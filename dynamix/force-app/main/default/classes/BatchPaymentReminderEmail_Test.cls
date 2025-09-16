@isTest()
public class BatchPaymentReminderEmail_Test {

    @isTest static void BatchPaymentReminderEmail_test(){
        List<Payment_Milestones__c> paymentList = new List<Payment_Milestones__c>();
        List<Interest_Charged__c> interestList = new List<Interest_Charged__c>();
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account accountObject  = new Account(
          RecordTypeID=recordTypeId ,
          FirstName='Test FName',
          LastName='Test LName',
          PersonMailingStreet='test@yahoo.com',
          PersonMailingPostalCode='12345',
          PersonMailingCity='SFO',
          PersonEmail='test@yahoo.com',
          PersonHomePhone='1234567',
          PersonMobilePhone='12345678' 
        );
        
       // Profile p1=[SELECT Id From Profile WHERE Name='Post Sales'];
        Profile p1=[SELECT Id From Profile WHERE Name='Sales Manager'];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User u2 =new User( Alias = uniqueName.substring(18, 23),
                            Email = uniqueName + '@test' + orgId + '.org',
                            EmailEncodingKey = 'UTF-8',
                            LastName = 'Testing',
                            Username = uniqueName + '@test' + orgId + '.org',
                            LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', // changed for to avoid: INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST, Locale: bad value for restricted picklist field: America/Los_Angeles
                            
                            ProfileId=p1.Id,
                            TimeZoneSidKey    = 'America/Los_Angeles');
        insert u2;  
            
        Project__c projObj = new Project__c();
        projObj.Name = 'test project';
        projObj.Last_Invoice_Number__c = 1;
        projobj.Post_Sales_Head__c = u2.Id;
        projobj.Budgets__c = 'above 3.5 crs';
        projobj.Configuration__c = '1 BHK';
        projobj.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        insert projObj;
       
        insert accountObject ;
        
        Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting');
        testOpportunity.AccountId = accountObject.Id;
        testOpportunity.Budget1__c = 'Under 75 lakhs';
        testOpportunity.Construction_Status__c = 'RTMI';
        testOpportunity.Interested_Configuration__c = '1 BHK';
        testOpportunity.Nature_of_Use__c ='';
        testOpportunity.Source_of_Funding__c = '';
        testOpportunity.Carpet_Area_in_sq_mts__c = 89.77;
        testOpportunity.AccountId = accountObject.Id;
        testOpportunity.Name = 'Test1';
        testOpportunity.StageName = 'Open';
        testOpportunity.Referral_Name__c = 'Test demo';
        testOpportunity.CloseDate = system.today();
        testOpportunity.Email_Id__c = 'TEst@gmail.com';
        testOpportunity.Phone__c = '8987676568';
        testOpportunity.Project__c = projObj.Id;
        testOpportunity.OwnerId =  u2.Id;
        testOpportunity.Date_of_Site_Visit__c = System.today();
        testOpportunity.Walk_in_Source__c = 'PreSales';
        testOpportunity.Sales_Manager__c = u2.id;
        insert testOpportunity;


        Booking__c bookingObjects = new Booking__c();
        
        bookingObjects.Stage__c = 'Draft';
        bookingObjects.Primary_Applicant__c=accountObject.id;
        bookingObjects.Project_Name__c = projObj.id;
        bookingObjects.OwnerId = projobj.Post_Sales_Head__c;
        bookingObjects.Sales_Manager__c =testOpportunity.ownerId;
        bookingObjects.Related_Opportunity__c = testOpportunity.id;
        insert bookingObjects;
        
        Price_Details__c p = new  Price_Details__c();
        p.Charge_Group__c='Agreement';
        p.Amount__c=100000000;
        p.Booking__c=bookingObjects.id;
        insert p;
            
        Project_Progress__c projectProgressObject = new Project_Progress__c();
        projectProgressObject.Name = 'test6543';
        projectProgressObject.Project__c = projObj.Id;
        projectProgressObject.Stage_Type__c = 'Sliding';
        projectProgressObject.Progress_Status__c = 'Completed';
        projectProgressObject.Invoice_Date__c = Date.today() - 7;
        projectProgressObject.Architect_Certification_Received_Date__c = Date.today();
        projectProgressObject.Architecture_Certificate__c = true;
        insert projectProgressObject;
            
        
            
            
        Payment_Milestones__c milestone = new Payment_Milestones__c(Milestone_Amount1__c=10000,GST_Amount1__c=1000,Name= 'Milestone Test1',Project_Progress__c=projectProgressObject.id,Due_Date__c = Date.today()-15,Booking__c= bookingObjects.Id,Milestone_age__c=10,Sequence_No__c=1);
        paymentList.add(milestone);
        insert paymentList;
       
        paymentList = [select Name,Due_Date__c,Invoice_Email_Sent__c,Milestone_Amount1__c ,Payment_Received__c,Remaining_Amount__c from Payment_Milestones__c where id= :paymentList[0].id];
      Test.startTest();
            BatchPaymentReminderEmail batch = new BatchPaymentReminderEmail(); 
            database.executebatch(batch);
        Test.stopTest();
        }
}