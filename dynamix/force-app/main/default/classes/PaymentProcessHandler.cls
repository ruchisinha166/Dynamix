public class PaymentProcessHandler {
    
    public class PaymentRequest {
        @InvocableVariable(required = true)
        public Id bookingId;
        
        @InvocableVariable(required = true)
        public Decimal amount;
        
        @InvocableVariable(required = true)
        public Id PaymentId;
    }
    
    @InvocableMethod(label = 'Process Payment' description = 'Creates Payment Line and Updates Milestones')
    public static void processPayments(List<PaymentRequest> requests) {
        if (requests == null || requests.isEmpty()) return;
        
        List<Payment_Line__c> paymentLinesToInsert = new List<Payment_Line__c>();
        List<Payment_Milestones__c> milestonesToUpdate = new List<Payment_Milestones__c>();
        
        // Collect all Booking Ids
        Set<Id> bookingIds = new Set<Id>();
        for (PaymentRequest req : requests) {
            bookingIds.add(req.bookingId);
            System.debug('PaymentRequest -> bookingId: ' + req.bookingId + ', amount: ' + req.amount + ', PaymentId: ' + req.PaymentId);
        }
        
        // Query related Payment Milestones and map by BookingId
        Map<Id, Payment_Milestones__c> milestoneMap = new Map<Id, Payment_Milestones__c>();
        for (Payment_Milestones__c milestone : [
            SELECT Id, Booking__c, Remaining_Milestone_Amount__c, Remaining_Unit_Cost__c
            FROM Payment_Milestones__c
            WHERE Booking__c IN :bookingIds
            AND Name LIKE 'Possession/Handover(Other) Charge'
        ]) {
            milestoneMap.put(milestone.Booking__c, milestone);
        }
        
        System.debug('Milestone Map: ' + milestoneMap);
        
        for (PaymentRequest req : requests) {
            if (milestoneMap.containsKey(req.bookingId)) {
                Payment_Milestones__c milestone = milestoneMap.get(req.bookingId);
                System.debug('Found milestone for BookingId: ' + req.bookingId);
                if (milestone.Remaining_Milestone_Amount__c != null && milestone.Remaining_Milestone_Amount__c >= req.amount) {
                    system.debug('line 46');
                    Payment_Line__c newLine = new Payment_Line__c(
                        Milestone__c = milestone.Id,
                        Amount__c = req.amount,
                        Payment_Status__c = 'Approved',
                        Payment_Category__c = 'Parking' ,
                        Adjusted_against__c = 'ruchi testing..',
                        Payment__c = req.PaymentId
                    );
                    paymentLinesToInsert.add(newLine);
                    
                    System.debug('Prepared Payment Line record: ' + newLine);
                    
                    
                    milestone.Remaining_Milestone_Amount__c = 
                        (milestone.Remaining_Milestone_Amount__c != null ? milestone.Remaining_Milestone_Amount__c : 0) - req.amount;
                    
                    milestone.Remaining_Unit_Cost__c = 
                        (milestone.Remaining_Unit_Cost__c != null ? milestone.Remaining_Unit_Cost__c : 0) - req.amount;
                    
                    milestonesToUpdate.add(milestone);
                }else {
                    system.debug('line 68');
                    System.debug('Skipped creating payment line because remaining amount is insufficient.');
                } 
            } else {
                system.debug('line 72');
                System.debug('No milestone found for BookingId: ' + req.bookingId);
            }
        }
        
        if (!paymentLinesToInsert.isEmpty()) {
            System.debug('Inserting Payment Lines: ' + paymentLinesToInsert);
            insert paymentLinesToInsert;
        }
        
        if (!milestonesToUpdate.isEmpty()) {
            System.debug('Updating Milestones: ' + milestonesToUpdate);
            update milestonesToUpdate;
        }
    }
}