trigger PropertyTrigger on Property__c (before insert,before update) {

    if(Trigger.isBefore && Trigger.isUpdate){
        PropertyTriggerHandler.validate(Trigger.New,Trigger.oldMap);
    }
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        PricingPlanToJSON.toJSON(Trigger.New);
    }
}