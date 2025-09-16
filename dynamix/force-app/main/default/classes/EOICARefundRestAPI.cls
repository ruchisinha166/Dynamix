/*
* Author : Nachiketa Khera
* Created Date : 9th May 2024
* Description : Rest API to capture EOI/CA Refund Payment details from SAP and store the information at EOI/CA Opportunity.
* Last Modified Date : 10th May 2024
*/
@RestResource(urlMapping='/EOICARefund/*')
global class EOICARefundRestAPI {
    @HttpGet
    global static void getEOICARefund() {
        RestResponse res = RestContext.response;
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
        Set<String> CodesOfEOICustomer = new Set<String>();
        
        Map<String, Object> EOICARefund = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
        Map<String, Object> innerBody = (Map<String, Object>)EOICARefund.get('ZFI014_SFDC_EOI_REFUND');
        Map<String, Object> internalMap = (Map<String, Object>)innerBody.get('EOI_REFUND');
        List<Object> itemList = (List<Object>)internalMap.get('item');
        System.debug('Payload--> '+itemList);
        
        if(itemList.size()>0){
            for(Object obj:itemList){
                Map<String, Object> item = (Map<String, Object>)obj;
                String eoiCustomerSAPCode = String.valueOf(item.get('KUNNR'));
                String refundDate = String.valueOf(item.get('H_BUDAT'));
                String refundSAPCode = String.valueOf(item.get('BELNR'));
                Decimal refundAmount = Decimal.valueOf(String.valueOf(item.get('DMBTR')));
                String refundChequeNumber = String.valueOf(item.get('KIDNO'));
                String bankName = String.valueOf(item.get('BANKA'));
                
                List<Opportunity> oppList = [Select Id,EOI_CA_Customer_Code__c from Opportunity where EOI_CA_Customer_Code__c=:eoiCustomerSAPCode limit 1];
                if(!oppList.isEmpty()){
                    Opportunity opp = new Opportunity();
                    opp.Id = oppList[0].Id;
                    opp.EOI_Refund_Payment_Status__c = 'Processed';
                    opp.Refund_Amount1__c = refundAmount;
                    opp.Refund_Date__c = Date.valueOf(dateFormat(refundDate));
                    opp.Refund_Instrument_Number__c = refundChequeNumber;
                    opp.Refund_Bank__c = bankName;
                    oppToUpdate.add(opp);
                }
                else{
                    CodesOfEOICustomer.add(eoiCustomerSAPCode);
                }
            }
        }
        system.debug('oppToUpdate--> '+oppToUpdate);
        JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
        jsonGenerator1.writeStartObject();
        jsonGenerator1.writeFieldName('RESPONSE');
        jsonGenerator1.writeStartObject();
        jsonGenerator1.writeFieldName('item');
        jsonGenerator1.writeStartArray();
        if(!oppToUpdate.isEmpty()){
            Database.SaveResult[] updateResults = Database.update(oppToUpdate, false);
            for (Database.SaveResult sr : updateResults) {
                if (sr.isSuccess()) {
                    Opportunity updatedOpp = [Select Id,EOI_CA_Customer_Code__c from Opportunity where Id=:sr.getId()];
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeStringField('KUNNR',updatedOpp.EOI_CA_Customer_Code__c);
                    jsonGenerator1.writeStringField('STATUS','SUCCESS');
                    jsonGenerator1.writeStringField('MESSAGE','EOI/CA Refund Details Updated Successfully');
                    jsonGenerator1.writeEndObject();
                }
                else {
                    Opportunity updatedOpp = [Select Id,EOI_CA_Customer_Code__c from Opportunity where Id=:sr.getId()];              
                    for(Database.Error err : sr.getErrors()) {
                        jsonGenerator1.writeStartObject();
                        jsonGenerator1.writeStringField('KUNNR',updatedOpp.EOI_CA_Customer_Code__c);
                        jsonGenerator1.writeStringField('STATUS','ERROR');
                        jsonGenerator1.writeStringField('MESSAGE',err.getMessage());
                        jsonGenerator1.writeEndObject();
                    }
                }
            }
        }
        if(!CodesOfEOICustomer.isEmpty()){
            system.debug('inside error');
            system.debug('CodesOfEOICustomer--> '+CodesOfEOICustomer);
            for(String codes:CodesOfEOICustomer){
                jsonGenerator1.writeStartObject();
                jsonGenerator1.writeStringField('KUNNR',string.valueOf(codes));
                jsonGenerator1.writeStringField('STATUS','ERROR');
                jsonGenerator1.writeStringField('MESSAGE','This EOI/CA Customer Code '+codes+' does not exist');
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
    }
    public static string dateFormat(string str){
        System.debug('Inside1---'+str);
        String dateFull  = String.valueOf(str);
        System.debug('Inside1str---'+str);
        String[] eoiRefundDate = dateFull.split('\\.');
        System.debug('Inside1-demandDate--'+eoiRefundDate);
        String dd = eoiRefundDate[0]; 
        String mm = eoiRefundDate[1];
        String yyyy = eoiRefundDate[2];
        string formattedEoiRefundDate = yyyy+'-'+mm+'-'+dd;
        System.debug('---formattedEoiRefundDate------'+formattedEoiRefundDate);
        return formattedEoiRefundDate;
    }
}