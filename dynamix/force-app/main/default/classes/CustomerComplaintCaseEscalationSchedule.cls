//This Schedule Class will Call CustomerComplaintCaseEscalation (Batch class) & Excute it With Default Batch Size-200
global class CustomerComplaintCaseEscalationSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        CustomerComplaintCaseEscalation batch4=new CustomerComplaintCaseEscalation();
        Database.executeBatch(batch4);
    }
}