public class FirstWhatsappReminderbatch implements Database.Batchable<sObject>,Database.AllowsCallouts,DataBase.Stateful {
    
    public FirstWhatsappReminderbatch(){}
    communicat_o__Registered_Template__mdt regWhatEmailTemp;
    public Database.QueryLocator start(Database.BatchableContext BC){
        Date todayDate=Date.today();
        System.debug('todayDate:'+todayDate);
        //For Send WhatsApp Message
        regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp Payment Reminder' Limit 1];
        System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
        return Database.getQueryLocator([SELECT Id,Name,booking__c,Milestone_Status__c,First_Payment_Email_Reminder_Date__c,Due_Date__c,Remaining_GST__c,Remaining_Amount__c  FROM Payment_Milestones__c where (First_Payment_Email_Reminder_Date__c=:todayDate AND Remaining_Amount__c > 0 and Milestone_Status__c ='Active')]);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        Date todayDate1=Date.today();
        list<Payment_Milestones__c >pmList =  scope;
        system.debug('1st WP Reminder execute '+scope);
        map<id,Payment_Milestones__c>  mapFirst = new  map<id,Payment_Milestones__c>();  
        for(Payment_Milestones__c p:pmList ) {
            if(p.First_Payment_Email_Reminder_Date__c==todayDate1)
            {
                mapFirst.put(p.booking__c,p);
            }
        }
        if(!mapFirst.isEmpty()) 
        {
            system.debug('First Reminder map  '+mapFirst);
            // SendSMSForReminder.sendWhatsappRem(mapFirst,Label.Whatsapp_First_Reminder);
            Set<ID> bookingIds=mapFirst.keyset();
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
        secondWhatsappReminderBatch bcn = new secondWhatsappReminderBatch() ;
        ID batchprocessid = Database.executeBatch(bcn,100);
    }
    
}