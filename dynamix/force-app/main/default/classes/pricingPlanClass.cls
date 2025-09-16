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
public with sharing class pricingPlanClass {

    @AuraEnabled(cacheable=true)
    public static PricingPlanComponents getPricingList(Id recordId){
        
        Set<Id> setId = new Set<Id>();
        
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        
        String pricePlanId;
        String projectId;
        String pricePlanName;
        Date validFrom;
        Date validTo;
        
        if(sObjName == 'Pricing_Plan__c'){
            
            Pricing_Plan__c pricePlan = [SELECT Id, Name,Valid_from__c,Valid_to__c, Project__c FROM Pricing_Plan__c WHERE Id =: recordId];
            pricePlanId = recordId;
            pricePlanName = pricePlan.Name;
            validFrom = pricePlan.Valid_from__c;
            validTo = pricePlan.Valid_to__c;
            projectId = pricePlan.Project__c;
        }
        else if(sObjName == 'Pricing_Plan_Components__c'){
            
            Pricing_Plan_Components__c ppComponent = [SELECT Id, Name, Pricing_Plan__c, Pricing_Plan__r.Project__c,
                                                        Pricing_Plan__r.Name,Pricing_Plan__r.Valid_from__c,Pricing_Plan__r.Valid_to__c
                                                        FROM Pricing_Plan_Components__c WHERE Id =: recordId];
            pricePlanId = ppComponent.Pricing_Plan__c;
            pricePlanName = ppComponent.Pricing_Plan__r.Name;
            validFrom = ppComponent.Pricing_Plan__r.Valid_from__c;
            validTo = ppComponent.Pricing_Plan__r.Valid_to__c;
            projectId = ppComponent.Pricing_Plan__r.Project__c;
        }
        else{
            pricePlanId = null;
            pricePlanName = null;
            projectId = recordId;
            validFrom = null;
            validTo = null;
        }

        Map<Id, Pricing_Plan_Components__c> projAddOnMap = new Map<Id, Pricing_Plan_Components__c>();

        for(Pricing_Plan_Components__c pln: [SELECT Id, Name, Pricing_Plan__r.Project__c, Price_age__c,
                                                Pricing_Plan__c, Project_Add_On_Charges__c, Price_Lumpsum__c, 
                                                Price_per_SQFT__c, GST_Treatment__c,Component_Type__c, Project_Add_On_Charges__r.Name,
                                                Project_Add_On_Charges__r.Project__c, 
                                                Project_Add_On_Charges__r.Charge_Type__c
                                                FROM Pricing_Plan_Components__c 
                                                WHERE Pricing_Plan__c =: pricePlanId]){

            projAddOnMap.put(pln.Project_Add_On_Charges__c, pln);
        }
        
        List<Pricing_Plan_Components__c> pPCLst = new List<Pricing_Plan_Components__c>();

        for(Project_Add_On_Charges__c proAdd: [SELECT Id, Name, Project__c, Allotted_Units__c, Available_Units__c, 
                                                Total_Units__c, Age_Calculated_on__c, Charge_Group__c, Charge_Type__c, 
                                                Is_Optional__c
                                                FROM Project_Add_On_Charges__c 
                                                WHERE Project__c =: projectId
                                                ORDER BY CreatedDate ASC, Name ASC]){
            
            if(projAddOnMap.containsKey(proAdd.Id)){
                pPCLst.add(projAddOnMap.get(proAdd.Id));
            }
            else{
                Pricing_Plan_Components__c pPC = new Pricing_Plan_Components__c();
                pPC.Project_Add_On_Charges__c = proAdd.Id;
                pPC.Project_Add_On_Charges__r = proAdd;
                pPC.Name = proAdd.Name;
                pPCLst.add(pPC);
            }
        }

        PricingPlanComponents pPC = new PricingPlanComponents();
        pPC.pricePlanName = pricePlanName;
        pPC.pPCLst = pPCLst;
        pPC.projectId = projectId;
        pPC.pricePlanId = pricePlanId;
        pPC.validFrom = validFrom;
        pPC.validTo = validTo;

        return pPC;
    }

 	@AuraEnabled
    public static void createRecords(List<Pricing_Plan_Components__c> planObjectList, String pricingPlan,Date validFrom,Date ValidTo, String projectId, String pricePlanId){   
        
        Pricing_Plan__c pricingPlanObject;

        if(pricePlanId == null){
            pricingPlanObject = new Pricing_Plan__c();
            pricingPlanObject.Project__c = ProjectId ;
        }
        else{
            pricingPlanObject = new Pricing_Plan__c(Id = pricePlanId);
        }
        
        pricingPlanObject.Name= pricingPlan;
        pricingPlanObject.Valid_from__c = validFrom;
        pricingPlanObject.Valid_to__c = ValidTo;

        upsert pricingPlanObject;

        List<Pricing_Plan_Components__c> pricingPlanCompObjList= new List<Pricing_Plan_Components__c>();
        
        for(Pricing_Plan_Components__c planObject : planObjectList){

            Pricing_Plan_Components__c pricingPlanCompObj;

            if(planObject.Id != null){
                pricingPlanCompObj = new Pricing_Plan_Components__c(Id = planObject.Id);
            }
            else{
                pricingPlanCompObj = new Pricing_Plan_Components__c();
                pricingPlanCompObj.Pricing_Plan__c = pricingPlanObject.Id;
            }

            pricingPlanCompObj.GST_Treatment__c=  planObject.GST_Treatment__c;
            pricingPlanCompObj.Project_Add_On_Charges__c = planObject.Project_Add_On_Charges__c;
            pricingPlanCompObj.Name = planObject.Project_Add_On_Charges__r.Name;
            pricingPlanCompObj.Component_Type__c = planObject.Component_Type__c;
            
            if(planObject.Price_per_SQFT__c != null){
                pricingPlanCompObj.Price_per_SQFT__c = planObject.Price_per_SQFT__c;
            }
            else if(planObject.Price_Lumpsum__c != null) {
                pricingPlanCompObj.Price_Lumpsum__c = planObject.Price_Lumpsum__c;
            }
            else {
                pricingPlanCompObj.Price_age__c = planObject.Price_age__c;
            }

            pricingPlanCompObjList.add(pricingPlanCompObj);
        }

        upsert pricingPlanCompObjList;
    }

    public class PricingPlanComponents{

        @AuraEnabled
        public String pricePlanName;

        @AuraEnabled
        public List<Pricing_Plan_Components__c> pPCLst;

        @AuraEnabled
        public String projectId;

        @AuraEnabled
        public String pricePlanId;
        
        @AuraEnabled
        public Date validFrom;
        
        @AuraEnabled
        public Date validTo;
    }
}