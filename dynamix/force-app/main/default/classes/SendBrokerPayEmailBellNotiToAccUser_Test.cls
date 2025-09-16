@isTest
public class SendBrokerPayEmailBellNotiToAccUser_Test {
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
            projectObject.Project_Email__c= 'nishi@manras.com';
            projectObject.Site_Head__c = testUserRcd1.Id;
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
            
            
            Add_On__c addOn = new Add_On__c();
            addOn.Opportunity__c = oppoObject.Id;
            addOn.Project_Add_On_Charges__c = projectAddbject1.Id;
            insert addOn;
            
          
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
            
            Broker_Payment__c brokerpayObj = new Broker_Payment__c();
            brokerpayObj.Name = 'Test Broker Payment';
            brokerpayObj.Booking__c = booking.id;
            brokerpayObj.Channel_Partner__c = accountObject.Id;
            brokerpayObj.Picklist_Payment_Cleared__c='F&F';
            brokerpayObj.Amount__c=1230;
            insert brokerpayObj;
            
            SendBrokerPaymentEmailBellNotiToAccUser.Request allObj = new SendBrokerPaymentEmailBellNotiToAccUser.Request();
            allObj.brokerPaymentRecodId = brokerpayObj.Id;
            List<SendBrokerPaymentEmailBellNotiToAccUser.Request> Requests = new List<SendBrokerPaymentEmailBellNotiToAccUser.Request>();
            Requests.add(allObj);
            SendBrokerPaymentEmailBellNotiToAccUser.execute(Requests);
        }
    }    
}