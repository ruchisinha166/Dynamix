trigger TriggerOnPaymentMileStone on Payment_Milestones__c (before insert,after insert, after update, after delete) {
    Boolean checkCondition = Boolean.valueOf(System.Label.TriggerOnPaymentMileStone);
    if(checkCondition){
        if(Trigger.isBefore && Trigger.isInsert)
        {
            PaymentMileStoneHandler.onBeforeHandler(Trigger.New);
        }
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                PaymentMileStoneHandler.updateMilestonePercentOnBooking(Trigger.new);
            }
            if(Trigger.isUpdate){
                for (Payment_Milestones__c pm: Trigger.new) {
                    
                    Payment_Milestones__c oldPm = Trigger.oldMap.get(pm.ID);
                    
                    
                    if(pm.Milestone_age__c != oldPm.Milestone_age__c) {
                        PaymentMileStoneHandler.updateMilestonePercentOnBooking(Trigger.new);
                    }else{
                        
                    }
                }
            }
            if(Trigger.isUpdate){
                PaymentMileStoneHandler.syncMilestonesToSAP(Trigger.new,Trigger.oldMap);
                PaymentMileStoneHandler.LastDemandGenerationSendSMStoCustomer(Trigger.new,Trigger.oldMap);
                
            }
            if(Trigger.isDelete){
                PaymentMileStoneHandler.updateMilestonePercentOnBooking(Trigger.old);
            }
        }
    }
}