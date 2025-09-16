trigger OpportunityTrigger on Opportunity (after update, before update,after insert,before insert) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        
      //  OpportunityTriggerHandler.makeCommentMandatory(Trigger.new, Trigger.oldMap);
        
    }
    if (Trigger.isAfter && Trigger.isInsert) {
        
      //  OpportunityTriggerHandler.makeCommentMandatory(Trigger.new, Trigger.oldMap);
              SendSMSHandler.sendSMSOnNewOpportunity(Trigger.new);
 
    }
     if (Trigger.isBefore && Trigger.isInsert) {
        
      //  OpportunityTriggerHandler.makeCommentMandatory(Trigger.new, Trigger.oldMap);
              OpportunityTriggerHandler.eoiCaOpportunity(Trigger.new);
 
    }
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        OpportunityTriggerHandler.makeCommentMandatory(Trigger.new, Trigger.oldMap);
        OpportunityTriggerHandler.updateEoiCaOpportunityRefundStatus(Trigger.new);
        if(!OpportunityTriggerHandler.channelPartnerFlag)
        {
            OpportunityTriggerHandler.channelPartnerFlag =true;
            OpportunityTriggerHandler.channelPartnerProject(Trigger.new);
        }
    }
     if (Trigger.isBefore && Trigger.isInsert) {
        if(!OpportunityTriggerHandler.channelPartnerFlag)
        {
            OpportunityTriggerHandler.channelPartnerFlag =true;
            OpportunityTriggerHandler.channelPartnerProject(Trigger.new);
        }
        //OpportunityTriggerHandler.populateCloseDate(Trigger.new);
    }
     if(Trigger.isAfter ){
        if(Trigger.isUpdate || Trigger.isInsert){
            if(!OpportunityTriggerHandler.updateChannelPartnerFlag)
            {OpportunityTriggerHandler.updateChannelPartnerFlag =true;
             OpportunityTriggerHandler.updateChannelPartner(Trigger.new , Trigger.oldMap);
            }
           
            if(Trigger.isInsert){ 
            OpportunityTriggerHandler.changeCheckWalkInTrue(Trigger.newMap);
            }
        }
    }
    
}