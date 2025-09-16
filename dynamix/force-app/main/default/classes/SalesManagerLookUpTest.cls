@isTest
private class SalesManagerLookUpTest {

    @TestSetup
    static void setup() {
        // Create test User
       Profile pId = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        UserRole r = new UserRole(Name = 'Sales Manager');
        insert r;
        List<User> testUser = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com'+i;
                    
            User testUserRcd1 = new User();
            testUserRcd1.FirstName = 'Test';
            testUserRcd1.LastName = 'Patel123';
            testUserRcd1.Email = 'mayur.patel@manras.com';
            testUserRcd1.Alias = 'MPatel';
            testUserRcd1.Username = uniqueUserName;
            testUserRcd1.ProfileId = pId.Id;
            testUserRcd1.EmailEncodingKey = 'UTF-8';
            testUserRcd1.Country = 'India';
            testUserRcd1.LanguageLocaleKey='en_US';
            testUserRcd1.LocaleSidKey='en_US';
            testUserRcd1.userRoleId= r.id;
            testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
            testUser.add(testUserRcd1);
        }
        insert testUser;
    }

    @isTest
    static void testFetchRecords() {
        // Test when inputWrapper is null
        test.startTest();
       // List<SalesManagerLookUp.ResultWrapper> result1 = SalesManagerLookUp.fetchRecords(null);
        //System.assertEquals(null, result1);
        List<User> userList = [SELECt id, name from User];
        
        // Test with a valid inputWrapper
        SalesManagerLookUp.SearchWrapper inputWrapper = new SalesManagerLookUp.SearchWrapper();
        inputWrapper.objectApiName = 'User';
        inputWrapper.fieldApiName = 'Name';
        inputWrapper.otherFieldApiName = 'Email';
        inputWrapper.role = 'Sales Manager';
        inputWrapper.searchString = 'TeSt';
        List<SalesManagerLookUp.ResultWrapper> result2 = SalesManagerLookUp.fetchRecords(inputWrapper);
        test.stopTest();
        // Add more test cases to cover different execution paths
        // ...
    }
}