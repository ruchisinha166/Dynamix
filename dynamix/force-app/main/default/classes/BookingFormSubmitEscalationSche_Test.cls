@isTest      
public class BookingFormSubmitEscalationSche_Test {
    
    @isTest
    public static void method(){
        Test.startTest();
        System.schedule('jobName','0 5 * * * ? *', new BookingFormSubmitEscalationSchedule());
        Test.stopTest();
         
    }
    
}