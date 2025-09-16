/*
* Added on 21/02/2024 
* Added by Nachiketa Khera
* To square off the GST payments of Other Charges and security/share money from the milestone named (Possession/Handover(Other) Charge)
*/
public class CreatePaymentLineItemForOtherChargesGST {
    @InvocableMethod(label='Create Payment Line Item For Other Charges GST')
    public static void execute( List<Request> requestLst){
        for(request req :requestLst){
            String paymentId = req.paymentId;
            String bookingId = req.bookingId;
            String category = req.category;
            
            List<Payment_Milestones__c> ListToUpdateMilestone = new List<Payment_Milestones__c>();
            List<Payment_Line__c> paymentLinesToInsert = new List<Payment_Line__c>();
            
            Decimal Balance = 0;
            
            Payment__c payment = [SELECT Id, Amount__c, Payment_Category__c, Payment_Status__c FROM Payment__c WHERE Id =: paymentId];
            List<Payment_Milestones__c> paymentMileStoneList = [SELECT Id,name, Remaining_Amount__c, Remaining_GST__c,Remaining_Milestone_Amount__c,Interest_on_milestone_amount__c
                                                                ,Remaining_GST1__c,Interest_on_GST__c,Milestone_Status__c,Unit_Cost__c,Remaining_Unit_Cost__c
                                                                FROM Payment_Milestones__c 
                                                                WHERE Booking__c =: bookingId AND Name =:System.Label.OtherChargesMilestone limit 1];
            for(Payment_Milestones__c mile : paymentMileStoneList){
                if(mile.Milestone_Status__c == 'Active'){
                    if(mile.Remaining_GST__c != null && mile.Remaining_GST__c > 0)
                    {
                        Balance = Balance + mile.Remaining_GST__c; 
                    }
                }
            }
            Decimal remaining_amount;
            remaining_amount = payment.Amount__c;
            if(paymentMileStoneList!=null && paymentMileStoneList.size()>0){
                for(Payment_Milestones__c paymentMilestone : paymentMileStoneList){
                    system.debug('payment.Payment_Category__c=='+payment.Payment_Category__c);
                    if(paymentMilestone.Remaining_GST__c != null && paymentMilestone.Remaining_GST__c > 0){
                        if( paymentMilestone.Remaining_GST__c >= remaining_amount ){
                            Balance = Balance - remaining_amount;
                            Payment_Line__c paymentLine = new Payment_Line__c();
                            paymentLine.Amount__c = remaining_amount;
                            paymentLine.Milestone__c = paymentMilestone.Id;
                            paymentLine.Payment__c = payment.Id;
                            paymentLine.Payment_Category__c = category;
                            paymentLine.Payment_Status__c = payment.Payment_Status__c;
                            paymentLine.Adjusted_against__c = 'GST Amount';
                            paymentLine.Balance__c = Balance;
                            paymentLinesToInsert.add(paymentLine);
                            
                            paymentMilestone.Remaining_GST1__c = paymentMilestone.Remaining_GST1__c - remaining_amount;
                            ListToUpdateMilestone.add(paymentMilestone);
                        }
                        else{
                            remaining_amount = remaining_amount - paymentMilestone.Remaining_GST__c;
                            Balance = Balance - paymentMilestone.Remaining_GST__c;
                            Payment_Line__c paymentLine1 = new Payment_Line__c();
                            paymentLine1.Amount__c = paymentMilestone.Remaining_GST__c;
                            paymentLine1.Milestone__c = paymentMilestone.Id;
                            paymentLine1.Payment__c = payment.Id;
                            paymentLine1.Payment_Category__c = category;
                            paymentLine1.Payment_Status__c = payment.Payment_Status__c;
                            paymentLine1.Adjusted_against__c = 'GST Amount';
                            paymentLine1.Balance__c = Balance;
                            paymentLinesToInsert.add(paymentLine1);
                            
                            paymentMilestone.Remaining_GST1__c = 0;
                            ListToUpdateMilestone.add(paymentMilestone);
                        }
                    }
                }
            }
            if(!paymentLinesToInsert.isEmpty()){
                insert paymentLinesToInsert;
            }
            if(!ListToUpdateMilestone.isEmpty()){
                update ListToUpdateMilestone;
            }
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