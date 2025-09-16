public class EmailReminderBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
 
   public EmailReminderBatch(){
   }
   
   public Database.QueryLocator start(Database.BatchableContext BC){
      list<Payment_Milestones__c >pmList =[SELECT Id,Name,booking__c,Milestone_Status__c,First_Payment_Email_Reminder_Date__c,
                                           forth_Payment_Email_Reminder_Date__c,Third_Payment_Email_Reminder_Date__c,
                                           Second_Payment_Email_Reminder_Date__c,Due_Date__c,Remaining_GST__c,
                                           Remaining_Amount__c  FROM Payment_Milestones__c 
                                           where ((First_Payment_Email_Reminder_Date__c=:Date.today() 
                                                   OR Third_Payment_Email_Reminder_Date__c=:Date.today() 
                                                   OR forth_Payment_Email_Reminder_Date__c=:Date.today() 
                                                   OR Second_Payment_Email_Reminder_Date__c=:Date.today()) 
                                                  AND Remaining_Amount__c > 0 and Milestone_Status__c ='Active')];
      system.debug('pmList=='+pmList );
      return Database.getQueryLocator([SELECT Id,Name,booking__c,Milestone_Status__c,First_Payment_Email_Reminder_Date__c,forth_Payment_Email_Reminder_Date__c,Third_Payment_Email_Reminder_Date__c,Second_Payment_Email_Reminder_Date__c,Due_Date__c,Remaining_GST__c,Remaining_Amount__c  FROM Payment_Milestones__c where ((First_Payment_Email_Reminder_Date__c=:Date.today() OR Third_Payment_Email_Reminder_Date__c=:Date.today() OR forth_Payment_Email_Reminder_Date__c=:Date.today() OR Second_Payment_Email_Reminder_Date__c=:Date.today()) AND Remaining_Amount__c > 0 and Milestone_Status__c ='Active')]);
   }
 
   public void execute(Database.BatchableContext BC, List<sObject> scope)
   {
      system.debug('scope=='+scope); 
      list<Payment_Milestones__c >pmList =  scope;
      map<id,id>  mapFirst = new  map<id,id>(); 
      map<id,id> mapSecond = new  map<id,id>(); 
      map<id,id>  mapthird = new  map<id,id>(); 
      map<id,id>  mapforth = new  map<id,id>(); 
      for(Payment_Milestones__c p:pmList ) {
          if(p.First_Payment_Email_Reminder_Date__c==Date.today())
          {
              mapFirst.put(p.booking__c,p.id);
          }
          else if(p.Second_Payment_Email_Reminder_Date__c==Date.today())
          {
              mapSecond.put(p.booking__c,p.id);
          }
          else if(p.Third_Payment_Email_Reminder_Date__c==Date.today())
          {
              mapthird.put(p.booking__c,p.id);
              system.debug(' mapthird=='+ mapthird);
          }
          else if(p.forth_Payment_Email_Reminder_Date__c==Date.today())
          {
              mapforth.put(p.booking__c,p.id);
          }
      }
      if(!mapFirst.isEmpty()) 
      {
           system.debug('mapFirst=='+mapFirst);
           SendEmailClass.SendEmailReminder(mapFirst, Label.First_Payment_Reminder_Notification);
      }
      if(!mapSecond.isEmpty()) 
      {
           system.debug('mapSecond=='+mapSecond);
           SendEmailClass.SendEmailReminder(mapSecond,Label.Second_Payment_Reminder_Notification);
      }
      if(!mapthird.isEmpty()) 
      {
          system.debug('mapthird=='+mapthird);
          SendEmailClass.SendEmailReminder(mapthird,Label.Final_Reminder);
      }
      if(!mapforth.isEmpty()) 
      {
           system.debug('mapforth=='+mapforth);
           SendEmailClass.SendEmailReminder(mapforth,Label.Termination_Note);
      }
      
   }  
   public void finish(Database.BatchableContext BC){
       system.debug('call finish method');
     //  SMSOnEmailReminderBatch.sendSMS();
   }
 
}