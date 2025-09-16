public with sharing class CreatePaymentLineItemForGst {
    
    @InvocableMethod(label='Create Payment Line Item For GST')
    public static void execute( List<Request> requestLst){
        for(request req :requestLst){
            String paymentId = req.paymentId;
            String bookingId = req.bookingId;
            String category = req.category;
            set<Payment_Milestones__c> paymentMilestoneIdSet = new set<Payment_Milestones__c>();
            List<Payment_Milestones__c> ListToUpdatePM_01 = new List<Payment_Milestones__c>();
            List<Payment_Milestones__c> ListToUpdatePM_02 = new List<Payment_Milestones__c>();
            
            List<Payment_Line__c> creditPayment = new List<Payment_Line__c>();
            
            List<Payment_Line__c> paymentLinesToInsert = new List<Payment_Line__c>();
            Decimal Balance = 0;
            Payment__c payment =[SELECT Id, Amount__c, Payment_Category__c, Payment_Status__c FROM Payment__c WHERE Id =: paymentId];
            List<Payment_Milestones__c> paymentMileStoneList = [SELECT Id,Name, Remaining_Amount__c, Remaining_GST__c,Remaining_Milestone_Amount__c,Interest_on_milestone_amount__c
                                                                ,Remaining_GST1__c,Interest_on_GST__c,Milestone_Status__c
                                                                FROM Payment_Milestones__c 
                                                                WHERE Booking__c =: bookingId AND Name!=:System.Label.OtherChargesMilestone ORDER BY Milestone_Status__c Asc,Sequence_No__c asc];
            for(Payment_Milestones__c objPm : paymentMileStoneList){
                if(objPm.Milestone_Status__c == 'Active'){
                    //Balance = Balance + objPm.Remaining_Amount__c;
                    Balance = Balance + objPm.Remaining_GST__c;
                }
            }
            //Booking__c objBooking = [Select Id, Name,Cheque_Bounced_Charges__c From Booking__c where Id =: bookingId];
            
            //List<Booking__c> ListToUpdateBooking = new List<Booking__c>();
            Decimal remaining_amount;
            
            remaining_amount = payment.Amount__c;
            if(paymentMileStoneList!=null && paymentMileStoneList.size()>0){
                if(payment.Payment_Category__c == 'GST'){
                    for(Payment_Milestones__c objPm : paymentMileStoneList){
                        if(objPm.Milestone_Status__c == 'Active' && objPm.Remaining_GST1__c > 0){
                            Payment_Line__c payLine = new Payment_Line__c();
                            payLine.Credit_Amount__c = payment.Amount__c;
                            payLine.Milestone__c = objPm.Id;
                            payLine.Payment__c = payment.Id;
                            payLine.Adjusted_against__c= payment.Payment_Category__c;
                            payLine.Payment_Category__c = payment.Payment_Category__c;
                            payLine.Balance__c = Balance;
                            creditPayment.add(payLine);
                            break;
                        }
                    }
                    
                    for(Payment_Milestones__c paymentMilestone : paymentMileStoneList){
                        system.debug('payment.Payment_Category__c=='+payment.Payment_Category__c);
                        /*if(paymentMilestone.Interest_on_GST__c != null && paymentMilestone.Interest_on_GST__c > 0){
                            if( paymentMilestone.Interest_on_GST__c >= remaining_amount ){
                                Balance = Balance - remaining_amount;
                                Payment_Line__c paymentLine2 = new Payment_Line__c();
                                paymentLine2.Amount__c = remaining_amount;
                                paymentLine2.Milestone__c = paymentMilestone.Id;
                                paymentLine2.Payment__c = payment.Id;
                                paymentLine2.Adjusted_against__c = 'Interest on due GST';
                                paymentLine2.Payment_Category__c = payment.Payment_Category__c;
                                paymentLine2.Balance__c = Balance;
                                paymentLinesToInsert.add(paymentLine2);
                                
                                paymentMilestone.Interest_on_GST__c = paymentMilestone.Interest_on_GST__c - remaining_amount;
                                ListToUpdatePM_01.add(paymentMilestone);
                                break;
                            }
                            else{
                                remaining_amount = remaining_amount - paymentMilestone.Interest_on_GST__c;
                                Balance = Balance - paymentMilestone.Interest_on_GST__c;
                                Payment_Line__c paymentLine2 = new Payment_Line__c();
                                paymentLine2.Amount__c = paymentMilestone.Interest_on_GST__c;
                                paymentLine2.Milestone__c = paymentMilestone.Id;
                                paymentLine2.Payment__c = payment.Id;
                                paymentLine2.Adjusted_against__c = 'Interest on due GST';
                                paymentLine2.Payment_Category__c = payment.Payment_Category__c;
                                paymentLine2.Balance__c = Balance;
                                paymentLinesToInsert.add(paymentLine2);
                                
                                paymentMilestone.Interest_on_GST__c = 0;
                                ListToUpdatePM_01.add(paymentMilestone);
                                break;
                            }
                        }
                        else*/ if(paymentMilestone.Remaining_GST1__c != null && paymentMilestone.Remaining_GST1__c > 0){
                            if( paymentMilestone.Remaining_GST1__c >= remaining_amount ){
                                Balance = Balance - remaining_amount;
                                Payment_Line__c paymentLine3 = new Payment_Line__c();
                                paymentLine3.Amount__c = remaining_amount;
                                paymentLine3.Milestone__c = paymentMilestone.Id;
                                paymentLine3.Payment__c = payment.Id;
                                paymentLine3.Adjusted_against__c = 'GST Amount';
                                paymentLine3.Payment_Category__c = payment.Payment_Category__c;
                                paymentLine3.Payment_Status__c = payment.Payment_Status__c;
                                paymentLine3.Balance__c = Balance;
                                paymentLinesToInsert.add(paymentLine3);
                                
                                paymentMilestone.Remaining_GST1__c = paymentMilestone.Remaining_GST1__c - remaining_amount;
                                ListToUpdatePM_02.add(paymentMilestone);
                                break;
                            }
                            else{
                                remaining_amount = remaining_amount - paymentMilestone.Remaining_GST1__c;
                                Balance = Balance - paymentMilestone.Remaining_GST1__c;
                                Payment_Line__c paymentLine3 = new Payment_Line__c();
                                paymentLine3.Amount__c = paymentMilestone.Remaining_GST1__c;
                                paymentLine3.Milestone__c = paymentMilestone.Id;
                                paymentLine3.Payment__c = payment.Id;
                                paymentLine3.Adjusted_against__c = 'GST Amount';
                                paymentLine3.Payment_Category__c = payment.Payment_Category__c;
                                paymentLine3.Payment_Status__c = payment.Payment_Status__c;
                                paymentLine3.Balance__c = Balance;
                                paymentLinesToInsert.add(paymentLine3);
                                
                                paymentMilestone.Remaining_GST1__c = 0;
                                ListToUpdatePM_02.add(paymentMilestone);
                            }
                        }
                    }
                }
            }
            if(!creditPayment.isEmpty()){
                insert creditPayment;
            }
            
            if(!paymentLinesToInsert.isEmpty()){
                insert paymentLinesToInsert;
            }
            if(!ListToUpdatePM_01.isEmpty()){
                update ListToUpdatePM_01;
            }
            if(!ListToUpdatePM_02.isEmpty()){
                update ListToUpdatePM_02;
            }
            //update objBooking;
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