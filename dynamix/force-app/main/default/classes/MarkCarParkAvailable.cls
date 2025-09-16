public class MarkCarParkAvailable {
    public static void AvailableParkin(List<Booking__c> bookList){
        system.debug('bookList----'+bookList);
        Set<Id> suggPropId = new Set<Id>();
        Set<Id> propId = new Set<Id>();
        Set<Id> carParkId = new Set<Id>();
        Id bookId;
        Id PricingPlanId;
        Set<Id> carParktoMakeAvailableId = new Set<Id>();
        List<Booking__c> bookingToUpdate = new List<Booking__c>();
        List<Property__c> carParkListUpdate = new List<Property__c>();
        Map<Id,Id> mapSuggPropBook = new Map<Id,Id>();
        Map<Id,Id> mapCarParkBook = new Map<Id,Id>();
        Integer carParkCount;
        Decimal CarparkValue = 0;
        List<Price_Details__c> PriceDetailUpdate = new List<Price_Details__c>();
        if(!bookList.isEmpty()){
            for(Booking__c book:bookList){
                suggPropId.add(book.Related_Suggested_Property__c);
                bookId = book.Id;
                mapSuggPropBook.put(book.Related_Suggested_Property__c,book.Id);
            }
            system.debug('suggPropId----'+suggPropId);
            system.debug('bookId----'+bookId);
            if(!suggPropId.isEmpty()){
                List<Add_On__c> AddOnList = [SELECT Id,Name,Suggested_Property__r.Unit__c,Car_Parking__c,Car_Parking__r.Car_Parking_Value__c,Parking_Value__c
                                             FROM Add_On__c 
                                             WHERE Suggested_Property__c IN :suggPropId];
                system.debug('AddOnList----'+AddOnList);
                if(!AddOnList.isEmpty()){
                    for(Add_On__c AddOn:AddOnList){
                        if(AddOn.Parking_Value__c!=null){
                            CarparkValue+=AddOn.Parking_Value__c;
                        }
                        else{
                            CarparkValue+=0;
                        }
                        propId.add(AddOn.Suggested_Property__r.Unit__c);
                        carParkId.add(AddOn.Car_Parking__c);
                        mapCarParkBook.put(AddOn.Car_Parking__c,mapSuggPropBook.get(AddOn.Suggested_Property__c));
                    }
                    system.debug('propId----'+propId);
                    system.debug('carParkId----'+carParkId);
                    carParkCount = AddOnList.size();
                    if(!carParkId.isEmpty()){
                        List<Property__c> carParkList = [SELECT Id,Name,Booking__c,Property_Status__c 
                                                         FROM Property__c 
                                                         WHERE Id IN :carParkId];
                        system.debug('carParkList----'+carParkList);
                        if(!carParkList.isEmpty()){
                            for(Property__c carPark:carParkList){
                                if(carPark.Property_Status__c=='Allotted In Progress'){
                                    carPark.Property_Status__c = 'Allotted';
                                }
                                carPark.Date_of_Car_Park_Booking__c = system.today();
                                carPark.Booking__c = bookId;
                                carParkListUpdate.add(carPark);
                            }
                            system.debug('carParkListUpdate----'+carParkListUpdate);
                        }
                    }
                }
            }
            if(!carParkId.isEmpty() && !propId.isEmpty()){
                List<Property_Add_On__c> propAddOnList = [SELECT Id,Car_Parking__c 
                                                          FROM Property_Add_On__c 
                                                          WHERE Property__c IN :propId 
                                                          AND Car_Parking__c NOT In :carParkId];
                system.debug('propAddOnList----'+propAddOnList);
                if(!propAddOnList.isEmpty()){
                    for(Property_Add_On__c propAddOn:propAddOnList){
                        carParktoMakeAvailableId.add(propAddOn.Car_Parking__c);
                    }
                    system.debug('carParktoMakeAvailableId----'+carParktoMakeAvailableId);
                    if(!carParktoMakeAvailableId.isEmpty()){
                        List<Property__c> carParkTomakeAvailList = [SELECT Id,Name,Property_Status__c 
                                                                    FROM Property__c 
                                                                    WHERE Id IN :carParktoMakeAvailableId];
                        system.debug('carParkTomakeAvailList----'+carParkTomakeAvailList);
                        if(!carParkTomakeAvailList.isEmpty()){
                            for(Property__c carPark:carParkTomakeAvailList){
                                carPark.Property_Status__c = 'Available';
                                carParkListUpdate.add(carPark);
                                system.debug('carParktoMakeAvailableId----'+carParktoMakeAvailableId);
                            }
                        }
                        List<Add_On__c> AddOntoDelete = [SELECT Id 
                                                         FROM Add_On__c 
                                                         WHERE Car_Parking__c IN :carParktoMakeAvailableId];
                        system.debug('AddOntoDelete----'+AddOntoDelete);
                        delete AddOntoDelete; 
                    }
                    system.debug('bookingToUpdate----'+carParktoMakeAvailableId);                   
                }
                
                delete propAddOnList; 
            }
            
            Map<Id,String> projGstTreatMentMap = new Map<Id,String>();
            List<Property__c> property = [SELECT Id, Index__c,Name,Total_Area__c, Property_Price_Slab__c, Floor__c FROM Property__c WHERE Id =: propId];
            system.debug('property=='+property);
            
            for(Property__c prop:property){
                PricingPlanId=prop.Property_Price_Slab__c;
            }
            List<Pricing_Plan_Components__c> pPComponentLst = [SELECT Id, Name, Price_Lumpsum__c, Price_age__c, Price_per_SQFT__c, GST_Treatment__c,
                                                           Project_Add_On_Charges__r.Name, Project_Add_On_Charges__r.Age_Calculated_on__c, 
                                                           Project_Add_On_Charges__r.Charge_Group__c, Project_Add_On_Charges__r.Charge_Type__c,
                                                           Project_Add_On_Charges__r.RecordType.Name, Project_Add_On_Charges__r.Is_Optional__c,
                                                           Project_Add_On_Charges__c
                                                           FROM Pricing_Plan_Components__c 
                                                           WHERE Pricing_Plan__c =: PricingPlanId];
            for(Pricing_Plan_Components__c pPComponent: pPComponentLst){
                //system.debug('pPComponent----'+pPComponent);
                if(pPComponent.Project_Add_On_Charges__r.Charge_Type__c == 'Fixed' && (pPComponent.Name == 'Car Parking Space' ||  pPComponent.Name == '2 Wheeler Parking')){
                    projGstTreatMentMap.put(pPComponent.Project_Add_On_Charges__c,pPComponent.GST_Treatment__c);
                    system.debug('pPComponent----'+pPComponent);
                }
            }
            List<Price_Details__c> priceDetailsList = new List<Price_Details__c>();
            List<Add_On__c> AddOnList = [Select Id,Name,Parking_Value__c,Car_Parking__c,Project_Add_On_Charges__r.Name,Project_Add_On_Charges__r.Charge_Group__c From Add_On__c Where Suggested_Property__c =:suggPropId];
            system.debug('AddOnList----'+AddOnList);
            system.debug('priceDetailsList----'+priceDetailsList);
            for(Add_On__c AddOn:AddOnList){
                if(AddOn.Parking_Value__c!=null){
                    system.debug('AddOn----'+AddOn);
                    Price_Details__c priceDetail = new Price_Details__c();
                    priceDetail.Booking__c = bookId;
                    priceDetail.Name = AddOn.Project_Add_On_Charges__r.Name;
                    priceDetail.Charge_Group__c = AddOn.Project_Add_On_Charges__r.Charge_Group__c;
                    priceDetail.Amount__c = AddOn.Parking_Value__c;
                    priceDetail.GST_Type__c = projGstTreatMentMap.get(AddOn.Project_Add_On_Charges__c);
                    priceDetail.GST__c = 1;
                    priceDetail.Additional_Car_Bike_Parking__c = false;
                    priceDetail.Parking__c = AddOn.Car_Parking__c;
                    priceDetailsList.add(priceDetail);
                }
            }
            system.debug('priceDetailsList1----'+priceDetailsList);
            insert priceDetailsList;
            update carParkListUpdate;
            update bookingToUpdate;
        } 
    }
}