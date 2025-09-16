public with sharing class UpdateAgreementValue{
    
    @InvocableMethod(label='Get New Agreement Value')
    public static List<Response> execute( List<Requests> requestLst){
        
        Decimal newAgreementValue = 0;
        Decimal newGSTValue = 0;
        
        for(Price_Details__c priceDetail: (List<Price_Details__c>)JSON.deserialize(requestLst[0].priceDetails, List<Price_Details__c>.class)){
            
            newAgreementValue += priceDetail.Amount__c - priceDetail.Discount__c;
            newGSTValue += (priceDetail.Amount__c - priceDetail.Discount__c) * priceDetail.GST__c/100;
            
        }

        Response response = new Response();
        response.newAgreementValue = newAgreementValue;
        response.newGSTValue = newGSTValue;

        return new List<Response>{response};
    }

    public class Requests {
        
        @InvocableVariable(label='Price Details' required=true)
        public String priceDetails;
    }

    public class Response {
        
        @InvocableVariable(label='New Agreement Value' required=true)
        public Decimal newAgreementValue;
        
         @InvocableVariable(label='New GST Value' required=true)
        public Decimal newGSTValue;
        
        
    }
}