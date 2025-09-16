//This Schedule Class will Call CustomerComplaintCase2ndEscalation (Batch class) & Excute it With Default Batch Size-200
global class CustomerComplntCase2ndEscalationSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        CustomerComplaintCase2ndEscalation batch5=new CustomerComplaintCase2ndEscalation();
        Database.executeBatch(batch5);
    }
}