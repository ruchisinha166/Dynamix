@isTest
public class ShareCollateralForOppOnWhatsappTest{
    @isTest
    static void testShareCollateralForOppOnWhatsappMethod() {
        
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
        
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account accountObject = new Account();
        accountObject.FirstName = 'testt';
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
        
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        
        insert projectObject;
        
        Campaign testCampRcd=new Campaign();
        testCampRcd.Name='test Campaign';
        testCampRcd.Project__c=projectObject.Id;
        testCampRcd.Source__c='Google';
        testCampRcd.StartDate=System.today();
        testCampRcd.EndDate=System.today()+15;
        testCampRcd.ActualCost=2500000;
        insert testCampRcd;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Budget1__c = 'Under 75 lakhs';
        oppoObject.Carpet_Area_in_sq_mts__c = 89.77;
        oppoObject.Email_Id__c = 'TEst@gmail.com';
        oppoObject.Phone__c = '8987676568';
        oppoObject.Project__c = projectObject.Id;
        oppoObject.Walk_in_Source__c = 'Referred by Existing Customer'; 
        oppoObject.OwnerId=testUserRcd1.Id;
        insert oppoObject;
        
        list<Opportunity> oppList = new List<Opportunity>();
        oppList.add(oppoObject);
        
        // Create a test EmailTemplate
        EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'Whatsapp Of Share Collateral Without Walk Through' LIMIT 1];
        
        // Create a test requestWrapper
        ShareCollateralForOppOnWhatsapp.requestWrapper testWrapper = new ShareCollateralForOppOnWhatsapp.requestWrapper();
        testWrapper.projectName = 'Test Project';
        testWrapper.projectArea = 'Test Area';
        testWrapper.flatVideo = 'Test Video';
        testWrapper.primaryMobileNumber = '1234567890';
        testWrapper.Location = 'Test Location';
        testWrapper.brochure = 'Test Brochure';
        testWrapper.walkThrough = true;
        testWrapper.projectPhone = '9876543210';
        testWrapper.opportunityId =oppoObject.Id;
        //testWrapper.enquiryId = testEnqRcd.id;
        testWrapper.personAccountId = accountObject.id;

        List<ShareCollateralForOppOnWhatsapp.requestWrapper> wrapperList = new List<ShareCollateralForOppOnWhatsapp.requestWrapper>();
        wrapperList.add(testWrapper);
        communicat_o__Registered_Template__mdt regEmailTemp = new communicat_o__Registered_Template__mdt();

        // Call the ShareCollateralForOppOnWhatsapp method
        Test.startTest();
        ShareCollateralForOppOnWhatsapp.ShareCollateralForOppOnWhatsappMethod(wrapperList);
        Test.stopTest();
    }
    
    @isTest
    static void testShareCollateralForOppOnWhatsappMethod1() {
        
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
        
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account accountObject = new Account();
        accountObject.FirstName = 'testt';
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
        
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        
        insert projectObject;
        
        Campaign testCampRcd=new Campaign();
        testCampRcd.Name='test Campaign';
        testCampRcd.Project__c=projectObject.Id;
        testCampRcd.Source__c='Google';
        testCampRcd.StartDate=System.today();
        testCampRcd.EndDate=System.today()+15;
        testCampRcd.ActualCost=2500000;
        insert testCampRcd;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Budget1__c = 'Under 75 lakhs';
        oppoObject.Carpet_Area_in_sq_mts__c = 89.77;
        oppoObject.Email_Id__c = 'TEst@gmail.com';
        oppoObject.Phone__c = '8987676568';
        oppoObject.Project__c = projectObject.Id;
        oppoObject.Walk_in_Source__c = 'Referred by Existing Customer'; 
        oppoObject.OwnerId=testUserRcd1.Id;
        insert oppoObject;
        
        list<Opportunity> oppList = new List<Opportunity>();
        oppList.add(oppoObject);
        
        // Create a test EmailTemplate
        EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'Whatsapp Of Share Collateral Without Walk Through' LIMIT 1];
        
        // Create a test requestWrapper
        ShareCollateralForOppOnWhatsapp.requestWrapper testWrapper = new ShareCollateralForOppOnWhatsapp.requestWrapper();
        testWrapper.projectName = 'Test Project';
        testWrapper.projectArea = 'Test Area';
        testWrapper.flatVideo = 'Test Video';
        testWrapper.primaryMobileNumber = '1234567890';
        testWrapper.Location = 'Test Location';
        testWrapper.brochure = 'Test Brochure';
        testWrapper.walkThrough = False;
        testWrapper.projectPhone = '9876543210';
        testWrapper.opportunityId =oppoObject.Id;
        //testWrapper.enquiryId = testEnqRcd.id;
        testWrapper.personAccountId = accountObject.id;

        List<ShareCollateralForOppOnWhatsapp.requestWrapper> wrapperList = new List<ShareCollateralForOppOnWhatsapp.requestWrapper>();
        wrapperList.add(testWrapper);
        Test.startTest();
        ShareCollateralForOppOnWhatsapp.ShareCollateralForOppOnWhatsappMethod(wrapperList);
        Test.stopTest();
    }

}