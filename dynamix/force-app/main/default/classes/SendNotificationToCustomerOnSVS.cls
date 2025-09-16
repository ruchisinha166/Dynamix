public class SendNotificationToCustomerOnSVS {
    @InvocableMethod(callout=true label='Send Notification To Customer On SVS')
    
    public static void SendNotificationToCustomerOnSVSMethod(List<requestWrapper> requestWrapperList) {
        //Send SMS
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        String templateName;
        Id recordId = id.valueof(requestWrapperList[0].enquiryId);
        String objectName = recordId.getSObjectType().getDescribe().getName();
        if( objectName =='Enquiry__c')
        {
           templateName= 'SMS When Site Visit Scheduled On Enquiry';
        }
        else if(objectName =='Opportunity')
        {
          templateName = 'SMS on site visit scheduled On Opportunity';
        }
        EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = :templateName LIMIT 1];
        system.debug('smsEmailTemp'+smsEmailTemp);
        if(smsEmailTemp!=null && requestWrapperList[0].primaryMobileNumber != null){
            try{
                String templateBody=smsEmailTemp.HtmlValue;
                templateBody=templateBody.stripHtmlTags();
                String mobileNumber=requestWrapperList[0].primaryMobileNumber;
                system.debug('requestWrapperList[0].projectName'+ requestWrapperList[0].projectName);
                String siteVisitTime = requestWrapperList[0].siteVisitTime.format('HH:mm:ss a'); 
                templateBody = templateBody.replace('{{Enquiry__c.Site_Visit_Scheduled_Date__c}}',string.valueof(requestWrapperList[0].siteVisitDate ));
                templateBody = templateBody.replace('{{Enquiry__c.Site_Visit_Scheduled_Time__c}}', siteVisitTime);
                templateBody = templateBody.replace('{{Enquiry__c.ProjectName__c}}', requestWrapperList[0].projectName);
                templateBody = templateBody.replace('{{MeetingLocation}}', requestWrapperList[0].meetingLocation);
                templateBody = templateBody.replace('{{contactNumber}}', requestWrapperList[0].contactNumber);
                if(!Test.isRunningTest()){
                    SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
                }
                EmailMessage objEmailMessage = new EmailMessage();
                objEmailMessage.status = '3'; // email was sent
                objEmailMessage.RelatedToId = requestWrapperList[0].enquiryId;
                objEmailMessage.fromName = 'Dynamix'; // from name
                objEmailMessage.Subject = 'SMS sent to customer for Site Visit Scheduled';
                objEmailMessage.HtmlBody = templateBody;
                insertEmailMessageList.add(objEmailMessage);
                
            }
            catch(Exception ex)
            {
                system.debug('Error'+ex.getMessage()+' Line Number----' +ex.getLineNumber());
            }           
        }
        
        //Send Email
        system.debug('requestWrapperList[0].email'+requestWrapperList[0].email);
        if(requestWrapperList[0].email != null && requestWrapperList[0].email != '' && objectName =='Enquiry__c'){
            try{
                EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'WhatsApp_When_Site_Visit_Scheduled_On_Enquiry' LIMIT 1];
                System.debug('emailTemplate:'+emailTemplate);
                String siteVisitTime = requestWrapperList[0].siteVisitTime.format('HH:mm:ss a'); 
                String htmlBody = emailTemplate.HtmlValue;
                String plainBody = emailTemplate.Body;
                plainBody = plainBody.replace('{{Enquiry__c.Site_Visit_Scheduled_Date__c}}',string.valueof(requestWrapperList[0].siteVisitDate ));
                plainBody = plainBody.replace('{{Enquiry__c.Site_Visit_Scheduled_Time__c}}', siteVisitTime);
                plainBody = plainBody.replace('{{Enquiry__c.ProjectName__c}}', requestWrapperList[0].projectName);
                plainBody = plainBody.replace('{{MeetingLocation}}', requestWrapperList[0].meetingLocation);
                plainBody = plainBody.replace('{{contactNumber}}', requestWrapperList[0].contactNumber);
                if(emailTemplate!=null){    
                    List<String> emailList=new List<String>();           
                    emailList.add(requestWrapperList[0].email); 
                    if(!Test.isRunningTest()){
                        SendEmailandBellNotificationUtility.SendEmail(emailTemplate.Id, htmlBody, plainBody, emailList,null);
                    }
                    EmailMessage objEmailMessage = new EmailMessage();
                    objEmailMessage.status = '3'; // email was sent
                    objEmailMessage.RelatedToId = requestWrapperList[0].enquiryId;
                    objEmailMessage.fromName = 'Dynamix'; // from name
                    objEmailMessage.Subject = 'Email sent to customer for Site Visit ScheduledEmail Sent For Site Visit Scheduled';
                    objEmailMessage.HtmlBody = plainBody;
                    insertEmailMessageList.add(objEmailMessage);
                }
            }
            catch(Exception ex)
            {
                system.debug('Error----'+ex.getMessage() +' Line Number----' +ex.getLineNumber());
            }
        }
        //Send Whatsapp
        String whatsappTemplateName;
        if( objectName =='Enquiry__c')
        {
           whatsappTemplateName= 'Whatsapp on When Site Visit Scheduled On Enquiry';
        }
        else if(objectName =='Opportunity')
        {
          whatsappTemplateName = 'Whatsapp on site visit scheduled On Opportunity';
        }
        EmailTemplate regWhatEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name =: whatsappTemplateName LIMIT 1];
        System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
        if(regWhatEmailTemp != null){
            try{
                System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
                String siteVisitTime = requestWrapperList[0].siteVisitTime.format('HH:mm a'); 
                String plainBody = regWhatEmailTemp.HtmlValue;
                plainBody = plainBody.stripHtmlTags();
                plainBody = plainBody.replace('{{{Enquiry__c.Site_Visit_Date__c}}}',string.valueof(requestWrapperList[0].siteVisitDate ));
                plainBody = plainBody.replace('{{{Enquiry__c.Site_Visit_Time__c}}}', siteVisitTime);
                plainBody = plainBody.replace('{{{Enquiry__c.ProjectName__c}}}', requestWrapperList[0].projectName);
                plainBody = plainBody.replace('{{{Enquiry__c.Project_Location__c}}}', requestWrapperList[0].meetingLocation);
                plainBody = plainBody.replace('{{contactNumber}}', requestWrapperList[0].contactNumber);
                
                List<string> arguments = New List<string>{string.valueof(requestWrapperList[0].siteVisitDate ),siteVisitTime,requestWrapperList[0].projectName,requestWrapperList[0].meetingLocation,requestWrapperList[0].contactNumber};
                String recipientAddress = requestWrapperList[0].primaryMobileNumber;
                String recipientId = requestWrapperList[0].personAccountId;
                String emailTemplateId = String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
                String relatedToId = requestWrapperList[0].enquiryId;
                System.debug('emailTemplateId:'+emailTemplateId);
                
                EmailMessage objEmailMessage = new EmailMessage();
                objEmailMessage.status = '3'; // email was sent
                objEmailMessage.RelatedToId = requestWrapperList[0].enquiryId;
                objEmailMessage.fromName = 'Dynamix'; // from name
                objEmailMessage.Subject = 'Whatsapp sent to customer for Site Visit Scheduled';
                objEmailMessage.HtmlBody = plainBody;
                insertEmailMessageList.add(objEmailMessage);
                
                
            }
            catch(Exception ex)
            {
                system.debug('Error---- '+ex.getMessage()+ ' Line Number---- '+ex.getLineNumber());
            }
        }
        if(!insertEmailMessageList.isEmpty())
        {
            insert insertEmailMessageList;
        }
        if(!Test.isRunningTest()){
            SendNotificationToCustomerOnSVSQueueable queueableInstance = new SendNotificationToCustomerOnSVSQueueable(requestWrapperList);
            System.enqueueJob(queueableInstance);
        }
    }
    public class requestWrapper{
        @InvocableVariable
        public String projectName;        
        @InvocableVariable
        public date siteVisitDate;
        
        @InvocableVariable
        public datetime siteVisitTime;
        
        @InvocableVariable
        public String primaryMobileNumber;
        
        @InvocableVariable
        public String meetingLocation;
        
        @InvocableVariable
        public String email;
        
        @InvocableVariable
        public String enquiryId;
        
        @InvocableVariable
        public String personAccountId;
        
        @InvocableVariable
        public String contactNumber;
    }    
}