@istest
public class AccountTriggerHandlerTest {
    
    @isTest  
    public static void Method3(){
        
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
            List <Account> accList = New List <Account> ();
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account3';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '4555465654';
            accountObject.PersonMobilePhone = '4555465612';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamt.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.RERA_Number__c = 'wre546';
            accountObject.PAN_Card_Uploaded__pc = true;
            insert accountObject;
            accList.add(accountObject);
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            insert projectObject;
            List <Opportunity> OppList = New List <Opportunity>();
            Opportunity oppoObject = new Opportunity();
            oppoObject.AccountId = accountObject.Id;
            oppoObject.Name = 'test Opportunity';
            oppoObject.StageName = 'Site Visit';
            oppoObject.CloseDate = System.Today()+3;
            oppoObject.Walk_in_Source__c = 'Presales';
            oppoObject.Project__c = projectObject.id;
            insert oppoObject;
            OppList.add(oppoObject);
            
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
            
            Property__c propertyObject1 = new Property__c();
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
            insert propertyObject3;
            
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
            
            Pricing_Plan_Components__c planComponentObject2 = new Pricing_Plan_Components__c();
            planComponentObject2.Name = 'Stamp Charges';
            planComponentObject2.GST_Treatment__c = 'Standard';
            planComponentObject2.Project_Add_On_Charges__c = projectAddbject2.Id;
            planComponentObject2.Price_Lumpsum__c  = 200;
            planComponentObject2.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
            insert planComponentObject2;
            
            Pricing_Plan_Components__c planComponentObject3 = new Pricing_Plan_Components__c();
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
            Test.startTest();
            
            List<Task> TaskList = new List <Task>();
            Task tsk = new Task();
            tsk.Subject = 'Draft Agreement';
            tsk.Status = 'Re-initiated';
            tsk.Priority = 'Normal';
            tsk.WhatId = booking.Id;
            tsk.OwnerId = testUserRcd1.Id;
            insert tsk;
            TaskList.add(tsk);
            AccountTriggerHandler.updateBookingDraftTaskStatus(accList);
            Test.stopTest();
            
            /*  Account acc = [Select Id,RERA_Number__c From Account limit 1];
acc.RERA_Number__c = 'abc';
update acc;*/
        }
    }
    
    @isTest  
    public static void Method31(){
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
            
            List <Account> accList = New List <Account> ();
            Account accountObject = new Account();
            accountObject.FirstName = 'Abhishree';
            accountObject.LastName = 'Akolkar';
            accountObject.BillingCountry = 'India';
            //accountObject.PersonMobilePhone = '909012345';
            accountObject.RecordTypeId = PersonRecId;
            accList.add(accountObject);
            try{
                insert accountObject;
            }
            catch(Exception ex)
            {
            }
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Rera_Number_Update_Notification' LIMIT 1];
                        Test.startTest();

            Contact contact = new Contact();
            contact.FirstName = 'Abc';
            contact.LastName = 'edf';
            insert contact;
              AccountTriggerHandler.insertContacts(accList);
            Test.stopTest();
            
            
        }
    }
     
    @isTest  
    public static void Method32(){
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
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
            
            List <Account> accList = New List <Account> ();
            Account accountObject = new Account();
            accountObject.FirstName = 'Abhishree';
            accountObject.LastName = 'Akolkar';
            accountObject.BillingCountry = 'India';
            //accountObject.PersonMobilePhone = '909012345';
            accountObject.CP_Name__c = 'Test';
            accountObject.RecordTypeId = PersonRecId;
            accList.add(accountObject);
            try{
                insert accountObject;
            }
            catch(Exception ex)
            {
            }
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Rera_Number_Update_Notification' LIMIT 1];
                        Test.startTest();

            Contact contact = new Contact();
            contact.FirstName = 'Abc';
            contact.LastName = accountObject.CP_Name__c;
            insert contact;
              AccountTriggerHandler.insertContacts(accList);
            Test.stopTest();
            
            
        }
    }
    @isTest
    static void testStageValidationWithCompleteData() {
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account completeAccount = new Account(
            FirstName = 'Test',
            LastName = 'Demo',
            RecordTypeId = PersonRecId,
            Rera_Certificate_Upload__c = false,
            CP_Empanelment_Stages__c = 'Registered',
            PersonMobilePhone = '7878656564'
        );
        try{
            insert completeAccount;
        }
        catch(Exception ex)
        {
        }
        List<Account> accountsToValidate = new List<Account>{ completeAccount };
            accountsToValidate.add(completeAccount);
        
        Test.startTest();
        AccountTriggerHandler.stagevalidation(accountsToValidate);
        Test.stopTest();
    }
    @isTest
    static void testUpdateRegistrationWithCompleteData() {
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account completeAccount = new Account(
            FirstName = 'Test',
            LastName = 'Demo',
            RecordTypeId = PersonRecId,
            Rera_Certificate_Upload__c = true,
            RERA_Number__c = '64566345346q',
            PersonEmail = 'dynamt.project@gmail.com',
            Phone = '4555465654',
            CP_Empanelment_Stages__c = 'Registered',
            PersonMobilePhone = '7878656564'
        );
        try{
            insert completeAccount;
        }
        catch(Exception ex)
        {
        }
        List<Account> accountsToUpdate = new List<Account>{ completeAccount };
            accountsToUpdate.add(completeAccount);
        
        Test.startTest();
        AccountTriggerHandler.updateRegistration(accountsToUpdate);
        Test.stopTest();
        
        List<Account> updatedAccounts = [SELECT CP_Empanelment_Stages__c FROM Account WHERE Id = :completeAccount.Id];
    }
    
    @isTest
    static void testUpdateRegistrationWithIncompleteData() {
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account incompleteAccount = new Account(
            FirstName = 'Test',
            LastName = 'Demo',
            RecordTypeId = PersonRecId,
            Rera_Certificate_Upload__c = true,
            PersonMobilePhone = '7878656564'
            
        );
        try{
            insert incompleteAccount;
        }
        catch(Exception ex)
        {
        }
        List<Account> accountsToUpdate = new List<Account>{ incompleteAccount };
            
            Test.startTest();
        AccountTriggerHandler.updateRegistration(accountsToUpdate);
        Test.stopTest();
        
        List<Account> updatedAccounts = [SELECT CP_Empanelment_Stages__c FROM Account WHERE Id = :incompleteAccount.Id];
        updatedAccounts.add(incompleteAccount);
        
    }
    @isTest
    static void testInsertContactsForChannelPartnerAccount() {
        Id channelPartnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        
        Account channelPartnerAccount = new Account(
            RecordTypeId = channelPartnerRecordTypeId,
            CP_Name__c = 'John Doe',
            CP_Number__c = '1234567890',
            FirstName = 'Test',
            LastName = 'Demo',
            Rera_Certificate_Upload__c = true,
            PersonMobilePhone = '7878656564'
            // Set other required fields as needed
        );
        try{
            insert channelPartnerAccount;
        }
        catch(Exception ex)
        {
        }
        
        List<Account> accountsToProcess = new List<Account>{ channelPartnerAccount };
            
            Test.startTest();
        AccountTriggerHandler.insertContacts(accountsToProcess);
        Test.stopTest();
        
        List<Contact> contactsCreated = [SELECT Id FROM Contact WHERE AccountId = :channelPartnerAccount.Id];
    }
    
    @isTest
    static void testInsertContactsForNonChannelPartnerAccount() {
        Id channelPartnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account nonChannelPartnerAccount = new Account(
            CP_Name__c = 'Jane Doe',
            CP_Number__c = '9876543210',
            FirstName = 'Test',
            LastName = 'Demo',
            RecordTypeId = channelPartnerRecordTypeId,
            Rera_Certificate_Upload__c = true,
            PersonMobilePhone = '7878656564'
        );
        try{
            insert nonChannelPartnerAccount;
        }
        catch(Exception ex)
        {
        }
        
        List<Account> accountsToProcess = new List<Account>{ nonChannelPartnerAccount };
            
            Test.startTest();
        AccountTriggerHandler.insertContacts(accountsToProcess);
        Test.stopTest();
        
        List<Contact> contactsCreated = [SELECT Id FROM Contact WHERE AccountId = :nonChannelPartnerAccount.Id];
    }
     @isTest  
    public static void duplicateAccountAndAddMandatory(){
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
                        Id cpRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();

            
            List <Account> accList = New List <Account> ();
            Account accountObject = new Account();
            accountObject.FirstName = 'Abhishree';
            accountObject.LastName = 'Akolkar';
            accountObject.BillingCountry = 'India';
            //accountObject.PersonMobilePhone = '909012345';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.CP_Name__c = 'Test';
            accList.add(accountObject);
            
             Account accountObject1 = new Account();
           // accountObject1.FirstName = 'Abhishree';
            accountObject1.LastName = 'Akolkar';
            accountObject1.BillingCountry = 'India';
            //accountObject.PersonMobilePhone = '909012345';
            accountObject1.RecordTypeId = cpRecId;
            accountObject1.CP_Name__c = 'Test';
            try{
                insert accountObject;
            }
            catch(Exception ex)
            {
            }
             try{
                insert accountObject1;
            }
            catch(Exception ex)
            {
            }
                        accList.add(accountObject);
                         accList.add(accountObject1);


            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Rera_Number_Update_Notification' LIMIT 1];
                        Test.startTest();

            Contact contact = new Contact();
            contact.FirstName = 'Abc';
            contact.LastName = 'edf';
            insert contact;
              AccountTriggerHandler.duplicateAccountAndAddMandatory(accList);
            Test.stopTest();
            
            
        }
    }
      @isTest  
    public static void duplicateAccountAndAddMandatory1(){
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
                     List <Account> accList = New List <Account> ();

             Account accountObject1 = new Account();
           // accountObject1.FirstName = 'Abhishree';
            accountObject1.LastName = 'Akolkar';
            accountObject1.BillingCountry = 'India';
            //accountObject.PersonMobilePhone = '909012345';
            accountObject1.RecordTypeId = PersonRecId;
            accountObject1.CP_Name__c = 'Test';
           
             try{
                insert accountObject1;
            }
            catch(Exception ex)
            {
            }
                         accList.add(accountObject1);
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Rera_Number_Update_Notification' LIMIT 1];
                        Test.startTest();

            Contact contact = new Contact();
            contact.FirstName = 'Abc';
            contact.LastName = 'edf';
            insert contact;
              AccountTriggerHandler.duplicateAccountAndAddMandatory(accList);
            //AccountTriggerHandler.method();
            Test.stopTest();
            
         }
    }
     @isTest
    static void teststagevalidationForChannelPartnerAccount() {
        Id channelPartnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        
        Account channelPartnerAccount = new Account();
        channelPartnerAccount.Name = 'Channel Firm';
        channelPartnerAccount.RecordTypeId = channelPartnerRecordTypeId;
        channelPartnerAccount.CP_Name__c = null;
        channelPartnerAccount.CP_Number__c = '1234567890';
        channelPartnerAccount.Firm_Type__c = null;
        channelPartnerAccount.Rera_Certificate_Upload__c = false;
        channelPartnerAccount.CP_Firm_Name__c = null;
        channelPartnerAccount.Phone = null;
        channelPartnerAccount.RERA_Number__c = null;
        channelPartnerAccount.Email__c =null;
        channelPartnerAccount.Rera_Expiry_Date__c = null;
        insert channelPartnerAccount;
        
        channelPartnerAccount.CP_Name__c = '';
        channelPartnerAccount.CP_Firm_Name__c = '';
        channelPartnerAccount.Phone = '';
        channelPartnerAccount.Firm_Type__c = '';
        channelPartnerAccount.RERA_Number__c = '';
        channelPartnerAccount.Email__c ='';
        update channelPartnerAccount;
        
        List<Account> accountsToProcess = new List<Account>{ channelPartnerAccount };
            
        Test.startTest();
        AccountTriggerHandler.stagevalidation(accountsToProcess);
        Test.stopTest();
        
        List<Contact> contactsCreated = [SELECT Id FROM Contact WHERE AccountId = :channelPartnerAccount.Id];
    }
}