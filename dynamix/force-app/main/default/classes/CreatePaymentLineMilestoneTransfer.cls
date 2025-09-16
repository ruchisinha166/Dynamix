public with sharing class CreatePaymentLineMilestoneTransfer {
    
    @InvocableMethod(label='Create Payment Line Item For Milestone Transfer Booking')
    public static void execute( List<Request> requestLst){
        String bookingId = requestLst[0].bookingId;
        system.debug('===> bookingId ' + bookingId);
        Boolean flag = false;
        
        List<Payment_Line__c> paymentLinesToInsert = new List<Payment_Line__c>();
        Map<Id,Payment_Milestones__c> MapToUpdateMilestone = new Map<Id,Payment_Milestones__c>();
        List<Payment_Milestones__c> ListToUpdateMilestone2 = new List<Payment_Milestones__c>();
        
        List<Payment_Milestones__c> paymentMileStoneList = [SELECT Id,Booking__c,Milestone_Amount1__c,GST_Amount1__c,Remaining_Amount__c,Remaining_Unit_Cost__c, 
                                                            Remaining_GST__c,Remaining_GST1__c,Sequence_No__c,Remaining_Milestone_Amount__c 
                                                            FROM Payment_Milestones__c 
                                                            WHERE Booking__c =: bookingId ORDER BY Milestone_Status__c Asc,Sequence_No__c asc];
        
        Map<Id,Decimal> MapOfPaymentMilestoneAndRemainingAmt = new Map<Id,Decimal>();
        Map<Id,Decimal> MapOfPaymentMilestoneAndRemainingGSTAmt = new Map<Id,Decimal>();
        if(paymentMileStoneList != null && paymentMileStoneList.size() > 0)
        {
            for(Payment_Milestones__c pm : paymentMileStoneList)
            {
                
                MapOfPaymentMilestoneAndRemainingAmt.put(pm.id,pm.Remaining_Unit_Cost__c);
                MapOfPaymentMilestoneAndRemainingGSTAmt.put(pm.id,pm.Remaining_GST__c);
            }
        }
        
        List<Payment__c> payment = [SELECT Id, Amount__c,Booking__c,Payment_Category__c,Payment_Status__c FROM Payment__c WHERE Booking__c =: bookingId ORDER BY CreatedDate];
        
        if(payment!=null && payment.size()>0){
            for(Payment__c pay : payment)
            {
                for(Payment_Milestones__c paymentMilestone : paymentMileStoneList)
                {
                    if(pay.Amount__c==0)
                    {
                        break;
                    }
                    Decimal RemainAmount = MapOfPaymentMilestoneAndRemainingAmt.get(paymentMilestone.id);
                    Decimal GSTRemainAmount = MapOfPaymentMilestoneAndRemainingGSTAmt.get(paymentMilestone.id);
                    if(pay.Payment_Category__c.containsignorecase('Unit Cost'))
                    {
                        system.debug('===> paymentMilestone.Remaining_Amount__c ' + MapOfPaymentMilestoneAndRemainingAmt.get(paymentMilestone.id));
                        system.debug('===> pay.Amount__c ' + pay.Amount__c);
                        if(RemainAmount > 0 && RemainAmount != null){
                            if(RemainAmount >= pay.Amount__c )
                            {
                                system.debug('in if');
                                Payment_Line__c paymentLine = new Payment_Line__c();
                                paymentLine.Amount__c = pay.Amount__c;
                                paymentLine.Milestone__c = paymentMilestone.Id;
                                paymentLine.Payment__c = pay.Id;
                                paymentLine.Payment_Category__c = pay.Payment_Category__c;
                                paymentLine.Payment_Status__c = pay.Payment_Status__c;
                                paymentLine.Adjusted_against__c = 'Unit Cost';
                                paymentLinesToInsert.add(paymentLine);
                                RemainAmount-=pay.Amount__c;
                                MapOfPaymentMilestoneAndRemainingAmt.put(paymentMilestone.id,RemainAmount);
                                paymentMilestone.Remaining_Milestone_Amount__c = paymentMilestone.Remaining_Milestone_Amount__c - pay.Amount__c;
                                paymentMilestone.Remaining_Unit_Cost__c = paymentMilestone.Remaining_Unit_Cost__c - pay.Amount__c;
                                MapToUpdateMilestone.put(paymentMilestone.Id,paymentMilestone);
                                break;
                            }
                            else{
                                system.debug('in else');
                                system.debug('=======> in else ' + pay.Amount__c );
                                pay.Amount__c = pay.Amount__c - RemainAmount ;
                                Payment_Line__c paymentLine = new Payment_Line__c();
                                paymentLine.Amount__c = RemainAmount ;
                                paymentLine.Milestone__c = paymentMilestone.Id;
                                paymentLine.Payment__c = pay.Id;
                                paymentLine.Payment_Category__c = pay.Payment_Category__c;
                                paymentLine.Payment_Status__c = pay.Payment_Status__c;
                                paymentLine.Adjusted_against__c = 'Unit Cost';
                                paymentLinesToInsert.add(paymentLine);
                                RemainAmount = 0;
                                MapOfPaymentMilestoneAndRemainingAmt.put(paymentMilestone.id,RemainAmount);
                                paymentMilestone.Remaining_Milestone_Amount__c = paymentMilestone.Remaining_Milestone_Amount__c - paymentMilestone.Remaining_Unit_Cost__c;
                                paymentMilestone.Remaining_Unit_Cost__c = 0;
                                MapToUpdateMilestone.put(paymentMilestone.Id,paymentMilestone);
                            }
                        }
                    }
                    else if(pay.Payment_Category__c.containsignorecase('GST'))
                    {
                        system.debug('===> paymentMilestone.Remaining_GST__c ' + MapOfPaymentMilestoneAndRemainingGSTAmt.get(paymentMilestone.id));
                        system.debug('===> pay.Amount__c ' + pay.Amount__c);
                        
                        if(GSTRemainAmount > 0 && GSTRemainAmount != null){
                            if(GSTRemainAmount >= pay.Amount__c )
                            {
                                Payment_Line__c paymentLine = new Payment_Line__c();
                                paymentLine.Amount__c = pay.Amount__c;
                                paymentLine.Milestone__c = paymentMilestone.Id;
                                paymentLine.Payment__c = pay.Id;
                                paymentLine.Payment_Category__c = pay.Payment_Category__c;
                                paymentLine.Payment_Status__c = pay.Payment_Status__c;
                                paymentLine.Adjusted_against__c = 'GST Amount';
                                paymentLinesToInsert.add(paymentLine);
                                GSTRemainAmount-=pay.Amount__c;
                                MapOfPaymentMilestoneAndRemainingGSTAmt.put(paymentMilestone.id,GSTRemainAmount);
                                paymentMilestone.Remaining_GST1__c = paymentMilestone.Remaining_GST1__c - pay.Amount__c;
                                MapToUpdateMilestone.put(paymentMilestone.Id,paymentMilestone);
                                break;
                            }
                            else{
                                pay.Amount__c = pay.Amount__c - GSTRemainAmount;
                                Payment_Line__c paymentLine = new Payment_Line__c();
                                paymentLine.Amount__c = GSTRemainAmount;
                                paymentLine.Milestone__c = paymentMilestone.Id;
                                paymentLine.Payment__c = pay.Id;
                                paymentLine.Payment_Category__c = pay.Payment_Category__c;
                                paymentLine.Payment_Status__c = pay.Payment_Status__c;
                                paymentLine.Adjusted_against__c = 'GST Amount';
                                paymentLinesToInsert.add(paymentLine); 
                                GSTRemainAmount = 0;
                                MapOfPaymentMilestoneAndRemainingGSTAmt.put(paymentMilestone.id,GSTRemainAmount);
                                paymentMilestone.Remaining_GST1__c = 0;
                                MapToUpdateMilestone.put(paymentMilestone.Id,paymentMilestone);            
                            }
                        }
                    }
                }
            }
            if(!paymentLinesToInsert.isEmpty()){
                system.debug('===> paymentLinesToInsert'  + paymentLinesToInsert);
                system.debug('===> paymentLinesToInsert size'  + paymentLinesToInsert.size());
                upsert paymentLinesToInsert; 
            }
            if(!MapToUpdateMilestone.isEmpty()){
                update MapToUpdateMilestone.values();
            }
        }
    }
    public class Request {
        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
    }
}