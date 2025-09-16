public class SchedulerKYCNotVerifiedClass implements Schedulable{
    public Static void execute(SchedulableContext sc){
        /*String todayDateMinute = String.valueOf(System.now().minute());
        String todayDateSecond = String.valueOf(System.now().second());
        String todayDateHour = String.valueOf(System.now().Hour());
        String todayDateDay = String.valueOf(System.now().Day());
        String todayDatemonth = String.valueOf(System.now().month());*/
        BatchKYCNotVerifiedClass obj = new BatchKYCNotVerifiedClass();
        Database.executeBatch(obj,200);
        BatchToSendEmailNOCPendingClass obj2 = new BatchToSendEmailNOCPendingClass();
        Database.executeBatch(obj2,200);
        BatchBankApprovedROCNotUplaodedClass obj3 = new BatchBankApprovedROCNotUplaodedClass();
        Database.executeBatch(obj3,200);
        //System.schedule('JOB'+todayDateSecond+todayDateMinute+todayDateHour+todayDateDay+todayDatemonth, '0 0 10 * * ? *', new SchedulerKYCNotVerifiedClass());
    }
}