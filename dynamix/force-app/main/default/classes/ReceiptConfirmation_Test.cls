@isTest
private class ReceiptConfirmation_Test {
    @isTest static void getdemandRecord_Test(){
        Profile prf = [Select id , name from Profile where name = 'System Administrator'];
        Profile prf1 = [Select id , name from Profile where name = 'Sales Manager'];
        
        User testUser = new User(Username='ABC006@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf.Id);
        insert testUser;
        
       // UserRole r = [Select Id from UserRole where DeveloperName = 'Sales Manager'];
        User testUser1 = new User(Username='ABC01206@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf1.Id);
        Insert testUser1;
        
        String recordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account accountObject = new Account();
        accountObject.RecordTypeId = recordtypeId;
        accountObject.Email__c = 'sunfeast@gmail.com';
        accountObject.PersonMobilePhone = '9856984569';
        accountObject.Aadhar_No__pc = '789456213245';
        accountObject.FirstName='Pant';
        accountObject.LastName = 'Sachin';
        Insert accountObject;
        
        Project__c proj = new Project__c();
        proj.Name = 'test';
        proj.Project_SAP_Code__c = '1400';
        proj.Project_Type__c = '10';
        proj.Project_Email__c = 'divum@dynamixgroup.co.in';
        proj.Project_Head__c = testUser.id;
        proj.Site_Head__c = testUser.id;
        proj.Configuration__c = '2 BHK';
        //proj.Budgets__c = '1.75 cr - 2.25 cr';
        proj.Project_Carpet_Area__c = '750 – 800 sq.ft.' ;
        Insert proj;
        
        Opportunity opp = new Opportunity ();
        opp.Name = 'opp1';
        opp.AccountId = accountObject.Id;
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
        
        Payment_Plan__c payPlan = new Payment_Plan__c();
        payPlan.Name = 'Testing Payment';
        payPlan.Project__c = proj.Id;
        Insert payPlan;
        
        List<Payment_Plan_Milestones__c> paymntPlanList = new List<Payment_Plan_Milestones__c>();
        Payment_Plan_Milestones__c payPlanMilestone = new Payment_Plan_Milestones__c();
        payPlanMilestone.Name = 'Booking Value';
        payPlanMilestone.Payment_Plan__c = payPlan.Id;
        payPlanMilestone.Sequence_No__c = 1;
        payPlanMilestone.Milestone_age__c = 50;
        payPlanMilestone.Milestone_Code__c = 'Z111';
        payPlanMilestone.Milestone_Activation__c = 'Booking Date';
        payPlanMilestone.Days_after_Booking__c = 0;
        paymntPlanList.add(payPlanMilestone);
        
        Payment_Plan_Milestones__c payPlanMilestone1 = new Payment_Plan_Milestones__c();
        payPlanMilestone1.Payment_Plan__c = payPlan.Id;
        payPlanMilestone1.Name = 'Milestone 1';
        payPlanMilestone1.Sequence_No__c = 2;
        payPlanMilestone1.Milestone_age__c = 50;
        payPlanMilestone1.Milestone_Code__c = 'Z112';
        payPlanMilestone1.Milestone_Activation__c = 'Booking Date';
        payPlanMilestone1.Days_after_Booking__c = 10;
        paymntPlanList.add(payPlanMilestone1);
        Insert paymntPlanList;
        
        List<Project_Add_On_Charges__c> projAddonList = new List<Project_Add_On_Charges__c>();
        Project_Add_On_Charges__c prjAddon1 = new Project_Add_On_Charges__c();
        prjAddon1.Name = 'Legal Charges';
        prjAddon1.Charge_Group__c = 'Others';
        prjAddon1.Charge_Type__c = 'Fixed';
        prjAddon1.Project__c = proj.Id;
        projAddonList.add(prjAddon1);
        
        Project_Add_On_Charges__c  prjAddon = new Project_Add_On_Charges__c();
        prjAddon.Name = 'Basic Price';
        prjAddon.Charge_Group__c = 'Agreement';
        prjAddon.Charge_Type__c = 'Fixed';
        prjAddon.Project__c = proj.Id;
        projAddonList.add(prjAddon);
        Insert projAddonList;
        
        Pricing_Plan__c pricingPlan = new Pricing_Plan__c ();
        pricingPlan.Name = 'testing Pricing';
        pricingPlan.Valid_to__c = System.Today().addDays(10);
        pricingPlan.Valid_from__c = System.Today().addDays(-15); 
        pricingPlan.Project__c = proj.Id;
        Insert pricingPlan;
        
        List<Pricing_Plan_Components__c> pricingPlanCompList = new List<Pricing_Plan_Components__c>();
        Pricing_Plan_Components__c pricngPlanCompnent1 = new Pricing_Plan_Components__c();
        pricngPlanCompnent1.Pricing_Plan__c = pricingPlan.Id;
        pricngPlanCompnent1.GST_Treatment__c = '5%';
        pricngPlanCompnent1.Price_Lumpsum__c = 300000;
        pricngPlanCompnent1.Component_Type__c = 'ZLC0';
        pricngPlanCompnent1.Project_Add_On_Charges__c = prjAddon1.Id;
        pricingPlanCompList.add(pricngPlanCompnent1);
        
        Pricing_Plan_Components__c pricngPlanCompnent = new Pricing_Plan_Components__c();
        pricngPlanCompnent.Pricing_Plan__c = pricingPlan.Id;
        pricngPlanCompnent.GST_Treatment__c = '18%';
        pricngPlanCompnent.Price_Lumpsum__c = 75000000;
        pricngPlanCompnent.Component_Type__c = 'ZPR0';
        pricngPlanCompnent.Project_Add_On_Charges__c = prjAddon.Id;
        pricingPlanCompList.add(pricngPlanCompnent);
        Insert pricingPlanCompList;
        
        Property__c prop = new Property__c();
        prop.Name = '9009';
        prop.Tower__c = tw.Id;
        prop.Project__c = proj.Id;
        prop.Property_Price_Slab__c = pricingPlan.id;
        prop.Start_Date__c = system.today();
        prop.Property_Status__c = 'Available';
        prop.Index__c = 25000000;
        prop.Floor__c = '9';
        prop.Construction_Status__c = 'Completed';
        prop.Features__c = '24 X 7 Working';
        prop.Terms_Conditions__c = 'https://bit.ly/3ahvfF4';
        prop.Annexures__c = 'https://bit.ly/3ahvfF412';
        prop.RERA_Carpet_Area__c = 6503.16;
        prop.Proposed_Area__c = 70000.00;
        prop.Deck_Proposed_Area__c = 40000;
        prop.Proposed_Utility_Area__c = 15000;
        prop.Proposed_Enclosed_Balcony_Area__c = 7000;
        prop.Property_Area_UOM__c = 'Sq.Ft.';
        prop.Distribution_Channel__c = '10';
        prop.Material_Type__c = 'ZFER';
        prop.Unit_classification__c = 'STANDARD';
        prop.Unit_View__c = 'EAST FACING';
        prop.Wing__c = 'WING A';
        prop.HSN_Code__c = '995411';
        prop.SAP_Code__c = '123546';
        Insert prop;
        
        Booking__c  buk = new Booking__c();
        buk.Stage__c = 'Draft';
        //buk.Project_Email__c = 'sf@gmail.com';
        buk.Project_Name__c = proj.Id;
        buk.Booking_Date__c = system.today();
        buk.Related_Opportunity__c = opp.Id;
        buk.Primary_Applicant__c = accountObject.id;
        buk.Stage__c = 'Draft';
        buk.Project_Name__c = proj.Id;
        buk.Tower_Name__c = tw.Id;
        buk.Booking_Date__c = system.today();
        buk.Prior_Primary_Applicant__c = accountObject.Id;
        //buk.Related_Suggested_Property__c = suggProp.Id;
        Insert buk;
        
        Co_Applicant__c testCoApp = new Co_Applicant__c();
        testCoApp.Booking__c = buk.id;
        testCoApp.Account__c = accountObject.id;
        testCoApp.Role__c = 'Primary';
        testCoApp.Sap_Code__c = '20000221';
        insert testCoApp;
        
        Payment__c paymnt = new Payment__c();
        paymnt.Booking__c = buk.Id;
        paymnt.Paid_By__c = 'Self';
        paymnt.Amount__c = 100000;
        paymnt.Payment_Status__c = 'Pending';
        paymnt.Payment_Date__c = system.today();
        paymnt.Payment_Category__c = 'Unit Cost';
        paymnt.Cheque__c = 'afaaafg';
        paymnt.Date__c = system.today();
        paymnt.Payment_Mode__c = 'NEFT';
        paymnt.Payment_Type__c = 'NEFT/ RTGS/ IMPS';
        paymnt.Receipt_No__c = '21314';
        Insert paymnt;
        
        Payment__c paymnt1 = new Payment__c();
        paymnt1.Booking__c = buk.Id;
        paymnt1.Paid_By__c = 'Self';
        paymnt1.Amount__c = 10000;
        paymnt1.Payment_Status__c = 'Pending';
        paymnt1.Payment_Date__c = system.today();
        paymnt1.Payment_Category__c = 'Unit Cost';
        paymnt1.Cheque__c = '123789';
        paymnt1.Payment_Mode__c = 'NEFT';
        paymnt1.Payment_Type__c = 'NEFT/ RTGS/ IMPS';
        paymnt1.Receipt_No__c = '2131488';
        Insert paymnt1;
        
        EOI_CA_Payment__c eoiPayment = new EOI_CA_Payment__c();
        eoiPayment.Amount__c = 10000;
        eoiPayment.Opportunity__c = opp.Id;
        eoiPayment.Payment_Status__c = 'Pending';
        eoiPayment.Payment_Category__c = 'Unit Cost';
        insert eoiPayment;
        
        EOI_CA_Payment__c eoiPayment1 = new EOI_CA_Payment__c();
        eoiPayment1.Amount__c = 10000;
        eoiPayment1.Opportunity__c = opp.Id;
        eoiPayment1.Payment_Status__c = 'Pending';
        eoiPayment1.Payment_Category__c = 'Unit Cost';
        insert eoiPayment1;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        String sbody = '{"ZFI012_SFDC_REC_POS_OUTBOUND":{"RECPOS_DATA":{"item":[{"ZSFDC_ID":"'+paymnt.id+'","ZPAYMENT_STATUS":"Reject","ZPAYMENT_DES":"INSUFFICIENT FUND","ZRECEIPT_DOC":"123456"},{"ZSFDC_ID":"'+eoiPayment1.id+'","ZPAYMENT_STATUS":"Reject","ZPAYMENT_DES":"INSUFFICIENT FUND","ZRECEIPT_DOC":"123456"},{"ZSFDC_ID":"'+eoiPayment.id+'","ZPAYMENT_STATUS":"Accept","ZPAYMENT_DES":"","ZRECEIPT_DOC":"78950"}]}}}';
        Blob blb = Blob.valueof(sbody);
        req.requestURI = '/services/apexrest/receiptconfirmation';
        req.httpMethod = 'GET';
        req.requestBody = blb;
        RestContext.request = req;
        RestContext.response= res;
        ReceiptConfirmation.getdemandRecord();
        Test.setMock(HttpCalloutMock.class, new callOutBookingCreationTestMock());
        Test.stopTest();

    }

}