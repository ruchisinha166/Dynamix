trigger CampaignTrigger on Campaign (before insert,before update,after update) {
    if(Trigger.isAfter){
        if(trigger.isUpdate /*&& CampaignTriggerHandler.Isfirst*/){
            //CampaignTriggerHandler.Isfirst = False ;
            CampaignTriggerHandler.makeApprovalCommentsMandatory(Trigger.new, Trigger.oldMap);
            CampaignTriggerHandler.makeApprovalCommentsMandatory2(Trigger.new, Trigger.oldMap);
        }
    }
    if(Trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
           CampaignTriggerHandler.main(Trigger.new,Trigger.oldMap);
        }
    }
}