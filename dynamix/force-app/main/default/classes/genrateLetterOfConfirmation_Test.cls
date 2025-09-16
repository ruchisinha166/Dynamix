@isTest()
public class genrateLetterOfConfirmation_Test {

       @isTest static void executeTestMethod(){
        
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
        
        blob body = Blob.valueOf('LetterOfConfirmationAllotementLetter');
        
        ContentVersion CV = New ContentVersion();
        CV.VersionData = body;
        CV.Title = 'Test';
        CV.Origin = 'H';
        CV.PathOnClient = 'Agreement of Sale.pdf';
        insert CV;
    
        
        ContentVersion ConDocId = [Select Id, Title,ContentDocumentId From ContentVersion Where Id =: CV.Id];
        
        
        
        ContentDocumentLink CDL = New ContentDocumentLink();
        CDL.LinkedEntityId = booking.Id;
        CDL.ContentDocumentId = ConDocId.ContentDocumentId;
        Insert CDL;
        
       
        
        List<genrateLetterOfConfirmation.Request> BookingReqList = New List<genrateLetterOfConfirmation.Request>();
        
        genrateLetterOfConfirmation.Request BookReq = New genrateLetterOfConfirmation.Request();
        BookReq.bookingId = booking.Id;
       
        BookingReqList.add(BookReq);
        
        genrateLetterOfConfirmation.execute(BookingReqList);
        
        
    }
    
     @isTest static void executeTestSecondMethod(){
        
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
        
        blob body = Blob.valueOf('LetterOfConfirmationAllotementLetter');
        
        ContentVersion CV = New ContentVersion();
        CV.VersionData = body;
        CV.Title = 'Test';
        CV.Origin = 'H';
        CV.PathOnClient = 'TestPic.pdf';
        insert CV;
        
        
        
        ContentVersion ConDocId = [Select Id, Title,ContentDocumentId From ContentVersion Where Id =: CV.Id];
        
        
        
        ContentDocumentLink CDL = New ContentDocumentLink();
        CDL.LinkedEntityId = booking.Id;
        CDL.ContentDocumentId = ConDocId.ContentDocumentId;
        Insert CDL;
        
     
        
        
        List<genrateLetterOfConfirmation.Request> BookingReqList = New List<genrateLetterOfConfirmation.Request>();
        
        genrateLetterOfConfirmation.Request BookReq = New genrateLetterOfConfirmation.Request();
        BookReq.bookingId = booking.Id;
       
        BookingReqList.add(BookReq);
        
        genrateLetterOfConfirmation.execute(BookingReqList);
        
        
    }
}