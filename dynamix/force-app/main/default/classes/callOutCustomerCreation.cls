public class callOutCustomerCreation {
    @InvocableMethod(label='create Customer')
    public static void calledFromTransactionFLow(List<request> reqList){
        System.debug('reqList----'+reqList[0].bookingIds);
        if(reqList.size()>0){
            for(String bookingIds :reqList[0].bookingIds){
                System.debug('bookingIds-----'+bookingIds);
                generateSapCodeForCoApplicant(String.valueOf(bookingIds));
            }
        }
    }
    @future(Callout=true)
    public static void generateSapCodeForCoApplicant(String bookingIds) {
        
        List<Booking__c> book = [select id,Prior_Primary_Applicant__c from Booking__c where Id =:bookingIds];
        List<Co_Applicant__c> previousApplicant = New List<Co_Applicant__c> ();
        if(!book.IsEmpty()){
            previousApplicant = [SELECT id FROM Co_Applicant__c WHERE
                                 Booking__c =:bookingIds AND Account__c =:book[0].Prior_Primary_Applicant__c];
        }
        // try{
        Set<String>dataSyncInProgress=new Set<String>();
        Set<String>coAppProcessed=new Set<String>();
        Set<String> CoApplicantList=new Set<String>();
        for (Data_Sync__c dataSync:[Select id,Event_Type__c,RecordId__c, Status__c from Data_Sync__c where Status__c ='In Progress' and Event_Type__c='Co-Applicant']){
            CoApplicantList.add(dataSync.RecordId__c);
        }
        System.debug('Received heree'+bookingIds);
        List<JSONGenerator> jsonGeneratorList = new List<JSONGenerator>();
        if(bookingIds.length()>0){
            JSONGenerator jsonGenerator1 = JSON.createGenerator(true);                   
            jsonGenerator1.writeStartObject();
            jsonGenerator1.writeFieldName('ZSD015_CUSTOMER_CREATION');
            jsonGenerator1.writeStartObject();
            // Primary 
            jsonGenerator1.writeFieldName('CUSTOMER_HEADER');
            for(Co_Applicant__c coApp :[
                Select id,Role__c,Account__r.FirstName, Account__r.LastName, Account__r.Salutation, Account__r.MiddleName, Booking__r.Related_Suggested_Property__r.Name , Account__r.PersonMailingAddress, 
                Account__r.PersonMailingCity, Account__r.BillingCity, Account__r.BillingCountry, Account__r.BillingState, Account__r.BillingPostalCode, Account__r.PersonMailingCountry, Account__r.PersonMailingState, Account__r.PersonMailingPostalCode, Account__r.Phone, Account__r.PersonMobilePhone, Account__r.PersonEmail, Account__r.Gender__pc, Account__r.Nationality__c, 
                Account__r.Martial_Status__pc, Account__r.Occupation__pc, Account__r.PersonBirthdate, Booking__r.Project_Name__c, Booking__r.Project_Name__r.Project_SAP_Code__c, Account__r.PAN_No__pc, Account__r.Aadhar_No__pc, Account__r.Passport__c, Booking__c, Booking__r.Name, Booking__r.Tower_Name__c, Booking__r.Sales_Manager__c
                ,Account__r.PersonMailingStreet,Account__r.OCI_PIO_Card__c,Account__r.Date_of_Board_Resolution_Authority_Lett__c,Account__r.PAN_Details__c,Account__r.NRI__c,Account__r.Industry,Booking__r.Related_Suggested_Property__r.Unit__r.Property_Price_Slab__r.Name,
                Booking__r.Project_Name__r.Builder_Organization__r.Name,Booking__r.Project_Name__r.Distribution_Channel__c,Booking__r.Tower_Name__r.Tower_SAP_Code__c,Booking__r.Channel_Partner__r.Id,
                Account__r.Fax_Number__c,Booking__r.Source_of_Booking__c,Booking__r.Sales_Manager__r.Name,Sap_Code__c,
                Booking__r.Unit_Number__c
                
                FROM Co_Applicant__c  
                WHERE Booking__c=:bookingIds  AND Role__c='Primary' // AND Id IN : CoApplicantList
            ]){
                if(coApp.Role__c=='Primary'){
                    coAppProcessed.add(coApp.Id);
                    jsonGenerator1.writeStartObject();
                    jsonGenerator1.writeStringField('SFDC_ID',!previousApplicant.isEmpty()?String.valueOf(previousApplicant[0].Id):''); //A0EFF000000KFZBMA4 coApp.Id //String.valueOf(coApp.Id).toUpperCase()    
                    jsonGenerator1.writeStringField('TITLE',coApp!=null && coApp.Account__r!=null && coApp.Account__r.Salutation !=null ? coApp.Account__r.Salutation:'');
                    jsonGenerator1.writeStringField('NAME_FIRST',coApp!=null && coApp.Account__r!=null && coApp.Account__r.FirstName !=null ? coApp.Account__r.FirstName:'');
                    jsonGenerator1.writeStringField('NAME_MIDDLE',coApp!=null && coApp.Account__r!=null && coApp.Account__r.MiddleName !=null ? coApp.Account__r.MiddleName:'');
                    jsonGenerator1.writeStringField('NAME_LAST',coApp!=null && coApp.Account__r!=null && coApp.Account__r.LastName !=null ? coApp.Account__r.LastName:'');
                    jsonGenerator1.writeStringField('SORT1',coApp.Booking__r!=null && coApp.Booking__r.Name !=null ? coApp.Booking__r.Name:'');
                    jsonGenerator1.writeStringField('SORT2',coApp.Booking__r.Unit_Number__c!=null?string.valueOf(coApp.Booking__r.Unit_Number__c):'');
                    jsonGenerator1.writeStringField('HOUSE_NO','');
                    jsonGenerator1.writeStringField('STREET',coApp.Account__r!=null && coApp.Account__r.PersonMailingStreet !=null ? coApp.Account__r.PersonMailingStreet:'');
                    jsonGenerator1.writeStringField('STR_SUPPL1',coApp.Account__r!=null && coApp.Account__r.BillingCity !=null ? coApp.Account__r.BillingCity:'');
                    jsonGenerator1.writeStringField('STR_SUPPL2',coApp.Account__r!=null && coApp.Account__r.BillingPostalCode !=null ? coApp.Account__r.BillingPostalCode:'');
                    jsonGenerator1.writeStringField('STR_SUPPL3',coApp.Account__r!=null && coApp.Account__r.BillingState !=null ? coApp.Account__r.BillingState:'');
                    jsonGenerator1.writeStringField('POST_CODE',coApp.Account__r!=null && coApp.Account__r.PersonMailingPostalCode !=null ? coApp.Account__r.PersonMailingPostalCode:'');
                    jsonGenerator1.writeStringField('CITY',coApp.Account__r!=null && coApp.Account__r.PersonMailingCity !=null ? coApp.Account__r.PersonMailingCity:'');
                    jsonGenerator1.writeStringField('COUNTRY',coApp.Account__r!=null && coApp.Account__r.PersonMailingCountry !=null ? coApp.Account__r.PersonMailingCountry:'');
                    jsonGenerator1.writeStringField('REGION',coApp.Account__r!=null && coApp.Account__r.PersonMailingState !=null ? coApp.Account__r.PersonMailingState:''); // DiscussionRequired booking state
                    jsonGenerator1.writeStringField('TEL_NUMBER',coApp.Account__r!=null && coApp.Account__r.Phone !=null ? coApp.Account__r.Phone:'');
                    jsonGenerator1.writeStringField('MOBILE_NO',coApp.Account__r!=null && coApp.Account__r.PersonMobilePhone !=null ? coApp.Account__r.PersonMobilePhone:'');
                    jsonGenerator1.writeStringField('FAX_NUMBER',coApp.Account__r!=null && coApp.Account__r.Fax_Number__c !=null ?coApp.Account__r.Fax_Number__c :'');
                    jsonGenerator1.writeStringField('SMTP_ADDR',coApp.Account__r!=null && coApp.Account__r.PersonEmail !=null ? coApp.Account__r.PersonEmail:'');
                    jsonGenerator1.writeStringField('XSEXU',coApp.Account__r!=null && coApp.Account__r.Gender__pc !=null ? coApp.Account__r.Gender__pc:'');
                    jsonGenerator1.writeStringField('NATIO',coApp.Account__r!=null && coApp.Account__r.Nationality__c !=null ? coApp.Account__r.Nationality__c:'');
                    jsonGenerator1.writeStringField('MARST',coApp.Account__r!=null && coApp.Account__r.Martial_Status__pc !=null ? coApp.Account__r.Martial_Status__pc:'');
                    jsonGenerator1.writeStringField('JOBGR',coApp.Account__r!=null && coApp.Account__r.Occupation__pc !=null ? coApp.Account__r.Occupation__pc:'');
                    if(coApp.Account__r!=null && coApp.Account__r.PersonBirthdate !=null){
                        Date birthDate = coApp.Account__r.PersonBirthdate;
                        String formattedDay = (birthDate.day() < 10) ? '0' + String.valueOf(birthDate.day()) : String.valueOf(birthDate.day());
                        // Format the month with leading zero if single digit
                        String formattedMonth = (birthDate.month() < 10) ? '0' + String.valueOf(birthDate.month()) : String.valueOf(birthDate.month());
                        // Concatenate the formatted date
                        String formattedDate = formattedDay + '.' + formattedMonth + '.' + birthDate.year();
                        jsonGenerator1.writeStringField('BIRTHDT',formattedDate != null ?formattedDate:'');
                    }
                    else{
                        jsonGenerator1.writeStringField('BIRTHDT','');
                    }
                    //String.valueOf(coApp.Account__r.PersonBirthdate.day()+'.'+coApp.Account__r.PersonBirthdate.month()+'.'+coApp.Account__r.PersonBirthdate.year())
                    jsonGenerator1.writeStringField('BIRTHPL','');
                    jsonGenerator1.writeStringField('EMPLO',coApp.Account__r!=null && coApp.Account__r.Industry !=null ? coApp.Account__r.Industry:'');
                    jsonGenerator1.writeStringField('KUKLA',coApp.Account__r!=null && coApp.Account__r.NRI__c !=null && coApp.Account__r.NRI__c==true ? String.valueOf((coApp.Account__r.NRI__c)):'');
                    jsonGenerator1.writeStringField('BUKRS',coApp.Booking__r!=null && coApp.Booking__r.Project_Name__r !=null && coApp.Booking__r.Project_Name__r.Project_SAP_Code__c !=null ? coApp.Booking__r.Project_Name__r.Project_SAP_Code__c:'');
                    jsonGenerator1.writeStringField('KDKG1','');
                    jsonGenerator1.writeStringField('ZTERM','Z015'); //coApp.Booking__r!=null && coApp.Booking__r.Related_Suggested_Property__r !=null && coApp.Booking__r.Related_Suggested_Property__r.Unit__r!=null && coApp.Booking__r.Related_Suggested_Property__r.Unit__r.Property_Price_Slab__r.Name !=null? coApp.Booking__r.Related_Suggested_Property__r.Unit__r.Property_Price_Slab__r.Name:''
                    jsonGenerator1.writeStringField('CST_NO','');
                    if(coApp.Account__r.Nationality__c == 'Non-Resident Indian'){
                        jsonGenerator1.writeStringField('PANNO',coApp.Account__r!=null && coApp.Account__r.PAN_Details__c !=null ? coApp.Account__r.PAN_Details__c:'');
                    }
                    else{
                        jsonGenerator1.writeStringField('PANNO',coApp.Account__r!=null && coApp.Account__r.PAN_No__pc !=null ? coApp.Account__r.PAN_No__pc:'');
                    }
                    jsonGenerator1.writeStringField('AADHAR',coApp.Account__r!=null && coApp.Account__r.Aadhar_No__pc !=null ? coApp.Account__r.Aadhar_No__pc:'');
                    jsonGenerator1.writeStringField('ZZNRI',coApp.Account__r!=null && coApp.Account__r.Nationality__c !=null ? coApp.Account__r.Nationality__c:'');
                    jsonGenerator1.writeStringField('VKORG',coApp.Booking__r!=null && coApp.Booking__r.Project_Name__r!=null && coApp.Booking__r.Project_Name__r.Project_SAP_Code__c!=null && coApp.Booking__r.Project_Name__r.Project_SAP_Code__c !=null ? coApp.Booking__r.Project_Name__r.Project_SAP_Code__c :'');
                    jsonGenerator1.writeStringField('VTWEG',coApp.Booking__r!=null && coApp.Booking__r.Project_Name__r!=null && coApp.Booking__r.Project_Name__r.Distribution_Channel__c !=null ? coApp.Booking__r.Project_Name__r.Distribution_Channel__c:'');
                    jsonGenerator1.writeStringField('VKBUR',coApp.Booking__r!=null && coApp.Booking__r.Tower_Name__r!=null && coApp.Booking__r.Tower_Name__r.Tower_SAP_Code__c !=null ? coApp.Booking__r.Tower_Name__r.Tower_SAP_Code__c:'');
                    jsonGenerator1.writeStringField('VKGRP',coApp.Account__r!=null && coApp.Booking__r.Source_of_Booking__c !=null ? coApp.Booking__r.Source_of_Booking__c:'');
                    jsonGenerator1.writeStringField('AUFSD','');
                    System.debug('testtt111');
                    jsonGenerator1.writeStringField('SALE_EMP',coApp.Booking__r!=null && coApp.Booking__r.Sales_Manager__c !=null ? coApp.Booking__r.Sales_Manager__r.Name:'');
                    System.debug('testtt12');
                    jsonGenerator1.writeStringField('BROKER',''); //coApp.Booking__r!=null && coApp.Booking__r.Channel_Partner__r!=null && coApp.Booking__r.Channel_Partner__r!=null?String.valueOf(coApp.Booking__r.Channel_Partner__r.Id):''
                    jsonGenerator1.writeStringField('KUNNR',coApp.Sap_Code__c!=null ?coApp.Sap_Code__c:'');
                    jsonGenerator1.writeStringField('EXT1',coApp.Account__r.Nationality__c == 'Non-Resident Indian' && coApp.Account__r.OCI_PIO_Card__c != null?coApp.Account__r.OCI_PIO_Card__c:'');
                    jsonGenerator1.writeStringField('EXT2',coApp.Account__r.Nationality__c == 'Non-Resident Indian' && coApp.Account__r.Passport__c != null?coApp.Account__r.Passport__c:'');
                    jsonGenerator1.writeStringField('EXT3',coApp.Account__r.Nationality__c == 'Non-Resident Indian' && coApp.Account__r.Date_of_Board_Resolution_Authority_Lett__c != null?string.valueOf(coApp.Account__r.Date_of_Board_Resolution_Authority_Lett__c):'');
                    jsonGenerator1.writeEndObject();
                }
            }
            jsonGenerator1.writeFieldName('CUSTOMER_CONTACT');
            jsonGenerator1.writeStartObject();
            jsonGenerator1.writeFieldName('item');
            jsonGenerator1.writeStartArray();
            //for loop elements
            for(Co_Applicant__c coApp :[
                Select id,Role__c,Account__r.FirstName, Account__r.LastName, Account__r.Salutation, Account__r.MiddleName, Booking__r.Related_Suggested_Property__r.Name , Account__r.PersonMailingAddress, 
                Account__r.PersonMailingCity, Account__r.BillingCity, Account__r.BillingCountry, Account__r.BillingState, Account__r.BillingPostalCode, Account__r.PersonMailingCountry, Account__r.PersonMailingState, Account__r.PersonMailingPostalCode, Account__r.Phone, Account__r.PersonMobilePhone, Account__r.PersonEmail, Account__r.Gender__pc, Account__r.Nationality__c, 
                Account__r.Martial_Status__pc, Account__r.Occupation__pc, Account__r.PersonBirthdate, Booking__r.Project_Name__c, Booking__r.Project_Name__r.Project_SAP_Code__c, Account__r.PAN_No__pc, Account__r.Aadhar_No__pc, Account__r.Passport__c, Booking__c, Booking__r.Name, Booking__r.Tower_Name__c, Booking__r.Sales_Manager__c
                ,Account__r.PersonMailingStreet,Account__r.NRI__c,Account__r.Industry,Booking__r.Related_Suggested_Property__r.Unit__r.Property_Price_Slab__r.Name,
                Booking__r.Project_Name__r.Builder_Organization__r.Name,Booking__r.Project_Name__r.Distribution_Channel__c,Booking__r.Tower_Name__r.Tower_SAP_Code__c,Booking__r.Channel_Partner__r.Id,
                Account__r.Fax_Number__c,Booking__r.Source_of_Booking__c
                
                FROM Co_Applicant__c 
                WHERE Booking__c=:bookingIds  AND Role__c!='Primary'])
            {
                coAppProcessed.add(coApp.Id);
                jsonGenerator1.writeStartObject();
                jsonGenerator1.writeStringField('TITLE',coApp!=null && coApp.Account__r!=null && coApp.Account__r.Salutation !=null ? coApp.Account__r.Salutation:'');
                jsonGenerator1.writeStringField('NAME_FIRST',coApp!=null && coApp.Account__r!=null && coApp.Account__r.FirstName !=null ? coApp.Account__r.FirstName:'');
                jsonGenerator1.writeStringField('NAME_LAST',coApp!=null && coApp.Account__r!=null && coApp.Account__r.LastName !=null ? coApp.Account__r.LastName:'');
                jsonGenerator1.writeStringField('NAME_MIDDLE',coApp!=null && coApp.Account__r!=null && coApp.Account__r.MiddleName !=null ? coApp.Account__r.MiddleName:'');
                jsonGenerator1.writeStringField('XSEXF',coApp.Account__r!=null && coApp.Account__r.Gender__pc !=null ? coApp.Account__r.Gender__pc:'');
                jsonGenerator1.writeStringField('MARST',coApp.Account__r!=null && coApp.Account__r.Martial_Status__pc !=null ? coApp.Account__r.Martial_Status__pc:'');
                if(coApp.Account__r!=null && coApp.Account__r.PersonBirthdate !=null){
                    Date birthDate = coApp.Account__r.PersonBirthdate;
                    String formattedDay = (birthDate.day() < 10) ? '0' + String.valueOf(birthDate.day()) : String.valueOf(birthDate.day());
                    // Format the month with leading zero if single digit
                    String formattedMonth = (birthDate.month() < 10) ? '0' + String.valueOf(birthDate.month()) : String.valueOf(birthDate.month());
                    // Concatenate the formatted date
                    String formattedDate = formattedDay + '.' + formattedMonth + '.' + birthDate.year();
                    jsonGenerator1.writeStringField('BIRTHDT',formattedDate != null ?formattedDate:'');
                }
                else{
                    jsonGenerator1.writeStringField('BIRTHDT','');
                }
                jsonGenerator1.writeStringField('STREET',coApp.Account__r!=null && coApp.Account__r.PersonMailingStreet !=null ? coApp.Account__r.PersonMailingStreet:'');
                jsonGenerator1.writeStringField('STR_SUPPL1',coApp.Account__r!=null && coApp.Account__r.BillingCity !=null ? coApp.Account__r.BillingCity:'');
                jsonGenerator1.writeStringField('STR_SUPPL2',coApp.Account__r!=null && coApp.Account__r.BillingPostalCode !=null ? coApp.Account__r.BillingPostalCode:'');
                jsonGenerator1.writeStringField('STR_SUPPL3',coApp.Account__r!=null && coApp.Account__r.BillingState !=null ? coApp.Account__r.BillingState:'');
                jsonGenerator1.writeStringField('LOCATION','');
                jsonGenerator1.writeStringField('POST_CODE',coApp.Account__r!=null && coApp.Account__r.PersonMailingPostalCode !=null ? coApp.Account__r.PersonMailingPostalCode:'');
                jsonGenerator1.writeStringField('CITY',coApp.Account__r!=null && coApp.Account__r.PersonMailingCity !=null ? coApp.Account__r.PersonMailingCity:'');
                jsonGenerator1.writeStringField('COUNTRY',coApp.Account__r!=null && coApp.Account__r.PersonMailingCountry !=null ? coApp.Account__r.PersonMailingCountry:'');
                jsonGenerator1.writeStringField('REGION','');
                jsonGenerator1.writeStringField('LANDLINE',coApp.Account__r!=null && coApp.Account__r.Phone !=null ? coApp.Account__r.Phone:'');
                jsonGenerator1.writeStringField('MOBILE',coApp.Account__r!=null && coApp.Account__r.PersonMobilePhone !=null ? coApp.Account__r.PersonMobilePhone:'');
                jsonGenerator1.writeStringField('FAX_NUMBER',coApp.Account__r!=null && coApp.Account__r.Fax_Number__c !=null ?coApp.Account__r.Fax_Number__c :'');
                jsonGenerator1.writeStringField('CP_ROLE','Co-Applicant');
                jsonGenerator1.writeStringField('CP_RELN','Child');
                jsonGenerator1.writeStringField('ABTNR','');
                jsonGenerator1.writeStringField('PAFKT','');
                jsonGenerator1.writeStringField('SMTP_ADDR',coApp.Account__r!=null && coApp.Account__r.PersonEmail !=null ? coApp.Account__r.PersonEmail:'');
                jsonGenerator1.writeStringField('PAN',coApp.Account__r!=null && coApp.Account__r.PAN_No__pc !=null ? coApp.Account__r.PAN_No__pc:'');
                jsonGenerator1.writeStringField('AADHAR',coApp.Account__r!=null && coApp.Account__r.Aadhar_No__pc !=null ? coApp.Account__r.Aadhar_No__pc:'');
                jsonGenerator1.writeStringField('PASSPORT',coApp.Account__r!=null && coApp.Account__r.Passport__c !=null ? coApp.Account__r.Passport__c :'');
                jsonGenerator1.writeEndObject();
            }
            jsonGenerator1.writeEndArray();                  
            jsonGenerator1.writeEndObject();
            
            jsonGenerator1.writeEndObject();
            jsonGenerator1.writeEndObject();
            jsonGeneratorList.add(jsonGenerator1);
            if(jsonGeneratorList.size()>0){
                String jsonString='' ;
                for (JSONGenerator generator : jsonGeneratorList) {
                    jsonString += generator.getAsString()+',';
                }
                if(jsonString.length()>2){
                    jsonString=jsonString.substring(0,jsonString.length()-1);
                }
                system.debug('jsonString......'+jsonString); 
                getSapCodes(jsonString,coAppProcessed);
            }
        }
    }
    public static String getSapCodes( String jsonString,Set<String>coAppProcessed){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        request.setEndpoint('callout:Sap_Coapplicant'); ///sap/opu/odata/SAP/ZCUSTOMER_CREATION_SRV/CustomerDetailSet?sap-client=110
        request.setMethod('POST');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Basic UzAwMjQzMDI0NDA6Umlja3lAOTk2OQ==');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jsonString);
        List<Co_Applicant__c> coAppToUpdate=new List<Co_Applicant__c>();
        Set<String>coAppIds=new Set<String>();
        try {
            response = http.send(request);
            ResponseAPIClass.getResponse(response);
            List<Data_Sync__c> DSToUpdate = new List<Data_Sync__c>(); 
            Map<String,String> coAppIdNew=new Map<String,String>();
            if (response.getStatusCode() == 200 ||response.getStatusCode() == 201) {
                String responseBody = response.getBody();
                System.debug('responseBody'+responseBody);
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                
                if(coAppProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c where RecordId__c IN :coAppProcessed AND Status__c = 'In Progress']){
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
                if(coAppProcessed.size()>0){
                    for(Data_Sync__c DS:[select id,Status__c,RecordId__c from Data_Sync__c  where RecordId__c IN :coAppProcessed AND Status__c = 'In Progress']){
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
        @InvocableVariable 
        public List<String> bookingIds;
    }
}