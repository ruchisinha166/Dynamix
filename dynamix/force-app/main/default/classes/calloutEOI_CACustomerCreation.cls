/*
* Author : Nachiketa Khera
* Created Date : 24th April 2024
* Description : Syncing of EOI/CA Customer to SAP when the threshold payment amount is paid.
* Last Modified Date : 7th May 2024
*/
public class calloutEOI_CACustomerCreation {
    @InvocableMethod
    public static void getEOICACustomer(List<request> reqList){
        System.debug('reqList'+reqList);
        if(reqList != null){
            for(request req :reqList){
                exposeEOICACustomerToSAP(req.accountId,req.opportunityId,req.cancellationFlag);
            }
        }
    }
    @future(Callout=true)
    public static void exposeEOICACustomerToSAP(String accountId,String opportunityId,String cancellationFlag){
        try{
            Set<String> opportunityIdsFromDataSync = new Set<String>();
            List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
            Set<String> EOI_CA_CustomerProcessed = new Set<String>();
            for(Data_Sync__c ds:[Select Id,Event_Type__c,RecordId__c, Status__c from Data_Sync__c where Status__c ='Pending' and RecordId__c =:opportunityId AND (Event_Type__c ='EOI/CA Customer' OR Event_Type__c ='EOI/CA Cancellation') limit 1]){
                if(ds!=null){
                    opportunityIdsFromDataSync.add(ds.RecordId__c);
                }
            }
            if(!opportunityIdsFromDataSync.isEmpty()){
                Opportunity opp = [Select Id,Account.FirstName,Account.LastName,Account.Salutation,Account.MiddleName,Account.PersonMailingAddress,
                                   Account.PersonMailingStreet,Account.PersonMailingCity,Account.PersonMailingCountry,Account.PersonMailingState,
                                   Account.PersonMailingPostalCode,Account.BillingCountry,Account.BillingState,Account.BillingPostalCode,
                                   Account.BillingCity,Account.Phone,Account.PersonMobilePhone,Account.PersonEmail,Account.Gender__pc,
                                   Account.Nationality__c,Account.Martial_Status__pc,Account.Occupation__pc,Account.PersonBirthdate,
                                   Account.PAN_No__pc,Account.Aadhar_No__pc,Account.Passport__c,Account.OCI_PIO_Card__c,
                                   Account.Date_of_Board_Resolution_Authority_Lett__c,Account.PAN_Details__c,EOI_CA_Customer_Code__c,
                                   Account.NRI__c,Account.Industry,Project__r.Project_SAP_Code__c,Project__r.Distribution_Channel__c
                                   from Opportunity where Id=:opportunityId];
                if(opp!=null){
                    EOI_CA_CustomerProcessed.add(opportunityId);
                    JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('ZSD016_EOI_CUSTOMER');
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('CUSTOMER_HEADER');
                    jsonGenerator1.writeStartObject();
                    	jsonGenerator1.writeStringField('SFDC_ID',opportunityId);
                        jsonGenerator1.writeStringField('KUNNR', opp.EOI_CA_Customer_Code__c!=null?opp.EOI_CA_Customer_Code__c:'');
                        jsonGenerator1.writeStringField('TITLE', opp.Account.Salutation!=null?opp.Account.Salutation:'');
                        jsonGenerator1.writeStringField('NAME_FIRST', opp.Account.FirstName!=null?opp.Account.FirstName:'');
                        jsonGenerator1.writeStringField('NAME_LAST', opp.Account.LastName!=null?opp.Account.LastName:'');
                        jsonGenerator1.writeStringField('SORT1', '');
                        jsonGenerator1.writeStringField('SORT2', '');
                        jsonGenerator1.writeStringField('HOUSE_NO', '');
                        jsonGenerator1.writeStringField('STREET', opp.Account.PersonMailingStreet!=null?opp.Account.PersonMailingStreet:'');
                        jsonGenerator1.writeStringField('STR_SUPPL1', '');
                        jsonGenerator1.writeStringField('STR_SUPPL2', '');
                        jsonGenerator1.writeStringField('STR_SUPPL3', '');
                        jsonGenerator1.writeStringField('POST_CODE', opp.Account.PersonMailingPostalCode!=null?string.valueOf(opp.Account.PersonMailingPostalCode):'');
                        jsonGenerator1.writeStringField('CITY', opp.Account.PersonMailingCity!=null?opp.Account.PersonMailingCity:'');
                        jsonGenerator1.writeStringField('COUNTRY', opp.Account.PersonMailingCountry!=null?opp.Account.PersonMailingCountry:'');
                        jsonGenerator1.writeStringField('REGION', opp.Account.PersonMailingState!=null?opp.Account.PersonMailingState:'');
                        jsonGenerator1.writeStringField('TEL_NUMBER', opp.Account.Phone!=null?string.valueOf(opp.Account.Phone):'');
                        jsonGenerator1.writeStringField('MOBILE_NO', opp.Account.PersonMobilePhone!=null?string.valueOf(opp.Account.PersonMobilePhone):'');
                        jsonGenerator1.writeStringField('SMTP_ADDR', opp.Account.PersonEmail!=null?opp.Account.PersonEmail:'');
                        jsonGenerator1.writeStringField('XSEXU', opp.Account.Gender__pc!=null?opp.Account.Gender__pc:'');
                        jsonGenerator1.writeStringField('NATIO', opp.Account.Nationality__c!=null?opp.Account.Nationality__c:'');
                        jsonGenerator1.writeStringField('MARST', opp.Account.Martial_Status__pc!=null?opp.Account.Martial_Status__pc:'');
                        if(opp.Account.PersonBirthdate !=null){
                            Date birthDate = opp.Account.PersonBirthdate;
                            String formattedDay = (birthDate.day() < 10) ? '0' + String.valueOf(birthDate.day()) : String.valueOf(birthDate.day());
                            String formattedMonth = (birthDate.month() < 10) ? '0' + String.valueOf(birthDate.month()) : String.valueOf(birthDate.month());
                            String formattedDate = formattedDay + '.' + formattedMonth + '.' + birthDate.year();
                            jsonGenerator1.writeStringField('BIRTHDT',formattedDate != null ?formattedDate:'');
                        }
                        else{
                            jsonGenerator1.writeStringField('BIRTHDT','');
                        }
                        jsonGenerator1.writeStringField('BIRTHPL', '');
                        jsonGenerator1.writeStringField('EMPLO', '');
                        jsonGenerator1.writeStringField('KUKLA', opp.Account.Occupation__pc!=null?opp.Account.Occupation__pc:'');
                        jsonGenerator1.writeStringField('BUKRS', opp.Project__r.Project_SAP_Code__c!=null?opp.Project__r.Project_SAP_Code__c:'');
                        jsonGenerator1.writeStringField('ZTERM', 'Z015');
                        jsonGenerator1.writeStringField('CST_NO', '');
                        if(opp.Account.Nationality__c == 'Non-Resident Indian'){
                            jsonGenerator1.writeStringField('PANNO',opp.Account.PAN_Details__c !=null?opp.Account.PAN_Details__c:'');
                        }
                        else{
                            jsonGenerator1.writeStringField('PANNO',opp.Account.PAN_No__pc !=null?opp.Account.PAN_No__pc:'');
                        }
                        jsonGenerator1.writeStringField('AADHAR', opp.Account.Aadhar_No__pc!=null?opp.Account.Aadhar_No__pc:'');
                        jsonGenerator1.writeStringField('ZZNRI', '');
                        jsonGenerator1.writeStringField('VKORG', opp.Project__r.Project_SAP_Code__c!=null?opp.Project__r.Project_SAP_Code__c:'');
                        jsonGenerator1.writeStringField('VTWEG', opp.Project__r.Distribution_Channel__c!=null?opp.Project__r.Distribution_Channel__c:'');
                        jsonGenerator1.writeStringField('VKBUR', '');
                        jsonGenerator1.writeStringField('VKGRP', '');
                        jsonGenerator1.writeStringField('AUFSD', String.isNotBlank(cancellationFlag)?cancellationFlag:'');//Send 01 if EOI/CA is Cancelled.
                        jsonGenerator1.writeStringField('SALE_EMP', '');
                    
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
                getSapCodes(jsonString,EOI_CA_CustomerProcessed);
            }
        }
        catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            System.debug('Exception:Number>> ' + e.getLineNumber());
        }
    }
    public static String getSapCodes( String jsonString,Set<String>EOI_CA_CustomerProcessed){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        request.setEndpoint('callout:SAP_EOI_CA_Customer');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic UzAwMjQzMDI0NDA6Umlja3lAOTk2OQ==');
        request.setBody(jsonString);
        try{
            response = http.send(request);
            ResponseAPIClass.getResponse(response);
            List<Data_Sync__c> DSToUpdate = new List<Data_Sync__c>();
            if (response.getStatusCode() == 200 ||response.getStatusCode() == 201) {
                String responseBody = response.getBody();
                if(EOI_CA_CustomerProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c where RecordId__c IN :EOI_CA_CustomerProcessed AND Status__c = 'Pending']){
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
                if(EOI_CA_CustomerProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c  where RecordId__c IN :EOI_CA_CustomerProcessed AND Status__c = 'Pending']){
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
        }
        catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            System.debug('Exception:Number>> ' + e.getLineNumber());
        }
        return null;
    }
    public class request{
        @InvocableVariable (required=true)
        public string accountId;
        @InvocableVariable (required=true)
        public string opportunityId;
        @InvocableVariable
        public string cancellationFlag;
    }
}