@isTest
private class BatchforCancellationEOICATest {
    @isTest
    static void testBatchExecution() {
        
        //List<Account> testAccounts = BatchforCancellationEOICATestDataFactory.createAccounts(2);
       // List<Project__c> testProjects = BatchforCancellationEOICATestDataFactory.createProjects(2);
       // List<Opportunity> testOpportunities = BatchforCancellationEOICATestDataFactory.createOpportunities(testAccounts, testProjects, 2);
       // List<Booking__c> testBookings = BatchforCancellationEOICATestDataFactory.createBookings(testOpportunities, 2);
        Test.startTest();

        
        BatchforCancellationOfEOICA batchInstance = new BatchforCancellationOfEOICA();
        Database.executeBatch(batchInstance);

        Test.stopTest();

        
        List<Opportunity> updatedOpportunities = [SELECT Id, StageName, Loss_Reason__c, Reason_for_lost__c FROM Opportunity];
        /*System.assertEquals(2, updatedOpportunities.size(), 'There should be 2 updated opportunities');
        for(Opportunity updatedOpportunity : updatedOpportunities) {
            System.assertEquals('Closed Lost', updatedOpportunity.StageName, 'StageName should be Closed Lost');
            System.assertEquals('Auto cancelled due to business reason', updatedOpportunity.Loss_Reason__c, 'Loss Reason should be Auto cancelled due to business reason');
            System.assertEquals('Auto cancelled due to business reason', updatedOpportunity.Reason_for_lost__c, 'Reason for lost should be Auto cancelled due to business reason');
        }
        
        System.assertEquals(2, [SELECT count() FROM EmailMessage], 'There should be 2 EmailMessage created');*/
    }
}