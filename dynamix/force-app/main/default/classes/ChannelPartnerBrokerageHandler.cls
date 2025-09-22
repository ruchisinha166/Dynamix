public class ChannelPartnerBrokerageHandler {
public static void updateBookingBrokerage(Set<Id> bookingIds) {
        if (bookingIds.isEmpty()) return;

        Map<Id, Decimal> bookingToBrokerageSum = new Map<Id, Decimal>();
        
        for (AggregateResult ar : [
            SELECT Booking__c bId, SUM(Total_Brokerage__c) totalPct
            FROM Channel_Partner_Brokrage__c
            WHERE Booking__c IN :bookingIds
            GROUP BY Booking__c
        ]) {
            bookingToBrokerageSum.put((Id)ar.get('bId'), (Decimal)ar.get('totalPct'));
        }

        // Prepare Booking updates
        List<Booking__c> updates = new List<Booking__c>();
        for (Id bId : bookingIds) {
            Decimal sumPct = bookingToBrokerageSum.containsKey(bId) ? bookingToBrokerageSum.get(bId) : 0;
            system.debug('line sumPct ==>' + sumPct);
            updates.add(new Booking__c(
                Id = bId,
                Brokerage_Percentage__c = sumPct
            ));
        }

        if (!updates.isEmpty()) {
            system.debug('updates' + updates);
            update updates;
        }
    }
}