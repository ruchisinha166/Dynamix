/*
 * Author : Nachiketa Khera
 * Created Date : 4th January 2024
 * Description : Payment Milestone Api for SAP integration.
 * Last Modified Date : 22th January 2024
*/
public with sharing class calloutPaymentMilestone {
    @InvocableMethod
    public static void getPaymentMilestoneBooking(List<request> reqList){
        System.debug('reqList'+reqList);
        if(reqList != null){
            for(request req :reqList){
                exposePaymentMilestonesToSAP(req.bookingId,req.currentMilestoneId,req.operationType);
            }
        }
    }
    @future(Callout=true)
    public static void exposePaymentMilestonesToSAP(String bookingId,String currentMilestoneId, String operationType){
        system.debug('operationType--> '+operationType);
        system.debug('currentMilestoneId--> '+currentMilestoneId);
        try{
            Map<Id,List<Payment_Milestones__c>> milestonesMap = new Map<Id,List<Payment_Milestones__c>>();
            List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
            Set<String> milestoneProcessed = new Set<String>();
            
            if(bookingId != null && (operationType == 'I' || operationType == 'U')){
                for(Booking__c book:[Select Id,Name,Sap_Code__c,Unexposed_Milestone_Ids__c,Unexposed_Milestone_Ids_on_Update__c,
                                    Unexposed_Milestone_Ids_on_Delete__c,(Select Id,Name,Sequence_No__c,Milestone_age__c,Milestone_Amount1__c,
                                    Sap_Code__c,Invoice_Date__c,Booking__c,Booking__r.Sap_Code__c,Payment_Term_Code__c,Project_Progress__c,Milestone_Activation_Date__c,Milestone_Master__r.Sap_Code__c from Payment_Milestones__r where 
                                    Name != 'Possession/Handover(Other) Charge' ORDER BY Sequence_No__c),
                                    (Select Id,Role__c,Sap_Code__c from Co_Applicant__r where Role__c = 'Primary' limit 1)
                                    from Booking__c where Id =:bookingId ALL ROWS]){
                             
                             String customerCode;
                             if(book.Co_Applicant__r != null){
                                 customerCode = book.Co_Applicant__r[0].Sap_Code__c;
                             }
                             Set<Id> unexposedInsertMilestones = new Set<Id>();
                             Set<Id> unexposedUpdateMilestones = new Set<Id>();
                             if(book.Unexposed_Milestone_Ids__c != null){
                                 //unexposedInsertMilestones.add()
                             }
                             if(book != null){
                                 if(book.Payment_Milestones__r != null){
                                     JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
                                     jsonGenerator1.writeStartObject();
                                     jsonGenerator1.writeFieldName('ZSD019_SFDC_BILL_PLAN_MANAGE');
                                     jsonGenerator1.writeStartObject();
                                     jsonGenerator1.writeFieldName('BILL_PLAN');
                                     jsonGenerator1.writeStartObject();
                                     jsonGenerator1.writeFieldName('item');
                                     jsonGenerator1.writeStartArray();
                                     for(Payment_Milestones__c milestone:book.Payment_Milestones__r){
                                         if(milestone.Id==currentMilestoneId){
                                             milestoneProcessed.add(milestone.Id);
                                         }
                                         jsonGenerator1.writeStartObject();
                                         	jsonGenerator1.writeStringField('SFDC_ID',milestone.Booking__c!=null?string.valueOf(milestone.Booking__c):'');
                                         	if(milestone.Id==currentMilestoneId){
                                                jsonGenerator1.writeStringField('INDI',operationType!=null?operationType:'');
                                            }
                                            else if(book.Unexposed_Milestone_Ids__c != null && book.Unexposed_Milestone_Ids__c.contains(milestone.Id)){
                                                 jsonGenerator1.writeStringField('INDI','I');
                                            }
                                         	else if(book.Unexposed_Milestone_Ids_on_Update__c != null && book.Unexposed_Milestone_Ids_on_Update__c.contains(milestone.Id)){
                                                 jsonGenerator1.writeStringField('INDI','U');
                                            }
                                         	else if(book.Unexposed_Milestone_Ids_on_Delete__c != null && book.Unexposed_Milestone_Ids_on_Delete__c.contains(milestone.Id)){
                                                 jsonGenerator1.writeStringField('INDI','D');
                                            }
                                         	else{
                                                jsonGenerator1.writeStringField('INDI','');
                                         	}
                                         	//jsonGenerator1.writeStringField('INDI',milestone.Id==currentMilestoneId?operationType:book.Unexposed_Milestone_Ids__c.contains(milestone.Id)?'I':book.Unexposed_Milestone_Ids_on_Update__c.contains(milestone.Id)?'U':book.Unexposed_Milestone_Ids_on_Delete__c.contains(milestone.Id)?'D':'');
                                         	jsonGenerator1.writeStringField('SALESORDER',milestone.Booking__r.Sap_Code__c);
                                         	jsonGenerator1.writeStringField('SEQUENCE',milestone.Sequence_No__c!=null?string.valueOf(milestone.Sequence_No__c):'');
                                         	jsonGenerator1.writeStringField('CUSTOMER_CODE',customerCode!=null?customerCode:'');
                                         	jsonGenerator1.writeStringField('MILESTONE_CODE',milestone.Sap_Code__c !=null ?milestone.Sap_Code__c:
                                                        milestone.Milestone_Master__r.Sap_Code__c!=null?milestone.Milestone_Master__r.Sap_Code__c:'');
                                            if(milestone.Project_Progress__c == null){
                                                Date mileDate = milestone.Milestone_Activation_Date__c;
                                                String formattedDay = (mileDate.day() < 10) ? '0' + String.valueOf(mileDate.day()) : String.valueOf(mileDate.day());
                                                String formattedMonth = (mileDate.month() < 10) ? '0' + String.valueOf(mileDate.month()) : String.valueOf(mileDate.month());
                                                String milestoneDate = formattedDay + '.' + formattedMonth + '.' + mileDate.year();
                                             	jsonGenerator1.writeStringField('MILESTONE_DATE',milestoneDate!=null?String.valueOf(milestoneDate):'');
                                            }
                                         	else{
                                                jsonGenerator1.writeStringField('MILESTONE_DATE',milestone.Invoice_Date__c!=null?String.valueOf(milestone.Invoice_Date__c.day()+'.'+milestone.Invoice_Date__c.month()+'.'+milestone.Invoice_Date__c.year()):'');
                                         	}
                                         	jsonGenerator1.writeStringField('MILESTONE_DESC',milestone.Name!=null?milestone.Name:'');
                                         	jsonGenerator1.writeStringField('PERCENTAGE',milestone.Milestone_age__c!=null?string.valueOf(milestone.Milestone_age__c.setScale(2)):'');
                                         	jsonGenerator1.writeStringField('AMOUNT',milestone.Milestone_Amount1__c!=null?string.valueOf(milestone.Milestone_Amount1__c.setScale(2)):'');
                                            if(milestone.Sequence_No__c == 1){
                                                 jsonGenerator1.writeStringField('PAYMENT_TERM','Z030');
                                            }
                                            else if(milestone.Payment_Term_Code__c != null && milestone.Sequence_No__c != 1){
                                                 jsonGenerator1.writeStringField('PAYMENT_TERM',milestone.Payment_Term_Code__c);
                                            }
                                         	else{
                                                jsonGenerator1.writeStringField('PAYMENT_TERM','');
                                         	}
                                         jsonGenerator1.writeEndObject();
                                     }
                                     jsonGenerator1.writeEndArray();
                                     jsonGenerator1.writeEndObject();
                                     jsonGenerator1.writeEndObject();
                                     jsonGenerator1.writeEndObject();
                                     jsonGeneratorList.add(jsonGenerator1);
                                 }
                                 
                             }
                }
            }
            /*else if(operationType == 'D'){
                for(Booking__c book:[Select Id,Name,Sap_Code__c,(Select Id,Name,Sequence_No__c,Milestone_age__c,Milestone_Amount1__c,
                                    Sap_Code__c,Invoice_Date__c,Booking__c,Booking__r.Sap_Code__c,Deletion_SAP_Exposed__c,Due_Date__c
                                    from Payment_Milestones__r ORDER BY Sequence_No__c),
                                    (Select Id,Role__c,Sap_Code__c from Co_Applicant__r where Role__c = 'Primary' limit 1)
                                    from Booking__c where Id =:bookingId ALL ROWS]){
                             
                             String customerCode;
                             if(book.Co_Applicant__r != null){
                                 customerCode = book.Co_Applicant__r[0].Sap_Code__c;
                             }
                             if(book != null){
                                 if(book.Payment_Milestones__r != null){
                                     JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
                                     jsonGenerator1.writeStartObject();
                                     jsonGenerator1.writeFieldName('ZSD019_SFDC_BILL_PLAN_MANAGE');
                                     jsonGenerator1.writeStartObject();
                                     jsonGenerator1.writeFieldName('BILL_PLAN');
                                     jsonGenerator1.writeStartObject();
                                     jsonGenerator1.writeFieldName('item');
                                     jsonGenerator1.writeStartArray();
                                     for(Payment_Milestones__c milestone:book.Payment_Milestones__r){
                                             if(milestone.Id==currentMilestoneId){
                                                 milestoneProcessed.add(milestone.Id);
                                             }
                                             jsonGenerator1.writeStartObject();
                                             jsonGenerator1.writeStringField('SFDC_ID',milestone.Id!=null?string.valueOf(milestone.Id):'');
                                             jsonGenerator1.writeStringField('INDI',milestone.Deletion_SAP_Exposed__c!=null?milestone.Deletion_SAP_Exposed__c:'');
                                             jsonGenerator1.writeStringField('SALESORDER',milestone.Booking__r.Sap_Code__c);
                                             jsonGenerator1.writeStringField('SEQUENCE',milestone.Sequence_No__c!=null?string.valueOf(milestone.Sequence_No__c):'');
                                             jsonGenerator1.writeStringField('CUSTOMER_CODE',customerCode!=null?customerCode:'');
                                             jsonGenerator1.writeStringField('MILESTONE_CODE',milestone.Sap_Code__c!=null?milestone.Sap_Code__c:'');
                                             jsonGenerator1.writeStringField('MILESTONE_DATE',milestone.Invoice_Date__c!=null?String.valueOf(milestone.Invoice_Date__c.day()+'.'+milestone.Invoice_Date__c.month()+'.'+milestone.Invoice_Date__c.year()):'');
                                             jsonGenerator1.writeStringField('MILESTONE_DESC',milestone.Name!=null?milestone.Name:'');
                                             jsonGenerator1.writeStringField('PERCENTAGE',milestone.Milestone_age__c!=null?string.valueOf(milestone.Milestone_age__c):'');
                                             jsonGenerator1.writeStringField('AMOUNT',milestone.Milestone_Amount1__c!=null?string.valueOf(milestone.Milestone_Amount1__c.setScale(2)):'');
                                             jsonGenerator1.writeStringField('PAYMENT_TERM',milestone.Due_Date__c!=null?String.valueOf(milestone.Due_Date__c.day()+'.'+milestone.Due_Date__c.month()+'.'+milestone.Due_Date__c.year()):'');
                                             jsonGenerator1.writeEndObject();
                                     }
                                     jsonGenerator1.writeEndArray();
                                     jsonGenerator1.writeEndObject();
                                     jsonGenerator1.writeEndObject();
                                     jsonGenerator1.writeEndObject();
                                     jsonGeneratorList.add(jsonGenerator1);
                                 }
                                 
                             }
                }
            }*/
            if(jsonGeneratorList.size()>0){
                String jsonString = '';
                for (JSONGenerator generator : jsonGeneratorList) {
                    jsonString += generator.getAsString();
                }
                system.debug('jsonString--> '+jsonString);
                getSapCodes(jsonString,milestoneProcessed);
            } 
        }
        catch (Exception e) {
            System.debug('Exception:Number>> ' + e.getLineNumber());
            System.debug('Exception: ' + e.getMessage());
        }
    }
    
    public static String getSapCodes( String jsonString,Set<String>milestoneProcessed){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        request.setEndpoint('callout:SAP_PaymentMilestone');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', System.Label.AuthorizationHeader);
        request.setBody(jsonString);
        
        try {
            response = http.send(request);
            ResponseAPIClass.getResponse(response);
            List<Data_Sync__c> DSToUpdate = new List<Data_Sync__c>();
            if (response.getStatusCode() == 200 ||response.getStatusCode() == 201) {
                String responseBody = response.getBody();
                
                if(milestoneProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c where RecordId__c IN :milestoneProcessed AND Status__c = 'Pending']){
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
                if(milestoneProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c  where RecordId__c IN :milestoneProcessed AND Status__c = 'Pending']){
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
        public string bookingId;
        @InvocableVariable (required=true)
        public string currentMilestoneId;
        @InvocableVariable (required=true)
        public string operationType;
    }
}