@isTest
public class DemandEmailReminderBatchSchedule_Test {
    public static testMethod void testschedule() {  
        Test.startTest();
        System.schedule('Demand Reminder Email','0 5 * * * ? *', new DemandEmailReminderBatchSchedule());
        Test.stopTest();
    }
}