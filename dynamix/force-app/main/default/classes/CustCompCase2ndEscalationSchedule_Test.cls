@isTest
public class CustCompCase2ndEscalationSchedule_Test {
    public static testMethod void testschedule() {  
        Test.StartTest();
        CustomerComplntCase2ndEscalationSchedule testSchedule1 = new CustomerComplntCase2ndEscalationSchedule(); 
        String sch = '0 15 10 * * ? *'; //Fire at 10:15 AM every day       	
        system.schedule('Test CustomerComplntCase2ndEscalationSchedule Job', sch, testSchedule1); 
        Test.stopTest(); 
    }
}