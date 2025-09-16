public with sharing class GetCharges {
    
    @InvocableMethod(label='Get Charges By Type')
    public static List<Decimal> execute( List<Requests> requestLst){
          List<Property_Add_On__c> propertyAddOnList = new List<Property_Add_On__c>();
          PropertyPriceJSON propertyPrice = new PropertyPriceJSON();
          Property__c property = [SELECT id,Pricing_Plan_Detail__c FROM Property__c WHERE Id =: requestLst[0].propertyId];  
          Decimal PLC = 0;
          if(property.Pricing_Plan_Detail__c != null)
          {
              propertyPrice = (PropertyPriceJSON)JSON.deserialize(property.Pricing_Plan_Detail__c, PropertyPriceJSON.class);
             
          }
          if(requestLst[0].chargeType == 'Preferred Location')
          {   Id recordTypeId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
              propertyAddOnList = [SELECT Id, Name, Property__c, Property__r.Pricing_Plan_Detail__c, Project_Add_On__c,Project_Add_On__r.Name, Is_Included__c 
                                   FROM Property_Add_On__c WHERE Project_Add_On__r.recordTypeId =: recordTypeId AND Property__c =: requestLst[0].propertyId];
          }
            List<String> plcs = new List<String>();
            for(Property_Add_On__c propAddOn: propertyAddOnList){
                plcs.add(propAddOn.Project_Add_On__r.Name);
            }
            
            String preferredLocation = String.join(plcs, ', ');
            for(PropertyPriceJSON.PriceComponent component: propertyPrice.components)
            {
                   if(component.type == 'Preferred Location' && preferredLocation.contains(component.name))
                   {
                          PLC += component.priceLumpSum;
                   }
            } 
        
          List<Decimal> totalList = new List<Decimal>();
          totalList.add(PLC);
          return totalList;
    }

   public class Requests {
        @InvocableVariable(label='Property Id' required=true)
        public String propertyId;

        @InvocableVariable(label='Charge Type' required=true)
        public String chargeType;

        @InvocableVariable(label='Charge Name')
        public String chargeName;
    }
}