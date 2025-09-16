/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-31-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   12-31-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public class PricingPlanToJSON {

    public static void toJSON(List<Property__c> properties){

        Set<Id> planIds = new set<Id>();
        Map<id,List<Property__c>> propertPlanMap = new Map<id,List<Property__c>>();
       
        for(Property__c p : properties){  
            planIds.add(p.Property_Price_Slab__c); 
            
            if(propertPlanMap.containsKey(p.Property_Price_Slab__c)){   
                
                List<Property__c> propertyList = propertPlanMap.get(p.Property_Price_Slab__c);
                propertyList.add(p);
                propertPlanMap.put(p.Property_Price_Slab__c,propertyList);
            }
            else{
                List<Property__c> propertyList = new List<Property__c>();
                propertyList.add(p);
                propertPlanMap.put(p.Property_Price_Slab__c,propertyList);
            }
        }
     
        List<Pricing_Plan__c> pricingPlans = [SELECT Id, Name, Project__c, 
                                                (SELECT Id, Name, GST_Treatment__c, Project_Add_On_Charges__r.recordType.Name,
                                                    Price_Lumpsum__c,Price_per_SQFT__c,Pricing_Plan__c 
                                                    FROM Pricing_Plan_Components__r 
                                                    WHERE Project_Add_On_Charges__r.Charge_Type__c = 'Fixed') 
                                             FROM Pricing_Plan__c WHERE Id IN: planIds];
        
        for(Pricing_Plan__c plan : pricingPlans){

            PropertyPriceJSON priceJSON = new PropertyPriceJSON();
            priceJSON.components = new List<PropertyPriceJSON.PriceComponent>();

            for(Pricing_Plan_Components__c planComponent: plan.Pricing_Plan_Components__r){

                PropertyPriceJSON.PriceComponent priceComponent = new PropertyPriceJSON.PriceComponent();
                priceComponent.name = planComponent.Name;
                priceComponent.type = planComponent.Project_Add_On_Charges__r.recordType.name;
                priceComponent.gst = planComponent.GST_Treatment__c;
                priceComponent.priceLumpSum = planComponent.Price_Lumpsum__c;
                priceComponent.pricePerSQFT = planComponent.Price_per_SQFT__c;

                priceJSON.components.add(priceComponent);
            }
            
            List<Property__c> proList = propertPlanMap.get(plan.id);
            for(Property__c prop : proList){
                prop.Pricing_Plan_Detail__c = JSON.serialize(priceJSON);
            }
        }
    }
    
    public static void updateJSON(List<Pricing_Plan_Components__c> planComponents){
           
        Set<Id> planIds = new Set<Id>();
        Map<id,List<Property__c>> propertPlanMap = new Map<id,List<Property__c>>();
        List<Property__c> propertiesToUpdate = new List<Property__c>();
        
        for(Pricing_Plan_Components__c planComponent : planComponents){
            planIds.add(planComponent.Pricing_Plan__c);
        }

        for(Property__c property: [SELECT Id, Property_Price_Slab__c FROM Property__c WHERE Property_Price_Slab__c IN: planIds]){

            if(propertPlanMap.containsKey(property.Property_Price_Slab__c)){

                List<Property__c> propertyList = propertPlanMap.get(property.Property_Price_Slab__c);
                propertyList.add(property);
                propertPlanMap.put(property.Property_Price_Slab__c,propertyList);
            }
            else{   
                List<Property__c> propertyList = new List<Property__c>();
                propertyList.add(property);
                propertPlanMap.put(property.Property_Price_Slab__c,propertyList);
            }
        }

        List<Pricing_Plan__c> pricingPlans = [SELECT Id, Name, Project__c, 
                                                (SELECT Id, Name, GST_Treatment__c, Project_Add_On_Charges__r.recordType.Name,
                                                    Price_Lumpsum__c,Price_per_SQFT__c,Pricing_Plan__c 
                                                    FROM Pricing_Plan_Components__r 
                                                    WHERE Project_Add_On_Charges__r.Charge_Type__c = 'Fixed') 
                                             FROM Pricing_Plan__c WHERE Id IN: planIds];

        for(Pricing_Plan__c plan : pricingPlans){

            PropertyPriceJSON priceJSON = new PropertyPriceJSON();
            priceJSON.components = new List<PropertyPriceJSON.PriceComponent>();

            for(Pricing_Plan_Components__c planComponent: plan.Pricing_Plan_Components__r){

                PropertyPriceJSON.PriceComponent priceComponent = new PropertyPriceJSON.PriceComponent();
                priceComponent.name = planComponent.Name;
                priceComponent.type = planComponent.Project_Add_On_Charges__r.recordType.name;
                priceComponent.gst = planComponent.GST_Treatment__c;
                priceComponent.priceLumpSum = planComponent.Price_Lumpsum__c;
                priceComponent.pricePerSQFT = planComponent.Price_per_SQFT__c;

                priceJSON.components.add(priceComponent);
            }
            System.debug(plan.id);
            System.debug(propertPlanMap);
            
            if(propertPlanMap.containsKey(plan.id)){
                List<Property__c> proList = propertPlanMap.get(plan.id);
                
                for(Property__c prop: proList){
                    prop.Pricing_Plan_Detail__c = JSON.serialize(priceJSON);
                    propertiesToUpdate.add(prop);
                }
            }
        }
     
        if(!propertiesToUpdate.isEmpty()){
            update propertiesToUpdate;
        }
    }
}