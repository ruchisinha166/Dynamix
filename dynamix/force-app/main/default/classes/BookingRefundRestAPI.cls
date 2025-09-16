/*
* Author : Nachiketa Khera
* Created Date : 22nd May 2024
* Description : Rest API to capture Booking Refund Payment details from SAP and store the information at Booking.
* Last Modified Date : 23th May 2024
*/
@RestResource(urlMapping='/BookingRefund/*')
global class BookingRefundRestAPI {
    @HttpPost
    global static void getBookingRefund() {
        RestResponse res = RestContext.response;
        try{
            List<Booking__c> bookingToUpdate = new List<Booking__c>();
            List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
            Set<String> CodesOfBooking = new Set<String>();
            
            Map<String, Object> bookingRefund = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
            Map<String, Object> innerBody = (Map<String, Object>)bookingRefund.get('ZFI014_SFDC_RES_REFUND');
            Map<String, Object> internalMap = (Map<String, Object>)innerBody.get('RES_REFUND');
            List<Object> itemList = (List<Object>)internalMap.get('item');
            System.debug('Payload--> '+itemList);
            
            if(itemList.size()>0){
                for(Object obj:itemList){
                    Map<String, Object> item = (Map<String, Object>)obj;
                    String bookingSAPCode = String.valueOf(item.get('VBELN'));
                    String refundDate = String.valueOf(item.get('H_BUDAT'));
                    String refundSAPCode = String.valueOf(item.get('BELNR'));
                    Decimal refundAmount = Decimal.valueOf(String.valueOf(item.get('DMBTR')));
                    String refundChequeNumber = String.valueOf(item.get('KIDNO'));
                    String bankName = String.valueOf(item.get('BANKA'));
                    
                    List<Booking__c> bookList = [Select Id,Sap_Code__c from Booking__c where Sap_Code__c =: bookingSAPCode limit 1];
                    if(!bookList.isEmpty()){
                        Booking__c book = new Booking__c();
                        book.Id = bookList[0].Id;
                        book.Refund_Amount1__c = refundAmount;
                        book.Refund_Date__c = Date.valueOf(dateFormat(refundDate));
                        book.Refund_Instrument_Number__c = refundChequeNumber;
                        book.Refund_Bank__c = bankName;
                        bookingToUpdate.add(book);
                    }
                    else{
                        system.debug('In else');
                        CodesOfBooking.add(bookingSAPCode);
                    }
                }
            }
            system.debug('bookingToUpdate--> '+bookingToUpdate);
            JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
            jsonGenerator1.writeStartObject();
            jsonGenerator1.writeFieldName('RESPONSE');
            jsonGenerator1.writeStartObject();
            jsonGenerator1.writeFieldName('item');
            jsonGenerator1.writeStartArray();
            if(!bookingToUpdate.isEmpty()){
                Database.SaveResult[] updateResults = Database.update(bookingToUpdate, false);
                for (Database.SaveResult sr : updateResults) {
                    if (sr.isSuccess()) {
                        Booking__c updatedBooking = [Select Id,Sap_Code__c from Booking__c where Id=:sr.getId()];
                        jsonGenerator1.writeStartObject();
                        jsonGenerator1.writeStringField('VBELN',updatedBooking.Sap_Code__c);
                        jsonGenerator1.writeStringField('STATUS','SUCCESS');
                        jsonGenerator1.writeStringField('MESSAGE','Booking Refund Details Updated Successfully');
                        jsonGenerator1.writeEndObject();
                    }
                    else {
                        Booking__c updatedBooking = [Select Id,Sap_Code__c from Booking__c where Id=:sr.getId()];            
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
                system.debug('CodesOfBooking--> '+CodesOfBooking);
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
        catch(Exception e){
            System.debug('---Request----'+ String.valueOf(e.getLineNumber()));
            res.statusCode = 400;
            String  jsonResponse = '{"RESPONSE": {"STATUS": "' + 'Error' + '","MESSAGE":"'+'Exception occured, Refund Details Not Updated :'+e+'\"}}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }
    }
    public static string dateFormat(string str){
        System.debug('Inside1---'+str);
        String dateFull  = String.valueOf(str);
        System.debug('Inside1str---'+str);
        String[] bookRefundDate = dateFull.split('\\.');
        System.debug('Inside1-demandDate--'+bookRefundDate);
        String dd = bookRefundDate[0]; 
        String mm = bookRefundDate[1];
        String yyyy = bookRefundDate[2];
        string formattedbookRefundDate = yyyy+'-'+mm+'-'+dd;
        System.debug('---formattedbookRefundDate------'+formattedbookRefundDate);
        return formattedbookRefundDate;
    }
}