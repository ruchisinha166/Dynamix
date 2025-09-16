@isTest
public class CallOutCustomerCreationTest {
    @isTest
    static void testCalledFromTransactionFlow() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Sales Manager'];
        User testUser = new User(
            Alias = 'testUser',
            Email = 'testuser1@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = p.Id,
            UserName = 'Chandlal0099@gmail.com'
        );
        insert testUser;
        
        Account accountObject = new Account();
        accountObject.Name = 'test Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '455546565';
        insert accountObject;
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        insert projectObject;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Project__c = projectObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.Sales_Manager__c = testUser.Id;
        oppoObject.CloseDate = System.Today()+3;
        insert oppoObject;
        
        Booking__c testBook = new Booking__c();
        testBook.Project_Name__c = projectObject.Id;
        testBook.Related_Opportunity__c = oppoObject.Id;
        insert testBook;

        Co_Applicant__c testCoApplicant = new Co_Applicant__c();
        testCoApplicant.Role__c = 'Primary';
        testCoApplicant.Account__c = accountObject.Id;
        testCoApplicant.Booking__c = testBook.Id;
        insert testCoApplicant;

        callOutCustomerCreation.request testRequest = new callOutCustomerCreation.request();
        testRequest.bookingIds = new List<String>{ testBook.Id };

        Test.startTest();
        callOutCustomerCreation.calledFromTransactionFLow(new List<callOutCustomerCreation.request>{ testRequest });
        Test.stopTest();

        List<Data_Sync__c> dataSyncRecords = [SELECT Id, Status__c FROM Data_Sync__c WHERE RecordId__c = :testCoApplicant.Id];
        //System.assertEquals(1, dataSyncRecords.size());
        //System.assertEquals('In Progress', dataSyncRecords[0].Status__c);
    }

    @isTest
    static void testGenerateSapCodeForCoApplicant() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Sales Manager'];
        User testUser = new User(
            Alias = 'testUser',
            Email = 'testuser1@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = p.Id,
            UserName = 'Chandlal0099@gmail.com'
        );
        insert testUser;
        
        Account accountObject = new Account();
        accountObject.RecordTypeId = [select Id from recordtype where developerName = 'PersonAccount' ].Id;
        accountObject.LastName = 'Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '455546565';
        accountObject.FirstName = 'Test';
        accountObject.PersonBirthdate = system.today() - 30;
        accountObject.PersonMobilePhone = '9856984569';
        insert accountObject;
        
        Account accountObject1 = new Account();
        accountObject1.RecordTypeId = [select Id from recordtype where developerName = 'PersonAccount' ].Id;
        accountObject1.FirstName = 'Test';
        accountObject1.LastName = 'test Account';
        accountObject1.BillingCountry = 'India';
        accountObject1.Phone = '455546565';
        accountObject1.PersonBirthdate = system.today() - 30;
        accountObject1.PersonMobilePhone = '9856984573';
        insert accountObject1;
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        insert projectObject;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Project__c = projectObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.Sales_Manager__c = testUser.Id;
        oppoObject.CloseDate = System.Today()+3;
        insert oppoObject;
        
        Booking__c testBook = new Booking__c();
        testBook.Project_Name__c = projectObject.Id;
        testBook.Related_Opportunity__c = oppoObject.Id;
        insert testBook;

        Co_Applicant__c testCoApplicant = new Co_Applicant__c();
        testCoApplicant.Role__c = 'Primary';
        testCoApplicant.Account__c = accountObject.Id;
        testCoApplicant.Booking__c = testBook.Id;
        insert testCoApplicant;
        
        Co_Applicant__c testCoApplicant1 = new Co_Applicant__c();
        testCoApplicant1.Role__c = 'Co-Applicant';
        testCoApplicant1.Account__c = accountObject1.Id;
        testCoApplicant1.Booking__c = testBook.Id;
        insert testCoApplicant1;

        Test.startTest();
        callOutCustomerCreation.generateSapCodeForCoApplicant(testBook.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetSapCodes() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        callOutCustomerCreation.getSapCodes('{"sample": "json"}', new Set<String>{'coAppId'});
        Test.stopTest();

        List<Data_Sync__c> dataSyncRecords = [SELECT Id, Status__c FROM Data_Sync__c WHERE RecordId__c = 'coAppId'];
    }
}