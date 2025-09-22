/*
* Author : Nachiketa Khera
* Created Date : 10th April 2024
* Description : Booking Cancellation
* Last Modified Date : 16th April 2024
*/
public class calloutBookingCancellation {
    @InvocableMethod
    public static void getBooking(List<request> reqList){
        System.debug('reqList'+reqList);
        if(reqList != null){
            for(request req :reqList){
                exposeBookingCancellationToSAP(req.bookingId);
            }
        }
    }
    @future(Callout=true)
    public static void exposeBookingCancellationToSAP(String bookingId){
        try{
            Set<String> bookingIdsFromDataSync = new Set<String>();
            List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
            Set<String> bookingCancellationProcessed = new Set<String>();
            for(Data_Sync__c ds:[Select Id,Event_Type__c,RecordId__c, Status__c from Data_Sync__c where Status__c ='Pending' and RecordId__c =:bookingId AND Event_Type__c ='Booking Cancellation' limit 1]){
                if(ds!=null){
                    bookingIdsFromDataSync.add(ds.RecordId__c);
                }
            }
            if(bookingIdsFromDataSync!=null){
                for(Booking__c book:[Select Id,Sap_Code__c,Cancellation_Reasons__c,Cancel_or_Termination_date__c,Cancellation_Initiated_by__c,Cancellation_Computation__c,
                                     Cancellation_Deed_Date__c from Booking__c where Id IN:bookingIdsFromDataSync]){
                    if(book!=null){
                        bookingCancellationProcessed.add(book.Id);
                        JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
                        jsonGenerator1.writeStartObject();
                        jsonGenerator1.writeFieldName('ZSD023_SFDC_BOOKING_CANCEL');
                        jsonGenerator1.writeStartObject();
                        jsonGenerator1.writeFieldName('ORDER_HEADER');
                        jsonGenerator1.writeStartObject();
                            jsonGenerator1.writeStringField('SFDC_ID',book.Id);
                            jsonGenerator1.writeStringField('VBELN',book.Sap_Code__c!=null?book.Sap_Code__c:'');
                            jsonGenerator1.writeStringField('ABGRU',book.Cancellation_Reasons__c!=null?book.Cancellation_Reasons__c:'');
                            jsonGenerator1.writeStringField('ZZCANL_INIT_BY',book.Cancellation_Initiated_by__c!=null?book.Cancellation_Initiated_by__c:'');
                            if(book.Cancellation_Deed_Date__c!=null){
                                Date cancelDeedDate = book.Cancellation_Deed_Date__c;
                                String formattedDay = (cancelDeedDate.day() < 10) ? '0' + String.valueOf(cancelDeedDate.day()) : String.valueOf(cancelDeedDate.day());
                                String formattedMonth = (cancelDeedDate.month() < 10) ? '0' + String.valueOf(cancelDeedDate.month()) : String.valueOf(cancelDeedDate.month());
                                String cancellationDeedDate = formattedDay + '.' + formattedMonth + '.' + cancelDeedDate.year();
                                jsonGenerator1.writeStringField('ZZDEED_CANL_REG',cancellationDeedDate!=null?cancellationDeedDate:'');
                            }else{
                                jsonGenerator1.writeStringField('ZZDEED_CANL_REG','');
                            }
                            if(book.Cancel_or_Termination_date__c!=null){
                                Date cancelDate = book.Cancel_or_Termination_date__c;
                                String formattedDay = (cancelDate.day() < 10) ? '0' + String.valueOf(cancelDate.day()) : String.valueOf(cancelDate.day());
                                String formattedMonth = (cancelDate.month() < 10) ? '0' + String.valueOf(cancelDate.month()) : String.valueOf(cancelDate.month());
                                String cancelOrTerminationDate = formattedDay + '.' + formattedMonth + '.' + cancelDate.year();
                                jsonGenerator1.writeStringField('ZZCANL_DT',cancelOrTerminationDate!=null?cancelOrTerminationDate:'');
                            }else{
                                jsonGenerator1.writeStringField('ZZCANL_DT','');
                            }
                        	jsonGenerator1.writeStringField('REFUND_TEXT',book.Cancellation_Computation__c);
                        jsonGenerator1.writeEndObject();
                        jsonGenerator1.writeEndObject();
                        jsonGenerator1.writeEndObject();
                        jsonGeneratorList.add(jsonGenerator1);
                    }
                }
            }
            if(jsonGeneratorList.size()>0){
                String jsonString = '';
                for (JSONGenerator generator : jsonGeneratorList) {
                    jsonString += generator.getAsString();
                }
                system.debug('jsonString--> '+jsonString);
                getSapCodes(jsonString,bookingCancellationProcessed);
            }
        }
        catch(Exception e){
            System.debug('Exception: ' + e.getMessage());
            System.debug('Exception:Number>> ' + e.getLineNumber());
        }
    }
    public static String getSapCodes( String jsonString,Set<String>bookingCancellationProcessed){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        request.setEndpoint('callout:SAP_BookingCancellation');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic UzAwMjQzMDI0NDA6Umlja3lAOTk2OQ==');
        request.setBody(jsonString);
        try {
            response = http.send(request);
            //ResponseAPIClass.getResponse(response);
            String responseBody1 = response.getBody();
            List<Booking__c> bookingToUpdate = new List<Booking__c>();
            System.debug('responseBody1---'+responseBody1);
            Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(responseBody1);
            List<Object> sapResponseArray = (List<Object>)requestBody.get('item');
            System.debug('responseBody1 sapResponseArray---'+sapResponseArray);
            Set<String> success_recordIds=new Set<String>();
            Set<String> failed_recordIds=new Set<String>();
            for (Object obj : sapResponseArray) {
                Map<String, Object> item = (Map<String, Object>)obj;
                String Status = (String)item.get('STATUS');
                System.debug('Response Status--> '+Status);
                if(Status=='Success'){
                    Booking__c book = new Booking__c();
                    book.Id=SFValidId.repairCasing((String)item.get('SFDC_ID'));
                    book.SAP_Cancellation_Status__c = 'Success';
                    bookingToUpdate.add(book);
                    success_recordIds.add(((String)item.get('SFDC_ID')));
                    
                }
                else{
                    Booking__c book = new Booking__c();
                    book.Id=SFValidId.repairCasing((String)item.get('SFDC_ID'));
                    book.SAP_Cancellation_Status__c = 'Failed';
                    bookingToUpdate.add(book);
                    failed_recordIds.add(((String)item.get('SFDC_ID')));
                }
            }
            List<Data_Sync__c> DSToUpdate = new List<Data_Sync__c>();
            if (response.getStatusCode() == 200 ||response.getStatusCode() == 201) {
                String responseBody = response.getBody();
                
                if(bookingCancellationProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c where RecordId__c IN :bookingCancellationProcessed AND Status__c = 'Pending']){
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
                if(bookingCancellationProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c  where RecordId__c IN :bookingCancellationProcessed AND Status__c = 'Pending']){
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
            if(!bookingToUpdate.isEmpty()){
                update bookingToUpdate;
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
        return null;
    }
    public class request{
        @InvocableVariable (required=true)
        public string bookingId;
    }
}