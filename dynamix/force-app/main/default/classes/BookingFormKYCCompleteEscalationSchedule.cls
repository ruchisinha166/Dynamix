//This Schedule Class will Call BookingFormKYCCompleteEscalationBatch (Batch class) & Excute it With Default Batch Size-200
global class BookingFormKYCCompleteEscalationSchedule implements Schedulable {
    global void execute(SchedulableContext sc){
        BookingFormKYCCompleteEscalationBatch batch1=new BookingFormKYCCompleteEscalationBatch();
        Database.executeBatch(batch1);
    }
    Public static void SchedulerMethodForRunInEvery10min() {
        System.schedule('BookingForm KYC Escalation 1 '+System.now(), '0 0 * * * ?', new BookingFormKYCCompleteEscalationSchedule());
        System.schedule('BookingForm KYC Escalation 2 '+System.now(), '0 10 * * * ?', new BookingFormKYCCompleteEscalationSchedule());
        System.schedule('BookingForm KYC Escalation 3 '+System.now(), '0 20 * * * ?', new BookingFormKYCCompleteEscalationSchedule());
        System.schedule('BookingForm KYC Escalation 4 '+System.now(), '0 30 * * * ?', new BookingFormKYCCompleteEscalationSchedule());
        System.schedule('BookingForm KYC Escalation 5 '+System.now(), '0 40 * * * ?', new BookingFormKYCCompleteEscalationSchedule());
        System.schedule('BookingForm KYC Escalation 6 '+System.now(), '0 50 * * * ?', new BookingFormKYCCompleteEscalationSchedule());
    }
}