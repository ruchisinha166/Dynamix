@isTest
private class EOICAFormControllerTest {
    
    @testSetup
    static void setup() {
        
       Account acc = new Account(
            Salutation = 'Mr.',
            FirstName = 'John',
            LastName = 'Doe',
            PersonEmail = 'viraj123@gmail.com',
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
            Name = 'Dynamix Test',
            Project_Phone__c = '9876543210',
            Launch_EOI_Period_s_End_Date__c = System.today().addDays(10),
            Launch_CA_Period_s_End_Date__c = System.today().addDays(10),
            Minimum_amount_for_EOI__c = 100000,
            Minimum_amount_for_CA__c = 200000,
            Budgets__c = '1 - 1.2 Cr',
            Configuration__c = '2 BHK',
            Project_Email__c = 'divum@dynamixgroup.co.in' ,
            Project_Carpet_Area__c = '700 – 750 sq.ft.',
            EOI_Terms_Conditions__c = 'EOI Terms and Conditions',
            CA_Terms_Conditions__c = 'CA Terms and Conditions',
            Project_Header__c = 'Project Header',
            Project_Footer__c = 'Project Footer'
        );
        insert proj;
        
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            EOI_CA__c = 'EOI',
            Project__c = proj.Id,
            Walk_in_Source__c = 'Channel Partner',
            Budget1__c = '1 - 1.1 Cr',
            Construction_Status__c = 'Under Construction',
            Source_of_Funding__c = 'Loan',
            Nature_of_Use__c = 'Self Use',
            Interested_Configuration__c = '1 BHK',
            Date_of_Site_Visit__c=system.today(),
            Referral_Mobile_Number__c='1234567890',
            EOI_CA_stage__c='Initiated',
            Sourcing_Manager__c=UserInfo.getUserId(), 
            EOI_CA_Form_Sent_Date_Time__c = System.now(),
            EOI_CA_Number__c = 'EOI-12'
        );
        insert opp;
        
        Property__c prop = new Property__c(
            Name = 'Test Property',
            Terms_Conditions__c = 'Property Terms and Conditions',
            Flat_Type__c = '2 BHK',
            RERA_Carpet_Area__c = 1000,
            Utility_Area__c = 100,
            Enclosed_balcony__c = 50,
            Deck_Carpet_Area__c = 75,
            Proposed_Area__c = 1225,
            Approved_Area__c = 1200,
            Deck_Approved_Area__c = 70,
            Deck_Proposed_Area__c = 80,
            Proposed_Utility_Area__c = 110,
            Proposed_Enclosed_Balcony_Area__c = 60
        );
        insert prop;
        
        Suggested_Property__c suggProp = new Suggested_Property__c(
            Opportunity__c = opp.Id,
            Unit__c = prop.Id,
            Status__c = 'Confirmed Allocation'
        );
        insert suggProp;
        
        User salesManager = new User(
            Alias = 'salesm',
            Email = 'salesmanager@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Sales Manager',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'salesManagerTestUser@example.com'
        );
        insert salesManager;
        
        User sourcingManager = new User(
            Alias = 'sourcm',
            Email = 'sourcingmanager@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Sourcing Manager',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'sourcingmanager@example.com'
        );
        insert sourcingManager;
        
        opp.Sales_Manager__c = salesManager.Id;
        opp.Sourcing_Manager__c = sourcingManager.Id;
        update opp;
    }
    
    @isTest
    static void test01() {
        
        Opportunity opp = [SELECT Id, Name, Walk_in_Source__c,AccountId,StageName,CloseDate, Budget1__c,Source_of_Funding__c, Nature_of_Use__c, 
                           EOI_CA_Form_Sent_Date_Time__c,Sales_Manager__c, Interested_Configuration__c, Project__c,Sourcing_Manager__c,
                           Project__r.Name,Secondary_Sales_Manager__c,Referral_By_Customer__c,Construction_Status__c,EOI_CA_Number__c
                           FROM Opportunity LIMIT 1];
        
        opp.Walk_in_Source__c = 'Referred by Existing Customer';
        update opp;
        Account acc = [SELECT Id, PersonEmail, FirstName, LastName, Designation_or_Position__pc,Age__c,
                       PersonMobilePhone, PersonMailingStreet,  PersonMailingState, PersonMailingCountry, PersonMailingPostalCode, PersonMailingCity,
                       Office_Locality__c,Industry__c,Locality__c, Nationality__c,Employment_Type__c,Office_Pin_Code__c FROM Account WHERE Id = :opp.AccountId];
        
        PageReference pageRef = Page.EOI_CA_Form; 
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(opp);
        pageRef.getParameters().put('Id', opp.Id); 
        
        EOICAFormController controller = new EOICAFormController(stdController);
        controller.selectedValue ='PreSales';
        controller.primaryAccountFirstName = 'John';
        controller.primaryAccountLastName = 'Doe';
        controller.primaryAccountMobileNo = '1234567890';
        controller.primaryAccountEmail = 'john@example.com';
        controller.primaryAccountSalutation = 'Mr';
        controller.selectedPrimaryAccCountryCodeAdd = '+91';
        controller.selectedValue = opp.Walk_in_Source__c;
        controller.salesManagerName = 'Test Sales Manager';
        controller.channelStringPartnerRecordID = 'Channel123';
        controller.channelPartnerName = 'Channel Partner';
        controller.myField = 'My Field';
        controller.CountOtp = 5;
        controller.salesManagerId = opp.Sales_Manager__c;
        controller.sourcingManagerId = opp.Sourcing_Manager__c;
        controller.sourcingManagerName = 'Sourcing Manager';
        controller.primaryAccountEmail = 'test@example.com';
        controller.cpAccountFirmName = 'CP Firm';
        controller.primaryAccountLastName = 'Doe';
        controller.primaryAccountFirstName = 'John';
        controller.primaryAccountChannelPartnerMobileNumber = '9876543210';
        controller.isPrimaryAccIndian = true;
        controller.selectedPrimaryAccAgeAdd = '26-35';
        controller.selectedPrimaryAccCountryCodeAdd ='+91';
        controller.isPrimaryAccNonIndian = false;
        controller.selectedPrimaryAccNationality = 'Indian';
        controller.submittedBy = 'User123';
        controller.recordId = opp.Project__c;
        controller.otpCode = '123456';
        controller.designation = 'Manager';
        controller.companyName = 'ABC Corp';
        controller.selectedPrimaryAccPermAddState = 'CA';
        controller.selectedPrimaryAccPermAddCountry = 'USA';
        controller.primaryAccMailingAddStreet = '123 Main St';
        controller.primaryAccMailingAddCity = 'City';
        controller.primaryAccMailingAddPostalCode = '12345';
        controller.primaryAccMailingAddState = 'CA';
        controller.primaryAccMailingAddCountry = 'USA';
        controller.apartmentFlat = 'Apt 101';
        controller.locality = 'Suburb';
        controller.officePinCode = '54321';
        controller.UnregisteredCP = true;
        controller.selectedPrimaryAccMaritalStatus = 'Married';
        controller.selectedNatureInUseAdd = 'Investment';
        controller.selectedPrimaryAccMaitalStatusAdd = 'Single';
        controller.selectedWalkInSourceAdd =opp.Walk_in_Source__c;
        controller.selectedProjectConfigurationAdd = '1 BHK';
        controller.selectedConstructionStatusAdd = 'Under Construction';
        controller.selectedSourceOfFundingStatus = 'Loan';
        controller.selectedEmploymentType = 'Salaried';    
        controller.showChannelPartner = true;
        controller.randomNumber = 42;
        controller.isverifyed = true;
        controller.otpBtnValue = 'Verify';
        controller.builderOrgName = 'BuilderCo';
        controller.disableOTP = true;
        controller.isSubmitButtonDisable = true;
        controller.errorMsg = 'Error message';
        controller.sucessMsg = 'Success message';
        controller.officeLocation = 'Downtown';
        controller.Industry = 'Real Estate';
        controller.projectCarpetArea = '475 - 1 BHK';
        controller.ProjectHeader = 'Header Text';
        controller.ProjectFooter = 'Footer Text';
        controller.showHeader = true;
        controller.showFooter = true;
        controller.ProjectName = opp.Project__r.Name;
        controller.secondarySalesManagerName = 'Secondary Manager';
        controller.secondarySalesManagerId = opp.Secondary_Sales_Manager__c;
        controller.secondarySalesManager = 'Secondary Sales';
        controller.setReadOnlyChannelPartner = 'ReadOnly';
        controller.cpFirmName ='xyz';
        controller.CPName = 'zyz';
        controller.reraNumber = '1234';
        controller.channelPartnerNumber='+915656565656';
        controller.referralId = opp.Referral_By_Customer__c;
        controller.referralName = 'test';
        controller.referralByCustomerId = opp.Referral_By_Customer__c;
        controller.countryCodeValue = '+91';
        controller.referralByMobileNumber = '7878787878';
        controller.makeItReadOnly = false;
        controller.referralLastName = 'Test';
        controller.referralFirstName = 'test';
        controller.referralType = 'Channel Partner';
        controller.showReferralByOther = True;
        
        controller.multiSelectBudgetValues = new List<String>{'76 lakhs - 1.25 crs', 'Under 75 lakhs'};
            controller.budgetPicklistOptions = new List<SelectOption>{new SelectOption('76 lakhs - 1.25 crs', 'Under 75 lakhs'), new SelectOption('76 lakhs - 1.25 crs', 'Under 75 lakhs')};
                controller.projectConfigurationPicklistOptions = new List<SelectOption>{new SelectOption('Jodi', 'Jodi'), new SelectOption('Studio', 'Studio')};
                    controller.selectedBudgetPicklistValue = 'Under 75 lakhs';
        controller.accountList = acc;
        List<SelectOption> options = controller.getselectedEmploymentTypeAddOption();
        List<SelectOption> options1 = controller.getselectedSourceOfFundingAddOption();
        List<SelectOption> options2 = controller.getselectedReferralTypeAddOption();
         List<SelectOption> options3 = controller.getselectedLocalityAddOption();
        List<SelectOption> options4 = controller.getselectedSourceOfFundingAddOption();
        List<SelectOption> options5 = controller.getselectedConstructionStatusAddOption();
        List<SelectOption> options6 = controller.getselectedNatureOfSourceAddOption();
        List<SelectOption> options7 = controller.getselectedFloorAddOption();
        List<SelectOption> options8 = controller.getEmploymentTypeOption();
        List<SelectOption> options9 = controller.getlistSelectedContact();
        List<SelectOption> options10 = controller.getselectedPrimaryAccMaitalStatusAddOption();
        List<SelectOption> options11 = controller.getselectedFloorAddOption();
        List<SelectOption> options12 = controller.getselectedEthnicityAddOption();
        List<SelectOption> options13 = controller.getselectedPrimaryAccMaitalStatusAddOption();
        List<SelectOption> options14 = controller.getselectedPrimaryAccAgeAddOption();
        List<List<SelectOption>> options15 = controller.getselectedWalkInSourceAddOption();
        List<SelectOption> options16 = controller.getselectedPrimaryAccNationalityOptions();
        List<SelectOption> options17 = controller.getprimaryAccountSalutationOption();
        List<SelectOption> options18 = controller.getselectedPrimaryAccCountryCodeAddOption();
        PageReference resultPage = controller.submitEOICAForm();
    }
    
    @isTest
    static void testEOICAFormController() {
        
        Opportunity opp = [SELECT Id, Name, Walk_in_Source__c,AccountId,StageName,CloseDate, Budget1__c,Source_of_Funding__c, Nature_of_Use__c, 
                            EOI_CA_Form_Sent_Date_Time__c,Sales_Manager__c, Interested_Configuration__c, Project__c,Sourcing_Manager__c,
                           Project__r.Name,Secondary_Sales_Manager__c,Referral_By_Customer__c,Construction_Status__c,EOI_CA_Number__c
                           FROM Opportunity LIMIT 1];
        
        Account acc = [SELECT Id, PersonEmail, FirstName, LastName, Designation_or_Position__pc,Age__c,
                       PersonMobilePhone, PersonMailingStreet,  PersonMailingState, PersonMailingCountry, PersonMailingPostalCode, PersonMailingCity,
                      Office_Locality__c,Industry__c,Locality__c, Nationality__c,Employment_Type__c,Office_Pin_Code__c FROM Account WHERE Id = :opp.AccountId];
        
        PageReference pageRef = Page.EOI_CA_Form; 
        Test.setCurrentPage(pageRef);
            
        ApexPages.StandardController stdController = new ApexPages.StandardController(opp);
        pageRef.getParameters().put('Id', opp.Id); 
        
        EOICAFormController controller = new EOICAFormController(stdController);
        controller.selectedValue ='PreSales';
        controller.primaryAccountFirstName = 'John';
        controller.primaryAccountLastName = 'Doe';
        controller.primaryAccountMobileNo = '1234567890';
        controller.primaryAccountEmail = 'john@example.com';
        controller.primaryAccountSalutation = 'Mr';
        controller.selectedPrimaryAccCountryCodeAdd = '+91';
        controller.selectedValue = opp.Walk_in_Source__c;
        controller.salesManagerName = 'Test Sales Manager';
        controller.channelStringPartnerRecordID = 'Channel123';
        controller.channelPartnerName = 'Channel Partner';
        controller.myField = 'My Field';
        controller.CountOtp = 5;
        controller.salesManagerId = opp.Sales_Manager__c;
        controller.sourcingManagerId = opp.Sourcing_Manager__c;
        controller.sourcingManagerName = 'Sourcing Manager';
        controller.primaryAccountEmail = 'test@example.com';
        controller.cpAccountFirmName = 'CP Firm';
        controller.primaryAccountLastName = 'Doe';
        controller.primaryAccountFirstName = 'John';
        controller.primaryAccountChannelPartnerMobileNumber = '9876543210';
        controller.isPrimaryAccIndian = true;
        controller.selectedPrimaryAccAgeAdd = '26-35';
        controller.selectedPrimaryAccCountryCodeAdd ='+91';
        controller.isPrimaryAccNonIndian = false;
        controller.selectedPrimaryAccNationality = 'Indian';
        controller.submittedBy = 'User123';
        controller.recordId = opp.Project__c;
        controller.otpCode = '123456';
        controller.designation = 'Manager';
        controller.companyName = 'ABC Corp';
        controller.selectedPrimaryAccPermAddState = 'CA';
        controller.selectedPrimaryAccPermAddCountry = 'USA';
        controller.primaryAccMailingAddStreet = '123 Main St';
        controller.primaryAccMailingAddCity = 'City';
        controller.primaryAccMailingAddPostalCode = '12345';
        controller.primaryAccMailingAddState = 'CA';
        controller.primaryAccMailingAddCountry = 'USA';
        controller.apartmentFlat = 'Apt 101';
        controller.locality = 'Suburb';
        controller.officePinCode = '54321';
        controller.UnregisteredCP = true;
        controller.selectedPrimaryAccMaritalStatus = 'Married';
        controller.selectedNatureInUseAdd = 'Investment';
        controller.selectedPrimaryAccMaitalStatusAdd = 'Single';
        controller.selectedWalkInSourceAdd =opp.Walk_in_Source__c;
        controller.selectedProjectConfigurationAdd = '1 BHK';
        controller.selectedConstructionStatusAdd = 'Under Construction';
        controller.selectedSourceOfFundingStatus = 'Loan';
        controller.selectedEmploymentType = 'Salaried';    
        controller.showChannelPartner = true;
        controller.randomNumber = 42;
        controller.isverifyed = true;
        controller.otpBtnValue = 'Verify';
        controller.builderOrgName = 'BuilderCo';
        controller.disableOTP = true;
        controller.isSubmitButtonDisable = true;
        controller.errorMsg = 'Error message';
        controller.sucessMsg = 'Success message';
        controller.officeLocation = 'Downtown';
        controller.Industry = 'Real Estate';
        controller.projectCarpetArea = '475 - 1 BHK';
        controller.ProjectHeader = 'Header Text';
        controller.ProjectFooter = 'Footer Text';
        controller.showHeader = true;
        controller.showFooter = true;
        controller.ProjectName = opp.Project__r.Name;
        controller.secondarySalesManagerName = 'Secondary Manager';
        controller.secondarySalesManagerId = opp.Secondary_Sales_Manager__c;
        controller.secondarySalesManager = 'Secondary Sales';
        controller.setReadOnlyChannelPartner = 'ReadOnly';
        controller.cpFirmName ='xyz';
        controller.CPName = 'zyz';
        controller.reraNumber = '1234';
        controller.channelPartnerNumber='+915656565656';
        controller.referralId = opp.Referral_By_Customer__c;
        controller.referralName = 'test';
        controller.referralByCustomerId = opp.Referral_By_Customer__c;
        controller.countryCodeValue = '+91';
        controller.referralByMobileNumber = '7878787878';
        controller.makeItReadOnly = false;
        controller.referralLastName = 'Test';
        controller.referralFirstName = 'test';
        controller.referralType = 'Channel Partner';
        controller.showReferralByOther = True;
      
        controller.multiSelectBudgetValues = new List<String>{'76 lakhs - 1.25 crs', 'Under 75 lakhs'};
            controller.budgetPicklistOptions = new List<SelectOption>{new SelectOption('76 lakhs - 1.25 crs', 'Under 75 lakhs'), new SelectOption('76 lakhs - 1.25 crs', 'Under 75 lakhs')};
                controller.projectConfigurationPicklistOptions = new List<SelectOption>{new SelectOption('Jodi', 'Jodi'), new SelectOption('Studio', 'Studio')};
                    controller.selectedBudgetPicklistValue = 'Under 75 lakhs';
        controller.accountList = acc;
        
        PageReference resultPage = controller.submitEOICAForm();
            }
}