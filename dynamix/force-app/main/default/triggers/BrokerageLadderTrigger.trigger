trigger BrokerageLadderTrigger on Brokerage_Ladder__c (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            BrokerageLadderHandler.updateChannelPartnerBrokerage(Trigger.new, null);
        }
        if (Trigger.isUpdate) {
            BrokerageLadderHandler.updateChannelPartnerBrokerage(Trigger.new, Trigger.oldMap);
        }
    }
}