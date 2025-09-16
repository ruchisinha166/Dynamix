@isTest
public class BrokerPaymentTriggerHandler_Test {
    @isTest  
    public static void Method1(){
        
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
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Id PersonRecId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.LastName = 'test';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.RERA_Number__c = 'Account';
            insert accountObject;
            
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
            insert oppoObject;
            
            Builder_Organisation__c BO = New Builder_Organisation__c();
            BO.Name = 'Dynamix Organisation';
            BO.Builder_Organisation_Initials__c = 'c';
            insert BO;
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'nishi@manras.com';
            projectObject.Site_Head__c = testUserRcd1.Id;
            projectObject.Builder_Organization__c = BO.Id;
            projectObject.Project_Initials__c = 'Test Project';
            projectObject.Last_Invoice_Number__c = 48;
            insert projectObject;
            
            Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
            pricingPlanObject.Name = 'Pricing Plan Test';
            pricingPlanObject.Project__c = projectObject.Id;
            insert pricingPlanObject;
            
            Property__c propertyObject3 = new Property__c();
            propertyObject3.Name = 'test property2';
            propertyObject3.Project__c = projectObject.Id;
            propertyObject3.Property_Price_Slab__c = pricingPlanObject.Id;
            propertyObject3.Floor__c= '4';
            propertyObject3.Index__c = 3;
            insert propertyObject3;
            
            Suggested_Property__c suggestedProperty = new Suggested_Property__c();
            suggestedProperty.Opportunity__c = oppoObject.Id;
            suggestedProperty.Unit__c = propertyObject3.Id;
            suggestedProperty.Discount__c = 10;
            insert suggestedProperty;
            
            
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
            paymentMilestoneObject.Days_after_Booking__c = 2;
            paymentMilestoneObject.Project_Progress__c=testProjProgRcd.Id;
            insert paymentMilestoneObject;
            
            
            Booking__c booking = new Booking__c();
            booking.Primary_Applicant__c = accountObject.Id;
            booking.Related_Opportunity__c = oppoObject.Id;
            booking.Project_Name__c = projectObject.Id;
            booking.OwnerId = testUserRcd1.Id;
            booking.Channel_Partner__c = accountObject1.Id;
            booking.Related_Suggested_Property__c = suggestedProperty.Id;            
            insert booking;
            
            Broker_Payment__c brokerpayObj = new Broker_Payment__c();
            brokerpayObj.Name = 'Test Broker Payment';
            brokerpayObj.Booking__c = booking.id;
            brokerpayObj.Channel_Partner__c = accountObject.Id;
            brokerpayObj.Picklist_Payment_Cleared__c='F&F';
            brokerpayObj.Amount__c=1230;
            insert brokerpayObj;
            
            Broker_Payment__c brokerpayObj1 = new Broker_Payment__c();
            brokerpayObj1.Name = 'Test Broker Payment';
            brokerpayObj1.Booking__c = booking.id;
            brokerpayObj1.Channel_Partner__c = accountObject.Id;           
            insert brokerpayObj1;
            
            Broker_Payment__c brokerpayObj2=[Select Id,Name,Picklist_Payment_Cleared__c From Broker_Payment__c Where Id=:brokerpayObj1.Id ];
            brokerpayObj2.Picklist_Payment_Cleared__c='F&F';
            update brokerpayObj2;
        }
    }
    
}