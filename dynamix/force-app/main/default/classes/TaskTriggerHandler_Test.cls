@isTest
public class TaskTriggerHandler_Test {

    @testSetup
    static void setup() {
        Profile pId = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User(
            FirstName = 'Mayur1',
            LastName = 'Patel123',
            Email = 'mayur.patel@manras.com',
            Alias = 'MPatel',
            Username = uniqueUserName,
            ProfileId = pId.Id,
            EmailEncodingKey = 'UTF-8',
            Country = 'India',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUserRcd1;

        Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
        Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

        Account accountObject = new Account(
            FirstName = 'test',
            LastName = 'Account',
            BillingCountry = 'India',
            Phone = '455546565',
            RecordTypeId = PersonRecId,
            PersonEmail = 'dynamix.project@gmail.com',
            PersonMobilePhone = '4587856985',
            Aadhar_No__pc = '458785698547',
            PAN_No__c = 'ABCTY1234D',
            Aadhar_Uploaded__pc = true,
            PAN_Card_Uploaded__pc = true
        );
        insert accountObject;

        Project__c projectObject = new Project__c(
            Name = 'Test Project',
            Project_Email__c = 'mayur.patel@manras.com',
            Project_Carpet_Area__c = '475 - 1 BHK',
            Budgets__c = 'Under 75 lakhs',
            Configuration__c = '1 BHK',
            Project_Head__c = testUserRcd1.Id,
            Site_Head__c = testUserRcd1.Id
        );
        insert projectObject;

        Opportunity oppoObject = new Opportunity(
            AccountId = accountObject.Id,
            Name = 'test Opportunity',
            StageName = 'Site Visit',
            CloseDate = System.Today() + 3,
            Walk_in_Source__c = 'Presales',
            Project__c = projectObject.Id
        );
        insert oppoObject;

        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c(
            Name = 'Pricing Plan Test',
            Project__c = projectObject.Id
        );
        insert pricingPlanObject;

        Property__c propertyObject = new Property__c(
            Name = 'test property',
            Project__c = projectObject.Id,
            Property_Price_Slab__c = pricingPlanObject.Id,
            Floor__c = '5'
        );
        insert propertyObject;

        Suggested_Property__c suggestedProperty = new Suggested_Property__c(
            Opportunity__c = oppoObject.Id,
            Unit__c = propertyObject.Id,
            Discount__c = 10
        );
        insert suggestedProperty;

        Project_Add_On_Charges__c projectAddbject = new Project_Add_On_Charges__c(
            Charge_Type__c = 'Fixed',
            Charge_Group__c = 'Floor Rise',
            Is_Optional__c = false,
            RecordTypeId = ChargesId,
            Project__c = projectObject.Id,
            Name = 'Basic Price'
        );
        insert projectAddbject;

        Project_Add_On_Charges__c projectAddbject1 = new Project_Add_On_Charges__c(
            Charge_Type__c = 'Fixed',
            Charge_Group__c = 'Agreement',
            Is_Optional__c = false,
            RecordTypeId = parkingId,
            Project__c = projectObject.Id,
            Name = 'Stilt'
        );
        insert projectAddbject1;

        Add_On__c addOn = new Add_On__c(
            Opportunity__c = oppoObject.Id,
            Project_Add_On_Charges__c = projectAddbject1.Id
        );
        insert addOn;

        Property_Add_On__c propertyAddOn = new Property_Add_On__c(
            Project_Add_On__c = projectAddbject1.Id,
            Property__c = propertyObject.Id,
            Is_Included__c = true
        );
        insert propertyAddOn;

        Payment_Plan__c paymentPlan = new Payment_Plan__c(
            Name = 'Test23',
            Project__c = projectObject.Id
        );
        insert paymentPlan;

        Project_Progress__c testProjProgRcd = new Project_Progress__c(
            Name = 'Test project progress',
            Project__c = projectObject.Id,
            Stage_Type__c = 'Booking',
            Stage__c = 'Completion',
            Progress_Status__c = 'In Progress'
        );
        insert testProjProgRcd;

        Payment_Plan_Milestones__c paymentMilestoneObject = new Payment_Plan_Milestones__c(
            Name = 'Test',
            Payment_Plan__c = paymentPlan.Id,
            Milestone_Activation__c = 'Booking Date',
            Sequence_No__c = 1,
            Milestone_age__c = 100,
            Days_after_Booking__c = 2,
            Project_Progress__c = testProjProgRcd.Id
        );
        insert paymentMilestoneObject;

        Pricing_Plan_Components__c planComponentObject = new Pricing_Plan_Components__c(
            Name = 'Basic Price',
            GST_Treatment__c = 'Standard',
            Project_Add_On_Charges__c = projectAddbject.Id,
            Price_Lumpsum__c = 200,
            Pricing_Plan__c = propertyObject.Property_Price_Slab__c
        );
        insert planComponentObject;

        Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c(
            Name = 'Stilt',
            GST_Treatment__c = 'Standard',
            Project_Add_On_Charges__c = projectAddbject1.Id,
            Price_Lumpsum__c = 200,
            Pricing_Plan__c = propertyObject.Property_Price_Slab__c
        );
        insert planComponentObject1;

        Booking__c booking = new Booking__c(
            Primary_Applicant__c = accountObject.Id,
            Related_Opportunity__c = oppoObject.Id,
            Related_Suggested_Property__c = suggestedProperty.Id,
            Project_Name__c = projectObject.Id,
            OwnerId = testUserRcd1.Id
        );
        insert booking;

        Booking_Line_Items__c bookingLineObjects = new Booking_Line_Items__c(
            Booking__c = booking.Id,
            Project_Add_On_Charges__c = projectAddbject.Id,
            Property__c = propertyObject.Id
        );
        insert bookingLineObjects;

        Price_Details__c priceDetailObject = new Price_Details__c(
            Name = 'Price Test1',
            Charge_Group__c = 'Agreement',
            GST_Type__c = 'Standard',
            Booking__c = booking.Id,
            Amount__c = 7800000
        );
        insert priceDetailObject;

        Price_Details__c priceDetailObject1 = new Price_Details__c(
            Name = 'Price Test',
            Charge_Group__c = 'Agreement',
            GST_Type__c = 'Standard',
            Booking__c = booking.Id,
            Amount__c = 8200000
        );
        insert priceDetailObject1;

        Bank__c Bank = new Bank__c(Name = 'PNB Bank');
        insert Bank;

        Bank_Loan_Details__c BLD = new Bank_Loan_Details__c(
            Home_LoanInstitution__c = Bank.Id,
            Booking__c = booking.Id
        );
        insert BLD;

        Task tsk = new Task(
            Subject = 'Generate Draft Agreement',
            Status = 'Pending',
            Priority = 'Normal',
            WhatId = booking.Id,
            OwnerId = testUserRcd1.Id
        );
        insert tsk;

        Task tsk5 = new Task(
            Subject = 'SDR Letter for the Booking',
            Status = 'Pending',
            Priority = 'Normal',
            WhatId = booking.Id,
            OwnerId = testUserRcd1.Id
        );
        insert tsk5;

        Task tsk1 = new Task(
            Subject = 'Welcome Call',
            Status = 'Pending',
            Priority = 'Normal',
            WhatId = booking.Id,
            OwnerId = testUserRcd1.Id
        );
        insert tsk1;

        Task tsk3 = new Task(
            Subject = 'Generate Final Agreement',
            Status = 'Pending',
            Priority = 'Normal',
            WhatId = booking.Id,
            OwnerId = testUserRcd1.Id
        );
        insert tsk3;

        Task tsk4 = new Task(
            Subject = 'SDR Receipt',
            Status = 'Pending',
            Priority = 'Normal',
            WhatId = booking.Id,
            OwnerId = testUserRcd1.Id
        );
        insert tsk4;

        Task tsk2 = new Task(
            Subject = 'Initiate Welcome Call',
            Status = 'Completed',
            Priority = 'Normal',
            WhatId = booking.Id,
            OwnerId = testUserRcd1.Id
        );
        insert tsk2;

        update new List<Task> { tsk, tsk5, tsk1, tsk3, tsk4, tsk2 };
    }
    

    @isTest
    static void testTaskTriggerHandler() {
        List<Task> tskList = [SELECT Id, Subject, Status, WhatId FROM Task];

        for (Task tsk : tskList) {
            tsk.Status = 'Completed';
        }
        update tskList;

        Test.startTest();
        // Update the task status to simulate trigger execution
        Task updatedTask = [SELECT Id, Status FROM Task LIMIT 1];
        updatedTask.Status = 'Completed';
        update updatedTask;
        Test.stopTest();

      //  List<Booking__c> bookingList = [SELECT Id, Booking_Status__c FROM Booking__c];
        //for (Booking__c booking : bookingList) {
          //  System.assertEquals('Agreement Drafted', booking.Booking_Status__c);
        //}
    }

    @isTest
    static void testSDRLetterCompletion() {
        Task tsk = [SELECT Id, Subject, Status, WhatId FROM Task WHERE Subject = 'SDR Letter for the Booking' LIMIT 1];
        tsk.Status = 'Completed';
        update tsk;

        Test.startTest();
        Task updatedTask = [SELECT Id, Status FROM Task WHERE Id = :tsk.Id];
        updatedTask.Status = 'Completed';
        update updatedTask;
        Test.stopTest();

       // List<Booking__c> bookingList = [SELECT Id, Booking_Status__c FROM Booking__c];
       // for (Booking__c booking : bookingList) {
         //   System.assertEquals('Booking Agreement Received', booking.Booking_Status__c);
        }
    

    @isTest
    static void testWelcomeCallCompletion() {
        Task tsk = [SELECT Id, Subject, Status, WhatId FROM Task WHERE Subject = 'Welcome Call' LIMIT 1];
        tsk.Status = 'Completed';
        update tsk;

        Test.startTest();
        Task updatedTask = [SELECT Id, Status FROM Task WHERE Id = :tsk.Id];
        updatedTask.Status = 'Completed';
        update updatedTask;
        Test.stopTest();

        
        
    }

    @isTest
    static void testInitiateWelcomeCallCompletion() {
        Task tsk = [SELECT Id, Subject, Status, WhatId FROM Task WHERE Subject = 'Initiate Welcome Call' LIMIT 1];
        tsk.Status = 'Completed';
        update tsk;

        Test.startTest();
        Task updatedTask = [SELECT Id, Status FROM Task WHERE Id = :tsk.Id];
        updatedTask.Status = 'Completed';
        update updatedTask;
        Test.stopTest();

    }

    @isTest
    static void testSDRReceiptCompletion() {
        Task tsk = [SELECT Id, Subject, Status, WhatId FROM Task WHERE Subject = 'SDR Receipt' LIMIT 1];
        tsk.Status = 'Completed';
        update tsk;

        Test.startTest();
        Task updatedTask = [SELECT Id, Status FROM Task WHERE Id = :tsk.Id];
        updatedTask.Status = 'Completed';
        update updatedTask;
        Test.stopTest();

        
    }

    @isTest
    static void testGenerateFinalAgreementCompletion() {
        Task tsk = [SELECT Id, Subject, Status, WhatId FROM Task WHERE Subject = 'Generate Final Agreement' LIMIT 1];
        tsk.Status = 'Completed';
        update tsk;

        Test.startTest();
        Task updatedTask = [SELECT Id, Status FROM Task WHERE Id = :tsk.Id];
        updatedTask.Status = 'Completed';
        update updatedTask;
        Test.stopTest();

        
    }
}