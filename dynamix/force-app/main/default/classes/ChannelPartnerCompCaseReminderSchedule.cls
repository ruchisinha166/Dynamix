//This Schedule Class will Call ChannelPartnerComplaintCaseReminder (Batch class) & Excute it With Default Batch Size-200
global class ChannelPartnerCompCaseReminderSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        ChannelPartnerComplaintCaseReminder batch1=new ChannelPartnerComplaintCaseReminder();
        Database.executeBatch(batch1);
    }
}