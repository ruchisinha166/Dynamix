public class BookingPaymentPlan {
    
    @InvocableMethod(label='Get Booking Payment Plans')
    public static List<Response> execute(List<Requests> requestLst){
        Decimal newAgreementValue = 0;
        
        Decimal newGSTValue = 0;
        
        
        List<Payment_Milestones__c> paymentPlanLst = [SELECT Id, Booking__c,Milestone_age__c, Milestone_Status__c,Milestone_Amount1__c,GST_Amount1__c, 
                                                      Name, Due_Date__c,Milestone_Activation_Date__c, Booking__r.Stage__c,Booking__r.Active_Milestones__c,
                                                      Payment_Received__c, Project_Progress__c, Sequence_No__c,Booking_Stage__c, Booking__r.Agreement_Value__c, 
                                                      TDS_Value__c,Booking__r.Registration_Status__c
                                                      FROM Payment_Milestones__c 
                                                      WHERE Booking__c =: requestLst[0].bookingId AND Name!=:System.Label.OtherChargesMilestone
                                                      ORDER BY Sequence_No__c];
        
        for(Payment_Milestones__c pm : paymentPlanLst)
        {
            
            system.debug('===> Milestone_Amount1__c ' + pm.Milestone_Amount1__c);
            system.debug('===> GST_Amount1__c' + pm.GST_Amount1__c);
            system.debug('===> Booking_Stage__c' + pm.Booking_Stage__c);
            newAgreementValue += pm.Milestone_Amount1__c;
            newGSTValue += pm.GST_Amount1__c; 
        }
        system.debug('===>total  newAgreementValue ' + newAgreementValue );
        system.debug('===> total newGSTValue  ' + newGSTValue);
        String jsonstring = JSON.serialize(paymentPlanLst);
        
        //return new List<String>{JSON.serialize(paymentPlanLst)};
         Response response = new Response();
         response.stringpaymentPlanLst= JSON.serialize(paymentPlanLst);
         response.newAgreementValue = newAgreementValue.setScale(2);
         response.newGSTValue = newGSTValue.setScale(2);
         return new List<Response>{response};
    }

    public class Requests {
        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
       
    }
     public class Response {
        
        @InvocableVariable(label='Payment Milestones' required=true)
        public String stringpaymentPlanLst;
         
        
        @InvocableVariable(label='New Agreement Value' required=true)
        public Decimal newAgreementValue;
        
        @InvocableVariable(label='New GST Value' required=true)
        public Decimal newGSTValue;
        
        
    }
}