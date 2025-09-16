public class CreatePaymentLineItemForCarParking {
    @InvocableMethod(label='Create Payment Line Item For Car Parking Milestone')
    public static void execute( List<Request> requestLst){
        for(request req :requestLst){
            String paymentId = req.paymentId;
            String bookingId = req.bookingId;
            String category = req.category;
            
            List<Payment_Milestones__c> ListToUpdatePM_01 = new List<Payment_Milestones__c>();
            List<Payment_Line__c> paymentLinesToInsert = new List<Payment_Line__c>();
            
            Decimal Balance = 0;
            Decimal UnitCostBalance =0;
            Payment__c payment =[SELECT Id, Amount__c, Payment_Category__c, Payment_Status__c FROM Payment__c WHERE Id =: paymentId];
            List<Payment_Milestones__c> paymentMileStoneList = [SELECT Id,name, Remaining_Amount__c, Remaining_GST__c,Remaining_Milestone_Amount__c,Interest_on_milestone_amount__c
                                                                ,Remaining_GST1__c,Interest_on_GST__c,Milestone_Status__c,Unit_Cost__c,Remaining_Unit_Cost__c
                                                                FROM Payment_Milestones__c 
                                                                WHERE Booking__c =: bookingId AND Name=:System.Label.CarParkingMilestone ORDER BY Milestone_Status__c Asc,Sequence_No__c asc];
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
            Decimal remaining_amount;
            remaining_amount = payment.Amount__c;
            if(paymentMileStoneList!=null && paymentMileStoneList.size()>0){
                if(payment.Payment_Category__c == 'Parking'){
                    for(Payment_Milestones__c paymentMilestone : paymentMileStoneList){
                        if(paymentMilestone.Remaining_Unit_Cost__c != null && paymentMilestone.Remaining_Unit_Cost__c > 0){
                            if( paymentMilestone.Remaining_Unit_Cost__c >= remaining_amount ){
                                system.debug('1--'+paymentMilestone.Unit_Cost__c);
                                system.debug('3--'+Balance);
                                Balance = Balance - remaining_amount;
                                system.debug('2--'+Balance);
                                Payment_Line__c paymentLine1 = new Payment_Line__c();
                                paymentLine1.Amount__c = remaining_amount;
                                paymentLine1.Milestone__c = paymentMilestone.Id;
                                paymentLine1.Payment__c = payment.Id;
                                paymentLine1.Adjusted_against__c = 'Milestone Amount';
                                paymentLine1.Payment_Category__c = payment.Payment_Category__c;
                                paymentLine1.Payment_Status__c = payment.Payment_Status__c;
                                paymentLine1.Balance__c = Balance;
                                paymentLinesToInsert.add(paymentLine1);
                                paymentMilestone.Remaining_Milestone_Amount__c = paymentMilestone.Remaining_Milestone_Amount__c - remaining_amount;
                                paymentMilestone.Remaining_Unit_Cost__c = paymentMilestone.Remaining_Unit_Cost__c - remaining_amount;
                                ListToUpdatePM_01.add(paymentMilestone);
                                break;
                            }
                            else{
                                remaining_amount = remaining_amount - paymentMilestone.Remaining_Unit_Cost__c;
                                Balance = Balance - paymentMilestone.Remaining_Milestone_Amount__c;
                                Payment_Line__c paymentLine2 = new Payment_Line__c();
                                paymentLine2.Amount__c = paymentMilestone.Remaining_Unit_Cost__c;
                                paymentLine2.Milestone__c = paymentMilestone.Id;
                                paymentLine2.Payment__c = payment.Id;
                                paymentLine2.Adjusted_against__c = 'Milestone Amount';
                                paymentLine2.Payment_Category__c = payment.Payment_Category__c;
                                paymentLine2.Payment_Status__c = payment.Payment_Status__c;
                                paymentLine2.Balance__c = Balance;
                                paymentLinesToInsert.add(paymentLine2);
                                system.debug('paymentLine2--'+paymentLine2);
                                paymentMilestone.Remaining_Milestone_Amount__c = paymentMilestone.Remaining_Milestone_Amount__c - paymentMilestone.Remaining_Unit_Cost__c;
                                paymentMilestone.Remaining_Unit_Cost__c = 0;
                                ListToUpdatePM_01.add(paymentMilestone);
                            }
                        } 
                    }
                }
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