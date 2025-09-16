@isTest
public class BookingFormDocVfpController_Test {
    static testMethod void testMethod1(){
        
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
            
            String personAccRcdTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();        
            
            //test account record 1
            Account testAccRcd1 = new Account();
            testAccRcd1.Salutation='Mr.';
            testAccRcd1.FirstName='Test FName';
            testAccRcd1.LastName='Test LName';
            testAccRcd1.BillingCountry = 'India';
            testAccRcd1.PersonMobilePhone = '1234567890';
            testAccRcd1.RecordTypeId=personAccRcdTypeId;         
            testAccRcd1.Country__c='India';
            testAccRcd1.Organisation_Country__c='India';
            testAccRcd1.Nationality__c='Indian';
            insert testAccRcd1;
            
            //test account record 2
            Account testAccRcd2 = new Account();
            testAccRcd2.Salutation='Ms.';
            testAccRcd2.FirstName='Test FName1';
            testAccRcd2.LastName='Test LName1';
            testAccRcd2.BillingCountry = 'India';
            testAccRcd2.PersonMobilePhone = '1234567568';
            testAccRcd2.RecordTypeId=personAccRcdTypeId;  
            testAccRcd2.Country__c='India';
            testAccRcd2.Organisation_Country__c='India';
            testAccRcd2.Nationality__c='Non-Resident Indian';
            insert testAccRcd2;
            
            
            //test project record
            Project__c testProjectRcd = new Project__c();
            testProjectRcd.Name = 'Test Project';
            testProjectRcd.Project_Header__c='Test Header'; 
            testProjectRcd.Project_Footer__c='Test Footer';
            testProjectRcd.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
            testProjectRcd.Budgets__c = 'Under 75 lakhs';
            testProjectRcd.Configuration__c ='3 BHK';
            insert testProjectRcd;
            
            //test opportunity record
            Opportunity testOppRcd = new Opportunity();
            testOppRcd.AccountId = testAccRcd1.Id;
            testOppRcd.Name = 'Test Opportunity';
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
            
            
            //test Project offer record
            Booking_Offer__c testBookingOfferRcd=new Booking_Offer__c();
            testBookingOfferRcd.Start_Date__c=System.today()-3;
            testBookingOfferRcd.End_Date__c=System.today()+3;
            testBookingOfferRcd.Project__c=testProjectRcd.Id;
            testBookingOfferRcd.Approval_Status__c='Rejected';
            //testBookingOfferRcd.Active__c=true;
            insert testBookingOfferRcd;
            
            //test pricing Plan record
            Pricing_Plan__c testPricingPlanRcd = new Pricing_Plan__c();
            testPricingPlanRcd.Name = 'Pricing Plan Test';
            testPricingPlanRcd.Project__c = testProjectRcd.Id;
            insert testPricingPlanRcd;
            
            //test Property record
            Property__c testPropertyRcd = new Property__c();
            testPropertyRcd.Name = 'test property';
            testPropertyRcd.Project__c = testProjectRcd.Id;
            testPropertyRcd.Property_Price_Slab__c = testPricingPlanRcd.Id;
            testPropertyRcd.Floor__c= '5';
            insert testPropertyRcd;
            
            //test suggested property record
            Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
            testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
            testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
            testSuggPropertyRcd.Discount__c = 10;
            insert testSuggPropertyRcd;      
            Test.startTest(); 
            //test booking record
            Booking__c testBookingRcd = new Booking__c();
            testBookingRcd.Primary_Applicant__c = testAccRcd1.Id;
            testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
            testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
            testBookingRcd.Project_Name__c = testProjectRcd.Id;
            testBookingRcd.Sub_Booking_Offer__c='Test 123';
            testBookingRcd.Booking_Form_OTP__c='12345';
            testBookingRcd.OwnerId =testUserRcd1.id;
            insert testBookingRcd;
            
            //test payment record
            Payment__c testPaymentRcd=new Payment__c();
            testPaymentRcd.Booking__c=testBookingRcd.Id;
            testPaymentRcd.Cheque_Transaction_Number__c='12345';
            testPaymentRcd.Amount__c=50000;
            testPaymentRcd.Payment_Date__c=System.today();
            testPaymentRcd.Bank_Name__c='ICICI';
            testPaymentRcd.Receipt_No__c = '1234234';
            testPaymentRcd.Payment_Category__c = 'Unit Cost';
            insert testPaymentRcd;
            
            //Test Co-applicant
            Co_Applicant__c testCoAppRcd1=new Co_Applicant__c();
            testCoAppRcd1.Account__c=String.valueOf(testAccRcd1.Id) ;
            testCoAppRcd1.Booking__c=testBookingRcd.Id;
            testCoAppRcd1.Role__c = 'Primary';
            insert testCoAppRcd1;
            
            Co_Applicant__c testCoAppRcd2 = new Co_Applicant__c();
            testCoAppRcd2.Account__c = String.valueOf(testAccRcd2.Id) ;
            testCoAppRcd2.Booking__c = testBookingRcd.Id;
            testCoAppRcd2.Role__c = 'Co-Applicant';
            insert testCoAppRcd2;
            
            List<EmailTemplate> emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName =: 'Booking_Cancellation_Approved_RM' OR DeveloperName =: 'Booking_Cancellation_RejectedRM' limit 2];
            pagereference testPage = page.BookingFormDocument; 
            Test.setCurrentPage(testPage);
            testPage.getParameters().put('Id', String.valueOf(testBookingRcd.Id));       
            
            ApexPages.StandardController sc = new  ApexPages.StandardController(testBookingRcd);   
            BookingFormDocVfpController ext = new BookingFormDocVfpController(sc);  
            Test.stopTest();
        }
    }
    static testMethod void testMethod2(){ 
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
            
            String personAccRcdTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();        
            //test account record 1
            Account testAccRcd1 = new Account();
            testAccRcd1.Salutation='Mr.';
            testAccRcd1.FirstName='Test FName1';
            testAccRcd1.LastName='Test LName1';
            testAccRcd1.BillingCountry = 'India';
            testAccRcd1.PersonMobilePhone = '1234567890';
            testAccRcd1.RecordTypeId=personAccRcdTypeId;         
            testAccRcd1.Country__c='India';
            testAccRcd1.Organisation_Country__c='India';
            testAccRcd1.Nationality__c='Non-Resident Indian';
            insert testAccRcd1;
            
            //test account record 2
            Account testAccRcd2 = new Account();
            testAccRcd2.Salutation='Ms.';
            testAccRcd2.FirstName='Test FName1';
            testAccRcd2.LastName='Test LName1';
            testAccRcd2.BillingCountry = 'India';
            testAccRcd2.PersonMobilePhone = '1234656890';
            testAccRcd2.RecordTypeId=personAccRcdTypeId;  
            testAccRcd2.Country__c='India';
            testAccRcd2.Organisation_Country__c='India';
            testAccRcd2.Nationality__c='Non-Resident Indian';
            insert testAccRcd2;
            
            //test project record
            Project__c testProjectRcd = new Project__c();
            testProjectRcd.Name = 'Test Project';
            testProjectRcd.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
            testProjectRcd.Budgets__c = 'Under 75 lakhs';
            testProjectRcd.Configuration__c ='3 BHK';
            insert testProjectRcd;
            
            //test opportunity record
            Opportunity testOppRcd = new Opportunity();
            testOppRcd.AccountId = testAccRcd1.Id;
            testOppRcd.Name = 'Test Opportunity';
            testOppRcd.StageName = 'Site Visit';
            testOppRcd.CloseDate = System.Today()+3;
            testOppRcd.Nature_of_Purchase__c='Investment';
            testOppRcd.Is_Booking_Form_Submitted_by_Customer__c=true;
            testOppRcd.EOI_Booking__c='Yes';
            testOppRcd.EOI_Date__c=System.today();
            testOppRcd.EOI_Amount__c=5000;
            testOppRcd.Project__c = testProjectRcd.Id;
            testOppRcd.Walk_in_Source__c = 'Hoarding';
            testOppRcd.KYC_Completed__c = true;
            testOppRcd.Stamp_Duty_Payable_By__c = 'Dynamix';
            insert testOppRcd;
            
            
            
            //test Project offer record
            Booking_Offer__c testBookingOfferRcd=new Booking_Offer__c();
            testBookingOfferRcd.Start_Date__c=System.today()-3;
            testBookingOfferRcd.End_Date__c=System.today()+3;
            testBookingOfferRcd.Project__c=testProjectRcd.Id;
            testBookingOfferRcd.Approval_Status__c='Rejected';
            //testBookingOfferRcd.Active__c=true;
            insert testBookingOfferRcd;
            
            //test pricing Plan record
            Pricing_Plan__c testPricingPlanRcd = new Pricing_Plan__c();
            testPricingPlanRcd.Name = 'Pricing Plan Test';
            testPricingPlanRcd.Project__c = testProjectRcd.Id;
            insert testPricingPlanRcd;
            
            //test Property record
            Property__c testPropertyRcd = new Property__c();
            testPropertyRcd.Name = 'test property';
            testPropertyRcd.Project__c = testProjectRcd.Id;
            testPropertyRcd.Property_Price_Slab__c = testPricingPlanRcd.Id;
            testPropertyRcd.Floor__c= '5';
            insert testPropertyRcd;
            
            //test suggested property record
            Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
            testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
            testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
            testSuggPropertyRcd.Discount__c = 10;
            insert testSuggPropertyRcd;      
            Test.startTest();  
            //test booking record
            Booking__c testBookingRcd = new Booking__c();
            testBookingRcd.Primary_Applicant__c = testAccRcd1.Id;
            testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
            testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
            testBookingRcd.Project_Name__c = testProjectRcd.Id;
            testBookingRcd.Sub_Booking_Offer__c='Test 123';
            testBookingRcd.Booking_Form_OTP__c='12345';
            testBookingRcd.OwnerId = testUserRcd1.id;
            insert testBookingRcd;
            
            //test payment record
            Payment__c testPaymentRcd=new Payment__c();
            testPaymentRcd.Booking__c=testBookingRcd.Id;
            testPaymentRcd.Cheque_Transaction_Number__c='12345';
            testPaymentRcd.Amount__c=50000;
            testPaymentRcd.Payment_Date__c=System.today();
            testPaymentRcd.Bank_Name__c='ICICI';
            testPaymentRcd.Receipt_No__c = '123563';
            testPaymentRcd.Payment_Category__c = 'Unit Cost';
            insert testPaymentRcd;
            
            //Test Co-applicant
            Co_Applicant__c testCoAppRcd1=new Co_Applicant__c();
            testCoAppRcd1.Account__c=String.valueOf(testAccRcd2.Id) ;
            testCoAppRcd1.Booking__c=testBookingRcd.Id;
            testCoAppRcd1.Role__c = 'Primary';
            insert testCoAppRcd1;
            
            
            pagereference testPage = page.BookingFormDocument; 
            Test.setCurrentPage(testPage);
            testPage.getParameters().put('Id', String.valueOf(testBookingRcd.Id));       
            
            ApexPages.StandardController sc = new  ApexPages.StandardController(testBookingRcd);   
            BookingFormDocVfpController ext = new BookingFormDocVfpController(sc);  
            Test.stopTest();
        }
    }
}