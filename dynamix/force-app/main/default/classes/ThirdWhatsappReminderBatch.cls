public class ThirdWhatsappReminderBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,DataBase.Stateful {
    
    public ThirdWhatsappReminderBatch(){}
    communicat_o__Registered_Template__mdt regWhatEmailTemp;
    public Database.QueryLocator start(Database.BatchableContext BC){
        Date todayDate=Date.today();
        System.debug('todayDate:'+todayDate);
        //For Send WhatsApp Message
        regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp Booking Payment Reminder Final' Limit 1];
        System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
        return Database.getQueryLocator([SELECT Id,Name,booking__c,Milestone_Status__c,First_Payment_Email_Reminder_Date__c,forth_Payment_Email_Reminder_Date__c,Third_Payment_Email_Reminder_Date__c,Second_Payment_Email_Reminder_Date__c,Due_Date__c,Remaining_GST__c,Remaining_Amount__c  FROM Payment_Milestones__c where ((First_Payment_Email_Reminder_Date__c=:todayDate OR Third_Payment_Email_Reminder_Date__c=:todayDate OR forth_Payment_Email_Reminder_Date__c=:todayDate OR Second_Payment_Email_Reminder_Date__c=:todayDate) AND Remaining_Amount__c > 0 and Milestone_Status__c ='Active')]);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        Date todayDate1=Date.today();
        list<Payment_Milestones__c >pmList =  scope;
        system.debug('3rd WP Reminder execute '+scope);
        map<id,Payment_Milestones__c>  mapthird = new  map<id,Payment_Milestones__c>(); 
        for(Payment_Milestones__c p:pmList ) {
            if(p.Third_Payment_Email_Reminder_Date__c==todayDate1)
            {
                mapthird.put(p.booking__c,p);
                system.debug(' mapthird=='+ mapthird);
            }
        }
        if(!mapthird.isEmpty()) 
        {
            // SendSMSForReminder.sendWhatsappRem(mapthird,Label.Whatsap_Final_Reminder);
            Set<ID> bookingIds=mapthird.keyset();
            //for Send WhatsApp SMS
            if(bookingIds.size()>0 && regWhatEmailTemp!=null ){
                for(Id bookingRcdId : bookingIds){
                    Booking__c bookingRcd = [select Id, Name,Primary_Applicant__c,Primary_Applicant__r.PersonMobilePhone FROM Booking__c WHERE Id=: bookingRcdId];
                    System.debug('bookingRcd:'+bookingRcd);
                    if(bookingRcd.Primary_Applicant__r.PersonMobilePhone!=null){
                        String recipientAddress=bookingRcd.Primary_Applicant__r.PersonMobilePhone;
                        String recipientId=bookingRcd.Primary_Applicant__c;
                        String emailTemplateId=String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
                        String relatedToId=bookingRcd.Id;
                        System.debug('emailTemplateId:'+emailTemplateId);
                        if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                            SendPaymentReminderMessage.SendWhatsAppMessage(recipientAddress, recipientId, emailTemplateId,relatedToId);
                        }
                    }
                }
            }
        }
        
    }  
    public void finish(Database.BatchableContext BC){
        
        FouthWhatsappReminderBatch bcn = new FouthWhatsappReminderBatch() ;
        ID batchprocessid = Database.executeBatch(bcn,100);
    }
    
}