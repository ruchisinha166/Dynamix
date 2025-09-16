@isTest
public class ChannelPartnerAccountHandlerTest {
    @isTest
    static void testHandleAfterInsert() {
        
        
        List<User> user = new List<User>();
        User testSiteHead = new User();
        testSiteHead.FirstName = 'Test';
        testSiteHead.LastName = 'SiteHead';
        testSiteHead.Email = 'testsitehead@example.com';
        testSiteHead.Alias = 'tshead';
        testSiteHead.Username = 'tshead@example.com';
        testSiteHead.EmailEncodingKey = 'UTF-8';
        testSiteHead.LanguageLocaleKey = 'en_US';
        testSiteHead.LocaleSidKey = 'en_US';
        testSiteHead.TimeZoneSidKey = 'America/Los_Angeles';
        testSiteHead.ProfileId = UserInfo.getProfileId();
        insert testSiteHead;
        user.add(testSiteHead);
        
        Project__c testProject = new Project__c();
        testProject.Name = 'Test Project';
        testProject.Project_Carpet_Area__c = '475 - 1 BHK';
        testProject.Budgets__c = 'Under 75 lakhs';
        testProject.Configuration__c ='1 BHK';
        testProject.Site_Head__c = testSiteHead.Id;
        insert testProject;

        RecordType channelPartnerRecordType = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Channel_Partner' LIMIT 1];

        Map<Id, Account> accountMap = new Map<Id, Account>();

        // List<Account> AccountList = new List<Account>();
        Account testAccount = new Account();
        testAccount.Name = 'Channel Partner Account';
        testAccount.RecordTypeId = channelPartnerRecordType.Id;
        testAccount.Project__c = testProject.Id;
        insert testAccount;
        //AccountList.add(testAccount);
        accountMap.put(testAccount.Id, testAccount);
        
       
       // accountProjectMap.containsKey(testAccount.Id);
        
      //  projectSiteHead.get(accountProjectMap.get(testAccount.Id));

        Project__c projectToUpdate = [SELECT Id, Site_Head__c FROM Project__c WHERE Id = :testProject.Id LIMIT 1];
        projectToUpdate.Site_Head__c = testSiteHead.Id;
        update projectToUpdate;

        
        List<EmailTemplate> templates = [SELECT Id FROM EmailTemplate WHERE DeveloperName = : 'Channel_Partner_Email' LIMIT 1];
        
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        
        Test.setMock(HttpCalloutMock.class, new MockCallout());
        
        Test.startTest();
        ChannelPartnerAccountHandler.handleAfterInsert(accountMap);
        Test.stopTest();
        Project__c updatedProject = [SELECT Id, Site_Head__c FROM Project__c WHERE Id = :testProject.Id LIMIT 1];
        
    }
}