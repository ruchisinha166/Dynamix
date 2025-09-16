//This Schedule Class will Call BatchForCustomerSDRPaymentReminder (Batch class) & will Excute it With Batch Size-10
global class BatchForCustSDRPaymentRemiSchedule implements Schedulable{
  global void execute(SchedulableContext sc){
        BatchForCustomerSDRPaymentReminder batch1=new BatchForCustomerSDRPaymentReminder();
        Database.executeBatch(batch1,10);
    }
}