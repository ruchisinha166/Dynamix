trigger ProjectTrigger on Project__c (After insert) {
   ProjectTriggerHandler.generateCIFFormLink(Trigger.new);
}