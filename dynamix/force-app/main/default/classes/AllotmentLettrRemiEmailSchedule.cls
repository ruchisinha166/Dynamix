//This Schedule Class will Call EmailReminderForSendAllotmentLetter (Batch class) & Excute it With Default Batch Size-200
global class AllotmentLettrRemiEmailSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        EmailReminderForSendAllotmentLetter batch1=new EmailReminderForSendAllotmentLetter();
        Database.executeBatch(batch1);
    }
    Public static void SchedulerMethodForRunInEvery10min() {
        System.schedule('Reminder For Send Allotment Letter 1 '+System.now(), '0 0 * * * ?', new AllotmentLettrRemiEmailSchedule());
        System.schedule('Reminder For Send Allotment Letter 2 '+System.now(), '0 10 * * * ?', new AllotmentLettrRemiEmailSchedule());
        System.schedule('Reminder For Send Allotment Letter 3 '+System.now(), '0 20 * * * ?', new AllotmentLettrRemiEmailSchedule());
        System.schedule('Reminder For Send Allotment Letter 4 '+System.now(), '0 30 * * * ?', new AllotmentLettrRemiEmailSchedule());
        System.schedule('Reminder For Send Allotment Letter 5 '+System.now(), '0 40 * * * ?', new AllotmentLettrRemiEmailSchedule());
        System.schedule('Reminder For Send Allotment Letter 6 '+System.now(), '0 50 * * * ?', new AllotmentLettrRemiEmailSchedule());
    }
}