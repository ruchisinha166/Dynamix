public With Sharing class SendEmailandBellNotificationUtility {
    Public Static void SendEmail(String emailTempId,String htmlBody,String plainBody,List<String> toMailList,List<String> ccMailList){
        System.debug('Inside SendEmail:'+emailTempId);
        if(emailTempId!=null && toMailList!=null){  
            EmailTemplate emailTemplate = [select Id,Subject from EmailTemplate where Id=:emailTempId];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setToAddresses(toMailList);
            mail.setCcAddresses(ccMailList);
            mail.setSubject(emailTemplate.Subject);
            mail.setHtmlBody(htmlBody);
            mail.setPlainTextBody(plainBody);
            mail.setSaveAsActivity(false);
            System.debug('Inside SendEmail mail:'+mail);
            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                System.debug('Mail Sent:'+mail);
            }
            catch (Exception e) {
                System.debug('Problem sending Email: '+ e.getMessage());
            }
        }
    }
    Public Static void SendBellNotification(String notificationTypeId,String title,String body,String targetId,Set<String> recipientIds){
        Messaging.CustomNotification notification = new Messaging.CustomNotification();                 
        notification.setTitle(title);                  
        notification.setBody(body);
        notification.setNotificationTypeId(notificationTypeId);
        notification.setTargetId(targetId);
        try {
            notification.send(recipientIds);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }      
    }
     //updated method

    Public Static void SendEmail2(String emailTempId,String subject,String htmlBody,String plainBody,List<String> toMailList,List<String> ccMailList,Boolean isSaveAsActivity,String targetRecordId,Blob blobValue,String attachmentFileName,String fromMailAddress,String contentVersionId){
        System.debug('Inside SendEmail2:'+emailTempId);
        if(emailTempId!=null && toMailList!=null){  
            EmailTemplate emailTemplate = [select Id,Subject from EmailTemplate where Id=:emailTempId];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setToAddresses(toMailList);
            mail.setCcAddresses(ccMailList);
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            mail.setPlainTextBody(plainBody);
            mail.setSaveAsActivity(isSaveAsActivity);
            if(contentVersionId != null){
                mail.setEntityAttachments(new List<String>{contentVersionId});
            }
            if(targetRecordId!=''){
                mail.setWhatId(targetRecordId);
            }
            if( fromMailAddress !=   '' ) 
            {
                mail.setOrgWideEmailAddressId(fromMailAddress);
            }
            
            /*if( blobValue !=null ) 
            {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                if(attachmentFileName==''){
                    efa.setFileName('Attachment.pdf');
                }
                else{
                    efa.setFileName(attachmentFileName);
                }
                efa.setBody(blobValue);
                efa.setContentType('application/pdf');
                
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            }*/
            System.debug('Inside SendEmail mail:'+mail);
            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                System.debug('Mail Sent:'+mail);
                /*EmailMessage emailMsg = new EmailMessage();
                emailMsg.status = '3'; // email was sent
                emailMsg.RelatedToId = targetRecordId;
                emailMsg.fromName = 'Dynamix'; // from name
                emailMsg.Subject = emailTemplate.Subject;
                emailMsg.HtmlBody = htmlBody;
                insert emailMsg;*/
            }
            catch (Exception e) {
                System.debug('Problem sending Email: '+ e.getMessage());
            }
        }
    }
     Public Static void SendEmail3(String emailTempId,String Subject,String htmlBody,String plainBody,List<String> toMailList,List<String> ccMailList,Boolean isSaveAsActivity,String targetRecordId,Blob blobValue,String attachmentFileName,String fromMailAddress){
        System.debug('Inside SendEmail2:'+emailTempId);
        if(emailTempId!=null && toMailList!=null){  
            EmailTemplate emailTemplate = [select Id,Subject from EmailTemplate where Id=:emailTempId];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setToAddresses(toMailList);
            mail.setCcAddresses(ccMailList);
            mail.setSubject(Subject);
            mail.setHtmlBody(htmlBody);
            mail.setPlainTextBody(plainBody);
            mail.setSaveAsActivity(isSaveAsActivity);
            if(targetRecordId!=''){
                mail.setWhatId(targetRecordId);
            }
            if(	fromMailAddress !=	 '' ) 
            {
                mail.setOrgWideEmailAddressId(fromMailAddress);
            }
            
            if(	blobValue !=null ) 
            {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                if(attachmentFileName==''){
                    efa.setFileName('Attachment.pdf');
                }
                else{
                    efa.setFileName(attachmentFileName);
                }
                efa.setBody(blobValue);  
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            }
            System.debug('Inside SendEmail mail:'+mail);
            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                System.debug('Mail Sent:'+mail);
            }
            catch (Exception e) {
                System.debug('Problem sending Email: '+ e.getMessage());
            }
        }
    }
    
    Public Static void SendEmail4(String emailTempId,String htmlBody,String plainBody,List<String> toMailList,List<String> ccMailList,Boolean isSaveAsActivity,String targetRecordId,Blob blobValue,String attachmentFileName,String fromMailAddress,String filetype, String fileTypeAnnexure,String AttcacmentNameAnnexure, Blob DataAnnexure){
        System.debug('Inside SendEmail2:'+emailTempId);
        if(emailTempId!=null && toMailList!=null){  
            EmailTemplate emailTemplate = [select Id,Subject from EmailTemplate where Id=:emailTempId];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setToAddresses(toMailList);
            mail.setCcAddresses(ccMailList);
            mail.setSubject(emailTemplate.Subject);
            mail.setHtmlBody(htmlBody);
            mail.setPlainTextBody(plainBody);
            mail.setSaveAsActivity(isSaveAsActivity);
            if(targetRecordId!=''){
                mail.setWhatId(targetRecordId);
            }
            if(	fromMailAddress !=	 '' ) 
            {
                mail.setOrgWideEmailAddressId(fromMailAddress);
            }
            
            if(	blobValue !=null || DataAnnexure !=null ) 
            {
                List<Messaging.EmailFileAttachment> lstFileAttechments = new List<Messaging.EmailFileAttachment>();
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
                if(attachmentFileName == '' || AttcacmentNameAnnexure=='' ){
                    efa.setFileName('Attachment.pdf');
                    efa1.setFileName('Attachment.pdf');
                }
                else{
                    efa.setFileName(attachmentFileName+'.'+filetype);
                    efa1.setFileName(AttcacmentNameAnnexure+'.'+fileTypeAnnexure);
                }
                efa.setBody(blobValue); 
                efa1.setBody(DataAnnexure);
                lstFileAttechments.add(efa);
                lstFileAttechments.add(efa1);
                mail.setFileAttachments(lstFileAttechments);
            }
           
            System.debug('Inside SendEmail mail:'+mail);
            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                System.debug('Mail Sent:'+mail);
            }
            catch (Exception e) {
                System.debug('Problem sending Email: '+ e.getMessage());
            }
        }
    }

}