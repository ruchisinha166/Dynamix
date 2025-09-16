/*
* Author : Nachiketa Khera
* Created Date : 26th April 2024
* Description : Syncing of EOI/CA Payment to SAP.
* Last Modified Date : 26th April 2024
*/
public class calloutEOI_CAPayment {
    @InvocableMethod
    public static void getEOI_CA_Payment(List<request> reqList){
        System.debug('reqList'+reqList);
        if(reqList != null){
            for(request req :reqList){
                exposeEOI_CA_PaymentToSAP(req.paymentId);
            }
        }
    }
    @future(Callout=true)
    public static void exposeEOI_CA_PaymentToSAP(String paymentId){
        try{
            Set<String> paymentIdsFromDataSync = new Set<String>();
            List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
            Set<String> EOI_CA_PaymentProcessed = new Set<String>();
            List<BANK_GL__mdt> bankGLMAP=[select id,Label,Unit_GL__c,GST_GL__c,Interest_GL__c,Other_Charges_GL__c,Security_and_Share_GL__c from BANK_GL__mdt];
            Map<String,BANK_GL__mdt > mapBankGL=new Map<String,BANK_GL__mdt>();
            if(bankGLMAP.size()>0){
                for(BANK_GL__mdt mdt :bankGLMAP){
                    mapBankGL.put(mdt.Label.toLowerCase(),mdt);
                }
            }
            for(Data_Sync__c ds:[Select Id,Event_Type__c,RecordId__c, Status__c from Data_Sync__c where Status__c ='Pending' and RecordId__c =:paymentId AND Event_Type__c ='EOI/CA Payment' limit 1]){
                if(ds!=null){
                    paymentIdsFromDataSync.add(ds.RecordId__c);
                }
            }
            if(paymentIdsFromDataSync!=null){
                for(EOI_CA_Payment__c payment :[Select id,Branch_Name__c,Bank_Name1__r.Account_Number__c,Bank_Name1__r.Name,Payment_Category__c,
                                         Paid_By__c,Amount__c, Payment_Status__c,Cheque_Transaction_Number__c, Payment_Date__c,Cheque__c,
                                         Opportunity__r.EOI_CA_Customer_Code__c,Date__c,Payment_Mode__c,Payment_Type__c,EOI_CA_Payment__c,
                                         Opportunity__r.Project__r.Project_SAP_Code__c,Opportunity__r.Account.Name,Opportunity__r.Project__r.Name
                                         from EOI_CA_Payment__c where id =:paymentId]){
                                             
                    JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('ZFI_SFDC_REC_POS');
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('RECPOS_DATA');
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('item');
                    jsonGenerator1.writeStartArray();
                    	EOI_CA_PaymentProcessed.add(payment.Id);
                        BANK_GL__mdt mdt= mapBankGL.get(payment.Opportunity__r!=null && payment.Opportunity__r.Project__r!=null && payment.Opportunity__r.Project__r.Name !=null ?payment.Opportunity__r.Project__r.Name.toLowerCase():'');
                        jsonGenerator1.writeStartObject();
                        jsonGenerator1.writeStringField('ZPLANT','');
                        jsonGenerator1.writeStringField('ZSFDC_ID',payment.id);
                        jsonGenerator1.writeStringField('ZCOMPANY_CODE',payment.Opportunity__r.Project__r.Project_SAP_Code__c!=null?payment.Opportunity__r.Project__r.Project_SAP_Code__c:'');
                        jsonGenerator1.writeStringField('ZCUSTOMER_CODE', payment.Opportunity__r.EOI_CA_Customer_Code__c!=null?payment.Opportunity__r.EOI_CA_Customer_Code__c:'');
                        jsonGenerator1.writeStringField('ZNAME', payment.Opportunity__r.Account.Name!=null?payment.Opportunity__r.Account.Name:'');
                        jsonGenerator1.writeStringField('ZPAYMENT_CATEGORY',payment.EOI_CA_Payment__c!=null ?payment.EOI_CA_Payment__c:'');
                        jsonGenerator1.writeStringField('ZPAYMENT_MODE',payment.Payment_Type__c!=null ? payment.Payment_Type__c :'');
                        jsonGenerator1.writeStringField('ZAMOUNT',payment.Amount__c !=null ?String.valueOf(payment.Amount__c):'');
                        jsonGenerator1.writeStringField('ZCHEQUE_DATE',payment.Date__c!=null?(String.valueOf(payment.Date__c.day()).length()==1?'0'+String.valueOf(payment.Date__c.day()):String.valueOf(payment.Date__c.day()))+'.'+(String.valueOf(payment.Date__c.month()).length()==1?'0'+String.valueOf(payment.Date__c.month()):String.valueOf(payment.Date__c.month()))+'.'+(payment.Date__c.year()) :'');
                        jsonGenerator1.writeStringField('ZUTR',payment.Cheque_Transaction_Number__c!=null ?payment.Cheque_Transaction_Number__c:'');
                        jsonGenerator1.writeStringField('ZPAYMENT_DATE',payment.Payment_Date__c!=null?(String.valueOf(payment.Payment_Date__c.day()).length()==1?'0'+String.valueOf(payment.Payment_Date__c.day()):String.valueOf(payment.Payment_Date__c.day()))+'.'+(String.valueOf(payment.Payment_Date__c.month()).length()==1?'0'+String.valueOf(payment.Payment_Date__c.month()):String.valueOf(payment.Payment_Date__c.month()))+'.'+(payment.Payment_Date__c.year()) :'');
                        jsonGenerator1.writeStringField('ZBANK_NAME',payment.Bank_Name1__r!=null && payment.Bank_Name1__r.Name !=null ? payment.Bank_Name1__r.Name:'');
                        jsonGenerator1.writeStringField('ZBANK_BRANCH',payment.Branch_Name__c!=null?payment.Branch_Name__c :'');
                        STring GLCode='';
                        if(payment.Payment_Category__c !=null && mdt !=null){
                            if(payment.Payment_Category__c=='Unit Cost'){
                                GLCode=mdt.Unit_GL__c;
                            }
                        }
                        jsonGenerator1.writeStringField('ZBANK_ZL_ACC',String.isNotBlank(GLCode)?GLCode:''); //GL number
                        jsonGenerator1.writeStringField('ZPAID_BY',payment.Paid_By__c!=null ? payment.Paid_By__c :'');
                        jsonGenerator1.writeStringField('ZUNIT_NUM','');
                        jsonGenerator1.writeStringField('ZFLOOR_NUM','');
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
                getSapCodes(jsonString,EOI_CA_PaymentProcessed);
            }
        }
        catch(Exception e){
            System.debug('Exception: ' + e.getMessage());
            System.debug('Exception:Number>> ' + e.getLineNumber());
        }
    }
    public static String getSapCodes( String jsonString,Set<String>EOI_CA_PaymentProcessed){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        request.setEndpoint('callout:Sap_ReceiptPosting');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic UzAwMjQ1MjI3MDM6Um9kcmlAMjAyMw==');
        request.setBody(jsonString);
        Set<String>propertyIds=new Set<String>();
        try {
            response = http.send(request);
            List<Data_Sync__c> DSToUpdate = new List<Data_Sync__c>();
            if (response.getStatusCode() == 200 ||response.getStatusCode() == 201) {
                String responseBody = response.getBody();
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                
                if(EOI_CA_PaymentProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c where RecordId__c IN :EOI_CA_PaymentProcessed AND Status__c = 'Pending']){
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
                if(EOI_CA_PaymentProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c  where RecordId__c IN :EOI_CA_PaymentProcessed AND Status__c = 'Pending']){
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
        public string paymentId;
    }
}