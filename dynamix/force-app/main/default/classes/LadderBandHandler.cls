public class LadderBandHandler {

    public static void updateChannelPartnerBrokerage(
        List<Ladder_Band__c> newList, 
        Map<Id, Ladder_Band__c> oldMap
    ) {
        List<Channel_Partner_Brokrage__c> updates = new List<Channel_Partner_Brokrage__c>();

        for (Ladder_Band__c band : newList) {
            Boolean isChanged = false;

            // Check if Additional_Brokerage__c changed, or if new band is inserted
            if (oldMap != null && oldMap.containsKey(band.Id)) {
                Ladder_Band__c oldRec = oldMap.get(band.Id);
                if (band.Additional_Brokerage__c != oldRec.Additional_Brokerage__c) {
                    isChanged = true;
                }
            } else {
                isChanged = true; // newly inserted band
            }

            if (isChanged) {
               system.debug('band.Id'+band.Id);
                List<Channel_Partner_Brokrage__c> cpbList = [
                    SELECT Id, Total_Brokerage__c, Total_Brokerage_Amount__c,
                    Booking__c,
                           Booking__r.Agreement_Value__c,
                           Brokerage_Ladder__r.Percentage__c,
                           Ladder_Band__r.Additional_Brokerage__c
                    FROM Channel_Partner_Brokrage__c
                    WHERE Ladder_Band__c = :band.Id
                ];

                for (Channel_Partner_Brokrage__c cpb : cpbList) {
                    Decimal basePct = (cpb.Brokerage_Ladder__r != null && cpb.Brokerage_Ladder__r.Percentage__c != null)
                                        ? cpb.Brokerage_Ladder__r.Percentage__c : 0;
                    Decimal addPct  = (band.Additional_Brokerage__c != null) ? band.Additional_Brokerage__c : 0;

                    // Total Brokerage % = Ladder % + Band %
                    Decimal totalPct = basePct + addPct;
                    cpb.Total_Brokerage__c = totalPct;

                    // Agreement Value from Booking
                    Decimal agreementVal = (cpb.Booking__r != null && cpb.Booking__r.Agreement_Value__c != null)
                                            ? cpb.Booking__r.Agreement_Value__c : 0;
					
                    // Calculate Brokerage Amount
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