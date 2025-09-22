@isTest
private class calloutBookingUpdate_Test {
    @isTest static void getBooking_Test(){
        Profile prf = [Select id , name from Profile where name = 'System Administrator'];
        Profile prf1 = [Select id , name from Profile where name = 'Sales Manager'];
        
        User testUser = new User(Username='ABC006@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf.Id);
        insert testUser;
        
       // UserRole r = [Select Id from UserRole where DeveloperName = 'Sales Manager'];
        User testUser1 = new User(Username='ABC01206@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf1.Id);
        Insert testUser1;
        
        
        String recordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = recordtypeId;
        acc.Email__c = 'sunfeast@gmail.com';
        acc.PersonMobilePhone = '9856984569';
        acc.Aadhar_No__pc = '789456213245';
         acc.FirstName='Pant';
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
        proj.Budgets__c = '1.75 cr - 2.25 cr';
        proj.Project_Carpet_Area__c = '750 – 800 sq.ft.' ;
        Insert proj;
        
        Tower__c  tw = new Tower__c();
        tw.Name = 'Divum';
        tw.Project__c = proj.Id;
        tw.Tower_SAP_Code__c = '1403';
        Insert tw;
        
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
        buk.Stamp_Duty_Date__c = system.today().addDays(30);
        buk.Related_Opportunity__c = opp.Id;
        buk.Primary_Applicant__c = acc.id;
        buk.Stamp_Duty_Status__c = 'Dynamix';
        buk.Registration_Date__c = system.today().addDays(15);
        buk.Registration_Number__c = '1245678';
        buk.Confirmation_Deed_Reg_Challan_No__c = '78458';
        buk.Agreement_Date__c = system.today().addDays(30);
        buk.Sales_Manager__c = testUser1.id;
        buk.Stage__c = 'Draft';
        buk.Project_Name__c = proj.Id;
        buk.Tower_Name__c = tw.Id;
        buk.Sap_Code__c = '145263';
        buk.SO_Created_Date__c = system.today().addDays(2);
        buk.Booking_Date__c = system.today();
        buk.Prior_Primary_Applicant__c = acc.Id;
        //buk.Related_Suggested_Property__c = suggProp.Id;
        Insert buk;
        
        buk.Registration_Number__c = '54569';
        Update buk;
        
        Data_Sync__c demandDataSync = new Data_Sync__c();
        demandDataSync.RecordId__c = buk.Id;
        demandDataSync.Status__c = 'Pending';
        demandDataSync.Event_Type__c = 'Booking';
        insert demandDataSync;
        
        List<calloutBookingUpdate.request> reqList = new List<calloutBookingUpdate.request>();
        calloutBookingUpdate.request req = new calloutBookingUpdate.request();
        req.bookingIds = buk.Id;
        reqList.add(req);
        
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new callOutBookingCreationTestMock());
        calloutBookingUpdate.getBooking(reqList);
        //calloutBookingCreation.exposeBookingToSAP(buk.Id);
        Test.stopTest();
        
    }

}