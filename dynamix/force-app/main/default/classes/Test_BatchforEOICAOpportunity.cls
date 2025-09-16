@isTest
private class Test_BatchforEOICAOpportunity {
    @isTest
    static void testBatchExecution() {
        Project__c project1 = new Project__c(
            Name = 'Project 1',
            Launch_CA_Period_s_Start_Date__c = Date.today().addDays(-1),
            Launch_CA_Period_s_End_Date__c = Date.today(),
            Launch_EOI_Period_s_End_Date__c = Date.Today(),
            Launch_EOI_Period_s_Start_Date__c =  Date.Today(),
            Minimum_amount_for_EOI__c = 1000,
            Project_Email__c = 'test@gmail.com',
            Minimum_amount_for_CA__c = 1000.00
        );
        insert project1;

        Project__c project2 = new Project__c(
            Name = 'Project 2',
            Launch_EOI_Period_s_Start_Date__c = Date.today().addDays(-1),
            Launch_EOI_Period_s_End_Date__c = Date.today(),
            Minimum_amount_for_EOI__c = 2000.00
        );
        insert project2;

        Project__c project3 = new Project__c(
            Name = 'Project 3',
            Launch_CA_Period_s_Start_Date__c = Date.today().addDays(-2),
            Launch_CA_Period_s_End_Date__c = Date.today().addDays(-1),
            Minimum_amount_for_CA__c = 1000.00,
            Launch_EOI_Period_s_Start_Date__c = Date.today().addDays(-2),
            Launch_EOI_Period_s_End_Date__c = Date.today().addDays(-1),
            Minimum_amount_for_EOI__c = 2000.00
        );
        insert project3;        

        OrgWideEmailAddress testOWA = new OrgWideEmailAddress(
            DisplayName = 'Test OWA',
            Address = 'testowa@example.com'
        );

        Test.startTest();
        BatchforEOICAOpportunity batch = new BatchforEOICAOpportunity();
        Database.executeBatch(batch);
        Test.stopTest();

        List<EmailMessage> insertedEmailMessages = [SELECT Subject FROM EmailMessage WHERE RelatedToId IN :new Set<Id>{project1.Id, project2.Id}];
        System.assertEquals(2, insertedEmailMessages.size());

        List<EmailMessage> sentEmailMessages = [SELECT Subject FROM EmailMessage WHERE RelatedToId IN :new Set<Id>{project1.Id, project2.Id} AND Status = '3'];
        System.assertEquals(2, sentEmailMessages.size());
    }
}