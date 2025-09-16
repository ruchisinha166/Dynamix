public class forthsmsReminderBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,DataBase.Stateful {
    
    public forthsmsReminderBatch(){}
    EmailTemplate smsEmailTemp;
    public Database.QueryLocator start(Database.BatchableContext BC){
        Date todayDate=Date.today();
        System.debug('todayDate:'+todayDate);
        smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Booking Termination' Limit 1];
        System.debug('smsEmailTemp:'+smsEmailTemp);
        return Database.getQueryLocator([SELECT Id,Name,booking__c,Milestone_Status__c,First_Payment_Email_Reminder_Date__c,forth_Payment_Email_Reminder_Date__c,Third_Payment_Email_Reminder_Date__c,Second_Payment_Email_Reminder_Date__c,Due_Date__c,Remaining_GST__c,Remaining_Amount__c  FROM Payment_Milestones__c where ((First_Payment_Email_Reminder_Date__c=:todayDate OR Third_Payment_Email_Reminder_Date__c=:todayDate OR forth_Payment_Email_Reminder_Date__c=:todayDate OR Second_Payment_Email_Reminder_Date__c=:todayDate) AND Remaining_Amount__c > 0 and Milestone_Status__c ='Active' )]);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        Date todayDate1=Date.today();
        list<Payment_Milestones__c >pmList =  scope;
        System.debug('4th SMS Reminder execute:'+pmList);
        map<id,id>  mapforth = new  map<id,id>(); 
        for(Payment_Milestones__c p:pmList ) {
            if(p.forth_Payment_Email_Reminder_Date__c==todayDate1)
            {
                mapforth.put(p.booking__c,p.id);
            }
        }
        if(!mapforth.isEmpty()) 
        {
            // SendSMSForReminder.SendSMSReminder(mapforth,Label.SMS_Termination_Letter);
            Set<ID> bookingIds=mapforth.keyset();
            //for Send SMS
            if(bookingIds.size()>0 && smsEmailTemp!=null ){
                for(Id bookingRcdId : bookingIds){
                    Booking__c bookingRcd = [select Id, Name,Primary_Applicant__c,Primary_Applicant__r.PersonMobilePhone,Primary_Applicant_Name_Formulla__c,Booking_Owner_Email__c FROM Booking__c WHERE Id=: bookingRcdId];
                    System.debug('bookingRcd:'+bookingRcd);
                    if(bookingRcd.Primary_Applicant__r.PersonMobilePhone!=null){
                        String templateBody=smsEmailTemp.HtmlValue;
                        String mobileNumber=bookingRcd.Primary_Applicant__r.PersonMobilePhone;
                        templateBody = templateBody.replace('{{{Booking__c.Primary_Applicant_Name_Formulla__c}}}',bookingRcd.Primary_Applicant_Name_Formulla__c);    
                        templateBody = templateBody.replace('{{{Booking__c.Name}}}',bookingRcd.Name);   
                        templateBody=templateBody.stripHtmlTags();
                        System.debug('templateBody:'+templateBody);
                        SendPaymentReminderMessage.sendTextMessage(templateBody,mobileNumber,'DYNAMX');
                    }
                }
            }
        }
    }  
    public void finish(Database.BatchableContext BC){}
    
}