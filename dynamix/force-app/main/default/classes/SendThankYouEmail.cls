public class SendThankYouEmail {
    
    @InvocableMethod(label='Send Thank You Mail')
    public static List<String> execute(List<Requests> requestLst){
         system.debug('===> Account Id ' + requestLst[0].accountId);
         system.debug('===> Person Email Id ' + requestLst[0].personEmailAddress);
         system.debug('===> Email Tem Id ' + requestLst[0].emailTemplateId);
         return new List<String> {SendEmail(requestLst[0].accountId ,requestLst[0].personEmailAddress,requestLst[0].emailTemplateId)};
    } 
    
    public static String SendEmail(string acId, string OwnerId, string tempId)
        {
            try{
                
                EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where Id =: tempId];
                OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress Limit 1];
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(tempId, OwnerId, acId);
              	email.setTargetObjectId(String.Valueof(OwnerId));
            	email.setOrgWideEmailAddressId(orgEmail.Id);
            	Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {email};
                try
                {
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    if(results[0].success)
                    {
                        System.debug('The email was sent successfully.');
                    }
                    else 
                    {
                        System.debug('The email failed to send: ' +  results[0].errors[0].message);
                    }   
            	}catch(Exception e)
                    {
                        system.debug(e);
                    }
                
                }Catch(Exception e)
                {
                    system.debug(e + e.getMessage()+e.getLineNumber());
                }
            
            return null;
        }
    
    public class Requests {
        @InvocableVariable(label='Account Id' required=true)
        public String accountId ;

        @InvocableVariable(label='Person Email Address' required=true)
        public String personEmailAddress;

        @InvocableVariable(label='Email Template Id' required=true)
        public String emailTemplateId;
    }

}