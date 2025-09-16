@isTest
public class BankLoanDetailsTriggerHandler_Test {
    @isTest
    static void generateWelcomeLetterTest(){
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
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.PersonMobilePhone = '6576743214';
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
        planComponentObject.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject.Price_Lumpsum__c  = 200;
        planComponentObject.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject;

        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.Welcome_Email_Checker__c = false;
        booking.Shared_SDR_Letter__c = false;
        booking.Primary_Secondary_info_Updated__c = false;
        booking.Allotment_Letter_Sent__c = false;
        insert booking;
        
        Booking_Line_Items__c bookingLineObjects = new Booking_Line_Items__c();
        bookingLineObjects.Booking__c = booking.Id;
        bookingLineObjects.Project_Add_On_Charges__c = projectAddbject1.Id;
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

        Bank__c Bank = New Bank__c();
        Bank.Name = 'ICICI Bank Ltd';
        insert Bank;
        
        Bank__c Bank1 = New Bank__c();
        Bank1.Name = 'HDFC Bank';
        insert Bank1;
        
        Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
        BLD.Home_LoanInstitution__c = Bank.Id;
        BLD.Booking__c = booking.Id;
        BLD.Sanction_Status__c ='In Progress';
        BLD.Sanction_Letter_No_File_Number__c ='4654756';
        BLD.Sanction_Letter__c = False;
      
      //  BLD.Loan_Closure_Reason__c = 'Test Closure Reason';
        BLD.Loan_Closed_Date__c = null;
        BLD.Loan_Status__c = 'In Progress';
        BLD.Interest_Rate__c = 4;
        BLD.Home_Loan_Representative__c = 'DRD';
        BLD.Pari_Passu__c = false;
        BLD.Bank_NOC_Date__c = System.today();
        BLD.Home_Loan_Institution__c = 'State Bank of India';
        BLD.Loan_Remarks__c = 'Test Remarks';
        BLD.Loan_Closure_Reason__c = 'Transferred';
        BLD.Bank_Returned_NOC_Uploaded__c = True;
        BLD.Bank_Returned_ROC_Uploaded__c = True;
        BLD.Loan_Closure_Letter_Uploaded__c = True;
        Insert BLD;
        
        
        BLD.Sanction_Letter__c = True;
        BLD.Sanction_Letter_No_File_Number__c ='4654756';
        BLD.Sanction_Status__c ='Sanctioned';
        BLD.Pari_Passu__c = true;
        update BLD;
        
        BLD.Loan_Status__c = 'Closed';
        try{
            update BLD;
        }
        Catch(Exception ex)
        {
            system.debug('Error');
        }
        List<Bank_Loan_Details__c> BLDList = new List<Bank_Loan_Details__c>();
        BLDList.add(BLD);
        
        Map<Id,Bank_Loan_Details__c> BLDMap = new Map<Id,Bank_Loan_Details__c>();
        BLDMap.put(BLD.Id,BLD);
        BankLoanDetailsTriggerHandler.handleLoanStatus(BLDList);
        BankLoanDetailsTriggerHandler.handleLoanStatusUpdate(BLDList,BLDMap);
    }
     @isTest
    static void generateWelcomeLetterTest1(){
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
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.PersonMobilePhone = '6576743214';
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
        planComponentObject.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject.Price_Lumpsum__c  = 200;
        planComponentObject.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject;

        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.Welcome_Email_Checker__c = false;
        booking.Shared_SDR_Letter__c = false;
        booking.Primary_Secondary_info_Updated__c = false;
        booking.Allotment_Letter_Sent__c = false;
        insert booking;
        
        Booking_Line_Items__c bookingLineObjects = new Booking_Line_Items__c();
        bookingLineObjects.Booking__c = booking.Id;
        bookingLineObjects.Project_Add_On_Charges__c = projectAddbject1.Id;
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

        Bank__c Bank = New Bank__c();
        Bank.Name = 'ICICI Bank Ltd';
        insert Bank;
        
        Bank__c Bank1 = New Bank__c();
        Bank1.Name = 'HDFC Bank';
        insert Bank1;
        
        Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
        BLD.Home_LoanInstitution__c = Bank.Id;
        BLD.Booking__c = booking.Id;
        BLD.Sanction_Status__c ='In Progress';
        BLD.Sanction_Letter_No_File_Number__c ='4654756';
        BLD.Sanction_Letter__c = False;
      
      //  BLD.Loan_Closure_Reason__c = 'Test Closure Reason';
        BLD.Loan_Closed_Date__c = null;
        BLD.Loan_Status__c = 'In Progress';
        BLD.Interest_Rate__c = 4;
        BLD.Home_Loan_Representative__c = 'DRD';
        BLD.Pari_Passu__c = false;
        BLD.Bank_NOC_Date__c = System.today();
        BLD.Home_Loan_Institution__c = 'State Bank of India';
        BLD.Loan_Remarks__c = 'Test Remarks';
      //  BLD.Loan_Closure_Reason__c = 'Transferred';
        BLD.Bank_Returned_NOC_Uploaded__c = True;
        BLD.Bank_Returned_ROC_Uploaded__c = True;
        BLD.Loan_Closure_Letter_Uploaded__c = True;
        Insert BLD;
        
        
        Bank_Loan_Details__c BLD1 = New Bank_Loan_Details__c();
        BLD1.Home_LoanInstitution__c = Bank.Id;
        BLD1.Booking__c = booking.Id;
        BLD1.Sanction_Status__c ='In Progress';
        BLD1.Sanction_Letter_No_File_Number__c ='4654756';
        BLD1.Sanction_Letter__c = False;
      
      //  BLD.Loan_Closure_Reason__c = 'Test Closure Reason';
        BLD1.Loan_Closed_Date__c = null;
        BLD1.Loan_Status__c = 'In Progress';
        BLD1.Interest_Rate__c = 4;
        BLD1.Home_Loan_Representative__c = 'DRD';
        BLD1.Pari_Passu__c = false;
        BLD1.Bank_NOC_Date__c = System.today();
        BLD1.Home_Loan_Institution__c = 'State Bank of India';
        BLD1.Loan_Remarks__c = 'Test Remarks';
      //  BLD.Loan_Closure_Reason__c = 'Transferred';
        BLD1.Bank_Returned_NOC_Uploaded__c = True;
        BLD1.Bank_Returned_ROC_Uploaded__c = True;
        BLD1.Loan_Closure_Letter_Uploaded__c = True;
        Insert BLD1;
        List<Bank_Loan_Details__c> newBLDList = new List<Bank_Loan_Details__c>();
        newBLDList.add(BLD);
        
        List<Bank_Loan_Details__c> oldBLDList = new List<Bank_Loan_Details__c>();
        oldBLDList.add(BLD1);
        
        Map<Id,Bank_Loan_Details__c> BLDMap = new Map<Id,Bank_Loan_Details__c>();
        BLDMap.put(BLD1.ID,BLD1);
        
        
        BLD.Sanction_Letter__c = True;
        BLD.Sanction_Letter_No_File_Number__c ='4654756';
        BLD.Sanction_Status__c ='Sanctioned';
        BLD.Pari_Passu__c = true;
        update BLD;
        
        BLD.Loan_Status__c = 'Closed';
        try{
            update BLD;
        }
        Catch(Exception ex)
        {
            system.debug('Error');
        }
        
        
        
        BankLoanDetailsTriggerHandler.handleLoanStatus(newBLDList);
       // BankLoanDetailsTriggerHandler.handleLoanStatusUpdate(newBLDList,BLDMap);
    }
    @isTest
    static void generateWelcomeLetterTest3(){
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
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.PersonMobilePhone = '6576743214';
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
        planComponentObject.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject.Price_Lumpsum__c  = 200;
        planComponentObject.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject;

        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.Welcome_Email_Checker__c = false;
        booking.Shared_SDR_Letter__c = false;
        booking.Primary_Secondary_info_Updated__c = false;
        booking.Allotment_Letter_Sent__c = false;
        insert booking;
        
        Booking_Line_Items__c bookingLineObjects = new Booking_Line_Items__c();
        bookingLineObjects.Booking__c = booking.Id;
        bookingLineObjects.Project_Add_On_Charges__c = projectAddbject1.Id;
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

        Bank__c Bank = New Bank__c();
        Bank.Name = 'ICICI Bank Ltd';
        insert Bank;
        
        Bank__c Bank1 = New Bank__c();
        Bank1.Name = 'HDFC Bank';
        insert Bank1;
        
        Bank_Loan_Details__c BLD1 = New Bank_Loan_Details__c();
        BLD1.Home_LoanInstitution__c = Bank.Id;
        BLD1.Booking__c = booking.Id;
        BLD1.Sanction_Status__c ='In Progress';
        BLD1.Sanction_Letter_No_File_Number__c ='4654756';
        BLD1.Sanction_Letter__c = False;
        BLD1.Pari_Passu__c = true;
        insert BLD1;
        
        Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
        BLD.Home_LoanInstitution__c = Bank.Id;
        BLD.Booking__c = booking.Id;
        BLD.Sanction_Status__c ='In Progress';
        BLD.Sanction_Letter_No_File_Number__c ='4654756';
        BLD.Sanction_Letter__c = False;
      
      //  BLD.Loan_Closure_Reason__c = 'Test Closure Reason';
        BLD.Loan_Closed_Date__c = null;
        BLD.Loan_Status__c = 'In Progress';
        BLD.Interest_Rate__c = 4;
        BLD.Home_Loan_Representative__c = 'DRD';
        BLD.Pari_Passu__c = false;
        BLD.Bank_NOC_Date__c = System.today();
        BLD.Home_Loan_Institution__c = 'State Bank of India';
        BLD.Loan_Remarks__c = 'Test Remarks';
        BLD.Loan_Closure_Reason__c = 'Transferred';
        BLD.Bank_Returned_NOC_Uploaded__c = True;
        BLD.Bank_Returned_ROC_Uploaded__c = True;
        BLD.Loan_Closure_Letter_Uploaded__c = True;
        BLD.Pari_Passu__c = true;
        try{
            Insert BLD;
        }
        catch(Exception ex)
        {
            system.debug('Error');
        }
        
        
       /* BLD.Sanction_Letter__c = True;
        BLD.Sanction_Letter_No_File_Number__c ='4654756';
        BLD.Sanction_Status__c ='Sanctioned';
        BLD.Pari_Passu__c = false;
        update BLD;
        
        BLD.Loan_Status__c = 'Closed';
        try{
            update BLD;
        }
        Catch(Exception ex)
        {
            system.debug('Error');
        }
        List<Bank_Loan_Details__c> BLDList = new List<Bank_Loan_Details__c>();
        BLDList.add(BLD);
        
        Map<Id,Bank_Loan_Details__c> BLDMap = new Map<Id,Bank_Loan_Details__c>();
        BLDMap.put(BLD.Id,BLD);
        BankLoanDetailsTriggerHandler.handleLoanStatus(BLDList);
        BankLoanDetailsTriggerHandler.handleLoanStatusUpdate(BLDList,BLDMap);*/
    }
     @isTest
    static void generateWelcomeLetterTest4(){
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
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.PersonMobilePhone = '6576743214';
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
        planComponentObject.Project_Add_On_Charges__c = projectAddbject1.Id;
        planComponentObject.Price_Lumpsum__c  = 200;
        planComponentObject.Pricing_Plan__c = propertyObject.Property_Price_Slab__c;
        insert planComponentObject;

        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.Welcome_Email_Checker__c = false;
        booking.Shared_SDR_Letter__c = false;
        booking.Primary_Secondary_info_Updated__c = false;
        booking.Allotment_Letter_Sent__c = false;
        insert booking;
        
        Booking_Line_Items__c bookingLineObjects = new Booking_Line_Items__c();
        bookingLineObjects.Booking__c = booking.Id;
        bookingLineObjects.Project_Add_On_Charges__c = projectAddbject1.Id;
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

        Bank__c Bank = New Bank__c();
        Bank.Name = 'ICICI Bank Ltd';
        insert Bank;
        
        Bank__c Bank1 = New Bank__c();
        Bank1.Name = 'HDFC Bank';
        insert Bank1;
       
        Bank_Loan_Details__c BLD = New Bank_Loan_Details__c();
        BLD.Home_LoanInstitution__c = Bank.Id;
        BLD.Booking__c = booking.Id;
        BLD.Sanction_Status__c ='In Progress';
        BLD.Sanction_Letter_No_File_Number__c ='4654756';
        BLD.Sanction_Letter__c = False;
      
      //  BLD.Loan_Closure_Reason__c = 'Test Closure Reason';
        BLD.Loan_Closed_Date__c = null;
        BLD.Loan_Status__c = 'In Progress';
        BLD.Interest_Rate__c = 4;
        BLD.Home_Loan_Representative__c = 'DRD';
        BLD.Pari_Passu__c = false;
        BLD.Bank_NOC_Date__c = System.today();
        BLD.Home_Loan_Institution__c = 'State Bank of India';
        BLD.Loan_Remarks__c = 'Test Remarks';
        BLD.Loan_Closure_Reason__c = 'Transferred';
        BLD.Bank_Returned_NOC_Uploaded__c = True;
        BLD.Bank_Returned_ROC_Uploaded__c = True;
        BLD.Loan_Closure_Letter_Uploaded__c = True;
        BLD.Pari_Passu__c = true;
        Insert BLD;
        
        BLD.Sanction_Letter__c = True;
        BLD.Sanction_Letter_No_File_Number__c ='4654756';
        BLD.Sanction_Status__c ='Sanctioned';
        BLD.Pari_Passu__c = false;
        update BLD;
        
        BLD.Loan_Status__c = 'Closed';
        try{
            update BLD;
        }
        Catch(Exception ex)
        {
            system.debug('Error');
        }
        List<Bank_Loan_Details__c> BLDList = new List<Bank_Loan_Details__c>();
        BLDList.add(BLD);
        
        Map<Id,Bank_Loan_Details__c> BLDMap = new Map<Id,Bank_Loan_Details__c>();
        BLDMap.put(BLD.Id,BLD);
        BankLoanDetailsTriggerHandler.handleLoanStatus(BLDList);
        BankLoanDetailsTriggerHandler.handleLoanStatusUpdate(BLDList,BLDMap);
    }
}