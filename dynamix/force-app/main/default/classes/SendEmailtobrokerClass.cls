public class SendEmailtobrokerClass {

   
     @InvocableMethod(label='Send Email to broker')
     public static List<String> execute(List<Requests> requestLst){
         //system.debug('===> book Id ' + requestLst[0].bookingId);
         system.debug('===> Person Acc Id ' + requestLst[0].personAccountId);
         system.debug('===> Email Tem Id ' + requestLst[0].emailTemplateId);
         system.debug('===> Milestone Id ' + requestLst[0].MilestoneId);
         
         return new List<String> {SendEmail(requestLst[0].personAccountId,requestLst[0].emailTemplateId,requestLst[0].MilestoneId)};
    } 
    
     public static String SendEmail(String aId,String eId,String pId){
         try{
             
            list<project__c> pr = [select Project_Email__c from project__c where id =: pId];
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where Id =: eId];
            
            OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where Address =: pr[0].Project_Email__c];
            list<Contact> conList = [select id,FirstName,LastName,email,AccountID from contact where AccountID =:aId ];
            system.debug('conList '+conList );
            if(conList.size()>0  && conList[0].email!='')
            {
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(String.Valueof(eId), String.Valueof(conList[0].Id), pId);
                email.setTargetObjectId(String.Valueof(conList[0].Id));
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
                    catch(Exception e)
                    {
                        system.debug(e);
                    }
           }  
           }Catch(Exception e)
           {
               system.debug('==> e'  + e.getMessage()+e.getLineNumber());
           }
            return null;
     }
     public static String SendEmail(String aId,String eId,String pId,String payId){
         try{
             
            list<project__c> pr = [select Project_Email__c from project__c where id =: pId];
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where Id =: eId];
            
            OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where Address =: pr[0].Project_Email__c];
            list<Contact> conList = [select id,FirstName,LastName,email,AccountID from contact where AccountID =:aId ];
            system.debug('conList '+conList );
            if(conList.size()>0  && conList[0].email!='')
            {
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(String.Valueof(eId), String.Valueof(conList[0].Id), payId);
                email.setTargetObjectId(String.Valueof(conList[0].Id));
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
                    catch(Exception e)
                    {
                        system.debug(e);
                    }
           }  
           }Catch(Exception e)
           {
               system.debug('==> e'  + e.getMessage()+e.getLineNumber());
           }
            return null;
     }
     public class Requests {
          /*
        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId ;
        */
        @InvocableVariable(label='Account Id' required=true)
        public String personAccountId;

        @InvocableVariable(label='Email Template Id' required=true)
        public String emailTemplateId;
        
         @InvocableVariable(label='project Id' required=true)
        public String MilestoneId;
    }
 }