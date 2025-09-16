@isTest
public class PricingPlanToJSON_Test
{   @isTest
    public static void toJsonTest()
    {
        Project__c proj = new Project__c(Name='Test');
        insert proj;
        Pricing_Plan__c plan = new Pricing_Plan__c(Name='Plan Test', Project__c=proj.id);
        insert plan;
        Property__c prop1 = new Property__c(Name='Testing property1',Floor__c='1',Property_Price_Slab__c=plan.id,Project__c=proj.id);
        List<Pricing_Plan_Components__c> ppcList = new List<Pricing_Plan_Components__c>();
        Pricing_Plan_Components__c p1 = new Pricing_Plan_Components__c(Pricing_Plan__c=plan.id,Name='Basic Price',Price_Lumpsum__c=112400);
        ppcList.add(p1);
        Pricing_Plan_Components__c p2 = new Pricing_Plan_Components__c(Pricing_Plan__c=plan.id,Name='Floor Rise',Price_Lumpsum__c=142400);
        ppcList.add(p2);
        Property__c prop2 = new Property__c(Name='Testing property1',Floor__c='1',Property_Price_Slab__c=plan.id,Project__c=proj.id);
        List<Property__c> listpro = new List<Property__c>();
        listpro.add(prop1);
        listpro.add(prop2);
        Test.startTest();
            insert prop1;
            insert ppcList;
            insert prop2;
        PricingPlanToJSON.toJSON(listpro);
        Test.stopTest();
        
    }
}