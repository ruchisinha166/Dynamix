@isTest
private class EOICARefundRestAPI_Test {
    @isTest static void getEOICARefund_Test(){
        Profile prf = [Select id , name from Profile where name = 'System Administrator'];
        Profile prf1 = [Select id , name from Profile where name = 'Sales Manager'];
        
        User testUser = new User(Username='ABC006@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf.Id);
        insert testUser;
        
        User testUser1 = new User(Username='ABC01206@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf1.Id);
        Insert testUser1;
        
        String recordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = recordtypeId;
        acc.PersonEmail = 'sunfeast@gmail.com';
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
        opp.EOI_CA_Customer_Code__c = '00400000080';
        Insert opp;
        
        OrgWideEmailAddress orgadd = [Select Id,Address from OrgWideEmailAddress where Address = 'divum@dynamixgroup.co.in'];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        String sbody = '{"ZFI014_SFDC_EOI_REFUND":{"EOI_REFUND":{"item":[{"BUKRS":"1400","PRCTR":"14001403","KUNNR":"'+opp.EOI_CA_Customer_Code__c+'","NAME1":"Test Name","BU_SORT2":"","H_BUDAT":"25.04.2024","BELNR":"1010000001","KTOKD":"ZEOI","DMBTR":"30000.50","KIDNO":"9010000028","BANKA":"ICICI"},{"BUKRS":"1100","PRCTR":"11001103","KUNNR":"0020000002","NAME1":"Test Name","BU_SORT2":"B-0839","H_BUDAT":"01.01.2024","BELNR":"1010000002","KTOKD":"ZEOI","DMBTR":"25000.00","KIDNO":"9010000029","BANKA":"HDFC BANK LIMITED"}]}}}';
        Blob blb = Blob.valueof(sbody);
        req.requestURI = '/services/apexrest/EOICARefund';
        req.httpMethod = 'GET';
        req.requestBody = blb;
        RestContext.request = req;
        RestContext.response= res;
        EOICARefundRestAPI.getEOICARefund();
        EOI_CARefundEmail.sendRefundEmail(opp.Id, orgadd.Id);
        Test.stopTest();

    }
}