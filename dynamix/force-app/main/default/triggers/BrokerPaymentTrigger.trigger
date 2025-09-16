trigger BrokerPaymentTrigger on Broker_Payment__c (after update,after insert) {

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            BrokerPaymentTriggerHandler.sendEmailToSiteHeadAndSMHead(Trigger.New);
        }
        if(Trigger.isUpdate){
            BrokerPaymentTriggerHandler.sendEmailToSiteHeadAndSMHead(Trigger.New, Trigger.oldMap);
        }
    }
}