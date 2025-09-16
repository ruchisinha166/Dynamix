@isTest 
public class ContentDocumentTriggerHandler_Test {
    
    @testSetup static void setup() {
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
        
        System.runAs(testUserRcd1){
            
            
            
            Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
            Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
            Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Id ChannelPrtnerRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '4555465655';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.PersonMobilePhone = '2342647892';
            insert accountObject;
            
            Account accountCP = new Account();
            accountCP.Name = 'test CP';
            accountCP.Email__c = 'dynamix.project@gmail.com';
            accountCP.Firm_Type__c = 'Firm';
            accountCP.Phone = '4555465655';
            accountCP.RecordTypeId = ChannelPrtnerRecId;
            insert accountCP;
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'nishi@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            insert projectObject;
            
            Opportunity oppoObject = new Opportunity();
            oppoObject.AccountId = accountObject.Id;
            oppoObject.Name = 'test Opportunity';
            oppoObject.StageName = 'Site Visit';
            oppoObject.CloseDate = System.Today()+3;
            oppoObject.Project__c = projectObject.Id;
            oppoObject.Walk_in_Source__c = 'Direct';
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
            booking.Channel_Partner__c = accountCP.Id;
            Test.startTest();
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
            
            
            Task tsk5 = new Task();
            tsk5.Subject = 'SDR Letter for the Booking';
            tsk5.Status = 'Pending';
            tsk5.Priority = 'Normal';
            tsk5.WhatId = booking.Id;
            tsk5.OwnerId = testUserRcd1.Id;
            
            insert tsk5;
            Test.stopTest();
            
            
            Attachment attach1=new Attachment();   	
            attach1.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach1.body=bodyBlob;
            attach1.parentId=booking.id;
            attach1.OwnerId = testUserRcd1.Id;
            insert attach1;
            
            Attachment attach =[select id, name,OwnerId,Body,ParentId from Attachment where parent.id=:booking.id];
            
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; 
            cVersion.PathOnClient = attach.Name;
            cVersion.Origin = 'H';
            cVersion.OwnerId = attach.OwnerId;
            cVersion.Title = attach.Name;
            cVersion.VersionData = attach.Body;
            cVersion.Document_Type__c = 'SDR Challan Copy';
            cVersion.SObjectType__c = 'Booking__c';
            cVersion.BookingId__c = booking.Id;
            Insert cVersion;
            
            ContentVersion cVersion1 = new ContentVersion();
            cVersion1.ContentLocation = 'S'; 
            cVersion1.PathOnClient = attach.Name;
            cVersion1.Origin = 'H';
            cVersion1.OwnerId = attach.OwnerId;
            cVersion1.Title = attach.Name;
            cVersion1.VersionData = attach.Body;
            cVersion1.Document_Type__c = 'Bank Approved NOC';
            cVersion1.SObjectType__c = 'Booking__c';
            cVersion1.BookingId__c = booking.Id;
            Insert cVersion1;
            
            ContentVersion cVersion2 = new ContentVersion();
            cVersion2.ContentLocation = 'S'; 
            cVersion2.PathOnClient = attach.Name;
            cVersion2.Origin = 'H';
            cVersion2.OwnerId = attach.OwnerId;
            cVersion2.Title = attach.Name;
            cVersion2.VersionData = attach.Body;
            cVersion2.Document_Type__c = 'Bank Approved ROC';
            cVersion2.SObjectType__c = 'Booking__c';
            cVersion2.BookingId__c = booking.Id;
            Insert cVersion2;
            
            ContentVersion cVersion3 = new ContentVersion();
            cVersion3.ContentLocation = 'S'; 
            cVersion3.PathOnClient = attach.Name;
            cVersion3.Origin = 'H';
            cVersion3.OwnerId = attach.OwnerId;
            cVersion3.Title = attach.Name;
            cVersion3.VersionData = attach.Body;
            cVersion3.Document_Type__c = 'Aadhar';
            cVersion3.SObjectType__c = 'Booking__c';
            cVersion3.BookingId__c = booking.Id;
            Insert cVersion3;
            
            ContentVersion cVersion4 = new ContentVersion();
            cVersion4.ContentLocation = 'S'; 
            cVersion4.PathOnClient = attach.Name;
            cVersion4.Origin = 'H';
            cVersion4.OwnerId = attach.OwnerId;
            cVersion4.Title = attach.Name;
            cVersion4.VersionData = attach.Body;
            cVersion4.Document_Type__c = 'PAN Card';
            cVersion4.SObjectType__c = 'Booking__c';
            cVersion4.BookingId__c = booking.Id;
            Insert cVersion4;
            
            ContentVersion cVersion5 = new ContentVersion();
            cVersion5.ContentLocation = 'S'; 
            cVersion5.PathOnClient = attach.Name;
            cVersion5.Origin = 'H';
            cVersion5.OwnerId = attach.OwnerId;
            cVersion5.Title = attach.Name;
            cVersion5.VersionData = attach.Body;
            cVersion5.Document_Type__c = 'Sanction Letter';
            cVersion5.SObjectType__c = 'Bank_Loan_Details__c';
            cVersion5.BookingId__c = BLD.Id;
            Insert cVersion5;
            
            ContentVersion cVersion6 = new ContentVersion();
            cVersion6.ContentLocation = 'S'; 
            cVersion6.PathOnClient = attach.Name;
            cVersion6.Origin = 'H';
            cVersion6.OwnerId = attach.OwnerId;
            cVersion6.Title = attach.Name;
            cVersion6.VersionData = attach.Body;
            cVersion6.Document_Type__c = 'Sanction Letter';
            cVersion6.SObjectType__c = 'Bank_Loan_Details__c';
            cVersion6.BookingId__c = BLD.Id;
            Insert cVersion6;
            
            ContentVersion cVersion7 = new ContentVersion();
            cVersion7.ContentLocation = 'S'; 
            cVersion7.PathOnClient = attach.Name;
            cVersion7.Origin = 'H';
            cVersion7.OwnerId = attach.OwnerId;
            cVersion7.Title = attach.Name;
            cVersion7.VersionData = attach.Body;
            cVersion7.Document_Type__c = 'Sanction Letter';
            cVersion7.SObjectType__c = 'Bank_Loan_Details__c';
            cVersion7.BookingId__c = BLD.Id;
            Insert cVersion7;
            
            CustomNotificationType notifyObj = [Select Id,CustomNotifTypeName from CustomNotificationType Where DeveloperName =: 'Notification_To_RM' limit 1];

            
            System.debug('cVersion'+cVersion.Id);
            Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
            System.debug('booking.Id'+booking.Id);
            System.debug('conDocId'+conDocId);
            
        }
    }
    
    @isTest  
    public static void Method1(){
        
        Test.startTest();
        ContentVersion cVersion1 = [Select ID,BookingId__c From ContentVersion Where Document_Type__c = 'SDR Challan Copy' limit 1];
        Booking__c book = [Select Id,Name From Booking__c limit 1];
        cVersion1.BookingId__c = book.Id;
        update cVersion1;
        Test.stopTest();
    }
    @isTest  
    public static void Method2(){
        
        Test.startTest();
        ContentVersion cVersion1 = [Select ID,BookingId__c From ContentVersion Where Document_Type__c = 'Bank Approved NOC' limit 1];
        Booking__c book = [Select Id,Name From Booking__c limit 1];
        cVersion1.BookingId__c = book.Id;
        update cVersion1;
        Test.stopTest();
    }
    
    @isTest  
    public static void Method3(){
        
        Test.startTest();
        ContentVersion cVersion1 = [Select ID,BookingId__c From ContentVersion Where Document_Type__c = 'Bank Approved ROC' limit 1];
        Booking__c book = [Select Id,Name From Booking__c limit 1];
        cVersion1.BookingId__c = book.Id;
        update cVersion1;
        Test.stopTest();
    }
    
    @isTest  
    public static void Method4(){
        
        Test.startTest();
        ContentVersion cVersion1 = [Select ID,BookingId__c From ContentVersion Where Document_Type__c = 'PAN Card' limit 1];
        Booking__c book = [Select Id,Name From Booking__c limit 1];
        cVersion1.BookingId__c = book.Id;
        update cVersion1;
        Test.stopTest();
    }
    @isTest  
    public static void Method5(){
        
        Test.startTest();
        ContentVersion cVersion1 = [Select ID,BookingId__c From ContentVersion Where Document_Type__c = 'Aadhar' limit 1];
        Booking__c book = [Select Id,Name From Booking__c limit 1];
        cVersion1.BookingId__c = book.Id;
        update cVersion1;
        Test.stopTest();
    }
    
    @isTest  
    public static void Method6(){        
        Test.startTest();
        ContentVersion cVersion1 = [Select ID,BookingId__c From ContentVersion Where Document_Type__c = 'Sanction Letter' limit 1];
        Bank_Loan_Details__c bld = [Select Id,Name From Bank_Loan_Details__c limit 1];
        cVersion1.BookingId__c = bld.Id;
        update cVersion1;
        Test.stopTest();
    }
    @isTest  
    public static void Method7(){        
        Test.startTest();
        ContentVersion cVersion1 = [Select ID,BookingId__c From ContentVersion Where Document_Type__c = 'Sanction Letter' limit 1];
        Bank_Loan_Details__c bld = [Select Id,Name From Bank_Loan_Details__c limit 1];
        cVersion1.BookingId__c = bld.Id;
        update cVersion1;
        Test.stopTest();
    }
    @isTest  
    public static void Method8(){       
        Test.startTest();
        ContentVersion cVersion1 = [Select ID,BookingId__c From ContentVersion Where Document_Type__c = 'Sanction Letter' limit 1];
        Bank_Loan_Details__c bld = [Select Id,Name From Bank_Loan_Details__c limit 1];
        cVersion1.BookingId__c = bld.Id;
        update cVersion1;
        Test.stopTest();
    }
}

//Previous

/*
@isTest 
public class ContentDocumentTriggerHandler_Test {
    
    @testSetup static void setup() {
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
        
        System.runAs(testUserRcd1){
            
            Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
            Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
            Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            List <account> accountList = new List<account>();
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
            accountObject.PersonMobilePhone = '8787567467';
            accountObject.Rera_Certificate_Upload__c =  true;
            //acc.id = ContentDocumentLinkObj.FirstPublishLocationId;
            accountList.add(accountObject);
            insert accountObject;
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'nishi@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            insert projectObject;
            
            Opportunity oppoObject = new Opportunity();
            oppoObject.AccountId = accountObject.Id;
            oppoObject.Name = 'test Opportunity';
            oppoObject.StageName = 'Site Visit';
            oppoObject.CloseDate = System.Today()+3;
            oppoObject.Project__c = projectObject.Id;
            oppoObject.Interested_Configuration__c = '1 BHK';
            oppoObject.Sales_Manager__c = testUserRcd1.id;
            oppoObject.Project__c = projectObject.Id;
            oppoObject.Walk_in_Source__c = 'Radio';
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
            
            
            Task tsk5 = new Task();
            tsk5.Subject = 'SDR Letter for the Booking';
            tsk5.Status = 'Pending';
            tsk5.Priority = 'Normal';
            tsk5.WhatId = booking.Id;
            tsk5.OwnerId = testUserRcd1.Id;
            tsk5.ActivityDate = Date.today();
            insert tsk5;
            
            
            Attachment attach1=new Attachment();   	
            attach1.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach1.body=bodyBlob;
            attach1.parentId=booking.id;
            attach1.OwnerId = testUserRcd1.Id;
            insert attach1;
            
            Attachment attach =[select id, name,OwnerId,Body,ParentId from Attachment where parent.id=:booking.id];
            
            List<ContentVersion> ContentVersionList = new List<ContentVersion>();
            ContentVersion cVersion3 = new ContentVersion();
            cVersion3.ContentLocation = 'S'; 
            cVersion3.PathOnClient = attach.Name;
            cVersion3.Origin = 'H';
            cVersion3.OwnerId = attach.OwnerId;
            cVersion3.Title = attach.Name;
            cVersion3.VersionData = attach.Body;
            cVersion3.Document_Type__c = 'Aadhar';
            cVersion3.SObjectType__c = 'Booking__c';
            cVersion3.BookingId__c = booking.Id;
            Insert cVersion3;
            ContentVersionList.add(cVersion3); 
            
            ContentVersion cVersion4 = new ContentVersion();
            cVersion4.ContentLocation = 'S'; 
            cVersion4.PathOnClient = attach.Name;
            cVersion4.Origin = 'H';
            cVersion4.OwnerId = attach.OwnerId;
            cVersion4.Title = attach.Name;
            cVersion4.VersionData = attach.Body;
            cVersion4.Document_Type__c = 'PAN Card';
            cVersion4.SObjectType__c = 'Booking__c';
            cVersion4.BookingId__c = booking.Id;
            Insert cVersion4;
            ContentVersionList.add(cVersion4); 
            
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; 
            cVersion.PathOnClient = attach.Name;
            cVersion.Origin = 'H';
            cVersion.OwnerId = attach.OwnerId;
            cVersion.Title = attach.Name;
            cVersion.VersionData = attach.Body;
            cVersion.Document_Type__c = 'SDR Challan Copy';
            cVersion.SObjectType__c = 'Booking__c';
            cVersion.BookingId__c = booking.Id;
            Insert cVersion;
            ContentVersionList.add(cVersion); 
            
            ContentVersion cVersion1 = new ContentVersion();
            cVersion1.ContentLocation = 'S'; 
            cVersion1.PathOnClient = attach.Name;
            cVersion1.Origin = 'H';
            cVersion1.OwnerId = attach.OwnerId;
            cVersion1.Title = attach.Name;
            cVersion1.VersionData = attach.Body;
            cVersion1.Document_Type__c = 'Bank Approved NOC';
            cVersion1.SObjectType__c = 'Booking__c';
            cVersion1.BookingId__c = booking.Id;
            Insert cVersion1;
            ContentVersionList.add(cVersion1); 
            
            ContentVersion cVersion2 = new ContentVersion();
            cVersion2.ContentLocation = 'S'; 
            cVersion2.PathOnClient = attach.Name;
            cVersion2.Origin = 'H';
            cVersion2.OwnerId = attach.OwnerId;
            cVersion2.Title = attach.Name;
            cVersion2.VersionData = attach.Body;
            cVersion2.Document_Type__c = 'Bank Approved ROC';
            cVersion2.SObjectType__c = 'Booking__c';
            cVersion2.BookingId__c = booking.Id;
            Insert cVersion2;
            ContentVersionList.add(cVersion2); 
            
            
            System.debug('cVersion'+cVersion.Id);
            Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
            System.debug('booking.Id'+booking.Id);
            System.debug('conDocId'+conDocId);
            
        }
    }
  
    @isTest  
    public static void Method4(){
        
        Test.startTest();
        ContentVersion cVersion1 = [Select ID,BookingId__c From ContentVersion Where Document_Type__c = 'PAN Card' limit 1];
        ContentVersion cVersion2 = [Select ID,BookingId__c From ContentVersion Where Document_Type__c = 'Aadhar' limit 1];
        Booking__c book = [Select Id,Name From Booking__c limit 1];
        Booking__c book1 = [Select Id,Name From Booking__c limit 1];
        Book1.Aadhar__c = True;
        update Book;
        cVersion1.BookingId__c = book.Id;
        update cVersion1;
        cVersion2.BookingId__c = book1.Id;
        update cVersion2;
        Test.stopTest();
    }
    @isTest  
    public static void Method5(){
        // Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String CRMHeadUserName = Label.CRM_Head_User;
        Test.startTest();
        
        User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: [select id from UserRole where DeveloperName =: 'CRM_Head' limit 1].Id AND isActive =: true Limit 1];
        List<String> addresses = new List<String>();
        addresses.add(CRMHeadRoleObjUser.Email); 
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = CRMHeadRoleObjUser.Email;
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.UserRoleId = UserInfo.getUserRoleId();
        testUserRcd1.ProfileId =  UserInfo.getProfileId();
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1){
            
            Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
            Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
            Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            List <account> accountList = new List<account>();
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '9896887676';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.PersonMobilePhone = '9896887676';
            accountObject.Rera_Certificate_Upload__c =  true;
            insert accountObject;
            accountList.add(accountObject);
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'nishi@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            insert projectObject;
            
            Opportunity oppoObject = new Opportunity();
            oppoObject.AccountId = accountObject.Id;
            oppoObject.Name = 'test Opportunity';
            oppoObject.StageName = 'Site Visit';
            oppoObject.CloseDate = System.Today()+3;
            oppoObject.Project__c = projectObject.Id;
            oppoObject.Interested_Configuration__c = '1 BHK';
            oppoObject.Sales_Manager__c = testUserRcd1.id;
            oppoObject.Project__c = projectObject.Id;
            oppoObject.Walk_in_Source__c = 'Radio';
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
            
            Booking__c booking = new Booking__c();
            booking.Primary_Applicant__c = accountObject.Id;
            booking.Related_Opportunity__c = oppoObject.Id;
            booking.Related_Suggested_Property__c = suggestedProperty.Id;
            booking.Project_Name__c = projectObject.Id;
            booking.OwnerId = testUserRcd1.Id;
            insert booking;
            addresses.add(booking.OwnerId);
            
            Task tsk5 = new Task();
            tsk5.Subject = 'SDR Letter for the Booking';
            tsk5.Status = 'Pending';
            tsk5.Priority = 'Normal';
            tsk5.WhatId = booking.Id;
            tsk5.OwnerId = testUserRcd1.Id;
            tsk5.ActivityDate = Date.today();
            insert tsk5;
            
            Attachment attach1=new Attachment();   	
            attach1.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach1.body=bodyBlob;
            attach1.parentId=booking.id;
            attach1.OwnerId = testUserRcd1.Id;
            insert attach1;
            
            Attachment attach =[select id, name,OwnerId,Body,ParentId from Attachment where parent.id=:booking.id];
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Bank_NOC_Document_Uploaded' limit 1];
            
            List<ContentVersion> ContentVersionList = new List<ContentVersion>();
            ContentVersion cVersion3 = new ContentVersion();
            cVersion3.ContentLocation = 'S'; 
            cVersion3.PathOnClient = attach1.Name;
            cVersion3.Origin = 'H';
            cVersion3.OwnerId = attach1.OwnerId;
            cVersion3.Title = attach1.Name;
            cVersion3.VersionData = attach1.Body;
            cVersion3.Document_Type__c = 'Bank Approved NOC';
            cVersion3.SObjectType__c = 'Booking__c';
            //  cVersion3.FirstPublishLocationId = accountObject.Id;
            cVersion3.BookingId__c = booking.Id;
            Insert cVersion3;
            
            ContentVersionList.add(cVersion3); 
            PreventRecursionClass.flag11 = true; // Reset flag  
            ContentDocumentTriggerHandler.sendEmailToRMAndCRMHeadBankNOCUploaded(ContentVersionList);
            Test.stopTest();
        }
    }
    @isTest
    static void testReraCertificateDocumentsUploadedCheckbox() {
        String CRMHeadUserName = Label.CRM_Head_User;
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.UserRoleId = UserInfo.getUserRoleId();
        testUserRcd1.ProfileId =  UserInfo.getProfileId();
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1){
            
            Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
            Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
            Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Test.startTest();
            List <account> accountList = new List<account>();
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '9896887676';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.PersonMobilePhone = '9896887676';
            accountObject.Rera_Certificate_Upload__c =  true;
            //acc.id = ContentDocumentLinkObj.FirstPublishLocationId;
            insert accountObject;
            accountList.add(accountObject);
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'nishi@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            insert projectObject;
            
            Opportunity oppoObject = new Opportunity();
            oppoObject.AccountId = accountObject.Id;
            oppoObject.Name = 'test Opportunity';
            oppoObject.StageName = 'Site Visit';
            oppoObject.CloseDate = System.Today()+3;
            oppoObject.Project__c = projectObject.Id;
            oppoObject.Interested_Configuration__c = '1 BHK';
            oppoObject.Sales_Manager__c = testUserRcd1.id;
            oppoObject.Project__c = projectObject.Id;
            oppoObject.Walk_in_Source__c = 'Radio';
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
            
            Booking__c booking = new Booking__c();
            booking.Primary_Applicant__c = accountObject.Id;
            booking.Related_Opportunity__c = oppoObject.Id;
            booking.Related_Suggested_Property__c = suggestedProperty.Id;
            booking.Project_Name__c = projectObject.Id;
            booking.OwnerId = testUserRcd1.Id;
            insert booking;
            
            Task tsk5 = new Task();
            tsk5.Subject = 'SDR Letter for the Booking';
            tsk5.Status = 'Pending';
            tsk5.Priority = 'Normal';
            tsk5.WhatId = booking.Id;
            tsk5.OwnerId = testUserRcd1.Id;
            tsk5.ActivityDate = Date.today();
            insert tsk5;
            
            Attachment attach1=new Attachment();   	
            attach1.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach1.body=bodyBlob;
            attach1.parentId=booking.id;
            attach1.OwnerId = testUserRcd1.Id;
            insert attach1;
            
            Attachment attach =[select id, name,OwnerId,Body,ParentId from Attachment where parent.id=:booking.id];
            
            EmailTemplate emailTemplate = [select Id, Name, Subject, HtmlValue, Body, DeveloperName from EmailTemplate where DeveloperName = 'Rera_Number_Update_Notification' LIMIT 1];
            
            List<ContentVersion> ContentVersionList = new List<ContentVersion>();
            ContentVersion cVersion3 = new ContentVersion();
            cVersion3.ContentLocation = 'S'; 
            cVersion3.PathOnClient = attach1.Name;
            cVersion3.Origin = 'H';
            cVersion3.OwnerId = attach1.OwnerId;
            cVersion3.Title = attach1.Name;
            cVersion3.VersionData = attach1.Body;
            cVersion3.Document_Type__c = 'Rera Certificate';
            cVersion3.SObjectType__c = 'Account';
            cVersion3.BookingId__c = booking.Id;
            cversion3.FirstPublishLocationId = accountObject.Id;
            Insert cVersion3;
            ContentVersionList.add(cVersion3); 
            
            
            ContentVersionTriggerHandler.reraCertificateFlag = false;
            ContentVersionTriggerHandler.ReraCertificateDocumentsUploadedCheckbox(ContentVersionList);
            
            Test.stopTest();
            
            
        }
    }
    @isTest
    static void testUpdateBookingBankApprovedCheckbox() {
        String CRMHeadUserName = Label.CRM_Head_User;
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.UserRoleId = UserInfo.getUserRoleId();
        testUserRcd1.ProfileId =  UserInfo.getProfileId();
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1){
            
            Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
            Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
            Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Test.startTest();
            List <account> accountList = new List<account>();
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '9896887676';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.PersonMobilePhone = '9896887676';
            accountObject.Rera_Certificate_Upload__c =  true;
            //acc.id = ContentDocumentLinkObj.FirstPublishLocationId;
            accountList.add(accountObject);
            insert accountObject;
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'nishi@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            insert projectObject;
            
            Opportunity oppoObject = new Opportunity();
            oppoObject.AccountId = accountObject.Id;
            oppoObject.Name = 'test Opportunity';
            oppoObject.StageName = 'Site Visit';
            oppoObject.CloseDate = System.Today()+3;
            oppoObject.Project__c = projectObject.Id;
            oppoObject.Interested_Configuration__c = '1 BHK';
            oppoObject.Sales_Manager__c = testUserRcd1.id;
            oppoObject.Project__c = projectObject.Id;
            oppoObject.Walk_in_Source__c = 'Radio';
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
            
            Booking__c booking = new Booking__c();
            booking.Primary_Applicant__c = accountObject.Id;
            booking.Related_Opportunity__c = oppoObject.Id;
            booking.Related_Suggested_Property__c = suggestedProperty.Id;
            booking.Project_Name__c = projectObject.Id;
            booking.OwnerId = testUserRcd1.Id;
            booking.Bank_Approved_NOC__c = true;
            booking.Bank_Approved_ROC__c = true;
            insert booking;
            
            Attachment attach2=new Attachment();   	
            attach2.Name='Bank Approved NOC';
            Blob bodyBlob1=Blob.valueOf('Bank Approved NOC Body');
            attach2.body=bodyBlob1;
            attach2.parentId=booking.id;
            attach2.OwnerId = testUserRcd1.Id;
            insert attach2;
            
            Attachment attachtest =[select id, name,OwnerId,Body,ParentId from Attachment where parent.id=:booking.id];
            
            ContentVersion cVersion2 = new ContentVersion();
            cVersion2.ContentLocation = 'S'; 
            cVersion2.PathOnClient = attach2.Name;
            cVersion2.Origin = 'H';
            cVersion2.OwnerId = attach2.OwnerId;
            cVersion2.Title = attach2.Name;
            cVersion2.VersionData = attach2.Body;
            cVersion2.Document_Type__c = 'Bank Approved ROC';
            cVersion2.SObjectType__c = 'Booking__c';
            cVersion2.BookingId__c = booking.Id;
            Insert cVersion2;
            
            
            Attachment attach1=new Attachment();   	
            attach1.Name='Bank Approved ROC';
            Blob bodyBlob=Blob.valueOf('Bank Approved ROC Body');
            attach1.body=bodyBlob;
            attach1.parentId=booking.id;
            attach1.OwnerId = testUserRcd1.Id;
            insert attach1;
            
            
            ContentVersion cVersion3 = new ContentVersion();
            cVersion3.ContentLocation = 'S'; 
            cVersion3.PathOnClient = attach1.Name;
            cVersion3.Origin = 'H';
            cVersion3.OwnerId = attach1.OwnerId;
            cVersion3.Title = attach1.Name;
            cVersion3.VersionData = attach1.Body;
            cVersion3.Document_Type__c = 'Bank Approved ROC';
            cVersion3.SObjectType__c = 'Booking__c';
            cVersion3.BookingId__c = booking.Id;
            Insert cVersion3;
            
            PreventRecursionClass.flag51 = false;
            List<ContentVersion> testContentVersions = new List<ContentVersion>{ cVersion3};
                ContentDocumentTriggerHandler.UpdateBookingBankApprovedCheckbox(testContentVersions);
            
            Test.stopTest();
        }
    }
    @isTest
    static void testChangeSDRTaskStatusAsChallanReceived() {
        //UserRole crmHeadRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'CRM_Head' LIMIT 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.UserRoleId =  UserInfo.getUserRoleId();
        testUserRcd1.ProfileId =  UserInfo.getProfileId();
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1){
            
            Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
            Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
            Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Test.startTest();
            List <account> accountList = new List<account>();
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '9896887676';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.PersonMobilePhone = '9896887676';
            accountObject.Rera_Certificate_Upload__c =  true;
            //acc.id = ContentDocumentLinkObj.FirstPublishLocationId;
            accountList.add(accountObject);
            insert accountObject;
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'nishi@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            insert projectObject;
            
            Opportunity oppoObject = new Opportunity();
            oppoObject.AccountId = accountObject.Id;
            oppoObject.Name = 'test Opportunity';
            oppoObject.StageName = 'Site Visit';
            oppoObject.CloseDate = System.Today()+3;
            oppoObject.Project__c = projectObject.Id;
            oppoObject.Interested_Configuration__c = '1 BHK';
            oppoObject.Sales_Manager__c = testUserRcd1.id;
            oppoObject.Project__c = projectObject.Id;
            oppoObject.Walk_in_Source__c = 'Radio';
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
            
            Booking__c booking = new Booking__c();
            booking.Primary_Applicant__c = accountObject.Id;
            booking.Related_Opportunity__c = oppoObject.Id;
            booking.Related_Suggested_Property__c = suggestedProperty.Id;
            booking.Project_Name__c = projectObject.Id;
            booking.OwnerId = testUserRcd1.Id;
            booking.Bank_Approved_NOC__c = true;
            booking.Bank_Approved_ROC__c = true;
            insert booking;
            
            Attachment attach2=new Attachment();   	
            attach2.Name='SDR Challan Copy';
            Blob bodyBlob1=Blob.valueOf('SDR Challan Copy Body');
            attach2.body=bodyBlob1;
            attach2.parentId=booking.id;
            attach2.OwnerId = testUserRcd1.Id;
            insert attach2;
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'SDR_Payment_received' limit 1];
  
            List<ContentVersion> testContentVersions = new List<ContentVersion>(); 
            ContentVersion cVersion3 = new ContentVersion();
            cVersion3.ContentLocation = 'S'; 
            cVersion3.PathOnClient = attach2.Name;
            cVersion3.Origin = 'H';
            cVersion3.OwnerId = attach2.OwnerId;
            cVersion3.Title = attach2.Name;
            cVersion3.VersionData = attach2.Body;
            cVersion3.Document_Type__c = 'SDR Challan Copy';
            cVersion3.SObjectType__c = 'Booking__c';
            cVersion3.BookingId__c = booking.Id;
    
            Insert cVersion3;
            testContentVersions.add(cVersion3);
             ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cVersion3.Id];
            
                 List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = booking.id;
            cdl.ContentDocumentId = testContent.ContentDocumentId;
            cdl.shareType = 'V';
            insert cdl;

            
            Task testSDRTask = new Task(
                Subject = 'SDR Letter for the Booking',
                WhatId = booking.Id
            );
            insert testSDRTask;            
            
            // Call the method under test
            PreventRecursionClass.flag4 = true;
            
            ContentDocumentTriggerHandler.ChangeSDRTaskStatusAsChallanRecieved(testContentVersions);
            
            Test.stopTest();
            
        }
    }
    
}*/