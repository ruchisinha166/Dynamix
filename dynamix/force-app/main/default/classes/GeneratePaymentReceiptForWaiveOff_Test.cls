@isTest
public class GeneratePaymentReceiptForWaiveOff_Test {

    @isTest static void generatePRWTest(){
        
        String testLab = Label.Booking_Form_Link;

                                  
         Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
         Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String testJSON = '[{"Name":"Test"}]';
       
       
        
        Account accountObject = new Account();
        accountObject.FirstName = 'test';
        accountObject.LastName = 'Account';
        accountObject.BillingCountry = 'India';
        accountObject.PersonMobilePhone = '4555465655';
        accountObject.RecordTypeId = PersonRecId;
        accountObject.PersonEmail = 'dynamix.project@gmail.com';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        insert accountObject;
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c = '	avanya@dynamixgroup.co.in';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        insert projectObject; 
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.Walk_in_Source__c = 'Referred by Existing Customer';
        oppoObject.Project__c = projectObject.Id;
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Apartment_Number__c = 'L02';
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
        
        Co_Applicant__c CO = New Co_Applicant__c();
        CO.Booking__c  = booking.Id;
        CO.Account__c = accountObject.Id;
        CO.Role__c = 'Primary';
        Insert CO;
       
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
        
        OrgWideEmailAddress orgEmail = new OrgWideEmailAddress();
        orgEmail.Address = projectObject.Project_Email__c;

        Bank__c Bank = New Bank__c();
        Bank.Name = 'PNB Bank';
        insert Bank;
        
        ReceiptNumber__c rct = new ReceiptNumber__c();
        rct.Name = 'Test Receipt';
        rct.LastReceiptNumber__c = 12345;
        insert rct;
        
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
        PaymentObj.Paid_By__c = 'Self';
        insert PaymentObj;
        
        Test.startTest();
        GeneratePaymentReceiptForWaiveOff.GeneratePaymentReceipt(booking.Id, PaymentObj.Id);
        Test.stopTest();
    }
}