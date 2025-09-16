@isTest
public class ScheduleBatchforEOIWithoutBookingTest {
    
    @isTest
    static void testExecute() {
        ScheduleBatchforEOIWithoutBooking schedulable = new ScheduleBatchforEOIWithoutBooking();
        
        String jobId = System.schedule('Test ScheduleBatchforEOIWithoutBooking', 
                                        '0 0 0 1 * ?', 
                                        schedulable);
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime 
                          FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals('0 0 0 1 * ?', ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.startTest();
        Database.executeBatch(new BatchforCancellationOfEOICA(), 200);
        Test.stopTest();
    }
}