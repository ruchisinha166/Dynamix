global class SendEmailForReviewTasksSchedule implements Schedulable {
    global void execute(SchedulableContext sc){
        BatchToSendEmailForReviewTasks batch1=new BatchToSendEmailForReviewTasks();
        Database.executeBatch(batch1);
    }
    global static void SchedulerMethodForRunInEvery10min() {
        system.schedule('Escalation For Review Tasks 1', '0 0 * * * ?', new SendEmailForReviewTasksSchedule());
        System.schedule('Escalation For Review Tasks 2', '0 10 * * * ?', new SendEmailForReviewTasksSchedule());
        System.schedule('Escalation For Review Tasks 3', '0 20 * * * ?', new SendEmailForReviewTasksSchedule());
        System.schedule('Escalation For Review Tasks 4', '0 30 * * * ?', new SendEmailForReviewTasksSchedule());
        System.schedule('Escalation For Review Tasks 5', '0 40 * * * ?', new SendEmailForReviewTasksSchedule());
        System.schedule('Escalation For Review Tasks 6', '0 50 * * * ?', new SendEmailForReviewTasksSchedule());
        
    } 
}