@isTest
private class calloutEOI_CA_Test {
    @isTest 
    static void testRun(){
        Profile prf = [Select id , name from Profile where name = 'System Administrator'];
        Profile prf1 = [Select id , name from Profile where name = 'Sales Manager'];
        
        User testUser = new User(Username='ABC006@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf.Id);
        insert testUser;
        
        User testUser1 = new User(Username='ABC01206@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf1.Id);
        Insert testUser1;
        
        String recordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = recordtypeId;
        acc.Email__c = 'sunfeast@gmail.com';
        acc.PersonMobilePhone = '9856984569';
        acc.PersonBirthdate = system.today().addMonths(-240);
        acc.Aadhar_No__pc = '789456213245';
        acc.FirstName = 'Kumar';
        acc.LastName = 'Sachin';
        Insert acc;
        
        Project__c proj = new Project__c();
        proj.Name = 'test';
        proj.Project_SAP_Code__c = '1400';
        proj.Project_Type__c = '10';
        proj.Project_Email__c = 'divum@dynamixgroup.co.in';
        proj.Project_Head__c = testUser.id;
        proj.Site_Head__c = testUser.id;
        proj.Configuration__c = '2 BHK';
        proj.Budgets__c = 'Under 75 lakhs';
        proj.Project_Carpet_Area__c = '750 – 800 sq.ft.' ;
        Insert proj;
        
        Opportunity opp = new Opportunity ();
        opp.Name = 'opp1';
        opp.AccountId = acc.Id;
        opp.StageName = 'Site Visit Done';
        opp.Budget1__c = 'Under 75 lakhs';
        opp.No_of_Total_Visits__c = 1;
        opp.Sales_Manager__c = testUser1.Id;
        opp.KYC_Completed__c = true;
        opp.Is_Booking_Form_Submitted_by_Customer__c = true;
        opp.Walk_in_Source__c = 'Social Media';
        opp.Stamp_Duty_Payable_By__c = 'Dynamix';
        opp.Project__c = proj.Id;
        opp.CloseDate = system.today().addDays(30);
        Insert opp;
        
        EOI_CA_Payment__c eoiPayment = new EOI_CA_Payment__c();
        eoiPayment.Amount__c = 10000;
        eoiPayment.Opportunity__c = opp.Id;
        eoiPayment.Payment_Status__c = 'Pending';
        insert eoiPayment;
        
        Data_Sync__c demandDataSync = new Data_Sync__c();
        demandDataSync.RecordId__c = opp.Id;
        demandDataSync.Status__c = 'Pending';
        demandDataSync.Event_Type__c = 'EOI/CA Customer';
        insert demandDataSync;
        
        List<calloutEOI_CACustomerCreation.request> reqList = new List<calloutEOI_CACustomerCreation.request>();
        calloutEOI_CACustomerCreation.request req = new calloutEOI_CACustomerCreation.request();
        req.accountId = acc.Id;
        req.opportunityId = opp.Id;
        req.cancellationFlag = '';
        reqList.add(req);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        calloutEOI_CACustomerCreation.getEOICACustomer(reqList);
        Test.stopTest();
    }
    @isTest 
    static void testRun1(){
        Profile prf = [Select id , name from Profile where name = 'System Administrator'];
        Profile prf1 = [Select id , name from Profile where name = 'Sales Manager'];
        
        User testUser = new User(Username='ABC006@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf.Id);
        insert testUser;
        
        User testUser1 = new User(Username='ABC01206@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf1.Id);
        Insert testUser1;
        
        String recordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = recordtypeId;
        acc.Email__c = 'sunfeast@gmail.com';
        acc.PersonMobilePhone = '9856984569';
        acc.PersonBirthdate = system.today().addMonths(-240);
        acc.Aadhar_No__pc = '789456213245';
        acc.FirstName = 'Kumar';
        acc.LastName = 'Sachin';
        Insert acc;
        
        Project__c proj = new Project__c();
        proj.Name = 'divum';
        proj.Project_SAP_Code__c = '1400';
        proj.Project_Type__c = '10';
        proj.Project_Email__c = 'divum@dynamixgroup.co.in';
        proj.Project_Head__c = testUser.id;
        proj.Site_Head__c = testUser.id;
        proj.Configuration__c = '2 BHK';
        proj.Budgets__c = 'Under 75 lakhs';
        proj.Project_Carpet_Area__c = '750 – 800 sq.ft.' ;
        Insert proj;
        
        Opportunity opp = new Opportunity ();
        opp.Name = 'opp1';
        opp.AccountId = acc.Id;
        opp.StageName = 'Site Visit Done';
        opp.Budget1__c = 'Under 75 lakhs';
        opp.No_of_Total_Visits__c = 1;
        opp.Sales_Manager__c = testUser1.Id;
        opp.KYC_Completed__c = true;
        opp.Is_Booking_Form_Submitted_by_Customer__c = true;
        opp.Walk_in_Source__c = 'Social Media';
        opp.Stamp_Duty_Payable_By__c = 'Dynamix';
        opp.Project__c = proj.Id;
        opp.CloseDate = system.today().addDays(30);
        Insert opp;
        
        EOI_CA_Payment__c eoiPayment = new EOI_CA_Payment__c();
        eoiPayment.Amount__c = 10000;
        eoiPayment.Opportunity__c = opp.Id;
        eoiPayment.Payment_Status__c = 'Pending';
        eoiPayment.Payment_Category__c = 'Unit Cost';
        insert eoiPayment;
        
        Data_Sync__c demandDataSync = new Data_Sync__c();
        demandDataSync.RecordId__c = eoiPayment.Id;
        demandDataSync.Status__c = 'Pending';
        demandDataSync.Event_Type__c = 'EOI/CA Payment';
        insert demandDataSync;
        
        List<calloutEOI_CAPayment.request> reqList1 = new List<calloutEOI_CAPayment.request>();
        calloutEOI_CAPayment.request req = new calloutEOI_CAPayment.request();
        req.paymentId = eoiPayment.Id;
        reqList1.add(req);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorPayment());
        calloutEOI_CAPayment.getEOI_CA_Payment(reqList1);
        Test.stopTest();
    }
    public class MockHttpResponseGeneratorPayment implements HttpCalloutMock
    {
        public HTTPResponse respond(HTTPRequest req) 
        {
            HttpResponse res = new HttpResponse();
            res.setStatus('SUCCESS');
            res.setStatusCode(200);
            res.setBody('{"item":[{"SFDC_ID":"a1271000000IdnhAAC","STATUS":"Success","MESSAGE":"Data Uploaded Successfully"}]}');
            return res;
        }
    }
}