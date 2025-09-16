@isTest
public class BatchforEOICAOpportunityTest {
    @testSetup
    static void setupTestData() {
        UserRole smUserRole = new UserRole(Name='S&M Head');
        //insert smUserRole;
        
        User smUser1 = new User(
            FirstName = 'SM',
            LastName = 'User1',
            Email = 'smuser1@test.com',
            Username = 'smuser1@test.com',
            Alias = 'smuser1',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US',
            UserRoleId = smUserRole.Id
        );
        
        User smUser2 = new User(
            FirstName = 'SM',
            LastName = 'User2',
            Email = 'smuser2@test.com',
            Username = 'smuser2@test.com',
            Alias = 'smuser2',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US',
            UserRoleId = smUserRole.Id
        );
        
        //insert new List<User> { smUser1 };
            
            CustomNotificationType notificationType = new CustomNotificationType(DeveloperName='New_Opportunity');
        // insert notificationType;
        
        EmailTemplate emailTemplate = new EmailTemplate(
            DeveloperName = 'EOI_CA_Extend_Notification',
            Subject = '{EOI_CA} Notification for {projectName}',
            HtmlValue = '<p>{EOI_CA} Notification for {projectName}</p><p>Start Date: {startDate}</p><p>End Date: {endDate}</p><p>Minimum Amount: {amount}</p><p><a href="{Link}">Project Link</a></p>',
            Body = '{EOI_CA} Notification for {projectName}\nStart Date: {startDate}\nEnd Date: {endDate}\nMinimum Amount: {amount}\n{Link}',
            TemplateType = 'text',
            IsActive = true
        );
        //insert emailTemplate;
        
        OrgWideEmailAddress orgWideEmailAddress = new OrgWideEmailAddress(Address='noreply@test.com');
        //  insert orgWideEmailAddress;
        
        List<Project__c> projects = new List<Project__c>();
        
        projects.add(new Project__c(
            Name = 'Project 1',
            Launch_EOI_Period_s_Start_Date__c = Date.today().addDays(-10),
            Launch_EOI_Period_s_End_Date__c = Date.today(),
            Minimum_amount_for_EOI__c = 1000,
            Project_Email__c = orgWideEmailAddress.Address
        ));
        
        projects.add(new Project__c(
            Name = 'Project 2',
            Launch_CA_Period_s_Start_Date__c = Date.today().addDays(-20),
            Launch_CA_Period_s_End_Date__c = Date.today(),
            Minimum_amount_for_CA__c = 2000,
            Project_Email__c = orgWideEmailAddress.Address
        ));
        
        insert projects;
    }
    
    @isTest
    static void testBatchforEOICAOpportunity() {
        Test.startTest();
        BatchforEOICAOpportunity batch = new BatchforEOICAOpportunity();
        Database.executeBatch(batch);
        Test.stopTest();
        
        List<EmailMessage> emailMessages = [SELECT Id, Subject, HtmlBody, RelatedToId FROM EmailMessage];
        System.assertEquals(2, emailMessages.size(), '2 Email Messages should be sent.');
        
        
    }
}