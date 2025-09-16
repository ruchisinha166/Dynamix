@isTest
public class CreateBookingLineItemsAndPricing_Test {
    @isTest
    public static void CreateBookingLineItemsAndPricingMethod(){
        Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
        Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
        Id PersonRecId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Id brokLadder = Schema.SObjectType.Brokerage_Ladder__c.getRecordTypeInfosByName().get('Launch').getRecordTypeId();
        
        Account accountObject = new Account();
        accountObject.FirstName = 'test';
        accountObject.LastName = 'Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '455546565';
        accountObject.RecordTypeId = PersonRecId;
        accountObject.PersonEmail = 'dynamix.project@gmail.com';
        accountObject.Aadhar_No__pc = '458785698549';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.PAN_No__pc = 'ABCTY1234C';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.PersonMobilePhone ='7789898989';
        insert accountObject;
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Status__c='Launch';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='3 BHK';
        insert projectObject;
        
        Account accountObject1 = new Account();
        accountObject1.Name = 'test1';
        accountObject1.RecordTypeId = PersonRecId1;
        accountObject1.RERA_Number__c = 'Accounfdt';
        
        insert accountObject1;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Project__c=projectObject.Id;
        oppoObject.Channel_Partner__c=accountObject1.Id;
        oppoObject.Project__c = projectObject.Id;
        oppoObject.Walk_in_Source__c = 'Hoarding';
        insert oppoObject;
        
        
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        insert pricingPlanObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Floor__c= '5';
        insert propertyObject;
        
        Property__c propertyObject1 = new Property__c();
        propertyObject1.Name = 'test property3';
        propertyObject1.Project__c = projectObject.Id;
        propertyObject1.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject1.Floor__c= '2';
        insert propertyObject1;
        
        Property__c propertyObject2 = new Property__c();
        propertyObject2.Name = 'test property1';
        propertyObject2.Project__c = projectObject.Id;
        propertyObject2.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject2.Floor__c= '3';
        insert propertyObject2;
        
        Property__c propertyObject3 = new Property__c();
        propertyObject3.Name = 'test property2';
        propertyObject3.Project__c = projectObject.Id;
        propertyObject3.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject3.Floor__c= '4';
        insert propertyObject3;
        
        Suggested_Property__c suggestedProperty = new Suggested_Property__c();
        suggestedProperty.Opportunity__c = oppoObject.Id;
        suggestedProperty.Unit__c = propertyObject.Id;
        suggestedProperty.Discount__c = 10;
        insert suggestedProperty;
        
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
        
        /*Project_Add_On_Charges__c projectAddbject4 = new Project_Add_On_Charges__c();
projectAddbject4.Charge_Type__c = 'Variable';
projectAddbject4.Charge_Group__c = 'Agreement';
projectAddbject4.Is_Optional__c = false;
projectAddbject4.RecordTypeId = parkingId;
projectAddbject4.Project__c = projectObject.Id;
projectAddbject4.Name = 'Stilt';
insert projectAddbject4;*/
        
        Add_On__c addOn = new Add_On__c();
        addOn.Opportunity__c = oppoObject.Id;
        addOn.Project_Add_On_Charges__c = projectAddbject1.Id;
        insert addOn;
        
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
        insert paymentMilestoneObject;
        
        Pricing_Plan_Components__c planComponentObject = new Pricing_Plan_Components__c();
        planComponentObject.Name = 'Basic Price';
        planComponentObject.GST_Treatment__c = 'Standard';
        planComponentObject.Project_Add_On_Charges__c = projectAddbject.Id;
        planComponentObject.Price_Lumpsum__c  = 200;
        planComponentObject.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject;
        
        /*  Pricing_Plan_Components__c planComponentObject2 = new Pricing_Plan_Components__c();
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
*/
        Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c();
        planComponentObject1.Name = 'Stilt';
        planComponentObject1.GST_Treatment__c = 'Standard';
        planComponentObject1.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject1.Price_Lumpsum__c  = 200;
        planComponentObject1.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject1;
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Stage__c = 'Registration';
        booking.cancellation_fees__c=10000;
        booking.Registration_Status__c = 'Not Started';
        booking.Index_II_Document__c = true;
        booking.Sales_Manager__c = oppoObject.OwnerId;
        insert booking;
        
        Booking_Line_Items__c bookingLineObjects = new Booking_Line_Items__c();
        bookingLineObjects.Booking__c = booking.Id;
        bookingLineObjects.Project_Add_On_Charges__c = projectAddbject.Id;
        bookingLineObjects.Property__c = propertyObject.Id;
        bookingLineObjects.Booking__c = booking.Id;       
        insert bookingLineObjects;
        
        Price_Details__c priceDetailObject = new Price_Details__c();
        priceDetailObject.Name = 'Price Test1';
        priceDetailObject.Charge_Group__c= 'Agreement';
        priceDetailObject.GST_Type__c = 'Standard';
        priceDetailObject.Booking__c = booking.Id;
        priceDetailObject.Amount__c = 6;
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= 'Agreement';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = booking.Id;
        priceDetailObject1.Amount__c = 6;
        insert priceDetailObject1;
        
        Brokerage_Ladder__c BrokerLadder = new Brokerage_Ladder__c();
        BrokerLadder.Project__c = projectObject.Id;
        BrokerLadder.RecordTypeId = brokLadder;
        insert BrokerLadder;
        
        booking.Stage__c = 'Booked';
        update booking;
        
        //CustomPaymentPlan.Requests cpprequest = new CustomPaymentPlan.Requests();
        //cpprequest.planId = paymentPlan.Id;
        
        //String playmentPlanDetail = CustomPaymentPlan.getPaymentPlanMilestones(new List<CustomPaymentPlan.Requests>{cpprequest})[0];
        suggestedProperty.Payment_Plan_Detail__c = '[{"attributes":{"type":"Payment_Plan_Milestones__c","url":"/services/data/v60.0/sobjects/Payment_Plan_Milestones__c/a0I71000000HqGjEAK"},"Id":"a0I71000000HqGjEAK","Days_after_Booking__c":0,"Milestone_age__c":10,"Milestone_Activation__c":"Booking Date","Name":"Booking Value","Payment_Plan__c":"a0J71000000EJIvEAO","Sequence_No__c":1,"Milestone_Code__c":"Z1111"}]';
        update suggestedProperty;
        
        List<CreateBookingLineItemsAndPricing.Requests> requestLst = new List<CreateBookingLineItemsAndPricing.Requests>();
        CreateBookingLineItemsAndPricing.Requests request = new CreateBookingLineItemsAndPricing.Requests();
        request.opportunityId = oppoObject.Id;
        request.propertyId = propertyObject.Id;
        request.suggestedPropertyId = suggestedProperty.Id;
        requestLst.add(request);
        Test.startTest();
        CreateBookingLineItemsAndPricing.execute(requestLst);
        Test.StopTest();
        
    }
}