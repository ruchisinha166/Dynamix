public class TDSScript {

    Public static Void Execute(String Status){
        
        Map<Id,List<Payment__c>> PaymentMap = New  Map<Id,List<Payment__c>>();
        Decimal PaymentBalance =0;
        
        List<Payment__c> paymentList = [SELECT ID,Amount__c,Payment_Category__c,Booking__c,Remaining_TDS_Amount__c
                                        FROM Payment__c WHERE Payment_Category__c ='TDS' 
                                        AND Payment_Status__c ='Approved' AND Booking__c!= NULL  ];
        system.debug('paymentList--'+paymentList);
        
        if(!paymentList.IsEmpty()){
            for(Payment__c pc :paymentList){
                if(PaymentMap.containsKey(pc.Booking__c)){
                    PaymentMap.get(pc.Booking__c).add(pc);
                    
                }else{
                    PaymentMap.put(pc.Booking__c,New List<Payment__c>{pc});
                }       
            }
        }
        system.debug('PaymentMap....'+PaymentMap);
        List<Payment_Milestones__c> MilestoneUpdateList = new List<Payment_Milestones__c>();
        
        List<Payment_Milestones__c> MilestoneList = [SELECT Id,Booking__c ,TDS_Received__c,TDS_Pending__c,TDS_Due__c,TDS_Value__c
                                                     from Payment_Milestones__c WHERE Booking__c =:PaymentMap.Keyset() AND TDS_Pending__c >0 AND Milestone_Status__c =: Status  Order By Sequence_No__c ASC];
        system.debug('MilestoneList--'+MilestoneList);
        if(!MilestoneList.IsEmpty()){
            Map<String,Decimal> paymentKNOCKOFFMaP = NEW Map<String,Decimal>();
            Map<String,Decimal> paymentMilKNOCKOFFMaP = NEW Map<String,Decimal>();
            for(Payment_Milestones__c  miles :MilestoneList){
                system.debug('miles--'+miles);
                Decimal TDSBalance = miles.TDS_Pending__c;
                if(PaymentMap.containsKey(miles.Booking__c)){
                    system.debug('PaymentMap.get(miles.Booking__c)--'+PaymentMap.get(miles.Booking__c));
                    system.debug('TDSBalance--'+TDSBalance);
                    for(Payment__C payment :PaymentMap.get(miles.Booking__c)){  
                        system.debug('TDSBalance in p--'+TDSBalance);
                        if(!paymentKNOCKOFFMaP.containskey(payment.Id)){
                            IF(payment.Remaining_TDS_Amount__c != null){
                                paymentKNOCKOFFMaP.put(payment.Id,payment.Remaining_TDS_Amount__c);
                            }else{
                                paymentKNOCKOFFMaP.put(payment.Id,payment.Amount__C);
                            }
                        }
                        system.debug('paymentKNOCKOFFMaP.get(payment.Id)--'+paymentKNOCKOFFMaP.get(payment.Id));
                        if(TDSBalance > 0 && paymentKNOCKOFFMaP.get(payment.Id) > 0){
                            SYSTEM.DEBUG('Clled');
                            if(TDSBalance >= paymentKNOCKOFFMaP.get(payment.Id)){
                                Payment_Milestones__c paymentMilestone = New Payment_Milestones__c();
                                paymentMilestone.id= miles.Id;
                                paymentMilestone.TDS_Received__c = paymentKNOCKOFFMaP.get(payment.Id);
                                //paymentMilestone.TDS_Pending__c = TDS_Pending__c-payment.Amount__C;
                                TDSBalance = TDSBalance - paymentMilestone.TDS_Received__c;
                                paymentKNOCKOFFMaP.put(payment.Id, 0);
                                
                                system.debug('paymentMilestone.TDS_Received__c--'+paymentMilestone.TDS_Received__c);
                                if(paymentMilKNOCKOFFMaP.containskey(miles.Id)){
                                    Decimal amount = paymentMilKNOCKOFFMaP.get(miles.Id) + paymentMilestone.TDS_Received__c;
                                    paymentMilKNOCKOFFMaP.put(miles.Id,amount);
                                }else{
                                    paymentMilKNOCKOFFMaP.put(miles.Id,paymentMilestone.TDS_Received__c);
                                }
                                  
                            }else{
                                Payment_Milestones__c paymentMilestone = New Payment_Milestones__c();
                                paymentMilestone.id= miles.Id;
                                paymentMilestone.TDS_Received__c = TDSBalance;
                                
                                paymentKNOCKOFFMaP.put(payment.Id, paymentKNOCKOFFMaP.get(payment.Id) - TDSBalance);
                                system.debug('paymentMilestone.paymentMilestone.TDS_Received__c--'+paymentMilestone.TDS_Received__c);
                                if(paymentMilKNOCKOFFMaP.containskey(miles.Id)){
                                    Decimal amount = paymentMilKNOCKOFFMaP.get(miles.Id) + paymentMilestone.TDS_Received__c;
                                    paymentMilKNOCKOFFMaP.put(miles.Id,amount);
                                }else{
                                    paymentMilKNOCKOFFMaP.put(miles.Id,paymentMilestone.TDS_Received__c);
                                }
                                TDSBalance = 0;
                            }
                        }
                    }      
                    
                }
            }
            SYSTEM.DEBUG('paymentKNOCKOFFMaP---'+paymentKNOCKOFFMaP);
            for(String pymnt1 :paymentMilKNOCKOFFMaP.Keyset()){
                Payment_Milestones__c newpymntMilestone = New Payment_Milestones__c();
                newpymntMilestone.id=pymnt1;
                newpymntMilestone.TDS_Received__c = paymentMilKNOCKOFFMaP.get(pymnt1);
                MilestoneUpdateList.add(newpymntMilestone);
            }
            system.debug('MilestoneUpdateList--'+MilestoneUpdateList);
            if(!MilestoneUpdateList.IsEmpty()){
                Update  MilestoneUpdateList;
                system.debug('MilestoneUpdateList--'+MilestoneUpdateList);
            }
            List<Payment__c> pymntupdateList = New  List<Payment__c>();
            for(String pymnt :paymentKNOCKOFFMaP.Keyset()){
                Payment__c newpymnt = New Payment__c();
                newpymnt.id=pymnt;
                newpymnt.Remaining_TDS_Amount__c = paymentKNOCKOFFMaP.get(pymnt);
                pymntupdateList.Add(newpymnt);
            }
            system.debug('pymntupdateList--'+pymntupdateList);
            If(!pymntupdateList.IsEmpty()){
                Update pymntupdateList;
            }
        }   
    } 
}