public with sharing class CreatePaymentLineItemForInterest {
    
    @InvocableMethod(label='Create Payment Line Item For Milestone Interest')
    public static void execute( List<Request> requestLst){
        String paymentId = requestLst[0].paymentId;
        String bookingId = requestLst[0].bookingId;
        String category = requestLst[0].category;
        
        List<Payment_Line__c> paymentLinesToInsert = new List<Payment_Line__c>();
        
        Payment__c payment =[SELECT Id, Amount__c, Payment_Category__c, Payment_Status__c FROM Payment__c WHERE Id =: paymentId];
        List<Payment_Milestones__c> paymentMileStoneList = [SELECT Id, Remaining_Amount__c, Total_Interest_Amount__c,Remaining_GST__c 
                                                            FROM Payment_Milestones__c 
                                                            WHERE Booking__c =: bookingId And Total_Interest_Amount__c > 0 ORDER BY Milestone_Status__c Asc,Sequence_No__c asc];
        
        if(paymentMileStoneList!=null && paymentMileStoneList.size()>0){
            system.debug('paymentMileStoneList=='+paymentMileStoneList);
             for(Payment_Milestones__c paymentMilestone : paymentMileStoneList){
                if(payment.Payment_Category__c == 'Interest'){
                    if( paymentMilestone.Total_Interest_Amount__c >= payment.Amount__c ){
                        Payment_Line__c paymentLine = new Payment_Line__c();
                        paymentLine.Amount__c = payment.Amount__c;
                        paymentLine.Milestone__c = paymentMilestone.Id;
                        paymentLine.Payment__c = payment.Id;
                        paymentLine.Payment_Category__c = payment.Payment_Category__c;
                        paymentLinesToInsert.add(paymentLine);
                        break;
                    }
                    else{
                        payment.Amount__c = payment.Amount__c - paymentMilestone.Total_Interest_Amount__c;
                        Payment_Line__c paymentLine = new Payment_Line__c();
                        paymentLine.Amount__c = paymentMilestone.Total_Interest_Amount__c;
                        paymentLine.Milestone__c = paymentMilestone.Id;
                        paymentLine.Payment__c = payment.Id;
                        paymentLine.Payment_Category__c = payment.Payment_Category__c;
                        paymentLinesToInsert.add(paymentLine);
                        
                    }
                }
                
                
            }
        }
        if(!paymentLinesToInsert.isEmpty()){
            insert paymentLinesToInsert;
        }
        
    }
     public class Request {
        @InvocableVariable(label='Payment Id' required=true)
        public String paymentId;

        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;

        @InvocableVariable(label='Category' required=true)
        public String category;
    }
}