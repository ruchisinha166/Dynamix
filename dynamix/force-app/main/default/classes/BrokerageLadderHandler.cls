public class BrokerageLadderHandler {

    public static void updateChannelPartnerBrokerage(
        List<Brokerage_Ladder__c> newList, 
        Map<Id, Brokerage_Ladder__c> oldMap
    ) {
        List<Channel_Partner_Brokrage__c> updates = new List<Channel_Partner_Brokrage__c>();

        for (Brokerage_Ladder__c ladder : newList) {
            System.debug('ladder ==> ' + ladder);

            Boolean isChanged = false;

            if (oldMap != null && oldMap.containsKey(ladder.Id)) {
                Brokerage_Ladder__c oldRec = oldMap.get(ladder.Id);

                if (ladder.Percentage__c != oldRec.Percentage__c) {
                    System.debug('ladder.Id === ' + ladder.Id);
                    isChanged = true;
                }
            } else {
                isChanged = true;
            }

            if (isChanged) {
                // Query related Channel Partner Brokerage records
                List<Channel_Partner_Brokrage__c> cpbList = [
                    SELECT Id, Total_Brokerage__c, Total_Brokerage_Amount__c,
                           Booking__r.Agreement_Value__c,
                           Ladder_Band__r.Additional_Brokerage__c
                    FROM Channel_Partner_Brokrage__c
                    WHERE Brokerage_Ladder__c = :ladder.Id
                ];

                for (Channel_Partner_Brokrage__c cpb : cpbList) {
                    Decimal basePct = (ladder.Percentage__c != null) ? ladder.Percentage__c : 0;
                    Decimal addPct  = (cpb.Ladder_Band__r != null 
                                      && cpb.Ladder_Band__r.Additional_Brokerage__c != null)
                                      ? cpb.Ladder_Band__r.Additional_Brokerage__c 
                                      : 0;

                    // Total Brokerage Percentage = Ladder % + Band %
                    Decimal totalPct = basePct + addPct;
                    cpb.Total_Brokerage__c = totalPct;

                    // Safely calculate agreement value
                    Decimal agreementVal = (cpb.Booking__r != null 
                                             && cpb.Booking__r.Agreement_Value__c != null) 
                                             ? cpb.Booking__r.Agreement_Value__c 
                                             : 0;

                    // Recalculate brokerage amount
                    cpb.Total_Brokerage_Amount__c = (agreementVal > 0) 
                                                    ? (agreementVal * totalPct) / 100 
                                                    : 0;

                    updates.add(cpb);
                }
            }
        }

        if (!updates.isEmpty()) {
            update updates;
        }
    }
}