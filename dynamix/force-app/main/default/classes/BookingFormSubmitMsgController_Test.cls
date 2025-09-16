@isTest
public class BookingFormSubmitMsgController_Test {
    static testMethod void testMethod1(){ 

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
        testAccRcd2.PersonMobilePhone = '1234567891';
        testAccRcd2.RecordTypeId=personAccRcdTypeId;  
        testAccRcd2.Country__c='India';
        testAccRcd2.Organisation_Country__c='India';
        testAccRcd2.Nationality__c='Indian';
        insert testAccRcd2;
        
         //test project record
        Project__c testProjectRcd = new Project__c();
        testProjectRcd.Name = 'Test Project';
        testProjectRcd.Project_Carpet_Area__c = '475 - 1 BHK';
        testProjectRcd.Budgets__c = 'Under 75 lakhs';
        testProjectRcd.Configuration__c ='1 BHK';
        insert testProjectRcd;
        
        //test opportunity record
        Opportunity testOppRcd = new Opportunity();
        testOppRcd.AccountId = testAccRcd1.Id;
        testOppRcd.Name = 'Test Opportunity';
        testOppRcd.StageName = 'Site Visit Done';
        testOppRcd.CloseDate = System.Today()+3;
        testOppRcd.Nature_of_Purchase__c='Self Use';
        testOppRcd.Is_Booking_Form_Submitted_by_Customer__c=true;
        testOppRcd.EOI_Booking__c='Yes';
        testOppRcd.EOI_Date__c=System.today();
        testOppRcd.Walk_in_Source__c = 'Referred by Existing Customer';
        testOppRcd.Project__c = testProjectRcd.Id;
        testOppRcd.EOI_Amount__c=5000;
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
        
        //test booking record
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd1.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        insert testBookingRcd;
        
        //test payment record
        Payment__c testPaymentRcd=new Payment__c();
        testPaymentRcd.Booking__c=testBookingRcd.Id;
        testPaymentRcd.Cheque_Transaction_Number__c='12345';
        testPaymentRcd.Amount__c=50000;
        testPaymentRcd.Payment_Date__c=System.today();
        testPaymentRcd.Bank_Name__c='ICICI';
        insert testPaymentRcd;
        
        //Test Co-applicant
        Co_Applicant__c testCoAppRcd1=new Co_Applicant__c();
        testCoAppRcd1.Account__c=String.valueOf(testAccRcd2.Id) ;
        testCoAppRcd1.Booking__c=testBookingRcd.Id;
        insert testCoAppRcd1;
        
        Test.startTest();   
        pagereference testPage = page.BookingFormSubmitMsg; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(testBookingRcd.Id));       
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(testBookingRcd);   
        BookingFormSubmitMsgController ext = new BookingFormSubmitMsgController(); 
         ext.submittedBy='customer';
        ext.saveBookingFormDocument();
        Test.stopTest();
    }
    static testMethod void testMethod2(){ 
       
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
        testAccRcd2.PersonMobilePhone = '1234567891';
        testAccRcd2.RecordTypeId=personAccRcdTypeId;  
        testAccRcd2.Country__c='India';
        testAccRcd2.Organisation_Country__c='India';
        testAccRcd2.Nationality__c='Non-Resident Indian';
        insert testAccRcd2;
        Project__c testProjectRcd = new Project__c();
        testProjectRcd.Name = 'Test Project';
        testProjectRcd.Project_Carpet_Area__c = '475 - 1 BHK';
        testProjectRcd.Budgets__c = 'Under 75 lakhs';
        testProjectRcd.Configuration__c ='1 BHK';
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
        testOppRcd.Walk_in_Source__c = 'Referred by Existing Customer';
        testOppRcd.Project__c = testProjectRcd.Id;
        insert testOppRcd;
        
        //test project record
        
        
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
        
        //test booking record
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd1.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        insert testBookingRcd;
        
        //test payment record
        Payment__c testPaymentRcd=new Payment__c();
        testPaymentRcd.Booking__c=testBookingRcd.Id;
        testPaymentRcd.Cheque_Transaction_Number__c='12345';
        testPaymentRcd.Amount__c=50000;
        testPaymentRcd.Payment_Date__c=System.today();
        testPaymentRcd.Bank_Name__c='ICICI';
        insert testPaymentRcd;
        
        //Test Co-applicant
        Co_Applicant__c testCoAppRcd1=new Co_Applicant__c();
        testCoAppRcd1.Account__c=String.valueOf(testAccRcd2.Id) ;
        testCoAppRcd1.Booking__c=testBookingRcd.Id;
        insert testCoAppRcd1;
          Test.startTest(); 
        ContentVersion testContVerRcd=new ContentVersion(); 
        testContVerRcd.Title='Booking Form'; 
        testContVerRcd.PathOnClient='Booking Form' + '.pdf'; 
        Blob bodyBlob3=Blob.valueOf('Test Booking Form'); 
        testContVerRcd.VersionData=bodyBlob3; 
        testContVerRcd.SObjectType__c='Booking__c';
        testContVerRcd.Document_Type__c='Booking Form';
        testContVerRcd.origin = 'C';
        insert testContVerRcd;
       
        ContentDocumentLink testContentLinkRcd=new ContentDocumentLink();
        testContentLinkRcd.LinkedEntityId=testBookingRcd.Id;
        testContentLinkRcd.contentdocumentid=[select contentdocumentid from contentversion where id =: testContVerRcd.id].contentdocumentid;
        testContentLinkRcd.ShareType = 'V';
        testContentLinkRcd.Visibility = 'AllUsers';       
        insert testContentLinkRcd;
        
              
        pagereference testPage = page.BookingFormSubmitMsg; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(testBookingRcd.Id));       
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(testBookingRcd);   
        BookingFormSubmitMsgController ext = new BookingFormSubmitMsgController();  
        ext.submittedBy='customer';
        ext.saveBookingFormDocument();
        Test.stopTest();
    }
}