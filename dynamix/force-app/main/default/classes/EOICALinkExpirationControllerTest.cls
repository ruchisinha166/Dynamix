@isTest
private class EOICALinkExpirationControllerTest{
    
    @isTest
    static void testFormSubmitted(){
        Account acc = new Account(
            Salutation = 'Mr.',
            FirstName = 'John',
            LastName = 'Doe',
            PersonEmail = 'test@example.com',
            PersonMobilePhone = '1234567890',
            Nationality__c = 'Indian',
            Martial_Status__pc = 'Single',
            Country_Code__c = '+91',
            Company_Name__pc = 'Test Company',
            Designation_or_Position__pc = 'Manager',
            Age__c = '30',
            PersonMailingStreet = '123 Main St',
            PersonMailingState = 'California',
            PersonMailingPostalCode = '12345',
            PersonMailingCountry = 'USA',
            PersonMailingCity = 'Los Angeles',
            Apartment_Flat__c = 'Apt 101',
            Locality__c = 'Downtown',
            Office_Locality__c = 'Business District',
            Industry__c = 'Technology',
            Employment_Type__c = 'Business',
            Office_Pin_Code__c = '54321'
        );
        insert acc;
        
        Project__c proj = new Project__c(
            Name = 'Test Project',
            Project_Email__c = 'test@example.com',
            Project_Phone__c = '9876543210',
            Launch_EOI_Period_s_End_Date__c = System.today().addDays(10),
            Launch_CA_Period_s_End_Date__c = System.today().addDays(10),
            Minimum_amount_for_EOI__c = 100000,
            Minimum_amount_for_CA__c = 200000,
            Budgets__c = '1 - 1.2 Cr',
            Configuration__c = '2 BHK',
            Project_Carpet_Area__c = '700 – 750 sq.ft.',
            EOI_Terms_Conditions__c = 'EOI Terms and Conditions',
            CA_Terms_Conditions__c = 'CA Terms and Conditions',
            Project_Header__c = 'Project Header',
            Project_Footer__c = 'Project Footer'
        );
        insert proj;
        
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity 1',
            AccountId = acc.Id,
            Project__c = proj.Id,
            CloseDate = Date.today().addDays(10),
            StageName = 'Prospecting',
            Transfer_Opportunity__c = true,
            EOI_CA_Form_Sent_Date_Time__c = System.now(),
            EOI_CA_Form_Submission_Date_and_Time__c = System.now(),
            EOI_CA__c = 'EOI'
        );
     
        insert opp;
        
        
        EOICALinkExpirationController.EOICALinkExpirationMethod(opp.Id);
       
    }
    @isTest
    static void testFormSubmitted1(){
        Account acc = new Account(
            Salutation = 'Mr.',
            FirstName = 'John',
            LastName = 'Doe',
            PersonEmail = 'test@example.com',
            PersonMobilePhone = '1234567890',
            Nationality__c = 'Indian',
            Martial_Status__pc = 'Single',
            Country_Code__c = '+91',
            Company_Name__pc = 'Test Company',
            Designation_or_Position__pc = 'Manager',
            Age__c = '30',
            PersonMailingStreet = '123 Main St',
            PersonMailingState = 'California',
            PersonMailingPostalCode = '12345',
            PersonMailingCountry = 'USA',
            PersonMailingCity = 'Los Angeles',
            Apartment_Flat__c = 'Apt 101',
            Locality__c = 'Downtown',
            Office_Locality__c = 'Business District',
            Industry__c = 'Technology',
            Employment_Type__c = 'Business',
            Office_Pin_Code__c = '54321'
        );
        insert acc;
        
        Project__c proj = new Project__c(
            Name = 'Test Project',
            Project_Email__c = 'test@example.com',
            Project_Phone__c = '9876543210',
            Launch_EOI_Period_s_End_Date__c = System.today().addDays(10),
            Launch_CA_Period_s_End_Date__c = System.today().addDays(10),
            Minimum_amount_for_EOI__c = 100000,
            Minimum_amount_for_CA__c = 200000,
            Budgets__c = '1 - 1.2 Cr',
            Configuration__c = '2 BHK',
            Project_Carpet_Area__c = '700 – 750 sq.ft.',
            EOI_Terms_Conditions__c = 'EOI Terms and Conditions',
            CA_Terms_Conditions__c = 'CA Terms and Conditions',
            Project_Header__c = 'Project Header',
            Project_Footer__c = 'Project Footer'
        );
        insert proj;
        
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity 1',
            AccountId = acc.Id,
            Project__c = proj.Id,
            CloseDate = Date.today().addDays(10),
            StageName = 'Prospecting',
            Transfer_Opportunity__c = true,
            EOI_CA_Form_Sent_Date_Time__c = System.now(),
            EOI_CA__c = 'EOI'
        );
     
        insert opp;
        
        
        EOICALinkExpirationController.EOICALinkExpirationMethod(opp.Id);
       
    }
}