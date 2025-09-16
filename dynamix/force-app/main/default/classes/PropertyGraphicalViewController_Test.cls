@isTest
public class PropertyGraphicalViewController_Test {
    @isTest 
    static void PropertyGraphicalViewControllerTestMethod(){
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'test project';
        insert projectObject;
        
        Tower__c towerObject = new Tower__c();
        towerObject.Name = 'test tower';
        towerObject.Project__c = projectObject.Id;
        insert towerObject;
        
        Pricing_Plan__c plan = new Pricing_Plan__c(Name='Plan Test', Project__c=projectObject.id);
        insert plan;
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'new property';
        propertyObject.Tower__c= towerObject.Id;
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Floor__c = '1';
        propertyObject.Property_Status__c = 'Available';
        propertyObject.Flat_Type__c  = '1 BHK';
        insert propertyObject;
        
        //Creating Property Add On Charges records.
        Property_Add_On__c addOn = new Property_Add_On__c();
        addOn.Is_Included__c = true;
        addOn.Property__c = propertyObject.id;
        //addOn.Is_Included__c = true;
        
        Account accountObject = new Account();
        accountObject.Name= 'Test Account';
        insert accountObject;
        
		Opportunity opprObject = new Opportunity();
        opprObject.Name = 'test opportunity';
        opprObject.Project__c = projectObject.Id;
        opprObject.StageName = 'Site Visit';
        opprObject.CloseDate = system.today();
        opprObject.AccountId = accountObject.Id;
        insert opprObject; 
     	
        Suggested_Property__c sproperty= new Suggested_Property__c(Opportunity__c=opprObject.id,Status__c='Short Listed',Unit__c=propertyObject.id);
        insert sproperty;
        
        PropertyGraphicalViewWrapper viewWrapObject = new PropertyGraphicalViewWrapper();
        PropertyGraphicalViewWrapper.Tower towerObj= new PropertyGraphicalViewWrapper.Tower(propertyObject);
        Map<String, PropertyGraphicalViewWrapper.Tower> towerMap = new Map<String, PropertyGraphicalViewWrapper.Tower>(); 
        towerMap.put('Property Plan',towerObj);
        
        Test.startTest();
        PropertyGraphicalViewController.createSuggestedProperty(propertyObject.id,opprObject.id);
        PropertyGraphicalViewController.getInventory(projectObject.Id);
        PropertyGraphicalViewController.getProperties(projectObject.Id);
        Test.stopTest();
	}
    @isTest 
    static void PropertyGraphicalViewControllerTestMethod1(){
		
        Project__c projectObject = new Project__c();
        projectObject.Name = 'test project';
        insert projectObject;
         
        Tower__c towerObject = new Tower__c();
        towerObject.Name = 'test tower';
        towerObject.Project__c = projectObject.Id;
        insert towerObject;
         
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'new property';
        propertyObject.Tower__c= null;
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Floor__c = '1';
        propertyObject.Property_Status__c = 'Available';
        propertyObject.Flat_Type__c  = '1 BHK';
      	insert propertyObject;
        
        Property__c propertyObject1 = new Property__c();
        propertyObject1.Name = 'new property';
        propertyObject1.Tower__c= null;
        propertyObject1.Project__c = projectObject.Id;
        propertyObject1.Floor__c = '1';
        propertyObject1.Property_Status__c = 'Available';
        propertyObject1.Flat_Type__c  = '1 BHK';
      	insert propertyObject1;
        
        Property__c propertyObject2 = new Property__c();
        propertyObject2.Name = 'new property';
        propertyObject2.Tower__c= null;
        propertyObject2.Project__c = projectObject.Id;
        propertyObject2.Floor__c = '2';
        propertyObject2.Property_Status__c = 'Available';
        propertyObject2.Flat_Type__c  = '1 BHK';
      	insert propertyObject2;
        
        Account accountObject = new Account();
        accountObject.Name= 'Test Account';
        insert accountObject;
        
		Opportunity opprObject = new Opportunity();
        opprObject.Name = 'test opportunity';
        opprObject.Project__c = projectObject.Id;
        opprObject.StageName = 'Site Visit';
        opprObject.CloseDate = system.today();
        opprObject.AccountId = accountObject.Id;
        insert opprObject; 
     	
        PropertyGraphicalViewWrapper viewWrapObject = new PropertyGraphicalViewWrapper();
        PropertyGraphicalViewWrapper.Tower towerObj= new PropertyGraphicalViewWrapper.Tower(propertyObject);
        Map<String, PropertyGraphicalViewWrapper.Tower> towerMap = new Map<String, PropertyGraphicalViewWrapper.Tower>(); 
        String relatedTower = 'Property Plan';
        towerMap.put(relatedTower,null); 
        PropertyGraphicalViewWrapper.Floor floor = new PropertyGraphicalViewWrapper.Floor(propertyObject);
         
        Test.startTest();
        PropertyGraphicalViewController.getInventory(projectObject.Id);
        PropertyGraphicalViewController.getProperties(projectObject.Id);
        Test.stopTest();
     }
}