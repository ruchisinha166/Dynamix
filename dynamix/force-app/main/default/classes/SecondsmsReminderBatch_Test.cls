@isTest 
public class SecondsmsReminderBatch_Test{
    @testSetup public static void setup() {
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        system.runAs(testUserRcd1){
            
            Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
            Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
            Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.PersonMobilePhone = '1234567890';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.PersonMobilePhone = '5657824685';
            insert accountObject;
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'nishi@manras.com';
            projectObject.Site_Head__c = testUserRcd1.Id;
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
            paymentMilestoneObject.Sequence_No__c = 1;
            paymentMilestoneObject.Milestone_age__c = 100;
            paymentMilestoneObject.Project_Progress__c=testProjProgRcd.Id;
            paymentMilestoneObject.Days_after_Booking__c = 2;
            
            insert paymentMilestoneObject;
            
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
            booking.OwnerId = testUserRcd1.Id;
            insert booking;
            List<Payment_Milestones__c> PMList = New List<Payment_Milestones__c>();
            Payment_Milestones__c PM = New Payment_Milestones__c();
            PM.Booking__c = booking.Id;
            PM.Name = 'Test Milestone';
            PM.Due_Date__c = date.today().addDays(-14);
            PM.GST_Amount1__c = 45000;
            PM.Sequence_No__c = 1;
            PM.Milestone_age__c = 10;
            PM.Milestone_age__c = 10;
            PM.Milestone_Amount1__c = 7800000;
            //  PM.Remaining_Amount__c = 10000;
            PM.Milestone_Status__c = 'Active';
            PM.Interest_Wave_Off_Amount__c = 200;
            Insert PM;
        }
    }
    @isTest  
    public static void testMethod1(){       
        Payment_Milestones__c paymentMilestone = [SELECT Id,Name,booking__c,Milestone_Status__c,First_Payment_Email_Reminder_Date__c,
                                                  Due_Date__c,Remaining_GST__c,Remaining_Amount__c  FROM Payment_Milestones__c ];
          paymentMilestone.Due_Date__c = date.today().addDays(-14);
        update paymentMilestone;
        Test.setMock(HttpCalloutMock.class, new SendSMSMock()); 
        Test.startTest();
        SecondsmsReminderBatch batch = new SecondsmsReminderBatch(); 
        database.executebatch(batch);
        Test.stopTest();
        
    }
    @isTest  
    public static void FirstsmsReminderBatch(){       
        
        List<Payment_Milestones__c> PMList = New List<Payment_Milestones__c>();
        Payment_Milestones__c paymentMilestone = [SELECT Id,Name,booking__c,Milestone_Status__c,First_Payment_Email_Reminder_Date__c,
                                                  Due_Date__c,Remaining_GST__c,Remaining_Amount__c  FROM Payment_Milestones__c ];
        
        paymentMilestone.Due_Date__c = date.today().addDays(-7);
        update paymentMilestone;
        
        Test.setMock(HttpCalloutMock.class, new SendSMSMock()); 
        Test.startTest();
        FirstsmsReminderBatch batch = new FirstsmsReminderBatch(); 
        database.executebatch(batch);
        Test.stopTest();
    }
     @isTest  
    public static void ThirdsmsReminderBatch(){       
        
        List<Payment_Milestones__c> PMList = New List<Payment_Milestones__c>();
        Payment_Milestones__c paymentMilestone = [SELECT Id,Name,booking__c,Milestone_Status__c,First_Payment_Email_Reminder_Date__c,
                                                  Due_Date__c,Remaining_GST__c,Remaining_Amount__c  FROM Payment_Milestones__c ];
        
        paymentMilestone.Due_Date__c = date.today().addDays(-21);
        update paymentMilestone;
        
        Test.setMock(HttpCalloutMock.class, new SendSMSMock()); 
        Test.startTest();
        ThirdsmsReminderBatch batch = new ThirdsmsReminderBatch(); 
        database.executebatch(batch);
        Test.stopTest();
    }
     @isTest  
    public static void forthsmsReminderBatch(){       
        
        List<Payment_Milestones__c> PMList = New List<Payment_Milestones__c>();
        Payment_Milestones__c paymentMilestone = [SELECT Id,Name,booking__c,Milestone_Status__c,First_Payment_Email_Reminder_Date__c,
                                                  Due_Date__c,Remaining_GST__c,Remaining_Amount__c  FROM Payment_Milestones__c ];
        
        paymentMilestone.Due_Date__c = date.today().addDays(-28);
        update paymentMilestone;
        
        Test.setMock(HttpCalloutMock.class, new SendSMSMock()); 
        Test.startTest();
        forthsmsReminderBatch batch = new forthsmsReminderBatch(); 
        database.executebatch(batch);
        Test.stopTest();
    }
    
}