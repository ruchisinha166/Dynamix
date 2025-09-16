@isTest
private class calloutBookingCreation_Test {
    @isTest
    static void exposeBookingToSAP_Test(){
        //UserRole r = [Select Id from UserRole where DeveloperName = 'CEO'];
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

        Pricing_Plan__c pricingPlan = new Pricing_Plan__c ();
        pricingPlan.Name = 'testing Pricing';
        pricingPlan.Valid_to__c = System.Today().addDays(10);
        pricingPlan.Valid_from__c = System.Today().addDays(-15); 
        pricingPlan.Project__c = proj.Id;
        Insert pricingPlan;
        
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
        
        
/*        Suggested_Property__c suggProp = new Suggested_Property__c();
        suggProp.Unit__c = prop.Id;
        suggProp.Opportunity__c = opp.id;
        suggProp.Status__c = 'In Progress';
        suggProp.Cost_Sheet_Provided__c = true;
        suggProp.Status_Change_Date__c = system.today().addDays(5);
        suggProp.Payment_Plan__c = payPlan.Id;
        Insert suggProp;*/
                    
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
        //buk.Related_Suggested_Property__c = suggProp.Id;
        Insert buk;
        
        List<Price_Details__c> priceDetalList = new List<Price_Details__c>();
        Price_Details__c priceDetal = new Price_Details__c();
        priceDetal.Name = 'Basic Price';
        priceDetal.Booking__c = buk.Id;
        priceDetal.Charge_Group__c = 'Agreement';
        priceDetal.Amount__c = 7500000;
        priceDetal.GST__c = 18;
        priceDetalList.add(priceDetal);
        
        Price_Details__c priceDetal1 = new Price_Details__c();
        priceDetal1.Name = 'Legal Charges';
        priceDetal1.Booking__c = buk.Id;
        priceDetal1.Charge_Group__c = 'Others';
        priceDetal1.Amount__c = 300000;
        priceDetal1.GST__c = 5;
        priceDetalList.add(priceDetal1);
        Insert priceDetalList;
        
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
        
        Data_Sync__c demandDataSync = new Data_Sync__c();
        demandDataSync.RecordId__c = buk.Id;
        demandDataSync.Status__c = 'Pending';
        demandDataSync.Event_Type__c = 'Booking';
        insert demandDataSync;
        
        List<calloutBookingCreation.request> reqList = new List<calloutBookingCreation.request>();
        calloutBookingCreation.request req = new calloutBookingCreation.request();
        req.bookingIds = buk.Id;
        reqList.add(req);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new callOutBookingCreationTestMock());
        calloutBookingCreation.getBooking(reqList);
        //calloutBookingCreation.exposeBookingToSAP(buk.Id);
        Test.stopTest();

    }
    
    
}