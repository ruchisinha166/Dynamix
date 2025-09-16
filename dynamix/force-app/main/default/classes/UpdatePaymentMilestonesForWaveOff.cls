public with sharing class UpdatePaymentMilestonesForWaveOff{
    
    @InvocableMethod(label='Update Booking Payment Milestones For Wave Off')
    public static void execute( List<Requests> requestLst){
        
        system.debug('===> requestLst ' + requestLst);
        String bookingId= requestLst[0].bookingId;
       // String paymentMilestoneId = requestLst[0].JsonMilestone;
         system.debug('===> bookingId' + bookingId);
        
       
        
        Booking__c bk = [select Related_Suggested_Property__c,Hidden_Interest_Wave_Off_Amount__c,Interest_Wafe_Off_Approved__c from Booking__c where id =: bookingId];
        Decimal InterestWaveOffAmount = bk.Hidden_Interest_Wave_Off_Amount__c;
        system.debug('===> InterestWaveOffAmount ' + InterestWaveOffAmount);
        

       List<Payment_Milestones__c> paymentMileStoneList = [SELECT Id,Interest_Amount__c,Total_Interest_Amount__c,Interest_Wave_Off_Amount__c,Milestone_Amount1__c,GST_Amount1__c,Remaining_Amount__c, Remaining_GST__c 
                                                            FROM Payment_Milestones__c 
                                                            WHERE Booking__c = : bookingId And Total_Interest_Amount__c > 0 ORDER BY Milestone_Status__c Asc,Sequence_No__c asc];
        system.debug('======> paymentMileStoneList ' + paymentMileStoneList );
       for(Payment_Milestones__c pm : paymentMileStoneList)
       {
               system.debug('======> pm.Interest_Wave_Off_Amount__c' + pm.Interest_Wave_Off_Amount__c);
                system.debug('======> pm.pm.Interest_Amount__c' + pm.Interest_Amount__c);
                system.debug('======> InterestWaveOffAmount' + InterestWaveOffAmount);
              if(pm.Interest_Wave_Off_Amount__c == null)
              {
                  pm.Interest_Wave_Off_Amount__c = 0;
              }
              if(pm.Total_Interest_Amount__c>= InterestWaveOffAmount){
                   pm.Interest_Wave_Off_Amount__c = pm.Interest_Wave_Off_Amount__c + InterestWaveOffAmount;
                   break;
              }
              else{
                   pm.Interest_Wave_Off_Amount__c = pm.Interest_Wave_Off_Amount__c + pm.Total_Interest_Amount__c;
                   InterestWaveOffAmount = InterestWaveOffAmount - pm.Total_Interest_Amount__c;
                   
              }
       }
       
       update paymentMileStoneList;
       
       // update Interest Wafe Off Approved Field
       bk.Interest_Wafe_Off_Approved__c = false;
       update bk;
        
    }
    public class Requests {
        
       @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
        
      /* @InvocableVariable(label='JsonString' required=true)
        public String JsonMilestone;
        
       @InvocableVariable(label='Input Interest Value' required=true)
        public Decimal inputedInterestValue;*/

    }
}