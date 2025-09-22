public class AllotmentLetterSent {
    @InvocableMethod(label='Allotment Letter Sent')
    public static void execute(List<Request> Requests){
        //for send Email to Booking Owner
        Booking__c bookingRcd = [select Id, Name,OwnerId,Owner.Email,Owner.Name,Project_Name__r.Name,Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.PersonMobilePhone,Primary_Applicant_Name_Formulla__c from Booking__c where id=: Requests[0].bookingId];
        
        String bookingLink=URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Id;
        String projectLink=URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Project_Name__c;
        
        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Allotment_Letter_Sent_Email' LIMIT 1];
        System.debug('emailTemplate:'+emailTemplate);
        String htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!Booking__c.Name}', '<a href="'+bookingLink+'">' + bookingRcd.Name +'</a>');
        htmlBody = htmlBody.replace('{!Booking__c.Owner.Name}', bookingRcd.Owner.Name);
        htmlBody = htmlBody.replace('{!projectName}', '<a href="'+projectLink+'">' + bookingRcd.Project_Name__r.Name +'</a>');
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!Booking__c.Name}', '<a href="'+bookingLink+'">' + bookingRcd.Name +'</a>'); 
        plainBody = plainBody.replace('{!Booking__c.Owner.Name}', bookingRcd.Owner.Name);
        plainBody = plainBody.replace('{!projectName}', '<a href="'+projectLink+'">' + bookingRcd.Project_Name__r.Name +'</a>');
        if(emailTemplate!=null){                
            List<String> emailList=new List<String>();           
            emailList.add(bookingRcd.Owner.Email);            
            SendEmailandBellNotificationUtility.SendEmail(emailTemplate.Id,htmlBody,plainBody,emailList,null);           
        }
        
        //For Send Bell Notification to Booking Owner
        // Get the Id for our custom notification type
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Notification_For_Allotment_Letter']; 
        if(notificationType!=null){
            String notificationTitle='Booking - Allotment Letter Sent';
            String notificationBody='Allotment Letter has been sent to Customer for Booking: '+ bookingRcd.Name;
            String targetId=bookingRcd.Id;
            Set <String> recipientIds= new Set <String> ();
            recipientIds.add(bookingRcd.OwnerId);
            SendEmailandBellNotificationUtility.SendBellNotification(notificationType.Id, notificationTitle, notificationBody, targetId, recipientIds);
        }       
        
        //For sent Email & Bell Notification to CRM Head
        String crmHeadUserName = Label.CRM_Head_User;
        System.debug('crmHeadUserName:'+crmHeadUserName);
        User crmHeadUser=[Select Id,Name,Email,UserName From User Where UserName=:crmHeadUserName Limit 1];
        System.debug('crmHeadUser:'+crmHeadUser);
        
        //for send Email to CRM Head User
        EmailTemplate emailTemplate1 = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Allotment_Letter_Sent_Email' LIMIT 1];
        System.debug('emailTemplate1:'+emailTemplate1);
        String htmlBody1 = emailTemplate1.HtmlValue;
        htmlBody1 = htmlBody1.replace('{!Booking__c.Name}', '<a href="'+bookingLink+'">' + bookingRcd.Name +'</a>');
        htmlBody1 = htmlBody1.replace('{!Booking__c.Owner.Name}', crmHeadUser.Name);
        htmlBody1 = htmlBody1.replace('{!projectName}', '<a href="'+projectLink+'">' + bookingRcd.Project_Name__r.Name +'</a>');
        String plainBody1 = emailTemplate.Body;
        plainBody1 = plainBody1.replace('{!Booking__c.Name}', '<a href="'+bookingLink+'">' + bookingRcd.Name +'</a>'); 
        plainBody1 = plainBody1.replace('{!Booking__c.Owner.Name}', crmHeadUser.Name);
        plainBody = plainBody.replace('{!projectName}', '<a href="'+projectLink+'">' + bookingRcd.Project_Name__r.Name +'</a>');
        if(emailTemplate1!=null){    
            List<String> emailList1=new List<String>();           
            emailList1.add(crmHeadUser.Email);              
            SendEmailandBellNotificationUtility.SendEmail(emailTemplate1.Id,htmlBody1,plainBody1,emailList1,null);
        }
        
        //For Send Bell Notification to CRM Head User
        // Get the Id for our custom notification type
        CustomNotificationType notificationType1 = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Notification_For_Allotment_Letter']; 
        if(notificationType!=null){
            String notificationTitle1='Booking - Allotment Letter Sent';
            String notificationBody1='Allotment Letter has been sent to Customer for Booking: '+ bookingRcd.Name;
            String targetId1=bookingRcd.Id;
            Set <String> recipientIds1= new Set <String> ();
            recipientIds1.add(crmHeadUser.Id);
            SendEmailandBellNotificationUtility.SendBellNotification(notificationType1.Id, notificationTitle1, notificationBody1, targetId1, recipientIds1);
        }
        
        //For Send WhatsApp Message
    
        communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName From communicat_o__Registered_Template__mdt Where QualifiedApiName=:'WhatsApp_Allotment_Letter_Sent' Limit 1];
        System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
        if(regWhatEmailTemp!=null){
            String recipientAddress=bookingRcd.Primary_Applicant__r.PersonMobilePhone;
            String recipientId=bookingRcd.Primary_Applicant__c;
            String emailTemplateId=String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
            String relatedToId=bookingRcd.Id;
            System.debug('emailTemplateId:'+emailTemplateId);
            if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                SendWhatsAppMessageUtility.SendMessage(recipientAddress, recipientId, emailTemplateId,relatedToId);
            }
        }
        //for Send SMS
        SMS_Template_Id__mdt smsTemplate = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='SMS Allotment Letter Sent' Limit 1];

        EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Allotment Letter Sent' Limit 1];
        if(smsEmailTemp!=null && bookingRcd.Primary_Applicant__r.PersonMobilePhone!=null && smsTemplate !=null){
            String templateBody=smsEmailTemp.HtmlValue;
            templateBody=templateBody.stripHtmlTags();
            String mobileNumber=bookingRcd.Primary_Applicant__r.PersonMobilePhone;
            templateBody = templateBody.replace('{{{Booking__c.Primary_Applicant_Name_Formulla__c}}}', bookingRcd.Primary_Applicant_Name_Formulla__c);
            templateBody = templateBody.replace('{{{Booking__c.Name}}}', bookingRcd.Name);
            templateBody = templateBody.replace('{{{Booking__c.Project_Name_Formulla__c}}}', bookingRcd.Project_Name__r.Name);
            //SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
            if(!test.isRunningTest())
            {
                SendSMSUtility.sendSMSMethod(templateBody,mobileNumber,'DYNAMX',smsTemplate.External_Template_Id__c);
            }
        }
    }
    public class Request {
        @InvocableVariable(label='Booking Id' required=true)
        public id bookingId;
    }
}