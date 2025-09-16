@isTest (SeeAllData=true)
public class PaymentReceiptNumber_Test {

    @isTest static void receiptNoTest(){
     
        
        Test.startTest();
        PaymentReceiptNumber.incrementNumber();
        Test.stopTest();
  }
}