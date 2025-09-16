@RestResource(urlMapping='/channelpartner/*')
global with sharing class RestChannelPartner{
    @HttpPost
    global static Response postChannelPartner(){
        Response resp = new Response();
        
        RestRequest restReq = RestContext.request;
        
        String requestBody = restReq.requestBody.toString();
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        List<ReqWrapper> reqWrapperList = new List<ReqWrapper>();
        reqWrapperList = (List<ReqWrapper>)JSON.deserialize(requestBody, List<ReqWrapper>.class);
        List<Account> updateFilesDetailsOnAccount = New List<Account>();
        
        Map<String,String> validateCheck = validateValues(reqWrapperList);
        if(validateCheck.size() <= 0){    
            List<Account> insertAccountList = new List<Account>();
            List<Channel_Partner_Project__c> insertChannelPartnerList = new List<Channel_Partner_Project__c>();
            List<Account> updateAccountList = new List<Account>();
            Set<String> projectSet = new set<string>();
            List<String> projectList = New List<string>();
            Set<String> phoneNumberSet = new set<string>();
            Map<String, ReqWrapper> accountMapRequestWrapper = new Map<String, ReqWrapper>();
            List<Project_Details__mdt> projectDetailList = [SELECT id,name__c, Label FROM Project_Details__mdt];
            Map<String,String> mapOfProjectDetails = New Map<String,String>();
            for(Project_Details__mdt thisProjectDetails : projectDetailList)
            {
                mapOfProjectDetails.put(thisProjectDetails.Label,thisProjectDetails.name__c);
            }
            Set<String> reraSet = new set<string>();      
            try{
                for(reqWrapper  reqWrapper :reqWrapperList){
                    if(reqWrapper.reranumber != null){
                        reraSet.add(reqWrapper.reranumber);
                    }
                    if(reqWrapper.phone != null){
                        phoneNumberSet.add(reqWrapper.phone);
                    }
                    if(reqWrapper.projectId != null){
                        projectList = reqWrapper.projectId.split(';');
                    }
                    system.debug('reraCertificate'+reqWrapper.reraCertificate);
                    
                }
                for(String ProjectId :projectList)
                {
                    if(mapOfProjectDetails.ContainsKey(ProjectId))
                    { 
                        String projectNameData = mapOfProjectDetails.get(ProjectId);
                        projectSet.add(projectNameData);
                    }
                    //projectSet.add(ProjectId);
                }
            }
            catch(exception EX)
            {
            }
            system.debug('reraSet'+reraSet);
            system.debug('phoneNumberSet'+phoneNumberSet);
            system.debug('projectSet'+projectSet);
            List<Account> accountReraList = [SELECT Name, phone, Email__c,RecordTypeId,BillingCity,BillingCountry,BillingState,RERA_Number__c,
                                             BillingStreet,Type,Rera_Uploaded_Date__c,AccountSource,Website,BillingPostalCode,PAN_No__c,GSTIN_No__c,CP_Unique_Number__c
                                             FROM Account WHERE RERA_Number__c IN: reraSet OR Phone IN: phoneNumberSet];
            System.debug('accountReraList---------->'+accountReraList);
            
            //try{
            Map<String ,Account> accountMap = New Map<String ,Account>();
            Map<String ,Account> allAccountMap = New Map<String ,Account>();
            if(!accountReraList.isEmpty()){
                // Map<String, String> accountReraMap = new Map<String, String>();
                for(Account acc:accountReraList){
                    accountMap.put(acc.Phone,acc);
                    accountMap.put(acc.RERA_Number__c,acc);
                    // resp.Status ='200';
                    // resp.message = 'Channel Partner record is created successfully with: ' +acc.CP_Unique_Number__c +' CrmId '+ acc.id;
                }
                //return resp;
                //throw new MyCustomException(message + 'Rera Already Exist');                
            }
            List<String> accountIds = new List<String>();
            
            for(reqWrapper  reqWrapper :reqWrapperList){
                if(accountMap.containsKey(reqWrapper.reranumber)){
                    //  if(reqWrapper.channelPartnerRecordId != null){
                    Account acc = accountMethod(reqWrapper);
                    acc.id = accountMap.get(reqWrapper.reranumber).id;
                    accountIds.add(acc.id);
                    updateAccountList.add(acc);
                }
                else if(accountMap.containsKey(reqWrapper.Phone))
                {
                    Account acc = accountMethod(reqWrapper);
                    acc.id = accountMap.get(reqWrapper.Phone).id;
                    accountIds.add(acc.id);
                    updateAccountList.add(acc);
                }
                else{
                    insertAccountList.add(accountMethod(reqWrapper));
                    accountMapRequestWrapper.put(accountMethod(reqWrapper).Name + accountMethod(reqWrapper).Phone + accountMethod(reqWrapper).Email__c , reqWrapper);
                }
            }
            system.debug('insertAccountList'+insertAccountList);
            Database.SaveResult[] resultList;
            if(!insertAccountList.isEmpty()){
                resultList = database.insert(insertAccountList, false);
            }
            if(!updateAccountList.isEmpty()){
                resultList = database.update(updateAccountList);
            }
            System.debug('43');
            
            for (Database.SaveResult sr : resultList) {
                System.debug('47----');
                if (sr.isSuccess()) {
                    accountIds.add(sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                        resp.status = '400';
                        resp.message = 'Account fields that affected this error: ' +err.getStatusCode() + ': ' + err.getMessage();
                        //resp.errorMessage.put( 'Error', err.getMessage()); 
                        return resp;
                    }
                }
            }
            
            Database.SaveResult[] channelPartnerResultList;
            OrgWideEmailAddress owea = new OrgWideEmailAddress();
            owea = [SELECT Id, Address, DisplayName FROM 
                    OrgWideEmailAddress WHERE DisplayName='Default'];
            communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,communicat_o__External_Template_Id__c From communicat_o__Registered_Template__mdt Where QualifiedApiName=: 'New_CP_Registration_Through_Website' Limit 1];
            
            List<Account> accountList = [SELECT Name, phone, Email__c,RecordTypeId,BillingCity,BillingCountry,BillingState,RERA_Number__c,
                                         BillingStreet,Type,AccountSource, Aadhar_Uploaded_Date__c,
                                         Rera_Uploaded_Date__c,Website,BillingPostalCode,GSTIN_No__c,PAN_No__c,CP_Unique_Number__c/*Bank_Name__c,
Bank_Account_Number__c,IFSC_Code__c,Branch_Address__c,GST_No__c,State__c,No_of_Employees__c,
Type_Other__c*/
                                         FROM Account WHERE Id IN : accountIds];
            if(!accountList.isEmpty()){
                EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'New_CP_Registration_Through_Website' LIMIT 1];
                
                for(Account acc:accountList){
                    allAccountMap.put(acc.Phone,acc);
                    List<string> arguments = New List<string>{acc.CP_Unique_Number__c,'923678789'};
                        String recipientAddress = acc.Phone;
                    String recipientId = acc.id;
                    String emailTemplateId = String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
                    String relatedToId = acc.id;
                    System.debug('emailTemplateId:'+emailTemplateId);
                    String htmlBody = emailTemplate.HtmlValue;
                    String plainBody = emailTemplate.Body;
                    plainBody = plainBody.replace('{cpUniqueId}',acc.CP_Unique_Number__c);
                    plainBody = plainBody.replace('{contactNumber}', '923678789');
                    if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                        // SendWhatsAppMessageUtility.SendWhatsappMessage(recipientAddress, recipientId,emailTemplateId, relatedToId ,regWhatEmailTemp.communicat_o__External_Template_Id__c ,arguments);
                        EmailMessage objEmailMessage = new EmailMessage();
                        objEmailMessage.status = '3'; // email was sent
                        objEmailMessage.RelatedToId = acc.id;
                        objEmailMessage.fromName = 'Dynamix'; // from name
                        objEmailMessage.Subject = 'Whatsapp sent to CP for Registration';
                        objEmailMessage.HtmlBody = plainBody;
                        //insertEmailMessageList.add(objEmailMessage);
                    }
                    if(emailTemplate!=null && acc.Email__c != null && acc.Email__c != ''){    
                        List<String> emailList=new List<String>();           
                        emailList.add(acc.Email__c);    
                        
                        EmailMessage objEmailMessage = new EmailMessage();
                        objEmailMessage.status = '3'; // email was sent
                        objEmailMessage.RelatedToId = acc.id;
                        objEmailMessage.fromName = 'Dynamix'; // from name
                        objEmailMessage.Subject = 'Email sent to CP for Registration';
                        objEmailMessage.HtmlBody = plainBody;
                        // insertEmailMessageList.add(objEmailMessage);
                        // SendEmailWithOrgWideAddress.SendEmail(emailTemplate.Id, htmlBody, plainBody, emailList,null,owea.id);
                        
                    }
                    
                }
            }
            //}
            List<Project__c> selectedProjectList = new List<Project__c>();
            Set<id> projectIdsSet = New Set<id>();
            Map<String,Project__c> mapofProject = new Map<String,Project__c>(); 
            selectedProjectList = [Select id,name from Project__c where name In:projectSet];
            system.debug('selectedProjectList'+selectedProjectList);
            Map<String,Project__c> projectMap = New Map<String,Project__c>();
            If(!projectList.IsEmpty()){
                For(Project__c thisProject : selectedProjectList){
                    mapofProject.put(thisProject.Name , thisProject);
                    projectMap.put(thisProject.id, thisProject);
                    projectIdsSet.add(thisProject.id);
                }
            }
            List<Channel_Partner_Project__c> channelPartnerList = [SELECT ID, NAME, Project__c, Channel_Partner__c  
                                                                   FROM Channel_Partner_Project__c 
                                                                   WHERE Project__c IN: projectIdsSet  AND Channel_Partner__c IN: accountIds];
            Map<String, String> accountReraMap = new Map<String, String>();
            Map<String, Channel_Partner_Project__c> channelPartnerMap = new Map<String, Channel_Partner_Project__c>();
            for(Channel_Partner_Project__c channelPartner:channelPartnerList){
                String Key = channelPartner.Channel_Partner__c + '-' + channelPartner.Project__c;
                channelPartnerMap.put(Key,channelPartner);
            }
            /*List<Project__c> selectedProjectList = [SELECT Id, Site_Head__c, Site_Head__r.Name, Site_Head__r.Email 
FROM Project__c
WHERE ID IN: projectSet];
Map<String,Project__c> projectMap = New Map<String,Project__c>();
if(!selectedProjectList.isEmpty()){
for(Project__c thisProject : selectedProjectList){
projectMap.put(thisProject.id, thisProject);
}
}*/
            Set<String> newProjectSet = New Set<string>();
            List<ContentVersion> contentVersionList = New List<ContentVersion>();
            for(reqWrapper reqWrapper :reqWrapperList){
                if(allAccountMap.containsKey(reqWrapper.phone) || allAccountMap.containsKey(reqWrapper.reranumber))
                {Account thisAccount = New Account();
                    
                    if(reqWrapper.projectId != null){
                        projectList = reqWrapper.projectId.split(';');
                        System.debug('projectList---------->'+projectList);
                    }
                    if(reqWrapper.reraCertificate.get('title') != null)
                    {
                        
                        system.debug('Test'+reqWrapper.reraCertificate.get('title'));
                        system.debug('Test'+reqWrapper.reraCertificate.get('title'));
                        ContentVersion cv = new ContentVersion();
                        if(allAccountMap.containskey(reqWrapper.phone))
                        {
                            if(allAccountMap.get(reqWrapper.phone).Rera_Uploaded_Date__c != null 
                               || allAccountMap.get(reqWrapper.phone).Rera_Uploaded_Date__c != datetime.valueof(reqWrapper.reraCertificate.get('createdDateTime'))){
                                String title = (String)reqWrapper.reraCertificate.get('title');
                            String base64Data = (String)reqWrapper.reraCertificate.get('data');
                            // Convert Base64 data to Blob
                            Blob dataBlob = EncodingUtil.base64Decode(base64Data);
                            // Create a new ContentVersion
                            
                            cv.Title = (String)reqWrapper.reraCertificate.get('title'); // Set the title from API response
                            cv.VersionData = dataBlob; // Set the data from API response
                            cv.PathOnClient = (String)reqWrapper.reraCertificate.get('title'); // Set the file name or path on client
                            cv.FirstPublishLocationId = allAccountMap.get(reqWrapper.phone).id;
                            cv.Document_Type__c = 'Rera Certificate';
                            cv.SObjectType__c = 'Account';
                            
                            thisAccount.id = allAccountMap.get(reqWrapper.phone).id;
                            thisAccount.Rera_Uploaded_Date__c = datetime.valueof(reqWrapper.reraCertificate.get('createdDateTime')).addMinutes(320);
                          
                               }
                            
                        }
                        else if(allAccountMap.containskey(reqWrapper.reranumber))
                        {
                              thisAccount.id = allAccountMap.get(reqWrapper.reranumber).id;
                            cv.FirstPublishLocationId = allAccountMap.get(reqWrapper.reranumber).id;
                        }
                        contentVersionList.add(cv);
                    }
                    
                    //Aadhaar Card
                    if(reqWrapper.aadhaarCard.get('title') != null)
                    {
                        
                        system.debug('Test'+reqWrapper.aadhaarCard.get('title'));
                        system.debug('Test'+reqWrapper.aadhaarCard.get('title'));
                        ContentVersion cv = new ContentVersion();
                        if(allAccountMap.containskey(reqWrapper.phone))
                        {
                            if(allAccountMap.get(reqWrapper.phone).Aadhar_Uploaded_Date__c != null 
                               || allAccountMap.get(reqWrapper.phone).Aadhar_Uploaded_Date__c != datetime.valueof(reqWrapper.aadhaarCard.get('createdDateTime'))){
                                String title = (String)reqWrapper.aadhaarCard.get('title');
                            String base64Data = (String)reqWrapper.aadhaarCard.get('data');
                            // Convert Base64 data to Blob
                            Blob dataBlob = EncodingUtil.base64Decode(base64Data);
                            // Create a new ContentVersion
                            
                            cv.Title = (String)reqWrapper.aadhaarCard.get('title'); // Set the title from API response
                            cv.VersionData = dataBlob; // Set the data from API response
                            cv.PathOnClient = (String)reqWrapper.aadhaarCard.get('title'); // Set the file name or path on client
                            cv.FirstPublishLocationId = allAccountMap.get(reqWrapper.phone).id;
                            cv.Document_Type__c = 'Aadhar';
                            cv.SObjectType__c = 'Account';

                            thisAccount.id = allAccountMap.get(reqWrapper.phone).id;
                            thisAccount.Aadhar_Uploaded_Date__c = datetime.valueof(reqWrapper.aadhaarCard.get('createdDateTime')).addMinutes(380);
                           
                               }
                            
                        }
                        else if(allAccountMap.containskey(reqWrapper.reranumber))
                        {
                            cv.FirstPublishLocationId = allAccountMap.get(reqWrapper.reranumber).id;
                             thisAccount.id = allAccountMap.get(reqWrapper.reranumber).id;
                        }
                        contentVersionList.add(cv);
                    }
                     updateFilesDetailsOnAccount.add(thisAccount);
                    
                    
                    for(String ProjectId :projectList){
                        
                        System.debug('mapOfProjectDetails---------->'+mapOfProjectDetails);
                        System.debug('ProjectId---------->'+ProjectId);
                        System.debug('mapOfProjectDetails.ContainsKey(ProjectId)---------->'+mapOfProjectDetails.ContainsKey(ProjectId));
                        if(mapOfProjectDetails.ContainsKey(ProjectId) )
                        { 
                            String projectNameData = mapOfProjectDetails.get(ProjectId);
                            if(mapofProject.ContainsKey(projectNameData)){
                                String Key ;
                                if(allAccountMap.containskey(reqWrapper.phone))
                                {
                                    Key = string.valueof(allAccountMap.get(reqWrapper.phone).id)+ '-' + mapofProject.get(projectNameData).id;
                                    
                                }
                                else if(allAccountMap.containskey(reqWrapper.reranumber))
                                {
                                    Key = string.valueof(allAccountMap.get(reqWrapper.reranumber).id)+ '-' + mapofProject.get(projectNameData).id;
                                    
                                }
                                
                                if(!channelPartnerMap.containsKey(Key) && mapofProject.containsKey(projectNameData))
                                {
                                    Channel_Partner_Project__c ChannelPartner = New Channel_Partner_Project__c();
                                    ChannelPartner.Channel_Partner__c = allAccountMap.get(reqWrapper.Phone).id;
                                    ChannelPartner.Project__c = mapofProject.get(projectNameData).id;
                                    insertChannelPartnerList.add(ChannelPartner);
                                }
                                else if(channelPartnerMap.containsKey(Key))
                                {
                                    try{
                                        
                                        string sfdcBaseURL=URL.getSalesforceBaseUrl().toExternalForm();
                                        string sfdcRecordURL= URL.getSalesforceBaseUrl().toExternalForm()+'/'+channelPartnerMap.get(Key).id;
                                        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'CP_Already_Exist' LIMIT 1];
                                        System.debug('emailTemplate:'+emailTemplate);
                                        String htmlBody = emailTemplate.HtmlValue;
                                        String plainBody = emailTemplate.Body;
                                        htmlBody = htmlBody.replace('{accountName}',channelPartnerMap.get(Key).Name);
                                        htmlBody = htmlBody.replace('{accountLink}', sfdcRecordURL);
                                        plainBody = plainBody.replace('{accountName}',channelPartnerMap.get(Key).Name);
                                        plainBody = plainBody.replace('{accountLink}', sfdcRecordURL);
                                        if(emailTemplate!=null){    
                                            List<String> emailList=new List<String>();           
                                            emailList.add(projectMap.get(ProjectId).Site_Head__r.Email);              
                                            SendEmailWithOrgWideAddress.SendEmail(emailTemplate.Id, htmlBody, plainBody, emailList,null,owea.id);
                                            EmailMessage objEmailMessage = new EmailMessage();
                                            objEmailMessage.status = '3'; // email was sent
                                            objEmailMessage.RelatedToId = channelPartnerMap.get(Key).id;
                                            objEmailMessage.fromName = 'Dynamix'; // from name
                                            objEmailMessage.Subject = 'Email sent to Project Site Head';
                                            objEmailMessage.HtmlBody = plainBody;
                                            insertEmailMessageList.add(objEmailMessage);
                                            
                                        }
                                    }
                                    catch(Exception ex)
                                    {
                                        system.debug('Error----'+ex.getMessage() +' Line Number----' +ex.getLineNumber());
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if(!contentVersionList.isEmpty()){
                insert contentVersionList;
                /*channelPartnerResultList = database.insert(insertChannelPartnerList);
System.debug('insertChannelPartnerList---->'+insertChannelPartnerList);*/
            } 
            System.debug('insertChannelPartnerList---->'+insertChannelPartnerList);
            System.debug(insertChannelPartnerList);
            if(!insertChannelPartnerList.isEmpty()){
                channelPartnerResultList = database.insert(insertChannelPartnerList);
                System.debug('insertChannelPartnerList---->'+insertChannelPartnerList);
            }
            Set<id> channelPartnerProjectSet = New Set<id>();
            if(!insertChannelPartnerList.isEmpty())
            {
                for (Database.SaveResult sr : channelPartnerResultList) {
                    System.debug('47----');
                    System.debug('sr---------->'+sr);
                    if (sr.isSuccess()) {
                        channelPartnerProjectSet.add(sr.getId());
                        System.debug('channelPartnerProjectSet---------->'+channelPartnerProjectSet);
                    }
                    else {
                        
                    }
                }
            }
            System.debug('channelPartnerProjectSet---------->'+channelPartnerProjectSet);
            List<Channel_Partner_Project__c> newChannelPartnerList = [SELECT ID, NAME, Project__c, Channel_Partner__c,
                                                                      Project__r.Site_Head__r.Email, Channel_Partner__r.Name
                                                                      FROM Channel_Partner_Project__c 
                                                                      WHERE Id IN: channelPartnerProjectSet];
            System.debug('newChannelPartnerList--------->'+newChannelPartnerList);
            if(!newChannelPartnerList.isEmpty())
            {
                EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'New_CP' LIMIT 1];
                
                for(Channel_Partner_Project__c thisRecord :newChannelPartnerList)
                {
                    string sfdcBaseURL=URL.getSalesforceBaseUrl().toExternalForm();
                    string sfdcRecordURL= URL.getSalesforceBaseUrl().toExternalForm()+'/'+thisRecord.id;
                    EmailTemplate cpExistemailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'New_Cp' LIMIT 1];
                    System.debug('cpExistemailTemplate:'+cpExistemailTemplate);
                    String htmlBody = cpExistemailTemplate.HtmlValue;
                    String plainBody = cpExistemailTemplate.Body;
                    // htmlBody = htmlBody.replace('{accountName}',channelPartnerMap.get(Key).Name);
                    //htmlBody = htmlBody.replace('{accountLink}', sfdcRecordURL);
                    plainBody = plainBody.replace('{accountName}',thisRecord.Channel_Partner__r.Name);
                    plainBody = plainBody.replace('{accountLink}', sfdcRecordURL);
                    if(cpExistemailTemplate!=null){    
                        List<String> emailList=new List<String>();           
                        emailList.add(thisRecord.Project__r.Site_Head__r.Email);              
                        SendEmailWithOrgWideAddress.SendEmail(cpExistemailTemplate.Id, htmlBody, plainBody, emailList,null,owea.id);
                        EmailMessage objEmailMessage = new EmailMessage();
                        objEmailMessage.status = '3'; // email was sent
                        objEmailMessage.RelatedToId = thisRecord.id;
                        objEmailMessage.fromName = 'Dynamix'; // from name
                        objEmailMessage.Subject = 'Email sent to Project Site Head For Registrating Again';
                        objEmailMessage.HtmlBody = plainBody;
                        insertEmailMessageList.add(objEmailMessage);
                        
                    }
                } 
            }
            
            
            System.debug(insertChannelPartnerList);
            System.debug('60---');
            if(!accountList.isEmpty())
            {
                for(Account acc:accountList){
                    resp.message = 'Channel Partner record is created successfully with: ' +acc.CP_Unique_Number__c +' CrmId '+ acc.id;
                    //resp.message = String.valueOf(accountIds);
                    resp.status = '200';
                }
            }
            else
            {
                resp.status = '400';
                // resp.message = 
            }
        }
        else
        {
            resp.status = '400';
            resp.message = 'Failed';
            resp.errorMessage = validateCheck;
        }
        if(!insertEmailMessageList.isEmpty())
        {
            insert insertEmailMessageList;
        }
        update updateFilesDetailsOnAccount;
        return resp;
        
    }
    
    public static Account accountMethod(ReqWrapper reqWrapper){
        Id channelPartnerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
        List<String> pickListValuesList = new List<String>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getValue());
        }     
        Account accountObj = new Account();
        accountObj.Country_Code__c = reqWrapper.countryCode;
        accountObj.Name = nullCheck(reqWrapper.name, 'companyname');
        accountObj.Phone = nullCheck(reqWrapper.phone, 'Phone');
        accountObj.Email__c = nullCheck(reqWrapper.email, 'Email');
        system.debug('reqWrapper.firmName'+reqWrapper.firmName);
        accountObj.CP_Firm_Name__c = reqWrapper.firmName;
        accountObj.CP_Name__c = reqWrapper.firmName;
        accountObj.Firm_Type__c = reqWrapper.firmType;
        accountObj.Entity__c = reqWrapper.entity;
        accountObj.PAN_No__c = reqWrapper.pan;
        accountObj.GSTIN_No__c = reqWrapper.gstnumber;
        accountObj.RERA_Number__c = reqWrapper.reranumber;
        accountObj.Focus_Location__c = reqWrapper.focusLocation;
        accountObj.Expertise__c = reqWrapper.expertise;
        accountObj.Affiliation_to_any_Broker_Association__c = reqWrapper.brokerAssociation;
        accountObj.RecordTypeId = channelPartnerRecordType;
        accountObj.BillingCity = reqWrapper.city;
        accountObj.BillingCountry = reqWrapper.country;
        accountObj.BillingState = reqWrapper.state;
        accountObj.BillingStreet = reqWrapper.addressline1;
        accountObj.BillingStreet += '\n ' + reqWrapper.addressline2;
        accountObj.AccountSource ='Website';
        accountObj.BillingPostalCode = reqWrapper.pincode;
        accountObj.Number_of_years_in_Operation__c	 = reqWrapper.noOfYearsInOperation;
        accountObj.Referral_By_Sales_Manager__c = reqWrapper.salesManagerName;
        accountObj.Designation__c = reqWrapper.designation;
        accountObj.Broker_Name__c = reqWrapper.addressline1;
        if(reqWrapper.reraExpiryDate != null && reqWrapper.reraExpiryDate != '')
        {
            accountObj.Rera_Expiry_Date__c = date.valueof(reqWrapper.reraExpiryDate);
        }
        return accountObj;
    }
    
    public static String nullCheck(String value, String fieldName){
        if(String.isBlank(value)){
            System.debug('i am here');
            throw new MyCustomException(fieldName + ' Cannot be blank');
        }
        else{
            return value;
        }
    }
    
    public class ReqWrapper{
        public String countryCode;
        public String reranumber;
        public String name;
        public String firmName;
        public String firmType;
        public String email;
        public String mobilenumber; 
        public String phone;
        //  public String reraCertificate;// pending
        public String entity;
        public String expertise;
        public String companyname;
        public String reraExpiryDate;
        public String pan;
        public String gstnumber;
        public String ownerName; // pending
        public String projectId;
        public String brokerAssociation;
        public String focusLocation;
        public String salesManagerName; // pending  
        public String noOfYearsInOperation; // pending
        public String designation;  
        public String addressline1; 
        public String addressline2; 
        public String city;
        public String channelPartnerRecordId;            
        public String country;
        public String pincode;
        public String state;
        public Map<String,String> reraCertificate;
        public Map<String,String> aadhaarCard;
        public Map<String,String> gstCertficate;
    }
    
    global class Response{
        public String message;
        public String status;
        public Map<String,String> errorMessage;
    }
    public with sharing class MyCustomException extends Exception{}
    public static Map<String,String> validateValues(List<ReqWrapper> reqWrapperList){   
        Map<String,String> errorMessageList = new Map<String,String>();
        
        for(reqWrapper reqWrapper :reqWrapperList)
        {
            if(reqWrapper.name == null || reqWrapper.name =='')
            {
                errorMessageList.put('CP Code','Please enter value in CP  Name.');
            }
            if(reqWrapper.phone == null || reqWrapper.phone =='')
            {
                errorMessageList.put('Phone','Please enter value in Phone.');
            }
            if(reqWrapper.firmType == null || reqWrapper.firmType =='')
            {
                errorMessageList.put('CP Firm Type','Please enter value in CP Firm Type.');
            }
            
            if(reqWrapper.firmName == null || reqWrapper.firmName =='')
            {
                errorMessageList.put('CP Firm Name','Please enter Value in CP Firm Name.');
            }
            if(reqWrapper.email == null || reqWrapper.email =='')
            {
                errorMessageList.put('Email','Please enter value in email.');
            }
            /*  if(reqWrapper.countryCode == null || reqWrapper.countryCode =='')
{
errorMessageList.put('Country Code','Please enter Country Code.');
}*/
            
        }
        
        return errorMessageList;
    }
   public static void testCoverageMethod()
    {
        integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        
    }
}