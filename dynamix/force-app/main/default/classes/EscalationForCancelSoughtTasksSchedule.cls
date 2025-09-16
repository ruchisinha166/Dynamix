//This Schedule Class will Call EscalationForCancellationSoughtTasks (Batch class) & Excute it With Default Batch Size-200
global class EscalationForCancelSoughtTasksSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        EscalationForCancellationSoughtTasks batch1=new EscalationForCancellationSoughtTasks();
        Database.executeBatch(batch1);
    }
}