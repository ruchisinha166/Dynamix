@isTest
public class scheduledEmailReminderBatch_Test {

    @isTest static void scheduleEmailTest(){


        Test.startTest();
        scheduledEmailReminderBatch SERB = New scheduledEmailReminderBatch();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test schedule', sch, SERB);
        Test.stopTest();
    }
}