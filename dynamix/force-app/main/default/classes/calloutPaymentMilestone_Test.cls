@isTest
public class calloutPaymentMilestone_Test {
	@isTest
    public static void testRun(){
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
        
        Tower__c  tw = new Tower__c();
        tw.Name = 'Divum';
        tw.Project__c = proj.Id;
        tw.Tower_SAP_Code__c = '1403';
        Insert tw;
        
        Booking__c  buk = new Booking__c();
        buk.Stage__c = 'Draft';
        buk.Project_Name__c = proj.Id;
        buk.Booking_Date__c = system.today();
        buk.Related_Opportunity__c = opp.Id;
        buk.Primary_Applicant__c = acc.id;
        buk.Stage__c = 'Draft';
        buk.Project_Name__c = proj.Id;
        buk.Tower_Name__c = tw.Id;
        buk.Booking_Date__c = system.today();
        buk.Prior_Primary_Applicant__c = acc.Id;
        buk.Sap_Code__c = '3000000745';
        //buk.Related_Suggested_Property__c = suggProp.Id;
        Insert buk;
        
        Co_Applicant__c coApp = new Co_Applicant__c();
        coApp.Booking__c = buk.Id;
        coApp.Account__c = acc.id;
        coApp.Sap_Code__c = '124564';
        coApp.Role__c = 'Primary';
        Insert coApp;
        
        List<Payment_Milestones__c> paymentList = new List<Payment_Milestones__c>();
        Payment_Milestones__c paymentMile = new Payment_Milestones__c();
        paymentMile.Name = 'Booking Value';
        paymentMile.Sequence_No__c = 1;
        paymentMile.Milestone_Status__c = 'Active';
        paymentMile.Milestone_age__c = 50;
        paymentMile.Booking__c = buk.Id;
        paymentMile.Milestone_Activation_Date__c = system.today();
        paymentMile.Sap_Code__c = 'Z111';
        paymentMile.Milestone_Amount1__c = 3500000;
        paymentList.add(paymentMile);
        
        Payment_Milestones__c paymentMile1 = new Payment_Milestones__c();
        paymentMile1.Name = 'Milestone 1';
        paymentMile1.Sequence_No__c = 1;
        paymentMile1.Milestone_Status__c = 'Active';
        paymentMile1.Milestone_age__c = 50;
        paymentMile1.Booking__c = buk.Id;
        paymentMile1.Milestone_Activation_Date__c = system.today();
        paymentMile1.Sap_Code__c = 'Z112';
        paymentMile1.Milestone_Amount1__c = 3500000;
        paymentList.add(paymentMile1);
        Insert paymentList;
        
        List<calloutPaymentMilestone.request> reqList = new List<calloutPaymentMilestone.request>();
        calloutPaymentMilestone.request req = new calloutPaymentMilestone.request();
        req.bookingId = paymentMile1.Booking__c;
        req.currentMilestoneId = paymentMile1.Id;
        req.operationType = 'I';
        reqList.add(req);
        
        Data_Sync__c mileDataSync = new Data_Sync__c();
        mileDataSync.RecordId__c = paymentMile1.Id;
        mileDataSync.Status__c = 'Pending';
        mileDataSync.Event_Type__c = 'Payment Milestone';
        insert mileDataSync;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new callOutBookingCreationTestMock());
        calloutPaymentMilestone.getPaymentMilestoneBooking(reqList);
        Test.stopTest();
    }
}