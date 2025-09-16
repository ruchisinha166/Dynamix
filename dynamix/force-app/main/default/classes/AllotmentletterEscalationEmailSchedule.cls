//This Schedule Class will Call AllotmentletterEscalationEmailBatch (Batch class) & Excute it With Default Batch Size-200
global class AllotmentletterEscalationEmailSchedule implements Schedulable {
    global void execute(SchedulableContext sc){
        AllotmentletterEscalationEmailBatch batch1=new AllotmentletterEscalationEmailBatch();
        Database.executeBatch(batch1);
    }
    Public static void SchedulerMethodForRunInEvery10min() {
        System.schedule('Escalation For Send Allotment Letter 1 '+System.now(), '0 0 * * * ?', new AllotmentletterEscalationEmailSchedule());
        System.schedule('Escalation For Send Allotment Letter 2 '+System.now(), '0 10 * * * ?', new AllotmentletterEscalationEmailSchedule());
        System.schedule('Escalation For Send Allotment Letter 3 '+System.now(), '0 20 * * * ?', new AllotmentletterEscalationEmailSchedule());
        System.schedule('Escalation For Send Allotment Letter 4 '+System.now(), '0 30 * * * ?', new AllotmentletterEscalationEmailSchedule());
        System.schedule('Escalation For Send Allotment Letter 5 '+System.now(), '0 40 * * * ?', new AllotmentletterEscalationEmailSchedule());
        System.schedule('Escalation For Send Allotment Letter 6 '+System.now(), '0 50 * * * ?', new AllotmentletterEscalationEmailSchedule());
   
    }
}