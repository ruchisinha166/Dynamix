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
@isTest
public class pricingPlanClass_Test {
	@isTest public static void pricingPlanClassTestMethod()
    {	
        List<Pricing_Plan_Components__c> planObjectList = new List<Pricing_Plan_Components__c>();
        Project__c projObj = new Project__c();
        projObj.Name = 'test project';
        insert projObj;
        
        Pricing_Plan__c pricingObject = new Pricing_Plan__c();
        pricingObject.Name= 'Pricing Object';
        pricingObject.Project__c = projObj.Id;
        pricingObject.Valid_from__c = system.today();
        pricingObject.Valid_to__c = system.today() + 30;
        insert pricingObject;
        
        Property__c prop1 = new Property__c(Name='Testing property1',Floor__c='1',Property_Price_Slab__c=pricingObject.id,Project__c=projObj.id);
        insert prop1;
        
        Pricing_Plan_Components__c planObject = new Pricing_Plan_Components__c();
        planObject.Name = 'test123';
       // planObject.Price_Lumpsum__c = 400;
        planObject.Pricing_Plan__c = pricingObject.Id;
        planObject.GST_Treatment__c='5%';
        planObject.Price_per_SQFT__c =20 ;
        planObjectList.add(planObject);
        insert planObjectList;
        
        List<Project_Add_On_Charges__c> addOnList = new List<Project_Add_On_Charges__c>();
        Project_Add_On_Charges__c projAddOnObject = new Project_Add_On_Charges__c();
        projAddOnObject.Name = 'Test Charges';
        projAddOnObject.Project__c = projObj.Id;
        projAddOnObject.Allotted_Units__c = 20;
        insert projAddOnObject;
        addOnList.add(projAddOnObject);
        
        List<Pricing_Plan_Components__c> pricingPlanCmpList = [select Id,Name,Pricing_Plan__r.Project__c,Pricing_Plan__c from Pricing_Plan_Components__c where Pricing_Plan__c =: pricingObject.Id limit 1];
        system.debug('pricingPlanCmpList=='+pricingPlanCmpList);
        
        Project_Add_On_Charges__c projAddOnObject1 = new Project_Add_On_Charges__c();
        projAddOnObject1.Name = 'Test Add On Charges';
        projAddOnObject1.Project__c = pricingPlanCmpList[0].Pricing_Plan__r.Project__c;
        projAddOnObject1.Allotted_Units__c = 20;
        insert projAddOnObject1;
        addOnList.add(projAddOnObject1);
        
        Test.startTest();
        pricingPlanClass.createRecords(planObjectList, pricingObject.Name,pricingObject.Valid_from__c,pricingObject.Valid_to__c, projObj.Id, pricingObject.Id);
        pricingPlanClass.getPricingList(projObj.Id);
        Test.stopTest();
    }
    @isTest public static void pricingPlanClassTestMethodA()
    {	
        List<Pricing_Plan_Components__c> planObjectList = new List<Pricing_Plan_Components__c>();
        Project__c projObj = new Project__c();
        projObj.Name = 'test project';
        insert projObj;
        
        Pricing_Plan__c pricingObject = new Pricing_Plan__c();
        pricingObject.Name= 'Pricing Object';
        pricingObject.Project__c = projObj.Id;
        pricingObject.Valid_from__c = system.today();
        pricingObject.Valid_to__c = system.today() + 30;
        insert pricingObject;
        
        Property__c prop1 = new Property__c(Name='Testing property1',Floor__c='1',Property_Price_Slab__c=pricingObject.id,Project__c=projObj.id);
        insert prop1;
        
        Pricing_Plan_Components__c planObject = new Pricing_Plan_Components__c();
        planObject.Name = 'test123';
        planObject.Price_Lumpsum__c = 400;
        planObject.Pricing_Plan__c = pricingObject.Id;
        planObject.GST_Treatment__c='5%';
        //planObject.Price_per_SQFT__c =20 ;
        planObjectList.add(planObject);
        insert planObjectList;
        
        Project_Add_On_Charges__c projAddOnObject = new Project_Add_On_Charges__c();
        projAddOnObject.Name = 'Test Charges';
        projAddOnObject.Project__c = projObj.Id;
        projAddOnObject.Allotted_Units__c = 20;
        insert projAddOnObject;
        
        Test.startTest();
        pricingPlanClass.createRecords(planObjectList, pricingObject.Name,pricingObject.Valid_from__c,pricingObject.Valid_to__c, projObj.Id, pricingObject.Id);
        pricingPlanClass.getPricingList(projObj.Id);
        Test.stopTest();
    }
    
    @isTest public static void pricingPlanClassTestMethodC()
    {	
        List<Pricing_Plan_Components__c> planObjectList = new List<Pricing_Plan_Components__c>();
        Project__c projObj = new Project__c();
        projObj.Name = 'test project';
        insert projObj;
        
        Pricing_Plan__c pricingObject = new Pricing_Plan__c();
        pricingObject.Name= 'Pricing Object';
        pricingObject.Project__c = projObj.Id;
        pricingObject.Valid_from__c = system.today();
        pricingObject.Valid_to__c = system.today() + 30;
        insert pricingObject;
        
        Property__c prop1 = new Property__c(Name='Testing property1',Floor__c='1',Property_Price_Slab__c=pricingObject.id,Project__c=projObj.id);
        insert prop1;
        
        Pricing_Plan_Components__c planObject = new Pricing_Plan_Components__c();
        planObject.Name = 'test123';
       // planObject.Price_Lumpsum__c = 400;
        planObject.Pricing_Plan__c = pricingObject.Id;
        planObject.GST_Treatment__c='5%';
        planObject.Price_per_SQFT__c =20 ;
        planObjectList.add(planObject);
        insert planObjectList;
        
        Map<String,Pricing_Plan_Components__c> pricingPlanMap = new Map<String,Pricing_Plan_Components__c>();
        pricingPlanMap.put(planObject.Name,planObject);
        
        List<Project_Add_On_Charges__c> addOnList = new List<Project_Add_On_Charges__c>();
        Project_Add_On_Charges__c projAddOnObject = new Project_Add_On_Charges__c();
        projAddOnObject.Name = 'Test Charges';
        projAddOnObject.Project__c = projObj.Id;
        projAddOnObject.Allotted_Units__c = 20;
        insert projAddOnObject;
        addOnList.add(projAddOnObject);
        
        List<Pricing_Plan_Components__c> pricingPlanCmpList = [select Id,Name,Pricing_Plan__r.Project__c,Pricing_Plan__c from Pricing_Plan_Components__c where Pricing_Plan__c =: pricingObject.Id limit 1];
        system.debug('pricingPlanCmpList=='+pricingPlanCmpList);
        
        Project_Add_On_Charges__c projAddOnObject1 = new Project_Add_On_Charges__c();
        projAddOnObject1.Name = 'Test Add On Charges';
        projAddOnObject1.Project__c = pricingPlanCmpList[0].Pricing_Plan__r.Project__c;
        projAddOnObject1.Allotted_Units__c = 20;
        insert projAddOnObject1;
        addOnList.add(projAddOnObject1);
        
        Test.startTest();
        system.debug('planObjectList==='+planObjectList);
        system.debug('pricingObject.Name==='+pricingObject.Name);
        system.debug('pricingObject.Id==='+pricingObject.Id);
        pricingPlanClass.createRecords(planObjectList,planObject.Name,pricingObject.Valid_from__c,pricingObject.Valid_to__c,pricingObject.Id, pricingObject.Id);
        pricingPlanClass.getPricingList(pricingObject.Id);
        Test.stopTest();
    }
    
    @isTest public static void pricingPlanClassTestMethod1()
    {	
        List<Pricing_Plan_Components__c> planObjectList = new List<Pricing_Plan_Components__c>();
        Project__c projObj = new Project__c();
        projObj.Name = 'test project';
        insert projObj;
        
        Pricing_Plan__c pricingObject = new Pricing_Plan__c();
        pricingObject.Name= 'Pricing Object';
        pricingObject.Project__c = projObj.Id;
        pricingObject.Valid_from__c = system.today();
        pricingObject.Valid_to__c = system.today() + 30;
        insert pricingObject;
        
        Property__c prop1 = new Property__c(Name='Testing property1',Floor__c='1',Property_Price_Slab__c=pricingObject.id,Project__c=projObj.id);
        insert prop1;
        
        Pricing_Plan_Components__c planObject = new Pricing_Plan_Components__c();
        planObject.Name = 'test123';
        //planObject.Price_per_SQFT__c = 400;
        planObject.Pricing_Plan__c = pricingObject.Id;
        planObject.GST_Treatment__c='5%';
        //planObject.Component_Type__c = 'Feature';
        planObjectList.add(planObject);
        insert planObjectList;
        
        Project_Add_On_Charges__c projAddOnObject = new Project_Add_On_Charges__c();
        projAddOnObject.Name = 'Test Charges';
        projAddOnObject.Project__c = projObj.Id;
        projAddOnObject.Allotted_Units__c = 20;
        insert projAddOnObject;
        
        Test.startTest();
        pricingPlanClass.createRecords(planObjectList,planObject.Name,pricingObject.Valid_from__c,pricingObject.Valid_to__c,projObj.Id, null);
        pricingPlanClass.getPricingList(pricingObject.Id);
        Test.stopTest();
    }
     @isTest public static void pricingPlanClassTestMethod2()
    {	
        List<Pricing_Plan_Components__c> planObjectList = new List<Pricing_Plan_Components__c>();
        Project__c projObj = new Project__c();
        projObj.Name = 'test project';
        insert projObj;
        
        Pricing_Plan__c pricingObject = new Pricing_Plan__c();
        pricingObject.Name= 'Pricing Object';
        pricingObject.Project__c = projObj.Id;
        pricingObject.Valid_from__c = system.today();
        pricingObject.Valid_to__c = system.today() + 30;
        insert pricingObject;
        
        Pricing_Plan__c pricingObject1 = new Pricing_Plan__c();
        pricingObject1.Name= 'Pricing Object';
        pricingObject1.Project__c = projObj.Id;
        insert pricingObject1;
        
        Property__c prop1 = new Property__c(Name='Testing property1',Floor__c='1',Property_Price_Slab__c=pricingObject.id,Project__c=projObj.id);
        insert prop1;
        
        Pricing_Plan_Components__c planObject = new Pricing_Plan_Components__c();
        planObject.Name = 'test123';
        planObject.Price_per_SQFT__c = 400;
        planObject.Pricing_Plan__c = pricingObject1.Id;
        planObject.GST_Treatment__c='5%';
        planObject.Component_Type__c = '';
        planObjectList.add(planObject);
        insert planObjectList;
        
        Project_Add_On_Charges__c projAddOnObject = new Project_Add_On_Charges__c();
        projAddOnObject.Name = 'Test Charges';
        projAddOnObject.Project__c = projObj.Id;
        projAddOnObject.Allotted_Units__c = 20;
        insert projAddOnObject;
        
        Test.startTest();
        pricingPlanClass.createRecords(planObjectList, pricingObject.Name,pricingObject.Valid_from__c,pricingObject.Valid_to__c, projObj.Id, pricingObject.Id);
        //pricingPlanClass.pricingPlanWrapper pwrap = pricingPlanClass.getPricingList(projObj.Id);
        pricingPlanClass.getPricingList(projObj.Id);
        Test.stopTest();
    }
}