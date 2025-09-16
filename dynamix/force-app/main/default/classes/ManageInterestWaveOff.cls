public class ManageInterestWaveOff {
    
    @InvocableMethod(label='Get Booking Payment Plans for Interest Wave Off')
    public static List<String> execute(List<Requests> requestLst){
        Decimal newAgreementValue = 0;
        
        Decimal newGSTValue = 0;
        
        
        List<Payment_Milestones__c> paymentPlanLst = [SELECT Id, Total_Interest_Amount__c,Milestone_age__c, Milestone_Status__c,Milestone_Amount1__c,GST_Amount1__c, Name,Interest_Amount__c, Due_Date__c,Milestone_Activation_Date__c, 
                                                                Payment_Received__c, Project_Progress__c, Sequence_No__c 
                                                                FROM Payment_Milestones__c 
                                                                WHERE Booking__c =: requestLst[0].bookingId and Total_Interest_Amount__c > 0 
                                                                ORDER BY Sequence_No__c];
                                                                
        return new List<String>{JSON.serialize(paymentPlanLst)};
       
    }

    public class Requests {
        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
       
    }
     
}