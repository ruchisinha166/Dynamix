trigger BookingOfferTrigger on Booking_Offer__c (after update,after insert) {
    if(trigger.isAfter){
        if(trigger.isUpdate){
            BookingOfferTriggerHandler.sendEmailToSMHead2(trigger.New,trigger.oldMap); 
        }
        if(trigger.isInsert){
            BookingOfferTriggerHandler.sendEmailToSMHead(trigger.New); 
        }
    }
}