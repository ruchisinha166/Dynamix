//This Schedule Class will Call BatchToSendEmailForReviewTasks (Batch class) & Excute it With Default Batch Size-200
global class ScheduleBatchToSendEmailForReviewTask implements Schedulable {
    global void execute(SchedulableContext sc){
        BatchToSendEmailForReviewTasks batch1=new BatchToSendEmailForReviewTasks();
        Database.executeBatch(batch1);
    }
    Public static void SchedulerMethodForRunInEvery10min() {
        
        System.schedule('BookingForm KYC Escalation  1', '0 0 * * * ?', new ScheduleBatchToSendEmailForReviewTask());
        System.schedule('BookingForm KYC Escalation  2', '0 10 * * * ?', new ScheduleBatchToSendEmailForReviewTask());
        System.schedule('BookingForm KYC Escalation  3', '0 20 * * * ?', new ScheduleBatchToSendEmailForReviewTask());
        System.schedule('BookingForm KYC Escalation  4', '0 30 * * * ?', new ScheduleBatchToSendEmailForReviewTask());
        System.schedule('BookingForm KYC Escalation  5', '0 40 * * * ?', new ScheduleBatchToSendEmailForReviewTask());
        System.schedule('BookingForm KYC Escalation  6', '0 50 * * * ?', new ScheduleBatchToSendEmailForReviewTask());
    }
}