trigger AccountTrigger on Account (after insert,after update, before insert, before update) {
    
    if(trigger.isafter && trigger.isinsert)
    {
        AccountTriggerHandler.insertContacts(trigger.new);
        ChannelPartnerHandler.sendSmsToCustomerForNewCP(trigger.new);
    }
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        AccountTriggerHandler.updateBookingDraftTaskStatus(Trigger.new);
    }
     if(trigger.isBefore && trigger.isinsert)
    {
        AccountTriggerHandler.duplicateAccountAndAddMandatory(trigger.new);
      
    }
     if(trigger.isBefore && trigger.isupdate)
    {
        AccountTriggerHandler.duplicateAccountAndAddMandatory(trigger.new);
      
    }
    if(trigger.isBefore && Trigger.isUpdate){
        AccountTriggerHandler.updateRegistration(Trigger.new);
    }

}