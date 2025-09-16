@isTest()
public class DummyPaymentLineScript_Test{
    
    @isTest static void executeMethodTest(){
        
        Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
        Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
        
        
        Account accountObject = new Account();
        accountObject.Name = 'test Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '455546565';
        insert accountObject;
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'harshita.sharma@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.OTP_Disable_Till__c = System.now().addDays(1);
        projectObject.Project_Header__c = 'abc.com';
        insert projectObject;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Walk_in_Source__c = 'Presales';
        oppoObject.Project__c = projectObject.id;
        insert oppoObject;
        
        
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        //   pricingPlanObject.
        insert pricingPlanObject;
        
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
        
        Payment_Plan__c paymentPlan = new Payment_Plan__c();
        paymentPlan.Name = 'Test23';
        paymentPlan.Project__c = projectObject.Id;
        insert paymentPlan;
        
        Payment_Plan_Milestones__c paymentMilestoneObject = new Payment_Plan_Milestones__c();
        paymentMilestoneObject.Name = 'Test';
        paymentMilestoneObject.Payment_Plan__c = paymentPlan.Id;
        paymentMilestoneObject.Milestone_Activation__c = 'Booking Date';
        paymentMilestoneObject.Sequence_No__c = 1;
        paymentMilestoneObject.Milestone_age__c = 20;
        paymentMilestoneObject.Days_after_Booking__c = 2;
        insert paymentMilestoneObject;
        
        
        Pricing_Plan_Components__c planComponentObject = new Pricing_Plan_Components__c();
        planComponentObject.Name = 'Basic Price';
        planComponentObject.GST_Treatment__c = 'Standard';
        // planComponentObject.Project_Add_On_Charges__c = projectAddbject.Id;
        planComponentObject.Price_Lumpsum__c  = 200;
        planComponentObject.Pricing_Plan__c = pricingPlanObject.id;
        insert planComponentObject;
        
        Pricing_Plan_Components__c planComponentObject2 = new Pricing_Plan_Components__c();
        planComponentObject2.Name = 'Stamp Charges';
        planComponentObject2.GST_Treatment__c = 'Standard';
        planComponentObject2.Project_Add_On_Charges__c = projectAddbject2.Id;
        planComponentObject2.Price_Lumpsum__c  = 200;
        planComponentObject2.Pricing_Plan__c = pricingPlanObject.id;
        insert planComponentObject2;
        
        Pricing_Plan_Components__c planComponentObject3 = new Pricing_Plan_Components__c();
        planComponentObject3.Name = 'Registration Charge';
        planComponentObject3.GST_Treatment__c = 'Standard';
        //  planComponentObject3.Project_Add_On_Charges__c = projectAddbject3.Id;
        planComponentObject3.Price_Lumpsum__c  = 200;
        planComponentObject3.Pricing_Plan__c = pricingPlanObject.id;
        insert planComponentObject3;
        
        Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c();
        planComponentObject1.Name = 'Stilt';
        planComponentObject1.GST_Treatment__c = 'Standard';
        planComponentObject1.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject1.Price_Lumpsum__c  = 200;
        planComponentObject1.Pricing_Plan__c = pricingPlanObject.id;
        insert planComponentObject1;
        
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
        
        
        
        Suggested_Property__c suggestedProperty = new Suggested_Property__c();
        suggestedProperty.Opportunity__c = oppoObject.Id;
        suggestedProperty.Unit__c = propertyObject.Id;
        suggestedProperty.Discount__c = 10;
        insert suggestedProperty;
        
        Add_On__c addOn = new Add_On__c();
        addOn.Opportunity__c = oppoObject.Id;
        addOn.Project_Add_On_Charges__c = projectAddbject1.Id;
        insert addOn;
        
        Property_Add_On__c propertyAddOn = new Property_Add_On__c();
        propertyAddOn.Project_Add_On__c = projectAddbject1.Id;
        propertyAddOn.Property__c = propertyObject.Id;
        propertyAddOn.Is_Included__c = true;
        insert propertyAddOn;
        
        
        
        Booking__c booking = new Booking__c();
        booking.Stage__c= 'Draft';
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        insert booking;
        
        
        Co_Applicant__c COAPP = New Co_Applicant__c();
        COAPP.Role__c = 'Co-Applicant';
        COAPP.Account__c = accountObject.Id;
        COAPP.Booking__c = booking.Id;
        Insert COAPP;
        
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
        priceDetailObject.Amount__c = 64000;
        
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= 'Agreement';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = booking.Id;
        priceDetailObject1.Amount__c = 60000;
        insert priceDetailObject1; 
        
        Bank__c Bank = New Bank__c();
        Bank.Name = 'PNB Bank';
        insert Bank;
        
        Payment__c  PaymentObj = New Payment__c();
        PaymentObj.Date__c = date.today();
        PaymentObj.BankName__c = Bank.Id;
        PaymentObj.Payment_Date__c = Date.today().addDays(20);
        PaymentObj.Amount__c = 655683;
        PaymentObj.Payment_Category__c = 'Unit Cost';
        PaymentObj.Payment_Type__c = 'Cheque';
        PaymentObj.Cheque_Status__c = 'Cleared';
        PaymentObj.Cheque_Transaction_Number__c = 'Cheque No';
        PaymentObj.Booking__c = booking.id;
        PaymentObj.Branch_Name__c = 'Mohali';
        insert PaymentObj;
        Pricing_Plan__c plan = new Pricing_Plan__c(Name='Plan Test', Project__c=ProjectObject.id);
        insert plan;
        Pricing_Plan_Components__c p1 = new Pricing_Plan_Components__c(Pricing_Plan__c=plan.id,Name='Basic Price',Price_Lumpsum__c=112400);
        insert p1;
        
        Payment__c  PaymentObj3 = New Payment__c();
        PaymentObj3.Date__c = date.today();
        PaymentObj3.BankName__c = Bank.Id;
        PaymentObj3.Payment_Date__c = Date.today().addDays(20);
        PaymentObj3.Amount__c = 65568345;
        PaymentObj3.Payment_Category__c = 'Unit Cost';
        PaymentObj3.Payment_Type__c = 'Cheque';
        PaymentObj3.Cheque_Status__c = 'Cleared';
        PaymentObj3.Cheque_Transaction_Number__c = 'Cheque No';
        PaymentObj3.Booking__c = booking.id;
        PaymentObj3.Branch_Name__c = 'Mohali';
        insert PaymentObj3;
        
        Payment__c  PaymentObj1 = New Payment__c();
        PaymentObj1.Date__c = date.today();
        PaymentObj1.BankName__c = Bank.Id;
        PaymentObj1.Payment_Date__c = Date.today().addDays(20);
        PaymentObj1.Amount__c = 6556;
        PaymentObj1.Payment_Category__c = 'GST';
        PaymentObj1.Payment_Type__c = 'Cheque';
        PaymentObj1.Cheque_Status__c = 'Cleared';
        PaymentObj1.Cheque_Transaction_Number__c = 'Cheque No';
        PaymentObj1.Booking__c = booking.id;
        PaymentObj1.Branch_Name__c = 'Mohali';
        insert PaymentObj1;
        
        Payment__c  PaymentObj2 = New Payment__c();
        PaymentObj2.Date__c = date.today();
        PaymentObj2.BankName__c = Bank.Id;
        PaymentObj2.Payment_Date__c = Date.today().addDays(20);
        PaymentObj2.Amount__c = 65564555;
        PaymentObj2.Payment_Category__c = 'GST';
        PaymentObj2.Payment_Type__c = 'Cheque';
        PaymentObj2.Cheque_Status__c = 'Cleared';
        PaymentObj2.Cheque_Transaction_Number__c = 'Cheque No';
        PaymentObj2.Booking__c = booking.id;
        PaymentObj2.Branch_Name__c = 'Mohali';
        insert PaymentObj2;
        
        Project_Progress__c	 pp = New Project_Progress__c();
        pp.Name = 'Test Milestone';
        pp.Project__c = projectObject.id;
        pp.Stage__c = 'Completion' ;
        pp.Stage_Type__c = 'Plinth';
        pp.Progress_Status__c = 'In Progress';
        //   pp.Architecture_Certificate__c = true;
        insert pp;
        
        Payment_Milestones__c PM = New Payment_Milestones__c();
        PM.Booking__c = booking.Id;
        PM.Name = 'Test Milestone';
        //  PM.Due_Date__c = date.today().addDays(10);
        PM.GST_Amount1__c = 45000;
        PM.Sequence_No__c = 1; 
        PM.Milestone_age__c = 10;
        PM.Milestone_Amount1__c = 7800000;
        PM.Project_Progress__c = pp.id;
        Insert PM;
        
        
        tower__c tower = new tower__c();
        tower.Project__c  = projectObject.id;
        tower.Unit_Names__c = '112';
        tower.Tower_Status__c = 'Sustenance';
        tower.Name = 'test tower';
        
        
        
        
        
        Property__c propertyObject3 = new Property__c();
        propertyObject3.Name = 'test property2';
        propertyObject3.Project__c = projectObject.Id;
        propertyObject3.Tower__c = tower.id;
        propertyObject3.Floor__c = '1';
        propertyObject3.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject3.Floor__c= '4';
        insert propertyObject3;
        
        
        
        Project_Progress__c prjProg = new Project_Progress__c();
        prjProg.Name = 'test proj';
        prjProg.Project__c = projectObject.id;
        prjProg.Stage_Type__c = 'Plinth';
        prjProg.Progress_Status__c ='Completed';
        prjProg.Architecture_Certificate__c = true;
        prjprog.Invoice_Date__c = System.today();
        prjProg.Tower__c =tower.id;
        prjProg.Floor__c = '1';
        prjProg.Architect_Certification_Received_Date__c =System.today();
        insert prjProg;
        
        
        Payment_Milestones__c PM1 = New Payment_Milestones__c();
        PM1.Booking__c = booking.Id;
        PM1.Name = 'Test Milestone';
        PM1.Due_Date__c = date.today().addDays(10);
        PM1.GST_Amount1__c = 45000;
        PM1.Sequence_No__c = 2;
        PM1.Milestone_age__c = 10;
        PM1.Milestone_Amount1__c = 7800000;
        PM1.Project_Progress__c = prjProg.id;
        Insert PM1;
        
        List<id> bkids = new list<id>();
        bkids.add(booking.id);
        
        DummyPaymentLineScript.insertPaymentLine(bkids);
        Test.StartTest();
        BatchForPaymentLineCorrection  batch1 = new BatchForPaymentLineCorrection();
        database.executebatch(batch1,1);
        Test.StopTest();
        
        
    }
}