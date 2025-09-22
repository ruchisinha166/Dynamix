trigger PropertyTrigger on Property__c (before insert,before update,after update) {

    if(Trigger.isBefore && Trigger.isUpdate){
        PropertyTriggerHandler.validate(Trigger.New,Trigger.oldMap);
    }
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        PricingPlanToJSON.toJSON(Trigger.New);
    }
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        PropertyTriggerHandler.customerSnagMethod(Trigger.New,Trigger.oldMap);
        if(PropertyTriggerHandler.propertyflag != true)
        {
            PropertyTriggerHandler.propertyflag = true;
            PropertyTriggerHandler.handoverCompletionPercentage(Trigger.New);
        }
        
    }
}