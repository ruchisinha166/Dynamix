@isTest
public class PossessionLetterControllerTest {
    
    @isTest static void PossessionLetterControllerTest(){
        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                       from EmailTemplate 
                                       where Name = 'FM Pre OC Review Task' LIMIT 1];
        EmailTemplate emailTemplateForPostOC = [select Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                                from EmailTemplate 
                                                where DeveloperName = 'Post_OC_FM_Task_Due_Date' LIMIT 1];
        
        
        SMS_Template_Id__mdt smsTemplateForConnectedCalls = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='SMS For Connected Call' Limit 1];
        EmailTemplate smsEmailTempForConnectedCalls = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS For Connected Call' LIMIT 1];
        SMS_Template_Id__mdt smsTemplateForClientMissedTheCall = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='SMS Sent Customer Missed the Call' Limit 1];
        EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS For a Missed Call form an Existing Enquiry' LIMIT 1];
        EmailTemplate smsEmailTempForClientMissedTheCall = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS Sent Customer Missed the Call' LIMIT 1];
        List<BusinessHours> bhs=[select id from BusinessHours where IsDefault=true];
        
        Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
        Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
        
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
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1){
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '7894567890';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.PersonMobilePhone='7894567890'; 
            insert accountObject;
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.Project_Footer__c='www.gmail.com';
            projectObject.Project_Header__c='www.gmail.com';
            projectObject.FM_Head__c = testUserRcd1.id;
            insert projectObject;
            
            Tower__c towerObject = new Tower__c();
            towerObject.Name = 'test tower';
            towerObject.Project__c = projectObject.Id;
            insert towerObject;
            List<Campaign> testCampaigns = new List<Campaign>();
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            insert testCampRcd;
       
            
         
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c=accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Hoarding';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='7894567890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            
            Enquiry__c testEnqRcd1=new Enquiry__c();
            testEnqRcd1.Campaign__c = testCampRcd.Id;
            testEnqRcd1.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='7894567890';
            try{
                // insert testEnqRcd;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }
            
            List<Task> taskLists = new List<Task>();
            Task task1 = new Task();
            task1.WhatId = testEnqRcd.Id;
            
            Opportunity oppoObject = new Opportunity();
            oppoObject.AccountId = accountObject.Id;
            oppoObject.Name = 'test Opportunity';
            oppoObject.StageName = 'Site Visit';
            oppoObject.CloseDate = System.Today()+3;
            oppoObject.Project__c = projectObject.Id;
            oppoObject.Walk_in_Source__c = 'Radio';
            insert oppoObject;
            
            //TaskTriggerHandler1.method();
            Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
            pricingPlanObject.Name = 'Pricing Plan Test';
            pricingPlanObject.Project__c = projectObject.Id;
            insert pricingPlanObject;
            
            Property__c propertyObject = new Property__c();
            propertyObject.Name = 'test property';
            propertyObject.Project__c = projectObject.Id;
            propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
            propertyObject.Floor__c= '11';
            propertyObject.Tower__c = towerObject.id;
            propertyObject.FM_User__c = testUserRcd1.Id;
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
            booking.Sales_Manager__c = testUserRcd1.Id;
            booking.Tower_Name__c = towerObject.id;
            booking.Primary_Secondary_info_Updated__c = false;
            booking.Shared_SDR_Letter__c = false;
            booking.Date_of_First_Disbursement__c = Date.today();
            booking.Amount_of_First_Disbursement__c = 43;
            booking.Cancellation_Approval_Status__c = 'Approved';
            booking.Booking_Cancellation__c = false;
            booking.Welcome_Email_Checker__c = false;
            booking.Cancellation_Checkbox__c = false;
            booking.Cancellation_Requested_Status__c = 'Cancellation Confirmed';
            booking.Cancellation_Approval_Status__c = 'Submitted';
            booking.Source_of_Finance__c = 'Self Funded';
            insert booking;
            Bank__c Bank = New Bank__c();
            Bank.Name = 'PNB Bank';
            insert Bank;
            
            List<Payment__c> payList = New List<Payment__c>();
            PreventRecursionClass.flag11 = true;
            PreventRecursionClass.flag4 = true;
            PreventRecursionClass.flag51 = true;
            Payment__c  PaymentObj = New Payment__c();
            PaymentObj.Date__c = date.today();
            PaymentObj.BankName__c = Bank.Id;
            PaymentObj.Payment_Date__c = Date.today().addDays(20);
            PaymentObj.Amount__c = 655683;
            PaymentObj.Payment_Category__c = 'Unit Cost';
            PaymentObj.Payment_Type__c = 'Cheque';
            PaymentObj.Cheque_Status__c = 'Cleared';
            PaymentObj.Cheque_Transaction_Number__c = 'Cheque No';
            PaymentObj.Booking__c = booking.id;
            PaymentObj.Branch_Name__c = 'Mohali';
            insert PaymentObj;
            
               Test.startTest();
            
            Attachment attach1=new Attachment();   	
            attach1.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach1.body=bodyBlob;
            attach1.parentId=accountObject.id;
            attach1.OwnerId = testUserRcd1.Id;
            insert attach1;
            
            Attachment attach =[select id, name,OwnerId,Body,ParentId from Attachment where parent.id=:accountObject.id];
            
            ContentVersion snagContentVersion = new ContentVersion();
            snagContentVersion.ContentLocation = 'S'; 
            snagContentVersion.Origin = 'H';
            snagContentVersion.PathOnClient = 'Possession Letter/Div/1110.pdf';
            snagContentVersion.Title = 'Possession Letter/Div/1110.pdf';
            snagContentVersion.VersionData = attach.Body;
            snagContentVersion.FirstPublishLocationId = booking.Id;
            snagContentVersion.Document_Type__c = 'Handover of Possession Letter';
            snagContentVersion.SObjectType__c = 'Booking__c';
            Insert snagContentVersion;
            
            ContentVersion snagContentVersion1 = new ContentVersion();
            snagContentVersion1.ContentLocation = 'S'; 
            snagContentVersion1.Origin = 'H';
            snagContentVersion1.PathOnClient = 'Letter Pending Common Amenities/Div/1110.pdf';
            snagContentVersion1.Title = 'Letter Pending Common Amenities/Div/1110.pdf';
            snagContentVersion1.VersionData = attach.Body;
            snagContentVersion1.FirstPublishLocationId = booking.Id;
            snagContentVersion1.Document_Type__c = 'Letter Pending Common Amenities';
            snagContentVersion1.SObjectType__c = 'Booking__c';
            Insert snagContentVersion1;
            
            List<GeneratePossessionLetter.Requests> BookingReqList = New List<GeneratePossessionLetter.Requests>();
            
            GeneratePossessionLetter.Requests BookReq = New GeneratePossessionLetter.Requests();
            BookReq.bookingId = booking.Id;
            
            BookingReqList.add(BookReq);
            pagereference pageref = page.PossessionLetter; 
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',String.valueOf(booking.id));
            ApexPages.StandardController sc = new ApexPages.StandardController(booking);
            PossessionLetterController Allot = New PossessionLetterController(sc);
             pagereference pageref1 = page.LetterPendingCommonAmenities; 
            Test.setCurrentPage(pageref1);
            pageref1.getParameters().put('id',String.valueOf(booking.id));
            ApexPages.StandardController sc1 = new ApexPages.StandardController(booking);
            LetterPendingCommonAmenitiesController LetterPendingCommonAmenitiesController = New LetterPendingCommonAmenitiesController(sc1);
            
            GeneratePossessionLetter.execute(BookingReqList);
            
            Test.stopTest();
        }
        
        
        
    }
    @isTest static void PossessionLetterControllerTest1(){
        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                       from EmailTemplate 
                                       where Name = 'FM Pre OC Review Task' LIMIT 1];
        EmailTemplate emailTemplateForPostOC = [select Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                                from EmailTemplate 
                                                where DeveloperName = 'Post_OC_FM_Task_Due_Date' LIMIT 1];
        
        
        SMS_Template_Id__mdt smsTemplateForConnectedCalls = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='SMS For Connected Call' Limit 1];
        EmailTemplate smsEmailTempForConnectedCalls = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS For Connected Call' LIMIT 1];
        SMS_Template_Id__mdt smsTemplateForClientMissedTheCall = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='SMS Sent Customer Missed the Call' Limit 1];
        EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS For a Missed Call form an Existing Enquiry' LIMIT 1];
        EmailTemplate smsEmailTempForClientMissedTheCall = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS Sent Customer Missed the Call' LIMIT 1];
        List<BusinessHours> bhs=[select id from BusinessHours where IsDefault=true];
        
        Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
        Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
        
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
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1){
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '7894567890';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.PersonMobilePhone='7894567890'; 
            insert accountObject;
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.FM_Head__c = testUserRcd1.id;
            insert projectObject;
            
            Tower__c towerObject = new Tower__c();
            towerObject.Name = 'test tower';
            towerObject.Project__c = projectObject.Id;
            insert towerObject;
            List<Campaign> testCampaigns = new List<Campaign>();
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            insert testCampRcd;
            
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
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c=accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Hoarding';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='7894567890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            
            Enquiry__c testEnqRcd1=new Enquiry__c();
            testEnqRcd1.Campaign__c = testCampRcd.Id;
            testEnqRcd1.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='7894567890';
            try{
                // insert testEnqRcd;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }
            
            List<Task> taskLists = new List<Task>();
            Task task1 = new Task();
            task1.WhatId = testEnqRcd.Id;
            
            Opportunity oppoObject = new Opportunity();
            oppoObject.AccountId = accountObject.Id;
            oppoObject.Name = 'test Opportunity';
            oppoObject.StageName = 'Site Visit';
            oppoObject.CloseDate = System.Today()+3;
            oppoObject.Project__c = projectObject.Id;
            oppoObject.Walk_in_Source__c = 'Radio';
            insert oppoObject;
            
            //TaskTriggerHandler1.method();
            Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
            pricingPlanObject.Name = 'Pricing Plan Test';
            pricingPlanObject.Project__c = projectObject.Id;
            insert pricingPlanObject;
            
            Property__c propertyObject = new Property__c();
            propertyObject.Name = 'test property';
            propertyObject.Project__c = projectObject.Id;
            propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
            propertyObject.Floor__c= '5';
            propertyObject.FM_User__c = testUserRcd1.Id;
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
            booking.Sales_Manager__c = testUserRcd1.Id;
            //booking.OwnerId = testUserRcd1.Id;
            booking.Primary_Secondary_info_Updated__c = false;
            booking.Shared_SDR_Letter__c = false;
            booking.Date_of_First_Disbursement__c = Date.today();
            booking.Amount_of_First_Disbursement__c = 43;
            booking.Cancellation_Approval_Status__c = 'Approved';
            booking.Booking_Cancellation__c = false;
            booking.Welcome_Email_Checker__c = false;
            booking.Cancellation_Checkbox__c = false;
            booking.Cancellation_Requested_Status__c = 'Cancellation Confirmed';
            booking.Cancellation_Approval_Status__c = 'Submitted';
            booking.Source_of_Finance__c = 'Self Funded';
            insert booking;
            
            Account accountObject1 = new Account();
            accountObject1.RecordTypeId = [select Id from recordtype where developerName = 'PersonAccount' ].Id;
            accountObject1.FirstName = 'Test';
            accountObject1.LastName = 'test Account';
            accountObject1.BillingCountry = 'India';
            accountObject1.Phone = '455546565';
            accountObject1.PersonBirthdate = system.today() - 30;
            accountObject1.PersonMobilePhone = '9856984573';
            insert accountObject1;
            
            Co_Applicant__c testCoApplicant1 = new Co_Applicant__c();
            testCoApplicant1.Role__c = 'Co-Applicant';
            testCoApplicant1.Account__c = accountObject1.Id;
            testCoApplicant1.Booking__c = booking.Id;
            // insert testCoApplicant1;
            
            Attachment attach1=new Attachment();   	
            attach1.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach1.body=bodyBlob;
            attach1.parentId=accountObject.id;
            attach1.OwnerId = testUserRcd1.Id;
            insert attach1;
            
            Attachment attach =[select id, name,OwnerId,Body,ParentId from Attachment where parent.id=:accountObject.id];
            
            ContentVersion snagContentVersion = new ContentVersion();
            snagContentVersion.ContentLocation = 'S'; 
            snagContentVersion.Origin = 'H';
            snagContentVersion.PathOnClient = 'Possession Letter/Div/1110.pdf';
            snagContentVersion.Title = 'Possession Letter/Div/1110.pdf';
            snagContentVersion.VersionData = attach.Body;
            snagContentVersion.FirstPublishLocationId = booking.Id;
            snagContentVersion.Document_Type__c = 'Handover of Possession Letter';
            snagContentVersion.SObjectType__c = 'Booking__c';
            Insert snagContentVersion;
            
            ContentVersion snagContentVersion1 = new ContentVersion();
            snagContentVersion1.ContentLocation = 'S'; 
            snagContentVersion1.Origin = 'H';
            snagContentVersion1.PathOnClient = 'Letter Pending Common Amenities/Div/1110.pdf';
            snagContentVersion1.Title = 'Letter Pending Common Amenities/Div/1110.pdf';
            snagContentVersion1.VersionData = attach.Body;
            snagContentVersion1.FirstPublishLocationId = booking.Id;
            snagContentVersion1.Document_Type__c = 'Letter Pending Common Amenities';
            snagContentVersion1.SObjectType__c = 'Booking__c';
            Insert snagContentVersion1;
            
            List<GeneratePossessionLetter.Requests> BookingReqList = New List<GeneratePossessionLetter.Requests>();
            
            GeneratePossessionLetter.Requests BookReq = New GeneratePossessionLetter.Requests();
            BookReq.bookingId = booking.Id;
            
            BookingReqList.add(BookReq);
            pagereference pageref = page.PossessionLetter; 
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',String.valueOf(booking.id));
            ApexPages.StandardController sc = new ApexPages.StandardController(booking);
            PossessionLetterController Allot = New PossessionLetterController(sc);
            pagereference pageref1 = page.LetterPendingCommonAmenities; 
            Test.setCurrentPage(pageref1);
            pageref1.getParameters().put('id',String.valueOf(booking.id));
            ApexPages.StandardController sc1 = new ApexPages.StandardController(booking);
            LetterPendingCommonAmenitiesController LetterPendingCommonAmenitiesController = New LetterPendingCommonAmenitiesController(sc1);
            
            //GeneratePossessionLetter.execute(BookingReqList);
            
            Test.stopTest();
        }
    }
}