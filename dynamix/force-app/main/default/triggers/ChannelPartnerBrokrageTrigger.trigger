trigger ChannelPartnerBrokrageTrigger on Channel_Partner_Brokrage__c (
after insert, after update, after delete, after undelete
) {
    Set<Id> bookingIds = new Set<Id>();

    // Collect booking IDs from NEW records
    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Channel_Partner_Brokrage__c cpb : Trigger.new) {
            if (cpb.Booking__c != null) {
                bookingIds.add(cpb.Booking__c);
            }
        }
    }

    if (Trigger.isUpdate || Trigger.isDelete) {
        for (Channel_Partner_Brokrage__c cpb : Trigger.old) {
            if (cpb.Booking__c != null) {
                bookingIds.add(cpb.Booking__c);
            }
        }
    }

    if (!bookingIds.isEmpty()) {
      ChannelPartnerBrokerageHandler.updateBookingBrokerage(bookingIds);
    }
}