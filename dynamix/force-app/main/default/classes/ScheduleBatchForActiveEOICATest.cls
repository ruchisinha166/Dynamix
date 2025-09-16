@isTest
public class ScheduleBatchForActiveEOICATest {
    
    @isTest
    static void testExecute() {
        ScheduleBatchForActiveEOICA schedulable = new ScheduleBatchForActiveEOICA();
        
        String jobId = System.schedule('Test ScheduleBatchForActiveEOICA', 
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