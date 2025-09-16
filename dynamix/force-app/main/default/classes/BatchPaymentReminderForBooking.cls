public class BatchPaymentReminderForBooking implements Database.Batchable<sObject> {
    
    String dateStr = Date.today().format();
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([select id,Project_Email__c,weekly_Reminder_Date__c,Project_Name__r.Project_Email__c,Total_Amount_Received__c,Agreement_Value__c,Primary_Applicant__r.PersonEmail,Primary_Applicant__r.PersonContactId,Stamp_Duty__c from Booking__c where (weekly_Reminder_Date__c =:Date.today() AND Indemnity_Form__c <> true AND SDR_Paid__c <> true AND  Disable_All_Reminders__c <> true AND Stamp_Duty__c!=0)]);
    }

    public void execute(Database.BatchableContext BC, List<booking__c> scope)
    {
        try
        {
            set<string> emailAddress = new set<string>();
            map<string,id> emailAddressAndIdMap = new map<string,id>();
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name =: 'After 10 Percentage payment SDR Template'];
            for(booking__c bk : scope){
                
                emailAddress.add(bk.Project_Name__r.Project_Email__c);
            }
            List<OrgWideEmailAddress> orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where Address IN: emailAddress];
            for(OrgWideEmailAddress org : orgEmail){
                emailAddressAndIdMap.put(org.Address,org.id);
            }
            List<Messaging.SingleEmailMessage> emailMsgList = New List<Messaging.SingleEmailMessage>();
            
            for(booking__c bk : scope)
            {
                    List<String> ToAddressList = new List<String>();
                    ToAddressList.add(bk.Primary_Applicant__r.PersonEmail);
                    Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(String.Valueof(emailTemplate.Id), bk.Primary_Applicant__r.PersonContactId, bk.id);
                    email.setOrgWideEmailAddressId(emailAddressAndIdMap.get(bk.Project_Email__c));
                    email.toAddresses = ToAddressList;
                    email.setSaveAsActivity(false);
                    emailMsgList.add(email);
                	bk.weekly_Reminder_Date__c = System.today().addDays(7);
            }
            if(scope.size() <> 0)
            {
                update scope;
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
            }catch(Exception e)
            {
                system.debug(e.getLineNumber() +'== msg '+ e.getMessage());
            }
        
    }
   
    public void finish(Database.BatchableContext BC){}
}