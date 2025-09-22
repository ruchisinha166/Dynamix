@isTest
public class ChannelPartnerHandler_Test {
    static testMethod void ChannelPartnerHandlerTest(){       
        //String personAccRcdTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        RecordType channelPartnerRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Channel Partner' LIMIT 1];
        
        List<User> user = new List<User>();
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        user.add(testUserRcd1);
        
        List<Account> accountList = new List<Account>();
        Account testAccRcd = new Account();
		testAccRcd.Name = 'Channel Partner Account';
        testAccRcd.BillingCountry = 'India';
        testAccRcd.Phone = '1234567890';
        testAccRcd.Email__c = 'mayur.patel@manras.com';
        testAccRcd.OwnerId = testUserRcd1.Id;
        testAccRcd.RERA_Number__c = '123456789';
        testAccRcd.RecordTypeId = channelPartnerRecordType.Id;
        insert testAccRcd;
        accountList.add(testAccRcd);
        
        Account testAcc = new Account();
		testAcc.Name = 'Channel Partner Account1';
        testAcc.BillingCountry = 'India';
        testAcc.Phone = '4569825678';
        testAcc.Email__c = 'tanu@manras.com';
        testAcc.OwnerId = testUserRcd1.Id;
        testAcc.RERA_Number__c = null;
        testAcc.RecordTypeId = channelPartnerRecordType.Id;
        insert testAcc;
        
        OrgWideEmailAddress orgadd = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Default'];
        
        Project__c testProjectRcd = new Project__c();
        testProjectRcd.Name = 'Test Project';
        testProjectRcd.Project_Carpet_Area__c = '475 - 1 BHK';
        testProjectRcd.Budgets__c = 'Under 75 lakhs';
        testProjectRcd.Configuration__c ='1 BHK';
        testProjectRcd.Site_Head__c = testUserRcd1.Id;
        insert testProjectRcd;
        
        Project__c testProjectRcd1 = new Project__c();
        testProjectRcd1.Name = 'Test Project1';
        testProjectRcd1.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        testProjectRcd1.Budgets__c = '1.25 - 1.75 cr';
        testProjectRcd1.Configuration__c ='3 BHK';
        testProjectRcd1.Site_Head__c = testUserRcd1.Id;
        insert testProjectRcd1;
        
        List<Channel_Partner_Project__c> cpprojectList = new List<Channel_Partner_Project__c>();
        Channel_Partner_Project__c cpProject = new Channel_Partner_Project__c();
        cpProject.Channel_Partner__c = testAccRcd.Id;
        cpProject.Project__c = testProjectRcd.Id;
        insert cpProject;
        cpprojectList.add(cpProject);
        
        Opportunity testOppRcd = new Opportunity();
        testOppRcd.AccountId = testAccRcd.Id;
        testOppRcd.Name = 'Test Opportunity';
        testOppRcd.StageName = 'Site Visit';
        testOppRcd.CloseDate = System.Today()+3;
        testOppRcd.Is_Booking_Form_Submitted_by_Customer__c=false;
        testOppRcd.Project__c = testProjectRcd.Id;
        testOppRcd.Walk_in_Source__c = 'Hoarding';
        insert testOppRcd;
        
        
        Pricing_Plan__c testPricingPlanRcd = new Pricing_Plan__c();
        testPricingPlanRcd.Name = 'Pricing Plan Test';
        testPricingPlanRcd.Project__c = testProjectRcd.Id;
        insert testPricingPlanRcd;
        
        
        Property__c testPropertyRcd = new Property__c();
        testPropertyRcd.Name = 'test property';
        testPropertyRcd.Project__c = testProjectRcd.Id;
        testPropertyRcd.Property_Price_Slab__c = testPricingPlanRcd.Id;
        testPropertyRcd.Floor__c= '5';
        insert testPropertyRcd;
        
    
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
        insert testBookingRcd;
        
        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Rera_Number_Update_Notification' LIMIT 1];

        Case caseRcd1=new Case();
        caseRcd1.Subject='Test Case 1';
        caseRcd1.Description='Test Desc';
        caseRcd1.Origin='Email';
        caseRcd1.Status='New';
        caseRcd1.Booking__c=testBookingRcd.Id;
        caseRcd1.Type='Channel Partner Complaint';
        caseRcd1.Complaint_category__c='Payments';
        insert caseRcd1;
        
        //Datetime dateBefore3Days = Datetime.now().addDays(-3);
        //Test.setCreatedDate(caseRcd1.Id, dateBefore3Days); 

        Test.startTest();
        ChannelPartnerHandler.sendSmsToCustomerForNewCP(accountList);
        Test.stopTest();
        
    }
}