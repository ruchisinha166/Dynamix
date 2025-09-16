@isTest
public class BatchForCustSDRPaymentRemiSche_Test {
    public static testMethod void testschedule() {  
        Test.StartTest();
        BatchForCustSDRPaymentRemiSchedule testSchedule1 = new BatchForCustSDRPaymentRemiSchedule(); 
        String sch = '0 15 10 * * ? *'; //Fire at 10:15 AM every day       	
        system.schedule('Test BatchForCustSDRPaymentRemiSchedule Job', sch, testSchedule1); 
        Test.stopTest(); 
    }
}