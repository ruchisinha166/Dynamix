public class GetBasePrice {
    
     @InvocableMethod(label='Get Charges By Type')
    public static List<Decimal> execute( List<Requests> requestLst){
         	List<Property_Add_On__c> propertyAddOnList = new List<Property_Add_On__c>();
         	PropertyPriceJSON propertyPrice = new PropertyPriceJSON();
          	List<Decimal> basePriceList = new List<Decimal>();
        	Pricing_Plan_Components__c PricingPlanList = new Pricing_Plan_Components__c();
        
         	Property__c property = [SELECT id,Pricing_Plan_Detail__c,Property_Price_Slab__c FROM Property__c WHERE Id =: requestLst[0].propertyId];
            if(property <> null)
            {
              PricingPlanList = [select id,Price_Lumpsum__c from Pricing_Plan_Components__c where (Pricing_Plan__c =: property.Property_Price_Slab__c AND (Name =: 'Basic Price' OR Project_Add_On_Charges__r.name = 'Basic Price'))];  
            }
            basePriceList.add(PricingPlanList.Price_Lumpsum__c);
            return basePriceList;
    }
    
    public class Requests {
        @InvocableVariable(label='Property Id' required=true)
        public String propertyId;

    }

}