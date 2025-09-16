@isTest
private class ReusableLookupController_Test {

    @TestSetup
    static void setup() {
        // Create test Account
        List<Account> testAccount = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account account = New Account();
            account.FirstName= String.valueof(i);
            account.LastName= 'Test';
            account.PersonMobilePhone = '901010102'+ String.valueof(i);
            testAccount.add(account);
        }
       
        
       Id cpRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        for (Integer i = 0; i < 10; i++) {
            Account account = New Account();
            account.Name= 'Test ' +String.valueof(i);
            account.RecordTypeId = cpRecordId;
            account.Phone = '901010101'+ String.valueof(i);
            testAccount.add(account);
        }
 insert testAccount;
    }

    @isTest
    static void testFetchRecords() {
        // Test when inputWrapper is null
        List<ReusableLookupController.ResultWrapper> result1 = ReusableLookupController.fetchRecords(null);
        System.assertEquals(null, result1);
        List<Account> accountList = [SELECt id, name, PersonMobilePhone from Account];

        // Test with a valid inputWrapper
        ReusableLookupController.SearchWrapper inputWrapper = new ReusableLookupController.SearchWrapper();
        inputWrapper.objectApiName = 'Account';
        inputWrapper.fieldApiName = 'Name';
        inputWrapper.otherFieldApiName = 'PersonMobilePhone';
        inputWrapper.searchString = 'TeSt';
        inputWrapper.type = 'Person Account';
        List<ReusableLookupController.ResultWrapper> result2 = ReusableLookupController.fetchRecords(inputWrapper);
        
        // Add more test cases to cover different execution paths
        // ...
    }
    
      @isTest
    static void testFetchRecords1() {
        // Test when inputWrapper is null
        List<ReusableLookupController.ResultWrapper> result1 = ReusableLookupController.fetchRecords(null);
        System.assertEquals(null, result1);
        List<Account> accountList = [SELECt id, name, Phone, RERA_Number__c from Account];

        // Test with a valid inputWrapper
        ReusableLookupController.SearchWrapper inputWrapper = new ReusableLookupController.SearchWrapper();
        inputWrapper.objectApiName = 'Account';
        inputWrapper.fieldApiName = 'Name';
        inputWrapper.otherFieldApiName = 'Phone';
        inputWrapper.searchString = 'TeSt';
        inputWrapper.type = 'Channel Partner';
        List<ReusableLookupController.ResultWrapper> result2 = ReusableLookupController.fetchRecords(inputWrapper);
        
        // Add more test cases to cover different execution paths
        // ...
    }
}