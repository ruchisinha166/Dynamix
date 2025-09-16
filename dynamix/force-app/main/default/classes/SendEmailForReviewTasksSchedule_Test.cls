@isTest
public class SendEmailForReviewTasksSchedule_Test {
    public static testMethod void testschedule() {  
        Test.StartTest();
        SendEmailForReviewTasksSchedule.SchedulerMethodForRunInEvery10min();
        Test.stopTest(); 
    }
}