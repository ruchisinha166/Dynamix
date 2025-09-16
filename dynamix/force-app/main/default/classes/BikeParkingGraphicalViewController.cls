public with sharing class BikeParkingGraphicalViewController {
    
    @AuraEnabled(cacheable=true)
    public static CarParkingGraphicalViewWrapper getInventory(String projectId	){
        try {
            
            CarParkingGraphicalViewWrapper propertyGraph = new CarParkingGraphicalViewWrapper();
            
            Map<String, CarParkingGraphicalViewWrapper.Tower> towerMap = new Map<String, CarParkingGraphicalViewWrapper.Tower>();
            Map<String, Map<String, CarParkingGraphicalViewWrapper.Floor>> floorMap = new Map<String, Map<String, CarParkingGraphicalViewWrapper.Floor>>();
            
            for(Property__c property: [SELECT Id, Name, Tower__c,Parking_Type__c, Tower__r.Name, Floor__c, Property_Status__c, Flat_Type__c,Snag_Status__c,
                                       Total_Area__c, Property_Price_Slab__c,RERA_Carpet_Area__c,Deck_Carpet_Area__c,Utility_Area__c, Pricing_Plan_Detail__c,
                                       Booking__c,Booking__r.Name,Booking__r.Primary_Applicant_Name_Formulla__c,Booking__r.Sales_Manager__r.Name,
                                       Booking__r.Booking_Date__c,Booking__r.Stage__c,
                                       
                                       (SELECT Id, Project_Add_On__r.Name FROM Properties_Add_On__r 
                                        WHERE Project_Add_On__r.RecordType.Name = 'Preferred Location'),
                                       (SELECT Id, Opportunity__r.Owner.Name, Status__c, Status_Change_Date__c,
                                        Opportunity__r.Account.FirstName, Opportunity__r.Account.LastName
                                        FROM Suggested_Property__r 
                                        WHERE Status__c = 'Reserved' OR Status__c = 'In Progress' OR Status__c = 'Booked'),
                                       (SELECT Id, Booking__r.Sales_Manager__r.Name, Booking__r.Closed_Reason__c, Booking__r.Booking_Date__c,
                                        Booking__r.Primary_Applicant__r.FirstName, Booking__r.Primary_Applicant__r.LastName, Booking__c,Booking__r.name
                                        FROM Booking_Line_Items__r 
                                        WHERE (Booking__r.Closed_Reason__c != 'Transferred' OR Booking__r.Closed_Reason__c = 'Cancelled')
                                        AND Project_Add_On_Charges__c = null)
                                       FROM Property__c 
                                       WHERE Project__c =: projectId 
                                       ORDER BY Floor__c desc, Name asc]){
                                           
                                           String relatedTower = '';
                                           
                                           if(property.Flat_Type__c == 'BIKE PARKING'){
                                               if(property.Tower__c == null){
                                                   relatedTower = 'Property Plan';
                                               }
                                               else{
                                                   relatedTower = property.Tower__c;
                                               }
                                               
                                               if(towerMap.containsKey(relatedTower)){
                                                   if(floorMap.get(relatedTower).containsKey(property.Parking_Type__c)){
                                                       floorMap.get(relatedTower).get(property.Parking_Type__c).properties.add(new CarParkingGraphicalViewWrapper.Property(property));
                                                   }
                                                   else{
                                                       CarParkingGraphicalViewWrapper.Floor floor = new CarParkingGraphicalViewWrapper.Floor(property);
                                                       floorMap.get(relatedTower).put(property.Parking_Type__c, floor);
                                                       towerMap.get(relatedTower).floors.add(floor);
                                                   }
                                               }
                                               else{
                                                   CarParkingGraphicalViewWrapper.Tower tower = new CarParkingGraphicalViewWrapper.Tower(property);
                                                   Map<String, CarParkingGraphicalViewWrapper.Floor> floors = new Map<String, CarParkingGraphicalViewWrapper.Floor>();
                                                   
                                                   towerMap.put(relatedTower, tower);
                                                   floors.put(property.Parking_Type__c, tower.floors[0]);
                                                   floorMap.put(relatedTower, floors);
                                               }
                                               
                                           }
                                           propertyGraph.towers = new List<CarParkingGraphicalViewWrapper.Tower>();
                                           
                                           for(CarParkingGraphicalViewWrapper.Tower tower: towerMap.values()){
                                               propertyGraph.towers.add(tower);	
                                           }
                                           
                                           
                                       }
            
            propertyGraph.towers = new List<CarParkingGraphicalViewWrapper.Tower>();
            
            for(CarParkingGraphicalViewWrapper.Tower tower: towerMap.values()){
                propertyGraph.towers.add(tower);
            }
            
            return propertyGraph;
        } catch (Exception e) {
            System.debug(e.getMessage()+e.getLineNumber());
            throw new AuraHandledException(e.getMessage()+e.getLineNumber());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static CarParkingGraphicalViewWrapper getBookingInventory(String projectId	){
        try {
            
            CarParkingGraphicalViewWrapper propertyGraph = new CarParkingGraphicalViewWrapper();
            
            Map<String, CarParkingGraphicalViewWrapper.Tower> towerMap = new Map<String, CarParkingGraphicalViewWrapper.Tower>();
            Map<String, Map<String, CarParkingGraphicalViewWrapper.Floor>> floorMap = new Map<String, Map<String, CarParkingGraphicalViewWrapper.Floor>>();
            
            for(Property__c property: [SELECT Id, Name, Tower__c,Parking_Type__c, Tower__r.Name, Floor__c, Property_Status__c, Flat_Type__c,Snag_Status__c,
                                       Total_Area__c, Property_Price_Slab__c,RERA_Carpet_Area__c,Deck_Carpet_Area__c,Utility_Area__c, Pricing_Plan_Detail__c,
                                       Booking__c,Booking__r.Name,Booking__r.Primary_Applicant_Name_Formulla__c,Booking__r.Sales_Manager__r.Name,
                                       Booking__r.Booking_Date__c,Booking__r.Stage__c,
                                       (SELECT Id, Project_Add_On__r.Name FROM Properties_Add_On__r 
                                        WHERE Project_Add_On__r.RecordType.Name = 'Preferred Location'),
                                       (SELECT Id, Opportunity__r.Owner.Name, Status__c, Status_Change_Date__c,
                                        Opportunity__r.Account.FirstName, Opportunity__r.Account.LastName
                                        FROM Suggested_Property__r 
                                        WHERE Status__c = 'Reserved' OR Status__c = 'In Progress' OR Status__c = 'Booked'),
                                       (SELECT Id, Booking__r.Sales_Manager__r.Name, Booking__r.Closed_Reason__c, Booking__r.Booking_Date__c,
                                        Booking__r.Primary_Applicant__r.FirstName, Booking__r.Primary_Applicant__r.LastName, Booking__c,Booking__r.name
                                        FROM Booking_Line_Items__r 
                                        WHERE (Booking__r.Closed_Reason__c != 'Transferred' OR Booking__r.Closed_Reason__c = 'Cancelled')
                                        AND Project_Add_On_Charges__c = null)
                                       FROM Property__c 
                                       WHERE Project__c =: projectId 
                                       ORDER BY Floor__c desc, Name asc]){
                                           
                                           String relatedTower = '';
                                           
                                           if(property.Flat_Type__c == 'BIKE PARKING' && property.Property_Status__c =='Available'){
                                               if(property.Tower__c == null){
                                                   relatedTower = 'Property Plan';
                                               }
                                               else{
                                                   relatedTower = property.Tower__c;
                                               }
                                               
                                               if(towerMap.containsKey(relatedTower)){
                                                   if(floorMap.get(relatedTower).containsKey(property.Parking_Type__c)){
                                                       floorMap.get(relatedTower).get(property.Parking_Type__c).properties.add(new CarParkingGraphicalViewWrapper.Property(property));
                                                   }
                                                   else{
                                                       CarParkingGraphicalViewWrapper.Floor floor = new CarParkingGraphicalViewWrapper.Floor(property);
                                                       floorMap.get(relatedTower).put(property.Parking_Type__c, floor);
                                                       towerMap.get(relatedTower).floors.add(floor);
                                                   }
                                               }
                                               else{
                                                   CarParkingGraphicalViewWrapper.Tower tower = new CarParkingGraphicalViewWrapper.Tower(property);
                                                   Map<String, CarParkingGraphicalViewWrapper.Floor> floors = new Map<String, CarParkingGraphicalViewWrapper.Floor>();
                                                   
                                                   towerMap.put(relatedTower, tower);
                                                   floors.put(property.Parking_Type__c, tower.floors[0]);
                                                   floorMap.put(relatedTower, floors);
                                               }
                                               
                                           }
                                           propertyGraph.towers = new List<CarParkingGraphicalViewWrapper.Tower>();
                                           
                                           for(CarParkingGraphicalViewWrapper.Tower tower: towerMap.values()){
                                               propertyGraph.towers.add(tower);	
                                           }

                                       }
            
            propertyGraph.towers = new List<CarParkingGraphicalViewWrapper.Tower>();
            
            for(CarParkingGraphicalViewWrapper.Tower tower: towerMap.values()){
                propertyGraph.towers.add(tower);
            }
            
            return propertyGraph;
        } catch (Exception e) {
            System.debug(e.getMessage()+e.getLineNumber());
            throw new AuraHandledException(e.getMessage()+e.getLineNumber());
        }
    }
    
    
    
    @AuraEnabled(cacheable=true)
    public static List<CarParkingGraphicalViewWrapper.Property> getProperties(String projectId){
        try {
            
            List<CarParkingGraphicalViewWrapper.Property> properties = new List<CarParkingGraphicalViewWrapper.Property>();
            
            for(Property__c property: [SELECT Id, Name, Tower__c,Parking_Type__c, Tower__r.Name, Floor__c, Property_Status__c, Flat_Type__c,Snag_Status__c,
                                       Total_Area__c, Property_Price_Slab__c,RERA_Carpet_Area__c,Deck_Carpet_Area__c,Utility_Area__c, Pricing_Plan_Detail__c,
                                       Booking__c,Booking__r.Name,Booking__r.Primary_Applicant_Name_Formulla__c,Booking__r.Sales_Manager__r.Name,
                                       Booking__r.Booking_Date__c,Booking__r.Stage__c,
                                       (SELECT Id, Project_Add_On__r.Name FROM Properties_Add_On__r 
                                        WHERE Project_Add_On__r.RecordType.Name = 'Preferred Location'),
                                       (SELECT Id, Opportunity__r.Owner.Name, Status__c, Status_Change_Date__c,
                                        Opportunity__r.Account.FirstName, Opportunity__r.Account.LastName
                                        FROM Suggested_Property__r 
                                        WHERE Status__c = 'Reserved' OR Status__c = 'In Progress' OR Status__c = 'Booked'),
                                       (SELECT Id, Booking__r.Sales_Manager__r.Name, Booking__r.Closed_Reason__c, Booking__r.Booking_Date__c,
                                        Booking__r.Primary_Applicant__r.FirstName, Booking__r.Primary_Applicant__r.LastName, Booking__c,Booking__r.Name
                                        FROM Booking_Line_Items__r 
                                        WHERE (Booking__r.Closed_Reason__c != 'Transferred' OR Booking__r.Closed_Reason__c = 'Cancelled')
                                        AND Project_Add_On_Charges__c = null) 
                                       FROM Property__c 
                                       WHERE Project__c =: projectId 
                                       ORDER BY Floor__c desc, Name asc]){
                                           
                                           properties.add(new CarParkingGraphicalViewWrapper.Property(property));
                                       }
            
            return properties;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static String createSuggestedProperty(String propertyId,String oppId){   
        List<Suggested_Property__c> spList = new List<Suggested_Property__c>();
        spList = [Select id from Suggested_Property__c where Unit__c = :propertyId AND Opportunity__c = :oppId];
        
        if(spList.isEmpty()){
            Suggested_Property__c sp = new Suggested_Property__c();
            sp.Unit__c = propertyId;
            sp.Opportunity__c = oppId;
            sp.status__c= 'Short Listed';
            
            insert sp;
            return sp.Id;
        }
        else{
            return 'Record Already Exists';
        }
    }
    
    @AuraEnabled
    public static String changeStatus(String propertyId){
        system.debug('propertyId'+propertyId);
        List<Property__c> ListProp = [Select Id,Property_Status__c From Property__c Where Id=:propertyId];
        system.debug('ListProp'+ListProp);
        List<Property__c> UpdateList = new List<Property__c>();
        if(!ListProp.isEmpty()){
            for(Property__c Prop:ListProp){
                Prop.Property_Status__c = 'Available';
                UpdateList.add(Prop);
            }
            try {
                update UpdateList;
            } catch (Exception e) {
                if (e.getMessage().contains('UNABLE_TO_LOCK_ROW')) {
                    Datetime futureTime = Datetime.now().addSeconds(2);
                    while (Datetime.now() < futureTime) {
                        
                    }
                    update UpdateList;
                }else {
                    
                }
            }
            
            List<Add_On__c> AddOnList = [Select Id,Name,Car_Parking__c From Add_On__c Where Car_Parking__c =: propertyId];
            if(!AddOnList.isEmpty()){
                delete AddOnList;
            }
            
            system.debug('ListProp'+ListProp);
        }
        return 'Record Successfully Updated';
        
    }
    @AuraEnabled
    public static List<Suggested_Property__c> getSuggProp(string opportunityId){
        system.debug('opportunityId '+opportunityId);
        return [Select Id, Name,Unit__r.Name From Suggested_Property__c Where Opportunity__c=:opportunityId];
    }
    
    public class SuggestedProperty {
        @AuraEnabled public Id Id;
        @AuraEnabled public String Name;
        // Add other fields as needed
    }
    
}