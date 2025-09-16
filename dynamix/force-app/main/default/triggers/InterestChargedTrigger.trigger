trigger InterestChargedTrigger on Interest_Charged__c (after update) {
    if(Trigger.isAfter && Trigger.isupdate){
        InterestChargedTriggerHandler.InterestOnPaymentMilestone(Trigger.new,Trigger.oldMap);        
    }
}