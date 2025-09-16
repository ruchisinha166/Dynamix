@RestResource(urlMapping='/demand/*')
global class DemandApi{
    public static void createAttachmenet(String json, String demandId,string sapCode){
        
        ContentVersion cv = new ContentVersion();
        cv.Title = sapCode;
        cv.Document_Type__c ='Demand Letter';
        cv.PathOnClient = 'demandLetter.pdf'; // Replace with your file's name
        cv.SObjectType__c ='Demand__c';
        cv.VersionData = EncodingUtil.base64Decode(json);
        insert cv;
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                           FROM ContentVersion WHERE Id =:cv.Id LIMIT 1];
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = demandId;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;
        
    }
    @HttpGet
    global static Void getdemandRecord() {
        RestResponse res = RestContext.response;
        try {
            Map<String,ResponseWrapper> responseMap = New Map<String,ResponseWrapper>();
            Map<String,String> iLISapCodeVsInvoiceSapCodeMap = new Map<String,String>();
            Map<String, Demand__c> demandMap = new Map<String, Demand__c>();
            Map<String, Invoice__c> invoiceMap = new Map<String, Invoice__c>();
            Map<String, Object> demandObject = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
            Map<String, Object> innerBody = (Map<String, Object>)demandObject.get('ZSD021_SFDC_DEMAND');
            Map<String, Object> demandHeader = (Map<String, Object>)innerBody.get('DEMAND_HEADER');
            Map<String, Object> demandItems = (Map<String, Object>)innerBody.get('DEMAND_ITEMS');
            List<Object> itemList = (List<Object>)demandItems.get('item');
            
            String demdId='';
            String InvoiceId;
            String Status ;
            if(!demandHeader.isEmpty()){
                String demandSapCode=String.valueOf(demandHeader.get('VBELN'));
                String demandCreatedDate=String.valueOf(demandHeader.get('FKDAT')); // milestone Activation date (billing date)
                System.debug('demandCreatedDate'+demandCreatedDate+ '--dd.mm.yyyy---'); 
               
                String bookingSapCode=String.valueOf(demandHeader.get('AUBEL')); 
                String bookingDate=String.valueOf(demandHeader.get('AUDAT')); // No use
                String SapCustomerCode=String.valueOf(demandHeader.get('KUNAG')); //0020000133
                String tower=String.valueOf(demandHeader.get('WERKS')); // No use
                String invoiceNetValue=String.valueOf(demandHeader.get('NETWR'));
                String MWSBK=String.valueOf(demandHeader.get('MWSBK')); // No Mapping
                String totalAmountIncludingGST=String.valueOf(demandHeader.get('TOTAL_AMOUNT'));
                String TDSCharges=String.valueOf(demandHeader.get('TDS'));
                String interest=String.valueOf(demandHeader.get('INTEREST'));
                Status=String.valueOf(demandHeader.get('FKSTO'));
                String emailStatus=String.valueOf(demandHeader.get('EMAIL_STATUS'));
                String base64File=String.valueOf(demandHeader.get('PDF_FILE'));
                List<Booking__c> bookingIds=[ select id, Name  from Booking__c  where Sap_Code__c=:bookingSapCode LIMIT 1];
                String bookingId='';
                if(bookingIds.size()>0){
                    bookingId=bookingIds[0].id;
                }
                else{
                    //throw new CustomException('No Booking found with the given Sap code');
                    res.statusCode = 200;
                    String  jsonResponse = '{"RESPONSE": {"SFDC_ID": \"'+''+'\", "STATUS": "' + 'Error' + '","MESSAGE":"'+'booking not exist"'+'}}'; //MESSAGE
                    res.responseBody = blob.valueOf(jsonResponse);
                    return;   
                }
                if (SapCustomerCode.length() < 10) {
                    Integer zeroesToAdd = 10 - SapCustomerCode.length();
                    
                    for (Integer i = 0; i < zeroesToAdd; i++) {
                        SapCustomerCode = '0' + SapCustomerCode;
                    }
                }
                List<Co_Applicant__c> coApp=[select id from Co_Applicant__c  where Sap_Code__c =:SapCustomerCode LIMIT 1];
                String coAppId='';
                if(coApp.size()>0){
                    coAppId=coApp[0].id;
                }
                else{
                    //throw new CustomException('co Applicant not exist ');
                    res.statusCode = 200;
                    String  jsonResponse = '{"RESPONSE": {"SFDC_ID": \"'+''+'\", "STATUS": "' + 'Error' + '","MESSAGE":"'+'co Applicant not exist"'+'}}'; //MESSAGE
                    res.responseBody = blob.valueOf(jsonResponse);
                    return;
                }
                
                SYstem.debug('demandSapCode'+demandSapCode);
                List<Demand__c> demandList=[Select id from demand__c where Sap_Code__c=:demandSapCode LIMIT 1];
                
                List<Invoice__c> invoiceList =[Select id,Demand__c from Invoice__c where Demand__r.Sap_Code__c=:demandSapCode LIMIT 1];
                Demand__c demand = new Demand__c();
                System.debug('Test+'+bookingId);
                demand.Booking__c = bookingId;
                demand.Sap_Code__c = demandSapCode;
                demand.Demand_Date__c = Date.valueOf(dateFormat(demandCreatedDate));
                demand.Total_Amount_SAP__c=Decimal.valueOf(totalAmountIncludingGST);
                demand.Stage__c = 'New';
                demand.TDS_Charges_SAP__c=Decimal.valueOf(TDSCharges);
                demand.Sap_Demand_Status__c=Status;   
                demand.Interest_SAP__c=Decimal.valueOf(interest);
                Invoice__c invoice = new Invoice__c();
                invoice.Co_Applicant__c = coAppId;
                invoice.Invoice_Date__c = Date.valueOf(dateFormat(demandCreatedDate));
                invoice.Status__c = Status;
                
                if(demandList.IsEmpty()){
                    insert demand;
                    demdId=demand.id;
                    
                    invoice.Demand__c = demand.Id;
                    insert invoice;
                    InvoiceId = invoice.id;
                    
                }else{
                    demand.id =  demandList[0].Id;
                    Update demand;
                    demdId=demand.id;
                    
                    invoice.Demand__c = demand.Id;
                    invoice.Id =invoiceList[0].Id;
                    Update invoice;
                    InvoiceId = invoice.id;
                    
                }
                
                //insert invoice line items
                List<Invoice_Line_Item__c> invoiceLineItemList = new List<Invoice_Line_Item__c>();
                Set<String> pmSapCodeList =new Set<String>();
                if(demandItems.get('item') !=null){
                    for (Object obj:itemList){
                        Map<String, Object> item = (Map<String, Object>)obj;
                        String Statusfield = String.valueOf(item.get('POSNR')); // no use
                        String MATERIAL_NO = String.valueOf(item.get('MATERIAL_NO'));
                        String particular = String.valueOf(item.get('ARKTX'));
                        String XREF1 = String.valueOf(item.get('XREF1')); // milestone code sap
                        String Amount = String.valueOf(item.get('NETWR'));
                        String CGST_AMOUNT = String.valueOf(item.get('CGST_AMOUNT'));
                        String SGST_AMOUNT = String.valueOf(item.get('SGST_AMOUNT'));
                        String IGST_AMOUNT = String.valueOf(item.get('IGST_AMOUNT'));
                        String DISCOUNT = String.valueOf(item.get('DISCOUNT'));
                        String TOTAL_AMOUNT = String.valueOf(item.get('TOTAL_AMOUNT'));
                        if(String.isNotBlank(XREF1)){
                            pmSapCodeList.add(XREF1);
                        }
                        Invoice_Line_Item__c invoiceLineItem = new Invoice_Line_Item__c();
                        invoiceLineItem.Invoice__c = invoice.Id;
                        invoiceLineItem.Particular__c = '';
                        invoiceLineItem.Amount__c =null;
                        invoiceLineItem.Sap_Code__c=demandSapCode;
                        invoiceLineItem.Particular__c=particular;
                        invoiceLineItem.Amount__c=Decimal.valueOf(Amount);
                        invoiceLineItem.GST__c=Decimal.valueOf(CGST_AMOUNT)+Decimal.valueOf(SGST_AMOUNT);
                        invoiceLineItemList.add(invoiceLineItem);
                        iLISapCodeVsInvoiceSapCodeMap.put(invoiceLineItem.Sap_Code__c, demandSapCode);
                        
                        System.debug('ssss'+iLISapCodeVsInvoiceSapCodeMap);
                        
                    }
                    List<Payment_Milestones__c> pmToUpdate=new List<Payment_Milestones__c>();
                    List<Demand__c> dmToUpdate=new List<Demand__c>();
                    system.debug('pmSapCodeList--> '+pmSapCodeList);
                    if(!pmSapCodeList.isEmpty() && pmSapCodeList!=null){
                        system.debug('pmSapCodeList.size()--> '+pmSapCodeList.size());
                        for(Payment_Milestones__c pm :[Select id,Milestone_Activation_Date__c, Booking__r.Sap_Code__c from Payment_Milestones__c where Sap_Code__c in :pmSapCodeList AND Booking__r.Sap_Code__c=:bookingSapCode]){
                            Payment_Milestones__c pp=new Payment_Milestones__c();
                            system.debug('pm.Name--'+pm.Booking__c);
                            pp.Id=pm.id;
                            
                            if(Status =='Cancelled'){
                                pp.Milestone_Status__c='Inactive';
                                pp.Milestone_Activation_Date__c = Null ;
                                pp.Due_Date__c = Null;
                            }else{
                                pp.Milestone_Status__c='Active';
                                pp.Milestone_Activation_Date__c=Date.valueOf(dateFormat(demandCreatedDate));
                            }
                            pmToUpdate.add(pp);
                            
                            Demand__c De = New Demand__c();
                            De.Id =demdId;
                            De.Payment_Milestones__c = pm.Id;
                            dmToUpdate.add(De);
                            
                        }
                    }
                    else{
                        String MilestoneName = System.Label.OtherChargesMilestone;
                        for(Payment_Milestones__c pm :[Select id,Milestone_Activation_Date__c, Booking__r.Sap_Code__c from Payment_Milestones__c where Name =:MilestoneName AND Booking__r.Sap_Code__c=:bookingSapCode]){
                            Payment_Milestones__c pp=new Payment_Milestones__c();
                            system.debug('pm.Name--'+pm.Booking__c);
                            pp.Id=pm.id;
                            
                            if(Status =='Cancelled'){
                                pp.Milestone_Status__c='Inactive';
                                pp.Milestone_Activation_Date__c = Null;
                                pp.Due_Date__c = Null;
                            }else{
                                pp.Milestone_Status__c='Active';
                                pp.Milestone_Activation_Date__c=Date.valueOf(dateFormat(demandCreatedDate));
                            }
                            pmToUpdate.add(pp);
                            
                            Demand__c De = New Demand__c();
                            De.Id =demdId;
                            De.Payment_Milestones__c = pm.Id;
                            dmToUpdate.add(De);
                            
                        }
                    }
                    if(Status!= 'Cancelled'){
                        createAttachmenet(base64File,demdId,demandSapCode);
                    }
                    
                    if(!pmToUpdate.isEmpty()){
                        update pmToUpdate;
                    }
                    
                    if(!dmToUpdate.isEmpty()){
                        update dmToUpdate;
                    }
                    
                    List<Invoice_Line_Item__c> iLIListToUpsert = new List<Invoice_Line_Item__c>();
                    
                    if(!invoiceLineItemList.isEmpty()){
                        Schema.SObjectField ILIftoken = Invoice_Line_Item__c.Sap_Code__c;
                        Database.UpsertResult[] upsertResultList = Database.upsert(
                            invoiceLineItemList,
                            ILIftoken,
                            false
                        );
                        
                        for (Integer i = 0; i < upsertResultList.size(); i++) {
                            if (!upsertResultList[i].isSuccess()) {
                                for (Database.Error err : upsertResultList[i].getErrors()) {
                                    //responseMap.get(iLISapCodeVsInvoiceSapCodeMap.get(invoiceLineItemList[i].Sap_Code__c)).message +
                                    String  jsonResponse = JSON.serialize(
                                        'Error Code: ' +
                                        err.getStatusCode() +
                                        'Error Message: ' +
                                        err.getMessage() +
                                        ' Error Field: ' +
                                        err.fields
                                    );
                                    res.statusCode = 200;
                                    res.responseBody = blob.valueOf(jsonResponse);
                                }
                                //responseMap.get(iLISapCodeVsInvoiceSapCodeMap.get(invoiceLineItemList[i].Sap_Code__c)).Status = 'Error';
                            }
                        }
                    }
                }
            }
            
            res.statusCode = 200;
            String  jsonResponse = '{"RESPONSE": {"SFDC_ID": \"'+demdId+'\", "STATUS": "' + 'Success' + '","MESSAGE":"'+'Demand Created Succesfully\"'+'}}'; //MESSAGE
            res.responseBody = blob.valueOf(jsonResponse);
        }
        catch (Exception e){
            System.debug('---Request----'+ String.valueOf(e.getLineNumber()));
            res.statusCode = 200;
            String  jsonResponse = '{"RESPONSE": {"SFDC_ID": \"'+''+'\", "STATUS": "' + 'Error' + '","MESSAGE":"'+'Exception occured, demand Not created :'+e+'\"}}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }
        
    }
    public static string dateFormat(string str){
        System.debug('Inside1---'+str);
        String dateFull  = String.valueOf(str);
        System.debug('Inside1str---'+str);
        String[] demandDate     = dateFull.split('\\.');
        System.debug('Inside1-demandDate--'+demandDate);
        String dd = demandDate[0]; 
        String mm = demandDate[1];
        String yyyy = demandDate[2];
        string demandcreateDate = yyyy+'-'+mm+'-'+dd;
        System.debug('---demandcreateDate------'+demandcreateDate);
        return demandcreateDate;
    }
    global class ResponseWrapper {
        public String SapCode;
        public String message;
        public String Status;
    }
    
    public class CustomException extends Exception {}
}