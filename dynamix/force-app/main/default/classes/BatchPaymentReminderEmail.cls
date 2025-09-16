public class BatchPaymentReminderEmail implements Database.Batchable<sObject>{
 
  
   Set<Id> milestoneIds = new Set<Id>();
   public BatchPaymentReminderEmail(){
   }
   
   public Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator([SELECT Id,Name,Project_Progress__c,Booking__c,Booking__r.Disable_All_Reminders__c,Booking__r.Primary_Applicant__r.PersonEmail,Booking__r.Primary_Applicant__r.PersonContactId FROM Payment_Milestones__c where (Invoice_Email_Sent__c =: 0 AND Remaining_Amount__c <> 0)]);
   }
 
   public void execute(Database.BatchableContext BC, List<Payment_Milestones__c> scope)
   {
        
         try{
             EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name =: 'Payment Reminder Email Template'];
             OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress Limit 1];
             List<Messaging.SingleEmailMessage> emailMsgList = New List<Messaging.SingleEmailMessage>();
             for(Payment_Milestones__c pm : scope)
             {
                 //Payment_Milestones__c p = (Payment_Milestones__c) s;
                // milestoneIds.add(p.id);
                if(pm.Booking__r.Disable_All_Reminders__c == false)
                {
                    List<String> ToAddressList = new List<String>();
                    ToAddressList.add(pm.Booking__r.Primary_Applicant__r.PersonEmail);
                    Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(String.Valueof(emailTemplate.Id), pm.Booking__r.Primary_Applicant__r.PersonContactId, pm.id);
                    email.setOrgWideEmailAddressId(orgEmail.Id);
                    email.toAddresses = ToAddressList;
                    email.setSaveAsActivity(false);
                    emailMsgList.add(email);
                }
            }
             if (emailMsgList.size() > 0) 
                {
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMsgList);
                    if(results[0].success){
                        System.debug('The email was sent successfully.');
                    }
                    else {
                        System.debug('The email failed to send: ' +  results[0].errors[0].message);
                    } 
                }
          }Catch(Exception e)
          {
              system.debug(e);
          }
      }
 
   public void finish(Database.BatchableContext BC){}
}