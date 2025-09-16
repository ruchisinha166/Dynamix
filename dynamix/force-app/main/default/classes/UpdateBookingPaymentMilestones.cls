public with sharing class UpdateBookingPaymentMilestones{
    
    @InvocableMethod(label='Update Booking Payment Milestones')
    public static void execute( List<Requests> requestLst){
        
        system.debug('===> requestLst ' + requestLst);
        String bookingId= requestLst[0].bookingId;
        String paymentMilestoneId = requestLst[0].JsonMilestone;
        Decimal newAgreementValue = requestLst[0].newAgreementValue;
        
        List<String> paymentMilestoneIdforDelete = new List<String>();
        String[] VarIds;
        if(requestLst[0].DeleteIdsOfPM != null)
        {
            // paymentMilestoneIdforDelete =+ requestLst[0].DeleteIdsOfPM;
            VarIds = requestLst[0].DeleteIdsOfPM;
        }
        system.debug('paymentMilestoneIdforDelete ==> ' + paymentMilestoneIdforDelete );
        system.debug('VarIds ==> ' + VarIds );
        Booking__c bk = [select Related_Suggested_Property__c from Booking__c where id =: bookingId];
        
        List<Payment_Milestones__c> UpdatePaymentMilestoneList = [select id,Name,Project_Progress__c,Milestone_age__c,Milestone_Activation_Date__c from Payment_Milestones__c where Booking__c = : bookingId];
        system.debug('===> UpdatePaymentMilestoneList ' + UpdatePaymentMilestoneList);
        system.debug('===> paymentMilestoneId ' + paymentMilestoneId);
        
        List<Payment_Milestones__c> paymentMilestones = (List<Payment_Milestones__c>)JSON.deserialize(requestLst[0].JsonMilestone, List<Payment_Milestones__c>.class);
        
        for(Payment_Milestones__c ppm : paymentMilestones){
            if(ppm.Name != 'Possession/Handover(Other) Charge'){
                ppm.Milestone_age__c = (ppm.Milestone_Amount1__c/newAgreementValue)*100;
            }
            if(ppm.id == null)
            {
                ppm.Booking__c = bookingId;
            }
            ppm.Name = ppm.Name;
            ppm.Sequence_No__c = ppm.Sequence_No__c;
            
            
        }
        
        if(paymentMilestones.size() > 0)
        {
            upsert paymentMilestones;
        }
        //system.debug('===> updatePaymentMilestoneLst' + updatePaymentMilestoneLst);
        
        // For Payment Milestones Delete
        List<Payment_Milestones__c> DeletePaymentMilestoneLst = new List<Payment_Milestones__c>();
        DeletePaymentMilestoneLst = [select id from Payment_Milestones__c where Id IN : VarIds];
        system.debug('==> var id ' + DeletePaymentMilestoneLst);
        if(DeletePaymentMilestoneLst.size() > 0)
        {
            delete DeletePaymentMilestoneLst;
        }
        
        
        
    }
    public class Requests {
        
        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
        
        @InvocableVariable(label='JsonString' required=true)
        public String JsonMilestone;
        
        @InvocableVariable(label='DeleteIdsOfPM' required=true)
        public String[] DeleteIdsOfPM;
        
        @InvocableVariable(label='New Agreement Value' required=true)
        public Decimal newAgreementValue;
        
    }
}