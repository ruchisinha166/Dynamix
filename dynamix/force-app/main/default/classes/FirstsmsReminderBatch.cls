public class FirstsmsReminderBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,DataBase.Stateful {
    
    public FirstsmsReminderBatch(){}
    EmailTemplate smsEmailTemp;
    public Database.QueryLocator start(Database.BatchableContext BC){
        Date todayDate=Date.today();
        System.debug('todayDate:'+todayDate);
        smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Payment Reminder' Limit 1];
        System.debug('smsEmailTemp:'+smsEmailTemp);
        return Database.getQueryLocator([SELECT Id,Name,booking__c,Milestone_Status__c,First_Payment_Email_Reminder_Date__c,Due_Date__c,Remaining_GST__c,Remaining_Amount__c  FROM Payment_Milestones__c where (First_Payment_Email_Reminder_Date__c=:todayDate AND Remaining_Amount__c > 0 and Milestone_Status__c ='Active')]);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        Date todayDate1=Date.today();
        list<Payment_Milestones__c >pmList =  scope;
        System.debug('1st SMS Reminder execute:'+pmList);
        map<id,id>  mapFirst = new  map<id,id>();  
        for(Payment_Milestones__c p:pmList ) {
            if(p.First_Payment_Email_Reminder_Date__c==todayDate1)
            {
                mapFirst.put(p.booking__c,p.id);
            }
        }
        if(!mapFirst.isEmpty()) 
        {
            // SendSMSForReminder.SendSMSReminder(mapFirst,Label.SMS_First_Reminder);
            Set<ID> bookingIds=mapFirst.keyset();
            //for Send SMS
            if(bookingIds.size()>0 && smsEmailTemp!=null ){
                for(Id bookingRcdId : bookingIds){
                    Booking__c bookingRcd = [select Id, Name,Primary_Applicant__c,Project_Name_Formulla__c,Primary_Applicant__r.PersonMobilePhone,Primary_Applicant_Name_Formulla__c FROM Booking__c WHERE Id=: bookingRcdId];
                    System.debug('bookingRcd:'+bookingRcd);
                    if(bookingRcd.Primary_Applicant__r.PersonMobilePhone!=null){
                        String templateBody=smsEmailTemp.HtmlValue;
                        String mobileNumber=bookingRcd.Primary_Applicant__r.PersonMobilePhone;
                        templateBody = templateBody.replace('{{{Booking__c.Primary_Applicant_Name_Formulla__c}}}',bookingRcd.Primary_Applicant_Name_Formulla__c);                       
                        templateBody=templateBody.stripHtmlTags();
                        System.debug('templateBody:'+templateBody);
                        SendPaymentReminderMessage.sendTextMessage(templateBody,mobileNumber,'DYNAMX');
                    }
                }
            } 
        }
    }  
    public void finish(Database.BatchableContext BC){
        SecondsmsReminderBatch bcn = new SecondsmsReminderBatch() ;
        ID batchprocessid = Database.executeBatch(bcn,100);
    }
    
}