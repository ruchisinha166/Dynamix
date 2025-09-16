@isTest
public class BookingCancellationChecklist_Test {
    static testMethod void testMethod1(){  
        String personAccRcdTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        //test account record
        Account testAccRcd = new Account();
        testAccRcd.Salutation='Mr.';
        testAccRcd.FirstName='Test FName';
        testAccRcd.LastName='Test LName';
        testAccRcd.BillingCountry = 'India';
        testAccRcd.PersonMobilePhone = '9234567890';
        testAccRcd.PersonEmail = 'mayur.patel@manras.com';
        testAccRcd.RecordTypeId=personAccRcdTypeId;         
        insert testAccRcd;
        
        //test account record 2
        Account testAccRcd2 = new Account();
        testAccRcd2.Salutation='Ms.';
        testAccRcd2.FirstName='Test FName1';
        testAccRcd2.LastName='Test LName1';
        testAccRcd2.BillingCountry = 'India';
        testAccRcd2.PersonMobilePhone = '1234567890';
        testAccRcd2.RecordTypeId=personAccRcdTypeId;  
        testAccRcd2.Country__c='India';
        testAccRcd2.Organisation_Country__c='India';
        insert testAccRcd2;
        
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
        
        //Test Co-applicant
        Co_Applicant__c testCoAppRcd1=new Co_Applicant__c();
        testCoAppRcd1.Account__c=String.valueOf(testAccRcd2.Id) ;
        testCoAppRcd1.Booking__c=testBookingRcd.Id;
        testCoAppRcd1.Role__c='Primary';
        insert testCoAppRcd1;
        
        Co_Applicant__c testCoAppRcd2=new Co_Applicant__c();
        testCoAppRcd2.Account__c=String.valueOf(testAccRcd.Id) ;
        testCoAppRcd2.Booking__c=testBookingRcd.Id;
        testCoAppRcd2.Role__c='Co-Applicant';
        insert testCoAppRcd2;
        
        Test.startTest();
        pagereference testPage2 = page.BookingCancellationChecklist; 
        Test.setCurrentPage(testPage2);
        testPage2.getParameters().put('Id', String.valueOf(testBookingRcd.Id));              
        ApexPages.StandardController sc1 = new  ApexPages.StandardController(testBookingRcd);   
        BookingCancellationChecklist ext1 = new BookingCancellationChecklist(sc1);  
        Test.stopTest();
    }
}