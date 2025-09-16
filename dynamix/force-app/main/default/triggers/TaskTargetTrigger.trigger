trigger TaskTargetTrigger on Task_Target__c (before insert,before Update) {
    TaskTargetTriggerHandler.duplicate(Trigger.New);
}