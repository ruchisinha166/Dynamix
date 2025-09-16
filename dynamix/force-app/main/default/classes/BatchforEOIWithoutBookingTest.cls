@isTest
public class BatchforEOIWithoutBookingTest {

    @testSetup
    static void setupTestData() {
        UserRole smUserRole = new UserRole(Name='S&M Head', DeveloperName='SM_Head');
        //insert smUserRole;
        
        User smUser = new User(
            FirstName = 'Test',
            LastName = 'SMUser',
            Email = 'smuser@test.com',
            Username = 'smuser@test.com' + System.currentTimeMillis(),
            Alias = 'smuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id,
            UserRoleId = smUserRole.Id,
            LanguageLocaleKey = 'en_US'
        );
        //insert smUser;

        CustomNotificationType notificationType = new CustomNotificationType(DeveloperName='New_Opportunity', MasterLabel='New Opportunity');
        //insert notificationType;
        
        OrgWideEmailAddress orgWideEmailAddress = new OrgWideEmailAddress(
            Address='no-reply@test.com',
            DisplayName='Test OrgWide Email',
            IsAllowAllProfiles=true
        );
        //insert orgWideEmailAddress;
        
        EmailTemplate emailTemplate = new EmailTemplate(
            DeveloperName='ForEOIWithoutBooking',
            Name='ForEOIWithoutBooking',
            Subject='EOI/CA Notification for {projectName}',
            HtmlValue='Dear {customerName}, your {EOI/CA} number is {EOI_CA_Number} for project {projectName} with number {projectNumber}.',
            Body='Dear {customerName}, your {EOI/CA} number is {EOI_CA_Number} for project {projectName} with number {projectNumber}.',
            TemplateType='custom',
            IsActive=true
        );
        //insert emailTemplate;
        
        Account testAccount = new Account(
            FirstName = 'Test',
            LastName = 'Customer',
            PersonEmail = 'customer@test.com',
            PersonMobilePhone = '9457813232',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account' LIMIT 1].Id
        );
        insert testAccount;
        
        Project__c testProject = new Project__c(
            Name='Test Project',
            Launch_EOI_Period_s_End_Date__c=System.today(),
            Project_Email__c='no-reply@test.com',
            Project_Phone__c='123-456-7890'
        );
        insert testProject;
        
        Opportunity testOpportunity = new Opportunity(
            Name='Test Opportunity',
            StageName='Site Visit Done',
            CloseDate=System.today().addMonths(1),
            EOI_CA__c='EOI',
            Transfer_Opportunity__c=true,
            AccountId=testAccount.Id,
            Project__c=testProject.Id,
            EOI_CA_Number__c='EOI123456'
        );
        insert testOpportunity;
    }
    
    @isTest
    static void testBatchExecution() {
        Test.startTest();
        
        BatchforEOIWithoutBooking batch = new BatchforEOIWithoutBooking();
        Database.executeBatch(batch);
        
        Test.stopTest();
        
        /*List<EmailMessage> emailMessages = [SELECT Id, Subject, HtmlBody, RelatedToId FROM EmailMessage];
        System.assertEquals(1, emailMessages.size(), 'One EmailMessage should have been created.');
        System.assert(emailMessages[0].HtmlBody.contains('Test Customer'), 'Email body should contain customer name.');
        System.assert(emailMessages[0].HtmlBody.contains('EOI123456'), 'Email body should contain EOI_CA_Number.');
        System.assert(emailMessages[0].HtmlBody.contains('123-456-7890'), 'Email body should contain project number.');*/
    }
}