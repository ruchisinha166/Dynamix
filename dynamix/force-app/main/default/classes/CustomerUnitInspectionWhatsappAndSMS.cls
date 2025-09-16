public class CustomerUnitInspectionWhatsappAndSMS {
    @InvocableMethod(callout=true label='Send Customer Unit Inspection Whatsapp And SMS')
    
    public static void CustomerUnitInspectionSVSMethod(List<requestWrapper> requestWrapperList) {
        //Send SMS
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'Customer Unit Inspection SMS' LIMIT 1];
        SMS_Template_Id__mdt smsTemplateId = [SELECT id, Salesforce_Template_Id__c, External_Template_Id__c, SMS_Template__c
                                              FROM SMS_Template_Id__mdt 
                                              WHERE MasterLabel = 'Customer Unit Inspection SMS'];
        
        system.debug('smsEmailTemp'+smsEmailTemp);
        if(smsEmailTemp!=null && requestWrapperList[0].primaryMobileNumber != null)
        {
            try{
                String templateBody=smsEmailTemp.HtmlValue;
                
                String mobileNumber=requestWrapperList[0].primaryMobileNumber;
                system.debug('requestWrapperList[0].projectName'+ requestWrapperList[0].projectName);
                String siteVisitTime = requestWrapperList[0].siteVisitTime.format('HH:mm:ss a'); 
                templateBody = templateBody.replace('{siteVisitDate}',string.valueof(requestWrapperList[0].siteVisitDate ));
                templateBody = templateBody.replace('{siteVisitTime}', siteVisitTime);
                templateBody = templateBody.replace('{customerName}', requestWrapperList[0].customerName);
                templateBody = templateBody.replace('{projectName}', requestWrapperList[0].projectName);
                templateBody = templateBody.replace('{meetingLocation}', requestWrapperList[0].meetingLocation);
                templateBody = templateBody.replace('{contactNumber}', requestWrapperList[0].contactNumber);
                templateBody=templateBody.stripHtmlTags();
                if(!Test.isRunningTest()){
                    SendSMSUtility.sendSMSMethod(templateBody,mobileNumber,'DYNAMX',smsTemplateId.External_Template_Id__c);
                }
                EmailMessage objEmailMessage = new EmailMessage();
                objEmailMessage.status = '3'; // email was sent
                objEmailMessage.RelatedToId = requestWrapperList[0].bookingId;
                objEmailMessage.fromName = 'Dynamix'; // from name
                objEmailMessage.Subject = 'SMS sent to customer for Unit Inspection';
                objEmailMessage.HtmlBody = templateBody;
                insertEmailMessageList.add(objEmailMessage);
                
                String recipientAddress = requestWrapperList[0].primaryMobileNumber;
                String recipientId = requestWrapperList[0].personAccountId;
                // String emailTemplateId = String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
                String relatedToId = requestWrapperList[0].bookingId;
                
                EmailMessage objWhatsappEmailMessage = new EmailMessage();
                objWhatsappEmailMessage.status = '3'; // email was sent
                objWhatsappEmailMessage.RelatedToId = requestWrapperList[0].bookingId;
                objWhatsappEmailMessage.fromName = 'Dynamix'; // from name
                objWhatsappEmailMessage.Subject = 'Whatsapp sent to customer for Unit Inspection';
                objWhatsappEmailMessage.HtmlBody = templateBody;
                insertEmailMessageList.add(objWhatsappEmailMessage);
                
            }
            catch(Exception ex)
            {
                system.debug('Error'+ex.getMessage()+' Line Number----' +ex.getLineNumber());
            }           
        }
         if(requestWrapperList[0].email != null && requestWrapperList[0].email != ''){
            try{
                EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name =: 'Customer Unit Inspection Scheduled' LIMIT 1];
                System.debug('emailTemplate:'+emailTemplate);
                String siteVisitTime = requestWrapperList[0].siteVisitTime.format('HH:mm:ss a'); 
                String htmlBody = emailTemplate.HtmlValue;
                String plainBody = emailTemplate.Body;
                String Subject = emailTemplate.Subject;
                Subject = Subject.replace('{unitNumber}',string.valueof(requestWrapperList[0].unitName ));

                htmlBody = htmlBody.replace('{siteVisitDate}',string.valueof(requestWrapperList[0].siteVisitDate ));
                htmlBody = htmlBody.replace('{siteVisitTime}', siteVisitTime);
                htmlBody = htmlBody.replace('{customerName}', requestWrapperList[0].customerName);
                htmlBody = htmlBody.replace('{projectName}', requestWrapperList[0].projectName);
                htmlBody = htmlBody.replace('{meetingLocation}', requestWrapperList[0].meetingLocation);
                htmlBody = htmlBody.replace('{contactNumber}', requestWrapperList[0].contactNumber);
                plainBody = plainBody.replace('{siteVisitDate}',string.valueof(requestWrapperList[0].siteVisitDate ));
                plainBody = plainBody.replace('{siteVisitTime}', siteVisitTime);
                plainBody = plainBody.replace('{customerName}', requestWrapperList[0].customerName);
                plainBody = plainBody.replace('{projectName}', requestWrapperList[0].projectName);
                plainBody = plainBody.replace('{meetingLocation}', requestWrapperList[0].meetingLocation);
                plainBody = plainBody.replace('{contactNumber}', requestWrapperList[0].contactNumber);
                if(emailTemplate!=null){    
                    List<String> emailList=new List<String>();           
                    emailList.add(requestWrapperList[0].email); 
                    if(!Test.isRunningTest()){
                        SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,Subject,htmlBody,plainBody,emailList,null,true,requestWrapperList[0].bookingId,null,null,requestWrapperList[0].organizationId);

                    }
                    EmailMessage objEmailMessage = new EmailMessage();
                    objEmailMessage.status = '3'; // email was sent
                    objEmailMessage.RelatedToId = requestWrapperList[0].bookingId;
                    objEmailMessage.fromName = 'Dynamix'; // from name
                    objEmailMessage.Subject = 'Email sent to customer for Unit Inspection';
                    objEmailMessage.HtmlBody = plainBody;
                    insertEmailMessageList.add(objEmailMessage);
                }
            }
            catch(Exception ex)
            {
                system.debug('Error----'+ex.getMessage() +' Line Number----' +ex.getLineNumber());
            }
        }
               
        if(!insertEmailMessageList.isEmpty())
        {
            insert insertEmailMessageList;
        }
        //if(!Test.isRunningTest()){
            CustomerUnitInspectionWhatsappQueueable queueableInstance = new CustomerUnitInspectionWhatsappQueueable(requestWrapperList);
            System.enqueueJob(queueableInstance);
        //}
    }
    
    
    public class requestWrapper{
        @InvocableVariable
        public String projectName; 
        
         @InvocableVariable
        public String unitName; 
        
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
        public String bookingId;
        
        @InvocableVariable
        public String personAccountId;
        
        @InvocableVariable
        public String customerName;
        
        @InvocableVariable
        public String contactNumber;
        
        @InvocableVariable
        public String organizationId;
    }    
}