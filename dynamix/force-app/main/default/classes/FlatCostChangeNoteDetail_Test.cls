@isTest()
public class FlatCostChangeNoteDetail_Test {

    @isTest static void flatCostChangeNoteDetailTest(){
        
        Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
        
        String testJSON = '[{"Name":"Test"}]';
       
        
        Account accountObject = new Account();
        accountObject.Name = 'test Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '455546565';
        insert accountObject;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        insert oppoObject;
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        insert projectObject;
        
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
        
        Suggested_Property__c suggestedProperty = new Suggested_Property__c();
        suggestedProperty.Opportunity__c = oppoObject.Id;
        suggestedProperty.Unit__c = propertyObject.Id;
        suggestedProperty.Discount__c = 10;
        suggestedProperty.Payment_Plan__c = paymentPlan.Id;
        suggestedProperty.Payment_Plan_Detail__c = testJSON;
        insert suggestedProperty;
        
        System.debug('PMT Plan Detail->'+suggestedProperty.Payment_Plan_Detail__c);
        
        Project_Add_On_Charges__c projectAddbject= new Project_Add_On_Charges__c();
        projectAddbject.Charge_Type__c = 'Fixed';
        projectAddbject.Charge_Group__c = 'Floor Rise';
        projectAddbject.Is_Optional__c = false;
        projectAddbject.RecordTypeId = ChargesId;
        projectAddbject.Project__c = projectObject.Id;
        projectAddbject.Name = 'Basic Price';
        insert projectAddbject;
        
        Pricing_Plan_Components__c planComponentObject = new Pricing_Plan_Components__c();
        planComponentObject.Name = 'Basic Price';
        planComponentObject.GST_Treatment__c = 'Standard';
        planComponentObject.Project_Add_On_Charges__c = projectAddbject.Id;
        planComponentObject.Price_Lumpsum__c  = 200;
        planComponentObject.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject;
        
        Booking__c booking = new Booking__c();
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
        
        Payment_Milestones__c PM = New Payment_Milestones__c();
        PM.Booking__c = booking.Id;
        PM.Name = 'Test Milestone';
        PM.Due_Date__c = date.today().addDays(10);
        PM.GST_Amount1__c = 45000;
        PM.Sequence_No__c = 1;
        PM.Milestone_age__c = 10;
        PM.Milestone_Amount1__c = 7800000;
        Insert PM;
        
       decimal newAgreementValue = 5800000;
        
        Test.startTest();   
        pagereference pageref = page.FlatCostChangeNote; 
        
        Test.setCurrentPage(pageRef);
   
   		pageRef.getParameters().put('newAgreementValue',string.valueOf(newAgreementValue));
        pageRef.getParameters().put('id',String.valueOf(booking.id));
        ApexPages.StandardController sc = new ApexPages.StandardController(booking);
        FlatCostChangeNoteDetail FlatCost = New FlatCostChangeNoteDetail(sc);
        Test.stopTest();
        
    }
}