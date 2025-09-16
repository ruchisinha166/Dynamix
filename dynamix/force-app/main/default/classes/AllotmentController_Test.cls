@isTest
public class AllotmentController_Test {
    
    @isTest static void AllotmentControllerTest(){
        try{
            Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
            Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
            Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.Name = 'test Account';
            accountObject.BillingCountry = 'India';
            //accountObject.PersonMobilePhone = '4555465612';
            insert accountObject;
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Header__c = 'Header';
            projectObject.Project_Footer__c = 'Footer';
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
            propertyObject.Floor__c= '5';
            propertyObject.Flat_Type__c = '1 BHK';
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
            projectAddbject2.Parking_Type__c = 'Car Parking';
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
            projectAddbject1.Parking_Type__c = 'Car Parking';
            projectAddbject1.RecordTypeId = parkingId;
            projectAddbject1.Project__c = projectObject.Id;
            projectAddbject1.Name = 'Stilt';
            insert projectAddbject1;
            
            Add_On__c addOn = new Add_On__c();
            addOn.Opportunity__c = oppoObject.Id;
            addOn.Project_Add_On_Charges__c = projectAddbject1.Id;
            addOn.No_Of_Unit__c = 6;
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
            insert booking;
            
            Co_Applicant__c COAPP = New Co_Applicant__c();
            COAPP.Role__c = 'Primary';
            COAPP.Account__c = accountObject.Id;
            COAPP.Booking__c = booking.Id;
            Insert COAPP;
            
            Booking_Line_Items__c bookingLineObjects = new Booking_Line_Items__c();
            bookingLineObjects.Booking__c = booking.Id;
            bookingLineObjects.Project_Add_On_Charges__c = projectAddbject.Id;
            bookingLineObjects.Property__c = propertyObject.Id;
            bookingLineObjects.Booking__c = booking.Id;       
            insert bookingLineObjects;
            
            Price_Details__c priceDetailObject = new Price_Details__c();
            priceDetailObject.Name = 'Price Test1';
            priceDetailObject.Charge_Group__c= '20';
            priceDetailObject.GST_Type__c = 'Standard';
            priceDetailObject.Booking__c = booking.Id;
            priceDetailObject.Amount__c = 6;
            insert priceDetailObject;
            
            Price_Details__c priceDetailObject1 = new Price_Details__c();
            priceDetailObject1.Name = 'Price Test';
            priceDetailObject1.Charge_Group__c= '20';
            priceDetailObject1.GST_Type__c = 'Standard' ;
            priceDetailObject1.Booking__c = booking.Id;
            priceDetailObject1.Amount__c = 6;
            insert priceDetailObject1;
            
            Bank__c bankObj = new Bank__c();
            bankObj.Name = 'ICICI';
            insert bankObj;
            
            Payment__c payOj = new Payment__c();
            payOj.Booking__c = booking.Id;
            payOj.Payment_Type__c = 'Cheque';
            payOj.Cheque_Transaction_Number__c = 'fgd';
            payOj.BankName__c = bankObj.Id;
            payOj.Receipt_No__c = '127856';
            insert payOj;
            
            Test.startTest();   
            pagereference pageref = page.Allotment; 
            Test.setCurrentPage(pageRef);
            if(booking != null && booking.Id != null){
                pageRef.getParameters().put('id',String.valueOf(booking.id));
                ApexPages.StandardController sc = new ApexPages.StandardController(booking);
                AllotmentController Allot = New AllotmentController(sc);
            }
            else{
                System.debug('Booking id null');
            }
            
            Test.stopTest();
        }
        catch(Exception ex)
        {
            System.debug('Error');
        }
    }
    
    @isTest static void AllotmentControllerTest1(){
        try{
            Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
            Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
            Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
            
            
            Account accountObject = new Account();
            accountObject.Name = 'test Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '4555465665';
            insert accountObject;
            
            Project__c testProj = new Project__c();
            testProj.Name = 'Test Name';
            insert testProj;
            
            Opportunity oppoObject = new Opportunity();
            oppoObject.AccountId = accountObject.Id;
            oppoObject.Name = 'test Opportunity';
            oppoObject.StageName = 'Site Visit';
            oppoObject.CloseDate = System.Today()+3;
            oppoObject.Project__c = testProj.Id;
            insert oppoObject;
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
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
            propertyObject.Flat_Type__c = '1 BHK';
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
            projectAddbject2.Parking_Type__c = 'Two Wheeler Parking';
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
            projectAddbject1.Parking_Type__c = 'Car Parking';
            projectAddbject1.Is_Optional__c = false;
            projectAddbject1.RecordTypeId = parkingId;
            projectAddbject1.Project__c = projectObject.Id;
            projectAddbject1.Name = 'Stilt';
            insert projectAddbject1;
            
            Add_On__c addOn = new Add_On__c();
            addOn.Opportunity__c = oppoObject.Id;
            addOn.Project_Add_On_Charges__c = projectAddbject1.Id;
            addOn.No_Of_Unit__c = 6;
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
            insert booking;
            
            Co_Applicant__c COAPP = New Co_Applicant__c();
            COAPP.Role__c = 'Primary';
            COAPP.Account__c = accountObject.Id;
            COAPP.Booking__c = booking.Id;
            Insert COAPP;
            
            Booking_Line_Items__c bookingLineObjects = new Booking_Line_Items__c();
            bookingLineObjects.Booking__c = booking.Id;
            bookingLineObjects.Project_Add_On_Charges__c = projectAddbject.Id;
            bookingLineObjects.Property__c = propertyObject.Id;
            bookingLineObjects.Booking__c = booking.Id;       
            insert bookingLineObjects;
            
            Price_Details__c priceDetailObject = new Price_Details__c();
            priceDetailObject.Name = 'Price Test1';
            priceDetailObject.Charge_Group__c= '20';
            priceDetailObject.GST_Type__c = 'Standard';
            priceDetailObject.Booking__c = booking.Id;
            priceDetailObject.Amount__c = 6;
            insert priceDetailObject;
            
            Price_Details__c priceDetailObject1 = new Price_Details__c();
            priceDetailObject1.Name = 'Price Test';
            priceDetailObject1.Charge_Group__c= '20';
            priceDetailObject1.GST_Type__c = 'Standard' ;
            priceDetailObject1.Booking__c = booking.Id;
            priceDetailObject1.Amount__c = 6;
            insert priceDetailObject1;
            
            Bank__c bankObj = new Bank__c();
            bankObj.Name = 'ICICI';
            insert bankObj;
            
            Payment__c payOj = new Payment__c();
            payOj.Booking__c = booking.Id;
            payOj.Payment_Type__c = 'Cheque';
            payOj.Cheque_Transaction_Number__c = 'fgd';
            payOj.BankName__c = bankObj.Id;
            payOj.Receipt_No__c = '123856';
            insert payOj;
            
            Test.startTest();   
            pagereference pageref = page.Allotment; 
            Test.setCurrentPage(pageRef);
            if(booking != null && booking.Id != null){
                pageRef.getParameters().put('id',String.valueOf(booking.id));
                ApexPages.StandardController sc = new ApexPages.StandardController(booking);
                AllotmentController Allot = New AllotmentController(sc);
            }
            else{
                System.debug('Booking id null');
            }
            
            Test.stopTest();
        }
        catch(Exception ex)
        {
            System.debug('Error');
        }
    }
    
    @isTest static void AllotmentControllerTest2(){
        try{
            Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
            Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
            Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.Name = 'test Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '4555465665';
            insert accountObject;
            
            Project__c testProj = new Project__c();
            testProj.Name = 'Test Name';
            insert testProj;
            
            Opportunity oppoObject = new Opportunity();
            oppoObject.AccountId = accountObject.Id;
            oppoObject.Name = 'test Opportunity';
            oppoObject.StageName = 'Site Visit';
            oppoObject.CloseDate = System.Today()+3;
            oppoObject.Project__c = testProj.Id;
            insert oppoObject;
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
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
            propertyObject.Flat_Type__c = '1 BHK';
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
            projectAddbject1.Parking_Type__c = 'Two Wheeler Parking';
            projectAddbject1.Is_Optional__c = false;
            projectAddbject1.RecordTypeId = parkingId;
            projectAddbject1.Project__c = projectObject.Id;
            projectAddbject1.Name = 'Stilt';
            insert projectAddbject1;
            
            Add_On__c addOn = new Add_On__c();
            addOn.Parking_Number__c = 'CP-01';
            addOn.Opportunity__c = oppoObject.Id;
            addOn.Project_Add_On_Charges__c = projectAddbject1.Id;
            addOn.No_Of_Unit__c = 6;
            addOn.Length__c = 100;
            addOn.Breadth__c = 50;
            addOn.Height__c = 10;
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
            insert booking;
            
            Co_Applicant__c COAPP = New Co_Applicant__c();
            COAPP.Role__c = 'Primary';
            COAPP.Account__c = accountObject.Id;
            COAPP.Booking__c = booking.Id;
            Insert COAPP;
            
            Booking_Line_Items__c bookingLineObjects = new Booking_Line_Items__c();
            bookingLineObjects.Booking__c = booking.Id;
            bookingLineObjects.Project_Add_On_Charges__c = projectAddbject.Id;
            bookingLineObjects.Property__c = propertyObject.Id;
            bookingLineObjects.Booking__c = booking.Id;       
            insert bookingLineObjects;
            
            Price_Details__c priceDetailObject = new Price_Details__c();
            priceDetailObject.Name = 'Price Test1';
            priceDetailObject.Charge_Group__c= '20';
            priceDetailObject.GST_Type__c = 'Standard';
            priceDetailObject.Booking__c = booking.Id;
            priceDetailObject.Amount__c = 6;
            insert priceDetailObject;
            
            Price_Details__c priceDetailObject1 = new Price_Details__c();
            priceDetailObject1.Name = 'Price Test';
            priceDetailObject1.Charge_Group__c= '20';
            priceDetailObject1.GST_Type__c = 'Standard' ;
            priceDetailObject1.Booking__c = booking.Id;
            priceDetailObject1.Amount__c = 6;
            insert priceDetailObject1;
            
            Bank__c bankObj = new Bank__c();
            bankObj.Name = 'ICICI';
            insert bankObj;
            
            Payment__c payOj = new Payment__c();
            payOj.Booking__c = booking.Id;
            payOj.Payment_Type__c = 'Cheque';
            payOj.Cheque_Transaction_Number__c = 'fgd';
            payOj.BankName__c = bankObj.Id;
            payOj.Receipt_No__c = '123456';
            insert payOj;
            
            Test.startTest();   
            pagereference pageref = page.LetterOfConfirmationAllotementLetter; 
            Test.setCurrentPage(pageRef);
            if(booking != null && booking.Id != null){
                pageRef.getParameters().put('id',String.valueOf(booking.id));
                ApexPages.StandardController sc = new ApexPages.StandardController(booking);
                AllotmentController Allot = New AllotmentController(sc);
            }
            else{
                System.debug('Booking id null');
            }
            
            Test.stopTest();
        }catch(Exception ex)
        {
            System.debug('Error');
        }
    }
}