//This Class will execute in every 10 mins and will send email to customer on Shared Agreement Date of booking And
//will Update Close Draft Agreement Task Field To Now() + 24 hrs And After 24 Hrs will mark the Draft Agreement Task 
//As Completed
public class ScheduleToSendEmailSharedDateClass implements Schedulable{
    
    public Static void execute(SchedulableContext sc){
        system.debug('in Scheduler calss :');
        Date pastTwoDate = System.today().addDays(-3); 
        List<Booking__c> listOfBookings = [Select Id,Name,OwnerId,CreatedById,Agreement_Shared_Date__c,Primary_Applicant__c,Customer_Mobile_No__c,Primary_Applicant__r.Name From Booking__c Where Agreement_Shared_Date__c = Last_N_Days:3 ];
        system.debug('listOfBookings :'+listOfBookings);
        Set<Id> setOfAccountIds = new Set<Id>();
        for(Booking__c book : listOfBookings){
            system.debug('book :'+book.Agreement_Shared_Date__c);
            setOfAccountIds.add(book.Primary_Applicant__c);
        }
        system.debug('setOfAccountIds :'+setOfAccountIds);
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User Where IsActive =: True]);
        OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName = 'Divum' Limit 1];
        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Draft_Agreement_Task_Not_Completed' LIMIT 1];
        Map<Id,Account> mapIdToAccount = new Map<Id,Account>([Select id,Name,OwnerId From Account Where Id In : setOfAccountIds]);
        
        Date TodayDate = System.today();
        List<Booking__c> listOfBookingsToComplete = [Select Id,Name,OwnerId,CreatedById,Close_Draft_Agreement_Task__c,Agreement_Shared_Date__c,Primary_Applicant__c From Booking__c];
        System.debug('listOfBookingsToComplete'+listOfBookingsToComplete);
        List<Task> listOfDraftTasks = new List<Task>([Select Id,Status,WhatId From Task Where Subject =: 'Generate Draft Agreement']);
        Map<Id,Task> mapBookingIdToTask = new Map<Id,Task>();
        for(Task taskObj : listOfDraftTasks){
            mapBookingIdToTask.put(taskObj.whatId,taskObj);
        }
        
        
        TimeZone tz = UserInfo.getTimeZone();
        DateTime dt = Datetime.now(); 
        System.debug('tz'+tz);
        Integer offset=tz.getOffset(dt)/1000;
        System.debug('offset'+offset);
        Datetime currentDateTime=dt.addSeconds(offset);
        System.debug('currentDateTime'+currentDateTime);
        DateTime currentDateTime1= currentDateTime.addMinutes(-20);
        System.debug('currentDateTime1'+currentDateTime1);
        Id businessHourId = [SELECT Id FROM BusinessHours WHERE IsDefault = true].Id;
        System.debug('businessHourId'+businessHourId);        
        Integer hours = 48;
        
        
        if(listOfBookingsToComplete.size() > 0){
            System.debug('in List');
            List<Task> listOfTaskToUpdate = new List<Task>();
            for(Booking__c bookObj : listOfBookingsToComplete){
                if(bookObj.Close_Draft_Agreement_Task__c != null){
                    
                    Datetime CloseDraftAgreement = BusinessHours.add(businessHourId,bookObj.Close_Draft_Agreement_Task__c, 24 * 60 * 60 * 1000L);    
                    System.debug('CloseDraftAgreement : '+CloseDraftAgreement);
                    
                    Integer offset1=tz.getOffset(CloseDraftAgreement)/1000;
                    System.debug('offset1'+offset1);
                    
                    Datetime CloseDraftAgreement1=(CloseDraftAgreement).addSeconds(offset1);     
                    System.debug('CloseDraftAgreement1'+CloseDraftAgreement1);
                    
                    if(CloseDraftAgreement1 > currentDateTime1 && CloseDraftAgreement1 <= currentDateTime){
                        if(mapBookingIdToTask.size() > 0 && mapBookingIdToTask.containsKey(bookObj.Id)){
                            System.debug('bookObj');
                            Task DraftTask = mapBookingIdToTask.get(bookObj.Id);
                            DraftTask.Status = 'Completed';
                            listOfTaskToUpdate.add(DraftTask);
                        }
                    }
                }
            }
            if(!listOfTaskToUpdate.isEmpty()){
                update listOfTaskToUpdate;
            }
        }
        
        if(listOfBookings.size() > 0){
            system.debug('In listOfBookings :');
            List<Messaging.SingleEmailMessage> emailMsgList = New List<Messaging.SingleEmailMessage>();
            List<String> Addresses = new List<String>(); 
            
            List<Booking__c> listOfBookingToUPdate = new List<Booking__c>();
            for(Booking__c bookObj : listOfBookings){
                if(bookObj.Agreement_Shared_Date__c != null){
                    
                    Datetime AgreementShareDate = BusinessHours.add(businessHourId,bookObj.Agreement_Shared_Date__c, hours * 60 * 60 * 1000L);    
                    System.debug('AgreementShareDate : '+AgreementShareDate);
                    
                    Integer offset1=tz.getOffset(AgreementShareDate)/1000;
                    System.debug('offset1'+offset1);
                    
                    Datetime AgreementShareDate1=(AgreementShareDate).addSeconds(offset1);     
                    System.debug('AgreementShareDate1'+AgreementShareDate1);
                    
                    if(AgreementShareDate1 > currentDateTime1 && AgreementShareDate1 <= currentDateTime){
                        
                        system.debug('bookObj.Primary_Applicant__c :'+bookObj.Primary_Applicant__c);
                        if(bookObj.Primary_Applicant__c != null){
                            system.debug('In listOfBookings :');
                            if(mapIdToAccount.size() > 0 && mapIdToAccount.containsKey(bookObj.Primary_Applicant__c)){
                                Account accObj = mapIdToAccount.get(bookObj.Primary_Applicant__c);
                                if(mapIdToUser.size() > 0 && mapIdToUser.containsKey(accObj.OwnerId)){
                                    Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(String.Valueof(emailTemplate.Id),bookObj.CreatedById,bookObj.Id);
                                    Addresses.add(mapIdToUser.get(accObj.OwnerId).Email);  
                                    email.setOrgWideEmailAddressId(orgEmail.Id);
                                    email.toaddresses = Addresses;
                                    email.setSaveAsActivity(false);
                                    emailMsgList.add(email);
                                }
                            }
                        }   
                        
                        bookObj.Close_Draft_Agreement_Task__c = BusinessHours.add(businessHourId,System.now(), 24 * 60 * 60 * 1000L);
                        listOfBookingToUPdate.add(bookObj); 
                        
                        //For Send WhatsApp Message
                        communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp Not Received Respond on Draft A' Limit 1];
                        System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
                        if(regWhatEmailTemp!=null){
                            String recipientAddress=bookObj.Customer_Mobile_No__c;
                            String recipientId=bookObj.Primary_Applicant__c;
                            String emailTemplateId=String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
                            String relatedToId=bookObj.Id;
                            System.debug('emailTemplateId:'+emailTemplateId);
                            if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                                SendWhatsAppMessageUtility.SendMessage(recipientAddress, recipientId, emailTemplateId,relatedToId);
                            }
                        }
                        //for Send SMS
                        EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Not Received Respond on Draft Agreement' Limit 1];
                        if(smsEmailTemp!=null && bookObj.Customer_Mobile_No__c!=null){
                            String templateBody=smsEmailTemp.HtmlValue;
                            String mobileNumber=bookObj.Customer_Mobile_No__c;
                            templateBody = templateBody.replace('{{{Booking__c.Primary_Applicant_Name_Formulla__c}}}',bookObj.Primary_Applicant__r.Name);
                            templateBody = templateBody.replace('{{{Booking__c.Name}}}',bookObj.Name);
                            
                            templateBody=templateBody.stripHtmlTags();
                            System.debug('templateBody:'+templateBody);
                            SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
                        }
                    }
                } 
                if(emailMsgList.size() > 0){
                    System.debug('In  Sending');
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMsgList);
                    if(results[0].success){
                        system.debug('The email was sent successfully! '+emailMsgList);
                    }
                    else{
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                    }
                }   
                
            }
            if(!listOfBookingToUPdate.isEmpty()){
                update listOfBookingToUPdate;
            }
        }
    }
}