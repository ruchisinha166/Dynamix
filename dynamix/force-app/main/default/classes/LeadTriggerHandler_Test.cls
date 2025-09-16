@isTest
public class LeadTriggerHandler_Test {
    @isTest public static void Method()
    {
         Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User testUser = new User(
            ProfileId = profile.Id,
            Username = 'testuser@jj.com',
            Email = 'testuser@example.com',
            LastName = 'Test',
            FirstName = 'User',
            Alias = 'TUser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'en_US'
        );
        insert testUser;

        List<Campaign> campaigns = new List<Campaign>();
        for (Integer i = 0; i < 5; i++) {
            Campaign campaign = new Campaign(
                Name = 'Test Campaign ' + i,
                Approval_Status__c = 'Pending',
                Source__c = 'Instagram',
                StartDate = system.today(),
                EndDate = system.today()
            );
            campaigns.add(campaign);
        }
        insert campaigns;


        Lead thisLead = New Lead();
        thisLead.FirstName = 'Test';
        thisLead.LastName = 'Test';
        thisLead.Phone = '9898123456';
        thisLead.LeadSource__c = 'Instagram';
        thisLead.Campaign__c = campaigns[0].id;
        insert thisLead;
        
    }

}