@isTest
public class DeactivateExpiredLaddersBatchTest {

    @isTest
    static void testDeactivateExpiredLadders() {
        BusinessHours bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];         
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
         Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = testUserRcd1.Id;
        projectObject.Site_Head__c = testUserRcd1.id;
        insert projectObject;
        Brokerage_Ladder__c expiredLadder = new Brokerage_Ladder__c(
            project__c =projectObject.id,
            Active__c = true,
            Start_Date__c = Date.today().addDays(-30),
            End_Date__c = Date.today().addDays(-1)
        );
        
        // 2. Insert Active Ladder with End_Date__c in the future (should remain active)
        Brokerage_Ladder__c activeLadder = new Brokerage_Ladder__c(
           project__c =projectObject.id,
            Active__c = true,
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(10)
        );
        
        insert new List<Brokerage_Ladder__c>{ expiredLadder, activeLadder };

        // 3. Run Batch
        Test.startTest();
        Database.executeBatch(new DeactivateExpiredLaddersBatch(), 200);
        Test.stopTest();

        // 4. Re-query records
        expiredLadder = [SELECT Id, Active__c FROM Brokerage_Ladder__c WHERE Id = :expiredLadder.Id];
        activeLadder = [SELECT Id, Active__c FROM Brokerage_Ladder__c WHERE Id = :activeLadder.Id];

        // 5. Assertions
        System.assertEquals(false, expiredLadder.Active__c, 'Expired ladder should be deactivated');
        System.assertEquals(true, activeLadder.Active__c, 'Future ladder should remain active');
    }
}