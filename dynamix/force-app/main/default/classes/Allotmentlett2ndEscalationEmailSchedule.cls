//This Schedule Class will Call Allotmentletter2ndEscalationEmailBatch (Batch class) & Excute it With Default Batch Size-200
global class Allotmentlett2ndEscalationEmailSchedule implements Schedulable {
    global void execute(SchedulableContext sc){
        Allotmentletter2ndEscalationEmailBatch batch1=new Allotmentletter2ndEscalationEmailBatch();
        Database.executeBatch(batch1);
    }
    Public static void SchedulerMethodForRunInEvery10min() {
        System.schedule('2nd Escalation For Send Allotment Letter 1 '+System.now(), '0 0 * * * ?', new Allotmentlett2ndEscalationEmailSchedule());
        System.schedule('2nd Escalation For Send Allotment Letter 2 '+System.now(), '0 10 * * * ?', new Allotmentlett2ndEscalationEmailSchedule());
        System.schedule('2nd Escalation For Send Allotment Letter 3 '+System.now(), '0 20 * * * ?', new Allotmentlett2ndEscalationEmailSchedule());
        System.schedule('2nd Escalation For Send Allotment Letter 4 '+System.now(), '0 30 * * * ?', new Allotmentlett2ndEscalationEmailSchedule());
        System.schedule('2nd Escalation For Send Allotment Letter 5 '+System.now(), '0 40 * * * ?', new Allotmentlett2ndEscalationEmailSchedule());
        System.schedule('2nd Escalation For Send Allotment Letter 6 '+System.now(), '0 50 * * * ?', new Allotmentlett2ndEscalationEmailSchedule());
    }
}