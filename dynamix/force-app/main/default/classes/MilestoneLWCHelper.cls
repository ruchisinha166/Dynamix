public with sharing class MilestoneLWCHelper {
    @AuraEnabled (cacheable=true)
    public static List<Payment_Milestones__c> getMilestoneList(String projectProgId){
        try {
            system.debug('projectProgId ==>> ' + projectProgId);
            List<Payment_Milestones__c> paymentMilestoneList=new List<Payment_Milestones__c>();
            paymentMilestoneList= [Select Id,Name,Milestone_Amount1__c,Milestone_Status__c,Booking__c,Booking__r.name,Booking__r.Primary_Applicant_Name_Formulla__c,
                                   Booking__r.Unit_Number__c,Project_Progress__c,Booking__r.Stage__c From Payment_Milestones__c Where Milestone_Status__c=:'Inactive' 
                                   AND Project_Progress__c!=null AND Booking__r.Stage__c!='Terminated' AND Booking__r.Stage__c!='Cancellation Initiated' 
                                   AND Booking__r.Stage__c!='Booking Cancelled – Refund Pending' AND Booking__r.Stage__c!='Booking Cancelled – Refund Ready'
                                   AND Project_Progress__c=:projectProgId];
            return paymentMilestoneList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}