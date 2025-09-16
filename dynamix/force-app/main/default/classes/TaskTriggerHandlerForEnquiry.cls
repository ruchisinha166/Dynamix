public class TaskTriggerHandlerForEnquiry {
    Public Static Boolean preventRecursionOnTask = False;
    public static void missedFollowUptask(List<Task> taskList){
        
        Set<Id> enquiryId = new Set<Id>();
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id,Enquiry__c> mapOfEnquiry = new map<Id,Enquiry__c>();
        Map<Id,Contact> mapOfContact = new map<Id,Contact>();
        List<EmailMessage> insertEmailMessageList = new List<EmailMessage>(); 
        system.debug('taskList----'+taskList);
        
        for(Task taskRecord : taskList){
            if(taskRecord.WhatId != null)
            {
                String objectName = taskRecord.WhatId.getSObjectType().getDescribe().getName();
                if(taskRecord.Subject.contains('Missed Call')
                   && objectName == 'Enquiry__c'){
                       enquiryId.add(taskRecord.WhatId);
                   }
            }
            
        }
        system.debug('enquiryId----'+enquiryId);
        if(!enquiryId.isEmpty()){
            List<Enquiry__c> enquiryList = [SELECT id, name, OwnerId, Contact_Person__c, Primary_Mobile_Number__c
                                            FROM Enquiry__c 
                                            WHERE id IN: enquiryId];
            
            system.debug('enquiryList----'+enquiryList);
          
            for(Enquiry__c EnquiryRecord:enquiryList ){
                mapOfEnquiry.put(EnquiryRecord.id,EnquiryRecord);
                accountIdSet.add(EnquiryRecord.Contact_Person__c);
            }
            List<Contact> contactList =[SELECT Id, Name,AccountId From Contact Where AccountId IN: accountIdSet ];
            for(contact contactRecord:contactList ){
                mapOfContact.put(contactRecord.AccountId,contactRecord);
            }
            system.debug('mapOfEnquiry----'+mapOfEnquiry);
            CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
            Datetime  NextWorkingDays = calc.AddDays(System.now(),2);
            String NextWorkingDate = NextWorkingDays.format('yyyy-MM-dd');
           
            for(Task taskRecord : taskList){
                if(mapOfEnquiry.ContainsKey(taskRecord.WhatId)){
                    //Send SMS
                    EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS For a Missed Call form an Existing Enquiry' LIMIT 1];
                    if(smsEmailTemp!=null && mapOfEnquiry.get(taskRecord.WhatId).Primary_Mobile_Number__c != null){
                        String templateBody = smsEmailTemp.HtmlValue;
                        templateBody = templateBody.stripHtmlTags();
                        String mobileNumber = mapOfEnquiry.get(taskRecord.WhatId).Primary_Mobile_Number__c;
                        system.debug('Primary_Mobile_Number__c'+ mapOfEnquiry.get(taskRecord.WhatId).Primary_Mobile_Number__c);
                        if(!test.isRunningTest())
                        SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
                        EmailMessage objEmailMessage = new EmailMessage();
                        objEmailMessage.status = '3'; // email was sent
                        objEmailMessage.RelatedToId = taskRecord.WhatId;
                        objEmailMessage.fromName = 'Dynamix'; // from name
                        objEmailMessage.Subject = 'SMS Sent to Customer For Missed Call';
                        objEmailMessage.HtmlBody = templateBody;
                        insertEmailMessageList.add(objEmailMessage);
                    }
                    
                }
            }
            if(!insertEmailMessageList.isEmpty())
            {
                insert insertEmailMessageList;
            }
        }
    }
}