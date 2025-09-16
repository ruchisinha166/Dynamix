/*
* Author : Nachiketa Khera
* Created Date : 18th October 2024
* Description : Car/Bike Parking Property API for SAP integration.
* Last Modified Date : 9th December 2024
*/
public class calloutParkingInventory {
    @InvocableMethod
    public static void getInventory(List<request> reqList){
        System.debug('reqList'+reqList);
        if(reqList != null){
            for(request req :reqList){
                exposeParkingInventoryToSAP(req.propertyIds,req.dataSyncId);
            }
        }
    }
    @future(Callout=true)
    public static void exposeParkingInventoryToSAP(String propertyIds, String dataSyncId){
        try{
            Set<String> propertyIdsFromDataSync = new Set<String>();
            Map<Id,Property__c> propertyMap = new Map<Id,Property__c>();
            Map<Id,List<Booking__c>> bookingAgainstPropertyMap = new Map<Id,List<Booking__c>>();
            Set<String> propertyProcessed = new Set<String>();
            for (Data_Sync__c dataSync:[Select Id,Event_Type__c,RecordId__c, Status__c from Data_Sync__c where Status__c ='Pending' AND
                                        Id =:dataSyncId ORDER BY CreatedDate DESC limit 1]){
                                            propertyIdsFromDataSync.add(dataSync.RecordId__c);
                                        }
            if(propertyIdsFromDataSync != null){
                for(Property__c prop:[
                    Select Id,Name,Tower__r.Tower_Number__c,Tower__r.Tower_SAP_Code__c,SAP_Code__c,Project__r.Name,Tower__r.Name,Size_of_Parking__c,
                    Floor__c,Parking_Type__c,Flat_Type__c,Project__r.Project_SAP_Code__c,Property_Status__c,EV_Charging__c,Length__c,Breadth__c,
                    Height__c,Booking__c,Booking__r.Name,Date_of_Car_Park_Booking__c,Distribution_Channel__c,CreatedDate
                    from Property__c where Id =: propertyIdsFromDataSync])
                {
                    if(prop != null){
                        propertyMap.put(prop.Id,prop);
                    }
                }
            }
            List<Property_Status_Metadata__mdt> statusMetadata = [Select Id,Label,Status_Code__c from Property_Status_Metadata__mdt];
            Map<String,String> statusCodesMap = new Map<String,String>();
            if(!statusMetadata.isEmpty()){
                for(Property_Status_Metadata__mdt propStatus:statusMetadata){
                    statusCodesMap.put(propStatus.Label,propStatus.Status_Code__c);
                }
            }
            List<Property_Floor_Metadata__mdt> floorMetadata = [Select Id,Label,Floor__c from Property_Floor_Metadata__mdt];
            Map<String,String> floorMap = new Map<String,String>();
            if(!floorMetadata.isEmpty()){
                for(Property_Floor_Metadata__mdt propFloor:floorMetadata){
                    floorMap.put(propFloor.Label,propFloor.Floor__c);
                }
            }
            List<Property_Unit_Type_Metadata__mdt> unitTypeMetadata = [Select Id,Label,Unit_Type_Code__c from Property_Unit_Type_Metadata__mdt];
            Map<String,String> unitTypeMap = new Map<String,String>();
            if(!unitTypeMetadata.isEmpty()){
                for(Property_Unit_Type_Metadata__mdt unitType:unitTypeMetadata){
                    unitTypeMap.put(unitType.Label,unitType.Unit_Type_Code__c);
                }
            }
            List<Property_Parking_Type_Metadata__mdt> parkingTypeMetadata = [Select Id,Label,Parking_Type_Code__c from Property_Parking_Type_Metadata__mdt];
            Map<String,String> parkingTypeMap = new Map<String,String>();
            if(!parkingTypeMetadata.isEmpty()){
                for(Property_Parking_Type_Metadata__mdt parkingType:parkingTypeMetadata){
                    parkingTypeMap.put(parkingType.Label,parkingType.Parking_Type_Code__c);
                }
            }
            
            List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
            if(!propertyMap.isEmpty()){
                for(String parkPropId:propertyMap.keySet()){
                    propertyProcessed.add(dataSyncId);
                    
                    Property__c parkProp = propertyMap.get(parkPropId);
                    JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
                    
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('ZSD013_SFDC_CAR_PARK_INVENTORY');
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('MATERIAL_DATA');
                    jsonGenerator1.writeStartObject();
                    
                    jsonGenerator1.writeStringField('VKORG', parkProp.Project__r.Project_SAP_Code__c!=null?parkProp.Project__r.Project_SAP_Code__c:'');
                    jsonGenerator1.writeStringField('WERKS', parkProp.Tower__r.Tower_SAP_Code__c!=null?parkProp.Tower__r.Tower_SAP_Code__c:'');
                    jsonGenerator1.writeStringField('VTWEG', parkProp.Distribution_Channel__c!=null?parkProp.Distribution_Channel__c:'');
                    jsonGenerator1.writeStringField('SFDC_ID', parkProp.Id!=null?parkProp.Id:'');
                    
                    String matnrValue = '';
                    if(parkProp.Flat_Type__c != null){
                        matnrValue += unitTypeMap.get(parkProp.Flat_Type__c);
                    }
                    if(parkProp.Floor__c != null){
                        matnrValue += '_' + floorMap.get(parkProp.Floor__c);
                    }
                    List<String> parkPropName = parkProp.Name.split('-');
                    system.debug('parkPropName--> '+parkPropName);
                    if(parkPropName != null){
                        if (parkPropName[1].length() < 4) {
                            Integer zeroesToAdd = 4 - parkPropName[1].length();
                            
                            for (Integer i = 0; i < zeroesToAdd; i++) {
                                parkPropName[1] = '0' + parkPropName[1];
                            }
                        }
                        matnrValue += '_' + parkPropName[1];
                    }
                    
                    jsonGenerator1.writeStringField('MATNR', matnrValue!=null?matnrValue:'');
                    jsonGenerator1.writeStringField('MAKTX', parkProp.Name!=null?parkProp.Name:'');
                    jsonGenerator1.writeStringField('MVGR5_D', parkProp.Flat_Type__c!= null?parkProp.Flat_Type__c:'');
                    jsonGenerator1.writeStringField('MVGR1_D', parkProp.Floor__c!=null?parkProp.Floor__c:'');
                    jsonGenerator1.writeStringField('MSTAV', statusCodesMap.get(parkProp.Property_Status__c)!=null?statusCodesMap.get(parkProp.Property_Status__c):'');
                    jsonGenerator1.writeStringField('MVGR2_D', parkProp.Parking_Type__c!=null?parkProp.Parking_Type__c:'');
                    jsonGenerator1.writeStringField('BONUS', parkProp.Size_of_Parking__c != null && parkProp.Size_of_Parking__c=='Big'?'Big':parkProp.Size_of_Parking__c != null && parkProp.Size_of_Parking__c=='Small'?'Small':'');
                    jsonGenerator1.writeStringField('PROVG', parkProp.EV_Charging__c != null && parkProp.EV_Charging__c=='Yes'?'Yes':parkProp.EV_Charging__c != null && parkProp.EV_Charging__c=='No'?'No':'');
                    jsonGenerator1.writeStringField('BRGEW', parkProp.Length__c != null?String.valueOf(parkProp.Length__c):'');
                    jsonGenerator1.writeStringField('NTGEW', parkProp.Breadth__c != null?String.valueOf(parkProp.Breadth__c):'');
                    jsonGenerator1.writeStringField('VOLUM', parkProp.Height__c != null?String.valueOf(parkProp.Height__c):'');
                    jsonGenerator1.writeStringField('BOOKING_NAME', parkProp.Booking__c != null?parkProp.Booking__r.Name:'');
                    if(parkProp.CreatedDate != null){
                        Date createdDate = Date.valueOf(parkProp.CreatedDate);
                        String formattedDay = (createdDate.day() < 10) ? '0' + String.valueOf(createdDate.day()) : String.valueOf(createdDate.day());
                        String formattedMonth = (createdDate.month() < 10) ? '0' + String.valueOf(createdDate.month()) : String.valueOf(createdDate.month());
                        String formattedDate = formattedDay + '.' + formattedMonth + '.' + createdDate.year();
                        jsonGenerator1.writeStringField('MSTDV', formattedDate!=null?formattedDate:'');
                    }
                    else{
                        jsonGenerator1.writeStringField('MSTDV', '');
                    }
                    
                    jsonGenerator1.writeEndObject();
                    jsonGenerator1.writeEndObject();
                    jsonGenerator1.writeEndObject();
                    jsonGeneratorList.add(jsonGenerator1);
                }
            }
            if(jsonGeneratorList.size()>0){
                String jsonString = '';
                for (JSONGenerator generator : jsonGeneratorList) {
                    jsonString += generator.getAsString();
                }
                system.debug('jsonString--> '+jsonString);
                getSapCodes(jsonString,propertyProcessed);
            } 
        }
        catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            System.debug('Exception:Number>> ' + e.getLineNumber());
        }
    }
    public static void getSapCodes( String jsonString,Set<String>propertyProcessed){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        request.setEndpoint('callout:SAP_ParkingInventory');
        request.setMethod('POST');
        //request.setHeader('Content-Type', 'text/plain');
        request.setHeader('Authorization', System.Label.AuthorizationHeader);
        request.setBody(jsonString);
        try{
            response = http.send(request);
            String responseBody = response.getBody();
            List<Property__c> parkingInventoryToUpdate = new List<Property__c>();
            List<Data_Sync__c> DSToUpdate = new List<Data_Sync__c>();
            System.debug('responseBody--> '+responseBody);
            Map<String, Object> responseBodyMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            List<Object> sapResponseArray = (List<Object>)responseBodyMap.get('item');
            System.debug('responseBody sapResponseArray---'+sapResponseArray);
            
            for (Object obj : sapResponseArray) {
                Map<String, Object> item = (Map<String, Object>)obj;
                String Status = (String)item.get('STATUS');
                System.debug('Response Status--> '+Status);
                if(Status=='Success'){
                    Property__c parkProp = new Property__c();
                    parkProp.Id=SFValidId.repairCasing((String)item.get('SFDC_ID'));
                    parkProp.SAP_Code__c = (String)item.get('MATERIAL_NO');
                    parkingInventoryToUpdate.add(parkProp);
                    
                    if(propertyProcessed.size()>0){
                        for(Data_Sync__c DS:[select Id,Status__c,RecordId__c from Data_Sync__c where Id IN :propertyProcessed AND Status__c = 'Pending']){
                            Data_Sync__c dataSync=new Data_Sync__c();
                            dataSync.Status__c='Success';
                            dataSync.Response_Body__c = responseBody;
                            dataSync.Request_Body__c = jsonString;
                            dataSync.Id = DS.Id;
                            DSToUpdate.add(dataSync);
                        }
                    }
                }
                else{
                    if(propertyProcessed.size()>0){
                        system.debug('Inside Error Else-->');
                        for(Data_Sync__c DS:[select Id,Status__c,RecordId__c from Data_Sync__c where Id IN :propertyProcessed AND Status__c = 'Pending']){
                            Data_Sync__c dataSync=new Data_Sync__c();
                            dataSync.Status__c='Error';
                            dataSync.Response_Body__c = responseBody;
                            dataSync.Request_Body__c = jsonString;
                            dataSync.Id = DS.Id;
                            DSToUpdate.add(dataSync);
                            system.debug('Data Sync --> ' +DSToUpdate);
                        }
                    }
                }
            }
            if(!parkingInventoryToUpdate.isEmpty()){
                update parkingInventoryToUpdate;
            }
            if(DSToUpdate.size()>0){
                update DSToUpdate;
            }
        }
        catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            System.debug('Exception:Number>> ' + e.getLineNumber());
        }
    }
    public class request{
        @InvocableVariable (required=true)
        public string propertyIds;
        
        @InvocableVariable (required=true)
        public string dataSyncId;
    }
}