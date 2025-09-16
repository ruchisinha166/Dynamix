@isTest
public class GetCustomPermission_Test {
	 @isTest public static void GetCustomPermissionMethod()
     {	
        Account accountObject = new Account();
        accountObject.Name= 'Test Account';
        insert accountObject;
         
        Opportunity opportunityObject = new Opportunity();
        opportunityObject.Name = 'Test Opportunity';
        opportunityObject.StageName = 'Site Visit';
        opportunityObject.CloseDate = System.today();
        opportunityObject.AccountId = accountObject.Id;
        insert opportunityObject;
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        insert projectObject;
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        insert pricingPlanObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Name = 'Property Test';
        insert propertyObject;
        
        Suggested_Property__c suggPropertyObject = new Suggested_Property__c();
        suggPropertyObject.Unit__c = propertyObject.Id;
        suggPropertyObject.Opportunity__c = opportunityObject.Id;
        insert suggPropertyObject;
         
       	String permissionName = suggPropertyObject.Id;
        
        GetCustomPermission.Requests requestObject = new GetCustomPermission.Requests();
        requestObject.permissionName = suggPropertyObject.Name;
        
        List<GetCustomPermission.Requests> requestList = new  List<GetCustomPermission.Requests>();
        requestList.add(requestObject);
        
        GetCustomPermission.execute(requestList);
     }
}