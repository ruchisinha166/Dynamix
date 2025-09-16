public with sharing class PropertyGraphicalViewController {
    
    @AuraEnabled(cacheable=true)
    public static PropertyGraphicalViewWrapper getInventory(String projectId){
        try {
            
            PropertyGraphicalViewWrapper propertyGraph = new PropertyGraphicalViewWrapper();
            
            Map<String, PropertyGraphicalViewWrapper.Tower> towerMap = new Map<String, PropertyGraphicalViewWrapper.Tower>();
            Map<String, Map<String, PropertyGraphicalViewWrapper.Floor>> floorMap = new Map<String, Map<String, PropertyGraphicalViewWrapper.Floor>>();
            
            for(Property__c property: [SELECT Id, Name, Tower__c,Parking_Type__c, Tower__r.Name, Floor__c, Property_Status__c, Flat_Type__c,Snag_Status__c,
                                       Total_Area__c, Property_Price_Slab__c,No_of_Car_Parking__c,No_of_Bike_Parking__c,
                                       RERA_Carpet_Area__c,Deck_Carpet_Area__c,Utility_Area__c, Pricing_Plan_Detail__c,
                                       (SELECT Id, Project_Add_On__r.Name FROM Properties_Add_On__r 
                                        WHERE Project_Add_On__r.RecordType.Name = 'Preferred Location'),
                                       (SELECT Id, Opportunity__r.Owner.Name, Status__c, Status_Change_Date__c,
                                        Opportunity__r.Account.FirstName, Opportunity__r.Account.LastName
                                        FROM Suggested_Property__r 
                                        WHERE Status__c = 'Reserved' OR Status__c = 'In Progress' OR Status__c = 'Booked'
                                        OR Status__c = 'Confirmed Allocation'),
                                       (SELECT Id, Booking__r.Sales_Manager__r.Name, Booking__r.Closed_Reason__c, Booking__r.Booking_Date__c,Booking__r.Stage__c,
                                        Booking__r.Primary_Applicant__r.FirstName, Booking__r.Primary_Applicant__r.LastName, Booking__c,Booking__r.name
                                        FROM Booking_Line_Items__r 
                                        WHERE (Booking__r.Closed_Reason__c != 'Transferred' OR Booking__r.Closed_Reason__c = 'Cancelled')
                                        AND Project_Add_On_Charges__c = null)
                                       FROM Property__c 
                                       WHERE Project__c =: projectId AND Flat_Type__c NOT IN ('CAR PARKING','BIKE PARKING') 
                                       ORDER BY Floor__c desc, Name asc]){
                                           
                                           String relatedTower = '';
                                           
                                           if(property.Tower__c == null){
                                               relatedTower = 'Property Plan';
                                           }
                                           else{
                                               relatedTower = property.Tower__c;
                                           }
                                           
                                           if(towerMap.containsKey(relatedTower)){
                                               
                                               if(floorMap.get(relatedTower).containsKey(property.Floor__c)){
                                                   floorMap.get(relatedTower).get(property.Floor__c).properties.add(new PropertyGraphicalViewWrapper.Property(property));
                                               }
                                               else{
                                                   PropertyGraphicalViewWrapper.Floor floor = new PropertyGraphicalViewWrapper.Floor(property);
                                                   floorMap.get(relatedTower).put(property.Floor__c, floor);
                                                   towerMap.get(relatedTower).floors.add(floor);
                                               }
                                           }
                                           else{
                                               PropertyGraphicalViewWrapper.Tower tower = new PropertyGraphicalViewWrapper.Tower(property);
                                               Map<String, PropertyGraphicalViewWrapper.Floor> floors = new Map<String, PropertyGraphicalViewWrapper.Floor>();
                                               
                                               towerMap.put(relatedTower, tower);
                                               floors.put(property.Floor__c, tower.floors[0]);
                                               floorMap.put(relatedTower, floors);
                                           }
                                       }
            
            propertyGraph.towers = new List<PropertyGraphicalViewWrapper.Tower>();
            
            for(PropertyGraphicalViewWrapper.Tower tower: towerMap.values()){
                propertyGraph.towers.add(tower);
            }
            
            return propertyGraph;
        } catch (Exception e) {
            System.debug(e.getMessage()+e.getLineNumber());
            throw new AuraHandledException(e.getMessage()+e.getLineNumber());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<PropertyGraphicalViewWrapper.Property> getProperties(String projectId){
        try {
            
            List<PropertyGraphicalViewWrapper.Property> properties = new List<PropertyGraphicalViewWrapper.Property>();
            
            for(Property__c property: [SELECT Id, Name, Tower__c,Parking_Type__c, Tower__r.Name, Floor__c, Property_Status__c, Flat_Type__c,Snag_Status__c,No_of_Car_Parking__c,
                                       Total_Area__c, Property_Price_Slab__c,RERA_Carpet_Area__c,No_of_Bike_Parking__c,
                                       Deck_Carpet_Area__c,Utility_Area__c, Pricing_Plan_Detail__c,
                                       (SELECT Id, Project_Add_On__r.Name FROM Properties_Add_On__r 
                                        WHERE Project_Add_On__r.RecordType.Name = 'Preferred Location'),
                                       (SELECT Id, Opportunity__r.Owner.Name, Status__c, Status_Change_Date__c,
                                        Opportunity__r.Account.FirstName, Opportunity__r.Account.LastName
                                        FROM Suggested_Property__r 
                                        WHERE Status__c = 'Reserved' OR Status__c = 'In Progress' OR Status__c = 'Booked'
                                        OR Status__c = 'Confirmed Allocation'),
                                       (SELECT Id, Booking__r.Sales_Manager__r.Name, Booking__r.Closed_Reason__c, Booking__r.Booking_Date__c,Booking__r.Stage__c,
                                        Booking__r.Primary_Applicant__r.FirstName, Booking__r.Primary_Applicant__r.LastName, Booking__c,Booking__r.Name
                                        FROM Booking_Line_Items__r 
                                        WHERE (Booking__r.Closed_Reason__c != 'Transferred' OR Booking__r.Closed_Reason__c = 'Cancelled')
                                        AND Project_Add_On_Charges__c = null) 
                                       FROM Property__c 
                                       WHERE Project__c =: projectId 
                                       ORDER BY Floor__c desc, Name asc]){
                                           
                                           properties.add(new PropertyGraphicalViewWrapper.Property(property));
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
    
}