@isTest
public class BookingFormControllerTestV1 {
@isTest
    static void runTest(){
           Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName1 = 'standarduser2' + DateTime.now().getTime() + '@testorg.com';
        String uniqueUserName2 = 'standarduser3' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur';
        testUserRcd1.LastName = 'Patel';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName1;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        testUserRcd1.Country='India';
        insert testUserRcd1;
        String personAccRcdTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account testAccRcd1 = new Account();
        testAccRcd1.Salutation='Mr.';
        testAccRcd1.FirstName='Test FName';
        testAccRcd1.LastName='Test LName';
        testAccRcd1.BillingCountry = 'India';
        testAccRcd1.PersonMobilePhone = '4352521421';
        testAccRcd1.RecordTypeId=personAccRcdTypeId;         
        testAccRcd1.Country__c='India';
        testAccRcd1.Organisation_Country__c='India';
        testAccRcd1.Permanent_Address__c='test address';
        testAccRcd1.Post_Code__c='396430';
        testAccRcd1.State__c='Gujarat';
        testAccRcd1.PersonMailingStreet='Jay Hind Street';
        testAccRcd1.PersonBirthdate=System.today();
        testAccRcd1.Nationality__c='Indian';
        testAccRcd1.Address_Proof__c='Pan Card';
        testAccRcd1.PersonMobilePhone='1237567890';
        testAccRcd1.PersonEmail='abc@outlook.com';
        testAccRcd1.Preferred_Address_for_all_Corresppondenc__c='Permanent';
        insert testAccRcd1;
        
          Project__c testProjectRcd = new Project__c();
        testProjectRcd.Name = 'Test Project';
        testProjectRcd.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        testProjectRcd.Budgets__c = 'Under 75 lakhs';
        testProjectRcd.Configuration__c ='3 BHK';
        testProjectRcd.Project_Email__c = 'parkwoods@dynamixgroup.co.in';
        insert testProjectRcd;
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
        testOppRcd.EOI_CA__c = 'EOI';
        testOppRcd.Project__c = testProjectRcd.Id;
        insert testOppRcd;
        
        
             Booking_Offer__c testBookingOfferRcd=new Booking_Offer__c();
        testBookingOfferRcd.Start_Date__c=System.today()-3;
        testBookingOfferRcd.End_Date__c=System.today()+3;
        testBookingOfferRcd.Project__c=testProjectRcd.Id;
        testBookingOfferRcd.Approval_Status__c='Rejected';
        //testBookingOfferRcd.Active__c=true;
        insert testBookingOfferRcd;
        
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
        test.startTest();
        
        Booking__c testBookingRcd = new Booking__c();
        //testBookingRcd.Primary_Applicant__c = testAccRcd1.Id;
        testBookingRcd.Prior_Primary_Applicant__c = testAccRcd1.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        insert testBookingRcd;
        
        Payment__c testPaymentRcd=new Payment__c();
        testPaymentRcd.Booking__c=testBookingRcd.Id;
        testPaymentRcd.Cheque_Transaction_Number__c='12345';
        testPaymentRcd.Amount__c=50000;
        testPaymentRcd.Payment_Date__c=System.today();
        testPaymentRcd.Bank_Name__c='ICICI';
        testPaymentRcd.Receipt_No__c = '332211';
        insert testPaymentRcd;
        
        Co_Applicant__c testCoAppRcd1=new Co_Applicant__c();
        testCoAppRcd1.Account__c=String.valueOf(testAccRcd1.Id) ;
        testCoAppRcd1.Booking__c=testBookingRcd.Id;
        testCoAppRcd1.Role__c = 'Co-Applicant';
        insert testCoAppRcd1;
        Co_Applicant__c testCoAppRcd2=new Co_Applicant__c();
        testCoAppRcd2.Account__c=String.valueOf(testAccRcd1.Id) ;
        testCoAppRcd2.Booking__c=testBookingRcd.Id;
        testCoAppRcd2.Role__c = 'Primary';
        insert testCoAppRcd2;
        
        Offer__c testOffer=new Offer__c();
        testOffer.Booking__c=testBookingRcd.Id;
        testOffer.Project_Offer__c=testBookingOfferRcd.Id;      
        insert testOffer;
        
    }
}