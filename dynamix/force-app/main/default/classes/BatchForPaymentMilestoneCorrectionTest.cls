@istest
public class BatchForPaymentMilestoneCorrectionTest {
    
    @isTest static void BatchForPaymentMilestoneCorrectionTestMethod(){
        
              
        Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
        Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
     
        
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
        insert accountObject;
        
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        insert oppoObject;
        
         Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c = 'shiv.ganesh@manras.com';
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
        
       /* Property__c propertyObject1 = new Property__c();
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
        insert propertyObject3;*/
        
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

      /*  Project_Add_On_Charges__c projectAddbject3 = new Project_Add_On_Charges__c();
        projectAddbject3.Charge_Type__c = 'Fixed';
        projectAddbject3.Charge_Group__c = 'Registration Charge';
        projectAddbject3.Is_Optional__c = false;
        projectAddbject3.RecordTypeId = ChargesId;
        projectAddbject3.Project__c = projectObject.Id;
        projectAddbject3.Name = 'Registration Charge';
        insert projectAddbject3;
 */
        Project_Add_On_Charges__c projectAddbject1 = new Project_Add_On_Charges__c();
        projectAddbject1.Charge_Type__c = 'Fixed';
        projectAddbject1.Charge_Group__c = 'Agreement';
        projectAddbject1.Is_Optional__c = false;
        projectAddbject1.RecordTypeId = parkingId;
        projectAddbject1.Project__c = projectObject.Id;
        projectAddbject1.Name = 'Stilt';
        insert projectAddbject1;
       
        
        Add_On__c addOn = new Add_On__c();
        addOn.Opportunity__c = oppoObject.Id;
        addOn.Project_Add_On_Charges__c = projectAddbject1.Id;
        insert addOn;
                
        Property_Add_On__c propertyAddOn = new Property_Add_On__c();
        propertyAddOn.Project_Add_On__c = projectAddbject2.Id;
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

        Pricing_Plan_Components__c planComponentObject2 = new Pricing_Plan_Components__c();
        planComponentObject2.Name = 'Stamp Charges';
        planComponentObject2.GST_Treatment__c = 'Standard';
        planComponentObject2.Project_Add_On_Charges__c = projectAddbject2.Id;
        planComponentObject2.Price_Lumpsum__c  = 200;
        planComponentObject2.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject2;

       /* Pricing_Plan_Components__c planComponentObject3 = new Pricing_Plan_Components__c();
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
        */
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
       // booking.GST__c=500000;
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
        priceDetailObject1.Amount__c = 10000000;
        priceDetailObject1.GST__c=5;
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
        PaymentObj.Paid_By__c = 'Self';
        insert PaymentObj;
        
        List<Id> PMIdsList = New List<Id>();
        Payment_Milestones__c PM = New Payment_Milestones__c();
        PM.Booking__c = booking.Id;
        PM.Name = 'Test Milestone';
        PM.Due_Date__c = date.today().addDays(10);
        PM.GST_Amount1__c = 45000;
        PM.Sequence_No__c = 1;
        PM.Milestone_age__c = 10;
        PM.Milestone_Amount1__c = 7800000;
        PM.Milestone_Activation_Date__c = date.today().addDays(-4);
        PM.Milestone_Status__c = 'Active';
        Insert PM;
        PMIdsList.add(PM.Id);
        
         blob body = Blob.valueOf('Generate Invoice PDF');
        
        List<Id> cvIdList  = New List<Id>();
        ContentVersion CV = New ContentVersion();
        CV.VersionData = body;
        CV.Title = 'Test';
        CV.Origin = 'H';
        CV.PathOnClient = 'Invoice.pdf';
        insert CV;
        cvIdList.add(CV.Id);
        
    
        
        ContentVersion ConDocId = [Select Id, Title,ContentDocumentId From ContentVersion Where Id =: CV.Id];
        
        
        
        ContentDocumentLink CDL = New ContentDocumentLink();
        CDL.LinkedEntityId = booking.Id;
        CDL.ContentDocumentId = ConDocId.ContentDocumentId;
        Insert CDL;
        
       
        
       Test.startTest();
            BatchForPaymentMilestoneCorrection batch = new BatchForPaymentMilestoneCorrection(); 
            database.executebatch(batch);
        Test.stopTest();
    }

}