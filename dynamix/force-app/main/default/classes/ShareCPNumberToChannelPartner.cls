public class ShareCPNumberToChannelPartner {
    
    @InvocableMethod(callout=true label='Share CP Number To Channel Partner')
    public static void ShareCPNumberToChannelPartnerMethod(List<requestWrapper> requestWrapperList) {
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        OrgWideEmailAddress owea = new OrgWideEmailAddress();
        EmailTemplate emailTemplateforSMS = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS for New CP Registration' LIMIT 1];
        EmailTemplate emailTemplateforWhatsapp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'New_CP_Registration_Through_Website' LIMIT 1];
        communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,communicat_o__External_Template_Id__c From communicat_o__Registered_Template__mdt Where QualifiedApiName=: 'New_CP_Registration_Through_Website' Limit 1];
        owea = [SELECT Id, Address, DisplayName FROM 
                OrgWideEmailAddress WHERE DisplayName = 'Default'];
        //SMS
        List<string> arguments = New List<string>{requestWrapperList[0].CPUniqueNumber,'923678789'};
        String recipientAddress = requestWrapperList[0].cpPhoneNumber;
        String recipientId = requestWrapperList[0].cpId;
        String relatedToId = requestWrapperList[0].cpId;
        String htmlBody = emailTemplateforSMS.Body;
        system.debug('emailTemplateforSMS.HtmlValue'+emailTemplateforSMS.HtmlValue);
        String plainBodyforSMS = emailTemplateforSMS.HtmlValue;
        plainBodyforSMS = plainBodyforSMS.replace('{{cpUniqueId}}',requestWrapperList[0].CPUniqueNumber);
        plainBodyforSMS = plainBodyforSMS.replace('{{contactNumber}}', '923678789');
        if(!Test.isRunningTest()){
            SendSMSUtility.sendSMS(plainBodyforSMS,requestWrapperList[0].cpPhoneNumber,'DYNAMX');
        }
        
        if(recipientAddress!=null && recipientId!=null){
            EmailMessage objEmailMessage = new EmailMessage();
            objEmailMessage.status = '3'; 
            objEmailMessage.RelatedToId = requestWrapperList[0].cpId;
            objEmailMessage.fromName = 'Dynamix'; 
            objEmailMessage.Subject = 'SMS sent to CP for Registration';
            objEmailMessage.HtmlBody = plainBodyforSMS;
            insertEmailMessageList.add(objEmailMessage);
        }
        
        //WHATSAPP
        String emailTemplateId = String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
        System.debug('emailTemplateId:'+emailTemplateId);
        String htmlBodyforWhatsapp = emailTemplateforWhatsapp.HtmlValue;
        String plainBodyforWhatsapp = emailTemplateforWhatsapp.Body;
        plainBodyforWhatsapp = plainBodyforWhatsapp.replace('{cpUniqueId}',requestWrapperList[0].CPUniqueNumber);
        plainBodyforWhatsapp = plainBodyforWhatsapp.replace('{contactNumber}', '923678789');
        if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
            if(!Test.isRunningTest()){
            SendWhatsAppMessageUtility.SendWhatsappMessage(recipientAddress, recipientId,emailTemplateId, relatedToId ,regWhatEmailTemp.communicat_o__External_Template_Id__c ,arguments);
            }
            EmailMessage objEmailMessage = new EmailMessage();
            objEmailMessage.status = '3'; // email was sent
            objEmailMessage.RelatedToId = requestWrapperList[0].cpId;
            objEmailMessage.fromName = 'Dynamix'; // from name
            objEmailMessage.Subject = 'Whatsapp sent to CP for Registration';
            objEmailMessage.HtmlBody = plainBodyforWhatsapp;
            insertEmailMessageList.add(objEmailMessage);
        }
        if(emailTemplateforWhatsapp != null && requestWrapperList[0].cpEmail != null && requestWrapperList[0].cpEmail != ''){    
            List<String> emailList=new List<String>();           
            emailList.add(requestWrapperList[0].cpEmail);    
            
            EmailMessage objEmailMessage = new EmailMessage();
            objEmailMessage.status = '3'; // email was sent
            objEmailMessage.RelatedToId = requestWrapperList[0].cpId;
            objEmailMessage.fromName = 'Dynamix'; // from name
            objEmailMessage.Subject = 'Email sent to CP for Registration';
            objEmailMessage.HtmlBody = plainBodyforWhatsapp;
            insertEmailMessageList.add(objEmailMessage);
            SendEmailWithOrgWideAddress.SendEmail(emailTemplateforWhatsapp.Id, htmlBodyforWhatsapp, plainBodyforWhatsapp, emailList,null,owea.id);
        }
        if(!insertEmailMessageList.isEmpty())
        {
            insertAuditTrail(insertEmailMessageList); 
        }
    }
    
    public static void insertAuditTrail(List<EmailMessage> insertEmailMessageList)
    {
        if(!insertEmailMessageList.isEmpty())
        {
            insert insertEmailMessageList;
        }
    }
    
    public class requestWrapper{
        @InvocableVariable
        public String CPUniqueNumber; 
        
        @InvocableVariable
        public String cpId;
        
        @InvocableVariable
        public String cpPhoneNumber;
        
         @InvocableVariable
        public String cpEmail;
    }
}