@isTest
public class GenerateBookingCancelChecklist_Test {
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
        
        Opportunity testOppRcd = new Opportunity();
        testOppRcd.AccountId = testAccRcd.Id;
        testOppRcd.Name = 'Test Opportunity';
        testOppRcd.StageName = 'Site Visit';
        testOppRcd.CloseDate = System.Today()+3;
        testOppRcd.Is_Booking_Form_Submitted_by_Customer__c=false;
        insert testOppRcd;
        
        //test project record
        Project__c testProjectRcd = new Project__c();
        testProjectRcd.Name = 'Test Project';
        insert testProjectRcd;
        
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
        testBookingRcd.Stage__c='Cancellation Initiated';
        insert testBookingRcd;
        
        GenerateBookingCancellationChecklist.Request allObj = new GenerateBookingCancellationChecklist.Request();
        allObj.bookingId = testBookingRcd.Id;
        List<GenerateBookingCancellationChecklist.Request> Requests = new List<GenerateBookingCancellationChecklist.Request>();
        Requests.add(allObj);
        GenerateBookingCancellationChecklist.execute(Requests);
    }
    static testMethod void testMethod2(){      
        String personAccRcdTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        //test account record
        Account testAccRcd1 = new Account();
        testAccRcd1.Salutation='Mr.';
        testAccRcd1.FirstName='Test FName';
        testAccRcd1.LastName='Test LName';
        testAccRcd1.BillingCountry = 'India';
        testAccRcd1.PersonMobilePhone = '1234567890';
        testAccRcd1.PersonEmail = 'mayur.patel@manras.com';
        testAccRcd1.RecordTypeId=personAccRcdTypeId;         
        insert testAccRcd1;
        
        Opportunity testOppRcd1 = new Opportunity();
        testOppRcd1.AccountId = testAccRcd1.Id;
        testOppRcd1.Name = 'Test Opportunity';
        testOppRcd1.StageName = 'Site Visit';
        testOppRcd1.CloseDate = System.Today()+3;
        testOppRcd1.Is_Booking_Form_Submitted_by_Customer__c=false;
        insert testOppRcd1;
        
        //test project record
        Project__c testProjectRcd1 = new Project__c();
        testProjectRcd1.Name = 'Test Project';
        insert testProjectRcd1;
        
        //test pricing Plan record
        Pricing_Plan__c testPricingPlanRcd1 = new Pricing_Plan__c();
        testPricingPlanRcd1.Name = 'Pricing Plan Test';
        testPricingPlanRcd1.Project__c = testProjectRcd1.Id;
        insert testPricingPlanRcd1;
        
        //test Property record
        Property__c testPropertyRcd1 = new Property__c();
        testPropertyRcd1.Name = 'test property';
        testPropertyRcd1.Project__c = testProjectRcd1.Id;
        testPropertyRcd1.Property_Price_Slab__c = testPricingPlanRcd1.Id;
        testPropertyRcd1.Floor__c= '5';
        insert testPropertyRcd1;
        
        //test suggested property record
        Suggested_Property__c testSuggPropertyRcd1 = new Suggested_Property__c();
        testSuggPropertyRcd1.Opportunity__c = testOppRcd1.Id;
        testSuggPropertyRcd1.Unit__c = testPropertyRcd1.Id;
        testSuggPropertyRcd1.Discount__c = 10;
        insert testSuggPropertyRcd1;
        
        //test booking record
        Booking__c testBookingRcd1 = new Booking__c();
        testBookingRcd1.Primary_Applicant__c = testAccRcd1.Id;
        testBookingRcd1.Related_Opportunity__c = testOppRcd1.Id;
        testBookingRcd1.Related_Suggested_Property__c = testSuggPropertyRcd1.Id;
        testBookingRcd1.Project_Name__c = testProjectRcd1.Id;
        testBookingRcd1.Stage__c='Cancellation Initiated';
        insert testBookingRcd1;
        
        Booking__c testBookingRcdForUpdate=[Select Id,Name,Stage__c From Booking__c Where Id=:testBookingRcd1.Id];
        testBookingRcdForUpdate.Stage__c='Booking Cancelled – Refund Pending';
        update testBookingRcdForUpdate;
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; 
        conVer.PathOnClient = 'Booking Cancellation Checklist' + '.pdf'; 
        conVer.Title = 'Booking Cancellation Checklist';
        conVer.VersionData = Blob.valueOf('Test primaryAccAddProofFile');
        conVer.SObjectType__c = 'Booking__c';
        conVer.Document_Type__c = 'Checklist - Booking Cancellation';
        conVer.isMajorVersion=false;
        insert conVer;
        
        ContentVersion contentVersionRcd = [SELECT Id, Title, ContentDocumentId 
                                            FROM ContentVersion WHERE Id = :conVer.Id LIMIT 1];
        
        //test Content doc record
        ContentDocumentLink testContDocLinkRcd=new ContentDocumentLink();
        testContDocLinkRcd.LinkedEntityId=testBookingRcdForUpdate.Id;
        testContDocLinkRcd.ShareType='V';
        testContDocLinkRcd.ContentDocumentId=contentVersionRcd.ContentDocumentId;
        insert testContDocLinkRcd;
        
        GenerateBookingCancellationChecklist.Request allObj = new GenerateBookingCancellationChecklist.Request();
        allObj.bookingId = testBookingRcd1.Id;
        List<GenerateBookingCancellationChecklist.Request> Requests = new List<GenerateBookingCancellationChecklist.Request>();
        Requests.add(allObj);
        GenerateBookingCancellationChecklist.execute(Requests);
    }
}