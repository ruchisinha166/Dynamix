/*
 * Author : Nachiketa Khera
 * Created Date : 22th January 2024
 * Description : Rest API to capture TDS data from SAP and Create a Payment record with category TDS
 * Last Modified Date : 31th January 2024
*/
@RestResource(urlMapping='/tdsPayment/*')
global class TDSPaymentRestAPI {
    @HttpGet
    global static void getTdsRecord() {
        RestResponse res = RestContext.response;
		try {
            List<Payment__c> paymentToInsert = new List<Payment__c>();
            Map<String, Object> tdsPayment = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
            Map<String, Object> innerBody = (Map<String, Object>)tdsPayment.get('ZFI016_SFDC_TDS_OUTBOUND');
            Map<String, Object> internalMap = (Map<String, Object>)innerBody.get('TDS_DATA');
            List<Object> itemList = (List<Object>)internalMap.get('item');
            System.debug('ppp'+itemList);
            Map<String,String> CodesOfBooking = new Map<String,String>();
            List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
         	List<JSONGenerator> jsonGeneratorList2 = new List<JSONGenerator>();
            if(itemList.size()>0){
                for (Object obj:itemList){
                    Map<String, Object> item = (Map<String, Object>)obj;
                    String bookingCode = String.valueOf(item.get('BOOKING_ID'));
                    String customerCode = String.valueOf(item.get('CUSTOMER_ID'));
                    String paymentCategory = String.valueOf(item.get('CATEGORY'));
                    String paymentAmount = String.valueOf(item.get('AMOUNT'));
                    String tdsDate = String.valueOf(item.get('DATE'));
                    String challanNo = String.valueOf(item.get('CHALLAN_NO'));
                    
                    List<Booking__c> bookList = [Select Id,Sap_Code__c from Booking__c where Sap_Code__c =: bookingCode limit 1];
                    if(bookList.size()>0){
                        Payment__c tdsPay = new Payment__c();
                        tdsPay.Booking__c = bookList[0].Id;
                        tdsPay.Payment_Category__c = 'TDS';
                        tdsPay.Amount__c = Decimal.valueOf(paymentAmount);
                        system.debug('tdsDate-- '+tdsDate);
                        Date paymentDate = Date.valueOf(dateFormat(tdsDate));
                        system.debug('paymentDate-- '+paymentDate);
                        tdsPay.Payment_Date__c = paymentDate;
                        tdsPay.Cheque_Transaction_Number__c = challanNo;
                        tdsPay.Paid_By__c = 'Self';
                        tdsPay.Payment_Status__c = 'Approved';
                        tdsPay.Status__c = 'Approved';
                        tdsPay.Payment_Type__c = 'NEFT/ RTGS/ IMPS';
                        tdsPay.SAP_Approved_Rejected_Date__c = paymentDate;
                        if(test.isRunningTest()){
                            tdsPay.Receipt_No__c = '12345';
                        }
                        paymentToInsert.add(tdsPay);
                    }
                    else{
                        system.debug('In else');
                        CodesOfBooking.put(bookingCode,tdsDate);
                    }
                }
            }
            
            if(paymentToInsert.size()>0){
                JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
                jsonGenerator1.writeStartObject();
                jsonGenerator1.writeFieldName('RESPONSE');
                jsonGenerator1.writeStartObject();
                jsonGenerator1.writeFieldName('item');
                jsonGenerator1.writeStartArray();
                Database.SaveResult[] insertResults = Database.insert(paymentToInsert, false); 
                for (Database.SaveResult result : insertResults) {
                    if(result.isSuccess()){
                        Payment__c insertedPayment = [Select Id,Amount__c,Booking__c,Booking__r.Total_TDS_Value__c,Booking__r.Total_TDS_Received__c,
                                                      Booking__r.Total_TDS_Pending__c,Booking__r.Sap_Code__c,Payment_Date__c from Payment__c where Id=:result.getId()];
                        jsonGenerator1.writeStartObject();
                        jsonGenerator1.writeStringField('BOOKING_ID',insertedPayment.Booking__r.Sap_Code__c!=null?insertedPayment.Booking__r.Sap_Code__c:'');
                        jsonGenerator1.writeStringField('STATUS','SUCCESS');
                        jsonGenerator1.writeStringField('TDS_AMOUNT',insertedPayment != null && insertedPayment.Amount__c != null?string.valueOf(insertedPayment.Amount__c):'');
                        
                        Date payDate = insertedPayment.Payment_Date__c;
                        String formattedDay = (payDate.day() < 10) ? '0' + String.valueOf(payDate.day()) : String.valueOf(payDate.day());
                        String formattedMonth = (payDate.month() < 10) ? '0' + String.valueOf(payDate.month()) : String.valueOf(payDate.month());
                        String paymentDate = formattedDay + '.' + formattedMonth + '.' + payDate.year();
                        
                        jsonGenerator1.writeStringField('TDS_DATE',paymentDate != null?string.valueOf(paymentDate):'');
                        jsonGenerator1.writeStringField('TOTAL_TDS',insertedPayment.Booking__r.Total_TDS_Value__c != null?string.valueOf(insertedPayment.Booking__r.Total_TDS_Value__c):'');
                        jsonGenerator1.writeStringField('TOTAL_TDS_REC',insertedPayment.Booking__r.Total_TDS_Received__c != null?string.valueOf(insertedPayment.Booking__r.Total_TDS_Received__c):'');
                        jsonGenerator1.writeStringField('TOTAL_TDS_BAL',insertedPayment.Booking__r.Total_TDS_Pending__c != null?string.valueOf(insertedPayment.Booking__r.Total_TDS_Pending__c):'');
                        jsonGenerator1.writeStringField('MESSAGE','TDS Created Successfully');
                        jsonGenerator1.writeEndObject();
                        System.debug('Success>> '+result.getId());
                    }
                    else{
                        for(Database.Error err : result.getErrors()) {
                            jsonGenerator1.writeStartObject();
                            jsonGenerator1.writeStringField('BOOKING_ID','');
                            jsonGenerator1.writeStringField('STATUS','ERROR');
                            jsonGenerator1.writeStringField('TDS_AMOUNT','0.00');
                            jsonGenerator1.writeStringField('TDS_DATE','');
                            jsonGenerator1.writeStringField('TOTAL_TDS','0.00');
                            jsonGenerator1.writeStringField('TOTAL_TDS_REC','0.00');
                            jsonGenerator1.writeStringField('TOTAL_TDS_BAL','0.00');
                            jsonGenerator1.writeStringField('MESSAGE',err.getMessage());
                            jsonGenerator1.writeEndObject();
                        }
                    }
                }
                jsonGenerator1.writeEndArray();
                jsonGenerator1.writeEndObject();
                jsonGenerator1.writeEndObject();
                jsonGeneratorList.add(jsonGenerator1);
            }
            if(paymentToInsert.size()==0 || !CodesOfBooking.isEmpty()){
                system.debug('inside error');
                system.debug('bookingCodes--> '+CodesOfBooking);
                //res.statusCode = 400;
                JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
                jsonGenerator1.writeStartObject();
                jsonGenerator1.writeFieldName('RESPONSE');
                jsonGenerator1.writeStartObject();
                jsonGenerator1.writeFieldName('item');
                jsonGenerator1.writeStartArray();
                for(String codes:CodesOfBooking.keySet()){
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeStringField('BOOKING_ID',string.valueOf(codes));
                    jsonGenerator1.writeStringField('STATUS','ERROR');
                    jsonGenerator1.writeStringField('TDS_AMOUNT','0.00');
                    jsonGenerator1.writeStringField('TDS_DATE',string.valueOf(CodesOfBooking.get(codes)));
                    jsonGenerator1.writeStringField('TOTAL_TDS','0.00');
                    jsonGenerator1.writeStringField('TOTAL_TDS_REC','0.00');
                    jsonGenerator1.writeStringField('TOTAL_TDS_BAL','0.00');
                    jsonGenerator1.writeStringField('MESSAGE','This Booking Code '+codes+' does not exist');
                    jsonGenerator1.writeEndObject();
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
            }
            res.statusCode = 201;
            String  jsonResponse = jsonString;
            res.responseBody = blob.valueOf(jsonResponse);
            Data_Sync__c ds = new Data_Sync__c();
            ds.Event_Type__c = 'TDS Payment';
            ds.Request_Body__c = RestContext.request.requestBody.toString();
            ds.Response_Body__c = jsonString;
            ds.Sync_Direction__c = 'SAP to SFDC';
            ds.Status__c = 'Success';
            insert ds;
        }
        catch (Exception e){
            System.debug('---Request----'+String.valueOf(e.getLineNumber()));
            res.statusCode = 400;
            String  jsonResponse = '{"response": {"STATUS": "' + 'Error' + '"," MESSAGE":"'+'Error occured while creating tds payment :'+e+'}}';
            res.responseBody = blob.valueOf(jsonResponse);
            Data_Sync__c ds = new Data_Sync__c();
            ds.Event_Type__c = 'TDS Payment';
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
        String[] tdsDate = dateFull.split('\\.');
        System.debug('Inside1-demandDate--'+tdsDate);
        String dd = tdsDate[0]; 
        String mm = tdsDate[1];
        String yyyy = tdsDate[2];
        string tdscreateDate = yyyy+'-'+mm+'-'+dd;
        System.debug('---tdscreateDate------'+tdscreateDate);
        return tdscreateDate;
    }
}