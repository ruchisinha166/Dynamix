/*
* Added on 20/02/2024 
* Added by Nachiketa Khera
* To square off the payments of Other Charges and security/share money from the milestone named (Possession/Handover(Other) Charge)
*/
public with sharing class CreatePaymentLineItemForOtherCharges {
    @InvocableMethod(label='Create Payment Line Item For Other Charges')
    public static void execute( List<Request> requestLst){
        for(request req :requestLst){
            String paymentId = req.paymentId;
            String bookingId = req.bookingId;
            String category = req.category;
            
            List<Payment_Milestones__c> ListToUpdateMilestone = new List<Payment_Milestones__c>();
            List<Payment_Line__c> paymentLinesToInsert = new List<Payment_Line__c>();
            
            Decimal Balance = 0;
            Decimal UnitCostBalance =0;
            
            Payment__c payment = [SELECT Id, Amount__c, Payment_Category__c, Payment_Status__c FROM Payment__c WHERE Id =: paymentId];
            List<Payment_Milestones__c> paymentMileStoneList = [SELECT Id,name, Remaining_Amount__c, Remaining_GST__c,Remaining_Milestone_Amount__c,Interest_on_milestone_amount__c
                                                                ,Remaining_GST1__c,Interest_on_GST__c,Milestone_Status__c,Unit_Cost__c,Remaining_Unit_Cost__c
                                                                FROM Payment_Milestones__c 
                                                                WHERE Booking__c =: bookingId AND Name =:System.Label.OtherChargesMilestone limit 1];
            for(Payment_Milestones__c mile : paymentMileStoneList){
                if(mile.Milestone_Status__c == 'Active'){
                    if(mile.Remaining_Milestone_Amount__c != null && mile.Remaining_Milestone_Amount__c > 0)
                    {
                        Balance = Balance + mile.Remaining_Milestone_Amount__c; 
                    }
                    if(mile.Remaining_Unit_Cost__c != null && mile.Remaining_Unit_Cost__c > 0)
                    {
                        UnitCostBalance = UnitCostBalance + mile.Remaining_Unit_Cost__c;
                    }
                }
            }
            Decimal remaining_amount;
            remaining_amount = payment.Amount__c;
            if(paymentMileStoneList!=null && paymentMileStoneList.size()>0){
                for(Payment_Milestones__c paymentMilestone : paymentMileStoneList){
                    system.debug('payment.Payment_Category__c=='+payment.Payment_Category__c);
                    if(paymentMilestone.Remaining_Unit_Cost__c != null && paymentMilestone.Remaining_Unit_Cost__c > 0){
                        if( paymentMilestone.Remaining_Unit_Cost__c >= remaining_amount ){
                            system.debug('Unit_Cost__c--'+paymentMilestone.Unit_Cost__c);
                            system.debug('Balance Before--'+Balance);
                            Balance = Balance - remaining_amount;
                            system.debug('Balance After--'+Balance);
                            Payment_Line__c paymentLine = new Payment_Line__c();
                            paymentLine.Amount__c = remaining_amount;
                            paymentLine.Payment_Category__c = payment.Payment_Category__c;
                            paymentLine.Milestone__c = paymentMilestone.Id;
                            paymentLine.Payment__c = payment.Id;
                            paymentLine.Adjusted_against__c = 'Milestone Amount';
                            paymentLine.Balance__c = Balance;
                            paymentLine.Payment_Status__c = payment.Payment_Status__c;
                            paymentLinesToInsert.add(paymentLine);
                            paymentMilestone.Remaining_Milestone_Amount__c = paymentMilestone.Remaining_Milestone_Amount__c - remaining_amount;
                            paymentMilestone.Remaining_Unit_Cost__c = paymentMilestone.Remaining_Unit_Cost__c - remaining_amount;
                            ListToUpdateMilestone.add(paymentMilestone);
                            break;
                        }
                        else{
                            remaining_amount = remaining_amount - paymentMilestone.Remaining_Unit_Cost__c;
                            Balance = Balance - paymentMilestone.Remaining_Milestone_Amount__c;
                            Payment_Line__c paymentLine1 = new Payment_Line__c();
                            paymentLine1.Amount__c = paymentMilestone.Remaining_Unit_Cost__c;
                            paymentLine1.Payment_Category__c = payment.Payment_Category__c;
                            paymentLine1.Milestone__c = paymentMilestone.Id;
                            paymentLine1.Payment__c = payment.Id;
                            paymentLine1.Adjusted_against__c = 'Milestone Amount';
                            paymentLine1.Balance__c = Balance;
                            paymentLine1.Payment_Status__c = payment.Payment_Status__c;
                            paymentLinesToInsert.add(paymentLine1);
                            system.debug('paymentLine1--'+paymentLine1);
                            paymentMilestone.Remaining_Milestone_Amount__c = paymentMilestone.Remaining_Milestone_Amount__c - paymentMilestone.Remaining_Unit_Cost__c;
                            paymentMilestone.Remaining_Unit_Cost__c = 0;
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