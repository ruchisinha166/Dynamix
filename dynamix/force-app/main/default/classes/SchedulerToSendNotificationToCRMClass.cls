//This Class will run 10 AM every morning and will Send Bell Notification TO CRM Head For Bookings Where Sent Date is of Past 3 Days 
public class SchedulerToSendNotificationToCRMClass implements Schedulable{

     public Static void execute(SchedulableContext sc){
         //String todayDateSecond = String.valueOf(System.today().Day());
         BatchToSendNotificationToCRMHeadClass obj = new BatchToSendNotificationToCRMHeadClass();
         Database.executeBatch(obj,200);
         BatchToSendEmailChallanRecievedClass obj1 = new BatchToSendEmailChallanRecievedClass();
         Database.executeBatch(obj1,200);
         //System.schedule('JOB'+todayDateSecond, '0 0 10 * * ? *', new SchedulerToSendNotificationToCRMClass());
     }
}