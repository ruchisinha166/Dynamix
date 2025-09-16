trigger PricingPlanComponentTrigger on Pricing_Plan_Components__c (after update,after insert) {
    
    If(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)){
        PricingPlanToJSON.updateJSON(Trigger.New);
    }
}