//This Batch Class Will Execute for All the Booking records for which SDR letter is shared to customer but stamp duty payment is still not received
//This Batch class will send Email to Customer  : Batch Size (10)
//Email send functionality to Customer is called From Finish Method 
global class BatchForCustomerSDRPaymentReminder implements DataBase.Batchable<Sobject>{
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        Date past7Days = System.Today().addDays(-7);
        Date past14Days = System.Today().addDays(-14);
        Date past21Days = System.Today().addDays(-21);
        System.debug('past7Days:'+past7Days);
       // List<Booking__c> bookingList1=[select Id,Project_Email__c,Shared_SDR_Letter__c,SDR_Letter_Sent_Date__c,Project_Name__r.Project_Email__c,Primary_Applicant__r.PersonEmail,Primary_Applicant__r.PersonContactId,SDR_email_reminder_Count__c,Payment_Received_Stamp_Duty__c from Booking__c where (Shared_SDR_Letter__c =true AND (SDR_email_reminder_Count__c <=2 OR SDR_email_reminder_Count__c=null) AND Payment_Received_Stamp_Duty__c = 0  AND (SDR_Letter_Sent_Date__c=: past7Days OR SDR_Letter_Sent_Date__c=: past14Days OR SDR_Letter_Sent_Date__c=: past21Days))];
       // System.debug('bookingList1:'+bookingList1);
       // return Database.getQueryLocator([select Id,Project_Email__c,Shared_SDR_Letter__c,SDR_Letter_Sent_Date__c,Project_Name__r.Project_Email__c,Primary_Applicant__r.PersonEmail,Primary_Applicant__r.PersonContactId,SDR_email_reminder_Count__c,Payment_Received_Stamp_Duty__c from Booking__c where (Shared_SDR_Letter__c =true AND (SDR_email_reminder_Count__c <=2 OR SDR_email_reminder_Count__c=null) AND Payment_Received_Stamp_Duty__c = 0  AND (SDR_Letter_Sent_Date__c=: past7Days OR SDR_Letter_Sent_Date__c=: past14Days OR SDR_Letter_Sent_Date__c=: past21Days))]);
        return Database.getQueryLocator([select Id,Project_Email__c,Shared_SDR_Letter__c,SDR_Letter_Sent_Date__c,SDR_Paid__c,Project_Name__r.Project_Email__c,Primary_Applicant__r.PersonEmail,Primary_Applicant__r.PersonContactId,SDR_email_reminder_Count__c,Payment_Received_Stamp_Duty__c from Booking__c where (Shared_SDR_Letter__c =true AND (SDR_email_reminder_Count__c <=2 OR SDR_email_reminder_Count__c=null) AND SDR_Paid__c = false AND (SDR_Letter_Sent_Date__c=: past7Days OR SDR_Letter_Sent_Date__c=: past14Days OR SDR_Letter_Sent_Date__c=: past21Days))]);
    }
    
    public void execute(Database.BatchableContext BC, List<booking__c> bookingList)
    {
        System.debug('bookingList:==>'+bookingList);
        try
        {
            set<string> emailAddress = new set<string>();
            map<string,id> emailAddressAndIdMap = new map<string,id>();
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName =: 'Customer_SDR_Payment_Reminder'];
            for(booking__c bk : bookingList){               
                emailAddress.add(bk.Project_Name__r.Project_Email__c);
            }
            List<OrgWideEmailAddress> orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where Address IN: emailAddress];
            for(OrgWideEmailAddress org : orgEmail){
                emailAddressAndIdMap.put(org.Address,org.id);
            }
            List<Messaging.SingleEmailMessage> emailMsgList = New List<Messaging.SingleEmailMessage>();
            
            for(booking__c bk : bookingList)
            {
                List<String> ToAddressList = new List<String>();
                ToAddressList.add(bk.Primary_Applicant__r.PersonEmail);
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(String.Valueof(emailTemplate.Id), bk.Primary_Applicant__r.PersonContactId, bk.id);
                email.setOrgWideEmailAddressId(emailAddressAndIdMap.get(bk.Project_Email__c));
                email.toAddresses = ToAddressList;
                email.setSaveAsActivity(true);
                email.setWhatId(bk.Id);
                emailMsgList.add(email);
                
                bk.Last_SDR_reminder_letter_send_date__c = System.today();
                if(bk.SDR_email_reminder_Count__c==null){
                    bk.SDR_email_reminder_Count__c=0;
                }
                bk.SDR_email_reminder_Count__c++;
            }
            if(bookingList.size() <> 0)
            {
                update bookingList;
            }
            
            if (emailMsgList.size() > 0) 
            {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMsgList);
                if(results[0].success){
                    System.debug('SDR Payment Reminder mail to Customer has been sent successfully.');
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