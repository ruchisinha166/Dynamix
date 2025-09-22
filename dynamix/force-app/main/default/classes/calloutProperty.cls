/*
 * Author : Nachiketa Khera
 * Created Date : 15th December 2023
 * Description : Property Api for SAP integration.
 * Last Modified Date : 4th January 2024
*/

public with sharing class calloutProperty {
    @InvocableMethod
    public static void getProperties(List<request> reqList){
        System.debug('reqList'+reqList);
        if(reqList != null){
            for(request req :reqList){
                exposePropertyToSAP(req.propertyIds);
            }
        }
    }
    @future(Callout=true)
    public static void exposePropertyToSAP(String propertyIds){
        System.debug('Inside class'+propertyIds);
        try{
            system.debug('propertyIds---> '+propertyIds);
            Set<String> propertyIdsFromDataSync = new Set<String>();
            Map<Id,Property__c> propertyMap = new Map<Id,Property__c>();
            Map<Id,List<Booking__c>> bookingAgainstPropertyMap = new Map<Id,List<Booking__c>>();
            Set<String> propertyProcessed = new Set<String>();
            for (Data_Sync__c dataSync:[Select Id,Event_Type__c,RecordId__c, Status__c from Data_Sync__c where Status__c ='Pending' and RecordId__c =:propertyIds]){
                propertyIdsFromDataSync.add(dataSync.RecordId__c);
            }
            if(propertyIdsFromDataSync != null){
                for(Property__c prop:[
                    Select Id,Name,Tower__r.Tower_Number__c,Tower__r.Tower_SAP_Code__c,Deck_Proposed_Area__c,Proposed_Utility_Area__c,Proposed_Enclosed_Balcony_Area__c,
                    Enclosed_balcony__c,SAP_Code__c,Material_Type__c,Project__r.Name,Distribution_Channel__c,Proposed_Area__c,Floor__c,Parking_Type__c,Tower__r.Name,
                    Unit_classification__c,Flat_Type__c,Project__r.Project_SAP_Code__c,HSN_Code__c,Unit_Type__c,Unit_View__c,Wing__c,Property_Status__c
                    from Property__c where Id =: propertyIdsFromDataSync
                ]){
                    if(prop != null){
                        propertyMap.put(prop.Id,prop);
                        //pricingPlanIds.add(prPlanComp.Pricing_Plan__c);
                    }
                }
            }
            if(!propertyIdsFromDataSync.isEmpty()){
                for(Suggested_Property__c suggProp:[Select Id,Name,Unit__c,(Select Id,Name,Booking_Date__c,Stage__c from Booking__r) from Suggested_Property__c where Unit__c IN:propertyIdsFromDataSync]){
                    if(suggProp != null){
                        if(suggProp.Booking__r != null){
                            if(!bookingAgainstPropertyMap.containsKey(suggProp.Unit__c)){
                              	List<Booking__c> bookingToAddInMap = new List<Booking__c>();
                                bookingToAddInMap.addAll(suggProp.Booking__r);    
                                bookingAgainstPropertyMap.put(suggProp.Unit__c,bookingToAddInMap);
                            }
                            else{
                                bookingAgainstPropertyMap.get(suggProp.Unit__c).addAll(suggProp.Booking__r);
                            }
                        }
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
            // Get today's date
            Date today = Date.today();
            // Format the day with leading zero if single digit
            String formattedDay = (today.day() < 10) ? '0' + String.valueOf(today.day()) : String.valueOf(today.day());
            // Format the month with leading zero if single digit
            String formattedMonth = (today.month() < 10) ? '0' + String.valueOf(today.month()) : String.valueOf(today.month());
            // Concatenate the formatted date
            String formattedDate = formattedDay + '.' + formattedMonth + '.' + today.year();
            
            List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
            if(!propertyMap.isEmpty()){
                for(String propId:propertyMap.keySet()){
                    propertyProcessed.add(propId);
                    JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
                    Property__c prop = propertyMap.get(propId);
                    
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('ZSD013_SFDC_UNIT_INVENTORY');
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('MATERIAL_DATA');
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('item');
                    jsonGenerator1.writeStartArray();
                    	jsonGenerator1.writeStartObject();
                    		jsonGenerator1.writeStringField('WERKS',prop.Tower__r.Tower_SAP_Code__c!=null?prop.Tower__r.Tower_SAP_Code__c:'');
                    		jsonGenerator1.writeStringField('SFDC_ID',prop.Id!=null?prop.Id:'');
                            if(bookingAgainstPropertyMap.containsKey(prop.Id)){
                                List<Booking__c> bookList = bookingAgainstPropertyMap.get(prop.Id) !=null? bookingAgainstPropertyMap.get(prop.Id):null;
                                jsonGenerator1.writeStringField('BISMT',bookList[0].Name!=null?string.valueOf(bookList[0].Name):'');
                            }
                    		jsonGenerator1.writeStringField('ATFLV_DECK',prop.Deck_Proposed_Area__c!=null?string.valueOf(prop.Deck_Proposed_Area__c):'');
                    		jsonGenerator1.writeStringField('ATFLV_CPRK',prop.Proposed_Utility_Area__c!=null?string.valueOf(prop.Proposed_Utility_Area__c):'');
                    		jsonGenerator1.writeStringField('ATFLV_BALCON',prop.Proposed_Enclosed_Balcony_Area__c!=null?string.valueOf(prop.Proposed_Enclosed_Balcony_Area__c):'');
                    		jsonGenerator1.writeStringField('ENC_BALCON',prop.Enclosed_balcony__c!=null?string.valueOf(prop.Enclosed_balcony__c):'');
                    		String matnrValue = '';
                            if(prop.Tower__r.Tower_SAP_Code__c!=null){
                                matnrValue += prop.Tower__r.Tower_SAP_Code__c;
                            }
                            if(prop.Flat_Type__c!=null){
                                matnrValue += unitTypeMap.get(prop.Flat_Type__c);
                            }
                            if(prop.Name!=null){
                                if (prop.Name.length() < 4) {
                                    Integer zeroesToAdd = 4 - prop.Name.length();
                                    
                                    for (Integer i = 0; i < zeroesToAdd; i++) {
                                        prop.Name = '0' + prop.Name;
                                    }
                                }
                                matnrValue += prop.Name;
                            }
                    		jsonGenerator1.writeStringField('MATNR',matnrValue!=null?matnrValue:'');
                    		jsonGenerator1.writeStringField('MTART',prop.Material_Type__c!=null?prop.Material_Type__c:'');
                    		jsonGenerator1.writeStringField('VKORG',prop.Project__r.Project_SAP_Code__c!=null?prop.Project__r.Project_SAP_Code__c:'');
                    		jsonGenerator1.writeStringField('VTWEG',prop.Distribution_Channel__c!=null?prop.Distribution_Channel__c:'');
                    		jsonGenerator1.writeStringField('MAKTX',prop.Name!=null?prop.Name:'');
                    		jsonGenerator1.writeStringField('NTGEW',prop.Proposed_Area__c!=null?string.valueOf(prop.Proposed_Area__c):'');
                    		jsonGenerator1.writeStringField('MSTAV',statusCodesMap.get(prop.Property_Status__c)!=null?statusCodesMap.get(prop.Property_Status__c):'');
                    		jsonGenerator1.writeStringField('MSTDV',string.valueOf(formattedDate));
                    		jsonGenerator1.writeStringField('MVGR1_D',floorMap.get(prop.Floor__c)!=null?floorMap.get(prop.Floor__c):'');
                    		jsonGenerator1.writeStringField('MVGR2_D',prop.Flat_Type__c!=null?prop.Flat_Type__c:'');
                    		jsonGenerator1.writeStringField('MVGR3_D',prop.Wing__c!=null?prop.Wing__c:'');
                    		jsonGenerator1.writeStringField('MVGR4_D',prop.Unit_View__c!=null?prop.Unit_View__c:'');
                    		jsonGenerator1.writeStringField('MVGR5_D',prop.Unit_classification__c!=null?prop.Unit_classification__c:'');
                    		jsonGenerator1.writeStringField('STEUC',prop.HSN_Code__c!=null?prop.HSN_Code__c:'');
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
        }catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            System.debug('Exception:Number>> ' + e.getLineNumber());
        }
    }
    
    public static String getSapCodes( String jsonString,Set<String>propertyProcessed){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        request.setEndpoint('callout:SAP_Inventory');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/plain');
        request.setHeader('Authorization', 'Basic UzAwMjQzMDI0NDA6Umlja3lAOTk2OQ==');
        request.setBody(jsonString);
        //List<Pricing_Plan_Components__c> prPlanCompToUpdate = new List<Pricing_Plan_Components__c>();
        Set<String>propertyIds=new Set<String>();
        try {
            response = http.send(request);
            ResponseAPIClass.getResponse(response);
            List<Data_Sync__c> DSToUpdate = new List<Data_Sync__c>();
            if (response.getStatusCode() == 200 ||response.getStatusCode() == 201) {
                String responseBody = response.getBody();
                
                if(propertyProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c where RecordId__c IN :propertyProcessed AND Status__c = 'Pending']){
                        Data_Sync__c dataSync=new Data_Sync__c();
                        dataSync.Status__c='Success';
                        dataSync.Response_Body__c = response.getBody();
                        dataSync.Request_Body__c = jsonString;
                        dataSync.Id=DS.id;
                        DSToUpdate.add(dataSync);
                    }
                    System.debug('HTTP Request sent Successfully: ' + response.getStatusCode());
                    System.debug('Response body: ' + response.getBody());
                }
                
            } else {
                if(propertyProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c  where RecordId__c IN :propertyProcessed AND Status__c = 'Pending']){
                        Data_Sync__c dataSync=new Data_Sync__c();
                        dataSync.Status__c='Error';
                        dataSync.Response_Body__c=response.getBody();
                        dataSync.Request_Body__c=jsonString;
                        dataSync.Id=DS.id;
                        DSToUpdate.add(dataSync);
                    }
                }
                System.debug('HTTP Request failed with status code: ' + response.getStatusCode());
                System.debug('Response body: ' + response.getBody());
            }
            
            
            if(DSToUpdate.size()>0){
                update DSToUpdate;
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
        return null;
    }
    public class request{
        @InvocableVariable (required=true)
        public string propertyIds;
    }
}