@isTest
public class FirstWhatsppReminder_Test {
    
    @isTest static void emailReminderTest(){        
        Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

        Account accountObject = new Account();
        accountObject.FirstName = 'test';
        accountObject.LastName = 'Account';
        accountObject.BillingCountry = 'India';
        accountObject.PersonMobilePhone = '4555465653';
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
        projectObject.Project_Email__c = 'neeraj.saini@manras.com';
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
        
        Property_Add_On__c propertyAddOn = new Property_Add_On__c();
        propertyAddOn.Project_Add_On__c = projectAddbject.Id;
        propertyAddOn.Property__c = propertyObject.Id;
        propertyAddOn.Is_Included__c = true;
        insert propertyAddOn;
        
        Payment_Plan__c paymentPlan = new Payment_Plan__c();
        paymentPlan.Name = 'Test23';
        paymentPlan.Project__c = projectObject.Id;
        insert paymentPlan;
        
        Project_Progress__c testProjProgRcd=new Project_Progress__c();
        testProjProgRcd.Name='Test project progress';
        testProjProgRcd.Project__c=projectObject.Id;
        testProjProgRcd.Stage_Type__c='Booking';
        testProjProgRcd.Stage__c='Completion';
        testProjProgRcd.Progress_Status__c='In Progress';
        insert testProjProgRcd;
        
        Payment_Plan_Milestones__c paymentMilestoneObject = new Payment_Plan_Milestones__c();
        paymentMilestoneObject.Name = 'Test';
        paymentMilestoneObject.Payment_Plan__c = paymentPlan.Id;
        paymentMilestoneObject.Milestone_Activation__c = 'Booking Date';
        paymentMilestoneObject.Sequence_No__c = 30;
        paymentMilestoneObject.Milestone_age__c = 20;
        paymentMilestoneObject.Days_after_Booking__c = 2;
        paymentMilestoneObject.Project_Progress__c=testProjProgRcd.Id;
        insert paymentMilestoneObject;
        
        
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
        
        Price_Details__c priceDetailObject = new Price_Details__c();
        priceDetailObject.Name = 'Price Test1';
        priceDetailObject.Charge_Group__c= 'Agreement';
        priceDetailObject.GST_Type__c = 'Standard';
        priceDetailObject.Booking__c = booking.Id;
        priceDetailObject.Amount__c = 64000;
        insert priceDetailObject;
        
        Payment_Milestones__c PM = New Payment_Milestones__c();
        PM.Booking__c = booking.Id;
        PM.Name = 'Test Milestone';
        PM.Due_Date__c = date.today().addDays(-7);
        PM.GST_Amount1__c = 45000;
        PM.Sequence_No__c = 1;
        PM.Milestone_age__c = 10;
        PM.Milestone_Amount1__c = 7800000;
        PM.Milestone_Activation_Date__c = date.today().addDays(-4);
        PM.Milestone_Status__c = 'Active';
        Insert PM;
        
        Payment_Milestones__c PM1 = New Payment_Milestones__c();
        PM1.Booking__c = booking.Id;
        PM1.Name = 'Test Milestone';
        PM1.Due_Date__c = date.today().addDays(-14);
        PM1.GST_Amount1__c = 45000;
        PM1.Sequence_No__c = 1;
        PM1.Milestone_age__c = 10;
        PM1.Milestone_Amount1__c = 7800000;
        PM1.Milestone_Activation_Date__c = date.today().addDays(-4);
        PM1.Milestone_Status__c = 'Active';
        Insert PM1;
        
        Payment_Milestones__c PM2 = New Payment_Milestones__c();
        PM2.Booking__c = booking.Id;
        PM2.Name = 'Test Milestone';
        PM2.Due_Date__c = date.today().addDays(-21);
        PM2.GST_Amount1__c = 45000;
        PM2.Sequence_No__c = 1;
        PM2.Milestone_age__c = 10;
        PM2.Milestone_Amount1__c = 7800000;
        PM2.Milestone_Activation_Date__c = date.today().addDays(-4);
        PM2.Milestone_Status__c = 'Active';
        Insert PM2;
        
        Payment_Milestones__c PM3 = New Payment_Milestones__c();
        PM3.Booking__c = booking.Id;
        PM3.Name = 'Test Milestone';
        PM3.Due_Date__c = date.today().addDays(-28);
        PM3.GST_Amount1__c = 45000;
        PM3.Sequence_No__c = 1;
        PM3.Milestone_age__c = 10;
        PM3.Milestone_Amount1__c = 7800000;
        PM3.Milestone_Activation_Date__c = date.today().addDays(-4);
        PM3.Milestone_Status__c = 'Active';
        Insert PM3;
        
        Test.startTest();
        scheduledWhatsappReminderBatch scBatch = new scheduledWhatsappReminderBatch();
        FirstWhatsappReminderbatch ERB = New FirstWhatsappReminderbatch();
        Database.executeBatch(ERB);
        Test.setMock(HttpCalloutMock.class, new SendSMSMock()); 
        FirstsmsReminderBatch batch = new FirstsmsReminderBatch();
        Database.executeBatch(batch);     
        Test.stopTest();
    }
}