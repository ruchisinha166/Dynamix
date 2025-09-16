@isTest
public class TDSScript_Test {
    
    @isTest
    static void testExecuteMethod() {
        Profile prf = [SELECT id , name 
                       FROM Profile 
                       WHERE name = 'System Administrator'];
        
        Profile prf1 = [SELECT id , name 
                        FROM Profile 
                        WHERE name = 'Sales Manager'];
        
        User testUser = new User(Username='ABC006@gmail.com', 
                                 LanguageLocaleKey = 'en_US', 
                                 Alias = 'alias',
                                 EmailEncodingKey = 'UTF-8',
                                 LastName= 'qwe',
                                 Email='testuser@example.com',
                                 TimeZoneSidKey = 'America/Los_Angeles', 
                                 LocaleSidKey = 'en_US', 
                                 ProfileId = prf.Id);
        insert testUser;
        
        User testUser1 = new User(Username='ABC01206@gmail.com', 
                                  LanguageLocaleKey = 'en_US', 
                                  Alias = 'alias',
                                  EmailEncodingKey = 'UTF-8',
                                  LastName= 'qwe',
                                  Email='testuser@example.com',
                                  TimeZoneSidKey = 'America/Los_Angeles', 
                                  LocaleSidKey = 'en_US', 
                                  ProfileId = prf1.Id);
        Insert testUser1;
        
        String recordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('PersonAccount').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = recordtypeId;
        acc.Email__c = 'yogesh.sharma@manras.com';
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
        proj.Budgets__c = '1.75 cr - 2.25 cr';
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
        
        Booking__c  testBook = new Booking__c();
        testBook.Stage__c = 'Draft';
        testBook.Project_Name__c = proj.Id;
        testBook.Booking_Date__c = system.today();
        testBook.Related_Opportunity__c = opp.Id;
        testBook.Primary_Applicant__c = acc.id;
        testBook.Stage__c = 'Draft';
        testBook.Project_Name__c = proj.Id;
        testBook.Tower_Name__c = tw.Id;
        testBook.Booking_Date__c = system.today();
        testBook.Prior_Primary_Applicant__c = acc.Id;
        testBook.Sap_Code__c = '3010000180';
        Insert testBook;
        
        Co_Applicant__c coApp = new Co_Applicant__c();
        coApp.Booking__c = testBook.Id;
        coApp.Account__c = acc.id;
        coApp.Sap_Code__c = '124564';
        coApp.Role__c = 'Primary';
        Insert coApp;
        
        List<Payment_Milestones__c> paymentList = new List<Payment_Milestones__c>();
        
        Payment_Milestones__c paymentMile1 = new Payment_Milestones__c();
        paymentMile1.Name = 'Milestone 1';
        paymentMile1.Sequence_No__c = 1;
        paymentMile1.Milestone_Status__c = 'Active';
        paymentMile1.Milestone_age__c = 50;
        paymentMile1.Booking__c = testBook.Id;
        paymentMile1.TDS_Received__c = 0;
        paymentMile1.Milestone_Activation_Date__c = system.today();
        paymentMile1.Sap_Code__c = 'Z112';
        paymentMile1.Calculate_TDS__c  = true;
        paymentMile1.Milestone_Amount1__c = 350000000;
        paymentList.add(paymentMile1);
        Insert paymentList;
        
        Payment__c paymnt = new Payment__c();
        paymnt.Booking__c = testBook.Id;
        paymnt.Paid_By__c = 'Self';
        paymnt.Amount__c = 100000;
        paymnt.Remaining_TDS_Amount__c = 10;
        paymnt.Payment_Status__c = 'Approved';
        paymnt.Payment_Date__c = system.today();
        paymnt.Payment_Category__c = 'TDS';
        paymnt.Cheque__c = '12354';
        paymnt.Date__c = system.today();
        paymnt.Payment_Mode__c = 'NEFT';
        paymnt.Payment_Type__c = 'NEFT/ RTGS/ IMPS';
        paymnt.Receipt_No__c = '21314';
        paymnt.Cheque_Transaction_Number__c = '12356';
        Insert paymnt;
        
        Test.startTest();
        TDSScript.Execute('Active');
        Test.stopTest();
        
        List<Payment_Milestones__c> updatedMilestones = [SELECT TDS_Received__c FROM Payment_Milestones__c WHERE Id = :paymentMile1.Id];
        System.assertEquals(1000, updatedMilestones[0].TDS_Received__c);
        
        List<Payment__c> updatedPayments = [SELECT Remaining_TDS_Amount__c FROM Payment__c WHERE Id = :paymnt.Id];
        System.assertEquals(0, updatedPayments[0].Remaining_TDS_Amount__c);
    }
}