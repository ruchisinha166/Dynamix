@isTest
public class BookingTriggerHandler_Test{
    
    @testSetup
    static void setup(){
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
            
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '4555465655';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.PAN_No__pc = 'ABCTY1234W';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.PersonMobilePhone = '5487956215';
            insert accountObject;
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
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
            propertyObject.Flat_Type__c = 'CAR PARKING';
            propertyObject.Property_Status__c = 'Allotted';
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
            booking.Primary_Secondary_info_Updated__c = false;
            booking.Shared_SDR_Letter__c = false;
            booking.Date_of_First_Disbursement__c = Date.today();
            booking.Amount_of_First_Disbursement__c = 43;
            booking.Booking_Cancellation__c = false;
            booking.Welcome_Email_Checker__c = false;
            booking.Cancellation_Checkbox__c = false;
            booking.Cancellation_Requested_Status__c = 'Cancellation Confirmed';
            booking.Cancellation_Approval_Status__c = 'Submitted';
            booking.Source_of_Finance__c = 'Self Funded';
            booking.Aadhar__c = false;
            booking.PAN__c = false;
            booking.Stage__c = 'Draft';
            insert booking;
            
            Payment__c paymnt = new Payment__c();
            paymnt.Booking__c = booking.Id;
            paymnt.Paid_By__c = 'Self';
            paymnt.Amount__c = 100000;
            paymnt.Payment_Status__c = 'Approved';
            paymnt.Payment_Date__c = system.today();
            paymnt.Payment_Category__c = 'Unit Cost';
            paymnt.Cheque__c = 'afaaafg';
            paymnt.Date__c = system.today();
            paymnt.Payment_Mode__c = 'NEFT';
            paymnt.Payment_Type__c = 'NEFT/ RTGS/ IMPS';
            paymnt.Receipt_No__c = '21314';
            Insert paymnt;
            
            EOI_CA_Payment__c testEOI = new EOI_CA_Payment__c();
            testEOI.Opportunity__c = oppoObject.id;
            insert testEOI;
            
            Booking__c booking1 = new Booking__c();
            booking1.Primary_Applicant__c = accountObject.Id;
            booking1.Related_Opportunity__c = oppoObject.Id;
            booking1.Related_Suggested_Property__c = suggestedProperty.Id;
            booking1.Project_Name__c = projectObject.Id;
            booking1.OwnerId = testUserRcd1.Id;
            booking1.Cancellation_Checkbox__c = false;
            booking1.Cancellation_Requested_Status__c = 'Cancellation Confirmed';
            booking1.Cancellation_Approval_Status__c = 'Submitted';
            booking1.Source_of_Finance__c = 'Self Funded';
            booking1.Stage__c = 'Terminated';
            //insert booking1;
            
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
            
            Bank__c Bank = New Bank__c();
            Bank.Name = 'PNB Bank';
            insert Bank;
            
            Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
            BLD.Home_LoanInstitution__c = Bank.Id;
            BLD.Booking__c = booking.Id;
            Insert BLD;  
            
            Task tsk = new Task();
            tsk.Subject = 'Generate Draft Agreement';
            tsk.Status = 'Pending';
            tsk.Priority = 'Normal';
            tsk.WhatId = booking.Id;
            tsk.OwnerId = testUserRcd1.Id;
            insert tsk;
            
            Task tsk1 = new Task();
            tsk1.Subject = 'Welcome Call';
            tsk1.Status = 'Pending';
            tsk1.Priority = 'Normal';
            tsk1.WhatId = booking.Id;
            tsk1.OwnerId = testUserRcd1.Id;
            insert tsk1;
            
            Task tsk12 = new Task();
            tsk12.Subject = 'Review Welcome Call';
            tsk12.Status = 'Pending';
            tsk12.Priority = 'Normal';
            tsk12.WhatId = booking.Id;
            tsk12.OwnerId = testUserRcd1.Id;
            insert tsk12;
            
            Task tsk3 = new Task();
            tsk3.Subject = 'SDR Letter for the Booking';
            tsk3.Status = 'Pending';
            tsk3.Priority = 'Normal';
            tsk3.WhatId = booking.Id;
            tsk3.OwnerId = testUserRcd1.Id;
            insert tsk3;
        }
    }
    
    @isTest  
    public static void Method1(){
        Test.startTest();
        Booking__c booking = [Select Id,Name From Booking__c limit 1];
        booking.Primary_Secondary_info_Updated__c = True;
        booking.Shared_SDR_Letter__c = True;
        booking.Date_of_First_Disbursement__c = Date.today();
        booking.Amount_of_First_Disbursement__c = 4343;
        update booking;
        
        String str = '['+JSON.serialize(booking)+']';
        String StrJSON = '[{"attributes": {"type": "Booking__c","url": "/services/data/v52.0/sobjects/Booking__c/a060w000001rHXLAA2"},"Primary_Applicant__c": "0010w00000gb9lGAAQ","Related_Opportunity__c": "0060w0000061faDAAQ","Related_Suggested_Property__c": "a0P0w000003IPYnEAO","Project_Name__c": "a0L0w000001SQHyEAO","Id": "a060w000001rHXLA","Primary_Loan_Details__c":"a030w000006SEnAAAW"},{"attributes": {"type": "Bank_Loan_Details__c","url": "/services/data/v52.0/sobjects/Bank_Loan_Details__c/a030w000006SEnAAAW"},"Home_LoanInstitution__c": "a040w000003t5r1AAA","Booking__c": "a060w000001rHujAAE","Id": "a030w000006SEnAAAW"}]';
        BookingTriggerHandler.generateWelcomeLetter(booking.Id);
        BookingTriggerHandler.generateNOCLetter(str);
        Test.stopTest();
    }
    
    @isTest  
    public static void Method2(){
        Test.startTest();
        Booking__c booking = [Select Id,Name From Booking__c limit 1];
        booking.Welcome_Email_Checker__c = True;
        update booking;
        Test.stopTest();
    }
    
    @isTest  
    public static void Method3(){
        Test.startTest();
        Booking__c booking = [Select Id,Name From Booking__c limit 1];
        booking.Booking_Cancellation__c = True;
        update booking;
        Test.stopTest();
    }
    
    @isTest  
    public static void Method4(){
        Test.startTest();
        Booking__c booking = [Select Id,Name From Booking__c limit 1];
        booking.Cancellation_Approval_Status__c = 'Rejected';
        update booking;
        Test.stopTest();
    }
    
    @isTest  
    public static void Method5(){
        Test.startTest();
        Booking__c booking = [Select Id,Name From Booking__c limit 1];
        booking.Cancellation_Checkbox__c = True;
        booking.Cancellation_Requested_Status__c = 'Retained';
        update booking;
        Test.stopTest();
    }
    
    @isTest  
    public static void Method6(){
        Test.startTest();
        Booking__c booking = [Select Id,Name From Booking__c limit 1];
        booking.Cancellation_Approval_Status__c = 'Approved';
        booking.Cancellation_Reasons__c = 'Termination';
        booking.Cancellation_Requested_Status__c = 'Unit Transfer';
        update booking;
        Test.stopTest();
    }
    
    @isTest  
    public static void Method7(){
        Test.startTest();
        Booking__c booking = [Select Id,Name From Booking__c limit 1];
        booking.Source_of_Finance__c = 'Loan from Bank';
        booking.Aadhar__c = true;
        booking.PAN__c = true;
        update booking;
        Test.stopTest();
    }
    
    @isTest  
    public static void Method8(){
        Test.startTest();
        List<Booking__c> booking = [Select Id,Name,Project_Name__c From Booking__c limit 1];
        BookingTriggerHandler.updateBrokerDetails(booking);
        Test.stopTest();
    }
    @isTest  
    public static void Method9(){
        Test.startTest();
        List<Booking__c> booking = [Select Id,Name,Project_Name__c From Booking__c limit 1];
        booking[0].Stage__c = 'Booked';
        update booking;
        Test.stopTest();
    }
}