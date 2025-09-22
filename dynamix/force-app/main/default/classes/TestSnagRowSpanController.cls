@isTest
public class TestSnagRowSpanController {
    
    @testSetup
    static void setupTestData(){
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd = new User();
        testUserRcd.FirstName = 'Mayur1';
        testUserRcd.LastName = 'Patel123';
        testUserRcd.Email = 'mayur.patel@manras.com';
        testUserRcd.Alias = 'MPatel';
        testUserRcd.Username = uniqueUserName;
        testUserRcd.ProfileId = pId.Id;
        testUserRcd.EmailEncodingKey = 'UTF-8';
        testUserRcd.Phone = '1234567890';
        testUserRcd.Country = 'India';
        testUserRcd.IsActive=true;
        testUserRcd.MobilePhone = '5657562465';
        testUserRcd.LanguageLocaleKey='en_US';
        testUserRcd.LocaleSidKey='en_US';
        testUserRcd.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd;
        
        String personAccRcdTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account testAccRcd = new Account();
        testAccRcd.Salutation='Mr.';
        testAccRcd.FirstName='Snag Row FName';
        testAccRcd.LastName='Test LName';
        testAccRcd.BillingCountry = 'India';
        testAccRcd.PersonMobilePhone = '1234567890';
        testAccRcd.RecordTypeId=personAccRcdTypeId;         
        testAccRcd.Country__c='India';
        testAccRcd.Organisation_Country__c='India';
        testAccRcd.Nationality__c='Indian';
        insert testAccRcd;
        
        
        
        Project__c testProjectRcd = new Project__c();
        testProjectRcd.Name = 'Snag Row Span Test Project';
        testProjectRcd.Project_Header__c='Test Header'; 
        testProjectRcd.Project_Footer__c='Test Footer';
        testProjectRcd.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        testProjectRcd.Budgets__c = 'Under 75 lakhs';
        testProjectRcd.Configuration__c ='3 BHK';
        testProjectRcd.Project_Email__c = 'divum@dynamixgroup.co.in';
        testProjectRcd.FM_Head__c = testUserRcd.Id;
        insert testProjectRcd;
        
        Project_Snag__c testProjSnag = new Project_Snag__c();
        testProjSnag.Project__c = testProjectRcd.Id;
        testProjSnag.Unit_Type__c = '2 BHK';
        testProjSnag.Area__c = 'KITCHEN';
        testProjSnag.Questions__c = 'Is Flooring Done?';
        insert testProjSnag;
        
        Opportunity testOppRcd = new Opportunity();
        testOppRcd.AccountId = testAccRcd.Id;
        testOppRcd.Name = 'Snag Row Span Test Opportunity';
        testOppRcd.StageName = 'Site Visit';
        testOppRcd.CloseDate = System.Today()+3;
        testOppRcd.Nature_of_Purchase__c='Self Use';
        testOppRcd.Is_Booking_Form_Submitted_by_Customer__c=true;
        testOppRcd.EOI_Booking__c='Yes';
        testOppRcd.EOI_Date__c=System.today();
        testOppRcd.EOI_Amount__c=5000;
        testOppRcd.Project__c = testProjectRcd.Id;
        testOppRcd.Walk_in_Source__c = 'Hoarding';
        testOppRcd.KYC_Completed__c = true;
        testOppRcd.Stamp_Duty_Payable_By__c = 'Dynamix';
        insert testOppRcd;
    }
    
    
    @isTest
    static void Method1() {
        
        User testUserRcd1 = [Select Id,Name From User Where Email=:'mayur.patel@manras.com'];
        Project__c testProjectRcd = [Select Id,Name From Project__c Where Name=:'Snag Row Span Test Project'];
        Opportunity testOppRcd = [Select Id, Name From Opportunity Where Name=:'Snag Row Span Test Opportunity'];
        Account testAccRcd = [Select Id,Name,FirstName From Account Where FirstName=:'Snag Row FName'];
        Project_Snag__c projectSnagList = [SELECT ID, NAME,Project__c,Questions__c,Unit_Type__c,Area__c 
                                                 FROM Project_Snag__c 
                                                 WHERE Project__c =: testProjectRcd.id];
        
        Property__c testPropertyRcd = new Property__c();
        testPropertyRcd.Electric_Meter_Reading__c = 2;
        testPropertyRcd.Snag_Status__c = 'Internal Snagging';
        testPropertyRcd.Sub_Snag_Status__c = 'Pre OC-Submitted with snags';
        testPropertyRcd.Flat_Type__c = '2 BHK';
        insert testPropertyRcd;
        system.debug('propertytest--'+testPropertyRcd.Id);
        
        Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
        testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
        testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
        testSuggPropertyRcd.Discount__c = 10;
        insert testSuggPropertyRcd;
        
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        testBookingRcd.OwnerId =testUserRcd1.id;
        insert testBookingRcd;
        
        Task tsk = new Task();
        tsk.WhatId = testPropertyRcd.Id;
        tsk.Subject = 'Pre-OC FM Unit Inspection task';
        insert tsk;
        
        pagereference testPage = page.SnagRowSpan;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(testPropertyRcd.Id));
        ApexPages.StandardController standardController = new ApexPages.StandardController(testPropertyRcd);
        SnagRowSpanController controller = new SnagRowSpanController(standardController);
    }
    @isTest
    static void Method2(){
        User testUserRcd1 = [Select Id,Name From User Where Email=:'mayur.patel@manras.com'];
        Project__c testProjectRcd = [Select Id,Name From Project__c Where Name=:'Snag Row Span Test Project'];
        Opportunity testOppRcd = [Select Id, Name From Opportunity Where Name=:'Snag Row Span Test Opportunity'];
        Account testAccRcd = [Select Id,Name,FirstName From Account Where FirstName=:'Snag Row FName'];
        Project_Snag__c projectSnagList = [SELECT ID, NAME,Project__c,Questions__c,Unit_Type__c,Area__c 
                                                 FROM Project_Snag__c 
                                                 WHERE Project__c =: testProjectRcd.id];
        
        Property__c testPropertyRcd = new Property__c();
        testPropertyRcd.Electric_Meter_Reading__c = 2;
        testPropertyRcd.Snag_Status__c = 'Internal Snagging';
        testPropertyRcd.Sub_Snag_Status__c = 'Post OC-Submitted with snags';
        testPropertyRcd.Flat_Type__c = '2 BHK';
        insert testPropertyRcd;
        system.debug('propertytest--'+testPropertyRcd.Id);
        
        Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
        testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
        testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
        testSuggPropertyRcd.Discount__c = 10;
        insert testSuggPropertyRcd;
        
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        testBookingRcd.OwnerId =testUserRcd1.id;
        insert testBookingRcd;
        
        Task tsk = new Task();
        tsk.WhatId = testPropertyRcd.Id;
        tsk.Subject = 'Post - OC FM Unit Inspection';
        insert tsk;
        
        pagereference testPage = page.SnagRowSpan;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(testPropertyRcd.Id));
        ApexPages.StandardController standardController = new ApexPages.StandardController(testPropertyRcd);
        SnagRowSpanController controller = new SnagRowSpanController(standardController);
    }
    
    @isTest
    static void Method3(){
        User testUserRcd1 = [Select Id,Name From User Where Email=:'mayur.patel@manras.com'];
        Project__c testProjectRcd = [Select Id,Name From Project__c Where Name=:'Snag Row Span Test Project'];
        Opportunity testOppRcd = [Select Id, Name From Opportunity Where Name=:'Snag Row Span Test Opportunity'];
        Account testAccRcd = [Select Id,Name,FirstName From Account Where FirstName=:'Snag Row FName'];
        Project_Snag__c projectSnagList = [SELECT ID, NAME,Project__c,Questions__c,Unit_Type__c,Area__c 
                                                 FROM Project_Snag__c 
                                                 WHERE Project__c =: testProjectRcd.id];
        
        Property__c testPropertyRcd = new Property__c();
        testPropertyRcd.Electric_Meter_Reading__c = 2;
        testPropertyRcd.Snag_Status__c = 'Internal Snagging';
        testPropertyRcd.Sub_Snag_Status__c = 'Post OC-Verified';
        testPropertyRcd.Flat_Type__c = '2 BHK';
        insert testPropertyRcd;
        system.debug('propertytest--'+testPropertyRcd.Id);
        
        Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
        testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
        testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
        testSuggPropertyRcd.Discount__c = 10;
        insert testSuggPropertyRcd;
        
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        testBookingRcd.OwnerId =testUserRcd1.id;
        insert testBookingRcd;
        
        Task tsk = new Task();
        tsk.WhatId = testPropertyRcd.Id;
        tsk.Subject = 'Post - OC FM Unit Inspection';
        insert tsk;
        
        pagereference testPage = page.SnagRowSpan;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(testPropertyRcd.Id));
        ApexPages.StandardController standardController = new ApexPages.StandardController(testPropertyRcd);
        SnagRowSpanController controller = new SnagRowSpanController(standardController);
    }
    
    @isTest
    static void Method4(){
        User testUserRcd1 = [Select Id,Name From User Where Email=:'mayur.patel@manras.com'];
        Project__c testProjectRcd = [Select Id,Name From Project__c Where Name=:'Snag Row Span Test Project'];
        Opportunity testOppRcd = [Select Id, Name From Opportunity Where Name=:'Snag Row Span Test Opportunity'];
        Account testAccRcd = [Select Id,Name,FirstName From Account Where FirstName=:'Snag Row FName'];
        Project_Snag__c projectSnagList = [SELECT ID, NAME,Project__c,Questions__c,Unit_Type__c,Area__c 
                                                 FROM Project_Snag__c 
                                                 WHERE Project__c =: testProjectRcd.id];
        
        Property__c testPropertyRcd = new Property__c();
        testPropertyRcd.Electric_Meter_Reading__c = 2;
        testPropertyRcd.Snag_Status__c = 'Customer Unit Inspection Scheduled';
        testPropertyRcd.Flat_Type__c = '2 BHK';
        insert testPropertyRcd;
        system.debug('propertytest--'+testPropertyRcd.Id);
        
        Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
        testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
        testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
        testSuggPropertyRcd.Discount__c = 10;
        insert testSuggPropertyRcd;
        
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        testBookingRcd.OwnerId =testUserRcd1.id;
        insert testBookingRcd;
        
        Task tsk = new Task();
        tsk.WhatId = testPropertyRcd.Id;
        tsk.Subject = 'Deep Cleaning Task';
        tsk.Status= 'Completed';
        insert tsk;
        
        pagereference testPage = page.SnagRowSpan;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(testPropertyRcd.Id));
        ApexPages.StandardController standardController = new ApexPages.StandardController(testPropertyRcd);
        SnagRowSpanController controller = new SnagRowSpanController(standardController);  
    }
    
    @isTest
    static void Method5(){
        User testUserRcd1 = [Select Id,Name From User Where Email=:'mayur.patel@manras.com'];
        Project__c testProjectRcd = [Select Id,Name From Project__c Where Name=:'Snag Row Span Test Project'];
        Opportunity testOppRcd = [Select Id, Name From Opportunity Where Name=:'Snag Row Span Test Opportunity'];
        Account testAccRcd = [Select Id,Name,FirstName From Account Where FirstName=:'Snag Row FName'];
        Project_Snag__c testProjSnag = [SELECT ID, NAME,Project__c,Questions__c,Unit_Type__c,Area__c 
                                                 FROM Project_Snag__c 
                                                 WHERE Project__c =: testProjectRcd.id];
        
        Property__c testPropertyRcd = new Property__c();
        testPropertyRcd.Electric_Meter_Reading__c = 2;
        testPropertyRcd.Snag_Status__c = 'Customer Snagging';
        testPropertyRcd.Flat_Type__c = '2 BHK';
        insert testPropertyRcd;
        system.debug('propertytest--'+testPropertyRcd.Id);
        
        Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
        testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
        testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
        testSuggPropertyRcd.Discount__c = 10;
        insert testSuggPropertyRcd;
        
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        testBookingRcd.OwnerId =testUserRcd1.id;
        insert testBookingRcd;
        
        Task tsk = new Task();
        tsk.WhatId = testPropertyRcd.Id;
        tsk.Subject = 'Post - OC FM Review Task';
        tsk.Status= 'Completed';
        insert tsk;
        
        pagereference testPage = page.SnagRowSpan;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(testPropertyRcd.Id));
        ApexPages.StandardController standardController = new ApexPages.StandardController(testPropertyRcd);
        SnagRowSpanController controller = new SnagRowSpanController(standardController);    
    }
    
    @isTest
    static void Method6(){
        User testUserRcd1 = [Select Id,Name From User Where Email=:'mayur.patel@manras.com'];
        Project__c testProjectRcd = [Select Id,Name From Project__c Where Name=:'Snag Row Span Test Project'];
        Opportunity testOppRcd = [Select Id, Name From Opportunity Where Name=:'Snag Row Span Test Opportunity'];
        Account testAccRcd = [Select Id,Name,FirstName From Account Where FirstName=:'Snag Row FName'];
        Project_Snag__c testProjSnag = [SELECT ID, NAME,Project__c,Questions__c,Unit_Type__c,Area__c 
                                                 FROM Project_Snag__c 
                                                 WHERE Project__c =: testProjectRcd.id];
        Property__c testPropertyRcd = new Property__c();
        testPropertyRcd.Electric_Meter_Reading__c = 2;
        testPropertyRcd.Snag_Status__c = 'Yet to start';
        testPropertyRcd.Project__c = testProjectRcd.Id;
        //   testPropertyRcd.Unit_Type__c = '1BHK';
        testPropertyRcd.Flat_Type__c = '2 BHK';
        insert testPropertyRcd;
        
        system.debug('propertytest--'+testPropertyRcd.Id);
       
        Unit_Snag_Response__c UnitSnagRes= new Unit_Snag_Response__c();
        UnitSnagRes.Project_Snag__c = testProjSnag.Id;
        UnitSnagRes.Property__c = testPropertyRcd.Id;
        insert UnitSnagRes;
        
        Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
        testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
        testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
        testSuggPropertyRcd.Discount__c = 10;
        insert testSuggPropertyRcd;
        
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        testBookingRcd.OwnerId =testUserRcd1.id;
        insert testBookingRcd;
        
        Task tsk = new Task();
        tsk.WhatId = testPropertyRcd.Id;
        tsk.Subject = 'Deep Cleaning Task';
        tsk.Status= 'Completed';
        insert tsk;
        
        pagereference testPage = page.SnagRowSpan;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(testPropertyRcd.Id));
        ApexPages.StandardController standardController = new ApexPages.StandardController(testPropertyRcd);
        SnagRowSpanController controller = new SnagRowSpanController(standardController);
        
        Test.startTest();
        controller.getData();
        Test.stopTest();
    }
    
    @isTest
    static void Method7(){
        User testUserRcd1 = [Select Id,Name From User Where Email=:'mayur.patel@manras.com'];
        Project__c testProjectRcd = [Select Id,Name,Project_Email__c From Project__c Where Name=:'Snag Row Span Test Project'];
        Opportunity testOppRcd = [Select Id, Name From Opportunity Where Name=:'Snag Row Span Test Opportunity'];
        Account testAccRcd = [Select Id,Name,FirstName From Account Where FirstName=:'Snag Row FName'];
        Project_Snag__c testProjSnag = [SELECT ID, NAME,Project__c,Questions__c,Unit_Type__c,Area__c 
                                                 FROM Project_Snag__c 
                                                 WHERE Project__c =: testProjectRcd.id];
        
        Property__c testPropertyRcd = new Property__c();
        testPropertyRcd.Electric_Meter_Reading__c = 2;
        testPropertyRcd.Snag_Status__c = 'Internal Snagging';
        testPropertyRcd.Sub_Snag_Status__c = 'Post OC-Verified';
        // testPropertyRcd.Unit_Type__c = '1BHK';
        testPropertyRcd.Flat_Type__c = '2 BHK';
        testPropertyRcd.Project__c = testProjectRcd.id;
        insert testPropertyRcd;
        system.debug('propertytest--'+testPropertyRcd.Id);
        
        
        Unit_Snag_Response__c UnitSnagRes= new Unit_Snag_Response__c();
        UnitSnagRes.Project_Snag__c = testProjSnag.Id;
        UnitSnagRes.Property__c = testPropertyRcd.Id;
        UnitSnagRes.Pre_OC_Answers__c=False;
        insert UnitSnagRes;
        
        Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
        testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
        testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
        testSuggPropertyRcd.Discount__c = 10;
        insert testSuggPropertyRcd;
        
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        testBookingRcd.OwnerId =testUserRcd1.id;
        insert testBookingRcd;
        
        Task tsk = new Task();
        tsk.WhatId = testPropertyRcd.Id;
        tsk.Subject = 'Pre-OC FM Unit Inspection task';
        insert tsk;
        
        pagereference testPage = page.SnagRowSpan;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', testPropertyRcd.Id);
        testPage.getParameters().put('SnagDetails', '[{"recordId":"' + UnitSnagRes.Id + '","CheckBox":true,"remarks":"Test remark"}]');
        testPage.getParameters().put('fileName', 'TestFileName'); // Set the fileName parameter
        ApexPages.StandardController standardController = new ApexPages.StandardController(testPropertyRcd);
        SnagRowSpanController controller = new SnagRowSpanController(standardController);
        
        Test.startTest();
        controller.saveUnitSnagList();
        Test.stopTest();
    }
    
    @isTest
    static void Method8(){
        User testUserRcd1 = [Select Id,Name From User Where Email=:'mayur.patel@manras.com'];
        Project__c testProjectRcd = [Select Id,Name From Project__c Where Name=:'Snag Row Span Test Project'];
        Opportunity testOppRcd = [Select Id, Name From Opportunity Where Name=:'Snag Row Span Test Opportunity'];
        Account testAccRcd = [Select Id,Name,FirstName From Account Where FirstName=:'Snag Row FName'];
        Project_Snag__c testProjSnag = [SELECT ID, NAME,Project__c,Questions__c,Unit_Type__c,Area__c 
                                                 FROM Project_Snag__c 
                                                 WHERE Project__c =: testProjectRcd.id];
        
        Property__c testPropertyRcd = new Property__c();
        testPropertyRcd.Electric_Meter_Reading__c = 2;
        testPropertyRcd.Snag_Status__c = 'Internal Snagging';
        testPropertyRcd.Sub_Snag_Status__c = 'Post OC-Verified';
        testPropertyRcd.Project__c = testProjectRcd.Id;
        //   testPropertyRcd.Unit_Type__c = '1BHK';
        testPropertyRcd.Flat_Type__c = '2 BHK';
        insert testPropertyRcd;
        system.debug('propertytest--'+testPropertyRcd.Id);
        
     
        
        Unit_Snag_Response__c UnitSnagRes= new Unit_Snag_Response__c();
        UnitSnagRes.Project_Snag__c = testProjSnag.Id;
        UnitSnagRes.Property__c = testPropertyRcd.Id;
        UnitSnagRes.Post_OC_Answers__c = False;
        insert UnitSnagRes;
        
        Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
        testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
        testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
        testSuggPropertyRcd.Discount__c = 10;
        insert testSuggPropertyRcd;
        
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        testBookingRcd.OwnerId =testUserRcd1.id;
        insert testBookingRcd;
        
        Task tsk = new Task();
        tsk.WhatId = testPropertyRcd.Id;
        tsk.Subject = 'Pre-OC FM Unit Inspection task';
        insert tsk;
        
        pagereference testPage = page.SnagRowSpan;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', testPropertyRcd.Id);
        testPage.getParameters().put('SnagDetails', '[{"recordId":"' + UnitSnagRes.Id + '","CheckBox":true,"remarks":"Test remark"}]');
        String Json= '[{"recordId":"' + UnitSnagRes.Id + '","CheckBox":true,"remarks":"Test remark"}]';
        ApexPages.StandardController standardController = new ApexPages.StandardController(testPropertyRcd);
        SnagRowSpanController controller = new SnagRowSpanController(standardController);
        
        Test.startTest();
        SnagRowSpanController.postOC(Json,testPropertyRcd.Id,90.98);
        Test.stopTest();
    }
    
    @isTest
    static void Method9(){
        User testUserRcd1 = [Select Id,Name From User Where Email=:'mayur.patel@manras.com'];
        Project__c testProjectRcd = [Select Id,Name From Project__c Where Name=:'Snag Row Span Test Project'];
        Opportunity testOppRcd = [Select Id, Name From Opportunity Where Name=:'Snag Row Span Test Opportunity'];
        Account testAccRcd = [Select Id,Name,FirstName From Account Where FirstName=:'Snag Row FName'];
        Project_Snag__c testProjSnag = [SELECT ID, NAME,Project__c,Questions__c,Unit_Type__c,Area__c 
                                                 FROM Project_Snag__c 
                                                 WHERE Project__c =: testProjectRcd.id];
        
        Property__c testPropertyRcd = new Property__c();
        testPropertyRcd.Electric_Meter_Reading__c = 2;
        testPropertyRcd.Snag_Status__c = 'Yet to start';
        testPropertyRcd.Project__c = testProjectRcd.Id;
        // testPropertyRcd.Unit_Type__c = '1BHK';
        testPropertyRcd.Flat_Type__c = '2 BHK';
        insert testPropertyRcd;
        system.debug('propertytest--'+testPropertyRcd.Id);
        
      
        
        Unit_Snag_Response__c UnitSnagRes= new Unit_Snag_Response__c();
        UnitSnagRes.Project_Snag__c = testProjSnag.Id;
        UnitSnagRes.Property__c = testPropertyRcd.Id;
        insert UnitSnagRes;
        
        Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
        testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
        testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
        testSuggPropertyRcd.Discount__c = 10;
        insert testSuggPropertyRcd;
        
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        testBookingRcd.OwnerId =testUserRcd1.id;
        insert testBookingRcd;
        
        Task tsk = new Task();
        tsk.WhatId = testPropertyRcd.Id;
        tsk.Subject = 'Pre-OC FM Unit Inspection task';
        insert tsk;
        
        pagereference testPage = page.SnagRowSpan;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', testPropertyRcd.Id);
        testPage.getParameters().put('SnagDetails', '[{"recordId":"' + UnitSnagRes.Id + '","CheckBox":true,"remarks":"Test remark"}]');
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(testPropertyRcd);
        SnagRowSpanController controller = new SnagRowSpanController(standardController);
                String Json= '[{"recordId":"' + UnitSnagRes.Id + '","CheckBox":true,"remarks":"Test remark"}]';

        Test.startTest();
        SnagRowSpanController.saveCustomerUnitSnagList(Json,testPropertyRcd.Id,90.98,null);
        Test.stopTest();
    }
    
    @isTest
    static void Metho10(){
        User testUserRcd1 = [Select Id,Name From User Where Email=:'mayur.patel@manras.com'];
        Project__c testProjectRcd = [Select Id,Name From Project__c Where Name=:'Snag Row Span Test Project'];
        Opportunity testOppRcd = [Select Id, Name From Opportunity Where Name=:'Snag Row Span Test Opportunity'];
        Account testAccRcd = [Select Id,Name,FirstName From Account Where FirstName=:'Snag Row FName'];
        Project_Snag__c testProjSnag = [SELECT ID, NAME,Project__c,Questions__c,Unit_Type__c,Area__c 
                                                 FROM Project_Snag__c 
                                                 WHERE Project__c =: testProjectRcd.id];
        
        Property__c testPropertyRcd = new Property__c();
        testPropertyRcd.Electric_Meter_Reading__c = 2;
        testPropertyRcd.Snag_Status__c = 'Yet to start';
        testPropertyRcd.Project__c = testProjectRcd.Id;
        //testPropertyRcd.Unit_Type__c = '1BHK';
        testPropertyRcd.Flat_Type__c = '2 BHK';
        insert testPropertyRcd;
        system.debug('propertytest--'+testPropertyRcd.Id);
        
        Unit_Snag_Response__c UnitSnagRes= new Unit_Snag_Response__c();
        UnitSnagRes.Project_Snag__c = testProjSnag.Id;
        UnitSnagRes.Property__c = testPropertyRcd.Id;
        UnitSnagRes.Pre_OC_Answers__c=False;
        insert UnitSnagRes;
        
        Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
        testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
        testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
        testSuggPropertyRcd.Discount__c = 10;
        insert testSuggPropertyRcd;
        
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        testBookingRcd.OwnerId =testUserRcd1.id;
        insert testBookingRcd;
        
        Task tsk = new Task();
        tsk.WhatId = testPropertyRcd.Id;
        tsk.Subject = 'Pre-OC FM Unit Inspection task';
        insert tsk;
        
        Test.startTest();
        SnagRowSpanController.generateSnagDoc(testPropertyRcd.Id,'Pre-OC',11.20);
        Test.stopTest();
    }
    @isTest
    static void Metho11(){
        User testUserRcd1 = [Select Id,Name From User Where Email=:'mayur.patel@manras.com'];
        Project__c testProjectRcd = [Select Id,Name From Project__c Where Name=:'Snag Row Span Test Project'];
        Opportunity testOppRcd = [Select Id, Name From Opportunity Where Name=:'Snag Row Span Test Opportunity'];
        Account testAccRcd = [Select Id,Name,FirstName From Account Where FirstName=:'Snag Row FName'];
        Project_Snag__c projectSnagList = [SELECT ID, NAME,Project__c,Questions__c,Unit_Type__c,Area__c 
                                                 FROM Project_Snag__c 
                                                 WHERE Project__c =: testProjectRcd.id];
        
        Property__c testPropertyRcd = new Property__c(/* Add required fields */);
        testPropertyRcd.Electric_Meter_Reading__c = 2;
        testPropertyRcd.Snag_Status__c = 'Internal Snagging';
        testPropertyRcd.Sub_Snag_Status__c = 'Post OC-Verified';
        testPropertyRcd.Project__c = testProjectRcd.Id;
        // testPropertyRcd.Unit_Type__c = '1BHK';
        testPropertyRcd.Flat_Type__c = '2 BHK';
        insert testPropertyRcd;
        system.debug('propertytest--'+testPropertyRcd.Id);
        
        Project_Snag__c testProjSnag = new Project_Snag__c();
        testProjSnag.Project__c = testProjectRcd.Id;
        testProjSnag.Unit_Type__c = '2 BHK';
        testProjSnag.Area__c = 'KITCHEN';
        insert testProjSnag;
        
        Unit_Snag_Response__c UnitSnagRes= new Unit_Snag_Response__c();
        UnitSnagRes.Project_Snag__c = testProjSnag.Id;
        UnitSnagRes.Property__c = testPropertyRcd.Id;
        UnitSnagRes.Pre_OC_Answers__c=True;
        insert UnitSnagRes;
        
        Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
        testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
        testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
        testSuggPropertyRcd.Discount__c = 10;
        insert testSuggPropertyRcd;
        
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        testBookingRcd.OwnerId =testUserRcd1.id;
        insert testBookingRcd;
        
        Task tsk = new Task();
        tsk.WhatId = testPropertyRcd.Id;
        tsk.Subject = 'Pre-OC FM Unit Inspection task';
        insert tsk;
        
        Test.startTest();
        SnagRowSpanController.generateSnagDoc(testPropertyRcd.Id,'Pre-OC',12.02);
        Test.stopTest();
    }
}