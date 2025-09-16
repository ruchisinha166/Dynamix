public with sharing class CustomPaymentPlan {
    
    @InvocableMethod(label='Get Payment Plans')
    public static List<String> getPaymentPlanMilestones(List<Requests> requestLst){
        try {
            List<Payment_Plan_Milestones__c> paymentPlanLst = [SELECT Id, Days_after_Booking__c, Milestone_age__c, Milestone_Activation__c, Name, 
                                                                Payment_Plan__c, Project_Progress__c, Sequence_No__c,Milestone_Code__c
                                                                FROM Payment_Plan_Milestones__c 
                                                                WHERE Payment_Plan__c =: requestLst[0].planId ORDER BY Sequence_No__c];
                                                                
            system.debug('paymentPlanLst==='+paymentPlanLst);
            return new List<String>{JSON.serialize(paymentPlanLst)};
        } catch (Exception e) {throw new AuraHandledException(e.getMessage()); }
    }

    public class Requests {
        @InvocableVariable(label='Plan Id' required=true)
        public String planId;
    }
}