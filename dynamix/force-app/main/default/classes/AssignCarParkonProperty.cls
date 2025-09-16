public class AssignCarParkonProperty {
    public static void carPark(List<Booking__c> bookList,Map<Id,Booking__c> oldBookMap){
        system.debug('bookList----'+bookList);
        Set<Id> bookId = new Set<Id>();
        Set<Id> carParkId = new set<Id>();
        Set<Id> preAllotCarparkId= new Set<Id>();
        Id unitId;
        Id ProjectId;
        Decimal carParkCount = 0;
        Decimal carParkToAsign = 0;
        List<Property__c> carParkToUpdate = new List<Property__c>();
        List<Property__c> PreAllotCarParkToUpdate = new List<Property__c>();
        List<Project_Add_On_Charges__c> projAddOnAdd = new List<Project_Add_On_Charges__c>();
        List<Property_Add_On__c> propAddOnAdd = new List<Property_Add_On__c>();
        Id ProjAddOnRecordTypeId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        
        if(!bookList.isEmpty()){
            for(Booking__c book:bookList){
                if((book.Cancellation_Approval_Status__c=='Approved') && (oldBookMap.get(book.Id).Cancellation_Approval_Status__c !=book.Cancellation_Approval_Status__c)){
                    bookId.add(book.Id);
                    ProjectId = book.Project_Name__c;
                    
                }
                system.debug('bookId----'+bookId);
                if(!bookId.isEmpty()){
                    List<Property__c> carParkList = [Select Id,Name,Property_Status__c From Property__c Where Booking__c In :bookId AND Property_Status__c = 'Allotted'];
                    List<Property__c> preAllotCarPark = [Select Id,Name From Property__c Where Booking__c In :bookId AND Property_Status__c = 'Pre - Allotted'];
                    system.debug('carParkList----'+carParkList);
                    system.debug('preAllotCarPark----'+preAllotCarPark);
                    if(!carParkList.isEmpty()){
                        for(Property__c carPark:carParkList){
                            carpark.Property_Status__c = 'Available';
                            carPark.Booking__c = null;
                            carParkToUpdate.add(carPark);
                            system.debug('carParkToUpdate----'+carParkToUpdate);
                        }
                        update carParkToUpdate;
                    }
                    
                    List<Booking__c> ListBooking = [Select Id,Name,Related_Suggested_property__r.unit__c,No_of_car_Parking__c From Booking__c WHere Id In :bookId];
                    system.debug('ListBooking----'+ListBooking);    
                    if(!ListBooking.isEmpty()){
                        for(Booking__c booking:ListBooking){
                            unitId = booking.Related_Suggested_Property__r.Unit__c;
                        }
                        system.debug('unitId----'+unitId);
                        List<Property__c> unitList = [Select Id,Name,No_of_car_Parking__c From Property__c Where Id=:unitId];
                        system.debug('unitList----'+unitList);
                        if(!unitList.isEmpty()){
                            for(Property__c unit:unitList){
                                carParkCount = unit.No_of_car_Parking__c;
                            }
                            system.debug('carParkCount----'+carParkCount);
                            if(carParkCount>preAllotCarPark.size()){
                                carParkToAsign = carParkCount-preAllotCarPark.size();
                                system.debug('carParkToAsign----'+carParkToAsign);
                                List<Property__c> AvailCarParkList = [Select Id,Name,Project__c,Property_Status__c From Property__c Where Property_Status__c='Available'  AND Flat_Type__c  IN ('CAR PARKING','BIKE PARKING') LIMIT :carParkToAsign.intValue()];
                                system.debug('AvailCarParkList----'+AvailCarParkList);
                                Project_Add_On_Charges__c projAddOn = new Project_Add_On_Charges__c();
                                projAddOn.Project__c = ProjectId;
                                projAddOn.Name = 'Project AddOn';
                                projAddOn.RecordTypeId = ProjAddOnRecordTypeId;
                                insert projAddOn;
                                //List<Project_Add_On_Charges__c> projAddOnList = [Select Id,Name From Project_Add_On_Charges__c Where Id IN =projAddOn.Id];
                                if(!AvailCarParkList.isEmpty()){
                                    for(Property__c AvailCarPark:AvailCarParkList){
                                        AvailCarPark.Property_Status__c = 'Pre - Allotted';
                                        Property_Add_On__c  propAddOn = new Property_Add_On__c();
                                        propAddOn.Car_Parking__c = AvailCarPark.Id;
                                        propAddOn.Project_Add_On__c = projAddOn.Id;
                                        propAddOn.Property__c = unitId;
                                        propAddOnAdd.add(propAddOn);
                                    }
                                    //insert projAddOnAdd;
                                    insert propAddOnAdd;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}