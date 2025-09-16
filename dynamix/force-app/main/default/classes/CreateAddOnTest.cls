@isTest
private class CreateAddOnTest {

    @isTest
    static String testOpportunityAddOnsCarParking() {
        
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Id ProjAddOnRecTypeId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        Account accountObject = new Account();
        accountObject.FirstName = 'test';
        accountObject.LastName = 'Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '455546565';
        accountObject.RecordTypeId = PersonRecId;
        accountObject.PersonEmail = 'dynamix.project@gmail.com';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.PersonMobilePhone = '6768789684';
        insert accountObject;
       
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'nishi@manras.com';
        projectObject.GST_Applicable__c = true;
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='3 BHK';
        insert projectObject;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Project__c = projectObject.Id;
        oppoObject.Walk_in_Source__c = 'Hoarding';
        insert oppoObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Floor__c= '5';
        insert propertyObject;
        
        
        
        Project_Add_On_Charges__c projAddOn = new Project_Add_On_Charges__c();
        projAddOn.Project__c= projectObject.Id;
        projAddOn.RecordTypeId = ProjAddOnRecTypeId;
        projAddOn.Name = 'Car Parking Space';
        projAddOn.Charge_Type__c = 'Fixed';
        projAddOn.Charge_Group__c = 'Agreement;Others';
        insert projAddOn;

        Suggested_Property__c suggProp = new Suggested_Property__c();
        suggProp.Opportunity__c = oppoObject.Id;
        suggProp.Unit__c = propertyObject.Id;
        insert suggProp;
        
        Booking__c bookingObject = new Booking__c();
        bookingObject.Stage__c = 'Draft';
        bookingObject.cancellation_fees__c=10000;
        bookingObject.Registration_Status__c = 'Not Started';
        bookingObject.Index_II_Document__c = true;
        bookingObject.Sales_Manager__c = oppoObject.OwnerId;
        bookingObject.Related_Opportunity__c = oppoObject.id;
        bookingObject.Project_Name__c = projectObject.Id;
        bookingObject.Registration_Status__c = 'Completed';
        bookingObject.Date_of_Agreement_Handover__c = system.today();
        insert bookingObject;

        Property__c carPark = new Property__c();
        carPark.Property_Status__c = 'Available';
        carPark.Name = 'Test Car Park';
        carPark.Project__c = projectObject.Id;
        carPark.Flat_Type__c = 'CAR PARKING';
        insert carPark;
        
        Property_Add_On__c propAddOn = new Property_Add_On__c();
        propAddOn.Car_Parking__c = carPark.Id;
        propAddOn.Property__c = propertyObject.Id;
        propAddOn.Project_Add_On__c = projAddOn.Id;
        insert propAddOn;
        
        Pricing_Plan__c pPlan = new Pricing_Plan__c();
        pPlan.Name = 'Car Parking Space';
        pPlan.Project__c = projectObject.Id;
        insert pPlan;
        
        
        Pricing_Plan_Components__c pPlanComp = new Pricing_Plan_Components__c();
        pPlanComp.Name = 'Car Parking Space';
        pPlanComp.Project_Add_On_Charges__c = projAddOn.Id;
        pPlanComp.Price_Lumpsum__c = 60000;
        pPlanComp.Pricing_Plan__c = pPlan.Id;
        insert pPlanComp;
        
        Test.startTest();
        String result = CreateAddOn.createOpportunityAddOns(oppoObject.Id, suggProp.Id, carPark.Id);
        String result1 = CreateAddOn.createAddOnBookingCarParking(bookingObject.Id, carPark.Id);
        System.assertEquals('Record Created Successfully', result);
        System.assertEquals('Record Created Successfully', result1);
        Add_On__c[] addOns = [SELECT Id, Name FROM Add_On__c WHERE Opportunity__c = :oppoObject.Id];
		Test.stopTest();
        return result;
    }
    @isTest
    static String testOpportunityAddOnsBikeParking() {
        
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Id ProjAddOnRecTypeId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        Account accountObject = new Account();
        accountObject.FirstName = 'test';
        accountObject.LastName = 'Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '455546565';
        accountObject.RecordTypeId = PersonRecId;
        accountObject.PersonEmail = 'dynamix.project@gmail.com';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.PersonMobilePhone = '6768789684';
        insert accountObject;
       
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'nishi@manras.com';
        projectObject.GST_Applicable__c = true;
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='3 BHK';
        insert projectObject;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Project__c = projectObject.Id;
        oppoObject.Walk_in_Source__c = 'Hoarding';
        insert oppoObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Floor__c= '5';
        insert propertyObject;
        
        
        
        Project_Add_On_Charges__c projAddOn = new Project_Add_On_Charges__c();
        projAddOn.Project__c= projectObject.Id;
        projAddOn.RecordTypeId = ProjAddOnRecTypeId;
        projAddOn.Name = '2 Wheeler Parking';
        projAddOn.Charge_Type__c = 'Fixed';
        projAddOn.Charge_Group__c = 'Agreement;Others';
        insert projAddOn;

        Suggested_Property__c suggProp = new Suggested_Property__c();
        suggProp.Opportunity__c = oppoObject.Id;
        suggProp.Unit__c = propertyObject.Id;
        insert suggProp;
        
        Booking__c bookingObject = new Booking__c();
        bookingObject.Stage__c = 'Draft';
        bookingObject.cancellation_fees__c=10000;
        bookingObject.Registration_Status__c = 'Not Started';
        bookingObject.Index_II_Document__c = true;
        bookingObject.Sales_Manager__c = oppoObject.OwnerId;
        bookingObject.Related_Opportunity__c = oppoObject.id;
        bookingObject.Project_Name__c = projectObject.Id;
        bookingObject.Registration_Status__c = 'Completed';
        bookingObject.Date_of_Agreement_Handover__c = system.today();
        insert bookingObject;

        Property__c carPark = new Property__c();
        carPark.Property_Status__c = 'Available';
        carPark.Name = 'Test Car Park';
        carPark.Project__c = projectObject.Id;
        carPark.Flat_Type__c = 'BIKE PARKING';
        insert carPark;
        
        Property_Add_On__c propAddOn = new Property_Add_On__c();
        propAddOn.Car_Parking__c = carPark.Id;
        propAddOn.Property__c = propertyObject.Id;
        propAddOn.Project_Add_On__c = projAddOn.Id;
        insert propAddOn;
        
        Pricing_Plan__c pPlan = new Pricing_Plan__c();
        pPlan.Name = 'Car Parking Space';
        pPlan.Project__c = projectObject.Id;
        insert pPlan;
        
        
        Pricing_Plan_Components__c pPlanComp = new Pricing_Plan_Components__c();
        pPlanComp.Name = 'Car Parking Space';
        pPlanComp.Project_Add_On_Charges__c = projAddOn.Id;
        pPlanComp.Price_Lumpsum__c = 60000;
        pPlanComp.Pricing_Plan__c = pPlan.Id;
        insert pPlanComp;
        
        Test.startTest();
        String result = CreateAddOn.createOpportunityAddOns(oppoObject.Id, suggProp.Id, carPark.Id);
        String result1 = CreateAddOn.createAddOnBookingCarParking(bookingObject.Id, carPark.Id);
        System.assertEquals('Record Created Successfully', result);
        System.assertEquals('Record Created Successfully', result1);
        Add_On__c[] addOns = [SELECT Id, Name FROM Add_On__c WHERE Opportunity__c = :oppoObject.Id];
		Test.stopTest();
        return result;
    }
}