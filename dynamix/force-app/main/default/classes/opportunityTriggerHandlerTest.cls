@isTest
public class opportunityTriggerHandlerTest {
    
    @isTest 
    public static void method1(){
        Account accountObject = new Account();
        accountObject.FirstName = 'test';
        accountObject.LastName = 'Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '4555465654';
        accountObject.PersonEmail = 'dynamt.project@gmail.com';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.RERA_Number__c = 'wre546';
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.PersonMobilePhone = '123456789';
        insert accountObject;
        
        Account accountObject1 = new Account();
        accountObject1.name = 'test';
        accountObject1.recordtypeId = '0125g000000d990AAA';
        
        accountObject1.CP_Firm_Name__c = 'India';
        accountObject1.Phone = '4555465654';
        accountObject1.Email__c = 'dynamt.project@gmail.com';
        accountObject1.Firm_Type__c = 'Proprietor';

        accountObject1.RERA_Number__c = 'wre546';
        
        insert accountObject1;
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        insert projectObject;
        
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
        
        Channel_Partner_Project__c channleObject = new Channel_Partner_Project__c();
        channleObject.Channel_Partner__c = accountObject1.Id;
        channleObject.project__c = projectObject.Id;
        insert channleObject;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Channel_Partner__c = accountObject1.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Budget1__c = 'Under 75 lakhs';
        oppoObject.Construction_Status__c = 'RTMI';
        oppoObject.Interested_Configuration__c = '1 BHK';
        oppoObject.Nature_of_Use__c ='';
        oppoObject.Source_of_Funding__c = '';
        oppoObject.Carpet_Area_in_sq_mts__c = 89.77;
        oppoObject.Email_Id__c = 'TEst@gmail.com';
        oppoObject.Phone__c = '8987676568';
        oppoObject.Project__c = projectObject.Id;
        oppoObject.Sales_Manager__c = testUserRcd1.Id;
        oppoObject.Date_of_Site_Visit__c = Date.newInstance(2023, 10, 17);
        oppoObject.Walk_in_Source__c = 'Referred by Existing Customer';
        oppoObject.EOI_CA__c = 'EOI';
        insert oppoObject;
        list<opportunity> oppList = new List<opportunity>();
        oppList.add(oppoObject);
        
        Opportunity oppoObject2 = new Opportunity();
        oppoObject2.AccountId = accountObject.Id;
        oppoObject2.Name = 'test Opportunity';
        oppoObject2.StageName = 'Site Visit';
        oppoObject2.CloseDate = System.Today()+3;
        oppoObject2.Budget1__c = 'Under 75 lakhs';
        oppoObject2.Construction_Status__c = 'RTMI';
        oppoObject2.Interested_Configuration__c = '1 BHK';
        oppoObject2.Nature_of_Use__c ='';
        oppoObject2.Source_of_Funding__c = '';
        oppoObject2.Carpet_Area_in_sq_mts__c = 89.77;
        oppoObject2.Email_Id__c = 'TEst@gmail.com';
        oppoObject2.Phone__c = '8987676568';
        oppoObject2.Project__c = projectObject.Id;
        oppoObject2.Sales_Manager__c = testUserRcd1.Id;
        oppoObject2.Date_of_Site_Visit__c = Date.newInstance(2023, 10, 17);
        oppoObject2.Walk_in_Source__c = 'Referred by Existing Customer';
        insert oppoObject2;
        Map<id,opportunity> oppOldMap = new Map<id,Opportunity>();
        oppOldMap.put(oppoObject2.id, oppoObject2);
        
        Task_Target__c taskTarget = new Task_Target__c();
        taskTarget.User__c = oppoObject.ownerID;
        taskTarget.Month__c = 'October';//ce with your desired month
        taskTarget.Type__c = 'Unique-Revisits';
        taskTarget.Year__c = '2023'; // Replace with your desired year
        taskTarget.Number_of_Targets_Achievement__c = 5; // Replace with your desired values
        taskTarget.Project__c = projectObject.Id;
        taskTarget.Number_of_Connected_Call__c = 10; // Replace with your desired values
        taskTarget.No_of_Walk_ins__c = 20; // Replace with your desired values
        taskTarget.No_of_Follow_Ups__c = 15; // Replace with your desired values
        taskTarget.Number_of_Targets__c = 12;
        insert taskTarget;
        
        Test.startTest();
        OpportunityTriggerHandler.countOpportunityAndAddOnTaskTarget(oppList);
        Test.stoptest();
    }
    
    @isTest
    public static void method2(){
        Account accountObject = new Account();
        accountObject.FirstName = 'test';
        accountObject.LastName = 'Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '4555465654';
        accountObject.PersonEmail = 'dynamt.project@gmail.com';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.RERA_Number__c = 'wre546';
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.PersonMobilePhone = '123456789';
        insert accountObject;
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        insert projectObject;
        
        Project__c projectObject2 = new Project__c();
        projectObject2.Name = 'Test Project';
        projectObject2.Project_Email__c= 'mayur.patel@manras.com';
        projectObject2.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject2.Budgets__c = 'Under 75 lakhs';
        projectObject2.Configuration__c ='1 BHK';
        insert projectObject2;
        
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
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Budget1__c = 'Under 75 lakhs';
        oppoObject.Construction_Status__c = 'RTMI';
        oppoObject.Interested_Configuration__c = '1 BHK';
        oppoObject.Nature_of_Use__c ='';
        oppoObject.Source_of_Funding__c = '';
        oppoObject.Carpet_Area_in_sq_mts__c = 89.77;
        oppoObject.Email_Id__c = 'TEst@gmail.com';
        oppoObject.Phone__c = '8987676568';
        oppoObject.Project__c = projectObject.Id;
        oppoObject.Sales_Manager__c = testUserRcd1.Id;
        oppoObject.Date_of_Site_Visit__c = system.today();
        oppoObject.Walk_in_Source__c = 'Referred by Existing Customer';
        oppoObject.Approval_Status__c ='Approved';
        insert oppoObject;
        
        list<opportunity> oppList = new List<opportunity>();
        oppList.add(oppoObject);
        oppoObject.Approval_Status__c = 'Rejected';
        oppoObject.Project__c = projectObject2.id;
        update oppoObject;
        
        Map<id,opportunity> oppOldMap = new Map<id,Opportunity>();
        oppOldMap.put(oppoObject.id, oppoObject);
        
        // Create a ProcessInstance for each Opportunity (assuming that Process Builder/Flow handles approvals)
        ProcessInstance processInstance1 = new ProcessInstance();
        processInstance1.TargetObjectId = oppoObject.Id;
        //insert processInstance1;
        // Create ProcessInstanceStep records for the ProcessInstances
        ProcessInstanceStep step1 = new ProcessInstanceStep();
        step1.ProcessInstanceId = processInstance1.Id;
        step1.StepStatus = 'Approved'; // Set to 'Approved'
        // Don't set the comments field to simulate a null value
      //  insert step1;
        
        test.startTest();
        OpportunityTriggerHandler.makeCommentMandatory(oppList ,oppOldMap);
        test.stopTest();
        
        
    }
}