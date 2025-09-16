@isTest
public class BookingFormKYCCompleteReminderSch_Test {
    @isTest
    public static void Method(){
        
        Test.startTest();
        System.schedule('jobName','0 5 * * * ? *', new BookingFormKYCCompleteReminderSchedule());
        BookingFormKYCCompleteReminderSchedule.SchedulerMethodForRunInEvery10min();
        Test.stopTest();
        
    }
}