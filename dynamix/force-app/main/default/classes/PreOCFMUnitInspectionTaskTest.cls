@isTest
private class PreOCFMUnitInspectionTaskTest {
    @isTest static void scheduleEmailTest(){


        Test.startTest();
        SchedulePreOCFMUnitInspectionTask SERB = New SchedulePreOCFMUnitInspectionTask();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test schedule', sch, SERB);
        Test.stopTest();
    }

    @isTest
    static void testBatchExecution1() {
        Id userProfileId = UserInfo.getProfileId();
        
        Profile userProfile  = [SELECT Id, Name, CreatedDate, LastModifiedDate FROM Profile WHERE Id = :userProfileId];
        UserRole smUserRole = new UserRole(Name='S&M Head');
        UserRole promUserRole = new UserRole(Name='Promoter');
        
        User smUser = new User();
        smUser.Alias = 'standt';
        smUser.Email = 'smuser@test.com';
        smUser.EmailEncodingKey = 'UTF-8';
        smUser.LastName = 'Testing SM';
        smUser.LanguageLocaleKey = 'en_Us';
        smUser.ProfileId = userProfile.Id;
        smUser.LocaleSidKey = 'en_US';
        smUser.TimeZoneSidKey = 'America/Los_Angeles';
        smUser.UserName='SMTESTUSER@test.com';
        smUser.UserRoleId = smUserRole.Id;
        insert smUser;

        User promUser = new User();
        promUser.Email = 'promoter@test.com';
        promUser.UserRoleId = promUserRole.Id;
        promUser.EmailEncodingKey='UTF-8';
        promUser.LastName='Testing Prom';
        promUser.LanguageLocaleKey='en_US';
        promUser.LocaleSidKey='en_US';
        promUser.TimeZoneSidKey='America/Los_Angeles';
        promUser.UserName='PROMTESTUSER@test.com';
        promUser.Alias = 'promAlia';
        promUser.ProfileId = userProfile.Id;
		insert promUser;
        
        User projHead = [Select Id,Name From User LIMIT 1];
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        projectObject.Budgets__c = '76  lakhs - 1.25 crs';
        projectObject.Configuration__c ='3 BHK';
        projectObject.Project_Head__c = projHead.Id;
        insert projectObject;
        
        Property__c testProperty = new Property__c();
        testProperty.Name = 'Test Property';
        testProperty.FM_User__c = smUser.Id;
        testProperty.Project__c = projectObject.Id;
        insert testProperty;

        Task testTask = new Task();
        testTask.Subject = 'Pre-OC FM Review Task';
        testTask.ActivityDate = Date.Today().addDays(-1);
        testTask.WhatId = testProperty.Id;
        insert testTask;
        
        
        Test.startTest();
        Database.executeBatch(new PreOCFMUnitInspectionTask());
        Test.stopTest();
    }
    
    @isTest
    static void testBatchExecution2() {
        Id userProfileId = UserInfo.getProfileId();
        
        Profile userProfile  = [SELECT Id, Name, CreatedDate, LastModifiedDate FROM Profile WHERE Id = :userProfileId];
        UserRole smUserRole = new UserRole(Name='S&M Head');
        UserRole promUserRole = new UserRole(Name='Promoter');
        
        
        User smUser = new User();
        smUser.Alias = 'standt';
        smUser.Email = 'smuser@test.com';
        smUser.EmailEncodingKey = 'UTF-8';
        smUser.LastName = 'Testing SM';
        smUser.LanguageLocaleKey = 'en_Us';
        smUser.ProfileId = userProfile.Id;
        smUser.LocaleSidKey = 'en_US';
        smUser.TimeZoneSidKey = 'America/Los_Angeles';
        smUser.UserName='SMTESTUSER@test.com';
        smUser.UserRoleId = smUserRole.Id;
		 insert smUser;
        
        User promUser = new User();
        promUser.Email = 'promoter@test.com';
        promUser.UserRoleId = promUserRole.Id;
        promUser.EmailEncodingKey='UTF-8';
        promUser.LastName='Testing Prom';
        promUser.LanguageLocaleKey='en_US';
        promUser.LocaleSidKey='en_US';
        promUser.TimeZoneSidKey='America/Los_Angeles';
        promUser.UserName='PROMTESTUSER@test.com';
        promUser.Alias = 'promAlia';
        promUser.ProfileId = userProfile.Id;
		insert promUser;
        
        User projHead = [Select Id,Name From User LIMIT 1];
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        projectObject.Budgets__c = '76  lakhs - 1.25 crs';
        projectObject.Configuration__c ='3 BHK';
        projectObject.Project_Head__c = projHead.Id;
        insert projectObject;
        
        Property__c testProperty = new Property__c();
        testProperty.Name = 'Test Property';
        testProperty.FM_User__c = smUser.Id;
        testProperty.Project__c = projectObject.Id;
        insert testProperty;

        Task testTask = new Task();
        testTask.Subject = 'Pre-OC FM Review Task';
        testTask.ActivityDate = Date.Today().addDays(-3);
        testTask.WhatId = testProperty.Id;
        insert testTask;
        
        
        Test.startTest();
        Database.executeBatch(new PreOCFMUnitInspectionTask());
        Test.stopTest();
    }
    
    @isTest
    static void testBatchExecution3() {
       Id userProfileId = UserInfo.getProfileId();
        
        Profile userProfile  = [SELECT Id, Name, CreatedDate, LastModifiedDate FROM Profile WHERE Id = :userProfileId];
        UserRole smUserRole = new UserRole(Name='S&M Head');
        UserRole promUserRole = new UserRole(Name='Promoter');
        
        
        User smUser = new User();
        smUser.Alias = 'standt';
        smUser.Email = 'smuser@test.com';
        smUser.EmailEncodingKey = 'UTF-8';
        smUser.LastName = 'Testing SM';
        smUser.LanguageLocaleKey = 'en_Us';
        smUser.ProfileId = userProfile.Id;
        smUser.LocaleSidKey = 'en_US';
        smUser.TimeZoneSidKey = 'America/Los_Angeles';
        smUser.UserName='SMTESTUSER@test.com';
        smUser.UserRoleId = smUserRole.Id;
 		insert smUser;

        User promUser = new User();
        promUser.Email = 'promoter@test.com';
        promUser.UserRoleId = promUserRole.Id;
        promUser.EmailEncodingKey='UTF-8';
        promUser.LastName='Testing Prom';
        promUser.LanguageLocaleKey='en_US';
        promUser.LocaleSidKey='en_US';
        promUser.TimeZoneSidKey='America/Los_Angeles';
        promUser.UserName='PROMTESTUSER@test.com';
        promUser.Alias = 'promAlia';
        promUser.ProfileId = userProfile.Id;
		insert promUser;
        
        User projHead = [Select Id,Name From User LIMIT 1];
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        projectObject.Budgets__c = '76  lakhs - 1.25 crs';
        projectObject.Configuration__c ='3 BHK';
        projectObject.Project_Head__c = projHead.Id;
        insert projectObject;
        
        Property__c testProperty = new Property__c();
        testProperty.Name = 'Test Property';
        testProperty.FM_User__c = smUser.Id;
        testProperty.Project__c = projectObject.Id;
        insert testProperty;
		
        Task testTask = new Task();
        testTask.Subject = 'Pre-OC FM Review Task';
        testTask.ActivityDate = Date.Today().addDays(-7);
        testTask.WhatId = testProperty.Id;
        insert testTask;
        
        
        Test.startTest();
        Database.executeBatch(new PreOCFMUnitInspectionTask());
        Test.stopTest();
    }
}