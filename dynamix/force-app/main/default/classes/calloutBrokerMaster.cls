/*
* Author : Nachiketa Khera
* Created Date : 29th March 2024
* Description : Channel Partner/Broker Api for SAP integration on Insertion/Updation.
* Last Modified Date : 10th April 2024
*/
public without sharing class calloutBrokerMaster {
    @InvocableMethod
    public static void getChannelPartner(List<request> reqList){
        System.debug('reqList'+reqList);
        if(reqList != null){
            for(request req :reqList){
                exposeChannelPartnerToSAP(req.accountId,req.deletionFlag);
            }
        }
    }
    @future(Callout=true)
    public static void exposeChannelPartnerToSAP(String accountId,String deletionFlag){
        try{
            Set<String> accountIdsFromDataSync = new Set<String>();
            String projectCode = '';
            List<Data_Sync__c> dsToUpdate = new List<Data_Sync__c>();
            Map<Id,Account> channelPartnerMap = new Map<Id,Account>();
            Set<String> channelPartnerProcessed = new Set<String>();
            List<Data_Sync__c> dsList = [Select Id,Event_Type__c,RecordId__c, Status__c from Data_Sync__c where Status__c ='Pending' and RecordId__c =:accountId];
            system.debug('dsList--> '+dsList.size());
            if(!dsList.isEmpty()){
                for (Data_Sync__c dataSync:dsList){
                    accountIdsFromDataSync.add(dataSync.RecordId__c);
                }
            }
            if(accountIdsFromDataSync != null){
                for(Account cpAcc:[Select Id,Name,CP_Firm_Name__c,CP_Name__c,Email__c,Phone,Firm_Type__c,Partner_Id__c,Aadhar_No__c,
                                   PAN_No__c,GSTIN_No__c,RERA_Number__c,Rera_Expiry_Date__c,Rera_Certificate_Upload__c,BillingStreet,
                                   BillingCity,BillingState,BillingCountry,BillingPostalCode,CP_Empanelment_Stages__c,
                                   (Select Id,Project__c,Project__r.Project_SAP_Code__c from Channel_Partner_Projects__r ORDER BY CreatedDate DESC limit 1)
                                   from Account where Id=:accountIdsFromDataSync ALL ROWS]){
                    if(cpAcc != null){
                        channelPartnerMap.put(cpAcc.Id,cpAcc);
                    }
                    if(!cpAcc.Channel_Partner_Projects__r.isEmpty()){
                            projectCode = cpAcc.Channel_Partner_Projects__r[0].Project__r.Project_SAP_Code__c;
                    }
                }
            }
            List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
            if(!channelPartnerMap.isEmpty()){
                for(String cpAccId:channelPartnerMap.keySet()){
                    channelPartnerProcessed.add(cpAccId);
                    JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
                    Account acc = channelPartnerMap.get(cpAccId);
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('ZFI015_BROKER_MASTER_INTERFACE');
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('BROKER_DETAIL');
                    jsonGenerator1.writeStartObject();
                    	jsonGenerator1.writeStringField('SFDC_ID',acc.Id);
                    	jsonGenerator1.writeStringField('LIFNR',acc.Partner_Id__c!=null?acc.Partner_Id__c:'');
                    	jsonGenerator1.writeStringField('TITLE',acc.CP_Name__c!=null?acc.CP_Name__c.toUpperCase():'');
                    	jsonGenerator1.writeStringField('NAME1',acc.Name!=null?acc.Name.toUpperCase():'');
                    	jsonGenerator1.writeStringField('NAME2','');
                    	jsonGenerator1.writeStringField('NAME3','');
                    	jsonGenerator1.writeStringField('NAME4','');
                    	jsonGenerator1.writeStringField('SORT1',acc.CP_Name__c!=null?acc.CP_Name__c.toUpperCase():'');
                    	jsonGenerator1.writeStringField('SORT2',acc.CP_Empanelment_Stages__c!=null?acc.CP_Empanelment_Stages__c.toUpperCase():'');
                    	jsonGenerator1.writeStringField('STREET',acc.BillingStreet!=null?acc.BillingStreet.toUpperCase():'NA');
                    	jsonGenerator1.writeStringField('STR_SUPPL1','NA');
                    	jsonGenerator1.writeStringField('POST_CODE',acc.BillingPostalCode!=null?acc.BillingPostalCode:'000000');
                    	jsonGenerator1.writeStringField('CITY',acc.BillingCity!=null?acc.BillingCity.toUpperCase():'NA');
                    	jsonGenerator1.writeStringField('COUNTRY',acc.BillingCountry!=null?acc.BillingCountry.toUpperCase():'INDIA');
                    	jsonGenerator1.writeStringField('REGION',acc.BillingState!=null?acc.BillingState.toUpperCase():'MAHARASHTRA');
                    	jsonGenerator1.writeStringField('TEL_NUMBER','');
                    	jsonGenerator1.writeStringField('MOBILE_NO',acc.Phone!=null?acc.Phone:'');
                    	jsonGenerator1.writeStringField('SMTP_ADDR',acc.Email__c!=null?acc.Email__c:'');
                    	jsonGenerator1.writeStringField('FAX_NUMBER','');
                    	jsonGenerator1.writeStringField('DELETION_FLAG',deletionFlag!=null?deletionFlag:'');
                    	jsonGenerator1.writeStringField('BUKRS',projectCode!=null?projectCode:'');
                    	jsonGenerator1.writeStringField('PAY_METHOD','');
                    	jsonGenerator1.writeStringField('HOUSE_BANK','');
                    	jsonGenerator1.writeStringField('TAX_NUMBER',acc.GSTIN_No__c!=null?acc.GSTIN_No__c.toUpperCase():'');
                    	jsonGenerator1.writeStringField('PANNO',acc.PAN_No__c!=null?acc.PAN_No__c.toUpperCase():'');
                    	jsonGenerator1.writeStringField('RERANO',acc.RERA_Number__c!=null?acc.RERA_Number__c.toUpperCase():'');
                        if(acc.Rera_Expiry_Date__c!=null){
                            Date reraExpiry = acc.Rera_Expiry_Date__c;
                            String formattedDay = (reraExpiry.day() < 10) ? '0' + String.valueOf(reraExpiry.day()) : String.valueOf(reraExpiry.day());
                            String formattedMonth = (reraExpiry.month() < 10) ? '0' + String.valueOf(reraExpiry.month()) : String.valueOf(reraExpiry.month());
                            String reraExpiryDate = formattedDay + '.' + formattedMonth + '.' + reraExpiry.year();
                            jsonGenerator1.writeStringField('RERA_EXP_DT',reraExpiryDate!=null?reraExpiryDate:'');
                        }else{
                            jsonGenerator1.writeStringField('RERA_EXP_DT','');
                        }
                    	jsonGenerator1.writeStringField('BANK_NO','');
                    	jsonGenerator1.writeStringField('BANK_NAME','');
                    	jsonGenerator1.writeStringField('BANK_ACC','');
                    	jsonGenerator1.writeStringField('CP_FIRM',acc.Firm_Type__c!=null?acc.Firm_Type__c.toUpperCase():'');
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
                getSapCodes(jsonString,channelPartnerProcessed);
            }
        }
        catch(Exception e){
            System.debug('Exception: ' + e.getMessage());
            System.debug('Exception:Number>> ' + e.getLineNumber());
        }
    }
    public static String getSapCodes( String jsonString,Set<String>channelPartnerProcessed){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        request.setEndpoint('callout:SAP_BrokerMaster');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic UzAwMjQzMDI0NDA6Umlja3lAOTk2OQ==');
        request.setBody(jsonString);
        try {
            response = http.send(request);
            ResponseAPIClass.getResponse(response);
            List<Data_Sync__c> DSToUpdate = new List<Data_Sync__c>();
            if (response.getStatusCode() == 200 ||response.getStatusCode() == 201) {
                String responseBody = response.getBody();
                
                if(channelPartnerProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c where RecordId__c IN :channelPartnerProcessed AND Status__c = 'Pending']){
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
                if(channelPartnerProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c  where RecordId__c IN :channelPartnerProcessed AND Status__c = 'Pending']){
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
        public string accountId;
        @InvocableVariable
        public string deletionFlag;
    }
}