@isTest
private class SendNotificationForOCReceivalTest {
    @isTest
    static void testSendEmail() {
        // Create test data - EmailTemplate
       EmailTemplate emailTemplate = [select Id,Subject,HtmlValue,Body from EmailTemplate where Name =: 'OC Receival Certificate Email'];
        SendNotificationForOCReceival.method();
        
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
            accountObject.Upload_PAN_Card__c=true;
            accountObject.PersonMobilePhone ='9875687784';
            insert accountObject;
        
        // Create test data - Projects
        Project__c project = new Project__c();
        project.Name = 'Test Project';
        project.Budgets__c = 'Under 75 Lakhs';
        project.Project_Carpet_Area__c = '475 - 1 BHK';
        project.Configuration__c = '1 BHK';
        project.Project_Email__c = 'divum@dynamixgroup.co.in';
        project.OC_Number__c = '123456';
        project.Project_Phone__c = '2548795468';
        project.OC_Receival_Date__c = System.today();
        insert project;
       
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Project__c = project.Id;
        oppoObject.Walk_in_Source__c = 'Hoarding';
        insert oppoObject;
        
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = project.Id;
        insert pricingPlanObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = project.Id;
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Floor__c= '5';
        insert propertyObject;
        
        Suggested_Property__c suggestedProperty = new Suggested_Property__c();
        suggestedProperty.Opportunity__c = oppoObject.Id;
        suggestedProperty.Unit__c = propertyObject.Id;
        suggestedProperty.Discount__c = 10;
        insert suggestedProperty;

        

        // Create test data - Bookings
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = project.Id;
        insert booking;
        
        project.OC_Number__c = '1234567';
         project.OC_Receival_Date__c = System.today();
        update project;
        
        // Mock the old project data
       // Map<Id, Project__c> oldProjMap = new Map<Id, Project__c>{project.Id => project};

        // Call the method to be tested
        //Test.startTest();
        //SendNotificationForOCReceival.sendEmail(new List<Project__c>{project}, oldProjMap);
        //Test.stopTest();

    }
}