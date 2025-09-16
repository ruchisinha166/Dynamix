@isTest
public class ChannelPartnerCompCaseRemiSche_Test {
    public static testMethod void testschedule() {  
        Test.StartTest();
        ChannelPartnerCompCaseReminderSchedule testSchedule1 = new ChannelPartnerCompCaseReminderSchedule(); 
        String sch = '0 15 10 * * ? *'; //Fire at 10:15 AM every day       	
        system.schedule('Test ChannelPartnerCompCaseReminderSchedule Job', sch, testSchedule1); 
        Test.stopTest(); 
    }
}