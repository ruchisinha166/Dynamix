@isTest
public class BatchForActiveEOICATest {
    
    @testSetup
    static void setupTestData() {
        Project__c projectEOIPastEndDate = new Project__c(
            Name = 'Project EOI Past End Date',
            Launch_EOI_Period_s_Start_Date__c = Date.today().addDays(-1),
            Launch_EOI_Period_s_End_Date__c = Date.today().addDays(2),
            Minimum_amount_for_EOI__c = 10000,
            EOI_CA_Floor__c = '1 - 5 Floor',
            EOI__c = true
        );
        insert projectEOIPastEndDate;
        
        Project__c projectCAPastEndDate = new Project__c(
            Name = 'Project CA Past End Date',
            Launch_CA_Period_s_Start_Date__c = Date.today().addDays(-1),
            Launch_CA_Period_s_End_Date__c = Date.today().addDays(2),
            Minimum_amount_for_CA__c = 12000,
            EOI_CA_Floor__c = '1 - 5 Floor',
            CA__c = true
        );
        insert projectCAPastEndDate;
        
        Project__c projectEOIStartDate = new Project__c(
            Name = 'Project EOI Start Date',
            Launch_EOI_Period_s_Start_Date__c = Date.today(),
            Launch_EOI_Period_s_End_Date__c = Date.today().addDays(2),
            Minimum_amount_for_EOI__c = 10000,
            EOI_CA_Floor__c = '1 - 5 Floor',
            EOI__c = false
        );
        insert projectEOIStartDate;
        
        Project__c projectCAStartDate = new Project__c(
            Name = 'Project CA Start Date',
            Launch_CA_Period_s_Start_Date__c = Date.today(),
            Launch_CA_Period_s_End_Date__c = Date.today().addDays(2),
            Minimum_amount_for_CA__c = 12000,
            EOI_CA_Floor__c = '1 - 5 Floor',
            CA__c = false
        );
        insert projectCAStartDate;
    }
    
    @isTest
    static void testBatchExecution() {
        Test.startTest();
        
        BatchForActiveEOICA batch = new BatchForActiveEOICA();
        Database.executeBatch(batch);
        
        Test.stopTest();
    }
}