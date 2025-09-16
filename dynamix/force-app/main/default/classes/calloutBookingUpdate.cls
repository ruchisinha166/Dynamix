public with sharing class calloutBookingUpdate {
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
       // try{
            
            Set<String> bookingProcessed = new Set<String>();
            Map<String,Booking__c> bukMap = new Map<String,Booking__c>();
            Set<string> bookingIdFromDataSync = new Set<string>();
            for (Data_Sync__c dataSync:[Select Id,Event_Type__c,RecordId__c, Status__c from Data_Sync__c where Status__c ='Pending' and RecordId__c =:bookingIds]){
                bookingIdFromDataSync.add(dataSync.RecordId__c);
            }
            if(bookingIdFromDataSync!=null){
                for(Booking__c bukList:[Select Id,Name,Booking_Date__c,Project_Name__r.Project_SAP_Code__c,Loan_Sanction_Amount__c,
                                        Related_Suggested_Property__r.Unit__r.Parking_Type__c,Related_Opportunity__r.No_of_Parking_s_Spots_Required__c,
                                        Related_Suggested_Property__r.Unit__r.SAP_Code__c,Sap_Code__c,NOC_Uploaded_Date__c,Brokerage_Percentage__c,
                                        Cancellation_Reasons__c,Sales_Manager__r.Name,Stamp_Duty_Date__c,Allotment_Letter_Generation_Date__c,
                                        Cancel_or_Termination_date__c,Bank_Approved_ROC__c,Possession_Date__c,
                                        (SELECT Id,Booking__r.Name,Home_LoanInstitution__r.Name,Sanction_Amount__c, 
                                         Sanction_Letter_No_File_Number__c,Sanction_percentage_of_AV__c,
                                         Sanction_Letter_Date__c From Bank_Loan_Details__r),
                                        (Select id,Name,Property__c,Booking__c,Sap_Code__c,Project_Add_On_Charges__c 
                                         From Booking_Line_Items__r),Stamp_Duty_Status__c,Registration_Date__c,
                                        Project_Name__r.Project_Type__c,Channel_Partner__r.Name,Related_Suggested_Property__r.Unit__r.Index__c,
                                        Agreement_Date__c,Source_of_Finance__c,Registration_Number__c,Confirmation_Deed_Reg_Challan_No__c,
                                        Primary_Loan_Details__r.Home_LoanInstitution__r.Name,
                                        Tower_Name__r.Tower_SAP_Code__c,Source_of_Booking__c,
                                        ROC_Uploaded_Date__c From Booking__c 
                                        Where id =:bookingIdFromDataSync AND Sap_Code__c !=null
                                       ]){
                                           bukMap.put(bukList.id,bukList);
                                       }
            }
            List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
            if(bukMap!=null){
                for(String buk:bukMap.keyset()){
                    bookingProcessed.add(buk);
                    JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
                    Booking__c buking = bukMap.get(buk);
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('ZSD018_SFDC_SALES_ORDER_CHANGE');
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeFieldName('ORDER_HEADER');
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeStringField('SFDC_ID',buking.id);
                    jsonGenerator1.writeStringField('VBELN',buking.Sap_Code__c !=null ?buking.Sap_Code__c:'');
                    jsonGenerator1.writeStringField('ABGRU',buking.Cancellation_Reasons__c !=null ?buking.Cancellation_Reasons__c:'');
                    jsonGenerator1.writeStringField('POSNR','');//string.valueOf(buking.Booking_Line_Items__r.size()+1)
                    jsonGenerator1.writeStringField('MATNR','');//buking.Related_Suggested_Property__r!=null?buking.Related_Suggested_Property__r.Unit__r!=null ?buking.Related_Suggested_Property__r.Unit__r.SAP_Code__c!=null? buking.Related_Suggested_Property__r.Unit__r.SAP_Code__c:'':'':''
                    jsonGenerator1.writeStringField('SALE_EMP',buking.Sales_Manager__r!=null ?buking.Sales_Manager__r.Name!=null ?buking.Sales_Manager__r.Name:'':'');
                    jsonGenerator1.writeStringField('BROKER',buking.Channel_Partner__r !=null ? buking.Channel_Partner__r.Name!=null ?buking.Channel_Partner__r.Name:'':'');
                    jsonGenerator1.writeStringField('ZZBOOK_DT',buking.Booking_Date__c !=null ?dateFormat(string.valueOf(buking.Booking_Date__c)):'');
                    jsonGenerator1.writeStringField('ZZSTM_REG_PD',buking.Stamp_Duty_Date__c !=null ?dateFormat(string.valueOf(buking.Stamp_Duty_Date__c)):'');
                    jsonGenerator1.writeStringField('ZZSTM_PAID_BY',buking.Stamp_Duty_Status__c!=null ?buking.Stamp_Duty_Status__c:'');
                    jsonGenerator1.writeStringField('ZZREG_DT',buking.Registration_Date__c !=null ?dateFormat(string.valueOf(buking.Registration_Date__c)):'');
                    jsonGenerator1.writeStringField('ZZREG_SR_NO',buking.Registration_Number__c !=null ?buking.Registration_Number__c:'');
                    jsonGenerator1.writeStringField('ZZREG_RECP_NO',buking.Confirmation_Deed_Reg_Challan_No__c !=null ?buking.Confirmation_Deed_Reg_Challan_No__c:'');
                    jsonGenerator1.writeStringField('ZZROC_ST',buking.Bank_Approved_ROC__c ?'X':'');
                    jsonGenerator1.writeStringField('ZZRROC_DT',buking.ROC_Uploaded_Date__c !=null ?dateFormat(string.valueOf(buking.ROC_Uploaded_Date__c)):'');
                    jsonGenerator1.writeStringField('ZZAGRMT_DT',buking.Agreement_Date__c!=null ? dateFormat(string.valueOf(buking.Agreement_Date__c)):'');
                    jsonGenerator1.writeStringField('ZZMKT_VAL',buking.Related_Suggested_Property__r!=null ?buking.Related_Suggested_Property__r.Unit__r!=null ?buking.Related_Suggested_Property__r.Unit__r.Index__c!=null ?string.valueOf(buking.Related_Suggested_Property__r.Unit__r.Index__c):'':'':'');
                    jsonGenerator1.writeStringField('ZZALOT_LTR_DT',buking.Allotment_Letter_Generation_Date__c !=null ?dateFormat(string.valueOf(buking.Allotment_Letter_Generation_Date__c)):'');
                    jsonGenerator1.writeStringField('ZZAGR_POSS_DT',buking.Possession_Date__c!=null ?dateFormat(string.valueOf(buking.Possession_Date__c)):'');
                    jsonGenerator1.writeStringField('ZZPOSS_STR_DT','');
                    jsonGenerator1.writeStringField('ZZPOSS_END_DT','');
                    jsonGenerator1.writeStringField('ZZKEY_HDOVR_DT','');
                    jsonGenerator1.writeStringField('ZZOCCP_CERT_DT','');
                    jsonGenerator1.writeStringField('ZZPAY_MODE',buking.Source_of_Finance__c!=null ?buking.Source_of_Finance__c:'');
                    String bankName;
                    if(!buking.Bank_Loan_Details__r.isEmpty()){
                        if(buking.Bank_Loan_Details__r[0].Home_LoanInstitution__r.Name !=null){
                           bankName =  buking.Bank_Loan_Details__r[0].Home_LoanInstitution__r.Name;
                        }else{
                            bankName = '';
                        }
                    }else{
                            bankName = '';
                        }
                    jsonGenerator1.writeStringField('ZZLOAN_BD',bankName);
                    String bankSanctionAmount;
                    if(!buking.Bank_Loan_Details__r.isEmpty()){
                        if(buking.Bank_Loan_Details__r[0].Sanction_Amount__c !=null){
                           bankSanctionAmount = string.valueOf(buking.Bank_Loan_Details__r[0].Sanction_Amount__c);
                        }else{
                            bankSanctionAmount = '';
                        }
                    }else{
                            bankSanctionAmount = '';
                        }
                    jsonGenerator1.writeStringField('ZZLOAN_AMT',bankSanctionAmount);
                    String bankFileNumber;
                    if(!buking.Bank_Loan_Details__r.isEmpty()){
                        if(buking.Bank_Loan_Details__r[0].Sanction_Letter_No_File_Number__c !=null){
                           bankFileNumber = buking.Bank_Loan_Details__r[0].Sanction_Letter_No_File_Number__c;
                        }else{
                            bankFileNumber = '';
                        }
                    }else{
                            bankFileNumber = '';
                        }
                    jsonGenerator1.writeStringField('ZZLOAN_FILE_NO',bankFileNumber);
                    String bankLoanPercentage;
                    if(!buking.Bank_Loan_Details__r.isEmpty()){
                        if(buking.Bank_Loan_Details__r[0].Sanction_percentage_of_AV__c !=null){
                           bankLoanPercentage = string.valueOf(buking.Bank_Loan_Details__r[0].Sanction_percentage_of_AV__c);
                        }else{
                            bankLoanPercentage = '';
                        }
                    }else{
                            bankLoanPercentage = '';
                        }
                    jsonGenerator1.writeStringField('ZZLOAN_PER_AGRM',bankLoanPercentage);
                    String loanSanctionDate;
                    if(!buking.Bank_Loan_Details__r.isEmpty()){
                        if(buking.Bank_Loan_Details__r[0].Sanction_Letter_Date__c !=null){
                            loanSanctionDate = dateFormat(string.valueOf(buking.Bank_Loan_Details__r[0].Sanction_Letter_Date__c));
                        }else{
                            loanSanctionDate = '';
                        }
                    }else{
                            loanSanctionDate = '';
                        }
                    jsonGenerator1.writeStringField('ZZSANCTION_DT',loanSanctionDate);
                    jsonGenerator1.writeStringField('ZZNOC_ISS_DT',buking.NOC_Uploaded_Date__c !=null ?dateFormat(string.valueOf(buking.NOC_Uploaded_Date__c)):'');
                    jsonGenerator1.writeStringField('ZZBRK_BILL_REC','');
                    jsonGenerator1.writeStringField('ZZBRK_BILL_PRC','');
                    jsonGenerator1.writeStringField('ZZ_BRK_BILL_PAID','');
                    jsonGenerator1.writeStringField('ZZBRK_PERC',buking.Brokerage_Percentage__c !=null ?string.valueOf(buking.Brokerage_Percentage__c):'');
                    jsonGenerator1.writeStringField('ZZCARPARK_ALT',buking.Related_Opportunity__r!=null ?buking.Related_Opportunity__r.No_of_Parking_s_Spots_Required__c!=null ?string.valueOf(buking.Related_Opportunity__r.No_of_Parking_s_Spots_Required__c):'':'');
                    jsonGenerator1.writeStringField('ZZCARPART_SLOT','');// need to ask Preeti
                    jsonGenerator1.writeStringField('ZZCARPARK_TP',buking.Related_Suggested_Property__r!=null ?buking.Related_Suggested_Property__r.Unit__r!=null ?buking.Related_Suggested_Property__r.Unit__r.Parking_Type__c!=null ?buking.Related_Suggested_Property__r.Unit__r.Parking_Type__c:'':'':'');
                    jsonGenerator1.writeStringField('ZZCANL_DT',buking.Cancel_or_Termination_date__c!=null ?dateFormat(string.valueOf(buking.Cancel_or_Termination_date__c)):'');
                    jsonGenerator1.writeStringField('ZZCANL_INIT_BY','');
                    jsonGenerator1.writeStringField('ZZDEED_CANL_REG','');
                    jsonGenerator1.writeStringField('ZZTRF_NOC_DT',buking.NOC_Uploaded_Date__c!=null ?dateFormat(string.valueOf(buking.NOC_Uploaded_Date__c)):'');
                    jsonGenerator1.writeStringField('ZZNW_CUST_NM','');
                    jsonGenerator1.writeStringField('ZZNW_CUST_CD','');
                    jsonGenerator1.writeEndObject();
                    jsonGenerator1.writeEndObject();
                    jsonGenerator1.writeEndObject();
                    jsonGeneratorList.add(jsonGenerator1);
                }
            }
            if(jsonGeneratorList.size()>0){
                String jsonString = '';
                for (JSONGenerator generator : jsonGeneratorList) {
                    jsonString += generator.getAsString();
                }
                system.debug('jsonString--> '+jsonString);
                getSapCodes(jsonString,bookingProcessed);
            } 
     /*   }
        catch(Exception e){
            System.debug('Exception: ' + e.getMessage());
            System.debug('Exception:Number>> ' + e.getLineNumber());
        }*/
        
    }
    public static String getSapCodes( String jsonString,Set<string>bookingProcessed){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        request.setEndpoint('callout:Sap_BookingUpdate');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/json');
        request.setHeader('Authorization', System.Label.AuthorizationHeader);
        request.setBody(jsonString);
        //List<Pricing_Plan_Components__c> prPlanCompToUpdate = new List<Pricing_Plan_Components__c>();
        Set<String>propertyIds=new Set<String>();
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