@isTest
public class LookupController_Test {
    
    @isTest static void findMethodTest(){
        List<List<SObject>> results = LookupController.find('Test', 'Contact');
        Test.startTest();
        system.assertEquals(1, results.size());
        Test.stopTest();
    }
    @isTest static void findMethodTest2(){
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account accountObject = new Account();
        accountObject.FirstName = 'Test 123';
        accountObject.LastName = 'Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '455546565';
        accountObject.RecordTypeId = PersonRecId;
        accountObject.PersonEmail = 'dynamix.project@gmail.com';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        insert accountObject;
        Id accId = accountObject.Id;
        SObject Results = LookupController.lookUpById(accId, 'Account', 'Name,RecordTypeId');
        Test.startTest();
        List<List<SObject>> results1 = LookupController.find('Test', 'Account (Name,RecordTypeId)');        
        Test.stopTest();
    }
    @isTest static void LookupById(){
        
        contact conRec = New Contact();
        conRec.LastName = 'Test';
        insert conRec;
        Id ConId = conRec.Id;
        
        SObject Results = LookupController.lookUpById(ConId, 'Contact', 'LastName');
        
    }
    
    
}