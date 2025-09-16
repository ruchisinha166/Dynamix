global class scheduledWhatsappReminderBatch implements Schedulable {
    global void execute(SchedulableContext sc) {
        FirstWhatsappReminderbatch whatsappbatch = new FirstWhatsappReminderbatch(); 
        database.executebatch(whatsappbatch,100);
     }
}