@isTest
public class BookingFormSubmitReminderBatch_Test {
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
        
        //test opportunity record
        TimeZone tz = UserInfo.getTimeZone();
        DateTime dt = Datetime.now();
        Id businessHourId = [SELECT Id FROM BusinessHours WHERE IsDefault = true].Id;
        Integer hours = -24;
        Datetime bookingFormShareToCustDateTime=BusinessHours.add(businessHourId,dt, hours * 60 * 60 * 1000L);
        Date bookingFormShareToCustDate=system.today().AddDays(1);
        
        //test project record
        Project__c testProjectRcd = new Project__c();
        testProjectRcd.Name = 'Test Project';
        testProjectRcd.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        testProjectRcd.Budgets__c = 'Under 75 lakhs';
        testProjectRcd.Configuration__c ='3 BHK';
        insert testProjectRcd;
        
        Opportunity testOppRcd = new Opportunity();
        testOppRcd.AccountId = testAccRcd.Id;
        testOppRcd.Name = 'Test Opportunity';
        testOppRcd.StageName = 'Site Visit';
        testOppRcd.CloseDate = System.Today()+3;
        testOppRcd.Booking_Form_Shared_to_Customer_Date__c = bookingFormShareToCustDate;
        testOppRcd.Is_Booking_Form_Submitted_by_Customer__c=false;
        testOppRcd.Project__c = testProjectRcd.Id;
        testOppRcd.Walk_in_Source__c = 'Hoarding';
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
        
        Test.startTest();
        BookingFormSubmitReminderBatch testBatch1= new BookingFormSubmitReminderBatch();
        Test.setMock(HttpCalloutMock.class, new SendSMSMock());
        Database.executeBatch(testBatch1);
        Test.stopTest();
    }
}