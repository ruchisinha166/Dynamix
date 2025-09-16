@RestResource(urlMapping='/receiptconfirmation/*')
global class ReceiptConfirmation {
    @HttpGet
    global static Void getdemandRecord() {
        RestResponse res = RestContext.response;
		try {
            List<SObject> paymentToUpdate=new List<SObject>();
            Map<String, Object> demandObject = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
            Map<String, Object> innerBody = (Map<String, Object>)demandObject.get('ZFI012_SFDC_REC_POS_OUTBOUND');
            Map<String, Object> internalMap = (Map<String, Object>)innerBody.get('RECPOS_DATA');
            List<Object> itemList = (List<Object>)internalMap.get('item');
            System.debug('ppp'+itemList);
            if(itemList.size()>0){
                for (Object obj:itemList){
                    Map<String, Object> item = (Map<String, Object>)obj;
    				Id SF_Id = SFValidId.repairCasing(String.valueOf(item.get('ZSFDC_ID')));
                    String Status = String.valueOf(item.get('ZPAYMENT_STATUS'));
                    String Description = String.valueOf(item.get('ZPAYMENT_DES'));
                    String PaymentSapCode = String.valueOf(item.get('ZRECEIPT_DOC'));
                    
                    Schema.SObjectType objectType = SF_Id.getSObjectType();
                    String objectName = objectType.getDescribe().getName();
                    if(objectName=='Payment__c'){
                        if(Status=='Accept'){
                            Payment__c pp=new Payment__c();
                            pp.id=SF_Id;
                            pp.Payment_Status__c='Approved';
                            pp.Sap_code__c=PaymentSapCode;
                            pp.SAP_Approved_Rejected_Date__c = system.today();
                            paymentToUpdate.add(pp);
                            
                        }
                        if(Status=='Reject'){
                            Payment__c pp=new Payment__c();
                            pp.id=SF_Id;
                            pp.Payment_Status__c='Rejected';
                            pp.Reason_for_reject__c=Description;
                            pp.Sap_code__c=PaymentSapCode;
                            pp.SAP_Approved_Rejected_Date__c = system.today();
                            paymentToUpdate.add(pp);
                            
                        }
                    }
                    else if(objectName=='EOI_CA_Payment__c'){
                        if(Status=='Accept'){
                            EOI_CA_Payment__c pp=new EOI_CA_Payment__c();
                            pp.id=SF_Id;
                            pp.Payment_Status__c='Approved';
                            pp.Sap_code__c=PaymentSapCode;
                            pp.SAP_Approved_Rejected_Date__c = system.today();
                            paymentToUpdate.add(pp);
                            
                        }
                        if(Status=='Reject'){
                            EOI_CA_Payment__c pp=new EOI_CA_Payment__c();
                            pp.id=SF_Id;
                            pp.Payment_Status__c='Rejected';
                            pp.Reason_for_reject__c=Description;
                            pp.Sap_code__c=PaymentSapCode;
                            pp.SAP_Approved_Rejected_Date__c = system.today();
                            paymentToUpdate.add(pp);
                            
                        }
                    }
                }
            }
            List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
            if(paymentToUpdate.size()>0){
                JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
            jsonGenerator1.writeStartObject();
            jsonGenerator1.writeFieldName('RESPONSE');
            
            jsonGenerator1.writeStartObject(); //RECPOS_DATA
            
            jsonGenerator1.writeFieldName('item');
                jsonGenerator1.writeStartArray();
                Database.SaveResult[] updateResults = Database.update(paymentToUpdate, false); 
                for (Database.SaveResult result : updateResults) {
                    if (result.isSuccess()) {
                        jsonGenerator1.writeStartObject();
                        jsonGenerator1.writeStringField('SFDC_ID',String.valueOf(result.getId()).toUpperCase());
                        jsonGenerator1.writeStringField('STATUS','Success'); jsonGenerator1.writeStringField('MESSAGE','Received'); 
                        jsonGenerator1.writeEndObject();
                        System.debug('Success'+result.getId());
                    }
                }
                jsonGenerator1.writeEndArray();
            
            jsonGenerator1.writeEndObject();
            jsonGenerator1.writeEndObject();
            jsonGeneratorList.add(jsonGenerator1);
            }
            String jsonString = '';
             if(jsonGeneratorList.size()>0){
                
                for (JSONGenerator generator : jsonGeneratorList) {
                    jsonString += generator.getAsString();
                }
                system.debug('jsonString--> '+jsonString);
               // getSapCodes(jsonString,TransProcessed);
            }
           
            
           res.statusCode = 201;
           String  jsonResponse = jsonString; //MESSAGE
           res.responseBody = blob.valueOf(jsonResponse);
        }
        catch (Exception e){
           System.debug('---Request----'+e);
           res.statusCode = 400;
           String  jsonResponse = '{"response": {"SFDC_ID": '+''+'\", "STATUS": "' + 'Error' + '"," MESSAGE":"'+'Error occured while updating a payment :'+e+'}}';
           res.responseBody = blob.valueOf(jsonResponse);
           return;
        }
       
}
 public class CustomException extends Exception {}
}