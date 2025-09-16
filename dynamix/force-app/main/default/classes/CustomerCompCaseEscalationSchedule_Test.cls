@isTest
public class CustomerCompCaseEscalationSchedule_Test {
    public static testMethod void testschedule() {  
        Test.StartTest();
        CustomerComplaintCaseEscalationSchedule testSchedule1 = new CustomerComplaintCaseEscalationSchedule(); 
        String sch = '0 15 10 * * ? *'; //Fire at 10:15 AM every day       	
        system.schedule('Test CustomerComplaintCaseEscalationSchedule Job', sch, testSchedule1); 
        Test.stopTest(); 
    }
}