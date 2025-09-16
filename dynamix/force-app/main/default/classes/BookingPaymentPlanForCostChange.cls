public class BookingPaymentPlanForCostChange {
    
    @InvocableMethod(label='Get Booking Payment Plans For Cost Change')
    public static List<String> execute(List<Requests> requestLst){
    
        Decimal newAgreementValue = requestLst[0].newAgreementValue;
        
        Decimal newGSTValue = requestLst[0].newGSTValue;
        
        List<Payment_Milestones__c> paymentPlanLst = [SELECT Id, Milestone_age__c,Booking__c,Milestone_Amount1__c,GST_Amount1__c,Milestone_Status__c, 
                                                            Name, Due_Date__c, Milestone_Activation_Date__c, 
                                                            Payment_Received__c, Project_Progress__c, Sequence_No__c
                                                              
                                                            FROM Payment_Milestones__c 
                                                            WHERE Booking__c =: requestLst[0].bookingId 
                                                            ORDER BY Sequence_No__c];
        
        system.debug('===> paymentPlanLst ' + paymentPlanLst);
        return new List<String>{JSON.serialize(paymentPlanLst)};
    }

    public class Requests {
        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
        
        @InvocableVariable(label='New Agreement Value' required=true)
        public Decimal newAgreementValue;
        
        @InvocableVariable(label='New GST Value' required=true)
        public Decimal newGSTValue;
    }
}