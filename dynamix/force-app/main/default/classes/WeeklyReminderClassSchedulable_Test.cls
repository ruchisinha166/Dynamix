@isTest
public class WeeklyReminderClassSchedulable_Test {

    @isTest static void weeklyRCSTest(){
        
          Test.startTest();
        WeeklyReminderClassSchedulable SERB = New WeeklyReminderClassSchedulable();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test schedule', sch, SERB);
        Test.stopTest();
    }
}