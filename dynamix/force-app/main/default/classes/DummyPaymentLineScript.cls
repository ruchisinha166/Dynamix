public class DummyPaymentLineScript {
    public static void insertPaymentLine(list<id> bkids){ 
    List<Payment_Line__c> paymentLinesToInsert = new List<Payment_Line__c>();
List<Payment_Milestones__c> paymentMileStoneList = [SELECT Id,Booking__c,Milestone_Amount1__c,GST_Amount1__c,Remaining_Amount__c, Remaining_GST__c,Sequence_No__c FROM Payment_Milestones__c WHERE Booking__c IN: bkids ORDER BY Milestone_Status__c Asc,Sequence_No__c asc];
system.debug('===> paymentMileStoneList ' + paymentMileStoneList);

Map<String,Decimal> MapOfPaymentMilestoneAndRemainingAmt = new Map<String,Decimal>();
        Map<String,Decimal> MapOfPaymentMilestoneAndRemainingGSTAmt = new Map<String,Decimal>();
        if(paymentMileStoneList != null && paymentMileStoneList.size() > 0)
        {
            for(Payment_Milestones__c pm : paymentMileStoneList)
            {
                
                MapOfPaymentMilestoneAndRemainingAmt.put(String.valueOf(pm.Sequence_No__c)+pm.id,pm.Remaining_Amount__c);
                MapOfPaymentMilestoneAndRemainingGSTAmt.put(String.valueOf(pm.Sequence_No__c)+pm.id,pm.Remaining_GST__c);
            }
        }
system.debug('===> MapOfPaymentMilestoneAndRemainingAmt ' + MapOfPaymentMilestoneAndRemainingAmt);
system.debug('===> MapOfPaymentMilestoneAndRemainingGSTAmt ' + MapOfPaymentMilestoneAndRemainingGSTAmt);

List<Payment__c> payment = [SELECT Id,Payment_Status__c,Amount__c,Booking__c,Payment_Category__c FROM Payment__c WHERE Booking__c IN: bkids ORDER BY CreatedDate];
system.debug('===> payment ' + payment);

if(payment!=null && payment.size()>0){
    for(Payment__c pay : payment)
    {
        for(Payment_Milestones__c paymentMilestone : paymentMileStoneList){
            system.debug('===> paymentMilestone seq ' + paymentMilestone.Sequence_No__c);
            if(pay.Amount__c==0)
                        {
                            break;
                        }
            Decimal RemainAmount = MapOfPaymentMilestoneAndRemainingAmt.get(String.valueOf(paymentMilestone.Sequence_No__c)+paymentMilestone.id);
            Decimal GSTRemainAmount = MapOfPaymentMilestoneAndRemainingGSTAmt.get(String.valueOf(paymentMilestone.Sequence_No__c)+paymentMilestone.id);
            if(pay.Payment_Category__c.containsignorecase('Unit Cost'))
                        {
                            //system.debug('===> paymentMilestone.Remaining_Amount__c ' + MapOfPaymentMilestoneAndRemainingAmt.get(paymentMilestone.id));
                            //system.debug('===> pay.Amount__c ' + pay.Amount__c);
                            
                            if(RemainAmount >= pay.Amount__c )
                            {
                                system.debug('in if');
                                Payment_Line__c paymentLine = new Payment_Line__c();
                                paymentLine.Payment_Status__c = pay.Payment_Status__c;
                                paymentLine.Amount__c = pay.Amount__c;
                                paymentLine.Milestone__c = paymentMilestone.Id;
                                paymentLine.Payment__c = pay.Id;
                                paymentLine.Payment_Category__c = pay.Payment_Category__c;
                                paymentLinesToInsert.add(paymentLine);
                                RemainAmount-=pay.Amount__c;
                                MapOfPaymentMilestoneAndRemainingAmt.put(String.valueOf(paymentMilestone.Sequence_No__c)+paymentMilestone.id,RemainAmount);
                                break;
                            }
                            else{
                              //  system.debug('in else');
                               // system.debug('=======> in else ' + pay.Amount__c );
                                pay.Amount__c = pay.Amount__c - RemainAmount ;
                                Payment_Line__c paymentLine = new Payment_Line__c();
                                paymentLine.Amount__c = RemainAmount ;
                                paymentLine.Payment_Status__c = pay.Payment_Status__c;
                                paymentLine.Milestone__c = paymentMilestone.Id;
                                paymentLine.Payment__c = pay.Id;
                                paymentLine.Payment_Category__c = pay.Payment_Category__c;
                                paymentLinesToInsert.add(paymentLine);
                                RemainAmount = 0;
                                MapOfPaymentMilestoneAndRemainingAmt.put(String.valueOf(paymentMilestone.Sequence_No__c)+paymentMilestone.id,RemainAmount);
                            }
                        }
                        else if(pay.Payment_Category__c.containsignorecase('GST'))
                        {
                            if(GSTRemainAmount >= pay.Amount__c )
                            {
                                Payment_Line__c paymentLine = new Payment_Line__c();
                                paymentLine.Amount__c = pay.Amount__c;
                                paymentLine.Payment_Status__c = pay.Payment_Status__c;
                                paymentLine.Milestone__c = paymentMilestone.Id;
                                paymentLine.Payment__c = pay.Id;
                                paymentLine.Payment_Category__c = pay.Payment_Category__c;
                                paymentLinesToInsert.add(paymentLine);
                                GSTRemainAmount-=pay.Amount__c;
                                MapOfPaymentMilestoneAndRemainingGSTAmt.put(String.valueOf(paymentMilestone.Sequence_No__c)+paymentMilestone.id,GSTRemainAmount);
                                break;
                            }
                            else{
                                pay.Amount__c = pay.Amount__c - GSTRemainAmount;
                                Payment_Line__c paymentLine = new Payment_Line__c();
                                paymentLine.Amount__c = GSTRemainAmount;
                                paymentLine.Payment_Status__c = pay.Payment_Status__c;
                                paymentLine.Milestone__c = paymentMilestone.Id;
                                paymentLine.Payment__c = pay.Id;
                                paymentLine.Payment_Category__c = pay.Payment_Category__c;
                                paymentLinesToInsert.add(paymentLine);
                                GSTRemainAmount = 0;
                                MapOfPaymentMilestoneAndRemainingGSTAmt.put(String.valueOf(paymentMilestone.Sequence_No__c)+paymentMilestone.id,GSTRemainAmount);
                               
                                
                            }
                        }
        }
    }
   // system.debug('==> paymentLinesToInsert ' + paymentLinesToInsert);
   // system.debug('==> paymentLinesToInsert size ' + paymentLinesToInsert.size());
    if(!paymentLinesToInsert.isEmpty()){
        upsert paymentLinesToInsert;
    }
    
}
      
}

}