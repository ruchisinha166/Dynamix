trigger LadderBandTrigger on Ladder_Band__c (after insert, after update) {
    if(Trigger.isAfter) {
        LadderBandHandler.updateChannelPartnerBrokerage(Trigger.new, Trigger.oldMap);
    }
}