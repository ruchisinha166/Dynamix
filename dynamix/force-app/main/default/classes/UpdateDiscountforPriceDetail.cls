public with sharing class UpdateDiscountforPriceDetail{
    
    @InvocableMethod(label='Update Dicount Price Detail')
    public static void execute( List<Requests> requestLst){

        Decimal newAgreementValue = requestLst[0].newAgreementValue;
        Decimal newGSTValue = requestLst[0].newGSTValue;
        String bookingId= requestLst[0].bookingId;
        String[] DeleteListofPaymentMilestone;
        
        if(requestLst[0].DeleteIdsOfPM != null)
        {
           // paymentMilestoneIdforDelete =+ requestLst[0].DeleteIdsOfPM;
            DeleteListofPaymentMilestone = requestLst[0].DeleteIdsOfPM;
        }
        
        List<Price_Details__c> priceDetails = (List<Price_Details__c>)JSON.deserialize(requestLst[0].priceDetails, List<Price_Details__c>.class);

        update priceDetails;

        List<Payment_Milestones__c> paymentMilestones = (List<Payment_Milestones__c>)JSON.deserialize(requestLst[0].paymentMilestones, List<Payment_Milestones__c>.class);

        for(Payment_Milestones__c ppm : paymentMilestones){
            
            ppm.Milestone_age__c = (ppm.Milestone_Amount1__c/newAgreementValue)*100;
            
            if(ppm.id == null)
            {
             ppm.Booking__c = bookingId;
            }
            ppm.Name = ppm.Name;
            ppm.Sequence_No__c = ppm.Sequence_No__c;
            
           
        }

        upsert paymentMilestones;
        
          // For Payment Milestones Delete
       List<Payment_Milestones__c> DeletePaymentMilestoneLst = new List<Payment_Milestones__c>();
       DeletePaymentMilestoneLst = [select id from Payment_Milestones__c where Id IN : DeleteListofPaymentMilestone];
       system.debug('==> var id ' + DeletePaymentMilestoneLst);
       if(DeletePaymentMilestoneLst.size() > 0)
       {
           delete DeletePaymentMilestoneLst;
       }
    }

    public class Requests {
        
        @InvocableVariable(label='Price Details' required=true)
        public String priceDetails;
        
        @InvocableVariable(label='Payment Milestones' required=true)
        public String paymentMilestones;

        @InvocableVariable(label='New Agreement Value' required=true)
        public Decimal newAgreementValue;
        
        @InvocableVariable(label='New GST Value' required=true)
        public Decimal newGSTValue;
        
        @InvocableVariable(label='DeleteIdsOfPM' required=true)
        public String[] DeleteIdsOfPM;
        
        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
        
        
    }
}