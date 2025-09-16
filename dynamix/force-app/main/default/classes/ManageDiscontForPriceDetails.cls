public class ManageDiscontForPriceDetails {
    
    @InvocableMethod(label='Get Price Detail for Discount')
    public static List<String> execute(List<Requests> requestLst){
        
        List<Price_Details__c> priceDetailLst = [SELECT Id, Name, Amount__c, GST_Calculated__c, Discount__c, 
                                                    Total_Amount_incl_Tax__c, Charge_Group__c,GST__c
                                                    
                                                    FROM Price_Details__c 
                                                    WHERE Booking__c =: requestLst[0].bookingId 
                                                        AND Charge_Group__c LIKE '%Agreement%' 
                                                        ORDER BY Name];
        
        String JsonPmString = JSON.serialize(priceDetailLst);
        
        return new List<String>{JSON.serialize(priceDetailLst)};
    }

    public class Requests {
        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
    }
}