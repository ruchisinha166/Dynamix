public with sharing class SendEmailWhenRegistrationComplete{

    @InvocableMethod(label='Send Email When Registration Complete')
    public static void SendEmail(List<Booking__c> books){
        try{
            Booking__c bk = [select id,Primary_Applicant__c,Primary_Applicant__r.PersonEmail from Booking__c where id=: books[0].id];
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name =: 'Notification For  Registration Complete'];
            
            List<Co_Applicant__c> coAppList = new List<Co_Applicant__c>();
            
            if(bk.id != null)
            {
                coAppList = [select id,Account__c,Booking__c,Account__r.PersonEmail from Co_Applicant__c where Booking__c =: bk.id];
            }
            
            Set<ID> Accids = new Set<ID>();
            for(Co_Applicant__c coapp :coAppList)
            {
                Accids.add(coapp.Account__c);
            }           
            
            
            List<Contact> cclist = [select id,Email from Contact where AccountId = : Accids];
            OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress Limit 1];
           
           // List<Messaging.SingleEmailMessage> emailMsgList = New List<Messaging.SingleEmailMessage>();
            for(Contact cc : cclist)
            {
                List<String> ToAddressList = new List<String>();
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(String.Valueof(emailTemplate.Id), String.Valueof(cc.id), bk.Id);
                email.setTargetObjectId(cc.id);
                email.setOrgWideEmailAddressId(orgEmail.Id);
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {email};
                try{
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    if(results[0].success){
                        System.debug('The email was sent successfully.');
                    }
                    else {
                        System.debug('The email failed to send: ' +  results[0].errors[0].message);
                    }   
                }
                catch(Exception e){
                    system.debug(e);
                }

            }
            
           
         }Catch(Exception e)
         {
             system.debug(e);
         }
      
    }
      


}