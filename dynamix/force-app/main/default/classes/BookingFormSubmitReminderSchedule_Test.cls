@isTest
public class BookingFormSubmitReminderSchedule_Test {
   public static testMethod void testschedule() {  
        Test.StartTest();
        BookingFormSubmitReminderSchedule testSchedule1 = new BookingFormSubmitReminderSchedule(); 
        String sch = '0 15 10 * * ? *'; //Fire at 10:15 AM every day       	
        system.schedule('Test BookingFormSubmitReminderSchedule Job', sch, testSchedule1); 
        Test.stopTest(); 
    }
}