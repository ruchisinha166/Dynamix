@isTest
private class TestEOICAFormDocController {
    static testMethod void testEOICAFormDocController() {
     
        Account testAccount = new Account(
            FirstName = 'John',
            LastName = 'Doe',
            PersonEmail = 'johndoe112@gmail.com',
            PersonMobilePhone = '1234567890',
            PersonMailingStreet = '123 Test Lane',
            PersonMailingCity = 'Testville',
            PersonMailingState = 'Test State',
            PersonMailingPostalCode = '12345',
            PersonMailingCountry = 'Testland'
        );
        insert testAccount;
        
        Project__c testProject = new Project__c(
            Name = 'Test Project',
            Project_Header__c = 'Header Info',
            Project_Footer__c = 'Footer Info',
            EOI_Terms_Conditions__c = 'EOI Terms',
            CA_Terms_Conditions__c = 'CA Terms'
            
        );
        insert testProject;

		
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = testAccount.Id,
            Project__c= testProject.id,
            EOI_CA__c = 'EOI',
            closeDate = System.Today()+7,
            StageName = 'In Progress'
        );
        insert testOpportunity; 
 

        PageReference pageRef = Page.EOI_CA_Document; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', testOpportunity.Id);
        
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testOpportunity);
        EOICAFormDocController controller = new EOICAFormDocController(sc);

       /* System.assertEquals(false, controller.ShowHeader, 'Header should initially be false');
        System.assertEquals(false, controller.showFooter, 'Footer should initially be false');*/
        
        controller.ShowHeader = true;
        controller.showFooter = true;

       /* System.assertEquals(true, controller.ShowHeader, 'Header should now be true');
        System.assertEquals(true, controller.showFooter, 'Footer should now be true');
        System.assertEquals('Header Info', controller.ProjectHeader, 'Incorrect project header');
        System.assertEquals('Footer Info', controller.ProjectFooter, 'Incorrect project footer');
        System.assertEquals('EOI Terms', controller.termsAndCondition, 'Terms should match EOI Terms');*/
                           
    }
}