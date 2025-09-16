@isTest
public class ChannelPartnerCompCaseEscaSchedule_Test {
    public static testMethod void testschedule() {  
        Test.StartTest();
        ChannelPartnerCompCaseEscalationSchedule testSchedule1 = new ChannelPartnerCompCaseEscalationSchedule(); 
        String sch = '0 15 10 * * ? *'; //Fire at 10:15 AM every day       	
        system.schedule('Test ChannelPartnerCompCaseEscalationSchedule Job', sch, testSchedule1); 
        Test.stopTest(); 
    }
}