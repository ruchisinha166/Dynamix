global class scheduledEmailReminderBatch implements Schedulable {
   global void execute(SchedulableContext sc) {
      FirstsmsReminderBatch batch = new FirstsmsReminderBatch(); 
      database.executebatch(batch,100);
      
   }
}