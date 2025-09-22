trigger SuggestedPropertyTrigger on Suggested_Property__c (after update) {
    
    if(Trigger.isAfter && Trigger.isUpdate){
        SuggestedPropertyTriggerHandler.statusUpdate(Trigger.NewMap,Trigger.OldMap);
        system.debug('Trigger.NewMap=='+Trigger.NewMap);
    }
}