trigger BookingTrigger on Booking__c ( before insert, before update, after insert, after update) {
    Boolean checkCondition = Boolean.valueOf(System.Label.Booking_Trigger);
    if (!checkCondition) return;

    // -------------------------
    // BEFORE INSERTassignBrokerageLadder
    // -------------------------
    if (Trigger.isBefore && Trigger.isInsert) {
        System.debug('Before Insert: assign brokerage ladder');
        BookingTriggerHandler.assignBrokerageLadder(Trigger.new);
    }

    // -------------------------
    // BEFORE UPDATE
    // -------------------------
    if (Trigger.isBefore && Trigger.isUpdate) {
        System.debug('Before Update: assign brokerage ladder');
       BookingTriggerHandler.assignBrokerageLadder(Trigger.new);
    }

    // -------------------------
    // AFTER INSERT
    // -------------------------
    if (Trigger.isAfter && Trigger.isInsert) {
        System.debug('After Insert: update brokerage');
       BookingTriggerHandlerNew.updateBrokerage(Trigger.new);
      
    }

    // -------------------------
    // AFTER UPDATE
    // -------------------------
    if (Trigger.isAfter && Trigger.isUpdate) {
        System.debug('After Update: update brokerage');
        BookingTriggerHandlerNew.updateBrokerage(Trigger.new);
        
    }
}