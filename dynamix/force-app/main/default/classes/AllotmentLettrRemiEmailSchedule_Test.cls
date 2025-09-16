@isTest
public class AllotmentLettrRemiEmailSchedule_Test {

    @isTest static void scheduleEmailTest(){

        Test.startTest();
        AllotmentLettrRemiEmailSchedule SERB = New AllotmentLettrRemiEmailSchedule();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test schedule', sch, SERB);
        
        AllotmentLettrRemiEmailSchedule.SchedulerMethodForRunInEvery10min();
        Test.stopTest();
    }
}