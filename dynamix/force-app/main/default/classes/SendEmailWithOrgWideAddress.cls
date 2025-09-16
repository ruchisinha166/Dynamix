public class SendEmailWithOrgWideAddress {
    Public Static void SendEmail(String emailTempId,String htmlBody,String plainBody,List<String> toMailList,List<String> ccMailList, Id orgId){
        System.debug('Inside SendEmail:'+emailTempId);
        if(emailTempId!=null && toMailList!=null){  
            EmailTemplate emailTemplate = [select Id,Subject from EmailTemplate where Id=:emailTempId];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setToAddresses(toMailList);
            mail.setCcAddresses(ccMailList);
            mail.setOrgWideEmailAddressId(orgId);
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
}