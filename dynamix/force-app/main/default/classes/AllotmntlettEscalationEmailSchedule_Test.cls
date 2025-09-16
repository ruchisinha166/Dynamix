@isTest
public class AllotmntlettEscalationEmailSchedule_Test {
    public static testMethod void testschedule() {  
        Test.StartTest();
        AllotmentletterEscalationEmailSchedule.SchedulerMethodForRunInEvery10min();
        Test.stopTest(); 
    }
    
}