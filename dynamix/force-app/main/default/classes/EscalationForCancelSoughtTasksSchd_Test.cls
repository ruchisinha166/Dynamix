@isTest
public class EscalationForCancelSoughtTasksSchd_Test {
    public static testMethod void testschedule() {  
        Test.StartTest();
        EscalationForCancelSoughtTasksSchedule testSchedule1 = new EscalationForCancelSoughtTasksSchedule(); 
        String sch = '0 15 10 * * ? *'; //Fire at 10:15 AM every day       	
        system.schedule('Test EscalationForCancelSoughtTasksSchedule Job', sch, testSchedule1); 
        Test.stopTest(); 
    }
}