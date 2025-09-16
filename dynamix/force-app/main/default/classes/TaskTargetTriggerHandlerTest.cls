@isTest
public class TaskTargetTriggerHandlerTest {
    @isTest
    public static void method1(){
        
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
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        insert projectObject;
        
        Project__c projectObject1 = new Project__c();
        projectObject1.Name = 'Test Project';
        projectObject1.Project_Email__c= 'mayur.patel@manras.com';
        projectObject1.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject1.Budgets__c = 'Under 75 lakhs';
        projectObject1.Configuration__c ='1 BHK';
        insert projectObject1;
        
        Task_Target__c testTaskTarget1 = new Task_Target__c();
        testTaskTarget1.Project__c = projectObject.Id;
        testTaskTarget1.Year__c= '2023';
        testTaskTarget1.Month__c = 'January';
        testTaskTarget1.User__c = testUserRcd1.Id;
        testTaskTarget1.Type__c ='Bookings';
        testTaskTarget1.Number_of_Targets__c = 3;
        insert testTaskTarget1;

       Task_Target__c testTaskTarget2 = new Task_Target__c();
        testTaskTarget2.Project__c = projectObject1.Id;
        testTaskTarget2.Year__c= '2023';
        testTaskTarget2.Month__c = 'January';
        testTaskTarget2.User__c = testUserRcd1.Id;
        testTaskTarget2.Type__c ='Bookings';
        testTaskTarget2.Number_of_Targets__c = 3;
        insert testTaskTarget2;

        Test.startTest();
        TaskTargetTriggerHandler.duplicate(new List<Task_Target__c>{testTaskTarget2});
        Test.stopTest();

    }
}