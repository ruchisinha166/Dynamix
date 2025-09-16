trigger EOICAPaymentTrigger on EOI_CA_Payment__c (after update) {
    EOICAPaymentTriggerHandler.SendRejectedPaymentEmail(trigger.new,trigger.oldMap);
}