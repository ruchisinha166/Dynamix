@isTest 
public class TaskTriggerHandler_Test {
    
    @isTest   
    static void Method1() {
        BusinessHours bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];         
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
        accountObject.PersonMobilePhone = '4587856985';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.Email__c = 'noreply@salesforce.com.invalid';
        accountObject.CP_Name__c = 'abc';
        accountObject.RERA_Number__c = '23wertyu';
        accountObject.Rera_Certification__c = 'abhd';
        insert accountObject;
        
        Contact contact = [SELECT id, AccountId, Name from Contact WHERE AccountId =: accountObject.Id];
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = testUserRcd1.Id;
        projectObject.Site_Head__c = testUserRcd1.id;
        insert projectObject;
        
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Walk_in_Source__c = 'Presales';
        oppoObject.Project__c = projectObject.id;
        insert oppoObject;
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        insert pricingPlanObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Floor__c= '4';
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
        propertyAddOn.Project_Add_On__c = projectAddbject1.Id;
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
        
        Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c();
        planComponentObject1.Name = 'Stilt';
        planComponentObject1.GST_Treatment__c = 'Standard';
        planComponentObject1.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject1.Price_Lumpsum__c  = 200;
        planComponentObject1.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject1;
        
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.OwnerId = testUserRcd1.Id;
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
        priceDetailObject.Amount__c = 7800000;
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= 'Agreement';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = booking.Id;
        priceDetailObject1.Amount__c = 8200000;
        insert priceDetailObject1;
        
        System.debug('Agt AMt'+booking.Agreement_Value__c);
        
        Bank__c Bank = New Bank__c();
        Bank.Name = 'PNB Bank';
        insert Bank;
        
        Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
        BLD.Home_LoanInstitution__c = Bank.Id;
        BLD.Booking__c = booking.Id;
        Insert BLD;
        
        Task_Target__c tasktarget = new Task_Target__c();
        tasktarget.Month__c =System.now().format('MMMMM');
        tasktarget.User__c = testUserRcd1.Id;
        tasktarget.Year__c = String.valueof(System.today().year());
        tasktarget.Number_of_Targets_Achievement__c = null;
        tasktarget.X1st_Week__c = 0;
        tasktarget.X2nd_Week__c =null;
        tasktarget.X3rd_Week__c = null;
        tasktarget.X4th_Week__c = null;
        tasktarget.X5th_Week__c =null;
        tasktarget.Project__c = projectObject.Id;
        tasktarget.Number_of_Connected_Call__c = 0;
        tasktarget.No_of_Walk_ins__c = 0;
        tasktarget.No_of_Follow_Ups__c =0;
        tasktarget.Number_of_Targets__c = 100;
        tasktarget.Type__c = 'Unique Outbound';
        
        insert tasktarget;
        Test.startTest();
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Welcome_Call_Letter_Task_Created' limit 1];
        //Test.stopTest();
        
        //Test.startTest();
        CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
        Datetime  NextWorkingDays = calc.AddDays(System.now(),1);
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where Id =: testUserRcd1.Id]);
        EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Welcome Letter Sent' Limit 1];
        
        Enquiry__c enquiry = new Enquiry__c();
        enquiry.Contact_Person__c = accountObject.Id;
        enquiry.Stage__c = 'New Enquiry';
        enquiry.Enquiry_Source__c = 'Google';
        insert enquiry;        
        Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>();
        List<Booking__c> bookingList =  [Select Id,Name,OwnerId,Unit_Number__c,Project_Name_Formulla__c,Customer_Mobile_No__c,Primary_Applicant__c,Primary_Applicant__r.Name,Booking_Owner_Email__c From Booking__c where Id =: booking.Id];
        
        Group grou = new Group();
        grou.Type = 'Queue';
        grou.Name = 'omni Channel';
        insert grou;
        
        Map<id,Task> oldMapIdToTask = new Map<id,Task>();
        List<Task> taskList = new List<Task>();
        Task tsk12 = new Task();
        tsk12.Subject = 'SDR Letter for the Booking';
        tsk12.Status = 'Pending';
        tsk12.Priority = 'Normal';
        tsk12.WhatId = booking.Id;
        tsk12.OwnerId = testUserRcd1.Id;
        tsk12.ActivityDate = System.today();
        tsk12.Call_Status__c = 'Connected';
        tsk12.Call_Sub_status__c = 'Interested';
        tsk12.Description = 'hdgfyu';
        insert tsk12;
        oldMapIdToTask.get(tsk12.Id);    
        
        tsk12.Subject = 'Welcome Call';
        tsk12.Status = 'Completed';
        update tsk12;
        taskList.add(tsk12);
        mapIdToBooking.containsKey(tsk12.whatId);
        
        TaskTriggerHandler.sendEmailToRMCRMWhenWelcomeCallTaskCreated(taskList);
        Test.stopTest();
        
    }    
    
    @isTest  
    public static void Method2(){
        BusinessHours bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];         
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
        accountObject.PersonMobilePhone = '4587856985';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.Email__c = 'noreply@salesforce.com.invalid';
        accountObject.CP_Name__c = 'abc';
        accountObject.RERA_Number__c = '23wertyu';
        accountObject.Rera_Certification__c = 'abhd';
        insert accountObject;
        
        Contact contact = [SELECT id, AccountId, Name from Contact WHERE AccountId =: accountObject.Id];
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = testUserRcd1.Id;
        projectObject.Site_Head__c = testUserRcd1.id;
        insert projectObject;
        
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Walk_in_Source__c = 'Presales';
        oppoObject.Project__c = projectObject.id;
        insert oppoObject;
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        insert pricingPlanObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Floor__c= '4';
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
        propertyAddOn.Project_Add_On__c = projectAddbject1.Id;
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
        
        Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c();
        planComponentObject1.Name = 'Stilt';
        planComponentObject1.GST_Treatment__c = 'Standard';
        planComponentObject1.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject1.Price_Lumpsum__c  = 200;
        planComponentObject1.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject1;
        
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.OwnerId = testUserRcd1.Id;
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
        priceDetailObject.Amount__c = 7800000;
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= 'Agreement';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = booking.Id;
        priceDetailObject1.Amount__c = 8200000;
        insert priceDetailObject1;
        
        System.debug('Agt AMt'+booking.Agreement_Value__c);
        
        Bank__c Bank = New Bank__c();
        Bank.Name = 'PNB Bank';
        insert Bank;
        
        Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
        BLD.Home_LoanInstitution__c = Bank.Id;
        BLD.Booking__c = booking.Id;
        Insert BLD;
        
        Task_Target__c tasktarget = new Task_Target__c();
        tasktarget.Month__c =System.now().format('MMMMM');
        tasktarget.User__c = testUserRcd1.Id;
        tasktarget.Year__c = String.valueof(System.today().year());
        tasktarget.Number_of_Targets_Achievement__c = null;
        tasktarget.X1st_Week__c = 0;
        tasktarget.X2nd_Week__c =null;
        tasktarget.X3rd_Week__c = null;
        tasktarget.X4th_Week__c = null;
        tasktarget.X5th_Week__c =null;
        tasktarget.Project__c = projectObject.Id;
        tasktarget.Number_of_Connected_Call__c = 0;
        tasktarget.No_of_Walk_ins__c = 0;
        tasktarget.No_of_Follow_Ups__c =0;
        tasktarget.Number_of_Targets__c = 100;
        tasktarget.Type__c = 'Unique Outbound';
        
        insert tasktarget;
        
        
        Test.startTest();
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Welcome_Call_Letter_Task_Created' limit 1];
        CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
        System.debug('calc-------------->'+calc);
        Datetime  NextWorkingDays = calc.AddDays(System.now(),1);
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where Id =: testUserRcd1.Id]);
        EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Welcome Letter Sent' Limit 1];
        
        Enquiry__c enquiry = new Enquiry__c();
        enquiry.Contact_Person__c = accountObject.Id;
        enquiry.Stage__c = 'New Enquiry';
        enquiry.Enquiry_Source__c = 'Google';
        insert enquiry;        
        Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Primary_Applicant__c,Name,OwnerId  From Booking__c WHERE ID =: booking.Id]);
        
        Group grou = new Group();
        grou.Type = 'Queue';
        grou.Name = 'omni Channel';
        insert grou;
        
        Map<id,Task> oldMapIdToTask = new Map<id,Task>();
        List<Task> taskList = new List<Task>();
        Task tsk12 = new Task();
        tsk12.Subject = 'SDR Letter for the Booking';
        tsk12.Status = 'Pending';
        tsk12.Priority = 'Normal';
        tsk12.WhatId = booking.Id;
        tsk12.OwnerId = testUserRcd1.Id;
        tsk12.ActivityDate = System.today();
        tsk12.Call_Status__c = 'Connected';
        tsk12.Call_Sub_status__c = 'Interested';
        tsk12.Description = 'hdgfyu';
        insert tsk12;
        oldMapIdToTask.get(tsk12.Id);    
        
        tsk12.Subject = 'Welcome Call';
        tsk12.Status = 'Completed';
        update tsk12;
        taskList.add(tsk12);
        mapIdToBooking.containsKey(tsk12.whatId);
        
        TaskTriggerHandler.WelcomeStatusClosedSendEmailToCustomer(taskList,oldMapIdToTask);
        TaskTriggerHandler.whenWelcomeTaskClosedCreateAgreementTask(taskList,oldMapIdToTask);
        Test.stopTest();
        
    }
    @isTest  
    public static void Method3(){
        BusinessHours bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];         
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
        accountObject.PersonMobilePhone = '4587856985';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.Email__c = 'noreply@salesforce.com.invalid';
        accountObject.CP_Name__c = 'abc';
        accountObject.RERA_Number__c = '23wertyu';
        accountObject.Rera_Certification__c = 'abhd';
        insert accountObject;
        
        Contact contact = [SELECT id, AccountId, Name from Contact WHERE AccountId =: accountObject.Id];
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = testUserRcd1.Id;
        projectObject.Site_Head__c = testUserRcd1.id;
        insert projectObject;
        
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Walk_in_Source__c = 'Presales';
        oppoObject.Project__c = projectObject.id;
        insert oppoObject;
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        insert pricingPlanObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Floor__c= '4';
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
        propertyAddOn.Project_Add_On__c = projectAddbject1.Id;
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
        
        Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c();
        planComponentObject1.Name = 'Stilt';
        planComponentObject1.GST_Treatment__c = 'Standard';
        planComponentObject1.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject1.Price_Lumpsum__c  = 200;
        planComponentObject1.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject1;
        
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.OwnerId = testUserRcd1.Id;
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
        priceDetailObject.Amount__c = 7800000;
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= 'Agreement';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = booking.Id;
        priceDetailObject1.Amount__c = 8200000;
        insert priceDetailObject1;
        
        System.debug('Agt AMt'+booking.Agreement_Value__c);
        
        Bank__c Bank = New Bank__c();
        Bank.Name = 'PNB Bank';
        insert Bank;
        
        Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
        BLD.Home_LoanInstitution__c = Bank.Id;
        BLD.Booking__c = booking.Id;
        Insert BLD;
        
        Task_Target__c tasktarget = new Task_Target__c();
        tasktarget.Month__c =System.now().format('MMMMM');
        tasktarget.User__c = testUserRcd1.Id;
        tasktarget.Year__c = String.valueof(System.today().year());
        tasktarget.Number_of_Targets_Achievement__c = null;
        tasktarget.X1st_Week__c = 0;
        tasktarget.X2nd_Week__c =null;
        tasktarget.X3rd_Week__c = null;
        tasktarget.X4th_Week__c = null;
        tasktarget.X5th_Week__c =null;
        tasktarget.Project__c = projectObject.Id;
        tasktarget.Number_of_Connected_Call__c = 0;
        tasktarget.No_of_Walk_ins__c = 0;
        tasktarget.No_of_Follow_Ups__c =0;
        tasktarget.Number_of_Targets__c = 100;
        tasktarget.Type__c = 'Unique Outbound';
        
        insert tasktarget;
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CalloutMock());

        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Welcome_Call_Letter_Task_Created' limit 1];
        CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
        System.debug('calc-------------->'+calc);
        Datetime  NextWorkingDays = calc.AddDays(System.now(),1);
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where Id =: testUserRcd1.Id]);
        EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Welcome Letter Sent' Limit 1];
        
        Enquiry__c enquiry = new Enquiry__c();
        enquiry.Contact_Person__c = accountObject.Id;
        enquiry.Stage__c = 'New Enquiry';
        enquiry.Enquiry_Source__c = 'Google';
        insert enquiry;        
        
        Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Primary_Applicant__c,Agreement_Shared_Date__c,Name,OwnerId,Unit_Number__c,Project_Name_Formulla__c From Booking__c where Id =: booking.Id]);
        
        Group grou = new Group();
        grou.Type = 'Queue';
        grou.Name = 'omni Channel';
        insert grou;
        
        Map<id,Task> oldMapIdToTask = new Map<id,Task>();
        List<Task> taskList = new List<Task>();
        Task tsk12 = new Task();
        tsk12.Subject = 'SDR Letter for the Booking';
        tsk12.Status = 'Pending';
        tsk12.Priority = 'Normal';
        tsk12.WhatId = booking.Id;
        tsk12.OwnerId = testUserRcd1.Id;
        tsk12.ActivityDate = System.today();
        tsk12.Call_Status__c = 'Connected';
        tsk12.Call_Sub_status__c = 'Interested';
        tsk12.Description = 'hdgfyu';
        insert tsk12;
        oldMapIdToTask.get(tsk12.Id);    
        
        tsk12.Subject = 'Generate Draft Agreement';
        tsk12.Status = 'Shared';
        update tsk12;
        taskList.add(tsk12);
        mapIdToBooking.containsKey(tsk12.whatId);
        
        TaskTriggerHandler.whenAgreeTaskStatusSharedUpdateBookingAgreeDate(taskList,oldMapIdToTask);
        Test.stopTest();
        
    }
    @isTest  
    public static void Method4(){
        BusinessHours bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];         
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
        accountObject.PersonMobilePhone = '4587856985';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.Email__c = 'noreply@salesforce.com.invalid';
        accountObject.CP_Name__c = 'abc';
        accountObject.RERA_Number__c = '23wertyu';
        accountObject.Rera_Certification__c = 'abhd';
        insert accountObject;
        
        Contact contact = [SELECT id, AccountId, Name from Contact WHERE AccountId =: accountObject.Id];
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = testUserRcd1.Id;
        projectObject.Site_Head__c = testUserRcd1.id;
        insert projectObject;
        
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Walk_in_Source__c = 'Presales';
        oppoObject.Project__c = projectObject.id;
        insert oppoObject;
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        insert pricingPlanObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Floor__c= '4';
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
        propertyAddOn.Project_Add_On__c = projectAddbject1.Id;
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
        
        Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c();
        planComponentObject1.Name = 'Stilt';
        planComponentObject1.GST_Treatment__c = 'Standard';
        planComponentObject1.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject1.Price_Lumpsum__c  = 200;
        planComponentObject1.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject1;
        
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.OwnerId = testUserRcd1.Id;
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
        priceDetailObject.Amount__c = 7800000;
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= 'Agreement';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = booking.Id;
        priceDetailObject1.Amount__c = 8200000;
        insert priceDetailObject1;
        
        System.debug('Agt AMt'+booking.Agreement_Value__c);
        
        Bank__c Bank = New Bank__c();
        Bank.Name = 'PNB Bank';
        insert Bank;
        
        Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
        BLD.Home_LoanInstitution__c = Bank.Id;
        BLD.Booking__c = booking.Id;
        Insert BLD;
        
        Task_Target__c tasktarget = new Task_Target__c();
        tasktarget.Month__c =System.now().format('MMMMM');
        tasktarget.User__c = testUserRcd1.Id;
        tasktarget.Year__c = String.valueof(System.today().year());
        tasktarget.Number_of_Targets_Achievement__c = null;
        tasktarget.X1st_Week__c = 0;
        tasktarget.X2nd_Week__c =null;
        tasktarget.X3rd_Week__c = null;
        tasktarget.X4th_Week__c = null;
        tasktarget.X5th_Week__c =null;
        tasktarget.Project__c = projectObject.Id;
        tasktarget.Number_of_Connected_Call__c = 0;
        tasktarget.No_of_Walk_ins__c = 0;
        tasktarget.No_of_Follow_Ups__c =0;
        tasktarget.Number_of_Targets__c = 100;
        tasktarget.Type__c = 'Unique Outbound';
        
        insert tasktarget;
        
        
        Test.startTest();
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Welcome_Call_Letter_Task_Created' limit 1];
        CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
        System.debug('calc-------------->'+calc);
        Datetime  NextWorkingDays = calc.AddDays(System.now(),1);
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where Id =: testUserRcd1.Id]);
        EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Welcome Letter Sent' Limit 1];
        
        Enquiry__c enquiry = new Enquiry__c();
        enquiry.Contact_Person__c = accountObject.Id;
        enquiry.Stage__c = 'New Enquiry';
        enquiry.Enquiry_Source__c = 'Google';
        insert enquiry;        
        
        Group grou = new Group();
        grou.Type = 'Queue';
        grou.Name = 'omni Channel';
        insert grou;
        
        Map<id,Task> oldMapIdToTask = new Map<id,Task>();
        List<Task> taskList = new List<Task>();
        Task tsk12 = new Task();
        tsk12.Subject = 'SDR Letter for the Booking';
        tsk12.Status = 'Pending';
        tsk12.Priority = 'Normal';
        tsk12.WhatId = enquiry.Id;
        tsk12.OwnerId = testUserRcd1.Id;
        tsk12.ActivityDate = System.today();
        tsk12.Call_Status__c = 'Connected';
        tsk12.Call_Sub_status__c = 'Interested';
        tsk12.Description = 'hdgfyu';
        insert tsk12;
        oldMapIdToTask.get(tsk12.Id);    
        
        tsk12.Subject = 'Welcome Call';
        tsk12.Status = 'Completed';
        update tsk12;
        taskList.add(tsk12);
        
        TaskTriggerHandler.whenWelcomeTaskClosedCreateAgreementTask(taskList,oldMapIdToTask);
        Test.stopTest();   
    }
    
    /*@isTest  
public static void Method5(){
BusinessHours bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];         
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
accountObject.PersonMobilePhone = '4587856985';
accountObject.Aadhar_No__pc = '458785698547';
accountObject.PAN_No__c = 'ABCTY1234D';
accountObject.Aadhar_Uploaded__pc = true;
accountObject.PAN_Card_Uploaded__pc = true;
accountObject.Email__c = 'noreply@salesforce.com.invalid';
accountObject.CP_Name__c = 'abc';
accountObject.RERA_Number__c = '23wertyu';
accountObject.Rera_Certification__c = 'abhd';
insert accountObject;

Contact contact = [SELECT id, AccountId, Name from Contact WHERE AccountId =: accountObject.Id];

Project__c projectObject = new Project__c();
projectObject.Name = 'Test Project';
projectObject.Project_Email__c= 'mayur.patel@manras.com';
projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
projectObject.Budgets__c = 'Under 75 lakhs';
projectObject.Configuration__c ='1 BHK';
projectObject.Project_Head__c = testUserRcd1.Id;
projectObject.Site_Head__c = testUserRcd1.id;
insert projectObject;


Opportunity oppoObject = new Opportunity();
oppoObject.AccountId = accountObject.Id;
oppoObject.Name = 'test Opportunity';
oppoObject.StageName = 'Site Visit';
oppoObject.CloseDate = System.Today()+3;
oppoObject.Walk_in_Source__c = 'Presales';
oppoObject.Project__c = projectObject.id;
insert oppoObject;

Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
pricingPlanObject.Name = 'Pricing Plan Test';
pricingPlanObject.Project__c = projectObject.Id;
insert pricingPlanObject;

Property__c propertyObject = new Property__c();
propertyObject.Name = 'test property';
propertyObject.Project__c = projectObject.Id;
propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
propertyObject.Floor__c= '4';
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
propertyAddOn.Project_Add_On__c = projectAddbject1.Id;
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

Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c();
planComponentObject1.Name = 'Stilt';
planComponentObject1.GST_Treatment__c = 'Standard';
planComponentObject1.Project_Add_On_Charges__c = projectAddbject1.Id;
planComponentObject1.Price_Lumpsum__c  = 200;
planComponentObject1.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
insert planComponentObject1;


Booking__c booking = new Booking__c();
booking.Primary_Applicant__c = accountObject.Id;
booking.Related_Opportunity__c = oppoObject.Id;
booking.Related_Suggested_Property__c = suggestedProperty.Id;
booking.Project_Name__c = projectObject.Id;
booking.OwnerId = testUserRcd1.Id;
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
priceDetailObject.Amount__c = 7800000;
insert priceDetailObject;

Price_Details__c priceDetailObject1 = new Price_Details__c();
priceDetailObject1.Name = 'Price Test';
priceDetailObject1.Charge_Group__c= 'Agreement';
priceDetailObject1.GST_Type__c = 'Standard' ;
priceDetailObject1.Booking__c = booking.Id;
priceDetailObject1.Amount__c = 8200000;
insert priceDetailObject1;

System.debug('Agt AMt'+booking.Agreement_Value__c);

Bank__c Bank = New Bank__c();
Bank.Name = 'PNB Bank';
insert Bank;

Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
BLD.Home_LoanInstitution__c = Bank.Id;
BLD.Booking__c = booking.Id;
Insert BLD;

Task_Target__c tasktarget = new Task_Target__c();
tasktarget.Month__c =System.now().format('MMMMM');
tasktarget.User__c = testUserRcd1.Id;
tasktarget.Year__c = String.valueof(System.today().year());
tasktarget.Number_of_Targets_Achievement__c = null;
tasktarget.X1st_Week__c = 0;
tasktarget.X2nd_Week__c =null;
tasktarget.X3rd_Week__c = null;
tasktarget.X4th_Week__c = null;
tasktarget.X5th_Week__c =null;
tasktarget.Project__c = projectObject.Id;
tasktarget.Number_of_Connected_Call__c = 0;
tasktarget.No_of_Walk_ins__c = 0;
tasktarget.No_of_Follow_Ups__c =0;
tasktarget.Number_of_Targets__c = 100;
tasktarget.Type__c = 'Unique Outbound';

insert tasktarget;


Test.startTest();
EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Welcome_Call_Letter_Task_Created' limit 1];
CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
System.debug('calc-------------->'+calc);
Datetime  NextWorkingDays = calc.AddDays(System.now(),1);
Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where Id =: testUserRcd1.Id]);
EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Welcome Letter Sent' Limit 1];

Enquiry__c enquiry = new Enquiry__c();
enquiry.Contact_Person__c = accountObject.Id;
enquiry.Stage__c = 'New Enquiry';
enquiry.Enquiry_Source__c = 'Google';
insert enquiry;        

Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,Related_Opportunity__c ,OwnerId,Unit_Number__c,Project_Name_Formulla__c,
Agreemnt_Non_Critical__c,Amount_Non_Critical__c,Bank_Name_Non_Critical__c,Carpet_Area_Non_Critical__c,
Description__c,Flat_No_Non_Critical__c,Flat_Type_Non_Critical__c,Floor_Non_Critical__c,GST_Non_Critical__c,
Intrument_Name__c,KYC_details_Non_Critical__c,PaymentMode__c,Question_10__c,Question_1__c,Question_2__c,
Question_3__c,Question_4__c,Question_5__c,Question_6__c,Question_7__c,Question_8__c,Question_9__c,
RM_Contact_Non_Critical__c,Reciept_Type_Non_Critical__c,Rm_Name_Non_Critical__c,Rm_Work_Hour_Non_Critical__c,
Tower_Non_Critical__c From Booking__c where Id =: booking.Id]);

Group grou = new Group();
grou.Type = 'Queue';
grou.Name = 'omni Channel';
insert grou;

Map<id,Task> oldMapIdToTask = new Map<id,Task>();
List<Task> taskList = new List<Task>();
Task tsk12 = new Task();
tsk12.Subject = 'SDR Letter for the Booking';
tsk12.Status = 'Pending';
tsk12.Priority = 'Normal';
tsk12.WhatId = booking.Id;
tsk12.OwnerId = testUserRcd1.Id;
tsk12.ActivityDate = System.today();
tsk12.Call_Status__c = 'Connected';
tsk12.Call_Sub_status__c = 'Interested';
tsk12.Description = 'hdgfyu';
insert tsk12;
oldMapIdToTask.get(tsk12.Id);    

tsk12.Subject = 'Welcome Call';
tsk12.Status = 'Rejected';
update tsk12;
taskList.add(tsk12);
mapIdToBooking.containsKey(tsk12.whatId);

TaskTriggerHandler.sendEmailWhenWelcomeCallRejected(taskList,oldMapIdToTask);
Test.stopTest();

}*/
    @isTest  
    public static void Method6(){
        BusinessHours bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];         
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
        accountObject.PersonMobilePhone = '4587856985';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.Email__c = 'noreply@salesforce.com.invalid';
        accountObject.CP_Name__c = 'abc';
        accountObject.RERA_Number__c = '23wertyu';
        accountObject.Rera_Certification__c = 'abhd';
        insert accountObject;
        
        Contact contact = [SELECT id, AccountId, Name from Contact WHERE AccountId =: accountObject.Id];
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = testUserRcd1.Id;
        projectObject.Site_Head__c = testUserRcd1.id;
        insert projectObject;
        
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Walk_in_Source__c = 'Presales';
        oppoObject.Project__c = projectObject.id;
        insert oppoObject;
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        insert pricingPlanObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Floor__c= '4';
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
        propertyAddOn.Project_Add_On__c = projectAddbject1.Id;
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
        
        Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c();
        planComponentObject1.Name = 'Stilt';
        planComponentObject1.GST_Treatment__c = 'Standard';
        planComponentObject1.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject1.Price_Lumpsum__c  = 200;
        planComponentObject1.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject1;
        
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.OwnerId = testUserRcd1.Id;
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
        priceDetailObject.Amount__c = 7800000;
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= 'Agreement';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = booking.Id;
        priceDetailObject1.Amount__c = 8200000;
        insert priceDetailObject1;
        
        System.debug('Agt AMt'+booking.Agreement_Value__c);
        
        Bank__c Bank = New Bank__c();
        Bank.Name = 'PNB Bank';
        insert Bank;
        
        Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
        BLD.Home_LoanInstitution__c = Bank.Id;
        BLD.Booking__c = booking.Id;
        Insert BLD;
        
        Task_Target__c tasktarget = new Task_Target__c();
        tasktarget.Month__c =System.now().format('MMMMM');
        tasktarget.User__c = testUserRcd1.Id;
        tasktarget.Year__c = String.valueof(System.today().year());
        tasktarget.Number_of_Targets_Achievement__c = null;
        tasktarget.X1st_Week__c = 0;
        tasktarget.X2nd_Week__c =null;
        tasktarget.X3rd_Week__c = null;
        tasktarget.X4th_Week__c = null;
        tasktarget.X5th_Week__c =null;
        tasktarget.Project__c = projectObject.Id;
        tasktarget.Number_of_Connected_Call__c = 0;
        tasktarget.No_of_Walk_ins__c = 0;
        tasktarget.No_of_Follow_Ups__c =0;
        tasktarget.Number_of_Targets__c = 100;
        tasktarget.Type__c = 'Unique Outbound';
        
        insert tasktarget;
        
        
        Test.startTest();
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Welcome_Call_Letter_Task_Created' limit 1];
        CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
        System.debug('calc-------------->'+calc);
        Datetime  NextWorkingDays = calc.AddDays(System.now(),1);
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where Id =: testUserRcd1.Id]);
        EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Welcome Letter Sent' Limit 1];
        
        Enquiry__c enquiry = new Enquiry__c();
        enquiry.Contact_Person__c = accountObject.Id;
        enquiry.Stage__c = 'New Enquiry';
        enquiry.Enquiry_Source__c = 'Google';
        insert enquiry;        
        
        Group grou = new Group();
        grou.Type = 'Queue';
        grou.Name = 'omni Channel';
        insert grou;
        
        List<Task> taskList = new List<Task>();
        Task tsk12 = new Task();
        tsk12.Subject = 'Welcome Call';
        tsk12.Status = 'Re-initiated';
        tsk12.Priority = 'Normal';
        tsk12.WhatId = enquiry.Id;
        tsk12.OwnerId = testUserRcd1.Id;
        tsk12.ActivityDate = System.today();
        tsk12.Call_Status__c = 'Connected';
        tsk12.Call_Sub_status__c = 'Interested';
        tsk12.Description = 'hdgfyu';
        insert tsk12;
        taskList.add(tsk12);
        
        TaskTriggerHandler.disableEditForWelcomeCallTask(taskList);
        Test.stopTest();
        
    }
    @isTest  
    public static void Method7(){
        BusinessHours bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];         
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
        accountObject.PersonMobilePhone = '4587856985';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.Email__c = 'noreply@salesforce.com.invalid';
        accountObject.CP_Name__c = 'abc';
        accountObject.RERA_Number__c = '23wertyu';
        accountObject.Rera_Certification__c = 'abhd';
        insert accountObject;
        
        Contact contact = [SELECT id, AccountId, Name from Contact WHERE AccountId =: accountObject.Id];
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = testUserRcd1.Id;
        projectObject.Site_Head__c = testUserRcd1.id;
        insert projectObject;
        
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Walk_in_Source__c = 'Presales';
        oppoObject.Project__c = projectObject.id;
        insert oppoObject;
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        insert pricingPlanObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Floor__c= '4';
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
        propertyAddOn.Project_Add_On__c = projectAddbject1.Id;
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
        
        Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c();
        planComponentObject1.Name = 'Stilt';
        planComponentObject1.GST_Treatment__c = 'Standard';
        planComponentObject1.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject1.Price_Lumpsum__c  = 200;
        planComponentObject1.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject1;
        
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.OwnerId = testUserRcd1.Id;
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
        priceDetailObject.Amount__c = 7800000;
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= 'Agreement';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = booking.Id;
        priceDetailObject1.Amount__c = 8200000;
        insert priceDetailObject1;
        
        System.debug('Agt AMt'+booking.Agreement_Value__c);
        
        Bank__c Bank = New Bank__c();
        Bank.Name = 'PNB Bank';
        insert Bank;
        
        Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,OwnerId,Unit_Number__c,Project_Name_Formulla__c,Customer_Mobile_No__c,Primary_Applicant__c,Primary_Applicant__r.Name From Booking__c where Id =: booking.Id]);
        
        
        Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
        BLD.Home_LoanInstitution__c = Bank.Id;
        BLD.Booking__c = booking.Id;
        Insert BLD;
        
        Task_Target__c tasktarget = new Task_Target__c();
        tasktarget.Month__c =System.now().format('MMMMM');
        tasktarget.User__c = testUserRcd1.Id;
        tasktarget.Year__c = String.valueof(System.today().year());
        tasktarget.Number_of_Targets_Achievement__c = null;
        tasktarget.X1st_Week__c = 0;
        tasktarget.X2nd_Week__c =null;
        tasktarget.X3rd_Week__c = null;
        tasktarget.X4th_Week__c = null;
        tasktarget.X5th_Week__c =null;
        tasktarget.Project__c = projectObject.Id;
        tasktarget.Number_of_Connected_Call__c = 0;
        tasktarget.No_of_Walk_ins__c = 0;
        tasktarget.No_of_Follow_Ups__c =0;
        tasktarget.Number_of_Targets__c = 100;
        tasktarget.Type__c = 'Unique Outbound';
        
        insert tasktarget;
        
        
        Test.startTest();
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Welcome_Call_Letter_Task_Created' limit 1];
        CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
        System.debug('calc-------------->'+calc);
        Datetime  NextWorkingDays = calc.AddDays(System.now(),1);
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where Id =: testUserRcd1.Id]);
        EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Welcome Letter Sent' Limit 1];
        
        Enquiry__c enquiry = new Enquiry__c();
        enquiry.Contact_Person__c = accountObject.Id;
        enquiry.Stage__c = 'New Enquiry';
        enquiry.Enquiry_Source__c = 'Google';
        insert enquiry;        
        
        Group grou = new Group();
        grou.Type = 'Queue';
        grou.Name = 'omni Channel';
        insert grou;
        
        Map<id,Task> oldMapIdToTask = new Map<id,Task>();
        List<Task> taskList = new List<Task>();
        Task tsk12 = new Task();
        tsk12.Subject = 'Review Welcome Call';
        tsk12.Status = 'Pending';
        tsk12.Priority = 'Normal';
        tsk12.WhatId = booking.Id;
        tsk12.OwnerId = testUserRcd1.Id;
        tsk12.ActivityDate = System.today();
        tsk12.Call_Status__c = 'Connected';
        tsk12.Call_Sub_status__c = 'Interested';
        tsk12.Description = 'hdgfyu';
        insert tsk12;
        oldMapIdToTask.get(tsk12.Id);    
        
        tsk12.Subject = 'SDR Letter for the Booking';
        tsk12.Status = 'Sent';
        update tsk12;
        taskList.add(tsk12);
        mapIdToBooking.containsKey(tsk12.whatId);
        
        TaskTriggerHandler.sendEmailToRMCRMSharedSDRLetter(taskList,oldMapIdToTask);
        Test.stopTest();
        
        
    }
    @isTest  
    public static void Method8(){
        BusinessHours bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];         
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
        accountObject.PersonMobilePhone = '4587856985';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.Email__c = 'noreply@salesforce.com.invalid';
        accountObject.CP_Name__c = 'abc';
        accountObject.RERA_Number__c = '23wertyu';
        accountObject.Rera_Certification__c = 'abhd';
        insert accountObject;
        
        Contact contact = [SELECT id, AccountId, Name from Contact WHERE AccountId =: accountObject.Id];
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = testUserRcd1.Id;
        projectObject.Site_Head__c = testUserRcd1.id;
        insert projectObject;
        
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Walk_in_Source__c = 'Presales';
        oppoObject.Project__c = projectObject.id;
        insert oppoObject;
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        insert pricingPlanObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Floor__c= '4';
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
        propertyAddOn.Project_Add_On__c = projectAddbject1.Id;
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
        
        Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c();
        planComponentObject1.Name = 'Stilt';
        planComponentObject1.GST_Treatment__c = 'Standard';
        planComponentObject1.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject1.Price_Lumpsum__c  = 200;
        planComponentObject1.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject1;
        
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.OwnerId = testUserRcd1.Id;
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
        priceDetailObject.Amount__c = 7800000;
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= 'Agreement';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = booking.Id;
        priceDetailObject1.Amount__c = 8200000;
        insert priceDetailObject1;
        
        System.debug('Agt AMt'+booking.Agreement_Value__c);
        
        Bank__c Bank = New Bank__c();
        Bank.Name = 'PNB Bank';
        insert Bank;
        
        Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
        BLD.Home_LoanInstitution__c = Bank.Id;
        BLD.Booking__c = booking.Id;
        Insert BLD;
        
        Task_Target__c tasktarget = new Task_Target__c();
        tasktarget.Month__c =System.now().format('MMMMM');
        tasktarget.User__c = testUserRcd1.Id;
        tasktarget.Year__c = String.valueof(System.today().year());
        tasktarget.Number_of_Targets_Achievement__c = null;
        tasktarget.X1st_Week__c = 0;
        tasktarget.X2nd_Week__c =null;
        tasktarget.X3rd_Week__c = null;
        tasktarget.X4th_Week__c = null;
        tasktarget.X5th_Week__c =null;
        tasktarget.Project__c = projectObject.Id;
        tasktarget.Number_of_Connected_Call__c = 0;
        tasktarget.No_of_Walk_ins__c = 0;
        tasktarget.No_of_Follow_Ups__c =0;
        tasktarget.Number_of_Targets__c = 100;
        tasktarget.Type__c = 'Unique Outbound';
        
        insert tasktarget;
        
        
        Test.startTest();
        Enquiry__c enquiry = new Enquiry__c();
        enquiry.Contact_Person__c = accountObject.Id;
        enquiry.Stage__c = 'New Enquiry';
        enquiry.Enquiry_Source__c = 'Google';
        insert enquiry;        
        
        Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,OwnerId,Unit_Number__c,Project_Name_Formulla__c From Booking__c where Id =: booking.Id]);
        
        Group grou = new Group();
        grou.Type = 'Queue';
        grou.Name = 'omni Channel';
        insert grou;
        
        
        Map<id,Task> oldMapIdToTask = new Map<id,Task>();
        List<Task> taskList = new List<Task>();
        Task tsk12 = new Task();
        tsk12.Subject = 'SDR Letter for the Booking';
        tsk12.Status = 'Pending';
        tsk12.Priority = 'Normal';
        tsk12.WhatId = booking.Id;
        tsk12.OwnerId = testUserRcd1.Id;
        tsk12.ActivityDate = System.today();
        tsk12.Call_Status__c = 'Connected';
        tsk12.Call_Sub_status__c = 'Interested';
        tsk12.Description = 'hdgfyu';
        insert tsk12;
        oldMapIdToTask.get(tsk12.Id);    
        
        tsk12.Subject = 'Generate Draft Agreement';
        tsk12.Status = 'Completed';
        update tsk12;
        taskList.add(tsk12);
        mapIdToBooking.containsKey(tsk12.whatId);
        
        TaskTriggerHandler.sendEmailWHenDraftAgreementComplete(taskList,oldMapIdToTask);
        TaskTriggerHandler.validationOnCompletionTask(taskList);
        Test.stopTest();
        
    }
    /* static testMethod void testUpdateReinitiatedDate() {

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
accountObject.PersonMobilePhone = '4587856985';
accountObject.Aadhar_No__pc = '458785698547';
accountObject.PAN_No__c = 'ABCTY1234D';
accountObject.Aadhar_Uploaded__pc = true;
accountObject.PAN_Card_Uploaded__pc = true;
accountObject.Email__c = 'noreply@salesforce.com.invalid';
accountObject.CP_Name__c = 'abc';
accountObject.RERA_Number__c = '23wertyu';
accountObject.Rera_Certification__c = 'abhd';
insert accountObject;

Contact contact = [SELECT id, AccountId, Name from Contact WHERE AccountId =: accountObject.Id];

Project__c projectObject = new Project__c();
projectObject.Name = 'Test Project';
projectObject.Project_Email__c= 'mayur.patel@manras.com';
projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
projectObject.Budgets__c = 'Under 75 lakhs';
projectObject.Configuration__c ='1 BHK';
projectObject.Project_Head__c = testUserRcd1.Id;
projectObject.Site_Head__c = testUserRcd1.id;
insert projectObject;


Opportunity oppoObject = new Opportunity();
oppoObject.AccountId = accountObject.Id;
oppoObject.Name = 'test Opportunity';
oppoObject.StageName = 'Site Visit';
oppoObject.CloseDate = System.Today()+3;
oppoObject.Walk_in_Source__c = 'Presales';
oppoObject.Project__c = projectObject.id;
insert oppoObject;
Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
pricingPlanObject.Name = 'Pricing Plan Test';
pricingPlanObject.Project__c = projectObject.Id;
insert pricingPlanObject;

Property__c propertyObject = new Property__c();
propertyObject.Name = 'test property';
propertyObject.Project__c = projectObject.Id;
propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
propertyObject.Floor__c= '4';
insert propertyObject;

Suggested_Property__c suggestedProperty = new Suggested_Property__c();
suggestedProperty.Opportunity__c = oppoObject.Id;
suggestedProperty.Unit__c = propertyObject.Id;
suggestedProperty.Discount__c = 10;
insert suggestedProperty;

List<Booking__c> BookingList = new List<Booking__c>();
Booking__c booking = new Booking__c();
booking.Primary_Applicant__c = accountObject.Id;
booking.Related_Opportunity__c = oppoObject.Id;
booking.Related_Suggested_Property__c = suggestedProperty.Id;
booking.Project_Name__c = projectObject.Id;
booking.OwnerId = testUserRcd1.Id;
booking.Primary_Applicant__c = accountObject.id;
booking.Reinitiated_Date__c = system.today();
insert booking;

Campaign testCampRcd=new Campaign();
testCampRcd.Name='test Campaign';
testCampRcd.Project__c=projectObject.Id;
testCampRcd.Source__c='Google';
testCampRcd.StartDate=System.today();
testCampRcd.EndDate=System.today()+15;
testCampRcd.ActualCost=2500000;
insert testCampRcd;

Test.startTest();
Enquiry__c testEnqRcd=new Enquiry__c();
testEnqRcd.Project__c=projectObject.Id;
testEnqRcd.Contact_Person__c=accountObject.Id;
testEnqRcd.Enquiry_Source__c='Google';
testEnqRcd.Campaign__c=testCampRcd.Id;
testEnqRcd.Country_Code__c='+91';
testEnqRcd.Primary_Mobile_Number__c='1234567890';
testEnqRcd.OwnerId=testUserRcd1.Id;
insert testEnqRcd;
List<Task> listOfExistingTasks = [Select Id,Subject,Status,whatId,CreatedById From task where Subject =: 'Welcome Call' AND WhatId =: booking.Id];

Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where isActive =: true]);

Contact Testcontact = new Contact();
Testcontact.LastName = 'Test contact';
insert Testcontact;

String CRMHeadUserName = Label.CRM_Head_User;
User CRMSiteHeadRoleUsers = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: [select id from UserRole where DeveloperName =: 'CRM_Head' limit 1].Id AND isActive =: true Limit 1];

Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,OwnerId,Unit_Number__c,Project_Name_Formulla__c From Booking__c WHERE ID =: booking.Id]);

Map<id,Task> oldMapIdToTask = new Map<id,Task>();
List<Task> taskList = new List<Task>();
Task tsk12 = new Task();
tsk12.Subject = 'SDR Letter for the Booking';
tsk12.Status = 'Pending';
tsk12.Priority = 'Normal';
tsk12.WhatId = booking.Id;
tsk12.OwnerId = testUserRcd1.Id;
tsk12.ActivityDate = System.today();
tsk12.Call_Status__c = 'Connected';
tsk12.Call_Sub_status__c = 'Interested';
tsk12.Description = 'hdgfyu';
insert tsk12;
oldMapIdToTask.get(tsk12.Id);    

tsk12.Subject = 'Generate Draft Agreement';
tsk12.Status = 'Re-initiated';
update tsk12;
taskList.add(tsk12);
mapIdToBooking.containsKey(tsk12.whatId);

BusinessHours bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];         
TaskTriggerHandler.updateReinitiatedDate(taskList, oldMapIdToTask);
Test.stopTest();
}*/
    @isTest  
    public static void Method9(){
        BusinessHours bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];         
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
        accountObject.PersonMobilePhone = '4587856985';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.Email__c = 'noreply@salesforce.com.invalid';
        accountObject.CP_Name__c = 'abc';
        accountObject.RERA_Number__c = '23wertyu';
        accountObject.Rera_Certification__c = 'abhd';
        insert accountObject;
        
        Contact contact = [SELECT id, AccountId, Name from Contact WHERE AccountId =: accountObject.Id];
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = testUserRcd1.Id;
        projectObject.Site_Head__c = testUserRcd1.id;
        insert projectObject;
        
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Walk_in_Source__c = 'Presales';
        oppoObject.Project__c = projectObject.id;
        insert oppoObject;
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        insert pricingPlanObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Floor__c= '4';
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
        propertyAddOn.Project_Add_On__c = projectAddbject1.Id;
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
        
        Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c();
        planComponentObject1.Name = 'Stilt';
        planComponentObject1.GST_Treatment__c = 'Standard';
        planComponentObject1.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject1.Price_Lumpsum__c  = 200;
        planComponentObject1.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject1;
        
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.OwnerId = testUserRcd1.Id;
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
        priceDetailObject.Amount__c = 7800000;
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= 'Agreement';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = booking.Id;
        priceDetailObject1.Amount__c = 8200000;
        insert priceDetailObject1;
        
        System.debug('Agt AMt'+booking.Agreement_Value__c);
        
        Bank__c Bank = New Bank__c();
        Bank.Name = 'PNB Bank';
        insert Bank;
        
        Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
        BLD.Home_LoanInstitution__c = Bank.Id;
        BLD.Booking__c = booking.Id;
        Insert BLD;
        
        Task_Target__c tasktarget = new Task_Target__c();
        tasktarget.Month__c =System.now().format('MMMMM');
        tasktarget.User__c = testUserRcd1.Id;
        tasktarget.Year__c = String.valueof(System.today().year());
        tasktarget.Number_of_Targets_Achievement__c = null;
        tasktarget.X1st_Week__c = 0;
        tasktarget.X2nd_Week__c =null;
        tasktarget.X3rd_Week__c = null;
        tasktarget.X4th_Week__c = null;
        tasktarget.X5th_Week__c =null;
        tasktarget.Project__c = projectObject.Id;
        tasktarget.Number_of_Connected_Call__c = 0;
        tasktarget.No_of_Walk_ins__c = 0;
        tasktarget.No_of_Follow_Ups__c =0;
        tasktarget.Number_of_Targets__c = 100;
        tasktarget.Type__c = 'Unique Outbound';
        
        insert tasktarget;
        
        
        Test.startTest();
        
        Enquiry__c enquiry = new Enquiry__c();
        enquiry.Contact_Person__c = accountObject.Id;
        enquiry.Stage__c = 'New Enquiry';
        enquiry.Enquiry_Source__c = 'Google';
        insert enquiry;        
        
        List<Enquiry__c> enquiryList = [SELECT id, Contact_Person__c, Stage__c, Project__c FROM Enquiry__c WHERE id =:enquiry.Id];
        
        Group grou = new Group();
        grou.Type = 'Queue';
        grou.Name = 'omni Channel';
        insert grou;
        
        List<Task> taskList = new List<Task>();
        Task tsk12 = new Task();
        tsk12.Subject = 'Welcome Call';
        tsk12.Status = 'Re-initiated';
        tsk12.Priority = 'Normal';
        tsk12.WhatId = enquiry.Id;
        tsk12.OwnerId = testUserRcd1.Id;
        tsk12.ActivityDate = System.today();
        tsk12.Call_Status__c = 'Connected';
        tsk12.Call_Sub_status__c = 'Call Back Later';
        tsk12.Description = 'hdgfyu';
        tsk12.Throw_Validation__c = false;
        tsk12.Exotel_CTI__Call_Direction__c = '43:20:11';
        insert tsk12;
        taskList.add(tsk12);
        
        TaskTriggerHandler.calculateTargetForConnectedCalls(taskList);
        TaskTriggerHandler.method();
        Test.stopTest();
        
    }
    @isTest  
    public static void Method10(){
        BusinessHours bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];         
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
        accountObject.PersonMobilePhone = '4587856985';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.Email__c = 'noreply@salesforce.com.invalid';
        accountObject.CP_Name__c = 'abc';
        accountObject.RERA_Number__c = '23wertyu';
        accountObject.Rera_Certification__c = 'abhd';
        insert accountObject;
        
        Contact contact = [SELECT id, AccountId, Name from Contact WHERE AccountId =: accountObject.Id];
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = testUserRcd1.Id;
        projectObject.Site_Head__c = testUserRcd1.id;
        insert projectObject;
        
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Walk_in_Source__c = 'Presales';
        oppoObject.Project__c = projectObject.id;
        insert oppoObject;
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        insert pricingPlanObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Floor__c= '4';
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
        propertyAddOn.Project_Add_On__c = projectAddbject1.Id;
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
        
        Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c();
        planComponentObject1.Name = 'Stilt';
        planComponentObject1.GST_Treatment__c = 'Standard';
        planComponentObject1.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject1.Price_Lumpsum__c  = 200;
        planComponentObject1.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject1;
        
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.OwnerId = testUserRcd1.Id;
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
        priceDetailObject.Amount__c = 7800000;
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= 'Agreement';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = booking.Id;
        priceDetailObject1.Amount__c = 8200000;
        insert priceDetailObject1;
        
        System.debug('Agt AMt'+booking.Agreement_Value__c);
        
        Bank__c Bank = New Bank__c();
        Bank.Name = 'PNB Bank';
        insert Bank;
        
        Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
        BLD.Home_LoanInstitution__c = Bank.Id;
        BLD.Booking__c = booking.Id;
        Insert BLD;
        
        Task_Target__c tasktarget = new Task_Target__c();
        tasktarget.Month__c =System.now().format('MMMMM');
        tasktarget.User__c = testUserRcd1.Id;
        tasktarget.Year__c = String.valueof(System.today().year());
        tasktarget.Number_of_Targets_Achievement__c = null;
        tasktarget.X1st_Week__c = 0;
        tasktarget.X2nd_Week__c =null;
        tasktarget.X3rd_Week__c = null;
        tasktarget.X4th_Week__c = null;
        tasktarget.X5th_Week__c =null;
        tasktarget.Project__c = projectObject.Id;
        tasktarget.Number_of_Connected_Call__c = 0;
        tasktarget.No_of_Walk_ins__c = 0;
        tasktarget.No_of_Follow_Ups__c =0;
        tasktarget.Number_of_Targets__c = 100;
        tasktarget.Type__c = 'Unique Outbound';
        
        insert tasktarget;
        
        
        Test.startTest();
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Welcome_Call_Letter_Task_Created' limit 1];
        CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
        System.debug('calc-------------->'+calc);
        Datetime  NextWorkingDays = calc.AddDays(System.now(),1);
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where Id =: testUserRcd1.Id]);
        EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Welcome Letter Sent' Limit 1];
        
        Enquiry__c enquiry = new Enquiry__c();
        enquiry.Contact_Person__c = accountObject.Id;
        enquiry.Stage__c = 'New Enquiry';
        enquiry.Enquiry_Source__c = 'Google';
        insert enquiry;        
        
        Group grou = new Group();
        grou.Type = 'Queue';
        grou.Name = 'omni Channel';
        insert grou;
        
        Map<id,Task> oldMapIdToTask = new Map<id,Task>();
        Task tsk1 = new Task();
        tsk1.Subject = 'Welcome Call';
        tsk1.Status = 'Pending';
        tsk1.Priority = 'Normal';
        tsk1.WhatId = enquiry.Id;
        tsk1.OwnerId = testUserRcd1.Id;
        tsk1.Call_Status__c = 'Connected';
        tsk1.Call_Sub_status__c = 'Call Back Later';
        tsk1.Description = 'hdgfyu';
        tsk1.Throw_Validation__c = true;
        tsk1.ActivityDate = System.today();
        insert tsk1;
        oldMapIdToTask.get(tsk1.Id);
        
        List<Task> taskList = new List<Task>();
        Task tsk12 = new Task();
        tsk12.Subject = 'Welcome Call';
        tsk12.Status = 'Re-initiated';
        tsk12.Priority = 'Normal';
        tsk12.WhatId = enquiry.Id;
        tsk12.OwnerId = testUserRcd1.Id;
        tsk12.ActivityDate = System.today();
        tsk12.Call_Status__c = 'Connected';
        tsk12.Call_Sub_status__c = 'Call Back Later';
        tsk12.Description = 'hdgfyu';
        tsk12.Throw_Validation__c = false;
        insert tsk12;
        taskList.add(tsk12);
        
        TaskTriggerHandler.ThrowValidationOnCompletionTask(taskList,oldMapIdToTask);
        Test.stopTest();
        
    }
    @isTest  
    public static void Method11(){
        BusinessHours bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];         
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
        accountObject.PersonMobilePhone = '4587856985';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.Email__c = 'noreply@salesforce.com.invalid';
        accountObject.CP_Name__c = 'abc';
        accountObject.RERA_Number__c = '23wertyu';
        accountObject.Rera_Certification__c = 'abhd';
        insert accountObject;
        
        Contact contact = [SELECT id, AccountId, Name from Contact WHERE AccountId =: accountObject.Id];
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = testUserRcd1.Id;
        projectObject.Site_Head__c = testUserRcd1.id;
        insert projectObject;
        
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Walk_in_Source__c = 'Presales';
        oppoObject.Project__c = projectObject.id;
        insert oppoObject;
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        insert pricingPlanObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Floor__c= '4';
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
        propertyAddOn.Project_Add_On__c = projectAddbject1.Id;
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
        
        Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c();
        planComponentObject1.Name = 'Stilt';
        planComponentObject1.GST_Treatment__c = 'Standard';
        planComponentObject1.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject1.Price_Lumpsum__c  = 200;
        planComponentObject1.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject1;
        
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.OwnerId = testUserRcd1.Id;
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
        priceDetailObject.Amount__c = 7800000;
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= 'Agreement';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = booking.Id;
        priceDetailObject1.Amount__c = 8200000;
        insert priceDetailObject1;
        
        System.debug('Agt AMt'+booking.Agreement_Value__c);
        
        Bank__c Bank = New Bank__c();
        Bank.Name = 'PNB Bank';
        insert Bank;
        
        Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
        BLD.Home_LoanInstitution__c = Bank.Id;
        BLD.Booking__c = booking.Id;
        Insert BLD;
        
        Task_Target__c tasktarget = new Task_Target__c();
        tasktarget.Month__c =System.now().format('MMMMM');
        tasktarget.User__c = testUserRcd1.Id;
        tasktarget.Year__c = String.valueof(System.today().year());
        tasktarget.Number_of_Targets_Achievement__c = null;
        tasktarget.X1st_Week__c = 0;
        tasktarget.X2nd_Week__c =null;
        tasktarget.X3rd_Week__c = null;
        tasktarget.X4th_Week__c = null;
        tasktarget.X5th_Week__c =null;
        tasktarget.Project__c = projectObject.Id;
        tasktarget.Number_of_Connected_Call__c = 0;
        tasktarget.No_of_Walk_ins__c = 0;
        tasktarget.No_of_Follow_Ups__c =0;
        tasktarget.Number_of_Targets__c = 100;
        tasktarget.Type__c = 'Unique Outbound';
        
        insert tasktarget;
        
        
        Test.startTest();        
        Enquiry__c enquiry = new Enquiry__c();
        enquiry.Contact_Person__c = accountObject.Id;
        enquiry.Stage__c = 'New Enquiry';
        enquiry.Enquiry_Source__c = 'Google';
        insert enquiry;
        
        Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,OwnerId,Unit_Number__c,Project_Name_Formulla__c From Booking__c WHERE ID =: booking.Id]);
        
        Group grou = new Group();
        grou.Type = 'Queue';
        grou.Name = 'omni Channel';
        insert grou;
        
        Map<id,Task> oldMapIdToTask = new Map<id,Task>();
        List<Task> taskList = new List<Task>();
        Task tsk12 = new Task();
        tsk12.Subject = 'SDR Letter for the Booking';
        tsk12.Status = 'Pending';
        tsk12.Priority = 'Normal';
        tsk12.WhatId = booking.Id;
        tsk12.OwnerId = testUserRcd1.Id;
        tsk12.ActivityDate = System.today();
        tsk12.Call_Status__c = 'Connected';
        tsk12.Call_Sub_status__c = 'Interested';
        tsk12.Description = 'hdgfyu';
        insert tsk12;
        oldMapIdToTask.get(tsk12.Id);    
        
        tsk12.Subject = 'Welcome Call';
        tsk12.Status = 'Re-open';
        update tsk12;
        taskList.add(tsk12);
        mapIdToBooking.containsKey(tsk12.whatId);
        
        TaskTriggerHandler.updateStatusAndSendEmailToRM(taskList,oldMapIdToTask);
        Test.stopTest();
        
    }
    @isTest  
    public static void Method12(){
        BusinessHours bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];         
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
        accountObject.PersonMobilePhone = '4587856985';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.Email__c = 'noreply@salesforce.com.invalid';
        accountObject.CP_Name__c = 'abc';
        accountObject.RERA_Number__c = '23wertyu';
        accountObject.Rera_Certification__c = 'abhd';
        insert accountObject;
        
        Contact contact = [SELECT id, AccountId, Name from Contact WHERE AccountId =: accountObject.Id];
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = testUserRcd1.Id;
        projectObject.Site_Head__c = testUserRcd1.id;
        insert projectObject;
        
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Walk_in_Source__c = 'Presales';
        oppoObject.Project__c = projectObject.id;
        insert oppoObject;
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        insert pricingPlanObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Floor__c= '4';
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
        propertyAddOn.Project_Add_On__c = projectAddbject1.Id;
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
        
        Pricing_Plan_Components__c planComponentObject1 = new Pricing_Plan_Components__c();
        planComponentObject1.Name = 'Stilt';
        planComponentObject1.GST_Treatment__c = 'Standard';
        planComponentObject1.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject1.Price_Lumpsum__c  = 200;
        planComponentObject1.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject1;
        
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.OwnerId = testUserRcd1.Id;
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
        priceDetailObject.Amount__c = 7800000;
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= 'Agreement';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = booking.Id;
        priceDetailObject1.Amount__c = 8200000;
        insert priceDetailObject1;
        
        System.debug('Agt AMt'+booking.Agreement_Value__c);
        
        Bank__c Bank = New Bank__c();
        Bank.Name = 'PNB Bank';
        insert Bank;
        
        Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
        BLD.Home_LoanInstitution__c = Bank.Id;
        BLD.Booking__c = booking.Id;
        Insert BLD;
        
        Task_Target__c tasktarget = new Task_Target__c();
        tasktarget.Month__c =System.now().format('MMMMM');
        tasktarget.User__c = testUserRcd1.Id;
        tasktarget.Year__c = String.valueof(System.today().year());
        tasktarget.Number_of_Targets_Achievement__c = null;
        tasktarget.X1st_Week__c = 0;
        tasktarget.X2nd_Week__c =null;
        tasktarget.X3rd_Week__c = null;
        tasktarget.X4th_Week__c = null;
        tasktarget.X5th_Week__c =null;
        tasktarget.Project__c = projectObject.Id;
        tasktarget.Number_of_Connected_Call__c = 0;
        tasktarget.No_of_Walk_ins__c = 0;
        tasktarget.No_of_Follow_Ups__c =0;
        tasktarget.Number_of_Targets__c = 100;
        tasktarget.Type__c = 'Unique Outbound';
        
        insert tasktarget;
        
        
        Test.startTest();        
        Enquiry__c enquiry = new Enquiry__c();
        enquiry.Contact_Person__c = accountObject.Id;
        enquiry.Stage__c = 'New Enquiry';
        enquiry.Enquiry_Source__c = 'Google';
        insert enquiry;
        
        List<Enquiry__c> enquiryList = [SELECT id, Contact_Person__c, Stage__c FROM Enquiry__c WHERE id =:enquiry.Id];
        List<Opportunity> opportunityList = [SELECT Id, StageName FROM Opportunity WHERE Id =:oppoObject.Id];
        
        Group grou = new Group();
        grou.Type = 'Queue';
        grou.Name = 'omni Channel';
        insert grou;
        
        Map<id,Task> oldMapIdToTask = new Map<id,Task>();
        List<Task> taskList = new List<Task>();
        Task tsk12 = new Task();
        tsk12.Subject = 'SDR Letter for the Booking';
        tsk12.Status = 'Pending';
        tsk12.Priority = 'Normal';
        tsk12.WhatId = oppoObject.Id;
        tsk12.OwnerId = testUserRcd1.Id;
        tsk12.ActivityDate = System.today();
        tsk12.Call_Status__c = 'Connected';
        tsk12.Call_Sub_status__c = 'Interested';
        tsk12.Description = 'hdgfyu';
        insert tsk12;
        oldMapIdToTask.get(tsk12.Id);    
        
        tsk12.Subject = 'Welcome Call';
        tsk12.Status = 'Re-open';
        update tsk12;
        taskList.add(tsk12);
        
        TaskTriggerHandler.updateLastCallDetails(taskList);
        Test.stopTest();
        
    }
    Public class CalloutMock implements HttpCalloutMock{
        Public HttpResponse respond(HttpRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type','application/json');
            res.setBody('{"Animals":["Horse","Dog","Tiger","Lion","Cat","Mouse"]}');
            res.setStatusCode(200);
            return res;
        }
        
    }
    
}