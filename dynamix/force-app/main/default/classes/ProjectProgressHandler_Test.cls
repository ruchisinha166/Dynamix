@isTest
public class ProjectProgressHandler_Test {
    @isTest public static void projectProgressTestMethod()
    {   
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile pId = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];        
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
        
        Account accountObject = new Account();
        accountObject.Name = 'test Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '455546565';
        insert accountObject;
        
        Builder_Organisation__c bo = new Builder_Organisation__c();
        bo.Builder_Organisation_Initials__c = 'c';
        insert bo;
        
        Project__c projObj = new Project__c();
        projObj.Name = 'test project';
        projObj.Builder_Organization__c = bo.id;
        projObj.Project_Initials__c = 'c';
        projObj.Project_Email__c= 'harshita.sharma@manras.com';
        projObj.Project_Carpet_Area__c = '475 - 1 BHK';
        projObj.Budgets__c = 'Under 75 lakhs';
        projObj.Configuration__c ='1 BHK';
        projObj.OTP_Disable_Till__c = System.now().addDays(1);
        projObj.Project_Header__c = 'abc.com';
        insert projObj;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.KYC_Completed__c = true;
        oppoObject.Project__c = projObj.Id;
        oppoObject.Walk_in_Source__c ='Presales' ;
        insert oppoObject;
        
        List<Project_Progress__c> progressList = new List<Project_Progress__c>(); 
        Project_Progress__c projectProgressObject = new Project_Progress__c();
        projectProgressObject.Name = 'test6543';
        projectProgressObject.Project__c = projObj.Id;
        projectProgressObject.Stage_Type__c = 'Sliding';
        projectProgressObject.Progress_Status__c = 'Completed';
        projectProgressObject.Invoice_Date__c = Date.today();
        projectProgressObject.Architect_Certification_Received_Date__c = Date.today();
        projectProgressObject.Architecture_Certificate__c = true;
        insert projectProgressObject;
        progressList.add(projectProgressObject);
        
        
        
        Booking__c bookingObject = new Booking__c();
        bookingObject.Stage__c= 'Draft';
        bookingObject.Project_Name__c = projObj.id;
        bookingObject.Primary_Applicant__c = accountObject.Id;
        bookingObject.Sales_Manager__c = testUserRcd1.id;
        bookingObject.Related_Opportunity__c = oppoObject.id;
        insert bookingObject;
        
        Co_Applicant__c COP = New Co_Applicant__c();
        COP.Booking__c = bookingObject.Id;
        COP.Account__c = accountObject.Id;
        COP.Role__c = 'Primary';
        Insert COP;
        
        
        Price_Details__c priceDetailObject = new Price_Details__c();
        priceDetailObject.Name = 'Price Test1';
        priceDetailObject.Charge_Group__c= 'Agreement';
        priceDetailObject.GST_Type__c = 'Standard';
        priceDetailObject.Booking__c = bookingObject.Id;
        priceDetailObject.Amount__c = 64000;
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= 'Agreement';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = bookingObject.Id;
        priceDetailObject1.Amount__c = 60000;
        insert priceDetailObject1;
        
        Payment_Milestones__c paymentObject = new Payment_Milestones__c();
        paymentObject.Name = 'Test Milestone';
        paymentObject.Project_Progress__c = projectProgressObject.Id;
        paymentObject.Booking__c = bookingObject.Id ;
        paymentObject.Milestone_age__c = 10;
        paymentObject.Sequence_No__c= 2;
        insert paymentObject;
        
        Test.startTest();
        ProjectProgressHandler.projectMethod(progressList);
        Test.stopTest();
    }
}