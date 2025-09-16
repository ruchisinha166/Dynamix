global class DemandEmailReminderBatchSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        EmailReminderBatch batch1 = new EmailReminderBatch(); 
        database.executebatch(batch1,10);     
    }
}