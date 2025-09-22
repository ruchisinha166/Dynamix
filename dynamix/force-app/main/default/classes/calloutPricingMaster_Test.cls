@isTest
public class calloutPricingMaster_Test {
    @isTest public static void testRun(){
        Profile prf = [Select id , name from Profile where name = 'System Administrator'];
        Profile prf1 = [Select id , name from Profile where name = 'Sales Manager'];
        
        User testUser = new User(Username='ABC006@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf.Id);
        insert testUser;
        
        User testUser1 = new User(Username='ABC01206@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf1.Id);
        Insert testUser1;
        
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
        
        Data_Sync__c demandDataSync = new Data_Sync__c();
        demandDataSync.RecordId__c = pricngPlanCompnent.Id;
        demandDataSync.Status__c = 'Pending';
        demandDataSync.Event_Type__c = 'Pricing Plan Component';
        insert demandDataSync;
        
        List<calloutPricingMaster.request> reqList = new List<calloutPricingMaster.request>();
        calloutPricingMaster.request req = new calloutPricingMaster.request();
        req.prPlanComponentIds = pricngPlanCompnent.Id;
        reqList.add(req);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new callOutBookingCreationTestMock());
        calloutPricingMaster.getPricingPlanComponent(reqList);
        Test.stopTest();
    }
}