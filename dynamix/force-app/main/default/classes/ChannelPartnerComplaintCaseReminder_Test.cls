@isTest
Public class ChannelPartnerComplaintCaseReminder_Test {
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
        insert testBookingRcd;
        
        //Insert test case record
        Case caseRcd1=new Case();
        caseRcd1.Subject='Test Case 1';
        caseRcd1.Description='Test Desc';
        caseRcd1.Origin='Email';
        caseRcd1.Status='New';
        caseRcd1.Booking__c=testBookingRcd.Id;
        caseRcd1.Type='Channel Partner Complaint';
        caseRcd1.Complaint_category__c='Payments';
        insert caseRcd1;
        
        Datetime dateBefore3Days = Datetime.now().addDays(-3);
        Test.setCreatedDate(caseRcd1.Id, dateBefore3Days); 
        
        Test.startTest();
        ChannelPartnerComplaintCaseReminder testBatch1= new ChannelPartnerComplaintCaseReminder();
        Database.executeBatch(testBatch1);
        Test.stopTest();
        
    }
}