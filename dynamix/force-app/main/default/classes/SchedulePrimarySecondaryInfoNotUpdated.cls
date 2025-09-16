public class SchedulePrimarySecondaryInfoNotUpdated implements Schedulable {
    public Static void execute(SchedulableContext sc){
       /* String todayDateMinute = String.valueOf(System.now().minute());
        String todayDateSecond = String.valueOf(System.now().second());
        String todayDateHour = String.valueOf(System.now().Hour());
        String todayDateDay = String.valueOf(System.now().Day());
        String todayDatemonth = String.valueOf(System.now().month());*/
        BatchPrimarySecondaryInfoNotUpdated obj = new BatchPrimarySecondaryInfoNotUpdated();
        Database.executeBatch(obj,200);
       // System.schedule('JOB'+todayDateSecond+todayDateMinute+todayDateHour+todayDateDay+todayDatemonth, '0 0 10 * * ? *', new SchedulePrimarySecondaryInfoNotUpdated());
    }
}