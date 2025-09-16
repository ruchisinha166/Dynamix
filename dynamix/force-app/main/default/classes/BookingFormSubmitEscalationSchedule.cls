//This Schedule Class will Call BookingFormSubmitEscalationBatch (Batch class) & Excute it With Default Batch Size-200
global class BookingFormSubmitEscalationSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        BookingFormSubmitEscalationBatch batch1=new BookingFormSubmitEscalationBatch();
        Database.executeBatch(batch1);
    }
}