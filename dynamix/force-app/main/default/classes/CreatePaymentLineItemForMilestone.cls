public with sharing class CreatePaymentLineItemForMilestone {
    @InvocableMethod(label='Create Payment Line Item For Milestone')
    public static void execute( List<Request> requestLst){
        for(request req :requestLst){
            String paymentId = req.paymentId;
            String bookingId = req.bookingId;
            String category = req.category;
            set<Payment_Milestones__c> paymentMilestoneIdSet = new set<Payment_Milestones__c>();
            List<Payment_Milestones__c> ListToUpdatePM_01 = new List<Payment_Milestones__c>();
            List<Payment_Milestones__c> ListToUpdatePM_02 = new List<Payment_Milestones__c>();
            List<Payment_Milestones__c> ListToUpdatePM_03 = new List<Payment_Milestones__c>();
            List<Payment_Milestones__c> ListToUpdatePM_04 = new List<Payment_Milestones__c>();
            List<Payment_Line__c> creditPayment = new List<Payment_Line__c>();
            List<Payment_Line__c> paymentLinesToInsert = new List<Payment_Line__c>();
            Decimal Balance = 0;
            Decimal UnitCostBalance =0;
            Payment__c payment =[SELECT Id, Amount__c, Payment_Category__c, Payment_Status__c FROM Payment__c WHERE Id =: paymentId];
            List<Payment_Milestones__c> paymentMileStoneList = [SELECT Id,name, Remaining_Amount__c, Remaining_GST__c,Remaining_Milestone_Amount__c,Interest_on_milestone_amount__c
                                                                ,Remaining_GST1__c,Interest_on_GST__c,Milestone_Status__c,Unit_Cost__c,Remaining_Unit_Cost__c
                                                                FROM Payment_Milestones__c 
                                                                WHERE Booking__c =: bookingId AND Name!=:System.Label.OtherChargesMilestone ORDER BY Milestone_Status__c Asc,Sequence_No__c asc];
            for(Payment_Milestones__c objPm : paymentMileStoneList){
                if(objPm.Milestone_Status__c == 'Active'){
                    if(objPm.Remaining_Milestone_Amount__c != null && objPm.Remaining_Milestone_Amount__c > 0)
                    {
                         Balance = Balance + objPm.Remaining_Milestone_Amount__c; 
                    }
                    if(objPm.Remaining_Unit_Cost__c != null && objPm.Remaining_Unit_Cost__c > 0)
                    {
                         UnitCostBalance = UnitCostBalance + objPm.Remaining_Unit_Cost__c;
                    }
                   
                }
            }
            Booking__c objBooking = [Select Id, Name,Cheque_Bounced_Charges__c From Booking__c where Id =: bookingId];
            List<Booking__c> ListToUpdateBooking = new List<Booking__c>();
            Decimal remaining_amount;
            remaining_amount = payment.Amount__c;
            if(paymentMileStoneList!=null && paymentMileStoneList.size()>0){
                if(payment.Payment_Category__c == 'Unit Cost'){
                    for(Payment_Milestones__c objPm : paymentMileStoneList){
                        if(objPm.Milestone_Status__c == 'Active' && objPm.Remaining_Milestone_Amount__c > 0){
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
                        if(objBooking.Cheque_Bounced_Charges__c > 0){
                            if(objBooking.Cheque_Bounced_Charges__c >= remaining_amount){
                                Balance = Balance - remaining_amount;
                                Payment_Line__c paymentLine = new Payment_Line__c();
                                paymentLine.Amount__c = remaining_amount;
                                paymentLine.Milestone__c = paymentMilestone.Id;
                                paymentLine.Payment__c = payment.Id;
                                paymentLine.Adjusted_against__c = 'Cheque Bounce Charges';
                                paymentLine.Balance__c = Balance;
                                paymentLinesToInsert.add(paymentLine);
                                objBooking.Cheque_Bounced_Charges__c = objBooking.Cheque_Bounced_Charges__c - remaining_amount;
                                break;
                            }
                            else{
                                remaining_amount = remaining_amount - objBooking.Cheque_Bounced_Charges__c;
                                Balance = Balance - objBooking.Cheque_Bounced_Charges__c;
                                Payment_Line__c paymentLine = new Payment_Line__c();
                                paymentLine.Amount__c = objBooking.Cheque_Bounced_Charges__c;
                                paymentLine.Milestone__c = paymentMilestone.Id;
                                paymentLine.Payment__c = payment.Id;
                                paymentLine.Adjusted_against__c = 'Cheque Bounce Charges';
                                paymentLine.Balance__c = Balance;
                                paymentLinesToInsert.add(paymentLine);
                                objBooking.Cheque_Bounced_Charges__c = 0;
    
                                if(remaining_amount > 0){
                                    if( paymentMilestone.Interest_on_milestone_amount__c >= remaining_amount ){
                                        Balance = Balance - remaining_amount;
                                        Payment_Line__c paymentLine4 = new Payment_Line__c();
                                        paymentLine4.Amount__c = remaining_amount;
                                        paymentLine4.Milestone__c = paymentMilestone.Id;
                                        paymentLine4.Payment__c = payment.Id;
                                        paymentLine4.Adjusted_against__c = 'Interest on due Milestone Amount';
                                        paymentLine4.Balance__c = Balance;
                                        paymentLinesToInsert.add(paymentLine4);
                                        paymentMilestone.Interest_on_milestone_amount__c = paymentMilestone.Interest_on_milestone_amount__c - remaining_amount;
                                        ListToUpdatePM_03.add(paymentMilestone);
                                        break;
                                    }
                                    else{
                                        remaining_amount = remaining_amount - paymentMilestone.Interest_on_milestone_amount__c;
                                        Balance = Balance - paymentMilestone.Interest_on_milestone_amount__c;
                                        Payment_Line__c paymentLine4 = new Payment_Line__c();
                                        paymentLine4.Amount__c = paymentMilestone.Interest_on_milestone_amount__c;
                                        paymentLine4.Milestone__c = paymentMilestone.Id;
                                        paymentLine4.Payment__c = payment.Id;
                                        paymentLine4.Adjusted_against__c = 'Interest on due Milestone Amount';
                                        paymentLine4.Balance__c = Balance;
                                        paymentLinesToInsert.add(paymentLine4);
                                        paymentMilestone.Interest_on_milestone_amount__c = 0;
                                        ListToUpdatePM_03.add(paymentMilestone);
                                        if(remaining_amount > 0){
                                            if( paymentMilestone.Remaining_Milestone_Amount__c >= remaining_amount ){
                                                Balance = Balance - remaining_amount;
                                                Payment_Line__c paymentLine5 = new Payment_Line__c();
                                                paymentLine5.Amount__c = remaining_amount;
                                                paymentLine5.Milestone__c = paymentMilestone.Id;
                                                paymentLine5.Payment__c = payment.Id;
                                                paymentLine5.Adjusted_against__c = 'Milestone Amount';
                                                paymentLine5.Balance__c = Balance;
                                                paymentLinesToInsert.add(paymentLine5);
                                                paymentMilestone.Remaining_Milestone_Amount__c = paymentMilestone.Remaining_Milestone_Amount__c - remaining_amount;
                                                ListToUpdatePM_04.add(paymentMilestone);
                                                break;
                                            }
                                            else{
                                                remaining_amount = remaining_amount - paymentMilestone.Remaining_Milestone_Amount__c;
                                                Balance = Balance - paymentMilestone.Remaining_Milestone_Amount__c;
                                                Payment_Line__c paymentLine5 = new Payment_Line__c();
                                                paymentLine5.Amount__c = paymentMilestone.Remaining_Milestone_Amount__c;
                                                paymentLine5.Milestone__c = paymentMilestone.Id;
                                                paymentLine5.Payment__c = payment.Id;
                                                paymentLine5.Adjusted_against__c = 'Milestone Amount';
                                                paymentLine5.Balance__c = Balance;
                                                paymentLinesToInsert.add(paymentLine5);
                                                paymentMilestone.Remaining_Milestone_Amount__c = 0;
                                                ListToUpdatePM_04.add(paymentMilestone);
                                            }
                                        }else{
                                            break;
                                        }
                                    }
                                }else{
                                    break;
                                }
                            }
                        }/*else if(paymentMilestone.Interest_on_milestone_amount__c != null && paymentMilestone.Interest_on_milestone_amount__c > 0){
                            if( paymentMilestone.Interest_on_milestone_amount__c >= remaining_amount ){
                                Balance = Balance - remaining_amount;
                                Payment_Line__c paymentLine4 = new Payment_Line__c();
                                paymentLine4.Amount__c = remaining_amount;
                                paymentLine4.Milestone__c = paymentMilestone.Id;
                                paymentLine4.Payment__c = payment.Id;
                                paymentLine4.Adjusted_against__c = 'Interest on due Milestone Amount';
                                paymentLine4.Balance__c = Balance;
                                paymentLinesToInsert.add(paymentLine4);
                                paymentMilestone.Interest_on_milestone_amount__c = paymentMilestone.Interest_on_milestone_amount__c - remaining_amount;
                                ListToUpdatePM_01.add(paymentMilestone);
                                break;
                            }
                            else{
                                remaining_amount = remaining_amount - paymentMilestone.Interest_on_milestone_amount__c;
                                Balance = Balance - paymentMilestone.Interest_on_milestone_amount__c;
                                Payment_Line__c paymentLine4 = new Payment_Line__c();
                                paymentLine4.Amount__c = paymentMilestone.Interest_on_milestone_amount__c;
                                paymentLine4.Milestone__c = paymentMilestone.Id;
                                paymentLine4.Payment__c = payment.Id;
                                paymentLine4.Adjusted_against__c = 'Interest on due Milestone Amount';
                                paymentLine4.Balance__c = Balance;
                                paymentLinesToInsert.add(paymentLine4);
                                paymentMilestone.Interest_on_milestone_amount__c = 0;
                                ListToUpdatePM_01.add(paymentMilestone);
                                if(remaining_amount > 0){
                                    if( paymentMilestone.Remaining_Milestone_Amount__c >= remaining_amount ){
                                        Balance = Balance - remaining_amount;
                                        Payment_Line__c paymentLine5 = new Payment_Line__c();
                                        paymentLine5.Amount__c = remaining_amount;
                                        paymentLine5.Milestone__c = paymentMilestone.Id;
                                        paymentLine5.Payment__c = payment.Id;
                                        paymentLine5.Adjusted_against__c = 'Milestone Amount';
                                        paymentLine5.Balance__c = Balance;
                                        paymentLinesToInsert.add(paymentLine5);
                                        paymentMilestone.Remaining_Milestone_Amount__c = paymentMilestone.Remaining_Milestone_Amount__c - remaining_amount;
                                        ListToUpdatePM_02.add(paymentMilestone);
                                        break;
                                    }
                                    else{
                                        remaining_amount = remaining_amount - paymentMilestone.Remaining_Milestone_Amount__c;
                                        Balance = Balance - paymentMilestone.Remaining_Milestone_Amount__c;
                                        Payment_Line__c paymentLine5 = new Payment_Line__c();
                                        paymentLine5.Amount__c = paymentMilestone.Remaining_Milestone_Amount__c;
                                        paymentLine5.Milestone__c = paymentMilestone.Id;
                                        paymentLine5.Payment__c = payment.Id;
                                        paymentLine5.Adjusted_against__c = 'Milestone Amount';
                                        paymentLine5.Balance__c = Balance;
                                        paymentLinesToInsert.add(paymentLine5);
                                        paymentMilestone.Remaining_Milestone_Amount__c = 0;
                                        ListToUpdatePM_02.add(paymentMilestone); 
                                    }
                                }else{
                                    break;
                                }
                            }
                        }*/else if(paymentMilestone.Remaining_Unit_Cost__c != null && paymentMilestone.Remaining_Unit_Cost__c > 0){  
                            if( paymentMilestone.Remaining_Unit_Cost__c >= remaining_amount ){
                                system.debug('1--'+paymentMilestone.Unit_Cost__c);
                                system.debug('3--'+Balance);
                                Balance = Balance - remaining_amount;
                                system.debug('2--'+Balance);
                                Payment_Line__c paymentLine5 = new Payment_Line__c();
                                paymentLine5.Amount__c = remaining_amount;
                                paymentLine5.Milestone__c = paymentMilestone.Id;
                                paymentLine5.Payment__c = payment.Id;
                                paymentLine5.Adjusted_against__c = 'Milestone Amount';
                                paymentLine5.Payment_Category__c = payment.Payment_Category__c;
                                paymentLine5.Payment_Status__c = payment.Payment_Status__c;
                                paymentLine5.Balance__c = Balance;
                                paymentLinesToInsert.add(paymentLine5);
                                paymentMilestone.Remaining_Milestone_Amount__c = paymentMilestone.Remaining_Milestone_Amount__c - remaining_amount;
                                paymentMilestone.Remaining_Unit_Cost__c = paymentMilestone.Remaining_Unit_Cost__c - remaining_amount;
                                ListToUpdatePM_01.add(paymentMilestone);
                                break;
                            }
                            else{
                                remaining_amount = remaining_amount - paymentMilestone.Remaining_Unit_Cost__c;
                                Balance = Balance - paymentMilestone.Remaining_Milestone_Amount__c;
                                Payment_Line__c paymentLine5 = new Payment_Line__c();
                                paymentLine5.Amount__c = paymentMilestone.Remaining_Unit_Cost__c;
                                paymentLine5.Milestone__c = paymentMilestone.Id;
                                paymentLine5.Payment__c = payment.Id;
                                paymentLine5.Adjusted_against__c = 'Milestone Amount';
                                paymentLine5.Payment_Category__c = payment.Payment_Category__c;
                                paymentLine5.Payment_Status__c = payment.Payment_Status__c;
                                paymentLine5.Balance__c = Balance;
                                paymentLinesToInsert.add(paymentLine5);
                                system.debug('paymentLine5--'+paymentLine5);
                                paymentMilestone.Remaining_Milestone_Amount__c = paymentMilestone.Remaining_Milestone_Amount__c - paymentMilestone.Remaining_Unit_Cost__c;
                                paymentMilestone.Remaining_Unit_Cost__c = 0;
                                ListToUpdatePM_01.add(paymentMilestone);
                            }
                        } 
                    }
                }
                else{
                    /*for(Payment_Milestones__c objPm : paymentMileStoneList){
                        if(objPm.Milestone_Status__c == 'Active'){
                            Payment_Line__c payLine = new Payment_Line__c();
                            payLine.Payment_Category__c = category;
                            payLine.Credit_Amount__c = payment.Amount__c;
                            payLine.Milestone__c = objPm.Id;
                            payLine.Payment__c = payment.Id;
                            payLine.Adjusted_against__c= payment.Payment_Category__c;
                            payLine.Balance__c = Balance;
                            creditPayment.add(payLine);
                            break;
                        }
                    }*/
                }
            }
            if(!creditPayment.isEmpty()){
                insert creditPayment;
            }
            if(!paymentLinesToInsert.isEmpty()){
                system.debug('paymentLinesToInsert.>> '+paymentLinesToInsert.size());
                insert paymentLinesToInsert;
            }
            if(!ListToUpdatePM_01.isEmpty()){
                update ListToUpdatePM_01;
            }
            if(!ListToUpdatePM_02.isEmpty()){
                update ListToUpdatePM_02;
            }
            if(!ListToUpdatePM_03.isEmpty()){
                update ListToUpdatePM_03;
            }
            if(!ListToUpdatePM_04.isEmpty()){
                update ListToUpdatePM_04;
            }
            update objBooking;
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