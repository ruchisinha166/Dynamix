@isTest
private class SendEOI_CAFormToCustomerTest {
    
    @isTest
    public static void testSendMethod_EmailTemplateNull() {
        
        OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where Address = : 'divum@dynamixgroup.co.in'];
        Project__c testProject = new Project__c(
            Name = 'Test Project',
            Project_Email__c = 'test@example.com',
            Project_Phone__c = '1234567890',
            Launch_EOI_Period_s_End_Date__c = System.today().addDays(7),
            Launch_CA_Period_s_End_Date__c = System.today().addDays(7),
            Project_Carpet_Area__c = '475 - 1 BHK',
            Configuration__c = '2.5 BHK',
            Budgets__c = 'Under 75 lakhs'
        );
        insert testProject;
        
        Account testAccount = new Account(
            FirstName = 'Test',
            LastName = 'Account',
            PersonEmail = 'testaccount@example.com',
            PersonMobilePhone = '9487568984'
        );
        insert testAccount;
        
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Account',
            CloseDate = system.today() + 5,
            Walk_in_Source__c = 'Website',
            StageName = 'Qualification',
            EOI_CA__c = 'EOI',
            Project__c = testProject.Id,
            AccountId = testAccount.Id
        );
        insert testOpportunity;
        
        SendEOI_CAFormToCustomer.requestWrapper testWrapper = new SendEOI_CAFormToCustomer.requestWrapper();
        testWrapper.organisationWideAddressId = orgEmail.Id;
        testWrapper.primaryMobileNumber = '1234567890';
        testWrapper.Name = 'Test Name';
        testWrapper.opportunityId = testOpportunity.Id;
        testWrapper.personEmail = 'test@example.com';
        testWrapper.EOICA = 'Test EOICA';
        testWrapper.UnitNumber = '123';
        testWrapper.projectName = 'Test Project';
        testWrapper.emailTemplateName = 'CA_Form_Link';
        testWrapper.EOI_CA_Number = '1209';
        Test.startTest();
        SendEOI_CAFormToCustomer.SendMethod(new List<SendEOI_CAFormToCustomer.requestWrapper>{testWrapper});
        Test.stopTest();
        
        List<EmailMessage> emailMessages = [SELECT Id FROM EmailMessage];
    }
}