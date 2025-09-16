@isTest
public class EnquiryStateChangeHandlerTest {

    @isTest public static void method1(){ 
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        BusinessHours bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];
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
       
        Account accountObject1 = new Account();
        accountObject1.name = 'test';
        accountObject1.recordtypeId = '0125g000000d990AAA';
        accountObject1.CP_Firm_Name__c = 'India';
        accountObject1.Phone = '4555465654';
        accountObject1.Email__c = 'dynamt.project@gmail.com';
        accountObject1.Firm_Type__c = 'Proprietor';
        
        accountObject1.RERA_Number__c = 'wre546';
        
        insert accountObject1;
        contact c1 = new contact();
        c1.lastName ='test';
        c1.AccountId = accountObject1.id;
        insert c1;
        
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        insert projectObject;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject1.Id;
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
        oppoObject.Sales_Manager__c = testUserRcd1.Id;
        oppoObject.Date_of_Site_Visit__c = System.today();
        oppoObject.Walk_in_Source__c = 'Referred by Existing Customer';
        oppoObject.Project__c = projectObject.Id;
        insert oppoObject;
        
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
        testEnqRcd.Contact_Person__c=accountObject1.Id;
        testEnqRcd.Enquiry_Source__c='Google';
        testEnqRcd.Campaign__c=testCampRcd.Id;
        testEnqRcd.Country_Code__c= '+91';
		testEnqRcd.Primary_Mobile_Number__c = '1234567890';
        //testEnqRcd.Primary_Mobile_Number_Text__c='1234567890';
        testEnqRcd.OwnerId=testUserRcd1.Id;
        insert testEnqRcd;
        
        Task tsk = new Task();
        tsk.Subject = 'Missed Call';
        tsk.Status = 'Pending';
        tsk.Priority = 'Normal';
        tsk.WhatId = testEnqRcd.Id;
        tsk.OwnerId = testUserRcd1.Id;
        tsk.ActivityDate = system.today();
        tsk.Description = 'abc';
        tsk.Call_Status__c ='Connected';
        tsk.Description_Check__c = true;
        insert tsk;
        List<Task> taskList = new List<Task>();
        taskList.add(tsk);
        map<id, task > oldmap = new map<id, task>();
        oldmap.put(tsk.id,new Task(Call_Status__c = ''));
     Test.startTest();
        EnquiryStateChangeHandler.main(taskList,oldmap);
        
        test.stopTest();
    }
}