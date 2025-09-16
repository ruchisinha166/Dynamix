public class updateInterestWaveOffAmountOnBooking{
    
    @InvocableMethod(label='Update Hidden Interest Wafe Off Amount On Booking Milestones')
    public static void execute( List<Requests> requestLst){
        
        system.debug('===> requestLst ' + requestLst);
        String bookingId= requestLst[0].bookingId;
      
        Decimal InterestWaveOffAmount = requestLst[0].inputedInterestValue;
        
        Booking__c bk = [select Hidden_Interest_Wave_Off_Amount__c from Booking__c where id =: bookingId];
        system.debug('==> bk' + bk);
        system.debug('==> InterestWaveOffAmount ' + InterestWaveOffAmount );
        if(InterestWaveOffAmount != null)
        {
            bk.Hidden_Interest_Wave_Off_Amount__c = InterestWaveOffAmount;
        }
        update bk;
        
    }
     
     
     public class Requests {
        
       @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
        
        @InvocableVariable(label='Input Interest Value' required=true)
        public Decimal inputedInterestValue;
       
      
    }
}