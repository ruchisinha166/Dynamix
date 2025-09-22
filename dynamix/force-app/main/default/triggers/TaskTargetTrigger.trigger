trigger TaskTargetTrigger on Task_Target__c (before insert,before Update, after Insert) {
    
    if(Trigger.isbefore && (Trigger.isInsert || Trigger.isUpdate)){
        TaskTargetTriggerHandler.duplicate(Trigger.New);
    }    
    /* if(Trigger.isbefore && Trigger.isInsert){
TaskTargetCount.countTaskTargets(Trigger.new);
}*/
    
    if(Trigger.isAfter && Trigger.isInsert){
        TaskTargetTriggerHandler.countBookingTarget(Trigger.new);
    }
}