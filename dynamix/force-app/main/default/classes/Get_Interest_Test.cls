@isTest
private class Get_Interest_Test {
    @isTest
    static void testGetInterest() {
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
        testBook.Sap_Code__c = '3010000177';
        insert testBook;
        
        Payment_Milestones__c testPM = new Payment_Milestones__c();
        testPM.Name = 'Test';
        testPM.Booking__c = testBook.Id;
        testPM.Sequence_No__c = 2;
        testPM.Milestone_age__c = 100;
        testPM.Sap_Code__c = 'Z1115';
        insert testPM;

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = accountObject.Id);
        insert testContact;

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/interest/';
        req.httpMethod = 'GET';

        Map<String, Object> requestBody = new Map<String, Object>();
        req.requestBody = Blob.valueOf('{"ZSD025_SFDC_INTEREST_LEDGER":{"CUST_HEADER":{"KUNNR":20000254,"VBELN":3010000177,"INT_WO":1000,"INT_REC":0,"INT_PEND":0},"CUST_PLAN":{"item":[{"MILESTONE":"Z1115","MILE_DESC":"Casting of Plinth of the tower","INVOICE":9010000110,"PAY_BY_DT":"01.02.2024","REC_DT":"","INT_RATE":16,"INT_AMT":3500,"INT_GST_AMT":200,"INT_TOT":3700}]}}}');

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        Get_Interest.getInterest();
        Test.stopTest();

        //System.assertEquals(400, RestContext.response.statusCode);
    }
}