//This Schedule Class will Call BookingFormKYCCompleteReminderBatch (Batch class) & Excute it With Default Batch Size-200
global class BookingFormKYCCompleteReminderSchedule implements Schedulable {
    global void execute(SchedulableContext sc){
        BookingFormKYCCompleteReminderBatch batch1=new BookingFormKYCCompleteReminderBatch();
        Database.executeBatch(batch1);
    }
    Public static void SchedulerMethodForRunInEvery10min() {
        System.schedule('BookingForm KYC Reminder 1 '+System.now(), '0 0 * * * ?', new BookingFormKYCCompleteReminderSchedule());
        System.schedule('BookingForm KYC Reminder 2 '+System.now(), '0 10 * * * ?', new BookingFormKYCCompleteReminderSchedule());
        System.schedule('BookingForm KYC Reminder 3 '+System.now(), '0 20 * * * ?', new BookingFormKYCCompleteReminderSchedule());
        System.schedule('BookingForm KYC Reminder 4 '+System.now(), '0 30 * * * ?', new BookingFormKYCCompleteReminderSchedule());
        System.schedule('BookingForm KYC Reminder 5 '+System.now(), '0 40 * * * ?', new BookingFormKYCCompleteReminderSchedule());
        System.schedule('BookingForm KYC Reminder 6 '+System.now(), '0 50 * * * ?', new BookingFormKYCCompleteReminderSchedule());
    }
}