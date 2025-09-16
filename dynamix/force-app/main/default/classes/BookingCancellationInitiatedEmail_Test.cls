@isTest
public class BookingCancellationInitiatedEmail_Test {
    static testMethod void testMethod1(){      
        String personAccRcdTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        //test account record
        Account testAccRcd = new Account();
        testAccRcd.Salutation='Mr.';
        testAccRcd.FirstName='Test FName';
        testAccRcd.LastName='Test LName';
        testAccRcd.BillingCountry = 'India';
        testAccRcd.PersonMobilePhone = '1234567890';
        testAccRcd.PersonEmail = 'mayur.patel@manras.com';
        testAccRcd.RecordTypeId=personAccRcdTypeId;         
        insert testAccRcd;
        
        //test project record
        Project__c testProjectRcd = new Project__c();
        testProjectRcd.Name = 'Test Project';
        insert testProjectRcd;
        
        Opportunity testOppRcd = new Opportunity();
        testOppRcd.AccountId = testAccRcd.Id;
        testOppRcd.Name = 'Test Opportunity';
        testOppRcd.StageName = 'Site Visit';
        testOppRcd.CloseDate = System.Today()+3;
        testOppRcd.Project__c = testProjectRcd.Id;
        testOppRcd.Is_Booking_Form_Submitted_by_Customer__c=false;
        insert testOppRcd;
        
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
        
        //test booking record
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        insert testBookingRcd;
        
        BookingCancellationInitiatedEmail.Request allObj = new BookingCancellationInitiatedEmail.Request();
        allObj.bookingId = testBookingRcd.Id;
        List<BookingCancellationInitiatedEmail.Request> Requests = new List<BookingCancellationInitiatedEmail.Request>();
        Requests.add(allObj);
        BookingCancellationInitiatedEmail.execute(Requests);
    }
}