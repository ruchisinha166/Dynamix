//This Schedule Class will Call BookingFormSubmitReminderBatch (Batch class) & Excute it With Default Batch Size-200
global class BookingFormSubmitReminderSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        BookingFormSubmitReminderBatch batch1=new BookingFormSubmitReminderBatch();
        Database.executeBatch(batch1);
    }
}