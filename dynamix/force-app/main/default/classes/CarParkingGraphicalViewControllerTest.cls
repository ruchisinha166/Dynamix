@isTest
private class CarParkingGraphicalViewControllerTest {

    @isTest
    static void testGetInventory() {
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
        propertyObject.Flat_Type__c  = 'CAR PARKING';
        insert propertyObject;
        
        
        Property_Add_On__c PropaddOn = new Property_Add_On__c();
        PropaddOn.Is_Included__c = true;
        PropaddOn.Property__c = propertyObject.id;
        
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
        
        Add_On__c AddON = new Add_On__c();
        AddON.Opportunity__c = opprObject.Id;
        AddON.Car_Parking__c = propertyObject.Id;
        insert AddON;
        
        CarParkingGraphicalViewWrapper viewWrapObject = new CarParkingGraphicalViewWrapper();
        CarParkingGraphicalViewWrapper.Tower towerObj= new CarParkingGraphicalViewWrapper.Tower(propertyObject);
        Map<String, CarParkingGraphicalViewWrapper.Tower> towerMap = new Map<String, CarParkingGraphicalViewWrapper.Tower>(); 
        towerMap.put('Property Plan',towerObj);
        
        Test.startTest();
        CarParkingGraphicalViewController.createSuggestedProperty(propertyObject.id,opprObject.id);
        CarParkingGraphicalViewController.getInventory(projectObject.Id);
        CarParkingGraphicalViewController.getProperties(projectObject.Id);
        CarParkingGraphicalViewController.getBookingInventory(projectObject.Id);
        CarParkingGraphicalViewController.changeStatus(propertyObject.Id);
        CarParkingGraphicalViewController.getSuggProp(opprObject.id);
        Test.stopTest();
    }
}