@RestResource(urlMapping='/interest/*')
global class Get_Interest {
    @HttpGet
    global static Void getInterest() {
        RestResponse res = RestContext.response;
        try {
            List<Payment__c> paymentToUpdate=new List<Payment__c>();
            Map<String, Object> InterestObject = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
            Map<String, Object> innerBody = (Map<String, Object>)InterestObject.get('ZSD025_SFDC_INTEREST_LEDGER');
            Map<String, Object> customerheaderMap = (Map<String, Object>)innerBody.get('CUST_HEADER');
            Map<String, Object> internalMap = (Map<String, Object>)innerBody.get('CUST_PLAN');
            List<Object> itemList = (List<Object>)internalMap.get('item');
            
            if(!customerheaderMap.isEmpty()){
                String customerSAPCode = String.valueOf(customerheaderMap.get('KUNNR')); // customer Sap code
                String BookingSapCode = String.valueOf(customerheaderMap.get('VBELN')); //Booking SAP Code
                String INT_WO = String.valueOf(customerheaderMap.get('INT_WO')); //booking level, interest waived off //Hidden_Interest_Wave_Off_Amount__c
                String INT_REC = String.valueOf(customerheaderMap.get('INT_REC'));// booking level total interest Total_Interest_Received__c
                String INT_PEND = String.valueOf(customerheaderMap.get('INT_PEND')); // booking Total_interest_amount__c
                List<booking__c> bookingList=[Select id,Sap_Code__c,Hidden_Interest_Wave_Off_Amount__c,Total_Interest_Received__c,Total_interest_amount__c from booking__c where Sap_Code__c=:BookingSapCode LIMIT 1];
                List<booking__c> booking_toUpdate=new List<Booking__c>();
                if(bookingList.size()>0){
                    //booking__c bb=new Booking__c(); 
                    //bb.id=
                    bookingList[0].Hidden_Interest_Wave_Off_Amount__c=Decimal.valueOf(INT_WO);
                    //bookingList[0].Total_Interest_Received__c=0;
                    //bookingList[0].Total_interest_amount__c=0;
                    update bookingList;
                    Map<String,interestWrapper> Pmap=new Map<String,interestWrapper>();
                    
                    
                    //******update milestones
                    if(itemList.size()>0){
                        for (Object obj:itemList){
                            Map<String, Object> item = (Map<String, Object>)obj;
                            String milestoneSAPCode = String.valueOf(item.get('MILESTONE')); // Milestone Sap_Code__c
                            String MILE_DESC = String.valueOf(item.get('MILE_DESC')); // Milestone Name
                            String INVOICE = String.valueOf(item.get('INVOICE')); // SAP  demand SAP Code
                            String PAY_BY_DT = String.valueOf(item.get('PAY_BY_DT')); // due date demand can be discard
                            String REC_DT = String.valueOf(item.get('REC_DT')); //  leave it
                            String INT_RATE = String.valueOf(item.get('INT_RATE')); //  create a field  on Milestone to fetch interest rate Rate_of_Interest
                            String INT_AMT = String.valueOf(item.get('INT_AMT')); // milestone 's Interest_Amount__c
                            String INT_GST_AMT = String.valueOf(item.get('INT_GST_AMT'));// milestone Interest_on_GST__c
                            String INT_TOT = String.valueOf(item.get('INT_TOT')); // milestone Total_Interest_Due__c
                            
                            interestWrapper wr=new interestWrapper();
                            wr.InterestAmount=INT_AMT;
                            wr.Rate=INT_RATE;
                            wr.InterestGST=INT_GST_AMT;
                            wr.InterestTotal=INT_TOT;
                            wr.FromDate = PAY_BY_DT;
                            wr.toDate = REC_DT;
                            Pmap.put(milestoneSAPCode, wr);
                            
                        }
                        
                    }
                    Map<String, Payment_Milestones__c> PM_ToUpdate=new Map<String,Payment_Milestones__c>();
                    Map<String, Interest_Charged__c> InterestChargeInsert=new Map<String,Interest_Charged__c>();
                    List<Interest_Charged__c> interestChargeList = New List<Interest_Charged__c>();
                    List<Interest_Charged__c> inteCharge = New list<Interest_Charged__c>(); 
                    if(!Pmap.isEmpty()){
                        for(Payment_Milestones__c PM:[Select id,Sap_Code__c,Name,Rate_of_Interest__c,Interest_Amount__c,Interest_on_GST__c,Total_Interest_Due__c,Booking__r.Sap_Code__c ,
                                                      (SELECT ID,Milestone__c FROM Interest_Charged__r ) FROM Payment_Milestones__c where  Booking__r.Sap_Code__c =: BookingSapCode AND Sap_Code__c IN : Pmap.keySet()]){
                                                          
                                                          //inteCharge =  [SELECT ID,Milestone__c FROM Interest_Charged__c WHERE Milestone__c =:PM.iD Limit 1] ;                          
                                                          Payment_Milestones__c pp=new  Payment_Milestones__c();
                                                          Interest_Charged__c interestCharge = New Interest_Charged__c(); 
                                                          interestWrapper wr=Pmap.get(PM.Sap_Code__c);
                                                          if(wr !=null){                            
                                                              if(PM.Interest_Charged__r.size() > 0){
                                                                  Interest_Charged__c intch = PM.Interest_Charged__r[0];
                                                                  intch.Id=PM.Interest_Charged__r[0].id;
                                                                  intch.Interest_Rate__c=Decimal.valueOf(wr.Rate);
                                                                  intch.Interest_Amount__c=Decimal.valueOf(wr.InterestAmount);
                                                                  intch.Interest_Amount_GST__c=Decimal.valueOf(wr.InterestGST);
                                                                  intch.Intrest_calucation_Amount__c=Decimal.valueOf(wr.InterestTotal);
                                                                  system.debug('wr.FromDate--'+wr.FromDate);
                                                                  if(wr.FromDate != null && wr.FromDate != ''){
                                                                      intch.From_Date__c = Date.valueOf(dateFormat(wr.FromDate));
                                                                  }
                                                                 // system.debug('wr.toDate--'+wr.toDate);
                                                                  if(wr.toDate != null && wr.toDate != ''){
                                                                      intch.To_Date__c = Date.valueOf(dateFormat(wr.toDate));
                                                                  }
                                                                  interestChargeList.add(intch);
                                                              }else{  
                                                                  interestCharge.Milestone__c=PM.id;
                                                                  interestCharge.Interest_Rate__c=Decimal.valueOf(wr.Rate);
                                                                  interestCharge.Interest_Amount__c=Decimal.valueOf(wr.InterestAmount);
                                                                  interestCharge.Interest_Amount_GST__c=Decimal.valueOf(wr.InterestGST);
                                                                  interestCharge.Intrest_calucation_Amount__c=Decimal.valueOf(wr.InterestTotal);
                                                                  if(wr.FromDate != null && wr.FromDate != ''){
                                                                  		interestCharge.From_Date__c = Date.valueOf(dateFormat(wr.FromDate));
                                                                  }
                                                                  //system.debug('wr.toDate--'+wr.toDate);
                                                                  if(wr.toDate != null && wr.toDate != ''){
                                                                  		interestCharge.To_Date__c = Date.valueOf(dateFormat(wr.toDate));
                                                                  }
                                                                  interestChargeList.add(interestCharge);
                                                                  //InterestChargeInsert.put(PM.Sap_Code__c,interestCharge);
                                                              }
                                                          }
                                                          
                                                      }
                    }
                    system.debug('interestChargeList--> '+interestChargeList);
                    if(!interestChargeList.isEmpty()){
                      
                        
                        Database.UpsertResult[] insertResults = Database.Upsert(interestChargeList, false); 
                   for (Integer i = 0; i < insertResults.size(); i++) {
                      system.debug('results=='+insertResults);
                        
                   }
                        
                    }   
                }
                
            }
            
            List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
            JSONGenerator jsonGenerator1 = JSON.createGenerator(true);
            jsonGenerator1.writeStartObject();
            jsonGenerator1.writeFieldName('RESPONSE');
            jsonGenerator1.writeStartObject();
            jsonGenerator1.writeStringField('STATUS','Success'); 
            jsonGenerator1.writeStringField('MESSAGE','Data received successfully'); 
            jsonGenerator1.writeEndObject();
            jsonGenerator1.writeEndObject();
            jsonGeneratorList.add(jsonGenerator1);
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
            res.responseBody = blob.valueOf(jsonResponse);        }
        catch (Exception e){
            System.debug('---Request----'+String.valueOf(e.getLineNumber()));
            res.statusCode = 400;
            String  jsonResponse = '{"response": {"SFDC_ID": '+''+'\", "STATUS": "' + 'Error' + '"," MESSAGE":"'+'Error occured  :'+e+'}}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }
        
        
    }
    public static string dateFormat(string str){
        System.debug('Inside1---'+str);
        String dateFull  = String.valueOf(str);
        System.debug('Inside1str---'+str);
        String[] deDate     = dateFull.split('\\.');
        String dd = deDate[0]; 
        String mm = deDate[1];
        String yyyy = deDate[2];
        string demcreateDate = yyyy+'-'+mm+'-'+dd;
        System.debug('---demcreateDate------'+demcreateDate);
        return demcreateDate;
    }
    public class interestWrapper{
        public string InterestAmount;
        public string InterestGST;
        public string InterestTotal;
        public string Rate;
        Public  string FromDate;
        Public  string toDate;
        
    }
}