@isTest
public class InterestCalculationBatchTest 
{   @isTest
    public static void testBatch()
    {   
        List<Payment_Milestones__c> paymentList = new List<Payment_Milestones__c>();
        List<Interest_Charged__c> interestList = new List<Interest_Charged__c>();
        
         Account accountObject = new Account();
        accountObject.Name = 'test Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '455546565';
        insert accountObject;
        
        Builder_Organisation__c bo = new Builder_Organisation__c();
        bo.Builder_Organisation_Initials__c = 'c';
        insert bo;
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Builder_Organization__c = bo.id;
        projectObject.Project_Initials__c= 'Test';
        projectObject.Last_Invoice_Number__c=1055150;
        insert projectObject;
        
        Project_Progress__c projectProgressObject = new Project_Progress__c();
        projectProgressObject.Name = 'test project';
        projectProgressObject.Project__c = projectObject.Id;
        projectProgressObject.Stage__c = 'Commencement';
        projectProgressObject.Stage_Type__c = 'Plinth';
        projectProgressObject.Progress_Status__c= 'Not Started';
        insert projectProgressObject;
          
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        insert oppoObject;
     
        Booking__c bookingObjects= new Booking__c();
        bookingObjects.Primary_Applicant__c = accountObject.Id;
        bookingObjects.Related_Opportunity__c = oppoObject.Id;
        //booking.Related_Suggested_Property__c = suggestedProperty.Id;
        bookingObjects.Project_Name__c = projectObject.Id;
        insert bookingObjects;
        
        Co_Applicant__c COAPP = New Co_Applicant__c();
        COAPP.Role__c = 'Co-Applicant';
        COAPP.Account__c = accountObject.Id;
        COAPP.Booking__c = bookingObjects.Id;
        Insert COAPP;
        
        Price_Details__c priceDetailObject = new Price_Details__c();
        priceDetailObject.Name = 'Price Test1';
        priceDetailObject.Charge_Group__c= 'Agreement';
        priceDetailObject.GST_Type__c = 'Standard';
        priceDetailObject.Booking__c = bookingObjects.Id;
        priceDetailObject.Amount__c = 64000;
        insert priceDetailObject;
        
        Price_Details__c priceDetailObject1 = new Price_Details__c();
        priceDetailObject1.Name = 'Price Test';
        priceDetailObject1.Charge_Group__c= 'Agreement';
        priceDetailObject1.GST_Type__c = 'Standard' ;
        priceDetailObject1.Booking__c = bookingObjects.Id;
        priceDetailObject1.Amount__c = 60000;
        insert priceDetailObject1;
        
        Bank__c Bank = New Bank__c();
        Bank.Name = 'PNB Bank';
        insert Bank;
        
       
        
        Payment_Milestones__c PM = New Payment_Milestones__c();
        PM.Booking__c = bookingObjects.Id;
        PM.Name = 'Test Milestone';
        PM.Due_Date__c = date.today()-5;
        PM.GST_Amount1__c = 45000;
        PM.Sequence_No__c = 1;
        PM.Milestone_age__c = 10;
        PM.Milestone_Amount1__c = 7800000;
        PM.Milestone_Status__c ='Active';
        
        Insert PM;

        /*
        
        Payment_Milestones__c milestone = new Payment_Milestones__c(Name= 'Milestone Test1',Milestone_Status__c ='Active',Due_Date__c = Date.today()-5,Booking__c= bookingObjects.Id,Milestone_age__c=10,Sequence_No__c=1);
        paymentList.add(milestone);
          
        Payment_Milestones__c milestone2 = new Payment_Milestones__c(Name= 'Milestone Test2',Milestone_Status__c ='Active',Due_Date__c = Date.today()-10,Booking__c= bookingObjects.Id,Milestone_age__c=10,Sequence_No__c=2);
        paymentList.add(milestone2);
        
        Payment_Milestones__c milestone3 = new Payment_Milestones__c(Name= 'Milestone Test3',Milestone_Status__c ='Active',Due_Date__c = Date.today()-15,Booking__c= bookingObjects.Id,Milestone_age__c=10,Sequence_No__c=3);
        paymentList.add(milestone3);
       
      
        insert paymentList;
        
          System.debug('Remaining AMT-->'+PM.Remaining_Amount__c);
        */ 
        
        Interest_Charged__c interest = new Interest_Charged__c(Milestone__c=PM.id,From_Date__c=Date.today()-20,To_Date__c=Date.today(),Interest_Rate__c=8);
        insert interest;
        Interest_Charged__c interest2 = new Interest_Charged__c(Milestone__c=PM.id,From_Date__c=Date.today()-10,To_Date__c=Date.today(),Interest_Rate__c=0.12);
        insert interest2;
     
        Test.startTest();
            InterestCalculationBatch batch = new InterestCalculationBatch(); 
        
            database.executebatch(batch);
        Test.stopTest();
    }
}