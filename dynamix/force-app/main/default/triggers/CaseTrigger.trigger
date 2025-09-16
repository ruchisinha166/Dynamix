trigger CaseTrigger on Case (after update) {
  if(Trigger.isAfter && Trigger.isUpdate){
      CaseTriggerHandler.sendEmailForComplaintType(Trigger.New,Trigger.oldMap);
  }
}