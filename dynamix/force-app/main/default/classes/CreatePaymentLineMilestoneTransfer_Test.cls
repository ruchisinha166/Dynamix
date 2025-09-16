@isTest
public class CreatePaymentLineMilestoneTransfer_Test {
    
    @isTest
    public static void testRun()
    {
        Account accountObject =  new Account();
        accountObject.Name = 'Test Account';
        insert accountObject;
        
        Builder_Organisation__c builderOrganization = New Builder_Organisation__c();
        builderOrganization.Name = 'Test';
        builderOrganization.Builder_Organisation_Initials__c = 'Test';
        insert builderOrganization;
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Builder_Organization__c = builderOrganization.id;
        projectObject.Project_Email__c = 'shiv.ganesh@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Initials__c ='abc';
        projectObject.Last_Receipt_Number__c = 34;
        projectObject.Last_Invoice_Number__c = 55;
        insert projectObject;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Walk_in_Source__c ='Website';
        oppoObject.Project__c = projectObject.id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        insert oppoObject;
        
        Project_Progress__c projectProgressObject = new Project_Progress__c();
        projectProgressObject.Name = 'test project';
        projectProgressObject.Project__c = projectObject.Id;
        projectProgressObject.Stage__c = 'Commencement';
        projectProgressObject.Stage_Type__c = 'Plinth';
        projectProgressObject.Progress_Status__c= 'Not Started';
        insert projectProgressObject;
        
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
        
        Suggested_Property__c suggestedProperty = new Suggested_Property__c();
        suggestedProperty.Opportunity__c = oppoObject.Id;
        suggestedProperty.Unit__c = propertyObject.Id;
        suggestedProperty.Discount__c = 10;
        insert suggestedProperty;
        
        Booking__c booking = new Booking__c();
        booking.Project_Name__c = projectObject.id;
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Cheque_Bounced_Charges__c = 0;
        insert booking;
        
        Co_Applicant__c COAPP = New Co_Applicant__c();
        COAPP.Role__c = 'Co-Applicant';
        COAPP.Account__c = accountObject.Id;
        COAPP.Booking__c = booking.Id;
        //Insert COAPP;
        
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
        
        ReceiptNumber__c ct = new ReceiptNumber__c();
        ct.Name = 'test';
        ct.LastReceiptNumber__c = 12345;
        insert ct;
        
        Payment__c paymentObject = new Payment__c();
        paymentObject.Amount__c = 3000;
        paymentObject.Booking__c = booking.Id;
        paymentObject.Payment_Category__c = 'Unit Cost';
        insert paymentObject;
        
        Payment__c paymentObject1 = new Payment__c();
        paymentObject1.Amount__c = 3000;
        paymentObject1.Booking__c = booking.Id;
        paymentObject1.Payment_Category__c = 'GST';
        insert paymentObject1;
        
        Payment_Plan__c paymentPlan = new Payment_Plan__c();
        paymentPlan.Name = 'Test23';
        paymentPlan.Project__c = projectObject.Id;
        insert paymentPlan;
        
        Payment_Plan_Milestones__c paymentMilestoneObject = new Payment_Plan_Milestones__c();
        paymentMilestoneObject.Name = System.Label.OtherChargesMilestone;
        paymentMilestoneObject.Payment_Plan__c = paymentPlan.Id;
        paymentMilestoneObject.Milestone_Activation__c = 'Booking Date';
        paymentMilestoneObject.Sequence_No__c = 2;
        paymentMilestoneObject.Milestone_age__c = 20;
        paymentMilestoneObject.Days_after_Booking__c = 2;
        paymentMilestoneObject.Project_Progress__c = projectProgressObject.Id;
        insert paymentMilestoneObject;
        
        Payment_Milestones__c PM = New Payment_Milestones__c();
        PM.Booking__c = booking.Id;
        PM.Name = System.Label.OtherChargesMilestone;
        PM.Due_Date__c = date.today().addDays(10);
        PM.Milestone_Status__c = 'Active';
        PM.GST_Amount1__c = 45000;
        PM.Sequence_No__c = 1;
        PM.Milestone_age__c = 10;
        PM.Milestone_Amount1__c = 78000000;
        PM.Interest_on_milestone_amount__c = 20000000;
        PM.Interest_on_GST__c = 20000;
        PM.Remaining_GST1__c = 200000;
        PM.Remaining_Milestone_Amount__c = 78000000;
        PM.Remaining_Unit_Cost__c = 75000000;
        Insert PM;
        /*
        Payment_Milestones__c paymentMiles = new Payment_Milestones__c();
        paymentMiles.Booking__c  = booking.Id;
        paymentMiles.Name= 'Payment';
        paymentMiles.Sequence_No__c = 2;
        paymentMiles.Milestone_age__c = 20;
        insert paymentMiles;
        */
        Test.startTest();      
        List<CreatePaymentLineMilestoneTransfer.Request> BookingReqList = New List<CreatePaymentLineMilestoneTransfer.Request>();
        
        CreatePaymentLineMilestoneTransfer.Request BookReq = New CreatePaymentLineMilestoneTransfer.Request();
        BookReq.bookingId = booking.Id;
        
        BookingReqList.add(BookReq);
        
        CreatePaymentLineMilestoneTransfer.execute(BookingReqList);
        Test.stopTest();
    }
    
     @isTest
    public static void testRun2()
    {
        Account accountObject =  new Account();
        accountObject.Name = 'Test Account';
        insert accountObject;
        Builder_Organisation__c builderOrganization = New Builder_Organisation__c();
        builderOrganization.Name = 'Test';
        builderOrganization.Builder_Organisation_Initials__c = 'Test';
        insert builderOrganization;
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Builder_Organization__c = builderOrganization.id;
        projectObject.Project_Email__c = 'shiv.ganesh@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Initials__c ='abc';
        projectObject.Last_Receipt_Number__c = 34;
        projectObject.Last_Invoice_Number__c = 55;
        insert projectObject;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Walk_in_Source__c ='Website';
        oppoObject.Project__c = projectObject.id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        insert oppoObject;
        
        ReceiptNumber__c ct = new ReceiptNumber__c();
        ct.Name = 'test';
        ct.LastReceiptNumber__c = 12343;
        insert ct;
        
        Project_Progress__c projectProgressObject = new Project_Progress__c();
        projectProgressObject.Name = 'test project';
        projectProgressObject.Project__c = projectObject.Id;
        projectProgressObject.Stage__c = 'Commencement';
        projectProgressObject.Stage_Type__c = 'Plinth';
        projectProgressObject.Progress_Status__c= 'Not Started';
        insert projectProgressObject;
        
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
        
        Suggested_Property__c suggestedProperty = new Suggested_Property__c();
        suggestedProperty.Opportunity__c = oppoObject.Id;
        suggestedProperty.Unit__c = propertyObject.Id;
        suggestedProperty.Discount__c = 10;
        insert suggestedProperty;
        
        Booking__c booking = new Booking__c();
        booking.Project_Name__c = projectObject.id;
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Cheque_Bounced_Charges__c = 0;
        insert booking;
        
        Co_Applicant__c COAPP = New Co_Applicant__c();
        COAPP.Role__c = 'Co-Applicant';
        COAPP.Account__c = accountObject.Id;
        COAPP.Booking__c = booking.Id;
        //Insert COAPP;
        
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
        
        Payment__c paymentObject = new Payment__c();
        paymentObject.Amount__c = 3000000;
        paymentObject.Booking__c = booking.Id;
        paymentObject.Payment_Category__c = 'GST';
        insert paymentObject;
        
        Payment__c paymentObject1 = new Payment__c();
        paymentObject1.Amount__c = 3000000;
        paymentObject1.Booking__c = booking.Id;
        paymentObject1.Payment_Category__c = 'Unit Cost';
        insert paymentObject1;
        
        Payment_Plan__c paymentPlan = new Payment_Plan__c();
        paymentPlan.Name = 'Test23';
        paymentPlan.Project__c = projectObject.Id;
        insert paymentPlan;
        
        Payment_Plan_Milestones__c paymentMilestoneObject = new Payment_Plan_Milestones__c();
        paymentMilestoneObject.Name = System.Label.OtherChargesMilestone;
        paymentMilestoneObject.Payment_Plan__c = paymentPlan.Id;
        paymentMilestoneObject.Milestone_Activation__c = 'Booking Date';
        paymentMilestoneObject.Sequence_No__c = 2;
        paymentMilestoneObject.Milestone_age__c = 20;
        paymentMilestoneObject.Days_after_Booking__c = 2;
        paymentMilestoneObject.Project_Progress__c = projectProgressObject.Id;
        insert paymentMilestoneObject;
        
        Payment_Milestones__c PM = New Payment_Milestones__c();
        PM.Booking__c = booking.Id;
        PM.Name = System.Label.OtherChargesMilestone;
        PM.Due_Date__c = date.today().addDays(10);
        PM.Milestone_Status__c = 'Active';
        PM.GST_Amount1__c = 100;
        PM.Sequence_No__c = 1;
        PM.Milestone_age__c = 10;
        PM.Milestone_Amount1__c = 0;
        PM.Interest_on_milestone_amount__c = 0;
        PM.Interest_on_GST__c = 100;
        PM.Remaining_GST1__c = 100;
        PM.Remaining_Milestone_Amount__c = 0;
		PM.Remaining_Unit_Cost__c = 75000;
        Insert PM;
        /*
        Payment_Milestones__c paymentMiles = new Payment_Milestones__c();
        paymentMiles.Booking__c  = booking.Id;
        paymentMiles.Name= 'Payment';
        paymentMiles.Sequence_No__c = 2;
        paymentMiles.Milestone_age__c = 20;
        insert paymentMiles;
        */
        
        Test.startTest();      
        List<CreatePaymentLineMilestoneTransfer.Request> BookingReqList = New List<CreatePaymentLineMilestoneTransfer.Request>();
        
        CreatePaymentLineMilestoneTransfer.Request BookReq = New CreatePaymentLineMilestoneTransfer.Request();
        BookReq.bookingId = booking.Id;
        
        BookingReqList.add(BookReq);
        
        CreatePaymentLineMilestoneTransfer.execute(BookingReqList);
        Test.stopTest();   
    }
}