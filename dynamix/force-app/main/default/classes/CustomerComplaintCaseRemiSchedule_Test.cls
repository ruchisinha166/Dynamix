@isTest
public class CustomerComplaintCaseRemiSchedule_Test {
    public static testMethod void testschedule() {  
        Test.StartTest();
        CustomerComplaintCaseReminderSchedule testSchedule1 = new CustomerComplaintCaseReminderSchedule(); 
        String sch = '0 15 10 * * ? *'; //Fire at 10:15 AM every day       	
        system.schedule('Test CustomerComplaintCaseReminderSchedule Job', sch, testSchedule1); 
        Test.stopTest(); 
    }
}