public class UpdateTranferPaymentStatusNew{
    @InvocableMethod(label='Update Transfer Payment Status')
     public static void execute(List<Requests> requestLst){
    
        system.debug('===> requestLst ' + requestLst);
        String bookingId = requestLst[0].bookingId;
        
        //String paymentId= requestLst[0].paymentId;
        
        List<Payment__c> payList = [select id,Payment__c,booking__c,Payment_Status__c from Payment__c where booking__c = : bookingId ];
        
        Map<Id,Payment__c> mapOfSelfPayemtId = new Map<Id,Payment__c>();
        for(Payment__c pay : payList)
        {
            mapOfSelfPayemtId.put(pay.Payment__c,pay);
        } 
        List<Payment__c> payListForUpdateStatus = [select id,Payment__c,Payment_Status__c from Payment__c where Id IN : mapOfSelfPayemtId.keyset()];
        system.debug('===> ' + payListForUpdateStatus);
        Map<Id,Payment__c> mapOfUpdatePaymentIds = new Map<Id,Payment__c>();
        for(Payment__c pay : payListForUpdateStatus)
        {
            mapOfUpdatePaymentIds.put(pay.id,pay);
        }
        
        
        for(Payment__c pay : payList)
        {
            if(mapOfUpdatePaymentIds.containskey(pay.Payment__c))
            {
                pay.Payment_Status__c = mapOfUpdatePaymentIds.get(pay.Payment__c).Payment_Status__c;
                
                //mapofpay.get(pay.id).Payment_Status__c = pay.Payment_Status__c;
            }
        }
        
        update payList;
        system.debug('===> ' + payList);
        //system.debug('===> ' + payids);
      
        
    }
    public class Requests {
        
       
        
        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
        
       

    }
    
}