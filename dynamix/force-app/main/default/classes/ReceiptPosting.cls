public with sharing class ReceiptPosting {
     @InvocableMethod
    public static void getReciptPosting(List<request> reqList){
        
        System.debug('reqList11'+reqList[0].transactionId);
        if(reqList!=null && reqList[0].transactionId !=null){
            System.debug('reqList[0].transactionId'+reqList[0].transactionId);
			exposeReceipt(String.valueOf(reqList[0].transactionId));  
            System.debug('called');
        }
        
    }
    @future(Callout=true)
    public static void exposeReceipt(String transactionId){
        try{
            System.debug('inside'); 
        }
        Catch (Exception e){
            System.debug('Exception'+e);
        }
        List<BANK_GL__mdt> bankGLMAP=[select id,Label,Unit_GL__c,GST_GL__c,Interest_GL__c,Other_Charges_GL__c,Security_and_Share_GL__c from BANK_GL__mdt];
        Map<String,BANK_GL__mdt > mapBankGL=new Map<String,BANK_GL__mdt>();
        if(bankGLMAP.size()>0){
            for(BANK_GL__mdt mdt :bankGLMAP){
                mapBankGL.put(mdt.Label.toLowerCase(),mdt);
            }
        }
        
       Set<String> TransProcessed = new Set<String>();
         Set<String> transactionIds = new Set<String>();
         for (Data_Sync__c dataSync:[Select Id,Event_Type__c,RecordId__c, Status__c from Data_Sync__c where Status__c ='In Progress' and RecordId__c =:transactionId]){
                transactionIds.add(dataSync.RecordId__c);
            }
       // transactionIds.add(transactionId);// for testing
          SYstem.debug('inside2'+transactionIds);
        List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
        Map<String,STring> booking_CoAppMap=new Map<String,STring>();
        Map<String,STring> booking_Name_CoAppMap=new Map<String,STring>();
        if(transactionIds.size()>0){
            Set<String> bookingIds=new Set<String>();
            for(Payment__c payment :[ Select id,Booking__r.Related_Suggested_Property__r.Unit__r.Floor__c, Booking__c,Paid_By__c,
                                     Booking__r.Related_Suggested_Property__r.Unit__r.SAP_Code__c, Amount__c, Payment_Status__c, Payment_Description__c,
                                     Payment_Date__c,Payment_Category__c, Cheque__c,Date__c, Payment_Mode__c, Payment_Type__c from 
                                     Payment__c where id =:transactionIds]){
                bookingIds.add(payment.Booking__c);
            }
            if(bookingIds.size()>0){
                for (Co_Applicant__c coApp:[ select id,Account__r.Name,Sap_Code__c, Booking__c from Co_Applicant__c  where Role__c ='Primary' and Booking__c IN :bookingIds]){
                    booking_CoAppMap.put(coApp.Booking__c,coApp.Sap_Code__c);
                    booking_Name_CoAppMap.put(coApp.Booking__c,coApp.Account__r!=null?coApp.Account__r.Name:'');
                }
            }
           
            JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
            jsonGenerator1.writeStartObject();
            jsonGenerator1.writeFieldName('ZFI_SFDC_REC_POS');
            
            jsonGenerator1.writeStartObject(); //RECPOS_DATA
            jsonGenerator1.writeFieldName('RECPOS_DATA');
            jsonGenerator1.writeStartObject();
            jsonGenerator1.writeFieldName('item');
                            jsonGenerator1.writeStartArray();
            for(Payment__c payment :[Select id,Booking__r.Project_Name__r.Name,Branch_Name__c,Booking__r.Tower_Name__r.Tower_SAP_Code__c,
                                     Booking__r.Project_Name__r.Project_SAP_Code__c,BankName__r.Account_Number__c, BankName__r.Name,
                                     Booking__r.Related_Suggested_Property__r.Unit__r.Floor__c, Booking__c,Paid_By__c, Payment_Description__c,
                                     Booking__r.Related_Suggested_Property__r.Unit__r.SAP_Code__c, Amount__c, Payment_Status__c,
                                     Cheque_Transaction_Number__c, Payment_Date__c,Payment_Category__c, Cheque__c,Date__c, Payment_Mode__c, 
                                     Payment_Type__c from Payment__c where id =:transactionIds]){
                TransProcessed.add(payment.id);
                BANK_GL__mdt mdt = new BANK_GL__mdt();
                if(payment.Booking__r.Project_Name__r.Name != 'Luma Tower A' && payment.Booking__r.Project_Name__r.Name != 'Luma Tower B' && payment.Booking__r.Project_Name__r.Name != 'Luma Tower C'){
                    mdt= mapBankGL.get(payment.Booking__r!=null && payment.Booking__r.Project_Name__r!=null && payment.Booking__r.Project_Name__r.Name !=null ?payment.Booking__r.Project_Name__r.Name.toLowerCase():'');
                }
                else{
                    system.debug('In Else --> '+ payment.Booking__r.Project_Name__r.Name);
                    if(payment.Payment_Description__c.contains('ICICI')){
                        String SearchKey = payment.Booking__r.Project_Name__r.Name.toLowerCase() +'-'+'ICICI';
                        system.debug('SearchKey--> '+SearchKey);
                        mdt= mapBankGL.get(payment.Booking__r!=null && payment.Booking__r.Project_Name__r!=null && payment.Booking__r.Project_Name__r.Name !=null ?SearchKey.toLowerCase():'');
                    }
                    else if(payment.Payment_Description__c.contains('HDFC')){
                        String SearchKey = payment.Booking__r.Project_Name__r.Name.toLowerCase() +'-'+'HDFC';
                        system.debug('SearchKey--> '+SearchKey);
                        mdt= mapBankGL.get(payment.Booking__r!=null && payment.Booking__r.Project_Name__r!=null && payment.Booking__r.Project_Name__r.Name !=null ?SearchKey.toLowerCase():'');
                    }
                }
                jsonGenerator1.writeStartObject();
                jsonGenerator1.writeStringField('ZPLANT',payment.Booking__r!=null && payment.Booking__r.Tower_Name__r!=null && payment.Booking__r.Tower_Name__r.Tower_SAP_Code__c !=null ? payment.Booking__r.Tower_Name__r.Tower_SAP_Code__c:''); //tower sap 
                jsonGenerator1.writeStringField('ZSFDC_ID',payment.id);
                //jsonGenerator1.writeStringField('ZCOMPANY_CODE',payment.Booking__r!=null && payment.Booking__r.Project_Name__r!=null && payment.Booking__r.Project_Name__r.Builder_Organization__r!=null && payment.Booking__r.Project_Name__r.Builder_Organization__r.Company_Code__c!=null ? payment.Booking__r.Project_Name__r.Builder_Organization__r.Company_Code__c:''); //  tower 4 digit Sap company code
                jsonGenerator1.writeStringField('ZCOMPANY_CODE',payment.Booking__r!=null && payment.Booking__r.Project_Name__r!=null && payment.Booking__r.Project_Name__r.Project_SAP_Code__c!=null ? payment.Booking__r.Project_Name__r.Project_SAP_Code__c:'');
                jsonGenerator1.writeStringField('ZCUSTOMER_CODE',booking_CoAppMap.get(payment.Booking__c)!=null ? booking_CoAppMap.get(payment.Booking__c) :'');
                jsonGenerator1.writeStringField('ZNAME',booking_Name_CoAppMap.get(payment.Booking__c)!=null ? booking_Name_CoAppMap.get(payment.Booking__c) :''); //customer name booking_Name_CoAppMap
                jsonGenerator1.writeStringField('ZPAYMENT_CATEGORY',payment.Payment_Category__c!=null ?payment.Payment_Category__c:'');
                jsonGenerator1.writeStringField('ZPAYMENT_MODE',payment.Payment_Type__c!=null ? payment.Payment_Type__c :'');
                jsonGenerator1.writeStringField('ZAMOUNT',payment.Amount__c !=null ?String.valueOf(payment.Amount__c):''); // String.valueOf(payment.Date__c).length==1?'0'+String.valueOf(payment.Date__c):String.valueOf(payment.Date__c)
               //STring test= String.valueOf(payment.Payment_Date__c.month()).length()==1?'0'+String.valueOf(payment.Payment_Date__c.month()):String.valueOf(payment.Payment_Date__c.month());
              //  String test2=payment.Payment_Date__c!=null?(String.valueOf(payment.Payment_Date__c.day()).length()==1?'0'+String.valueOf(payment.Payment_Date__c.day()):String.valueOf(payment.Payment_Date__c.day()))+'.'+(String.valueOf(payment.Payment_Date__c.month()).length()==1?'0'+String.valueOf(payment.Payment_Date__c.month()):String.valueOf(payment.Payment_Date__c.month()))+'.'+(payment.Payment_Date__c.year()) :'';
                
                
                jsonGenerator1.writeStringField('ZCHEQUE_DATE',payment.Date__c!=null?(String.valueOf(payment.Date__c.day()).length()==1?'0'+String.valueOf(payment.Date__c.day()):String.valueOf(payment.Date__c.day()))+'.'+(String.valueOf(payment.Date__c.month()).length()==1?'0'+String.valueOf(payment.Date__c.month()):String.valueOf(payment.Date__c.month()))+'.'+(payment.Date__c.year()) :'');
                //payment.Payment_Date__c.day()+'.'+payment.Payment_Date__c.month()+'.'+payment.Payment_Date__c.year()
                jsonGenerator1.writeStringField('ZUTR',payment.Cheque_Transaction_Number__c!=null ?payment.Cheque_Transaction_Number__c:''); //challan number
                
                jsonGenerator1.writeStringField('ZPAYMENT_DATE',payment.Payment_Date__c!=null?(String.valueOf(payment.Payment_Date__c.day()).length()==1?'0'+String.valueOf(payment.Payment_Date__c.day()):String.valueOf(payment.Payment_Date__c.day()))+'.'+(String.valueOf(payment.Payment_Date__c.month()).length()==1?'0'+String.valueOf(payment.Payment_Date__c.month()):String.valueOf(payment.Payment_Date__c.month()))+'.'+(payment.Payment_Date__c.year()) :'');
                jsonGenerator1.writeStringField('ZBANK_NAME',payment.BankName__r!=null && payment.BankName__r.Name !=null ? payment.BankName__r.Name:''); //HDFC //payment.BankName__r!=null  && payment.BankName__r.Account_Number__c !=null ? payment.BankName__r.Account_Number__c:''
                jsonGenerator1.writeStringField('ZBANK_BRANCH',payment.Branch_Name__c!=null?payment.Branch_Name__c :'');//
                STring GLCode='';
                if(payment.Payment_Category__c !=null && mdt !=null){
                    if(payment.Payment_Category__c=='Unit Cost'){
                        GLCode=mdt.Unit_GL__c;
                    }
                    else if(payment.Payment_Category__c=='GST' || payment.Payment_Category__c=='Possession/Handover(Other) Charge GST' ||
                            payment.Payment_Category__c=='Security and Share Money GST'){
                        GLCode=mdt.GST_GL__c;
                    }
                    else if(payment.Payment_Category__c=='Interest'){
                       GLCode=mdt.Interest_GL__c; 
                    }
                    else if(payment.Payment_Category__c == 'Possession/Handover(Other) Charge'){
                        GLCode=mdt.Other_Charges_GL__c;
                    }
                    else if(payment.Payment_Category__c == 'Security and Share Money'){
                        GLCode=mdt.Security_and_Share_GL__c;
                    }
                }
                jsonGenerator1.writeStringField('ZBANK_ZL_ACC',String.isNotBlank(GLCode)?GLCode:''); //GL number
                jsonGenerator1.writeStringField('ZPAID_BY',payment.Paid_By__c!=null ? payment.Paid_By__c :'');
                jsonGenerator1.writeStringField('ZUNIT_NUM',payment.Booking__r!=null && payment.Booking__r.Related_Suggested_Property__r!=null && payment.Booking__r.Related_Suggested_Property__r.Unit__r!=null && payment.Booking__r.Related_Suggested_Property__r.Unit__r.SAP_Code__c !=null ? payment.Booking__r.Related_Suggested_Property__r.Unit__r.SAP_Code__c:'');
                jsonGenerator1.writeStringField('ZFLOOR_NUM',payment.Booking__r!=null && payment.Booking__r.Related_Suggested_Property__r!=null && payment.Booking__r.Related_Suggested_Property__r.Unit__r!=null && payment.Booking__r.Related_Suggested_Property__r.Unit__r.Floor__c !=null ? payment.Booking__r.Related_Suggested_Property__r.Unit__r.Floor__c:'');
                
                jsonGenerator1.writeEndObject();
            }
              jsonGenerator1.writeEndArray();
            jsonGenerator1.writeEndObject();
            jsonGenerator1.writeEndObject();
            jsonGenerator1.writeEndObject();
            jsonGeneratorList.add(jsonGenerator1);
        }
        if(jsonGeneratorList.size()>0){
                String jsonString = '';
                for (JSONGenerator generator : jsonGeneratorList) {
                    jsonString += generator.getAsString();
                }
                system.debug('jsonString--> '+jsonString);
                getSapCodes(jsonString,TransProcessed);
            }
        
    }
    public static String getSapCodes( String jsonString,Set<String>TransProcessed){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        request.setEndpoint('callout:Sap_ReceiptPosting');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic UzAwMjQ1MjI3MDM6Um9kcmlAMjAyMw==');
        request.setBody(jsonString);
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
               
                if(TransProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c where RecordId__c IN :TransProcessed AND Status__c = 'In Progress']){
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
               if(TransProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c  where RecordId__c IN :TransProcessed AND Status__c = 'In Progress']){
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
        public string transactionId;
    }

}