public with sharing class calloutBookingCreation{
    @InvocableMethod
    public static void getBooking(List<request> reqList){
        System.debug('reqList'+reqList);
        if(reqList != null){
            System.debug('reqList[0].bookingIds'+reqList[0].bookingIds);
            exposeBookingToSAP(reqList[0].bookingIds);
        }
    }
    @future(Callout=true)
    public static void exposeBookingToSAP(String bookingIds){
        //try{
        Map<String,List<Payment_Milestones__c>> paymentMilestoneMap = new Map<String,List<Payment_Milestones__c>>();
        Map<String,List<Booking_Line_Items__c>> bukingLineItemMap = new Map<String,List<Booking_Line_Items__c>>();
        Map<String,Booking__c> bukMap = new Map<String,Booking__c>();
        Map<String,Co_Applicant__c> primaryCoapplicant = new Map<String,Co_Applicant__c>();
        Set<String> bookingProcessed = new Set<String>();
        Set<string> bookingIdFromDataSync = new Set<string>();
        Set<String> projectAddonIds = new Set<String>();
        Set<String> propertyPriceSlab = new Set<String>();
        Map<String,Price_Details__c> pdMapCarParking = new Map<String,Price_Details__c>();
        Map<String,Price_Details__c> pdMapBrokerage = new Map<String,Price_Details__c>();
        Map<String,Price_Details__c> pdMapStampDuty = new Map<String,Price_Details__c>();
        List<Price_Details__c> priceDetailList = new List<Price_Details__c>();
        
        
        Map<String,List<Price_Details__c>> priceDetailMap = new Map<String,List<Price_Details__c>>();
        for (Data_Sync__c dataSync:[Select Id,Event_Type__c,RecordId__c, Status__c from Data_Sync__c where Status__c ='Pending' and RecordId__c =:bookingIds]){
            bookingIdFromDataSync.add(dataSync.RecordId__c);
            system.debug('dataSync--'+dataSync.RecordId__c);
        }
        Map<String,PriceDetailComponent__mdt> priceMetaData = new Map<String,PriceDetailComponent__mdt>();
        for(PriceDetailComponent__mdt mt:[Select id,Label,key__c,DeveloperName,Charge_Name__c From PriceDetailComponent__mdt]){
            priceMetaData.put(mt.Label.toUpperCase(),mt);
        }
        
        if(bookingIdFromDataSync!=null){
            for(Booking__c bukList:[
                Select id,Name,Booking_Date__c,Project_Name__r.Project_SAP_Code__c,Loan_Sanction_Amount__c,
                Related_Suggested_Property__r.Discount__c,Discount__c,
                Sales_Manager__r.Name,Related_Opportunity__r.No_of_Parking_s_Spots_Required__c,
                Bank_Approved_ROC__c,Channel_Partner__r.Partner_Id__c,
                (Select Id,Booking__c,Amount__c,Discount__c,Name,Charge_Group__c 
                 From Price_Details__r),
                Related_Suggested_Property__r.Unit__c,
                Related_Suggested_Property__r.Unit__r.SAP_Code__c,Related_Suggested_Property__r.Unit__r.Property_Price_Slab__c,
                (Select id,Name,Booking__c,Milestone_Amount__c,Sequence_No__c,Invoice_Date__c,
                 Project_Progress__c,Milestone_Activation_Date__c,Milestone_Master__r.Sap_Code__c,
                 Sap_Code__c,Milestone_age__c,Milestone_Amount1__c,Payment_Term_Code__c 
                 From Payment_Milestones__r 
                 Where Name !='Possession/Handover(Other) Charge'),
                (Select id,Name,Property__c,Booking__c,Sap_Code__c,Project_Add_On_Charges__c 
                 From Booking_Line_Items__r
                ),Payment_Plan__c,
                (Select id,Account_Name__c,Booking__c,Sap_Code__c,Role__c
                 From Co_Applicant__r 
                 Where Role__c ='Primary'),
                Project_Name__r.Project_Type__c,Channel_Partner__c,Stamp_Duty_Status__c,
                Agreement_Date__c,Source_of_Finance__c,
                Primary_Loan_Details__r.Home_LoanInstitution__r.Name,
                Tower_Name__r.Tower_SAP_Code__c,Source_of_Booking__c 
                From Booking__c 
                Where id =:bookingIdFromDataSync AND Sap_Code__c =null
            ])
            {
                system.debug('buking record...'+bukList);
                propertyPriceSlab.add(bukList.Related_Suggested_Property__r.Unit__r.Property_Price_Slab__c);
                bukMap.put(bukList.id,bukList);
                if(bukList.Payment_Milestones__r !=null){
                    if(!paymentMilestoneMap.containsKey(bukList.Id)){
                        List<Payment_Milestones__c> pmilestone = new List<Payment_Milestones__c>();
                        pmilestone.addAll(bukList.Payment_Milestones__r);
                        paymentMilestoneMap.put(bukList.Id,pmilestone);
                    }else{
                        paymentMilestoneMap.get(bukList.Id).addAll(bukList.Payment_Milestones__r);
                    }
                }
                if(bukList.Price_Details__r !=null){
                    for(Price_Details__c pd:bukList.Price_Details__r){
                        system.debug('Charge_Group__c..'+pd.Charge_Group__c);
                        if(pd.Charge_Group__c == 'Others'){
                            if(priceDetailMap.containsKey(pd.Booking__c)){
                                priceDetailMap.get(pd.Booking__c).add(pd);
                            }else{
                                priceDetailMap.put(pd.Booking__c,new List<Price_Details__c>{pd});    
                            }
                            system.debug('priceDetailMap..'+priceDetailMap);
                        }else if(pd.Name == 'Car Parking Space'){
                            pdMapCarParking.put(pd.Booking__c,pd);
                        }else if(pd.Name == 'Brokerage'){
                            pdMapBrokerage.put(pd.Booking__c,pd);
                        }
                        else if(pd.Charge_Group__c == 'Stamp Duty'){
                            pdMapStampDuty.put(pd.Booking__c,pd);
                        }
                    }
                }
                
            }
            
            for(Co_Applicant__c coapp:[Select id,Account_Name__c,Booking__c,Sap_Code__c,Role__c
                                       From Co_Applicant__c Where Role__c ='Primary' AND Booking__c IN:bookingIdFromDataSync]){
                                           if(coapp !=null){
                                               primaryCoapplicant.put(coapp.Booking__c,coapp);
                                           }
                                       }
        }
        String CoapplicantSapCode;
        List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
        system.debug('bukMap;;;'+bukMap);
        if(bukMap!=null){
            for(String buk:bukMap.keyset()){
                bookingProcessed.add(buk);
                JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
                Booking__c buking = bukMap.get(buk);
                
                jsonGenerator1.writeStartObject();
                jsonGenerator1.writeFieldName('ZSD018_SFDC_SALES_ORDER');
                system.debug('ZSD018_SFDC_SALES_ORDER');
                jsonGenerator1.writeStartObject();
                jsonGenerator1.writeFieldName('ORDER_HEADER');
                jsonGenerator1.writeStartObject();
                jsonGenerator1.writeStringField('SFDC_ID',buking.id);
                system.debug('SFDC_ID'+buking.id);
                jsonGenerator1.writeStringField('VKORG',buking.Project_Name__r !=null ? buking.Project_Name__r.Project_SAP_Code__c!=null?buking.Project_Name__r.Project_SAP_Code__c:'':'');
                system.debug('SFDC_ID1'+buking.Project_Name__r.Project_SAP_Code__c);
                jsonGenerator1.writeStringField('VTWEG',buking.Project_Name__r !=null ? buking.Project_Name__r.Project_Type__c !=null?buking.Project_Name__r.Project_Type__c:'':'');
                jsonGenerator1.writeStringField('VKBUR',buking.Tower_Name__r !=null ?buking.Tower_Name__r.Tower_SAP_Code__c !=null ?buking.Tower_Name__r.Tower_SAP_Code__c:'':'');
                system.debug('SFDC_ID12');
                jsonGenerator1.writeStringField('BOOK_SOURCE',buking.Source_of_Booking__c !=null ?buking.Source_of_Booking__c :'');
                jsonGenerator1.writeStringField('KUNNR',buking.Co_Applicant__r[0].Sap_Code__c !=null ?buking.Co_Applicant__r[0].Sap_Code__c:'' );
                jsonGenerator1.writeStringField('BSTKD',buking.Name);
                jsonGenerator1.writeStringField('ZZBOOK_DT',buking.Booking_Date__c !=null ?dateFormat(string.valueOf(buking.Booking_Date__c)):'');
                jsonGenerator1.writeStringField('SALE_EMP',buking.Sales_Manager__r!=null ?buking.Sales_Manager__r.Name!=null ?buking.Sales_Manager__r.Name:'':'');
                system.debug('SFDC_ID1234');
                jsonGenerator1.writeStringField('BROKER',buking.Channel_Partner__c !=null && buking.Channel_Partner__r.Partner_Id__c != null?buking.Channel_Partner__r.Partner_Id__c :'');//buking.Channel_Partner__c !=null ?buking.Channel_Partner__c:''-SAP CODE
                system.debug('SFDC_ID123456');
                jsonGenerator1.writeStringField('PAY_PLAN',buking.Payment_Plan__c !=null ?buking.Payment_Plan__c:'');//
                jsonGenerator1.writeStringField('ZZSTM_PAID_BY',buking.Stamp_Duty_Status__c !=null ? buking.Stamp_Duty_Status__c:'');
                jsonGenerator1.writeStringField('ZZAGRMT_DT',buking.Agreement_Date__c!=null ?dateFormat(string.valueOf(buking.Agreement_Date__c)):'');
                jsonGenerator1.writeStringField('ZZOCCP_CERT_DT','');
                jsonGenerator1.writeStringField('ZZPAY_MODE',buking.Source_of_Finance__c!=null ?buking.Source_of_Finance__c:'');
                jsonGenerator1.writeStringField('ZZLOAN_BD',buking.Primary_Loan_Details__r!=null ?buking.Primary_Loan_Details__r.Home_LoanInstitution__r!= null?buking.Primary_Loan_Details__r.Home_LoanInstitution__r.Name:'':'');
                jsonGenerator1.writeStringField('ZZLOAN_AMT',buking.Loan_Sanction_Amount__c !=null ? string.valueOf(buking.Loan_Sanction_Amount__c):'');
                jsonGenerator1.writeStringField('ZZLOAN_FILE_NO','');
                jsonGenerator1.writeStringField('ZZLOAN_PER_AGRM','');
                jsonGenerator1.writeStringField('ZZSANCTION_DT','');
                jsonGenerator1.writeStringField('ZZBRK_PERC','');
                jsonGenerator1.writeStringField('ZZCARPARK_ALT',buking.Related_Opportunity__r!=null ?buking.Related_Opportunity__r.No_of_Parking_s_Spots_Required__c!=null ?string.valueOf(buking.Related_Opportunity__r.No_of_Parking_s_Spots_Required__c):'':'');
                jsonGenerator1.writeStringField('ZZCARPART_SLOT','');
                jsonGenerator1.writeStringField('ZZCARPARK_TP','');
                jsonGenerator1.writeEndObject();
                jsonGenerator1.writeFieldName('ORDER_ITEM');
                jsonGenerator1.writeStartObject();
                jsonGenerator1.writeFieldName('item');
                jsonGenerator1.writeStartArray();
                if(priceDetailMap.containsKey(buking.Id)){
                    Integer index=1;
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeStringField('POSNR',string.valueOf(index));
                    jsonGenerator1.writeStringField('MATNR',buking.Related_Suggested_Property__r!=null?buking.Related_Suggested_Property__r.Unit__r!=null ?buking.Related_Suggested_Property__r.Unit__r.SAP_Code__c!=null? buking.Related_Suggested_Property__r.Unit__r.SAP_Code__c:'':'':'');
                    String priceCode; 
                    if(pdMapCarParking.containsKey(buking.Id)){
                        String BukName = pdMapCarParking.get(buking.Id).Name.toUpperCase();
                        if(priceMetaData.containsKey(BukName)){
                            priceCode=priceMetaData.get(BukName).Key__c;
                        }
                    }
                    jsonGenerator1.writeStringField('KSCHL1',priceCode !=null ? priceCode:'');
                    Decimal priceAmount=0;
                    if(pdMapCarParking.containsKey(buking.Id)){
                        priceAmount = pdMapCarParking.get(buking.Id).Amount__c; 
                    }
                    
                    jsonGenerator1.writeStringField('KWERT1',priceAmount !=0 ? string.valueOf(priceAmount):'');
                    String pCode1;
                    if(pdMapBrokerage.containsKey(buking.Id)){
                        String BukName1 = pdMapBrokerage.get(buking.Id).Name;
                        if(priceMetaData.containsKey(BukName1)){
                            pCode1=priceMetaData.get(BukName1).Key__c;
                        }
                    }
                    
                    jsonGenerator1.writeStringField('KSCHL2',pCode1!=null ?pCode1:'');
                    Decimal priceAmnt1;
                    if(pdMapBrokerage.containsKey(buking.Id)){
                        priceAmnt1=pdMapBrokerage.get(buking.Id).Amount__c;
                    }
                    jsonGenerator1.writeStringField('KWERT2',priceAmnt1!=null ?string.valueOf(priceAmnt1):'');
                    String priceCode3;
                    if(buking.Discount__c!=null && buking.Discount__c!=0){
                        priceCode3=priceMetaData.get('DISCOUNT').Key__c;
                    }
                    jsonGenerator1.writeStringField('KSCHL3',priceCode3 !=null ?priceCode3:'');
                    Decimal priceAmount2;
                    if(buking.Discount__c !=null && buking.Discount__c!=0){
                        priceAmount2=buking.Discount__c;
                    }
                    jsonGenerator1.writeStringField('KWERT3',priceAmount2!=null ?string.valueOf('-'+priceAmount2):'');
                    String priceCode4;
                    if(pdMapStampDuty.containsKey(buking.Id)){
                        String BukName4 = pdMapStampDuty.get(buking.Id).Name;
                        priceCode4 = priceMetaData.get(BukName4.toUpperCase()).Key__c;
                    }
                    jsonGenerator1.writeStringField('KSCHL4',priceCode4 !=null ?priceCode4:'');
                    Decimal priceAmount4;
                    if(pdMapStampDuty.containsKey(buking.Id)){
                        priceAmount4=pdMapStampDuty.get(buking.Id).Amount__c;
                    }
                    jsonGenerator1.writeStringField('KWERT4',priceAmount4!=null ?string.valueOf(priceAmount4):'');
                    jsonGenerator1.writeStringField('KSCHL5','');
                    jsonGenerator1.writeStringField('KWERT5','');
                    jsonGenerator1.writeEndObject();
                    Integer indexxx=2;
                    for(Price_Details__c bukLine:priceDetailMap.get(buking.Id)){
                        
                        jsonGenerator1.writeStartObject();
                        jsonGenerator1.writeStringField('POSNR',string.valueOf(indexxx));
                        String MatnrName;
                        if(priceMetaData.containskey(bukLine.Name.toUpperCase())){
                            MatnrName=priceMetaData.get(bukLine.Name.toUpperCase()).Charge_Name__c;
                        }
                        jsonGenerator1.writeStringField('MATNR',MatnrName!=null ? MatnrName.toUpperCase():'');
                        String priceCode1;
                        if(priceMetaData.containskey(bukLine.Name.toUpperCase())){
                            priceCode1=priceMetaData.get(bukLine.Name.toUpperCase()).Key__c;
                        }
                        jsonGenerator1.writeStringField('KSCHL1',priceCode1 !=null ? priceCode1:'');
                        jsonGenerator1.writeStringField('KWERT1',string.valueOf(bukLine.Amount__c));//bukLine.Amount__c !=0 || bukLine.Amount__c !=null ? string.valueOf(bukLine.Amount__c):
                        jsonGenerator1.writeStringField('KSCHL2','');
                        jsonGenerator1.writeStringField('KWERT2','');
                        jsonGenerator1.writeStringField('KSCHL3','');
                        jsonGenerator1.writeStringField('KWERT3','');
                        jsonGenerator1.writeStringField('KSCHL4','');
                        jsonGenerator1.writeStringField('KWERT4','');
                        jsonGenerator1.writeStringField('KSCHL5','');
                        jsonGenerator1.writeStringField('KWERT5','');
                        jsonGenerator1.writeEndObject();
                        indexxx++;
                    }
                }
                jsonGenerator1.writeEndArray();
                jsonGenerator1.writeEndObject();
                jsonGenerator1.writeFieldName('BILL_PLAN');
                jsonGenerator1.writeStartObject();
                jsonGenerator1.writeFieldName('item');
                jsonGenerator1.writeStartArray();
                if(paymentMilestoneMap.containsKey(buking.Id)){
                    for(Payment_Milestones__c pm:paymentMilestoneMap.get(buking.Id)){
                        jsonGenerator1.writeStartObject();
                        jsonGenerator1.writeStringField('SEQUENCE',pm.Sequence_No__c!=null ?string.valueOf(pm.Sequence_No__c):'');
                        jsonGenerator1.writeStringField('CUSTOMER_CODE',buking.Co_Applicant__r[0].Sap_Code__c !=null ?buking.Co_Applicant__r[0].Sap_Code__c:'');
                        jsonGenerator1.writeStringField('MILESTONE_CODE',pm.Sap_Code__c !=null ?pm.Sap_Code__c:
                                                        pm.Milestone_Master__r.Sap_Code__c!=null?pm.Milestone_Master__r.Sap_Code__c:'');
                        if(pm.Project_Progress__c == null){
                            Date mileDate = pm.Milestone_Activation_Date__c;
                            String formattedDay = (mileDate.day() < 10) ? '0' + String.valueOf(mileDate.day()) : String.valueOf(mileDate.day());
                            String formattedMonth = (mileDate.month() < 10) ? '0' + String.valueOf(mileDate.month()) : String.valueOf(mileDate.month());
                            String milestoneDate = formattedDay + '.' + formattedMonth + '.' + mileDate.year();
                            jsonGenerator1.writeStringField('MILESTONE_DATE',milestoneDate!=null?String.valueOf(milestoneDate):'');
                        }
                        else{
                            jsonGenerator1.writeStringField('MILESTONE_DATE',pm.Invoice_Date__c !=null ?dateFormat(string.valueOf(pm.Invoice_Date__c)):'');
                        }
                        jsonGenerator1.writeStringField('MILESTONE_DESC',pm.Name!=null ?pm.Name:'');
                        jsonGenerator1.writeStringField('PERCENTAGE',pm.Milestone_age__c !=null ? string.valueOf(pm.Milestone_age__c):'');
                        jsonGenerator1.writeStringField('AMOUNT',pm.Milestone_Amount1__c !=null ? string.valueOf(pm.Milestone_Amount1__c.setscale(2)):'');
                        if(pm.Sequence_No__c == 1){
                            jsonGenerator1.writeStringField('PAYMENT_TERM','Z030');
                        }
                        else if(pm.Payment_Term_Code__c != null && pm.Sequence_No__c != 1){
                            jsonGenerator1.writeStringField('PAYMENT_TERM',pm.Payment_Term_Code__c);
                        }
                        else{
                            jsonGenerator1.writeStringField('PAYMENT_TERM','');
                        }
                        jsonGenerator1.writeEndObject();
                    }
                }
                jsonGenerator1.writeEndArray();
                jsonGenerator1.writeEndObject();
                jsonGeneratorList.add(jsonGenerator1);
            }
        }
        system.debug('jsonGeneratorList---'+jsonGeneratorList);
        if(jsonGeneratorList.size()>0){
            String jsonString = '';
            for (JSONGenerator generator : jsonGeneratorList) {
                jsonString += generator.getAsString();
            }
            system.debug('jsonString--> '+jsonString);
            getSapCodes(jsonString,bookingProcessed);
        } 
        /* }catch(Exception e){
System.debug('Exception: ' + e.getMessage());
System.debug('Exception:Number>> ' + e.getLineNumber());
}*/
    }
    
    public static String getSapCodes( String jsonString,Set<String>bookingProcessed){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        request.setEndpoint('callout:Sap_Callout');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic UzAwMjQzMDI0NDA6Umlja3lAOTk2OQ==');
        request.setBody(jsonString);
        request.setTimeout(120000);
        
        try {
            response = http.send(request);
            ResponseAPIClass.getResponse(response);
            List<Data_Sync__c> DSToUpdate = new List<Data_Sync__c>();
            if (response.getStatusCode() == 200 ||response.getStatusCode() == 201) {
                String responseBody = response.getBody();
                
                if(bookingProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c where RecordId__c IN :bookingProcessed AND Status__c = 'Pending']){
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
                if(bookingProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c  where RecordId__c IN :bookingProcessed AND Status__c = 'Pending']){
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
    public static string dateFormat(string str){
        
        String dateFull  = String.valueOf(str);
        String[] demandDate     = dateFull.split('-');
        String yyyy = demandDate[0]; 
        String mm = demandDate[1]; 
        String dd = demandDate[2];
        string demandcreateDate = dd+'.'+mm+'.'+yyyy;
        return demandcreateDate;
    }
    public class request{
        @InvocableVariable (required=true)
        public string bookingIds;
    }
}