@isTest
private class GeneratePublicURLTest {

    @isTest
    static void testGeneratePublicLinkTC() {
        // Create test data - ContentDocument, ContentVersion, and Project__c records
        List<ContentVersion> cvList = new List<ContentVersion>();
        Project__c testProject = new Project__c();
        testProject.Name = 'Test Project';
        testProject.Budgets__c = 'Under 75 lakhs';
        testProject.Configuration__c = '1 BHK';
        testProject.Project_Carpet_Area__c = '475 - 1 BHK';
        insert testProject;
        ContentVersion testContentVersion = new ContentVersion();
        testContentVersion.Title = 'Test Document';
        testContentVersion.Document_Type__c = 'Terms & Conditions';
        testContentVersion.SObjectType__c = 'Project__c';
        testContentVersion.PathOnClient = 'Test Path';
        testContentVersion.VersionData = Blob.valueof('Testdata');
        testContentVersion.FirstPublishLocationId = testProject.Id;
        insert testContentVersion;
        cvList.add(testContentVersion);

        testProject.Terms_Conditions__c = null; // Ensure the field is initially empty

        Test.startTest();
        GeneratePublicURL.generatePublicLink(testContentVersion.ContentDocumentId);
        Test.stopTest();

        testProject = [SELECT Id, Terms_Conditions__c FROM Project__c WHERE Id = :testProject.Id LIMIT 1];
        System.assertNotEquals(null, testProject.Terms_Conditions__c, 'Public URL should be generated and stored in Terms_Conditions__c field');
    }
    
    @isTest
    static void testGeneratePublicLinkAnnexure() {
        List<ContentVersion> cvList = new List<ContentVersion>();
        
        Property__c testProperty = new Property__c();
        testProperty.Name = '1234';
        insert testProperty;
        
        ContentVersion testContentVersion = new ContentVersion();
        testContentVersion.Title = 'Test Document';
        testContentVersion.Document_Type__c = 'Annexures';
        testContentVersion.SObjectType__c = 'Property__c';
        testContentVersion.PathOnClient = 'Test Path';
        testContentVersion.VersionData = Blob.valueof('Testdata');
        testContentVersion.FirstPublishLocationId = testProperty.Id;
        insert testContentVersion;
        cvList.add(testContentVersion);
        
        testProperty.Annexures__c = null;
        
        Test.startTest();
        GeneratePublicURL.generatePublicLink(testContentVersion.ContentDocumentId);
        Test.stopTest();
        
        testProperty = [Select Id, Annexures__c From Property__c Where Id = : testProperty.Id LIMIT 1];
        System.assertNotEquals(null, testProperty.Annexures__c, 'Public URL should be generated and stored in Annexures__c field');

    }
    
    
}