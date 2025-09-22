/*
 * Author : Nachiketa Khera
 * Created Date : 11th December 2023
 * Description : Pricing Master Api for SAP integration.
 * Last Modified Date : 4th January 2024
*/
public with sharing class calloutPricingMaster {
    @InvocableMethod
    public static void getPricingPlanComponent(List<request> reqList){
        System.debug('reqList'+reqList);
        if(reqList != null){
            for(request req :reqList){
                exposePricingPlanToSAP(req.prPlanComponentIds);
            }
            // exposePricingPlanToSAP(reqList[0].prPlanComponentIds);
        }
    }
    @future(Callout=true)
    public static void exposePricingPlanToSAP(String prPlanComponentIds){
        System.debug('Inside class'+prPlanComponentIds);
        try{
            system.debug('prPlanComponentIds---> '+prPlanComponentIds);
            Set<String> pricingPlanIds = new Set<String>();
            Set<String> pricingComponentIds = new Set<String>();
            Set<Id> projectId = new Set<Id>();
            Map<Id,Pricing_Plan_Components__c> prPlanComponentMap = new Map<Id,Pricing_Plan_Components__c>();
            Map<Id,List<Property__c>> propertyMap = new Map<Id,List<Property__c>>();
            Map<Id,List<Tower__c>> towerMap = new Map<Id,List<Tower__c>>();
            Set<String> prPlanCompProcessed = new Set<String>();
            for (Data_Sync__c dataSync:[Select Id,Event_Type__c,RecordId__c, Status__c from Data_Sync__c where Status__c ='Pending' and RecordId__c =:prPlanComponentIds]){
                pricingComponentIds.add(dataSync.RecordId__c);
            }
            if(pricingComponentIds != null){
                for(Pricing_Plan_Components__c prPlanComp:[
                    Select Id,Component_Type__c,Pricing_Plan__c,Price_Lumpsum__c,Pricing_Plan__r.Project__r.Project_SAP_Code__c,
                    Pricing_Plan__r.Project__r.Project_Type__c,Pricing_Plan__r.Valid_from__c,Pricing_Plan__r.Valid_to__c,
                    Pricing_Plan__r.Project__c
                    from Pricing_Plan_Components__c where Id =: pricingComponentIds
                ]){
                    if(prPlanComp != null){
                        prPlanComponentMap.put(prPlanComp.Id,prPlanComp);
                        pricingPlanIds.add(prPlanComp.Pricing_Plan__c);
                        projectId.add(prPlanComp.Pricing_Plan__r.Project__c);
                    }
                }
            }
            if(!pricingPlanIds.isEmpty()){
                for(Property__c prop:[Select Id,Name,Tower__c,Tower__r.Tower_SAP_Code__c,Property_Price_Slab__c,SAP_Code__c from Property__c where Property_Price_Slab__c IN:pricingPlanIds AND SAP_Code__c != null]){
                    if(prop != null){
                        if(!propertyMap.containsKey(prop.Property_Price_Slab__c)){
                            propertyMap.put(prop.Property_Price_Slab__c,new List<Property__c>{prop});
                        }
                        else{
                            propertyMap.get(prop.Property_Price_Slab__c).add(prop);
                        }
                    }
                }
            }
            if(!projectId.isEmpty()){
                for(Project__c proj:[Select Id,Name,(Select Id,Project__c,Tower_SAP_Code__c from Towers__r where Tower_SAP_Code__c!=null) from Project__c where Id IN:projectId]){
                    if(proj != null){
                        if(!towerMap.containsKey(proj.Id)){
                            List<Tower__c> towerToAddInMap = new List<Tower__c>();
                            towerToAddInMap.addAll(proj.Towers__r);
                            towerMap.put(proj.Id,towerToAddInMap);
                        }
                        else{
                            towerMap.get(proj.Id).addAll(proj.Towers__r);
                        }
                    }
                }
            }
            List<Pricing_Other_Charges__mdt> materialMetadata = [Select Id,Label,Material__c from Pricing_Other_Charges__mdt];
            Map<String,String> materialMap = new Map<String,String>();
            if(!materialMetadata.isEmpty()){
                for(Pricing_Other_Charges__mdt materialCode:materialMetadata){
                    materialMap.put(materialCode.Label,materialCode.Material__c);
                }
            }
            List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
            if(!prPlanComponentMap.isEmpty()){
                for(String prPlanCompId:prPlanComponentMap.keySet()){
                    prPlanCompProcessed.add(prPlanCompId);
                    JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
                    Pricing_Plan_Components__c prPlanComp = prPlanComponentMap.get(prPlanCompId);
                    if(prPlanComp.Component_Type__c == 'ZPR0' || prPlanComp.Component_Type__c == 'ZREG' || prPlanComp.Component_Type__c == 'ZSDT' || prPlanComp.Component_Type__c == 'ZCPR' || prPlanComp.Component_Type__c == 'ZDIS'){
                        if(propertyMap.containsKey(prPlanComp.Pricing_Plan__c)){
                            jsonGenerator1.writeStartObject();
                            jsonGenerator1.writeFieldName('ZSD_SFDC_PRICE_MASTER');
                            jsonGenerator1.writeStartObject();
                            jsonGenerator1.writeFieldName('PRICING_DATA');
                            jsonGenerator1.writeStartObject();
                            jsonGenerator1.writeFieldName('item');
                            jsonGenerator1.writeStartArray();
                            
                            for(Property__c prop:propertyMap.get(prPlanComp.Pricing_Plan__c)){
                                jsonGenerator1.writeStartObject();
                                jsonGenerator1.writeStringField('KSCHL',prPlanComp.Component_Type__c!=null?string.valueOF(prPlanComp.Component_Type__c):'');
                                jsonGenerator1.writeStringField('VKORG',prPlanComp.Pricing_Plan__r.Project__r.Project_SAP_Code__c!=null?string.valueOF(prPlanComp.Pricing_Plan__r.Project__r.Project_SAP_Code__c):'');
                                jsonGenerator1.writeStringField('VTWEG',prPlanComp.Pricing_Plan__r.Project__r.Project_Type__c!=null?string.valueOF(prPlanComp.Pricing_Plan__r.Project__r.Project_Type__c):'');
                                jsonGenerator1.writeStringField('WERKS',prop.Tower__r.Tower_SAP_Code__c!=null?prop.Tower__r.Tower_SAP_Code__c:'');
                                jsonGenerator1.writeStringField('MATNR',prop.SAP_Code__c!=null?prop.SAP_Code__c:'');
                                jsonGenerator1.writeStringField('KBETR',prPlanComp.Price_Lumpsum__c!=null?string.valueOF(prPlanComp.Price_Lumpsum__c):'');
                                if(prPlanComp.Pricing_Plan__r.Valid_from__c!=null){
                                    Date validDate = prPlanComp.Pricing_Plan__r.Valid_from__c;
                                    String formattedDay = (validDate.day() < 10) ? '0' + String.valueOf(validDate.day()) : String.valueOf(validDate.day());
                                    String formattedMonth = (validDate.month() < 10) ? '0' + String.valueOf(validDate.month()) : String.valueOf(validDate.month());
                                    String validFromDate = formattedDay + '.' + formattedMonth + '.' + validDate.year();
                                    jsonGenerator1.writeStringField('KDATU',validFromDate!=null?String.valueOf(validFromDate):'');
                                }
                                else{
                                    jsonGenerator1.writeStringField('KDATU','');
                                }
                                if(prPlanComp.Pricing_Plan__r.Valid_to__c!=null){
                                    Date validDate = prPlanComp.Pricing_Plan__r.Valid_to__c;
                                    String formattedDay = (validDate.day() < 10) ? '0' + String.valueOf(validDate.day()) : String.valueOf(validDate.day());
                                    String formattedMonth = (validDate.month() < 10) ? '0' + String.valueOf(validDate.month()) : String.valueOf(validDate.month());
                                    String validToDate = formattedDay + '.' + formattedMonth + '.' + validDate.year();
                                    jsonGenerator1.writeStringField('DATBI',validToDate!=null?String.valueOf(validToDate):'');
                                }
                                else{
                                    jsonGenerator1.writeStringField('DATBI','');
                                }
                                jsonGenerator1.writeStringField('SFDC_ID',prPlanComp.Id!=null?prPlanComp.Id:'');
                                jsonGenerator1.writeEndObject();
                            }
                            
                            jsonGenerator1.writeEndArray();
                            jsonGenerator1.writeEndObject();
                            jsonGenerator1.writeEndObject();
                            jsonGenerator1.writeEndObject();
                            jsonGeneratorList.add(jsonGenerator1);
                        }
                    }
                    else{
                        if(towerMap.containsKey(prPlanComp.Pricing_Plan__r.Project__c)){
                            jsonGenerator1.writeStartObject();
                            jsonGenerator1.writeFieldName('ZSD_SFDC_PRICE_MASTER');
                            jsonGenerator1.writeStartObject();
                            jsonGenerator1.writeFieldName('PRICING_DATA');
                            jsonGenerator1.writeStartObject();
                            jsonGenerator1.writeFieldName('item');
                            jsonGenerator1.writeStartArray();
                            
                            for(Tower__c towr:towerMap.get(prPlanComp.Pricing_Plan__r.Project__c)){
                                jsonGenerator1.writeStartObject();
                                jsonGenerator1.writeStringField('KSCHL',prPlanComp.Component_Type__c!=null?string.valueOF(prPlanComp.Component_Type__c):'');
                                jsonGenerator1.writeStringField('VKORG',prPlanComp.Pricing_Plan__r.Project__r.Project_SAP_Code__c!=null?string.valueOF(prPlanComp.Pricing_Plan__r.Project__r.Project_SAP_Code__c):'');
                                jsonGenerator1.writeStringField('VTWEG',prPlanComp.Pricing_Plan__r.Project__r.Project_Type__c!=null?string.valueOF(prPlanComp.Pricing_Plan__r.Project__r.Project_Type__c):'');
                                jsonGenerator1.writeStringField('WERKS',towr.Tower_SAP_Code__c!=null?towr.Tower_SAP_Code__c:'');
                                jsonGenerator1.writeStringField('MATNR',materialMap.get(prPlanComp.Component_Type__c)!=null?materialMap.get(prPlanComp.Component_Type__c):'');
                                jsonGenerator1.writeStringField('KBETR',prPlanComp.Price_Lumpsum__c!=null?string.valueOF(prPlanComp.Price_Lumpsum__c):'');
                                if(prPlanComp.Pricing_Plan__r.Valid_from__c!=null){
                                    Date validDate = prPlanComp.Pricing_Plan__r.Valid_from__c;
                                    String formattedDay = (validDate.day() < 10) ? '0' + String.valueOf(validDate.day()) : String.valueOf(validDate.day());
                                    String formattedMonth = (validDate.month() < 10) ? '0' + String.valueOf(validDate.month()) : String.valueOf(validDate.month());
                                    String validFromDate = formattedDay + '.' + formattedMonth + '.' + validDate.year();
                                    jsonGenerator1.writeStringField('KDATU',validFromDate!=null?String.valueOf(validFromDate):'');
                                }
                                else{
                                    jsonGenerator1.writeStringField('KDATU','');
                                }
                                if(prPlanComp.Pricing_Plan__r.Valid_to__c!=null){
                                    Date validDate = prPlanComp.Pricing_Plan__r.Valid_to__c;
                                    String formattedDay = (validDate.day() < 10) ? '0' + String.valueOf(validDate.day()) : String.valueOf(validDate.day());
                                    String formattedMonth = (validDate.month() < 10) ? '0' + String.valueOf(validDate.month()) : String.valueOf(validDate.month());
                                    String validToDate = formattedDay + '.' + formattedMonth + '.' + validDate.year();
                                    jsonGenerator1.writeStringField('DATBI',validToDate!=null?String.valueOf(validToDate):'');
                                }
                                else{
                                    jsonGenerator1.writeStringField('DATBI','');
                                }
                                jsonGenerator1.writeStringField('SFDC_ID',prPlanComp.Id!=null?prPlanComp.Id:'');
                                jsonGenerator1.writeEndObject();
                            }
                            
                            jsonGenerator1.writeEndArray();
                            jsonGenerator1.writeEndObject();
                            jsonGenerator1.writeEndObject();
                            jsonGenerator1.writeEndObject();
                            jsonGeneratorList.add(jsonGenerator1);
                        }                        
                    }
                }
            }
            if(jsonGeneratorList.size()>0){
                String jsonString = '';
                for (JSONGenerator generator : jsonGeneratorList) {
                    jsonString += generator.getAsString();
                }
                system.debug('jsonString--> '+jsonString);
                getSapCodes(jsonString,prPlanCompProcessed);
            } 
        }catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }
    
    public static String getSapCodes( String jsonString,Set<String>prPlanCompProcessed){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        request.setEndpoint('callout:SAP_PriceMaster');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic UzAwMjQzMDI0NDA6Umlja3lAOTk2OQ==');
        request.setBody(jsonString);
        request.setTimeout(120000);
        List<Pricing_Plan_Components__c> prPlanCompToUpdate = new List<Pricing_Plan_Components__c>();
        Set<String>propertyIds=new Set<String>();
        try {
            response = http.send(request);
            ResponseAPIClass.getResponse(response);
           List<Data_Sync__c> DSToUpdate = new List<Data_Sync__c>(); 
           Map<String,String> coAppIdNew=new Map<String,String>();
            if (response.getStatusCode() == 200 ||response.getStatusCode() == 201) {
                String responseBody = response.getBody();
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
               
                if(prPlanCompProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c where RecordId__c IN :prPlanCompProcessed AND Status__c = 'Pending']){
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
               if(prPlanCompProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c  where RecordId__c IN :prPlanCompProcessed AND Status__c = 'Pending']){
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
        public string prPlanComponentIds;
    }
}