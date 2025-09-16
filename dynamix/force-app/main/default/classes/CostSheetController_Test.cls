@isTest
public class CostSheetController_Test {
    @isTest public static void CostSheetControllerTestMethod()
    {
        Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
        Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
        
        Builder_Organisation__c bldOrg = new Builder_Organisation__c();
        bldOrg.Name = 'Dynamix Contractors and Builders Pvt. Ltd';
        bldOrg.Bank_Account_Number__c = '57500000289821';
        
        insert bldOrg;
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Builder_Organization__c = bldOrg.id;
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='3 BHK';
        insert projectObject;
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        insert pricingPlanObject;
        
        Project_Progress__c projectProgressObject = new Project_Progress__c();
        projectProgressObject.Name = 'test project';
        projectProgressObject.Project__c = projectObject.Id;
        projectProgressObject.Stage__c = 'Commencement';
        projectProgressObject.Stage_Type__c = 'Plinth';
        projectProgressObject.Progress_Status__c= 'Not Started';
        insert projectProgressObject;
        
        Tower__c towerObject = new Tower__c();
        towerObject.Name = 'test tower';
        towerObject.Project__c = projectObject.Id;
        insert towerObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'te';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Floor__c= '5';
        propertyObject.tower__c = towerObject.id;
        propertyObject.Deck_Proposed_Area__c = 54;
        propertyObject.Proposed_Utility_Area__c = 32;
        propertyObject.RERA_Carpet_Area__c = 12;
        insert propertyObject;
        
        Property__c propertyObject1 = new Property__c();
        propertyObject1.Name = 'test';
        propertyObject1.Project__c = projectObject.Id;
        propertyObject1.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject1.Floor__c= '2';
         propertyObject1.Deck_Proposed_Area__c = 44;
        propertyObject1.Proposed_Utility_Area__c = 22;
        propertyObject1.RERA_Carpet_Area__c = 121;
        insert propertyObject1;
        
        Property__c propertyObject2 = new Property__c();
        propertyObject2.Name = 'test property1';
        propertyObject2.Project__c = projectObject.Id;
        propertyObject2.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject2.Floor__c= '3';
         propertyObject2.Deck_Proposed_Area__c = 55;
        propertyObject2.Proposed_Utility_Area__c = 30;
        propertyObject2.RERA_Carpet_Area__c = 122;
        insert propertyObject2;
        
        Property__c propertyObject3 = new Property__c();
        propertyObject3.Name = 'test property2';
        propertyObject3.Project__c = projectObject.Id;
        propertyObject3.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject3.Floor__c= '4';
         propertyObject3.Deck_Proposed_Area__c = 59;
        propertyObject3.Proposed_Utility_Area__c = 35;
        propertyObject3.RERA_Carpet_Area__c = 124;
        insert propertyObject3;
        
        
        
        Project_Add_On_Charges__c projectAddbject= new Project_Add_On_Charges__c();
        projectAddbject.Charge_Type__c = 'Fixed';
        projectAddbject.Charge_Group__c = 'Floor Rise';
        projectAddbject.Is_Optional__c = false;
        projectAddbject.RecordTypeId = ChargesId;
        projectAddbject.Project__c = projectObject.Id;
        projectAddbject.Name = 'Basic Price';
        insert projectAddbject;
        
        Project_Add_On_Charges__c projectAddbject2 = new Project_Add_On_Charges__c();
        projectAddbject2.Charge_Type__c = 'Fixed';
        projectAddbject2.Charge_Group__c = 'Stamp Duty';
        projectAddbject2.Is_Optional__c = false;
        projectAddbject2.RecordTypeId = ChargesId;
        projectAddbject2.Project__c = projectObject.Id;
        projectAddbject2.Name = 'Stamp Duty';
        insert projectAddbject2;
        
        Project_Add_On_Charges__c projectAddbject3 = new Project_Add_On_Charges__c();
        projectAddbject3.Charge_Type__c = 'Fixed';
        projectAddbject3.Charge_Group__c = 'Registration Charge';
        projectAddbject3.Is_Optional__c = false;
        projectAddbject3.RecordTypeId = ChargesId;
        projectAddbject3.Project__c = projectObject.Id;
        projectAddbject3.Name = 'Registration Charge';
        insert projectAddbject3;
        
        Project_Add_On_Charges__c projectAddbject1 = new Project_Add_On_Charges__c();
        projectAddbject1.Charge_Type__c = 'Fixed';
        projectAddbject1.Charge_Group__c = 'Agreement';
        projectAddbject1.Is_Optional__c = false;
        projectAddbject1.RecordTypeId = parkingId;
        projectAddbject1.Project__c = projectObject.Id;
        projectAddbject1.Name = 'Stilt';
        insert projectAddbject1;
        
        
        
        
        Project_Add_On_Charges__c projectAddbject5 = new Project_Add_On_Charges__c();
        projectAddbject5.Charge_Type__c = 'Fixed';
        projectAddbject5.Charge_Group__c = 'Agreement';
        projectAddbject5.Is_Optional__c = false;
        projectAddbject5.RecordTypeId = parkingId;
        projectAddbject5.Project__c = projectObject.Id;
        projectAddbject5.Name = 'Large car parking';
        insert projectAddbject5;    
        
        Project_Add_On_Charges__c projectAddbject4 = new Project_Add_On_Charges__c();
        projectAddbject4.Charge_Type__c = 'Variable';
        projectAddbject4.Charge_Group__c = 'Others';
        projectAddbject4.Is_Optional__c = false;
        projectAddbject4.RecordTypeId = parkingId;
        projectAddbject4.Project__c = projectObject.Id;
        projectAddbject4.Name = 'Stilt';
        insert projectAddbject4;
        
        
        
        Property_Add_On__c propertyAddOn = new Property_Add_On__c();
        propertyAddOn.Project_Add_On__c = projectAddbject1.Id;
        propertyAddOn.Property__c = propertyObject.Id;
        propertyAddOn.Is_Included__c = true;
        insert propertyAddOn;
        
        Payment_Plan__c paymentPlan = new Payment_Plan__c();
        paymentPlan.Name = 'Test23';
        paymentPlan.Project__c = projectObject.Id;
        insert paymentPlan;
        
        Payment_Plan_Milestones__c paymentMilestoneObject = new Payment_Plan_Milestones__c();
        paymentMilestoneObject.Name = 'Test';
        paymentMilestoneObject.Payment_Plan__c = paymentPlan.Id;
        paymentMilestoneObject.Milestone_Activation__c = 'Booking Date';
        paymentMilestoneObject.Sequence_No__c = 30;
        paymentMilestoneObject.Milestone_age__c = 20;
        paymentMilestoneObject.Days_after_Booking__c = 2;
        paymentMilestoneObject.Project_Progress__c = projectProgressObject.Id;
        insert paymentMilestoneObject;
        
        Pricing_Plan_Components__c planComponentObject = new Pricing_Plan_Components__c();
        planComponentObject.Name = 'Basic Price';
        planComponentObject.GST_Treatment__c = 'Standard';
        planComponentObject.Project_Add_On_Charges__c = projectAddbject.Id;
        planComponentObject.Price_Lumpsum__c  = 200;
        planComponentObject.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject;
        
        Pricing_Plan_Components__c planComponentObject4 = new Pricing_Plan_Components__c();
        planComponentObject4.Name = 'stail car park';
        planComponentObject4.GST_Treatment__c = '18%';
        planComponentObject4.Project_Add_On_Charges__c = projectAddbject4.Id;
        planComponentObject4.Price_Lumpsum__c  = 200;
        planComponentObject4.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject4;
        
        Pricing_Plan_Components__c planComponentObject2 = new Pricing_Plan_Components__c();
        planComponentObject2.Name = 'Stamp Charges';
        planComponentObject2.GST_Treatment__c = 'Standard';
        planComponentObject2.Project_Add_On_Charges__c = projectAddbject2.Id;
        planComponentObject2.Price_Lumpsum__c  = 200;
        planComponentObject2.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject2;
        
        Pricing_Plan_Components__c planComponentObject3 = new Pricing_Plan_Components__c();
        planComponentObject3.Name = 'Registration Charge';
        planComponentObject3.GST_Treatment__c = 'Standard';
        planComponentObject3.Project_Add_On_Charges__c = projectAddbject3.Id;
        planComponentObject3.Price_Lumpsum__c  = 200;
        planComponentObject3.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject3;
        
        Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c();
        planComponentObject1.Name = 'Stilt';
        planComponentObject1.GST_Treatment__c = 'Standard';
        planComponentObject1.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject1.Price_Lumpsum__c  = 200;
        planComponentObject1.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject1;
        
        
        Account accountObject = new Account();
        accountObject.Name = 'test Account';
        insert accountObject;
        
        Contact cc = new Contact();
        cc.lastname = 'test';
        cc.AccountId = accountObject.Id;
        insert cc;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.Project__c = projectObject.id;
        oppoObject.CloseDate = System.Today()+3;
        insert oppoObject;
        
        Add_On__c addOn = new Add_On__c();
        addOn.Opportunity__c = oppoObject.Id;
        addOn.Project_Add_On_Charges__c = projectAddbject1.Id;
        insert addOn;
        
        
        Suggested_Property__c suggestedProperty = new Suggested_Property__c();
        suggestedProperty.Opportunity__c = oppoObject.Id;
        suggestedProperty.Unit__c = propertyObject.Id;
        suggestedProperty.Cost_Sheet_Provided__c = true;
        
        suggestedProperty.Discount__c = 10;
        
        insert suggestedProperty;
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        insert booking;
        
        Booking_Line_Items__c bookingLineObjects = new Booking_Line_Items__c();
        bookingLineObjects.Booking__c = booking.Id;
        bookingLineObjects.Project_Add_On_Charges__c = projectAddbject.Id;
        bookingLineObjects.Property__c = propertyObject.Id;
        bookingLineObjects.Booking__c = booking.Id;       
        insert bookingLineObjects;
        
        Price_Details__c priceDetailObject = new Price_Details__c();
        priceDetailObject.Name = 'Price Test1';
        priceDetailObject.Charge_Group__c= '20';
        priceDetailObject.GST_Type__c = 'Standard';
        priceDetailObject.Booking__c = booking.Id;
        priceDetailObject.Amount__c = 6;
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= '20';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = booking.Id;
        priceDetailObject1.Amount__c = 6;
        insert priceDetailObject1;
        
        CustomPaymentPlan.Requests request = new CustomPaymentPlan.Requests();
        request.planId = paymentPlan.Id;
        
        String playmentPlanDetail = CustomPaymentPlan.getPaymentPlanMilestones(new List<CustomPaymentPlan.Requests>{request})[0];
        suggestedProperty.Payment_Plan_Detail__c = playmentPlanDetail;
        update suggestedProperty;
        
        
        
        Test.startTest();   
        pagereference pageref = page.costsheet; 
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',suggestedProperty.id);
        pageRef.getParameters().put('customp',String.valueof(suggestedProperty.Cost_Sheet_Provided__c));
        
        ApexPages.StandardController sc = new ApexPages.standardController(suggestedProperty);
        CostSheetController controller = new CostSheetController();
        controller.CostSheetController1();
        Test.stopTest();
    }
    
}