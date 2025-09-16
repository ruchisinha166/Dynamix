@isTest
public class BookingFormKYCCompEscalSchedule_Test {
    public static testMethod void testschedule() {  
        Test.StartTest();
        BookingFormKYCCompleteEscalationSchedule.SchedulerMethodForRunInEvery10min();
        Test.stopTest(); 
    }
}