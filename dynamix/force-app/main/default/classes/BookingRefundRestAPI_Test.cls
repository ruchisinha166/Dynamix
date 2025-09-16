@isTest
public class BookingRefundRestAPI_Test {
	@isTest
    static void getBookingRefund_Test(){
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
        
        Booking__c  buk = new Booking__c();
        buk.Stage__c = 'Draft';
        buk.Project_Name__c = proj.Id;
        buk.Booking_Date__c = system.today();
        buk.Related_Opportunity__c = opp.Id;
        buk.Primary_Applicant__c = acc.id;
        buk.Stage__c = 'Draft';
        buk.Project_Name__c = proj.Id;
        buk.Booking_Date__c = system.today();
        buk.Prior_Primary_Applicant__c = acc.Id;
        buk.Sap_Code__c = '3010077777';
        buk.OwnerId = testUser.Id;
        Insert buk;
        
        OrgWideEmailAddress owe = [Select Id,Address from OrgWideEmailAddress where Address =: proj.Project_Email__c];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        
        List<BookingRefundEmailToRM.request> reqList = new List<BookingRefundEmailToRM.request>();
        BookingRefundEmailToRM.request reqR = new BookingRefundEmailToRM.request();
        reqR.bookingIds = buk.Id;
        reqR.fromAddress = owe.Id;
        reqList.add(reqR);
        
        Test.startTest();
        String sbody = '{"ZFI014_SFDC_RES_REFUND":{"RES_REFUND":{"item":[{"BUKRS":"1100","PRCTR":"0011001102","KUNNR":"0020000055","NAME1":"Somgiri Goswami","BU_SORT2":"B-0523","H_BUDAT":"30.04.2024","BELNR":"1110000001","KTOKD":"ZREC","DMBTR":"26450.00","KIDNO":"9010000028","BANKA":"HDFC BANK LIMITED","VBELN":"9010000103"},{"BUKRS":"1100","PRCTR":"0011001102","KUNNR":"0020000056","NAME1":"Sushma Tripathi","BU_SORT2":"B-0524","H_BUDAT":"29.04.2024","BELNR":"1110000001","KTOKD":"ZREC","DMBTR":"29450.00","KIDNO":"9010000030","BANKA":"HDFC BANK LIMITED","VBELN":"'+buk.Sap_Code__c+'"}]}}}';
        Blob blb = Blob.valueof(sbody);
        req.requestURI = '/services/apexrest/BookingRefund';
        req.httpMethod = 'GET';
        req.requestBody = blb;
        RestContext.request = req;
        RestContext.response= res;
        BookingRefundRestAPI.getBookingRefund();
        BookingRefundEmailToRM.getBookingId(reqList);
        Test.stopTest();
    }
}