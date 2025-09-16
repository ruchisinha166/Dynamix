@isTest
public class TestBatchforCancellationOfEOICA {
    @testSetup
    static void setupTestData() {
        // Create test Account
        Account testAccount = new Account(
            FirstName = 'Test',
            LastName = 'User',
            PersonEmail = 'testuser@example.com'
        );
        insert testAccount;
        
        // Create test Project
        Project__c testProject = new Project__c(
            Name = 'Test Project',
            Project_Email__c = 'project@example.com',
            Project_Phone__c = '1234567890',
            Launch_EOI_Period_s_End_Date__c = System.today().addDays(-7),
            Launch_CA_Period_s_End_Date__c = System.today().addDays(-7)
        );
        insert testProject;

        // Create test Opportunities
        Opportunity testOpportunityEOI = new Opportunity(
            Name = 'Test Opportunity EOI',
            AccountId = testAccount.Id,
            StageName = 'Prospecting',
            CloseDate = System.today(),
            EOI_CA__c = 'EOI',
            EOI_CA_Number__c = 'EOI123',
            Project__c = testProject.Id
        );
        
        Opportunity testOpportunityCA = new Opportunity(
            Name = 'Test Opportunity CA',
            AccountId = testAccount.Id,
            StageName = 'Prospecting',
            CloseDate = System.today(),
            EOI_CA__c = 'CA',
            EOI_CA_Number__c = 'CA123',
            Project__c = testProject.Id
        );
        
        insert testOpportunityEOI;
        insert testOpportunityCA;

        // Create OrgWideEmailAddress
        OrgWideEmailAddress orgWideEmail = new OrgWideEmailAddress(
            Address = 'project@example.com',
            DisplayName = 'Project',
            IsAllowAllProfiles = true
        );
       // insert orgWideEmail;

        // Create EmailTemplate
        EmailTemplate emailTemplate = new EmailTemplate(
            DeveloperName = 'EOI_CA_Automatically_Cancellation_Notification_To_Customer',
            Name = 'EOI/CA Auto Cancellation',
            Subject = 'Cancellation Notification for {projectName}',
            HtmlValue = '<p>Dear {customerName},</p><p>Your EOI/CA {EOI/CA} has been cancelled for project {projectName} (Number: {projectNumber}).</p>',
            Body = 'Dear {customerName}, Your EOI/CA {EOI/CA} has been cancelled for project {projectName} (Number: {projectNumber}).'
        );
        insert emailTemplate;

        // Create Suggested Property
        Suggested_Property__c suggestedProperty = new Suggested_Property__c(
            Opportunity__c = testOpportunityEOI.Id,
            Unit__c = 'TestUnit',
            Status__c = 'Not Short Listed'
        );
        insert suggestedProperty;

        // Create Property
        Property__c property = new Property__c(
            Id = 'TestUnit',
            Property_Status__c = 'Not Available'
        );
        insert property;
    }

    @isTest
    static void testBatchExecution() {
        Test.startTest();
        
        // Start batch
        BatchforCancellationOfEOICA batch = new BatchforCancellationOfEOICA();
        Id batchProcessId = Database.executeBatch(batch);
        
        Test.stopTest();

        // Verify Opportunity status and related fields
        Opportunity[] updatedOpportunities = [SELECT Id, StageName, Loss_Reason__c, Reason_for_lost__c, EOI_CA_stage__c FROM Opportunity WHERE StageName = 'Closed Lost'];
        System.assertEquals(2, updatedOpportunities.size(), 'Two Opportunities should be marked as Closed Lost');

        for (Opportunity opp : updatedOpportunities) {
            System.assertEquals('Auto cancelled due to business reason', opp.Loss_Reason__c);
            System.assertEquals('Auto cancelled due to business reason', opp.Reason_for_lost__c);
            System.assertEquals('Terminated', opp.EOI_CA_stage__c);
        }

        // Verify Property status
       // Property__c updatedProperty = [SELECT Id, Property_Status__c FROM Property__c WHERE Id = 'TestUnit'];
       // System.assertEquals('Available', updatedProperty.Property_Status__c, 'Property should be marked as Available');

        // Verify EmailMessage records
        EmailMessage[] sentEmailMessages = [SELECT Id, ToAddress, Subject FROM EmailMessage];
        System.assertEquals(2, sentEmailMessages.size(), 'Two email messages should be sent');

        // Verify Emails
     //   Messaging.SingleEmailMessage[] sentEmails = [SELECT Subject FROM Messaging.SingleEmailMessage];
       // System.assertEquals(2, sentEmails.size(), 'Two emails should be sent');
    }
}