//This Schedule Class will Call ChannelPartnerComplaintCaseEscalation (Batch class) & Excute it With Default Batch Size-200
global class ChannelPartnerCompCaseEscalationSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        ChannelPartnerComplaintCaseEscalation batch1=new ChannelPartnerComplaintCaseEscalation();
        Database.executeBatch(batch1);
    }
}