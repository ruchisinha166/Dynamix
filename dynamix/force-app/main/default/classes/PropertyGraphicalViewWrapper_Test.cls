@isTest
public class PropertyGraphicalViewWrapper_Test {
    
    @isTest 
    static void PropertyGraphicalTest(){
		
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
        
        /*
        Property__c propertyObject1 = new Property__c();
        propertyObject1.Name = 'new property';
        propertyObject1.Tower__c= null;
        propertyObject1.Project__c = projectObject.Id;
        propertyObject1.Floor__c = '1';
        propertyObject1.Property_Status__c = 'Available';
        propertyObject1.Flat_Type__c  = '1 BHK';
        propertyObject1.Pricing_Plan_Detail__c = 'PricingTest';
      	insert propertyObject1;
        
        Property__c propertyObject2 = new Property__c();
        propertyObject2.Name = 'new property';
        propertyObject2.Tower__c= null;
        propertyObject2.Project__c = projectObject.Id;
        propertyObject2.Floor__c = '2';
        propertyObject2.Property_Status__c = 'Available';
        propertyObject2.Flat_Type__c  = '1 BHK';
        propertyObject2.Pricing_Plan_Detail__c = 'PricingTest';
      	insert propertyObject2;
        */
        
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
         
       
     }

     @isTest 
    static void PropertyGraphicalwrapperTest(){
        
          Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
		
        Project__c projectObject = new Project__c();
        projectObject.Name = 'test project';
        insert projectObject;
        
         Project_Add_On_Charges__c projectAddbject= new Project_Add_On_Charges__c();
        projectAddbject.Charge_Type__c = 'Fixed';
        projectAddbject.Charge_Group__c = 'Floor Rise';
        projectAddbject.Is_Optional__c = false;
        projectAddbject.RecordTypeId = ChargesId;
        projectAddbject.Project__c = projectObject.Id;
        projectAddbject.Name = 'Basic Price';
        insert projectAddbject;
         
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
        
        Property_Add_On__c PAddOn = New Property_Add_On__c();
        PAddOn.Property__c = propertyObject.Id;
        PAddOn.Project_Add_On__c = projectAddbject.Id;
        insert PAddOn;
        /*
        Property__c propertyObject1 = new Property__c();
        propertyObject1.Name = 'new property';
        propertyObject1.Tower__c= null;
        propertyObject1.Project__c = projectObject.Id;
        propertyObject1.Floor__c = '1';
        propertyObject1.Property_Status__c = 'Available';
        propertyObject1.Flat_Type__c  = '1 BHK';
        propertyObject1.Pricing_Plan_Detail__c = 'PricingTest';
      	insert propertyObject1;
        
        Property__c propertyObject2 = new Property__c();
        propertyObject2.Name = 'new property';
        propertyObject2.Tower__c= null;
        propertyObject2.Project__c = projectObject.Id;
        propertyObject2.Floor__c = '2';
        propertyObject2.Property_Status__c = 'Available';
        propertyObject2.Flat_Type__c  = '1 BHK';
        propertyObject2.Pricing_Plan_Detail__c = 'PricingTest';
      	insert propertyObject2;
        */
        
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
         
       
     }
}