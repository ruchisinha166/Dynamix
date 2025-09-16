@isTest
public class ScheduleBatchforEOICAOpportunityTest {
    
    @isTest
    static void testExecute() {
       ScheduleBatchforEOICAOpportunity schedulable = new ScheduleBatchforEOICAOpportunity();
        
        String jobId = System.schedule('Test ScheduleBatchforEOICAOpportunity', 
                                        '0 0 0 1 * ?', 
                                        schedulable);
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime 
                          FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals('0 0 0 1 * ?', ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.startTest();
        Database.executeBatch(new BatchforCancellationOfEOICA(), 200);
        Test.stopTest();
        
        /*AsyncApexJob aaj = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedById 
                            FROM AsyncApexJob WHERE Id = :jobId];
        System.assertEquals('Completed', aaj.Status);
        System.assertEquals(0, aaj.NumberOfErrors);
        System.assertEquals(200, aaj.TotalJobItems); // Assuming 200 records were processed*/
    }
}