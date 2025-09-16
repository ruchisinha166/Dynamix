@isTest
public class BikeParkingGraphicalViewControllerTest { 
    
    @isTest
    static void testCreateSuggestedProperty() {
        Account testAcc = new Account();
        testAcc.Name = 'Test Name';
        insert testAcc;
        
        Project__c project = new Project__c(Name='Test Project');
        insert project;
        Tower__c towerObject = new Tower__c();
        towerObject.Name = 'test tower';
        towerObject.Project__c = project.Id;
        insert towerObject;
        
        Property__c testProperty = new Property__c(Name = 'Test Property', Flat_Type__c = 'BIKE PARKING',Parking_Type__c = 'Puzzle Tandem' ,Project__c = project.id,Tower__c= towerObject.Id);
        insert testProperty;
        Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity',
                                                      AccountId = testAcc.id,
                                                      CloseDate = System.Today(),
                                                      StageName = 'Closed Won',
                                                      Project__c = project.Id);
        insert testOpportunity;
        
        Test.startTest();
        BikeParkingGraphicalViewController.createSuggestedProperty(testProperty.Id, testOpportunity.Id);
        BikeParkingGraphicalViewController.getInventory(project.Id);
        Test.stopTest();
        
    }
    
    
      @isTest
    static void testCreateSuggestedProperty323() {
        Account testAcc = new Account();
        testAcc.Name = 'Test Name';
        insert testAcc;  
        
        Project__c project = new Project__c(Name='Test Project');
        insert project;
        
         Tower__c towerObject = new Tower__c();
        towerObject.Name = 'test tower';
        towerObject.Project__c = project.Id;
        insert towerObject;
        
        Property__c testProperty = new Property__c(Name = 'Test Property', Flat_Type__c = 'BIKE PARKING',Parking_Type__c = 'Puzzle Tandem' ,Project__c = project.id,Tower__c= towerObject.Id);
        insert testProperty;
        Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity',
                                                      AccountId = testAcc.id,
                                                      CloseDate = System.Today(),
                                                      StageName = 'Closed Won',
                                                      Project__c = project.Id);
        insert testOpportunity;
        
        Test.startTest();
        BikeParkingGraphicalViewController.createSuggestedProperty(testProperty.Id, testOpportunity.Id);
        BikeParkingGraphicalViewController.getBookingInventory(project.Id);
        Test.stopTest();
        
    }
    
    
       @isTest
    static void testCreateSuggestedProperty3235() {
        Account testAcc = new Account();
        testAcc.Name = 'Test Name';
        insert testAcc;
        
        Project__c project = new Project__c(Name='Test Project');
        insert project;
        Tower__c towerObject = new Tower__c();
        towerObject.Name = 'test tower';
        towerObject.Project__c = project.Id;
        insert towerObject;
                
        Property__c testProperty = new Property__c(Name = 'Test Property',  Flat_Type__c = 'BIKE PARKING',Parking_Type__c = 'Puzzle Tandem' ,Project__c = project.id,Tower__c= towerObject.Id);
        insert testProperty;
        
        Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity',
                                                      AccountId = testAcc.id,
                                                      CloseDate = System.Today(),
                                                      StageName = 'Closed Won',
                                                      Project__c = project.Id);
        insert testOpportunity;
        
        Test.startTest();
        BikeParkingGraphicalViewController.createSuggestedProperty(testProperty.Id, testOpportunity.Id);
        BikeParkingGraphicalViewController.getProperties(project.Id);
        Test.stopTest();
        
    }
    

    
     @isTest
    static void testCreateSuggestedProperty3() {
        Account testAcc = new Account();
        testAcc.Name = 'Test Name';
        insert testAcc;
        
        Project__c project = new Project__c(Name='Test Project');
        insert project;
        
          
        
        Property__c testProperty = new Property__c(Name = 'Test Property', Flat_Type__c = 'BIKE PARKING',
                                                   Property_Status__c ='Available', Project__c = project.id);
        insert testProperty;
        
        Property_Add_On__c propertyAddOn = new Property_Add_On__c();
           
        /*propertyAddOn.Property__c = testProperty.Id;
        propertyAddOn.Is_Included__c = true;
        propertyAddOn.Project_Add_On__c = ;
            insert propertyAddOn;*/
        
        Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity',
                                                      AccountId = testAcc.id,
                                                      CloseDate = System.Today(),
                                                      StageName = 'Closed Won',
                                                      Project__c = project.Id);
        insert testOpportunity;
        
        Test.startTest();
        BikeParkingGraphicalViewController.createSuggestedProperty(testProperty.Id, testOpportunity.Id);
        BikeParkingGraphicalViewController.getBookingInventory(project.Id);
        Test.stopTest();
        
    }
    
    
    @isTest
    static void testGetSuggProp() {
        Project__c project = new Project__c(Name='Test Project');
        insert project;
        
        Account testAcc = new Account();
        testAcc.Name = 'Test Name';
        insert testAcc;
        
        Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity',
                                                      AccountId = testAcc.id,
                                                      CloseDate = System.Today(),
                                                      StageName = 'Closed Won',
                                                      Project__c = project.Id);
        insert testOpportunity;
        
        Property__c testProperty1 = new Property__c(Name = 'Test Property 1', Project__c = project.Id, Flat_Type__c = 'BIKE PARKING');
        insert testProperty1;
        
        Suggested_Property__c testSuggestedProperty = new Suggested_Property__c(Opportunity__c = testOpportunity.Id,Unit__c = testProperty1.Id);
        insert testSuggestedProperty;
        
        Test.startTest();
        BikeParkingGraphicalViewController.getSuggProp(testOpportunity.Id);
        BikeParkingGraphicalViewController.changeStatus(testProperty1.Id);  
        Test.stopTest();
    }
}