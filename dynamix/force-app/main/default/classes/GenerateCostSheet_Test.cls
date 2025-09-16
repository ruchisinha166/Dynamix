@isTest
public class GenerateCostSheet_Test {
	@isTest
    static void GenerateCostSheetMethod()
    {
        Account accountObject = new Account();
        accountObject.Name= 'Test Account';
        insert accountObject;
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='3 BHK';
        insert projectObject;
        
        Opportunity opportunityObject = new Opportunity();
        opportunityObject.Name = 'Test Opportunity';
        opportunityObject.StageName = 'Site Visit';
        opportunityObject.CloseDate = System.today();
        opportunityObject.AccountId = accountObject.Id;
        opportunityObject.Project__c = projectObject.Id;
        opportunityObject.Walk_in_Source__c = 'Hoarding';
        insert opportunityObject;
        
        
        Tower__c towerObject = new Tower__c();
        towerObject.Name = 'test tower';
        towerObject.Project__c = projectObject.Id;
        insert towerObject;
        
        Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
        pricingPlanObject.Name = 'Pricing Plan Test';
        pricingPlanObject.Project__c = projectObject.Id;
        insert pricingPlanObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Name = 'Property Test';
        propertyObject.Tower__c = towerObject.id;
        insert propertyObject;
        
        Suggested_Property__c suggPropertyObject = new Suggested_Property__c();
        suggPropertyObject.Unit__c = propertyObject.Id;
        suggPropertyObject.Opportunity__c = opportunityObject.Id;
       
        insert suggPropertyObject;
        
        
       	String propertyId = suggPropertyObject.Id;
        test.startTest();
        GenerateCostSheet.Requests requestObject = new GenerateCostSheet.Requests();
        requestObject.propertyId = suggPropertyObject.Id;
        
        List<GenerateCostSheet.Requests> requestList = new  List<GenerateCostSheet.Requests>();
        requestList.add(requestObject);
        
        List<GenerateCostSheet.Requests> requestList2 = new  List<GenerateCostSheet.Requests>();
        requestList2.add(requestObject);
        
		GenerateCostSheet.execute(requestList);
        GenerateCostSheet.execute(requestList2);
       
        
        test.stopTest();
    }
}