/*
* Author : Nachiketa Khera
* Created Date : 15th May 2024
* Description : Rest API to capture Credit Note Payment details from SAP and store the information at Booking.
* Last Modified Date : 17th May 2024
*/
@RestResource(urlMapping='/CreditNote/*')
global class CreditNoteRestAPI {
    @HttpPost
    global static void getCreditNoteDetails(){
        RestResponse res = RestContext.response;
        try{
            List<Credit_Note__c> creditNoteToUpsert = new List<Credit_Note__c>();
            List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
            Set<String> CodesOfBooking = new Set<String>();
            
            Map<String, Object> creditNote = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
            Map<String, Object> innerBody = (Map<String, Object>)creditNote.get('ZSD028_SFDC_CREDIT_NOTE');
            Map<String, Object> internalMap = (Map<String, Object>)innerBody.get('CREDIT_NOTE');
            List<Object> itemList = (List<Object>)internalMap.get('item');
            System.debug('Payload--> '+itemList);
            
            if(itemList.size()>0){
                for(Object obj:itemList){
                    Map<String, Object> item = (Map<String, Object>)obj;
                    String creditNoteSapCode = String.valueOf(item.get('VBELN'));
                    String creditNoteDate = String.valueOf(item.get('FKDAT'));
                    String customerSapCode = String.valueOf(item.get('KUNAG'));
                    String bookingSapCode = String.valueOf(item.get('AUBEL'));
                    String description = String.valueOf(item.get('AUGRU'));
                    String creditNoteAmount = String.valueOf(item.get('NETWR'));
                    String creditNoteStatus = String.valueOf(item.get('FKSTO'));
                    
                    List<Booking__c> bookList = [Select Id,Sap_Code__c from Booking__c where Sap_Code__c =: bookingSapCode limit 1];
                    if(!bookList.isEmpty()){
                        List<Credit_Note__c> creditList = [Select Id,Sap_Code__c from Credit_Note__c where Sap_Code__c=:creditNoteSapCode limit 1];
                        Credit_Note__c creditRecord = new Credit_Note__c();
                        creditRecord.Booking__c = bookList[0].Id;
                        creditRecord.Credit_Note_Date__c = Date.valueOf(dateFormat(creditNoteDate));
                        creditRecord.Credit_Note_Amount__c = Decimal.valueOf(creditNoteAmount);
                        creditRecord.Credit_Note_Status__c = creditNoteStatus;
                        creditRecord.Description__c = description;
                        
                        if(creditList.isEmpty()){
                            creditRecord.Sap_Code__c = creditNoteSapCode;
                            creditNoteToUpsert.add(creditRecord);
                        }
                        else{
                            creditRecord.Id = creditList[0].Id;
                            creditRecord.Sap_Code__c = creditList[0].Sap_Code__c;
                            creditNoteToUpsert.add(creditRecord);
                        }
                    }
                    else{
                        CodesOfBooking.add(bookingSapCode);
                        system.debug('CodesOfBooking--> '+CodesOfBooking);
                    }
                }
            }
            system.debug('creditNoteToUpsert--> '+creditNoteToUpsert);
            JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
            jsonGenerator1.writeStartObject();
            jsonGenerator1.writeFieldName('RESPONSE');
            jsonGenerator1.writeStartObject();
            jsonGenerator1.writeFieldName('item');
            jsonGenerator1.writeStartArray();
            if(!creditNoteToUpsert.isEmpty()){
                Database.UpsertResult[] upsertResults = Database.upsert(creditNoteToUpsert, false);
                for (Database.UpsertResult sr : upsertResults) {
                    Set<String> bookingCodes = new Set<String>();
                    if (sr.isSuccess()) {
                        Credit_Note__c upsertedCreditNote = [Select Id,Sap_Code__c from Credit_Note__c where Id=:sr.getId()];
                        jsonGenerator1.writeStartObject();
                        jsonGenerator1.writeStringField('VBELN',upsertedCreditNote.Sap_Code__c);
                        jsonGenerator1.writeStringField('STATUS','SUCCESS');
                        if(sr.isCreated()){
                            jsonGenerator1.writeStringField('MESSAGE','Credit Note Created Successfully');
                        }
                        else{
                            jsonGenerator1.writeStringField('MESSAGE','Credit Note Updated Successfully');
                        }
                        jsonGenerator1.writeEndObject();
                    }
                    else {
                        String errorCreditNoteSAPCode='';
                        if(!sr.isCreated()){
                            Credit_Note__c errorCreditNote = [Select Id,Sap_Code__c from Credit_Note__c where Id=:sr.getId()];
                            errorCreditNoteSAPCode=errorCreditNote.Sap_Code__c;
                        }
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            jsonGenerator1.writeStartObject();
                            if(!sr.isCreated()){ 
                            	jsonGenerator1.writeStringField('VBELN',errorCreditNoteSAPCode);
                            }
                            jsonGenerator1.writeStringField('STATUS','ERROR');
                            jsonGenerator1.writeStringField('MESSAGE',err.getMessage());
                            jsonGenerator1.writeEndObject();
                        }
                    }
                }
            }
            if(!CodesOfBooking.isEmpty()){
                system.debug('inside error');
                system.debug('bookingCodes--> '+CodesOfBooking);
                for(String codes:CodesOfBooking){
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeStringField('AUBEL',string.valueOf(codes));
                    jsonGenerator1.writeStringField('STATUS','ERROR');
                    jsonGenerator1.writeStringField('MESSAGE','This Booking Code '+codes+' does not exist');
                    jsonGenerator1.writeEndObject();
                }
            }
            jsonGenerator1.writeEndArray();
            jsonGenerator1.writeEndObject();
            jsonGenerator1.writeEndObject();
            jsonGeneratorList.add(jsonGenerator1);
            String jsonString = '';
            if(jsonGeneratorList.size()>0){
                for (JSONGenerator generator : jsonGeneratorList) {
                    jsonString += generator.getAsString();
                }
                system.debug('jsonString--> '+jsonString);
            }
            res.statusCode = 201;
            String  jsonResponse = jsonString;
            res.responseBody = blob.valueOf(jsonResponse);
            Data_Sync__c ds = new Data_Sync__c();
            ds.Event_Type__c = 'Credit Note';
            ds.Request_Body__c = RestContext.request.requestBody.toString();
            ds.Response_Body__c = jsonString;
            ds.Sync_Direction__c = 'SAP to SFDC';
            ds.Status__c = 'Success';
            insert ds;
        }
        catch(Exception e){
            System.debug('---Request----'+ String.valueOf(e.getLineNumber()));
            res.statusCode = 400;
            String  jsonResponse = '{"RESPONSE": {"STATUS": "' + 'Error' + '","MESSAGE":"'+'Exception occured, Credit Note not created :'+e+'\"}}';
            res.responseBody = blob.valueOf(jsonResponse);
            Data_Sync__c ds = new Data_Sync__c();
            ds.Event_Type__c = 'Credit Note';
            ds.Request_Body__c = RestContext.request.requestBody.toString();
            ds.Response_Body__c = jsonResponse;
            ds.Sync_Direction__c = 'SAP to SFDC';
            ds.Status__c = 'Error';
            insert ds;
            
            return;
        }
    }
    public static string dateFormat(string str){
        System.debug('Inside1---'+str);
        String dateFull  = String.valueOf(str);
        System.debug('Inside1str---'+str);
        String[] creditNoteDate = dateFull.split('\\.');
        System.debug('Inside1-demandDate--'+creditNoteDate);
        String dd = creditNoteDate[0]; 
        String mm = creditNoteDate[1];
        String yyyy = creditNoteDate[2];
        string formattedCreditNoteDate = yyyy+'-'+mm+'-'+dd;
        System.debug('---formattedCreditNoteDate------'+formattedCreditNoteDate);
        return formattedCreditNoteDate;
    }
}