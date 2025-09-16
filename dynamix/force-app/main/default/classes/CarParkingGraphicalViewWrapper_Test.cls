@isTest
public class CarParkingGraphicalViewWrapper_Test {
    
    @isTest 
    static void CarParkingGraphicalTest(){
        
        Id ProjAddOnRecTypeId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();

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
        propertyObject.Flat_Type__c  = 'CAR PARKING';
        propertyObject.Pricing_Plan_Detail__c = '{"components":[{"type":"Charges","pricePerSQFT":null,"priceLumpSum":7500000.00,"name":"Basic Price","gst":"18%"},{"type":"Charges","pricePerSQFT":null,"priceLumpSum":300000.00,"name":"Legal Charges","gst":"5%"},{"type":"Parking","pricePerSQFT":null,"priceLumpSum":60000.00,"name":"Car Parking Space","gst":"1%"},{"type":"Charges","pricePerSQFT":null,"priceLumpSum":60000.00,"name":"Society Formation Charges","gst":"1%"},{"type":"Charges","pricePerSQFT":null,"priceLumpSum":30000.00,"name":"Utilities Connection Charges","gst":"1%"},{"type":"Charges","pricePerSQFT":null,"priceLumpSum":55000.00,"name":"Security maintenance deposit(Divum)","gst":"Standard"},{"type":"Parking","pricePerSQFT":null,"priceLumpSum":7000.00,"name":"2 Wheeler Parking","gst":"0%"}]}';
        insert propertyObject;
        
        
        Property__c propertyObject1 = new Property__c();
        propertyObject1.Name = 'new property';
        propertyObject1.Tower__c= null;
        propertyObject1.Project__c = projectObject.Id;
        propertyObject1.Floor__c = '1';
        propertyObject1.Property_Status__c = 'Available';
        propertyObject1.Flat_Type__c  = '1 BHK';
        
      	insert propertyObject1;
        
        Project_Add_On_Charges__c projAddOn = new Project_Add_On_Charges__c();
        projAddOn.Project__c= projectObject.Id;
        projAddOn.RecordTypeId = ProjAddOnRecTypeId;
        projAddOn.Name = 'Car Parking Space';
        projAddOn.Charge_Type__c = 'Fixed';
        projAddOn.Charge_Group__c = 'Agreement;Others';
        insert projAddOn;
        
        Property_Add_On__c propAddOn = new Property_Add_On__c();
        propAddOn.Car_Parking__c = propertyObject.Id;
        propAddOn.Property__c = propertyObject1.Id;
        propAddOn.Project_Add_On__c = projAddOn.Id;
        insert propAddOn;
        
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
     	
        CarParkingGraphicalViewWrapper viewWrapObject = new CarParkingGraphicalViewWrapper();
        CarParkingGraphicalViewWrapper.Tower towerObj= new CarParkingGraphicalViewWrapper.Tower(propertyObject);
       
        Map<String, CarParkingGraphicalViewWrapper.Tower> towerMap = new Map<String, CarParkingGraphicalViewWrapper.Tower>(); 
        String relatedTower = 'Property Plan';
        towerMap.put(relatedTower,null); 
        CarParkingGraphicalViewWrapper.Floor floor = new CarParkingGraphicalViewWrapper.Floor(propertyObject);
     }
}