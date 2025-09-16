//This Schedule Class will Call CustomerComplaintCaseReminder (Batch class) & Excute it With Default Batch Size-200
global class CustomerComplaintCaseReminderSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        CustomerComplaintCaseReminder batch3=new CustomerComplaintCaseReminder();
        Database.executeBatch(batch3);
    }
}