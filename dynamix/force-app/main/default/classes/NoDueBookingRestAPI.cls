/*
* Author : Nachiketa Khera
* Created Date : 18th April 2024
* Description : Rest API to capture No Due data from SAP and store the information at Booking.
* Last Modified Date : 22th April 2024
*/
@RestResource(urlMapping='/NoDueBooking/*')
global class NoDueBookingRestAPI {
    @HttpGet
    global static void getNoDueBooking() {
        RestResponse res = RestContext.response;
        List<Booking__c> bookToUpdate = new List<Booking__c>();
        List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
        Set<String> CodesOfBooking = new Set<String>();
        Map<String, Object> noDueBook = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
        Map<String, Object> innerBody = (Map<String, Object>)noDueBook.get('ZSD027_SFDC_NO_DUE_CERTIFICATE');
        Map<String, Object> internalMap = (Map<String, Object>)innerBody.get('NO_DUE_CERT');
        List<Object> itemList = (List<Object>)internalMap.get('item');
        System.debug('Payload--> '+itemList);
        if(itemList.size()>0){
            for (Object obj:itemList){
                Map<String, Object> item = (Map<String, Object>)obj;
                String customerSAPCode = String.valueOf(item.get('KUNNR'));
                String bookingSAPCode = String.valueOf(item.get('VBELN'));
                String noDueClearance = String.valueOf(item.get('NO_DUE'));
                
                List<Booking__c> bookList = [Select Id,Sap_Code__c from Booking__c where Sap_Code__c =: bookingSAPCode limit 1];
                if(!bookList.isEmpty()){
                    if(noDueClearance=='X'){
                        Booking__c book = new Booking__c();
                        book.Id = bookList[0].Id;
                        book.NDC_Received__c = true;
                        book.No_Due_Received_Date__c = system.today();
                        bookToUpdate.add(book);
                    }
                } 
                else{
                    system.debug('In else');
                    CodesOfBooking.add(bookingSAPCode);
                }
            }
        }
        system.debug('bookToUpdate--> '+bookToUpdate);
        JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
        jsonGenerator1.writeStartObject();
        jsonGenerator1.writeFieldName('RESPONSE');
        jsonGenerator1.writeStartObject();
        jsonGenerator1.writeFieldName('item');
        jsonGenerator1.writeStartArray();
        if(!bookToUpdate.isEmpty()){
            Database.SaveResult[] updateResults = Database.update(bookToUpdate, false);
            for (Database.SaveResult sr : updateResults) {
                Set<String> bookingCodes = new Set<String>();
                if (sr.isSuccess()) {
                    Booking__c updatedBooking = [Select Id,Sap_Code__c from Booking__c where Id=:sr.getId()];
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeStringField('VBELN',updatedBooking.Sap_Code__c);
                    jsonGenerator1.writeStringField('STATUS','SUCCESS');
                    jsonGenerator1.writeStringField('MESSAGE','Booking Updated Successfully');
                    jsonGenerator1.writeEndObject();
                }
                else {
                    Booking__c updatedBooking = [Select Id,Sap_Code__c from Booking__c where Id=:sr.getId()];
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        jsonGenerator1.writeStartObject();
                        jsonGenerator1.writeStringField('VBELN',updatedBooking.Sap_Code__c);
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
                jsonGenerator1.writeStringField('VBELN',string.valueOf(codes));
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
    }
}