@isTest
private class OpportunityFormControllerTest {
    @isTest
    static void testform4Condition() {
        
        // Create test data and prepare the controller
        // createTestData();
        Map<String,String> enquirySourceMap = New Map<String,String>();
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Phone = '1234567890';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.MobilePhone = '5657562465';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            BookingForm_OTP_Data__mdt mockMetadata = new BookingForm_OTP_Data__mdt(
                DeveloperName = 'Test_Label',
                Bearer_Token__c = 'TestBearerToken',
                End_Point__c = 'TestEndPoint',
                Content_Type_Header__c = 'TestContentTypeHeader',
                Authorization_Header__c = 'TestAuthorizationHeader',
                Message_Body__c = 'Your OTP is: {{1}} for {{2}}',
                CIF_OTP_Message_Body__c = 'Test CIF Message Body {{1}} {{2}}'
            );
            
            if (mockMetadata != null && mockMetadata.Message_Body__c != null) {
                String msgBody = mockMetadata.Message_Body__c;
                Integer randomNumber = 1234; 
                msgBody = msgBody.replace('{{1}}', String.valueOf(randomNumber));
                msgBody = msgBody.replace('{{2}}', 'opportunity');
                
            } else {
                System.debug('Metadata not found or Message Body is empty.');
            }
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            insert accountObject; 
            
            if (mockMetadata != null && mockMetadata.Message_Body__c != null) {
                String msgBody = mockMetadata.Message_Body__c;
                Integer randomNumber = 1234; 
                msgBody = msgBody.replace('{{1}}', String.valueOf(randomNumber));
                msgBody = msgBody.replace('{{2}}', 'opportunity');
                
            } 
            
            List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
            CIF_Form__c cifFormObject = new CIF_Form__c();
            if (!cifForm.isEmpty()) {
                // The list is not empty, so you can access its elements
                
                cifFormObject.Name = 'Test11 CIF Form';
                cifFormObject.Disable_Till__c = System.now().addDays(1);
                cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
                insert cifFormObject;
            } else {
                // The list is empty, so you need to create a new record
                // CIF_Form__c cifFormObject = new CIF_Form__c();
                cifFormObject.Name = 'Test11 CIF Form';
                cifFormObject.Disable_Till__c = System.now().addDays(1);
                
                insert cifFormObject;
            }
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.Project_Footer__c = 'tsc.com';
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            List<Opportunity> OpportunityList = new List<opportunity>();
            
            
            Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity');
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Budget1__c = 'Under 75 lakhs';
            testOpportunity.Construction_Status__c = 'RTMI';
            testOpportunity.Interested_Configuration__c = '1 BHK';
            testOpportunity.Nature_of_Use__c ='';
            testOpportunity.Source_of_Funding__c = '';
            testOpportunity.Carpet_Area_in_sq_mts__c = 89.77;
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Name = 'Test1';
            testOpportunity.StageName = 'Site Visit';
            testOpportunity.CloseDate = system.today().addDays(30);
            testOpportunity.Email_Id__c = 'TEst@gmail.com';
            testOpportunity.Phone__c = '8987676568';
            testOpportunity.Project__c = projectObject.Id;
            testOpportunity.Sales_Manager__c = testUserRcd1.Id;
            testOpportunity.Date_of_Site_Visit__c = System.today();
            testOpportunity.Walk_in_Source__c = 'Referred by Existing Customer';
            testOpportunity.Referral_Name__c = 'test Test';
            testOpportunity.Sourcing_Manager__c = testUserRcd1.Id;
            testOpportunity.Secondary_Sales_Manager__c = testUserRcd1.Id;
            testOpportunity.Referral_By_Customer__c =  accountObject.Id;
            insert testOpportunity;
            
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            insert testCampRcd;
            
            
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c = projectObject.Id;
            testEnqRcd.Contact_Person__c = accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Google';
            testEnqRcd.Campaign__c = testCampRcd.Id;
            testEnqRcd.Country_Code__c = '+91';
            testEnqRcd.Primary_Mobile_Number__c = '1234567890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            testEnqRcd.Site_Visit_Done_Date__c = system.now();
            testEnqRcd.Stage__c = 'Interested';
            testEnqRcd.Construction_Status__c = 'RTMI';
            testEnqRcd.Configuration__c = '1 BHK';
            testEnqRcd.Budget__c = '1.75 crs - 2.25 crs';
            testEnqRcd.Enquiry_Source__c = 'Google';
            insert testEnqRcd;
            enquirySourceMap.containsKey(testEnqRcd.Enquiry_Source__c);
            
            testOpportunity.Linked_Enquiry__c = testEnqRcd.id;
            testOpportunity.Enquiry_Source__c = testEnqRcd.Enquiry_Source__c;
            testOpportunity.Enquiry_Sub_Source__c = testEnqRcd.Enquiry_Sub_Source__c;
            testOpportunity.Walk_in_Source__c = 'Referred by Others';
            update testEnqRcd;
            
            Task testTaskRcd=new Task();
            testTaskRcd.Subject = 'Site Visit Done';
            testTaskRcd.Status = 'Open';
            testTaskRcd.WhatId = testOpportunity.Id;
            testTaskRcd.Project__c = projectObject.Id;
            testTaskRcd.ActivityDate=System.today();
            testTaskRcd.OwnerId = testUserRcd1.Id;
            testTaskRcd.ReminderDateTime = system.now();
            insert testTaskRcd;
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SmartWorldMock());
            OpportunityList.add(testOpportunity);
            
            PageReference pageRef = Page.CIF2;
            Test.setCurrentPage(pageRef);
            
            EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'Customer revisit on submission of CIF' LIMIT 1];
            
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            pageRef.getParameters().put('Verified', 'True');
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.selectedValue ='PreSales';
            // controller.selectedValue ='PreSales';
            controller.primaryAccountFirstName = 'John';
            controller.primaryAccountLastName = 'Doe';
            controller.primaryAccountMobileNo = '1234567890';
            controller.primaryAccountEmail = 'john@example.com';
            controller.primaryAccountSalutation = 'Mr';
            controller.selectedPrimaryAccCountryCodeAdd = '+91';
            controller.selectedValue = testOpportunity.Walk_in_Source__c;
            controller.salesManagerName = 'Test Sales Manager';
            controller.channelStringPartnerRecordID = 'Channel123';
            controller.channelPartnerName = 'Channel Partner';
            controller.myField = 'My Field';
            controller.CountOtp = 5;
            controller.salesManagerId = testOpportunity.Sales_Manager__c;
            controller.sourcingManagerId = testOpportunity.Sourcing_Manager__c;
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
            controller.recordId = projectObject.Id;
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
            controller.selectedWalkInSourceAdd =testOpportunity.Walk_in_Source__c;
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
            controller.ProjectName = projectObject.Name;
            controller.secondarySalesManagerName = 'Secondary Manager';
            controller.secondarySalesManagerId = testOpportunity.Secondary_Sales_Manager__c;
            controller.secondarySalesManager = 'Secondary Sales';
            controller.setReadOnlyChannelPartner = 'ReadOnly';
            controller.cpFirmName ='xyz';
            controller.CPName = 'zyz';
            controller.reraNumber = accountObject.RERA_Number__c;
            controller.channelPartnerNumber='+915656565656';
            controller.referralId = testOpportunity.Referral_By_Customer__c;
            controller.referralName = 'test';
            controller.referralByCustomerId = testOpportunity.Referral_By_Customer__c;
            controller.countryCodeValue = '+91';
            controller.referralByMobileNumber = '7878787878';
            controller.makeItReadOnly = false;
            controller.referralLastName = 'Test';
            controller.referralFirstName = 'test';
            controller.referralType = 'Channel Partner';
            controller.showReferralByOther = True;
            // Set values for list properties
            controller.multiSelectBudgetValues = new List<String>{'76 lakhs - 1.25 crs', 'Under 75 lakhs'};
                controller.budgetPicklistOptions = new List<SelectOption>{new SelectOption('76 lakhs - 1.25 crs', 'Under 75 lakhs'), new SelectOption('76 lakhs - 1.25 crs', 'Under 75 lakhs')};
                    controller.projectConfigurationPicklistOptions = new List<SelectOption>{new SelectOption('Jodi', 'Jodi'), new SelectOption('Studio', 'Studio')};
                        controller.selectedBudgetPicklistValue = 'Under 75 lakhs';
            controller.accountList = accountObject;
            
            
            
            // Call the submitFirstForm method
            PageReference resultPage = controller.submitBookingForm();
            
            // Send Custom Notification
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            
            notification.setTitle('Revisit done by ' + testOpportunity.Name);
            String ProjectName = 'Test Project'; // Replace with a valid project name
            notification.setBody('Opportunity Name: ' + testOpportunity.Name + '.\n Project Name: ' + ProjectName);
            
            // Set the notification type and target
            CustomNotificationType notificationType = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'New_Opportunity' LIMIT 1];
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(testOpportunity.Id);
            Set<String> recipientIds = new Set<String>{testUserRcd1.Id};
                
                try {
                    notification.send(recipientIds);
                } catch (Exception e) {
                    System.debug('Problem sending notification: ' + e.getMessage());
                }
            
        }
        Test.stopTest();
    } 
    
    
    @isTest
    static void testDisableOtp() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            insert accountObject;
            
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            List<Opportunity> OpportunityList = new List<opportunity>();
            
            
            Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting');
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Budget1__c = 'Under 75 lakhs';
            testOpportunity.Construction_Status__c = 'RTMI';
            testOpportunity.Interested_Configuration__c = '1 BHK';
            testOpportunity.Nature_of_Use__c ='';
            testOpportunity.Source_of_Funding__c = '';
            testOpportunity.Carpet_Area_in_sq_mts__c = 89.77;
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Name = 'Test1';
            testOpportunity.StageName = 'Open';
            testOpportunity.CloseDate = system.today();
            testOpportunity.Email_Id__c = 'TEst@gmail.com';
            testOpportunity.Phone__c = '8987676568';
            testOpportunity.Project__c = projectObject.Id;
            testOpportunity.Sales_Manager__c = testUserRcd1.Id;
            testOpportunity.Date_of_Site_Visit__c = System.today();
            testOpportunity.Walk_in_Source__c = 'Channel Partner';
            testOpportunity.Last_Site_Visit_Date_CIF__c = System.today();
            insert testOpportunity;
            OpportunityList.add(testOpportunity); 
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id',projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            
            
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.selectedValue ='Website';
            controller.primaryAccountFirstName = 'John';
            controller.primaryAccountMiddleName = 'Gupta';
            controller.primaryAccountLastName = 'Doe';
            controller.primaryAccountMobileNo = accountObject.PersonMobilePhone;
            controller.primaryAccountEmail = 'john@example.com';
            controller.primaryAccountSalutation = 'Mr';
            controller.selectedPrimaryAccCountryCodeAdd = '+91';
            
            controller.salesManagerName = 'Test Sales Manager';
            controller.channelStringPartnerRecordID = 'Channel123';
            controller.channelPartnerName = 'Channel Partner';
            controller.myField = 'My Field';
            controller.CountOtp = 5;
            controller.salesManagerId = testOpportunity.Sales_Manager__c;
            
            controller.sourcingManagerId = testOpportunity.Sourcing_Manager__c;
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
            controller.recordId = projectObject.Id;
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
            controller.selectedWalkInSourceAdd = 'Referred by Others';
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
            controller.projectCarpetArea = '1000 sq. ft.';
            controller.ProjectHeader = 'Header Text';
            controller.ProjectFooter = 'Footer Text';
            controller.showHeader = true;
            controller.showFooter = true;
            controller.ProjectName = 'My Project';
            controller.secondarySalesManagerName = 'Secondary Manager';
            controller.secondarySalesManagerId = testOpportunity.Secondary_Sales_Manager__c;
            controller.secondarySalesManager = 'Secondary Sales';
            controller.setReadOnlyChannelPartner = 'ReadOnly';
            controller.cpFirmName ='xyz';
            controller.CPName = 'zyz';
            controller.reraNumber = accountObject.RERA_Number__c;
            controller.channelPartnerNumber='+915656565656';
            controller.referralId = testOpportunity.Referral_By_Customer__c;
            controller.referralName = 'test';
            controller.referralByCustomerId = testOpportunity.Referral_By_Customer__c;
            controller.countryCodeValue = '+91';
            controller.referralByMobileNumber = '7878787878';
            controller.referralLastName = 'Test';
            controller.referralFirstName = 'test';
            controller.referralType = 'Channel Partner';
            controller.showReferralByOther = True;
            
            
            // Set values for list properties
            controller.multiSelectBudgetValues = new List<String>{'Budget1', 'Budget2'};
                controller.budgetPicklistOptions = new List<SelectOption>{new SelectOption('Budget1', 'Budget 1'), new SelectOption('Budget2', 'Budget 2')};
                    controller.projectConfigurationPicklistOptions = new List<SelectOption>{new SelectOption('Jodi', 'Jodi'), new SelectOption('Studio', 'Studio')};
                        controller.selectedBudgetPicklistValue = '76 lakhs - 1.25 crs';
            controller.accountList = accountObject;
            // List<SelectOption> resultOptions = controller.getselectedCarpetAreaAddOption();
            
            
            // Call the disableOtp method.
            PageReference resultPage = controller.disableOtp();
            
            // Perform assertions to verify the behavior of the method.
            System.assertNotEquals(null, resultPage);
            // Add more assertions based on the expected behavior of your code.
        }
    }
    @isTest
    static void testSendOtpM() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.Account_Form_OTP__c = 'test';
            accountObject.PersonMobilePhone='1234567890';
            insert accountObject;
            
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            List<Opportunity> OpportunityList = new List<opportunity>();
            
            
            Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting');
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Budget1__c = 'Under 75 lakhs';
            testOpportunity.Construction_Status__c = 'RTMI';
            testOpportunity.Interested_Configuration__c = '1 BHK';
            testOpportunity.Nature_of_Use__c ='';
            testOpportunity.Source_of_Funding__c = '';
            testOpportunity.Carpet_Area_in_sq_mts__c = 89.77;
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Name = 'Test1';
            testOpportunity.StageName = 'Open';
            testOpportunity.CloseDate = system.today();
            testOpportunity.Email_Id__c = 'TEst@gmail.com';
            testOpportunity.Phone__c = '8987676568';
            testOpportunity.Project__c = projectObject.Id;
            testOpportunity.Sales_Manager__c = testUserRcd1.Id;
            testOpportunity.Date_of_Site_Visit__c = System.today();
            testOpportunity.Walk_in_Source__c = 'Channel Partner';
            insert testOpportunity;
            OpportunityList.add(testOpportunity); 
            
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            
            
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.selectedValue ='Website';
            controller.primaryAccountFirstName = 'John';
            controller.primaryAccountLastName = 'Doe';
            controller.primaryAccountMobileNo = accountObject.PersonMobilePhone;
            controller.primaryAccountEmail = 'john@example.com';
            controller.primaryAccountSalutation = 'Mr';
            controller.selectedPrimaryAccCountryCodeAdd = '+91';
            
            controller.salesManagerName = 'Test Sales Manager';
            controller.channelStringPartnerRecordID = 'Channel123';
            controller.channelPartnerName = 'Channel Partner';
            controller.myField = 'My Field';
            controller.CountOtp = 5;
            controller.salesManagerId = testOpportunity.Sales_Manager__c;
            
            controller.sourcingManagerId = testOpportunity.Sourcing_Manager__c;
            controller.sourcingManagerName = 'Sourcing Manager';
            controller.primaryAccountEmail = 'test@example.com';
            controller.cpAccountFirmName = 'CP Firm';
            controller.primaryAccountLastName = 'Doe';
            controller.primaryAccountMiddleName = 'Gupta';
            controller.primaryAccountFirstName = 'John';
            controller.primaryAccountChannelPartnerMobileNumber = '9876543210';
            controller.isPrimaryAccIndian = true;
            controller.selectedPrimaryAccAgeAdd = '26-35';
            controller.selectedPrimaryAccCountryCodeAdd ='+91';
            controller.isPrimaryAccNonIndian = false;
            controller.selectedPrimaryAccNationality = 'Indian';
            controller.submittedBy = 'User123';
            controller.recordId = projectObject.Id;
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
            controller.selectedWalkInSourceAdd = 'Loyalty';
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
            controller.projectCarpetArea = '1000 sq. ft.';
            controller.ProjectHeader = 'Header Text';
            controller.ProjectFooter = 'Footer Text';
            controller.showHeader = true;
            controller.showFooter = true;
            controller.ProjectName = 'My Project';
            controller.secondarySalesManagerName = 'Secondary Manager';
            controller.secondarySalesManagerId = testOpportunity.Secondary_Sales_Manager__c;
            controller.secondarySalesManager = 'Secondary Sales';
            controller.setReadOnlyChannelPartner = 'ReadOnly';
            controller.cpFirmName ='xyz';
            controller.CPName = 'zyz';
            controller.reraNumber = accountObject.RERA_Number__c;
            controller.channelPartnerNumber='+915656565656';
            controller.referralId = testOpportunity.Referral_By_Customer__c;
            controller.referralName = 'test';
            controller.referralByCustomerId = testOpportunity.Referral_By_Customer__c;
            controller.countryCodeValue = '+91';
            controller.referralByMobileNumber = '7878787878';
            controller.referralLastName = 'Test';
            controller.referralFirstName = 'test';
            controller.referralType = 'Channel Partner';
            controller.showReferralByOther = True;
            
            
            // Set values for list properties
            controller.multiSelectBudgetValues = new List<String>{'Budget1', 'Budget2'};
                controller.budgetPicklistOptions = new List<SelectOption>{new SelectOption('Budget1', 'Budget 1'), new SelectOption('Budget2', 'Budget 2')};
                    controller.projectConfigurationPicklistOptions = new List<SelectOption>{new SelectOption('Jodi', 'Jodi'), new SelectOption('Studio', 'Studio')};
                        controller.selectedBudgetPicklistValue = '76 lakhs - 1.25 crs';
            controller.accountList = accountObject;
            // List<SelectOption> resultOptions = controller.getselectedCarpetAreaAddOption();
            
            
            Test.startTest();
            controller.sendOtpM();
            Test.stopTest();
            
            
            
            Account updatedAccount = [SELECT Id, Account_Form_OTP__c FROM Account WHERE Id = :accountObject.Id];
            
            // Verify that the Account_Form_OTP__c field is updated
            System.assertEquals(true, !String.isBlank(updatedAccount.Account_Form_OTP__c), 'OTP should be updated.');
        }
        
        
    }
    @isTest
    static void testGetselectedReferralTypeAddOption() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            insert accountObject;
            
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            List<Opportunity> OpportunityList = new List<opportunity>();
            
            
            Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting');
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Budget1__c = 'Under 75 lakhs';
            testOpportunity.Construction_Status__c = 'RTMI';
            testOpportunity.Interested_Configuration__c = '1 BHK';
            testOpportunity.Nature_of_Use__c ='';
            testOpportunity.Source_of_Funding__c = '';
            testOpportunity.Carpet_Area_in_sq_mts__c = 89.77;
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Name = 'Test1';
            testOpportunity.StageName = 'Open';
            testOpportunity.CloseDate = system.today();
            testOpportunity.Email_Id__c = 'TEst@gmail.com';
            testOpportunity.Phone__c = '8987676568';
            testOpportunity.Project__c = projectObject.Id;
            testOpportunity.Sales_Manager__c = testUserRcd1.Id;
            testOpportunity.Date_of_Site_Visit__c = System.today();
            testOpportunity.Walk_in_Source__c = 'Channel Partner';
            insert testOpportunity;
            OpportunityList.add(testOpportunity); 
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            
            
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.selectedValue ='Website';
            controller.primaryAccountFirstName = 'John';
            controller.primaryAccountLastName = 'Doe';
            controller.primaryAccountMobileNo = accountObject.PersonMobilePhone;
            controller.primaryAccountEmail = 'john@example.com';
            controller.primaryAccountSalutation = 'Mr';
            controller.selectedPrimaryAccCountryCodeAdd = '+91';
            
            controller.salesManagerName = 'Test Sales Manager';
            controller.channelStringPartnerRecordID = 'Channel123';
            controller.channelPartnerName = 'Channel Partner';
            controller.myField = 'My Field';
            controller.CountOtp = 5;
            controller.salesManagerId = testOpportunity.Sales_Manager__c;
            
            controller.sourcingManagerId = testOpportunity.Sourcing_Manager__c;
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
            controller.recordId = projectObject.Id;
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
            controller.selectedWalkInSourceAdd = 'Loyalty';
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
            controller.projectCarpetArea = '1000 sq. ft.';
            controller.ProjectHeader = 'Header Text';
            controller.ProjectFooter = 'Footer Text';
            controller.showHeader = true;
            controller.showFooter = true;
            controller.ProjectName = 'My Project';
            controller.secondarySalesManagerName = 'Secondary Manager';
            controller.secondarySalesManagerId = testOpportunity.Secondary_Sales_Manager__c;
            controller.secondarySalesManager = 'Secondary Sales';
            controller.setReadOnlyChannelPartner = 'ReadOnly';
            controller.cpFirmName ='xyz';
            controller.CPName = 'zyz';
            controller.reraNumber = accountObject.RERA_Number__c;
            controller.channelPartnerNumber='+915656565656';
            controller.referralId = testOpportunity.Referral_By_Customer__c;
            controller.referralName = 'test';
            controller.referralByCustomerId = testOpportunity.Referral_By_Customer__c;
            controller.countryCodeValue = '+91';
            controller.referralByMobileNumber = '7878787878';
            controller.referralLastName = 'Test';
            controller.referralFirstName = 'test';
            controller.referralType = 'Channel Partner';
            controller.showReferralByOther = True;
            
            
            // Set values for list properties
            controller.multiSelectBudgetValues = new List<String>{'Budget1', 'Budget2'};
                controller.budgetPicklistOptions = new List<SelectOption>{new SelectOption('Budget1', 'Budget 1'), new SelectOption('Budget2', 'Budget 2')};
                    controller.projectConfigurationPicklistOptions = new List<SelectOption>{new SelectOption('Jodi', 'Jodi'), new SelectOption('Studio', 'Studio')};
                        controller.selectedBudgetPicklistValue = '76 lakhs - 1.25 crs';
            controller.accountList = accountObject;
            //  List<SelectOption> resultOptions = controller.getselectedCarpetAreaAddOption();
            
            // Call the getselectedReferralTypeAddOption method
            List<SelectOption> options = controller.getselectedReferralTypeAddOption();
            
        }
    }
    
    @isTest
    static void testGetselectedWalkInSourceAddOption() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            insert accountObject;
            
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            List<Opportunity> OpportunityList = new List<opportunity>();
            
            
            Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting');
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Budget1__c = 'Under 75 lakhs';
            testOpportunity.Construction_Status__c = 'RTMI';
            testOpportunity.Interested_Configuration__c = '1 BHK';
            testOpportunity.Nature_of_Use__c ='';
            testOpportunity.Source_of_Funding__c = '';
            testOpportunity.Carpet_Area_in_sq_mts__c = 89.77;
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Name = 'Test1';
            testOpportunity.StageName = 'Open';
            testOpportunity.CloseDate = system.today();
            testOpportunity.Email_Id__c = 'TEst@gmail.com';
            testOpportunity.Phone__c = '8987676568';
            testOpportunity.Project__c = projectObject.Id;
            testOpportunity.Sales_Manager__c = testUserRcd1.Id;
            testOpportunity.Date_of_Site_Visit__c = System.today();
            testOpportunity.Walk_in_Source__c = 'Channel Partner';
            insert testOpportunity;
            OpportunityList.add(testOpportunity); 
            
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            
            
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.selectedValue ='Website';
            controller.primaryAccountFirstName = 'John';
            controller.primaryAccountLastName = 'Doe';
            controller.primaryAccountMobileNo = accountObject.PersonMobilePhone;
            controller.primaryAccountEmail = 'john@example.com';
            controller.primaryAccountSalutation = 'Mr';
            controller.selectedPrimaryAccCountryCodeAdd = '+91';
            
            controller.salesManagerName = 'Test Sales Manager';
            controller.channelStringPartnerRecordID = 'Channel123';
            controller.channelPartnerName = 'Channel Partner';
            controller.myField = 'My Field';
            controller.CountOtp = 5;
            controller.salesManagerId = testOpportunity.Sales_Manager__c;
            
            controller.sourcingManagerId = testOpportunity.Sourcing_Manager__c;
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
            controller.recordId = projectObject.Id;
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
            controller.selectedWalkInSourceAdd = 'Loyalty';
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
            controller.projectCarpetArea = '1000 sq. ft.';
            controller.ProjectHeader = 'Header Text';
            controller.ProjectFooter = 'Footer Text';
            controller.showHeader = true;
            controller.showFooter = true;
            controller.ProjectName = 'My Project';
            controller.secondarySalesManagerName = 'Secondary Manager';
            controller.secondarySalesManagerId = testOpportunity.Secondary_Sales_Manager__c;
            controller.secondarySalesManager = 'Secondary Sales';
            controller.setReadOnlyChannelPartner = 'ReadOnly';
            controller.cpFirmName ='xyz';
            controller.CPName = 'zyz';
            controller.reraNumber = accountObject.RERA_Number__c;
            controller.channelPartnerNumber='+915656565656';
            controller.referralId = testOpportunity.Referral_By_Customer__c;
            controller.referralName = 'test';
            controller.referralByCustomerId = testOpportunity.Referral_By_Customer__c;
            controller.countryCodeValue = '+91';
            controller.referralByMobileNumber = '7878787878';
            controller.referralLastName = 'Test';
            controller.referralFirstName = 'test';
            controller.referralType = 'Channel Partner';
            controller.showReferralByOther = True;
            
            
            // Set values for list properties
            controller.multiSelectBudgetValues = new List<String>{'Budget1', 'Budget2'};
                controller.budgetPicklistOptions = new List<SelectOption>{new SelectOption('Budget1', 'Budget 1'), new SelectOption('Budget2', 'Budget 2')};
                    controller.projectConfigurationPicklistOptions = new List<SelectOption>{new SelectOption('Jodi', 'Jodi'), new SelectOption('Studio', 'Studio')};
                        controller.selectedBudgetPicklistValue = '76 lakhs - 1.25 crs';
            controller.accountList = accountObject;            
            List<List<SelectOption>> options = controller.getselectedWalkInSourceAddOption();
        }
    }
    @isTest
    static void testGetEmploymentTypeOption() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            insert accountObject;
            
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            List<Opportunity> OpportunityList = new List<opportunity>();
            
            
            Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting');
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Budget1__c = 'Under 75 lakhs';
            testOpportunity.Construction_Status__c = 'RTMI';
            testOpportunity.Interested_Configuration__c = '1 BHK';
            testOpportunity.Nature_of_Use__c ='';
            testOpportunity.Source_of_Funding__c = '';
            testOpportunity.Carpet_Area_in_sq_mts__c = 89.77;
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Name = 'Test1';
            testOpportunity.StageName = 'Open';
            testOpportunity.CloseDate = system.today();
            testOpportunity.Email_Id__c = 'TEst@gmail.com';
            testOpportunity.Phone__c = '8987676568';
            testOpportunity.Project__c = projectObject.Id;
            testOpportunity.Sales_Manager__c = testUserRcd1.Id;
            testOpportunity.Date_of_Site_Visit__c = System.today();
            testOpportunity.Walk_in_Source__c = 'Channel Partner';
            insert testOpportunity;
            OpportunityList.add(testOpportunity); 
            
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            
            
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.selectedValue ='Website';
            controller.primaryAccountFirstName = 'John';
            controller.primaryAccountLastName = 'Doe';
            controller.primaryAccountMobileNo = accountObject.PersonMobilePhone;
            controller.primaryAccountEmail = 'john@example.com';
            controller.primaryAccountSalutation = 'Mr';
            controller.selectedPrimaryAccCountryCodeAdd = '+91';
            
            controller.salesManagerName = 'Test Sales Manager';
            controller.channelStringPartnerRecordID = 'Channel123';
            controller.channelPartnerName = 'Channel Partner';
            controller.myField = 'My Field';
            controller.CountOtp = 5;
            controller.salesManagerId = testOpportunity.Sales_Manager__c;
            
            controller.sourcingManagerId = testOpportunity.Sourcing_Manager__c;
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
            controller.recordId = projectObject.Id;
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
            controller.selectedWalkInSourceAdd = 'Loyalty';
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
            controller.projectCarpetArea = '1000 sq. ft.';
            controller.ProjectHeader = 'Header Text';
            controller.ProjectFooter = 'Footer Text';
            controller.showHeader = true;
            controller.showFooter = true;
            controller.ProjectName = 'My Project';
            controller.secondarySalesManagerName = 'Secondary Manager';
            controller.secondarySalesManagerId = testOpportunity.Secondary_Sales_Manager__c;
            controller.secondarySalesManager = 'Secondary Sales';
            controller.setReadOnlyChannelPartner = 'ReadOnly';
            controller.cpFirmName ='xyz';
            controller.CPName = 'zyz';
            controller.reraNumber = accountObject.RERA_Number__c;
            controller.channelPartnerNumber='+915656565656';
            controller.referralId = testOpportunity.Referral_By_Customer__c;
            controller.referralName = 'test';
            controller.referralByCustomerId = testOpportunity.Referral_By_Customer__c;
            controller.countryCodeValue = '+91';
            controller.referralByMobileNumber = '7878787878';
            controller.referralLastName = 'Test';
            controller.referralFirstName = 'test';
            controller.referralType = 'Channel Partner';
            controller.showReferralByOther = True;
            
            
            // Set values for list properties
            controller.multiSelectBudgetValues = new List<String>{'Budget1', 'Budget2'};
                controller.budgetPicklistOptions = new List<SelectOption>{new SelectOption('Budget1', 'Budget 1'), new SelectOption('Budget2', 'Budget 2')};
                    controller.projectConfigurationPicklistOptions = new List<SelectOption>{new SelectOption('Jodi', 'Jodi'), new SelectOption('Studio', 'Studio')};
                        controller.selectedBudgetPicklistValue = '76 lakhs - 1.25 crs';
            controller.accountList = accountObject;
            
            List<SelectOption> options = controller.getEmploymentTypeOption();
        }
    }
    @isTest
    static void testOtpVerificationSuccess() {
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.Account_Form_OTP__c = '56565';
            accountObject.PersonMobilePhone='1234567890';
            insert accountObject;
            List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
            
            CIF_Form__c cifFormObject = new CIF_Form__c();
            cifFormObject.Name = 'Test11 CIF Form';
            cifFormObject.Disable_Till__c = System.now().addDays(1);
            cifFormObject.Disable_Time__c = 10.2;
            cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
            insert cifFormObject;
            cifForm.add(cifFormObject); 
            
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            List<Opportunity> OpportunityList = new List<opportunity>();
            
            
            Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting');
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Budget1__c = 'Under 75 lakhs';
            testOpportunity.Construction_Status__c = 'RTMI';
            testOpportunity.Interested_Configuration__c = '1 BHK';
            testOpportunity.Nature_of_Use__c ='';
            testOpportunity.Source_of_Funding__c = '';
            testOpportunity.Carpet_Area_in_sq_mts__c = 89.77;
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Name = 'Test1';
            testOpportunity.StageName = 'Open';
            testOpportunity.CloseDate = system.today();
            testOpportunity.Email_Id__c = 'TEst@gmail.com';
            testOpportunity.Phone__c = '8987676568';
            testOpportunity.Project__c = projectObject.Id;
            testOpportunity.Sales_Manager__c = testUserRcd1.Id;
            testOpportunity.Date_of_Site_Visit__c = System.today();
            testOpportunity.Walk_in_Source__c = 'Channel Partner';
            insert testOpportunity;
            OpportunityList.add(testOpportunity); 
            
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            
            
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.selectedValue ='Website';
            controller.primaryAccountFirstName = 'John';
            controller.primaryAccountLastName = 'Doe';
            controller.primaryAccountMobileNo = accountObject.PersonMobilePhone;
            controller.primaryAccountEmail = 'john@example.com';
            controller.primaryAccountSalutation = 'Mr';
            controller.selectedPrimaryAccCountryCodeAdd = '+91';
            
            controller.salesManagerName = 'Test Sales Manager';
            controller.channelStringPartnerRecordID = 'Channel123';
            controller.channelPartnerName = 'Channel Partner';
            controller.myField = 'My Field';
            controller.CountOtp = 5;
            controller.salesManagerId = testOpportunity.Sales_Manager__c;
            
            controller.sourcingManagerId = testOpportunity.Sourcing_Manager__c;
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
            controller.recordId = projectObject.Id;
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
            controller.selectedWalkInSourceAdd = 'Loyalty';
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
            controller.projectCarpetArea = '1000 sq. ft.';
            controller.ProjectHeader = 'Header Text';
            controller.ProjectFooter = 'Footer Text';
            controller.showHeader = true;
            controller.showFooter = true;
            controller.ProjectName = 'My Project';
            controller.secondarySalesManagerName = 'Secondary Manager';
            controller.secondarySalesManagerId = testOpportunity.Secondary_Sales_Manager__c;
            controller.secondarySalesManager = 'Secondary Sales';
            controller.setReadOnlyChannelPartner = 'ReadOnly';
            controller.cpFirmName ='xyz';
            controller.CPName = 'zyz';
            controller.reraNumber = accountObject.RERA_Number__c;
            controller.channelPartnerNumber='+915656565656';
            controller.referralId = testOpportunity.Referral_By_Customer__c;
            controller.referralName = 'test';
            controller.referralByCustomerId = testOpportunity.Referral_By_Customer__c;
            controller.countryCodeValue = '+91';
            controller.referralByMobileNumber = '7878787878';
            controller.referralLastName = 'Test';
            controller.referralFirstName = 'test';
            controller.referralType = 'Channel Partner';
            controller.showReferralByOther = True;
            
            
            // Set values for list properties
            controller.multiSelectBudgetValues = new List<String>{'Budget1', 'Budget2'};
                controller.budgetPicklistOptions = new List<SelectOption>{new SelectOption('Budget1', 'Budget 1'), new SelectOption('Budget2', 'Budget 2')};
                    controller.projectConfigurationPicklistOptions = new List<SelectOption>{new SelectOption('Jodi', 'Jodi'), new SelectOption('Studio', 'Studio')};
                        controller.selectedBudgetPicklistValue = '76 lakhs - 1.25 crs';
            controller.accountList = accountObject;
            
            
            PageReference result = controller.verifyOtp();
            
        }
    }
    @isTest
    static void testOtpVerificationFailure() {
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            accountObject.Account_Form_OTP__c = '56565';
            insert accountObject;
            List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
            
            CIF_Form__c cifFormObject = new CIF_Form__c();
            cifFormObject.Name = 'Test11 CIF Form';
            cifFormObject.Disable_Till__c = System.now().addDays(1);
            cifFormObject.Disable_Time__c = 10.2;
            cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
            insert cifFormObject;
            
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            List<Opportunity> OpportunityList = new List<opportunity>();
            
            
            Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity', StageName = 'Site Visit');
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Budget1__c = 'Under 75 lakhs';
            testOpportunity.Construction_Status__c = 'RTMI';
            testOpportunity.Interested_Configuration__c = '1 BHK';
            testOpportunity.Nature_of_Use__c ='';
            testOpportunity.Source_of_Funding__c = '';
            testOpportunity.Carpet_Area_in_sq_mts__c = 89.77;
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Name = 'Test1';
            testOpportunity.StageName = 'Open';
            testOpportunity.CloseDate = system.today();
            testOpportunity.Email_Id__c = 'TEst@gmail.com';
            testOpportunity.Phone__c = '8987676568';
            testOpportunity.Project__c = projectObject.Id;
            testOpportunity.Sales_Manager__c = testUserRcd1.Id;
            testOpportunity.Date_of_Site_Visit__c = System.today();
            testOpportunity.Walk_in_Source__c = 'Channel Partner';
            insert testOpportunity;
            
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            
            
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.selectedValue ='Website';
            controller.primaryAccountFirstName = 'John';
            controller.primaryAccountLastName = 'Doe';
            controller.primaryAccountMobileNo = accountObject.PersonMobilePhone;
            controller.primaryAccountEmail = 'john@example.com';
            controller.primaryAccountSalutation = 'Mr';
            controller.selectedPrimaryAccCountryCodeAdd = '+91';
            controller.isAgreeWithTermsConditions = true;
            controller.salesManagerName = 'Test Sales Manager';
            controller.channelStringPartnerRecordID = 'Channel123';
            controller.channelPartnerName = 'Channel Partner';
            controller.myField = 'My Field';
            controller.CountOtp = 5;
            controller.salesManagerId = testOpportunity.Sales_Manager__c;
            
            controller.sourcingManagerId = testOpportunity.Sourcing_Manager__c;
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
            controller.recordId = projectObject.Id;
            controller.otpCode = '56565';
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
            controller.selectedWalkInSourceAdd = 'Loyalty';
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
            controller.projectCarpetArea = '1000 sq. ft.';
            controller.ProjectHeader = 'Header Text';
            controller.ProjectFooter = 'Footer Text';
            controller.showHeader = true;
            controller.showFooter = true;
            controller.ProjectName = 'My Project';
            controller.secondarySalesManagerName = 'Secondary Manager';
            controller.secondarySalesManagerId = testOpportunity.Secondary_Sales_Manager__c;
            controller.secondarySalesManager = 'Secondary Sales';
            controller.setReadOnlyChannelPartner = 'ReadOnly';
            controller.cpFirmName ='xyz';
            controller.CPName = 'zyz';
            controller.reraNumber = accountObject.RERA_Number__c;
            controller.channelPartnerNumber='+915656565656';
            controller.referralId = testOpportunity.Referral_By_Customer__c;
            controller.referralName = 'test';
            controller.referralByCustomerId = testOpportunity.Referral_By_Customer__c;
            controller.countryCodeValue = '+91';
            controller.referralByMobileNumber = '7878787878';
            controller.referralLastName = 'Test';
            controller.referralFirstName = 'test';
            controller.referralType = 'Channel Partner';
            controller.showReferralByOther = True;
            
            
            // Set values for list properties
            controller.multiSelectBudgetValues = new List<String>{'Budget1', 'Budget2'};
                controller.budgetPicklistOptions = new List<SelectOption>{new SelectOption('Budget1', 'Budget 1'), new SelectOption('Budget2', 'Budget 2')};
                    controller.projectConfigurationPicklistOptions = new List<SelectOption>{new SelectOption('Jodi', 'Jodi'), new SelectOption('Studio', 'Studio')};
                        controller.selectedBudgetPicklistValue = '76 lakhs - 1.25 crs';
            controller.accountList = accountObject;
            PageReference result = controller.verifyOtp();
        }
    }
    
    @isTest
    static void testSubmitBookingFormValidation() {
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            accountObject.Account_Form_OTP__c = '56565';
            insert accountObject;
            List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
            
            CIF_Form__c cifFormObject = new CIF_Form__c();
            cifFormObject.Name = 'Test11 CIF Form';
            cifFormObject.Disable_Till__c = System.now().addDays(1);
            cifFormObject.Disable_Time__c = 10.2;
            cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
            insert cifFormObject;
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting');
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Budget1__c = 'Under 75 lakhs';
            testOpportunity.Construction_Status__c = 'RTMI';
            testOpportunity.Interested_Configuration__c = '1 BHK';
            testOpportunity.Nature_of_Use__c ='';
            testOpportunity.Source_of_Funding__c = '';
            testOpportunity.Carpet_Area_in_sq_mts__c = 89.77;
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Name = 'Test1';
            testOpportunity.StageName = 'Open';
            testOpportunity.CloseDate = system.today();
            testOpportunity.Email_Id__c = 'TEst@gmail.com';
            testOpportunity.Phone__c = '8987676568';
            testOpportunity.Project__c = projectObject.Id;
            testOpportunity.Sales_Manager__c = testUserRcd1.Id;
            testOpportunity.Date_of_Site_Visit__c = System.today();
            testOpportunity.Walk_in_Source__c = 'Channel Partner';
            insert testOpportunity;
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id',projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.selectedValue ='Website';
            controller.primaryAccountFirstName = 'New';
            controller.primaryAccountLastName = 'Account';
            controller.primaryAccountMobileNo = '4654659754';
            controller.primaryAccountEmail = '';
            controller.primaryAccountSalutation = 'Mr.';
            controller.selectedPrimaryAccCountryCodeAdd = '+91';
            
            controller.salesManagerName = 'Test Sales Manager';
            controller.channelStringPartnerRecordID = 'Channel123';
            controller.channelPartnerName = 'Channel Partner';
            controller.myField = 'My Field';
            controller.CountOtp = 5;
            controller.salesManagerId = testOpportunity.Sales_Manager__c;
            controller.selectedPrimaryAccCountryCodeAdd = '+11';
            controller.sourcingManagerId = testOpportunity.Sourcing_Manager__c;
            controller.sourcingManagerName = 'Sourcing Manager';
            controller.primaryAccountEmail = 'test@example.com';
            controller.cpAccountFirmName = 'CP Firm';
            controller.primaryAccountLastName = '';
            controller.primaryAccountFirstName = '';
            controller.primaryAccountChannelPartnerMobileNumber = '9876543210';
            controller.isPrimaryAccIndian = true;
            controller.selectedPrimaryAccAgeAdd = '26-35';
            controller.selectedPrimaryAccCountryCodeAdd ='+91';
            controller.isPrimaryAccNonIndian = false;
            controller.selectedPrimaryAccNationality = 'Indian';
            controller.submittedBy = 'User123';
            controller.recordId = projectObject.Id;
            controller.otpCode = '56565';
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
            controller.selectedWalkInSourceAdd = 'Loyalty';
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
            controller.projectCarpetArea = '1000 sq. ft.';
            controller.ProjectHeader = 'Header Text';
            controller.ProjectFooter = 'Footer Text';
            controller.showHeader = true;
            controller.showFooter = true;
            controller.ProjectName = 'My Project';
            controller.secondarySalesManagerName = 'Secondary Manager';
            controller.secondarySalesManagerId = testOpportunity.Secondary_Sales_Manager__c;
            controller.secondarySalesManager = 'Secondary Sales';
            controller.setReadOnlyChannelPartner = 'ReadOnly';
            controller.cpFirmName ='xyz';
            controller.CPName = 'zyz';
            controller.reraNumber = accountObject.RERA_Number__c;
            controller.channelPartnerNumber='+915656565656';
            controller.referralId = testOpportunity.Referral_By_Customer__c;
            controller.referralName = 'test';
            controller.referralByCustomerId = testOpportunity.Referral_By_Customer__c;
            controller.countryCodeValue = '+91';
            controller.referralByMobileNumber = '7878787878';
            controller.referralLastName = 'Test';
            controller.referralFirstName = 'test';
            controller.referralType = 'Channel Partner';
            controller.showReferralByOther = True;
            
            // Call the submitBookingForm method
            PageReference result = controller.submitFirstForm();
        }
    }
    @isTest
    static void testBookingForm() {
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            accountObject.Account_Form_OTP__c = '56565';
            insert accountObject;
            List<CIF_Form__c> cifFormlist = [SELECT Id FROM CIF_Form__c];
            
            CIF_Form__c cifFormObject = new CIF_Form__c();
            cifFormObject.Name = 'Test11 CIF Form';
            cifFormObject.Disable_Till__c = System.now().addDays(1);
            cifFormObject.Disable_Time__c = 10.2;
            cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
            insert cifFormObject;
            cifFormlist.add(cifFormObject); 
            
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            insert testCampRcd;
            
            
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c = accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Google';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='1234567890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            testEnqRcd.Site_Visit_Done_Date__c = system.now();
            testEnqRcd.Stage__c = 'Interested';
            testEnqRcd.Construction_Status__c = 'RTMI';
            testEnqRcd.Configuration__c = '1 BHK';
            //testEnqRcd.Enquiry_Sub_Source__c = 'TOI';
            insert testEnqRcd;
            
            Opportunity oppObject = new Opportunity();
            oppObject.Name = 'Oppo';
            oppObject.Project__c = projectObject.Id;
            oppObject.No_of_Total_Visits__c = 5;
            oppObject.OTP_Submission_Date__c = System.today();
            oppObject.OTP_Submitted__c = '56654';
            oppObject.Linked_Enquiry__c = testEnqRcd.Id;
            oppObject.AccountId = accountObject.Id;
            oppObject.CloseDate = system.today();
            oppObject.Walk_in_Source__c = 'Channel Partner';
            oppObject.StageName = 'In Progress';
            insert oppObject;
            
            Task_Target__c taskTarget =  new Task_Target__c();
            taskTarget.User__c = testUserRcd1.Id;
            taskTarget.Month__c = 'December';
            taskTarget.Year__c = '2023';
            taskTarget.Type__c = 'Customer Walk In(CP)';
            taskTarget.Number_of_Targets_Achievement__c = 5;
            taskTarget.Number_of_Connected_Call__c = 8;
            taskTarget.X1st_Week__c =1;
            taskTarget.X2nd_Week__c =2;
            taskTarget.X3rd_Week__c = 3;
            taskTarget.X4th_Week__c = 4;
            taskTarget.X5th_Week__c = 5;
            taskTarget.Project__c = projectObject.Id;
            taskTarget.No_of_Walk_ins__c = 5;
            taskTarget.No_of_Follow_Ups__c = 2;
            taskTarget.Number_of_Targets__c = 6;
            insert taskTarget;
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.primaryAccountLastName = '';
            controller.primaryAccountFirstName = '';
            controller.primaryAccountMobileNo = '';
            controller.primaryAccMailingAddCity = '';
            controller.primaryAccMailingAddStreet = '';
            controller.primaryAccMailingAddPostalCode = '';
            controller.locality = '';
            controller.apartmentFlat = '';
            controller.primaryAccMailingAddState = '';
            controller.primaryAccMailingAddCountry = '';
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedPrimaryAccAgeAdd = null;
            controller.selectedBudgetPicklistValue = '';
            controller.selectedEmploymentType = '';
            controller.channelStringPartnerRecordID = '';
            controller.selectedWalkInSourceAdd = '';
            controller.myField = 'myField';
            controller.UnregisteredCP = true;
            controller.CPName = '';
            controller.cpFirmName = '';
            controller.salesManagerId = '';
            controller.sourcingManagerId = null;
            controller.sourcingManagerId = '';
            controller.channelStringPartnerRecordID = null;
            controller.channelPartnerNumber = '';
            controller.selectedSourceOfFundingStatus = null;
            controller.primaryAccountMobileNo = ''; // This is an example for a valid mobile number
            controller.selectedconstructionStatusAdd = null;
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedNatureInUseAdd = null;
            controller.referralByCustomerId = null;
            controller.selectedWalkInSourceAdd = 'Channel Partner';
            controller.referralType = null;
            controller.referralFirstName = '';
            controller.referralLastName = null;
            controller.countryCodeValue = '';
            controller.selectedPrimaryAccCountryCodeAdd = '';
            controller.primaryAccountSalutation = '';
            controller.primaryAccountEmail = '';
            
            // Call the submitBookingForm method
            PageReference result = controller.submitBookingForm();
        }
    }
    @isTest
    public  static void testGetSelectedPrimaryAccNationalityOptions() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        cifForm.add(cifFormObject); 
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            accountObject.Account_Form_OTP__c = '56565';
            insert accountObject;
            List<CIF_Form__c> cifFormlist = [SELECT Id FROM CIF_Form__c];
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            list<Opportunity> OpportunityList = new list<Opportunity>();
            Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting');
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Budget1__c = 'Under 75 lakhs';
            testOpportunity.Construction_Status__c = 'RTMI';
            testOpportunity.Interested_Configuration__c = '1 BHK';
            testOpportunity.Nature_of_Use__c ='';
            testOpportunity.Source_of_Funding__c = '';
            testOpportunity.Carpet_Area_in_sq_mts__c = 89.77;
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Name = 'Test1';
            testOpportunity.StageName = 'Open';
            testOpportunity.CloseDate = system.today();
            testOpportunity.Email_Id__c = 'TEst@gmail.com';
            testOpportunity.Phone__c = '8987676568';
            testOpportunity.Project__c = projectObject.Id;
            testOpportunity.Sales_Manager__c = testUserRcd1.Id;
            testOpportunity.Date_of_Site_Visit__c = System.today();
            testOpportunity.Walk_in_Source__c = 'Referred by Existing Customer';
            testOpportunity.Referral_Name__c='john doe';
            testOpportunity.Referral_By_Customer__c = accountObject.Id;
            insert testOpportunity;
            OpportunityList.add(testOpportunity); 
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.primaryAccountLastName = '';
            controller.primaryAccountFirstName = '';
            controller.primaryAccountMobileNo = '';
            controller.primaryAccMailingAddCity = '';
            controller.primaryAccMailingAddStreet = '';
            controller.primaryAccMailingAddPostalCode = '';
            controller.locality = '';
            controller.apartmentFlat = '';
            controller.primaryAccMailingAddState = '';
            controller.primaryAccMailingAddCountry = '';
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedPrimaryAccAgeAdd = null;
            controller.selectedBudgetPicklistValue = '';
            controller.selectedEmploymentType = '';
            controller.selectedWalkInSourceAdd = '';
            controller.myField = '';
            controller.UnregisteredCP = true;
            controller.CPName = '';
            controller.cpFirmName = '';
            controller.salesManagerId = '';
            controller.sourcingManagerId = null;
            controller.channelStringPartnerRecordID = null;
            controller.channelPartnerNumber = '';
            controller.selectedSourceOfFundingStatus = null;
            controller.primaryAccountMobileNo = ''; // This is an example for a valid mobile number
            controller.selectedconstructionStatusAdd = null;
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedNatureInUseAdd = null;
            controller.referralByCustomerId = null;
            controller.selectedWalkInSourceAdd = 'Referred by Existing Customer';
            controller.referralType = null;
            
            controller.referralFirstName = 'john df';
            controller.referralLastName = 'doe f';
            controller.countryCodeValue = '';
            controller.selectedPrimaryAccCountryCodeAdd = '';
            controller.primaryAccountSalutation = '';
            controller.primaryAccountEmail = '';
            
            List<SelectOption> options = controller.getselectedPrimaryAccNationalityOptions();
        }
    }
    @isTest
    static void testGetselectedPrimaryAccAgeAddOption() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        cifForm.add(cifFormObject); 
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            accountObject.Account_Form_OTP__c = '56565';
            insert accountObject;
            List<CIF_Form__c> cifFormlist = [SELECT Id FROM CIF_Form__c];
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.primaryAccountLastName = '';
            controller.primaryAccountFirstName = '';
            controller.primaryAccountMobileNo = '';
            controller.primaryAccMailingAddCity = '';
            controller.primaryAccMailingAddStreet = '';
            controller.primaryAccMailingAddPostalCode = '';
            controller.locality = '';
            controller.apartmentFlat = '';
            controller.primaryAccMailingAddState = '';
            controller.primaryAccMailingAddCountry = '';
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedPrimaryAccAgeAdd = null;
            controller.selectedBudgetPicklistValue = '';
            controller.selectedEmploymentType = '';
            controller.selectedWalkInSourceAdd = '';
            controller.myField = '';
            controller.UnregisteredCP = true;
            controller.CPName = '';
            controller.cpFirmName = '';
            controller.salesManagerId = '';
            controller.sourcingManagerId = null;
            controller.channelStringPartnerRecordID = null;
            controller.channelPartnerNumber = '';
            controller.selectedSourceOfFundingStatus = null;
            controller.primaryAccountMobileNo = ''; // This is an example for a valid mobile number
            controller.selectedconstructionStatusAdd = null;
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedNatureInUseAdd = null;
            controller.referralByCustomerId = null;
            controller.selectedWalkInSourceAdd = 'Referred by Existing Customer';
            controller.referralType = null;
            controller.referralFirstName = '';
            controller.referralLastName = null;
            controller.countryCodeValue = '';
            controller.selectedPrimaryAccCountryCodeAdd = '';
            controller.primaryAccountSalutation = '';
            controller.primaryAccountEmail = '';
            
            List<SelectOption> options = controller.getselectedPrimaryAccAgeAddOption();
        }
    }
    @isTest
    static void testGetselectedPrimaryAccCountryCodeAddOption() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        cifForm.add(cifFormObject); 
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            accountObject.Account_Form_OTP__c = '56565';
            insert accountObject;
            List<CIF_Form__c> cifFormlist = [SELECT Id FROM CIF_Form__c];
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.primaryAccountLastName = '';
            controller.primaryAccountFirstName = '';
            controller.primaryAccountMobileNo = '';
            controller.primaryAccMailingAddCity = '';
            controller.primaryAccMailingAddStreet = '';
            controller.primaryAccMailingAddPostalCode = '';
            controller.locality = '';
            controller.apartmentFlat = '';
            controller.primaryAccMailingAddState = '';
            controller.primaryAccMailingAddCountry = '';
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedPrimaryAccAgeAdd = null;
            controller.selectedBudgetPicklistValue = '';
            controller.selectedEmploymentType = '';
            controller.selectedWalkInSourceAdd = '';
            controller.myField = '';
            controller.UnregisteredCP = true;
            controller.CPName = '';
            controller.cpFirmName = '';
            controller.salesManagerId = '';
            controller.sourcingManagerId = null;
            controller.channelStringPartnerRecordID = null;
            controller.channelPartnerNumber = '';
            controller.selectedSourceOfFundingStatus = null;
            controller.primaryAccountMobileNo = ''; // This is an example for a valid mobile number
            controller.selectedconstructionStatusAdd = null;
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedNatureInUseAdd = null;
            controller.referralByCustomerId = null;
            controller.selectedWalkInSourceAdd = 'Referred by Existing Customer';
            controller.referralType = null;
            controller.referralFirstName = '';
            controller.referralLastName = null;
            controller.countryCodeValue = '';
            controller.selectedPrimaryAccCountryCodeAdd = '';
            controller.primaryAccountSalutation = '';
            controller.primaryAccountEmail = '';
            
            List<SelectOption> options = controller.getselectedPrimaryAccCountryCodeAddOption();
        } 
    }
    @isTest
    static void testGetselectedPrimaryAccMaitalStatusAddOption() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        cifForm.add(cifFormObject); 
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            accountObject.Account_Form_OTP__c = '56565';
            insert accountObject;
            List<CIF_Form__c> cifFormlist = [SELECT Id FROM CIF_Form__c];
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.primaryAccountLastName = '';
            controller.primaryAccountFirstName = '';
            controller.primaryAccountMobileNo = '';
            controller.primaryAccMailingAddCity = '';
            controller.primaryAccMailingAddStreet = '';
            controller.primaryAccMailingAddPostalCode = '';
            controller.locality = '';
            controller.apartmentFlat = '';
            controller.primaryAccMailingAddState = '';
            controller.primaryAccMailingAddCountry = '';
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedPrimaryAccAgeAdd = null;
            controller.selectedBudgetPicklistValue = '';
            controller.selectedEmploymentType = '';
            controller.selectedWalkInSourceAdd = '';
            controller.myField = '';
            controller.UnregisteredCP = true;
            controller.CPName = '';
            controller.cpFirmName = '';
            controller.salesManagerId = '';
            controller.sourcingManagerId = null;
            controller.channelStringPartnerRecordID = null;
            controller.channelPartnerNumber = '';
            controller.selectedSourceOfFundingStatus = null;
            controller.primaryAccountMobileNo = ''; // This is an example for a valid mobile number
            controller.selectedconstructionStatusAdd = null;
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedNatureInUseAdd = null;
            controller.referralByCustomerId = null;
            controller.selectedWalkInSourceAdd = 'Referred by Existing Customer';
            controller.referralType = null;
            controller.referralFirstName = '';
            controller.referralLastName = null;
            controller.countryCodeValue = '';
            controller.selectedPrimaryAccCountryCodeAdd = '';
            controller.primaryAccountSalutation = '';
            controller.primaryAccountEmail = '';
            
            List<SelectOption> options = controller.getselectedPrimaryAccMaitalStatusAddOption();
        }}
    @isTest
    static void testGetlistSelectedContact() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        cifForm.add(cifFormObject); 
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            accountObject.Account_Form_OTP__c = '56565';
            insert accountObject;
            List<CIF_Form__c> cifFormlist = [SELECT Id FROM CIF_Form__c];
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.primaryAccountLastName = '';
            controller.primaryAccountFirstName = '';
            controller.primaryAccountMobileNo = '';
            controller.primaryAccMailingAddCity = '';
            controller.primaryAccMailingAddStreet = '';
            controller.primaryAccMailingAddPostalCode = '';
            controller.locality = '';
            controller.apartmentFlat = '';
            controller.primaryAccMailingAddState = '';
            controller.primaryAccMailingAddCountry = '';
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedPrimaryAccAgeAdd = null;
            controller.selectedBudgetPicklistValue = '';
            controller.selectedEmploymentType = '';
            controller.selectedWalkInSourceAdd = '';
            controller.myField = '';
            controller.UnregisteredCP = true;
            controller.CPName = '';
            controller.cpFirmName = '';
            controller.salesManagerId = '';
            controller.sourcingManagerId = null;
            controller.channelStringPartnerRecordID = null;
            controller.channelPartnerNumber = '';
            controller.selectedSourceOfFundingStatus = null;
            controller.primaryAccountMobileNo = ''; // This is an example for a valid mobile number
            controller.selectedconstructionStatusAdd = null;
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedNatureInUseAdd = null;
            controller.referralByCustomerId = null;
            controller.selectedWalkInSourceAdd = 'Referred by Existing Customer';
            controller.referralType = null;
            controller.referralFirstName = '';
            controller.referralLastName = null;
            controller.countryCodeValue = '';
            controller.selectedPrimaryAccCountryCodeAdd = '';
            controller.primaryAccountSalutation = '';
            controller.primaryAccountEmail = '';
            
            List<SelectOption> options = controller.getlistSelectedContact();
        }
    }
    @isTest
    static void testGetselectedNatureOfSourceAddOption() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        cifForm.add(cifFormObject); 
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            accountObject.Account_Form_OTP__c = '56565';
            insert accountObject;
            List<CIF_Form__c> cifFormlist = [SELECT Id FROM CIF_Form__c];
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.primaryAccountLastName = '';
            controller.primaryAccountFirstName = '';
            controller.primaryAccountMobileNo = '';
            controller.primaryAccMailingAddCity = '';
            controller.primaryAccMailingAddStreet = '';
            controller.primaryAccMailingAddPostalCode = '';
            controller.locality = '';
            controller.apartmentFlat = '';
            controller.primaryAccMailingAddState = '';
            controller.primaryAccMailingAddCountry = '';
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedPrimaryAccAgeAdd = null;
            controller.selectedBudgetPicklistValue = '';
            controller.selectedEmploymentType = '';
            controller.selectedWalkInSourceAdd = '';
            controller.myField = '';
            controller.UnregisteredCP = true;
            controller.CPName = '';
            controller.cpFirmName = '';
            controller.salesManagerId = '';
            controller.sourcingManagerId = null;
            controller.channelStringPartnerRecordID = null;
            controller.channelPartnerNumber = '';
            controller.selectedSourceOfFundingStatus = null;
            controller.primaryAccountMobileNo = ''; // This is an example for a valid mobile number
            controller.selectedconstructionStatusAdd = null;
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedNatureInUseAdd = null;
            controller.referralByCustomerId = null;
            controller.selectedWalkInSourceAdd = 'Referred by Existing Customer';
            controller.referralType = null;
            controller.referralFirstName = '';
            controller.referralLastName = null;
            controller.countryCodeValue = '';
            controller.selectedPrimaryAccCountryCodeAdd = '';
            controller.primaryAccountSalutation = '';
            controller.primaryAccountEmail = '';
            
            List<SelectOption> options = controller.getselectedNatureOfSourceAddOption();
        }
    }
    @isTest
    static void testGetselectedConstructionStatusAddOption() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        cifForm.add(cifFormObject); 
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            accountObject.Account_Form_OTP__c = '56565';
            insert accountObject;
            List<CIF_Form__c> cifFormlist = [SELECT Id FROM CIF_Form__c];
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.primaryAccountLastName = '';
            controller.primaryAccountFirstName = '';
            controller.primaryAccountMobileNo = '';
            controller.primaryAccMailingAddCity = '';
            controller.primaryAccMailingAddStreet = '';
            controller.primaryAccMailingAddPostalCode = '';
            controller.locality = '';
            controller.apartmentFlat = '';
            controller.primaryAccMailingAddState = '';
            controller.primaryAccMailingAddCountry = '';
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedPrimaryAccAgeAdd = null;
            controller.selectedBudgetPicklistValue = '';
            controller.selectedEmploymentType = '';
            controller.selectedWalkInSourceAdd = '';
            controller.myField = '';
            controller.UnregisteredCP = true;
            controller.CPName = '';
            controller.cpFirmName = '';
            controller.salesManagerId = '';
            controller.sourcingManagerId = null;
            controller.channelStringPartnerRecordID = null;
            controller.channelPartnerNumber = '';
            controller.selectedSourceOfFundingStatus = null;
            controller.primaryAccountMobileNo = ''; // This is an example for a valid mobile number
            controller.selectedconstructionStatusAdd = null;
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedNatureInUseAdd = null;
            controller.referralByCustomerId = null;
            controller.selectedWalkInSourceAdd = 'Referred by Existing Customer';
            controller.referralType = null;
            controller.referralFirstName = '';
            controller.referralLastName = null;
            controller.countryCodeValue = '';
            controller.selectedPrimaryAccCountryCodeAdd = '';
            controller.primaryAccountSalutation = '';
            controller.primaryAccountEmail = '';
            
            List<SelectOption> options = controller.getselectedConstructionStatusAddOption();
        }
    }
    @isTest
    static void testGetselectedSourceOfFundingAddOption() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        cifForm.add(cifFormObject); 
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            accountObject.Account_Form_OTP__c = '56565';
            insert accountObject;
            List<CIF_Form__c> cifFormlist = [SELECT Id FROM CIF_Form__c];
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.primaryAccountLastName = '';
            controller.primaryAccountFirstName = '';
            controller.primaryAccountMobileNo = '';
            controller.primaryAccMailingAddCity = '';
            controller.primaryAccMailingAddStreet = '';
            controller.primaryAccMailingAddPostalCode = '';
            controller.locality = '';
            controller.apartmentFlat = '';
            controller.primaryAccMailingAddState = '';
            controller.primaryAccMailingAddCountry = '';
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedPrimaryAccAgeAdd = null;
            controller.selectedBudgetPicklistValue = '';
            controller.selectedEmploymentType = '';
            controller.selectedWalkInSourceAdd = '';
            controller.myField = '';
            controller.UnregisteredCP = true;
            controller.CPName = '';
            controller.cpFirmName = '';
            controller.salesManagerId = '';
            controller.sourcingManagerId = null;
            controller.channelStringPartnerRecordID = null;
            controller.channelPartnerNumber = '';
            controller.selectedSourceOfFundingStatus = null;
            controller.primaryAccountMobileNo = ''; // This is an example for a valid mobile number
            controller.selectedconstructionStatusAdd = null;
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedNatureInUseAdd = null;
            controller.referralByCustomerId = null;
            controller.selectedWalkInSourceAdd = 'Referred by Existing Customer';
            controller.referralType = null;
            controller.referralFirstName = '';
            controller.referralLastName = null;
            controller.countryCodeValue = '';
            controller.selectedPrimaryAccCountryCodeAdd = '';
            controller.primaryAccountSalutation = '';
            controller.primaryAccountEmail = '';
            
            List<SelectOption> options = controller.getselectedSourceOfFundingAddOption();
        }
    }
    @isTest
    static void testOnChangeUnregisteredCP() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        cifForm.add(cifFormObject); 
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            accountObject.Account_Form_OTP__c = '56565';
            insert accountObject;
            List<CIF_Form__c> cifFormlist = [SELECT Id FROM CIF_Form__c];
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.primaryAccountLastName = '';
            controller.primaryAccountFirstName = '';
            controller.primaryAccountMobileNo = '';
            controller.primaryAccMailingAddCity = '';
            controller.primaryAccMailingAddStreet = '';
            controller.primaryAccMailingAddPostalCode = '';
            controller.locality = '';
            controller.apartmentFlat = '';
            controller.primaryAccMailingAddState = '';
            controller.primaryAccMailingAddCountry = '';
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedPrimaryAccAgeAdd = null;
            controller.selectedBudgetPicklistValue = '';
            controller.selectedEmploymentType = '';
            controller.selectedWalkInSourceAdd = '';
            controller.myField = '';
            controller.UnregisteredCP = true;
            controller.CPName = '';
            controller.cpFirmName = '';
            controller.salesManagerId = '';
            controller.sourcingManagerId = null;
            controller.channelStringPartnerRecordID = null;
            controller.channelPartnerNumber = '';
            controller.selectedSourceOfFundingStatus = null;
            controller.primaryAccountMobileNo = ''; // This is an example for a valid mobile number
            controller.selectedconstructionStatusAdd = null;
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedNatureInUseAdd = null;
            controller.referralByCustomerId = null;
            controller.selectedWalkInSourceAdd = 'Referred by Existing Customer';
            controller.referralType = null;
            controller.referralFirstName = '';
            controller.referralLastName = null;
            controller.countryCodeValue = '';
            controller.selectedPrimaryAccCountryCodeAdd = '';
            controller.primaryAccountSalutation = '';
            controller.primaryAccountEmail = '';
            
            controller.UnregisteredCP = false;
            pageRef = controller.onChangeUnregisteredCP();
            controller.UnregisteredCP = true;
            
            pageRef = controller.onChangeUnregisteredCP();
        }
    }
    @isTest
    static void testGetSelectedEmploymentTypeAddOption() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        cifForm.add(cifFormObject); 
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            accountObject.Account_Form_OTP__c = '56565';
            insert accountObject;
            List<CIF_Form__c> cifFormlist = [SELECT Id FROM CIF_Form__c];
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.primaryAccountLastName = '';
            controller.primaryAccountFirstName = '';
            controller.primaryAccountMobileNo = '';
            controller.primaryAccMailingAddCity = '';
            controller.primaryAccMailingAddStreet = '';
            controller.primaryAccMailingAddPostalCode = '';
            controller.locality = '';
            controller.apartmentFlat = '';
            controller.primaryAccMailingAddState = '';
            controller.primaryAccMailingAddCountry = '';
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedPrimaryAccAgeAdd = null;
            controller.selectedBudgetPicklistValue = '';
            controller.selectedEmploymentType = '';
            controller.selectedWalkInSourceAdd = '';
            controller.myField = '';
            controller.UnregisteredCP = true;
            controller.CPName = '';
            controller.cpFirmName = '';
            controller.salesManagerId = '';
            controller.sourcingManagerId = null;
            controller.channelStringPartnerRecordID = null;
            controller.channelPartnerNumber = '';
            controller.selectedSourceOfFundingStatus = null;
            controller.primaryAccountMobileNo = ''; // This is an example for a valid mobile number
            controller.selectedconstructionStatusAdd = null;
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedNatureInUseAdd = null;
            controller.referralByCustomerId = null;
            controller.selectedWalkInSourceAdd = 'Referred by Existing Customer';
            controller.referralType = null;
            controller.referralFirstName = '';
            controller.referralLastName = null;
            controller.countryCodeValue = '';
            controller.selectedPrimaryAccCountryCodeAdd = '';
            controller.primaryAccountSalutation = '';
            controller.primaryAccountEmail = '';
            
            List<SelectOption> options = controller.getselectedEmploymentTypeAddOption();
        }
    }
    @isTest
    static void testGetPrimaryAccountSalutationOption() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        cifForm.add(cifFormObject); 
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'testt';
            accountObject.MiddleName = 'Gupta';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.Nationality__c = 'Indian';
            accountObject.Age__c = '20-25';
            accountObject.Martial_Status__pc = 'Single';
            accountObject.Apartment_Flat__c = '21';
            accountObject.Locality__c = 'xyz';
            accountObject.Country__c = 'Benin';
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.Employment_Type__c = 'Business';
            accountObject.Company_Name__pc = 'abc';
            accountObject.Designation_or_Position__pc='Head';
            accountObject.Industry='Law';
            accountObject.PersonMobilePhone='1234567890';
            accountObject.Account_Form_OTP__c = '56565';
            insert accountObject;
            List<CIF_Form__c> cifFormlist = [SELECT Id FROM CIF_Form__c];
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity', StageName = 'Site Visit');
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Budget1__c = 'Under 75 lakhs';
            testOpportunity.Construction_Status__c = 'RTMI';
            testOpportunity.Interested_Configuration__c = '1 BHK';
            testOpportunity.Nature_of_Use__c ='';
            testOpportunity.Source_of_Funding__c = '';
            testOpportunity.Carpet_Area_in_sq_mts__c = 89.77;
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Name = 'Test1';
            testOpportunity.StageName = 'Open';
            testOpportunity.CloseDate = system.today();
            testOpportunity.Email_Id__c = 'TEst@gmail.com';
            testOpportunity.Phone__c = '8987676568';
            testOpportunity.Project__c = projectObject.Id;
            testOpportunity.Sales_Manager__c = testUserRcd1.Id;
            testOpportunity.Date_of_Site_Visit__c = System.today();
            testOpportunity.Referral_Type__c ='Other';
            testOpportunity.Referral_Name__c ='John doe';
            testOpportunity.Referral_Mobile_Number__c ='1234657890';
            testOpportunity.Walk_in_Source__c = 'Referred by Others';
            insert testOpportunity;
            
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            insert testCampRcd;
            
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c = accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Google';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='1234567890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            testEnqRcd.Site_Visit_Done_Date__c = system.now();
            testEnqRcd.Stage__c = 'Interested';
            
            insert testEnqRcd;
            
            PageReference pageRef = Page.CIF2; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.primaryAccountLastName = '';
            controller.primaryAccountFirstName = '';
            controller.primaryAccountMobileNo = '';
            controller.primaryAccMailingAddCity = '';
            controller.primaryAccMailingAddStreet = '';
            controller.primaryAccMailingAddPostalCode = '';
            controller.locality = '';
            controller.apartmentFlat = '';
            controller.primaryAccMailingAddState = '';
            controller.primaryAccMailingAddCountry = '';
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedPrimaryAccAgeAdd = null;
            controller.selectedBudgetPicklistValue = '';
            controller.selectedEmploymentType = '';
            controller.selectedWalkInSourceAdd = '';
            controller.myField = '';
            controller.UnregisteredCP = true;
            controller.CPName = '';
            controller.cpFirmName = '';
            controller.salesManagerId = '';
            controller.sourcingManagerId = null;
            controller.channelStringPartnerRecordID = null;
            controller.channelPartnerNumber = '';
            controller.selectedSourceOfFundingStatus = null;
            controller.primaryAccountMobileNo = ''; // This is an example for a valid mobile number
            controller.selectedconstructionStatusAdd = null;
            controller.selectedProjectConfigurationAdd = null;
            controller.selectedNatureInUseAdd = null;
            controller.referralByCustomerId = null;
            controller.selectedWalkInSourceAdd = 'Referred by Others';
            controller.referralType = null;
            controller.referralFirstName = '';
            controller.referralLastName = null;
            controller.countryCodeValue = '';
            controller.selectedPrimaryAccCountryCodeAdd = '';
            controller.primaryAccountSalutation = '';
            controller.primaryAccountEmail = '';
            
            
            List<SelectOption> options = controller.getprimaryAccountSalutationOption();
            
        }
    }
    @isTest
    static void OpportunityForm() {
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        
        CIF_Form__c cifFormObject = new CIF_Form__c();
        cifFormObject.Name = 'Test11 CIF Form';
        cifFormObject.Disable_Till__c = System.now().addDays(1);
        cifFormObject.Disable_Time__c = 10.2;
        cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
        insert cifFormObject;
        cifForm.add(cifFormObject); 
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            
            PageReference pageRef = Page.OpportunityForm; // Replace with your page name.
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.primaryAccountLastName = '';
            controller.primaryAccountFirstName = '';
            controller.primaryAccountMobileNo = '';
            controller.primaryAccountSalutation = '';
            controller.selectedPrimaryAccCountryCodeAdd ='';
            controller.primaryAccountFirstName = 'PrimaryName';
            controller.primaryAccountMiddleName = 'Gupta';
            controller.primaryAccountLastName = 'Account';
            controller.primaryAccountMobileNo = '4354654734';
            controller.primaryAccountSalutation = 'Mr.';
            controller.selectedPrimaryAccCountryCodeAdd = '+91';
            PageReference resultPage = controller.submitFirstForm();
        }
    }
    
    @isTest
    static void testCallOut() {
        
        string projectId = ApexPages.currentPage().getParameters().get('Id');
        List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        Profile pId;
        if (!profiles.isEmpty()) {
            pId = profiles[0];
        } else {
            System.debug('No "System Administrator" profile found.');
        }
        
        //Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        // testUserRcd1.MobilePhone = '1234567890';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List <Account> AccountList = New List <Account>();
        Account testAccount = new Account();
        testAccount.FirstName = 'Channel';
        testAccount.MiddleName = 'Broker';
        testAccount.LastName = 'Partner';
        testAccount.RecordTypeId = PersonRecId;
        testAccount.PersonMobilePhone = '5665345763';
        testAccount.PersonEmail = 'test@gmail.com';
        testAccount.OwnerId = testUserRcd1.Id;
        // testAccount.CreatedById = testUserRcd1.Id;
        testAccount.Account_Form_OTP__c = '34564';
        insert testAccount;
        AccountList.add(testAccount);
        
        List <Project__c> ProjectList = New List <Project__c>();
        Project__c testProject = new Project__c();
        testProject.Name = 'Astrum';
        testProject.Project_Email__c = 'astrum@dynamixgroup.co.in';
        testProject.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        testProject.Budgets__c = 'Under 75 lakhs';
        testProject.Configuration__c ='3 BHK';
        testProject.Project_Head__c = testUserRcd1.Id;
        testProject.Site_Head__c = testUserRcd1.id;
        testProject.Project_Header__c = 'https://dynamixgroup2--uatdynamix.sandbox.file.force.com/sfc/dist/version/download/?oid=00DFf000000DnSj&ids=068Ff000000tQpt&d=%2Fa%2FFf0000005Q1t%2FTbK32XltDvOtmcb.7ZgBZWXhTnLB1OH2ELNVofcBvcs&asPdf=false';
        testProject.Project_Footer__c = 'https://dynamixgroup2--uatdynamix.sandbox.file.force.com/sfc/dist/version/download/?oid=00DFf000000DnSj&ids=068Ff000000tQrV&d=%2Fa%2FFf0000005Q3V%2Fcj96w6D0yJadb.UhzpwwZLMsQJQbJGp89nidy2G4gkg&asPdf=false';
        insert testProject;
        ProjectList.add(testProject);
        
        BookingForm_OTP_Data__mdt mockMetadata = new BookingForm_OTP_Data__mdt(
            DeveloperName = 'Test_Label',
            Bearer_Token__c = 'TestBearerToken',
            End_Point__c = 'TestEndPoint',
            Content_Type_Header__c = 'TestContentTypeHeader',
            Authorization_Header__c = 'TestAuthorizationHeader',
            Message_Body__c = 'Your OTP is: {{1}} for {{2}}',
            CIF_OTP_Message_Body__c = 'Test CIF Message Body {{1}} {{2}}'
        );
        
        if (mockMetadata != null && mockMetadata.Message_Body__c != null) {
            String msgBody = mockMetadata.Message_Body__c;
            Integer randomNumber = 1234; 
            msgBody = msgBody.replace('{{1}}', String.valueOf(randomNumber));
            msgBody = msgBody.replace('{{2}}', 'opportunity');
            
        } else {
            System.debug('Metadata not found or Message Body is empty.');
        }
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        CIF_Form__c cifFormObject = new CIF_Form__c();
        if (!cifForm.isEmpty()) {            
            cifFormObject.Name = 'Test11 CIF Form';
            cifFormObject.Disable_Till__c = System.now().addDays(1);
            cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
            insert cifFormObject;
        } else {
            cifFormObject.Name = 'Test11 CIF Form';
            cifFormObject.Disable_Till__c = System.now().addDays(1);
            
            insert cifFormObject;
        }
        PageReference pageRef = Page.CIF2; // Replace with your page name
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('AccounId', testAccount.Id);
        pageRef.getParameters().put('Id', testProject.Id);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
        OpportunityFormController controller = new OpportunityFormController(stdController);
        Test.startTest();
        controller.callOut();        
        Test.stopTest();
        
    }  
    @isTest
    static void testupdateSelectedValue() {
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.MobilePhone = '5657562465';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1) {
            
            Id ChPartnerRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.Name = 'Channel Partner';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = ChPartnerRecId;
            accountObject.RERA_Number__c = '3534645';
            accountObject.CP_Firm_Name__c = 'CP Firm';
            accountObject.CP_Name__c = 'CP Name';
            insert accountObject; 
            
            
            List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
            CIF_Form__c cifFormObject = new CIF_Form__c();
            if (!cifForm.isEmpty()) {                
                cifFormObject.Name = 'Test11 CIF Form';
                cifFormObject.Disable_Till__c = System.now().addDays(1);
                cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
                insert cifFormObject;
            } else {
                cifFormObject.Name = 'Test11 CIF Form';
                cifFormObject.Disable_Till__c = System.now().addDays(1);
                
                insert cifFormObject;
            }
            
            List <Project__c> ProjectList = new List <Project__c>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OTP_Disable_Till__c = System.now().addDays(1);
            projectObject.Project_Header__c = 'abc.com';
            insert projectObject;
            ProjectList.add(projectObject);
            
            List<Opportunity> OpportunityList = new List<opportunity>();
            
            
            Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity');
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Budget1__c = 'Under 75 lakhs';
            testOpportunity.Construction_Status__c = 'RTMI';
            testOpportunity.Interested_Configuration__c = '1 BHK';
            testOpportunity.Nature_of_Use__c ='';
            testOpportunity.Source_of_Funding__c = '';
            testOpportunity.Carpet_Area_in_sq_mts__c = 89.77;
            testOpportunity.AccountId = accountObject.Id;
            testOpportunity.Name = 'Test1';
            testOpportunity.StageName = 'Site Visit';
            testOpportunity.CloseDate = system.today().addDays(30);
            testOpportunity.Email_Id__c = 'TEst@gmail.com';
            testOpportunity.Phone__c = '8987676568';
            testOpportunity.Project__c = projectObject.Id;
            testOpportunity.Sales_Manager__c = testUserRcd1.Id;
            testOpportunity.Date_of_Site_Visit__c = System.today();
            testOpportunity.Walk_in_Source__c = 'Channel Partner';
            testOpportunity.Referral_Name__c = 'test Test';
            testOpportunity.Sourcing_Manager__c = testUserRcd1.Id;
            testOpportunity.Secondary_Sales_Manager__c = testUserRcd1.Id;
            testOpportunity.Referral_By_Customer__c =  accountObject.Id;
            insert testOpportunity;
            
            Test.startTest();
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            insert testCampRcd;
            
            
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c = accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Google';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='1234567890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            testEnqRcd.Site_Visit_Done_Date__c = system.now();
            testEnqRcd.Stage__c = 'Interested';
            testEnqRcd.Construction_Status__c = 'RTMI';
            testEnqRcd.Configuration__c = '1 BHK';
            testEnqRcd.Budget__c = '1.75 crs - 2.25 crs';
            insert testEnqRcd;
            
            testOpportunity.Linked_Enquiry__c = testEnqRcd.id;
            testOpportunity.Enquiry_Source__c =testEnqRcd.Enquiry_Source__c;
            testOpportunity.Enquiry_Sub_Source__c = testEnqRcd.Enquiry_Sub_Source__c;
            testOpportunity.Walk_in_Source__c = 'Referred by Existing Customer';
            update testEnqRcd;
            
            testOpportunity.Linked_Enquiry__c = testEnqRcd.id;
            testOpportunity.Enquiry_Source__c =testEnqRcd.Enquiry_Source__c;
            testOpportunity.Enquiry_Sub_Source__c = testEnqRcd.Enquiry_Sub_Source__c;
            testOpportunity.Walk_in_Source__c = 'Referred by Others';
            update testEnqRcd;
            
            Task testTaskRcd=new Task();
            testTaskRcd.Subject='Site Visit Done';
            testTaskRcd.Status='Open';
            testTaskRcd.WhatId=testOpportunity.Id;
            testTaskRcd.Project__c = projectObject.Id;
            testTaskRcd.ActivityDate=System.today();
            insert testTaskRcd;
            
            OpportunityList.add(testOpportunity);
            
            PageReference pageRef = Page.CIF2;
            Test.setCurrentPage(pageRef);
            
            EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'Customer revisit on submission of CIF' LIMIT 1];
            
            pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
            pageRef.getParameters().put('AccounId', accountObject.Id);
            ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
            OpportunityFormController controller = new OpportunityFormController(stdController);
            controller.selectedValue ='PreSales';
            // controller.selectedValue ='PreSales';
            controller.primaryAccountFirstName = 'John';
            controller.primaryAccountLastName = 'Doe';
            controller.primaryAccountMobileNo = '1234567890';
            controller.primaryAccountEmail = 'john@example.com';
            controller.primaryAccountSalutation = 'Mr';
            controller.selectedPrimaryAccCountryCodeAdd = '+91';
            controller.selectedValue = testOpportunity.Walk_in_Source__c;
            controller.salesManagerName = 'Test Sales Manager';
            controller.channelStringPartnerRecordID = 'Channel123';
            controller.channelPartnerName = 'Channel Partner';
            controller.myField = 'My Field';
            controller.CountOtp = 5;
            controller.showReferralByCustomer = true;
            controller.salesManagerId = testOpportunity.Sales_Manager__c;
            controller.sourcingManagerId = testOpportunity.Sourcing_Manager__c;
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
            controller.recordId = projectObject.Id;
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
            controller.selectedWalkInSourceAdd =testOpportunity.Walk_in_Source__c;
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
            controller.ProjectName = projectObject.Name;
            controller.secondarySalesManagerName = 'Secondary Manager';
            controller.secondarySalesManagerId = testOpportunity.Secondary_Sales_Manager__c;
            controller.setReadOnlyChannelPartner = 'ReadOnly';
            controller.cpFirmName ='xyz';
            controller.CPName = 'zyz';
            controller.reraNumber = accountObject.RERA_Number__c;
            controller.channelPartnerNumber='+915656565656';
            controller.referralId = testOpportunity.Referral_By_Customer__c;
            controller.referralByCustomerId = testOpportunity.Referral_By_Customer__c;
            controller.makeItReadOnly = false;
            controller.referralType = 'Channel Partner';
            controller.showReferralByOther = True;
            // Set values for list properties
            controller.multiSelectBudgetValues = new List<String>{'76 lakhs - 1.25 crs', 'Under 75 lakhs'};
                controller.budgetPicklistOptions = new List<SelectOption>{new SelectOption('76 lakhs - 1.25 crs', 'Under 75 lakhs'), new SelectOption('76 lakhs - 1.25 crs', 'Under 75 lakhs')};
                    controller.projectConfigurationPicklistOptions = new List<SelectOption>{new SelectOption('Jodi', 'Jodi'), new SelectOption('Studio', 'Studio')};
                        controller.selectedBudgetPicklistValue = 'Under 75 lakhs';
            controller.accountList = accountObject;
            
              List<SelectOption> options = controller.getselectedEthnicityAddOption();
            
            // Call the submitFirstForm method
            PageReference resultPage = controller.updateSelectedValue();
            
            // Send Custom Notification
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            
            notification.setTitle('Revisit done by ' + testOpportunity.Name);
            String ProjectName = 'Test Project'; // Replace with a valid project name
            notification.setBody('Opportunity Name: ' + testOpportunity.Name + '.\n Project Name: ' + ProjectName);
            
            // Set the notification type and target
            CustomNotificationType notificationType = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'New_Opportunity' LIMIT 1];
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(testOpportunity.Id);
            Set<String> recipientIds = new Set<String>{testUserRcd1.Id};
                
                try {
                    notification.send(recipientIds);
                } catch (Exception e) {
                    System.debug('Problem sending notification: ' + e.getMessage());
                }
            Test.stopTest();
        }
        
    } 
    @isTest
    static void testgetselectedLocalityAddOption() {
        List<SelectOption> selectedLocalityAddOption = new List<SelectOption>();
        Locality__mdt localityList = [Select label,id FROM Locality__mdt ORDER BY Label ASC limit 1];
        Test.startTest();
        selectedLocalityAddOption.add(new SelectOption('','--None--'));
        selectedLocalityAddOption.add(new SelectOption(localityList.label,localityList.label));
        Test.stopTest();
        
    } 
    
    @isTest
    static void testGetSelectedLocalityAddOption1() {
        Id ChPartnerRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        
        Account accountObject = new Account();
        accountObject.Name = 'Channel Partner';
        accountObject.Phone = '455546565';
        accountObject.RecordTypeId = ChPartnerRecId;
        accountObject.RERA_Number__c = '3534645';
        accountObject.CP_Firm_Name__c = 'CP Firm';
        accountObject.CP_Name__c = 'CP Name';
        insert accountObject; 
        
        List <Project__c> ProjectList = new List <Project__c>();
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = UserInfo.getUserId();
        projectObject.Site_Head__c = UserInfo.getUserId();
        projectObject.OTP_Disable_Till__c = System.now().addDays(1);
        projectObject.Project_Header__c = 'abc.com';
        insert projectObject;
        ProjectList.add(projectObject);
        
        List<Locality__mdt> localityRecords = [Select label,id FROM Locality__mdt ORDER BY Label ASC];
        List<CIF_Form__c> cifForm = [SELECT Id FROM CIF_Form__c];
        CIF_Form__c cifFormObject = new CIF_Form__c();
        if (!cifForm.isEmpty()) {                
            cifFormObject.Name = 'Test11 CIF Form';
            cifFormObject.Disable_Till__c = System.now().addDays(1);
            cifFormObject.Set_Opportunity_Feild_as_Read_Only__c = 20.00;
            insert cifFormObject;
        } else {
            cifFormObject.Name = 'Test11 CIF Form';
            cifFormObject.Disable_Till__c = System.now().addDays(1);
            
            insert cifFormObject;
        }
        
        
        PageReference pageRef = Page.CIF2;
        Test.setCurrentPage(pageRef);
        
        EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'Customer revisit on submission of CIF' LIMIT 1];
        
        pageRef.getParameters().put('Id', projectObject.Id); // Replace with the opportunity Id.
        pageRef.getParameters().put('AccounId', accountObject.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(cifFormObject);
        OpportunityFormController controller = new OpportunityFormController(stdController);
        List<SelectOption> options = controller.getSelectedLocalityAddOption();
        
        
        
        System.assertNotEquals(0, options.size(), 'Select options list is empty');
        
        System.assertEquals('', options[0].getValue(), 'First option should be --None--');
        System.assertEquals('--None--', options[0].getLabel(), 'First option label is incorrect');
        
        for (Integer i = 0; i < localityRecords.size(); i++) {
            System.assertEquals(localityRecords[i].Label, options[i + 1].getValue(), 'Option value is incorrect');
            System.assertEquals(localityRecords[i].Label, options[i + 1].getLabel(), 'Option label is incorrect');
        }
    }
    // Mock HTTP callout implementation
    public class SmartWorldMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"SUCCESS","message":"All Records Uploaded successfully","failedErrorList":null,"error":null,"crmSuccessList":[{"crmId":"0010w00000zxXAOAA2","message":"25"}]}');
            res.setStatusCode(200);
            return res;
        }
    }
}