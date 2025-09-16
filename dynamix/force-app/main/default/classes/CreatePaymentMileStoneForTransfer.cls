public with sharing class CreatePaymentMileStoneForTransfer {
    
    @InvocableMethod(label='Create Payment Milestone For Transfer')
    public static void execute( List<Requests> requestLst){
         String bookingId = requestLst[0].bookingId;
         Booking__c bk = [select id,Project_Name__r.Transfer_Charges__c,Related_Suggested_Property__c,Booking__c.Related_Suggested_Property__r.unit__r.RERA_Carpet_Area_in_sqmtr__c,Related_Opportunity__c,Related_Property__c from Booking__c where id =: bookingId];
         
         List<Payment_Milestones__c> payMileList  = [select id from Payment_Milestones__c where booking__c =: bk.id];
         Decimal seqno = payMileList.size();
         List<Payment_Milestones__c> paymentMilestoneLst = new List<Payment_Milestones__c>();
        Payment_Milestones__c paymentMilestone = new Payment_Milestones__c();
        paymentMilestone.Booking__c = bk.Id;
        paymentMilestone.Name = 'Transfer Charge';
        paymentMilestone.Sequence_No__c = seqno +1;
        paymentMilestone.Milestone_age__c = 0;
        
        if(bk.Project_Name__r.Transfer_Charges__c != null && bk.Related_Suggested_Property__r.Unit__r.RERA_Carpet_Area_in_sqmtr__c != null)
        {
        paymentMilestone.Milestone_Amount1__c = bk.Project_Name__r.Transfer_Charges__c * bk.Related_Suggested_Property__r.Unit__r.RERA_Carpet_Area_in_sqmtr__c;
        }
        paymentMilestone.GST_Amount1__c = 0;
        paymentMilestoneLst.add(paymentMilestone);
        insert paymentMilestoneLst;
         
        
            
    }
    
    public class Requests {
    
    @InvocableVariable(label='Booking Id' required=true)
    public String bookingId;
    
    /*@InvocableVariable(label='Suggested Property Id' required=true)
    public String suggestedPropertyId;
    
    @InvocableVariable(label='Property Id' required=true)
    public String propertyId;
    
    @InvocableVariable(label='Opportunity Id' required=true)
    public String opportunityId;*/
    }
}