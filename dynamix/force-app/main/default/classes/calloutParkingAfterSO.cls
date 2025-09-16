public class calloutParkingAfterSO {
    /*
* Author : Nachiketa Khera
* Created Date : 14th January 2025
* Description : API for SAP integration to sync the Car/Bike Parking Inventory to Sales Order/Booking.
* Last Modified Date : 16th January 2025
*/
    @InvocableMethod
    public static void getParking(List<request> reqList){
        System.debug('reqList'+reqList);
        if(reqList != null){
            for(request req :reqList){
                exposeSOParkingToSAP(req.parkingIds,req.dataSyncId);
            }
        }
    }
    @future(Callout=true)
    public static void exposeSOParkingToSAP(String parkingIds, String dataSyncId){
        try{
            Set<String> parkingIdsFromDataSync = new Set<String>();
            Map<Id,Property__c> propertyMap = new Map<Id,Property__c>();
            Set<Id> bookingIds = new Set<Id>();
            Set<String> propertyProcessed = new Set<String>();
            Booking__c book = new Booking__c();
            Map<Id,Price_Details__c> priceDetailMap = new Map<Id,Price_Details__c>();
            for (Data_Sync__c dataSync:[Select Id,Event_Type__c,RecordId__c, Status__c from Data_Sync__c where Status__c ='Pending' AND
                                        Id =:dataSyncId ORDER BY CreatedDate DESC limit 1]){
                                            parkingIdsFromDataSync.add(dataSync.RecordId__c);
                                        }
            if(parkingIdsFromDataSync != null){
                for(Property__c prop:[
                    Select Id,Name,SAP_Code__c,Project__r.Name,Property_Status__c,Booking__c,Booking__r.Name,Date_of_Car_Park_Booking__c,CreatedDate,
                    Booking__r.Sap_Code__c
                    from Property__c where Id =: parkingIdsFromDataSync AND Sap_Code__c != null])
                {
                    if(prop != null){
                        propertyMap.put(prop.Id,prop);
                    }
                    if(prop.Booking__c != null){
                        bookingIds.add(prop.Booking__c);
                    }
                }
                if(!bookingIds.isEmpty()){
                    book = [Select Id, Name,Registration_Status__c, (Select Id,Booking__c,Amount__c,Discount__c,Name,Charge_Group__c,Parking__c
                                                      From Price_Details__r where Parking__c =:parkingIdsFromDataSync) from Booking__c where Id =:bookingIds AND Sap_Code__c != null];
                    if(book.Price_Details__r != null){
                        for(Price_Details__c pd:book.Price_Details__r){
                            priceDetailMap.put(pd.Parking__c,pd);
                        }
                    }
                }
            }
            
            List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
            if(!propertyMap.isEmpty()){
                for(String parkPropId:propertyMap.keySet()){
                    propertyProcessed.add(dataSyncId);
                    
                    Property__c parkProp = propertyMap.get(parkPropId);
                    JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
                    
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('ZSD018_SFDC_SO_CAR_UPDATE');
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('ORDER_HEADER');
                    jsonGenerator1.writeStartObject();
                    
                    jsonGenerator1.writeStringField('SFDC_ID', parkProp.Booking__c!=null?parkProp.Booking__c:'');
                    jsonGenerator1.writeStringField('VBELN', parkProp.Booking__r.Sap_Code__c!=null?parkProp.Booking__r.Sap_Code__c:'');
                    
                    jsonGenerator1.writeEndObject();
                    jsonGenerator1.writeFieldName('PARKING_ITEMS');
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('item');
                    jsonGenerator1.writeStartArray();
                    jsonGenerator1.writeStartObject();
                    	jsonGenerator1.writeStringField('POSNR','1');
                    	jsonGenerator1.writeStringField('MATNR',parkProp.SAP_Code__c != null?parkProp.SAP_Code__c:'');
                    if(book.Registration_Status__c == 'Completed'){
                        jsonGenerator1.writeStringField('KSCHL','ZCPA');
                        jsonGenerator1.writeStringField('KWERT',priceDetailMap.get(parkProp.Id).Amount__c != null?string.valueOf(priceDetailMap.get(parkProp.Id).Amount__c):'');
                    }
                    else{
                        jsonGenerator1.writeStringField('KSCHL','ZCPR');
                        //jsonGenerator1.writeStringField('KWERT','0.00');
                        jsonGenerator1.writeStringField('KWERT',priceDetailMap.get(parkProp.Id).Amount__c != null?string.valueOf(priceDetailMap.get(parkProp.Id).Amount__c):'');
                    }
                    jsonGenerator1.writeEndObject();
                    jsonGenerator1.writeEndArray();
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
        request.setEndpoint('callout:SAP_SaleOrderParking');
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
                    /*Property__c parkProp = new Property__c();
                    parkProp.Id=SFValidId.repairCasing((String)item.get('SFDC_ID'));
                    parkProp.SAP_Code__c = (String)item.get('MATERIAL_NO');
                    parkingInventoryToUpdate.add(parkProp);*/
                    
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
            /*if(!parkingInventoryToUpdate.isEmpty()){
                update parkingInventoryToUpdate;
            }*/
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
        public string parkingIds;
        
        @InvocableVariable (required=true)
        public string dataSyncId;
    }
}