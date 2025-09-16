trigger SuggestedPropertyTrigger on Suggested_Property__c (after update,after Insert) {
    
    if(Trigger.isAfter && Trigger.isUpdate){
        SuggestedPropertyTriggerHandler.statusUpdate(Trigger.NewMap,Trigger.OldMap);
        system.debug('Trigger.NewMap=='+Trigger.NewMap);
    }
    if(Trigger.isAfter && Trigger.isInsert){
        createAddOn.createAddOnforPreAllotted(Trigger.new);
    }
}