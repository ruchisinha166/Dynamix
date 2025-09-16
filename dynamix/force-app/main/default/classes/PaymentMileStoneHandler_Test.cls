@isTest
private class PaymentMileStoneHandler_Test {
    @isTest static void updateMilestonePercentOnBookingOnDelete_Test(){
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
        acc.PersonEmail = 'sunfeast@gmail.com';
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
        proj.Budgets__c = '1.2 – 1.4 Cr';
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
        buk.Sap_Code__c = '12457';
        //buk.Related_Suggested_Property__c = suggProp.Id;
        Insert buk;
        
        Payment_Milestones__c paymentMile = new Payment_Milestones__c();
        paymentMile.Name = 'Booking Value';
        paymentMile.Sequence_No__c = 1;
        paymentMile.Milestone_Status__c = 'Active';
        paymentMile.Milestone_age__c = 50;
        paymentMile.Booking__c = buk.Id;
        paymentMile.Milestone_Activation_Date__c = system.today();
        paymentMile.Sap_Code__c = 'Z111';
        paymentMile.Milestone_Amount1__c = 3500000;
        Insert paymentMile;
       
        
        Payment_Milestones__c paymentMile1 = new Payment_Milestones__c();
        paymentMile1.Name = 'Booking Value';
        paymentMile1.Sequence_No__c = 2;
        paymentMile1.Milestone_Status__c = 'Inactive';
        paymentMile1.Milestone_age__c = 50;
        paymentMile1.Booking__c = buk.Id;
        //paymentMile1.Milestone_Activation_Date__c = system.today();
        paymentMile1.Sap_Code__c = 'Z111';
        paymentMile1.Milestone_Amount1__c = 3500000;
        Insert paymentMile1;
        
        paymentMile1.Milestone_Status__c = 'Active';
        update paymentMile1;
           
        List<Payment_Milestones__c> pm = new List<Payment_Milestones__c>();
        Payment_Milestones__c paymentMile2 = new Payment_Milestones__c();
        paymentMile2.id = paymentMile.Id;
        pm.add(paymentMile2);
        Delete pm;
        
        Test.startTest();
        PaymentMileStoneHandler.updateMilestonePercentOnBookingOnDelete(pm);
        Test.stopTest();
        
    }

}