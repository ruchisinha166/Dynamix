Global without Sharing class EOICAFormController {
    private ApexPages.StandardController standardController;
    public List<List<ItemWrapper>> items { get; set; }
    public List<String> selectedItems { get; set; }
    public String selectedValue { get; set; }
    Public String countryCodeValue {get;set;}
    Public String primaryAccountMobileNo {get;set;}
    Public String selectedSecondaryAccCountryCodeAdd {get;set;}
    Public String SecondaryMobileNo {get;set;}
    Public String salesManagerName {get;set;}
    Public String channelStringPartnerRecordID {get;set;}
    Public String channelPartnerName {get;set;}
    Public String myField {get;set;}
    Public Integer CountOtp {get;set;}
    Public String salesManagerId {get;set;}
    Public String sourcingManagerId {get;set;}
    Public String sourcingManagerName {get;set;}
    Public String primaryAccountEmail {get;set;}
    Public String cpAccountFirmName {get;set;}
    Public Boolean isAgreeWithTermsConditions {get;set;}
    Public String primaryAccountSalutation {get;set;}
    Public String primaryAccountLastName {get;set;}
    Public String primaryAccountMiddleName {get;set;}
    Public String primaryAccountFirstName {get;set;}
    Public String primaryAccountChannelPartnerMobileNumber {get;set;}
    Public Boolean isPrimaryAccIndian {get;set;}
    Public String selectedPrimaryAccAgeAdd {get;set;}
    Public String selectedPrimaryAccCountryCodeAdd {get;set;}
    Public Boolean isPrimaryAccNonIndian {get;set;}
    Public String selectedPrimaryAccNationality {get;set;}
    Public String submittedBy {get;set;}
    Public String recordId {get;set;}
    Public String otpCode {get;set;}
    Public String designation {get;set;}
    Public String companyName {get;set;}
    Public String selectedPrimaryAccPermAddState {get;set;}
    Public String selectedPrimaryAccPermAddCountry {get;set;}
    Public String primaryAccMailingAddStreet {get;set;}
    Public String primaryAccMailingAddCity {get;set;}
    Public String primaryAccMailingAddPostalCode {get;set;}
    Public String primaryAccMailingAddState {get;set;}
    Public String primaryAccMailingAddCountry {get;set;}
    Public String apartmentFlat {get;set;}
    Public String locality {get;set;}
    Public String officePinCode {get;set;}
    Public Boolean UnregisteredCP {get;set;}
    Public String selectedPrimaryAccMaritalStatus {get;set;}
    Public String selectedNatureInUseAdd {get;set;}
    Public String selectedPrimaryAccMaitalStatusAdd {get;set;}
    Public String selectedWalkInSourceAdd {get;set;}
    Public String selectedProjectConfigurationAdd {get;set;}
    Public String selectedConstructionStatusAdd {get;set;}
    Public String selectedSourceOfFundingStatus {get;set;}
    Public String selectedEmploymentType {get;set;}    
    Public Boolean showChannelPartner {get;set;}
    public Integer randomNumber{get;set;}
    Public Boolean isverifyed {get;set;}
    Public String otpBtnValue {get;set;}
    Public String builderOrgName {get;set;}
    Public Boolean disableOTP {get;set;}
    Public Boolean isSubmitButtonDisable=false;
    Public String errorMsg {get;set;}
    Public String sucessMsg {get;set;}
    Public String officeLocation {get;set;}
    Public String Industry {get;set;}
    Public String projectCarpetArea {get;set;}
    Public String selectedFloor {get;set;}
    Public Boolean makeItdefaultReadOnly {get;set;}
    Public Boolean ShowForm {get;set;}
    
    Public string ProjectHeader{get;set;}
    Public string ProjectFooter{get;set;}
    public boolean showFooter {get;set;}
    public boolean showHeader {get;set;}
    Public string ProjectName{get;set;}
    public String secondarySalesManagerName {get;set;}
    public String secondarySalesManagerId {get;set;}
    public String secondarySalesManager {get;set;}
    
    public String setReadOnlyChannelPartner {get;set;}
    public List<String> multiSelectBudgetValues { get; set; }
    public List<SelectOption> budgetPicklistOptions { get; set; }
    public List<SelectOption> projectConfigurationPicklistOptions { get; set; }
    public List<SelectOption> selectedCarpetAreaAddOption { get; set; }
    Public String selectedBudgetPicklistValue {get;set;}
     Public string termsAndCondition{get;set;}
    public String stateFromPage { get; set; }
    public String countryFromPage { get; set; }
    public String cityFromPage { get; set; }
    public String pinCodeFromPage { get; set; }
    public String streetFromPage { get; set; }
    public String localityFromPage { get; set; }
    public String residenceAddress { get; set; }
    
    Public Account accountList {get;set;}
    Public Opportunity Opportunity {get;set;}
    Public List<Suggested_Property__c> suggProprtyRecord {get;set;}
    Public Property__c propertyRecord {get;set;}
    Public string ethnicity{get;set;}
    
    public boolean makeItReadOnly {get;set;}
    Public string cpFirmName{get;set;}
    Public string CPName{get;set;}
    public string reraNumber {get;set;}
    public string channelPartnerNumber {get;set;}
    public boolean newchannelPartner {get;set;}
    
    public Boolean showReferralByCustomer { get; set; }
    public String referralId { get; set; }
    Public String referralName {get;set;}
    Public String referralByCustomerId {get;set;}
    
    public Boolean showReferralByOther { get; set; }
    public String referralType { get; set; }
    Public String referralFirstName {get;set;}
    Public String referralLastName {get;set;}
    Public String referralByMobileNumber {get;set;}
    // public List<SelectOption> selectedLocalityAddOption { get; set; }
    
    
    Public EOICAFormController(ApexPages.StandardController stdController) {
        ShowForm = false;
        otpBtnValue='Get OTP';
        items = new List<List<ItemWrapper>>();
        selectedItems = new List<String>();
        List<String> values = New List<String>();
        
        
        DescribeFieldResult fieldResult = Schema.Opportunity.Walk_In_Source__c.getDescribe();
        
        // Schema.DescribeFieldResult fieldResult = Opportunity.Walk_In_Source__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry entry : picklistEntries) {
            String picklistValue = entry.getValue();
            values.add(picklistValue);
        }
        system.debug('values---'+values.size());
        integer outerRow = values.size()/5;
        
        if(values.size() > outerRow * 5)
        { 
            outerRow = outerRow+ 1;
        }
        system.debug('outerRow'+outerRow);
        integer k = 0;
        integer l =0;
        for (Integer i = 0; i < outerRow; i++) {
            
            List<ItemWrapper> row = new List<ItemWrapper>();
            for (Integer j = 0; j < 5; j++) {
                
                system.debug('Sum'+k+l);
                if(l <  values.size())
                {
                    String picklistValue = values[l];
                    ItemWrapper item = new ItemWrapper(picklistValue);
                    row.add(item);
                    l++;
                }
                
                
            }
            items.add(row);
        }
        showHeader = true;
        makeItdefaultReadOnly = true;
        isverifyed = true;
        recordId = ApexPages.currentPage().getParameters().get('Id');
        Opportunity = [SELECT id, Name,AccountId, Project__c, Walk_in_Source__c,Budget1__c,Project__r.Name,
                       Construction_Status__c, Source_of_Funding__c, Nature_of_Use__c,Last_Site_Visit_Date_CIF__c,
                       Interested_Configuration__c,Date_of_Site_Visit__c,Channel_Partner__c,EOI_CA__c,
                       Channel_Partner__r.Name, Sales_Manager__c,Sales_Manager__r.Name,Channel_Partner__r.RERA_Number__c,
                       Sourcing_Manager__c,Sourcing_Manager__r.Name, Secondary_Sales_Manager__c,Channel_Partner__r.Phone,
                       Secondary_Sales_Manager__r.Name,Referral_By_Customer__r.Name, Project_Carpet_Area__c, 
                       Referral_By_Customer__c, Referral_Type__c, Referral_Name__c, Referral_Mobile_Number__c,
                       Account.Salutation,Account.FirstName,Account.LastName,Account.PersonEmail,EOI_CA_stage__c,
                       Account.PersonMobilePhone,Account.Name,EOI_CA_Payment_Received__c,EOI_CA_Form_Sent_Date_Time__c,
                       Project__r.Configuration__c,Project__r.Budgets__c,Project__r.Project_Carpet_Area__c,
                       Project__r.Launch_CA_Period_s_End_Date__c, Project__r.Launch_EOI_Period_s_End_Date__c,
                       project__r.EOI_Terms_Conditions__c,project__r.CA_Terms_Conditions__c,ownerId,EOI_CA_Number__c
                       FROM Opportunity 
                       WHERE Id =: recordId 
                       AND StageName != 'Closed Won' AND StageName != 'Closed Lost'
                       AND StageName != 'Booking Cancelled – Refund Pending' AND StageName != 'Cancellation Initiated' Limit 1];
        multiSelectBudgetValues = new List<String>();
        budgetPicklistOptions = new List<SelectOption>();
        if ( Opportunity.Project__r.Budgets__c != null) {
            multiSelectBudgetValues = Opportunity.Project__r.Budgets__c.split(';'); // Assuming values are separated by semicolon
        }
        // Create picklist options from multi-select values
        for (String value : multiSelectBudgetValues) {
            budgetPicklistOptions.add(new SelectOption(value, value));
        }
        List<String> multiSelectprojectConfigurationValues = new List<String>();
        projectConfigurationPicklistOptions = new List<SelectOption>();
        if (Opportunity.Project__r.Configuration__c != null) {
            multiSelectprojectConfigurationValues = Opportunity.Project__r.Configuration__c.split(';'); // Assuming values are separated by semicolon
        }
        // Create picklist options from multi-select values
        for (String value : multiSelectprojectConfigurationValues) {
            projectConfigurationPicklistOptions.add(new SelectOption(value, value));
        }
        if(Opportunity.EOI_CA__c == 'EOI')
            {
                termsAndCondition = Opportunity.project__r.EOI_Terms_Conditions__c;
            }
            else if(Opportunity.EOI_CA__c == 'CA')
            {
                termsAndCondition = Opportunity.project__r.CA_Terms_Conditions__c;

            }
        // Carpet Area
        List<String> multiSelectprojectCarpetValues = new List<String>();
        selectedCarpetAreaAddOption = new List<SelectOption>();
        if (Opportunity.Project__r.Project_Carpet_Area__c != null) {
            multiSelectprojectCarpetValues = Opportunity.Project__r.Project_Carpet_Area__c.split(';'); // Assuming values are separated by semicolon
        }
        // Create picklist options from multi-select values
        for (String value : multiSelectprojectCarpetValues) {
            selectedCarpetAreaAddOption.add(new SelectOption(value, value));
        }
        system.debug('Opportunity.EOI_CA_Form_Sent_Date_Time__c'+Opportunity.EOI_CA_Form_Sent_Date_Time__c);
        system.debug('Opportunity.EOI_CA_Form_Sent_Date_Time__c'+Opportunity.EOI_CA_Form_Sent_Date_Time__c.addHours(24));
        if(Opportunity.EOI_CA_Form_Sent_Date_Time__c != null 
           && Opportunity.EOI_CA_Form_Sent_Date_Time__c.addHours(24) > system.now()
           && ((Opportunity.EOI_CA__c == 'CA' && Opportunity.Project__r.Launch_CA_Period_s_End_Date__c >= system.Today()) ||
               (Opportunity.EOI_CA__c == 'EOI' && Opportunity.Project__r.Launch_EOI_Period_s_End_Date__c >= system.Today()) )){
                   ShowForm = true;
                   List<Project__c> projectList = [SELECT id, name,OTP_Disable_Till__c, Project_Header__c,Budgets__c, 
                                                   Project_Footer__c, Configuration__c,Project_Carpet_Area__c  
                                                   FROM Project__c 
                                                   WHERE id =: Opportunity.Project__c];
                   List<Account> accountExistList  = [SELECT id, Name,PersonMobilePhone,PersonEmail,FirstName,MiddleName,LastName,Salutation,
                                                      Locality__c,Apartment_Flat__c,Office_Pin_Code__c,PersonOtherPhone,Phone,	
                                                      Office_Locality__c, Industry__c, Company_Name__pc,
                                                      Nationality__c, Country_Code__c, Martial_Status__pc, Designation_or_Position__pc,
                                                      Age__c, PersonMailingStreet, PersonMailingState,PersonMailingPostalCode,
                                                      PersonMailingCountry,PersonMailingCity,Employment_Type__c,Residence_Address__c
                                                      FROM Account 
                                                      WHERE id =: Opportunity.AccountId Limit 1];
                   if( accountExistList[0].Residence_Address__c != null &&  accountExistList[0].Residence_Address__c != '')
                   {
                        residenceAddress = accountExistList[0].Residence_Address__c;
                   }
                   else
                   {
                       if(accountExistList[0].PersonMailingStreet != null && accountExistList[0].PersonMailingStreet != '')
                       {
                           residenceAddress = accountExistList[0].PersonMailingStreet +' ';
                       }
                       if(accountExistList[0].PersonMailingCity != null && accountExistList[0].PersonMailingCity != '')
                       {
                           residenceAddress = residenceAddress +accountExistList[0].PersonMailingCity +' ';
                       }
                       if(accountExistList[0].PersonMailingCity != null && accountExistList[0].PersonMailingCity != '')
                       {
                           residenceAddress = residenceAddress +accountExistList[0].PersonMailingCity +' ';
                       }
                       if(accountExistList[0].PersonMailingState != null && accountExistList[0].PersonMailingState != '')
                       {
                           residenceAddress = residenceAddress +accountExistList[0].PersonMailingState +' ';
                       }
                        if(accountExistList[0].PersonMailingCountry != null && accountExistList[0].PersonMailingCountry != '')
                       {
                           residenceAddress = residenceAddress +accountExistList[0].PersonMailingCountry;
                       }
                   }
                  
                   SecondaryMobileNo = accountExistList[0].Phone;
                   primaryAccountSalutation = accountExistList[0].Salutation;
                   primaryAccountFirstName = accountExistList[0].FirstName;
                   primaryAccountMiddleName = accountExistList[0].MiddleName;
                   primaryAccountLastName = accountExistList[0].LastName;
                   primaryAccountEmail = accountExistList[0].PersonEmail;
                   primaryAccountMobileNo = accountExistList[0].PersonMobilePhone;
                   selectedPrimaryAccNationality = accountExistList[0].Nationality__c;
                   selectedPrimaryAccMaitalStatusAdd = accountExistList[0].Martial_Status__pc;
                   selectedPrimaryAccCountryCodeAdd = accountExistList[0].Country_Code__c;
                   companyName = accountExistList[0].Company_Name__pc;
                   designation = accountExistList[0].Designation_or_Position__pc;
                   selectedPrimaryAccAgeAdd = accountExistList[0].Age__c;
                   primaryAccMailingAddStreet =accountExistList[0].PersonMailingStreet;
                   primaryAccMailingAddState =accountExistList[0].PersonMailingState;
                   primaryAccMailingAddPostalCode=accountExistList[0].PersonMailingPostalCode;
                   primaryAccMailingAddCountry=accountExistList[0].PersonMailingCountry;
                   primaryAccMailingAddCity=accountExistList[0].PersonMailingCity;
                   apartmentFlat=accountExistList[0].Apartment_Flat__c;
                   locality=accountExistList[0].Locality__c	;
                   officeLocation = accountExistList[0].Office_Locality__c;
                   Industry = accountExistList[0].Industry__c;
                   selectedEmploymentType = accountExistList[0].Employment_Type__c;
                   officePinCode = accountExistList[0].Office_Pin_Code__c;
                   officeLocation = accountExistList[0].Office_Locality__c;
                   designation = accountExistList[0].Designation_or_Position__pc;
                   companyName = accountExistList[0].Company_Name__pc;
                   System.debug('projectList'+projectList);
                   if(!projectList.isempty()){
                       ProjectHeader = projectList[0].Project_Header__c;
                       ProjectFooter = projectList[0].Project_Footer__c;
                       ProjectName = projectList[0].Name;
                   }
                   suggProprtyRecord=[Select Id,Name,Opportunity__c,Unit__c 
                                      From Suggested_Property__c 
                                      Where Opportunity__c =: recordId AND Status__c = 'Confirmed Allocation'];
                   if(!suggProprtyRecord.isEmpty()){
                       propertyRecord=[Select Id,Name,Annexure__c,Annexures__c,Terms_Conditions__c,Flat_Type__c,RERA_Carpet_Area__c,RERA_Carpet_Area_in_sqmtr__c,Utility_Area__c,Enclosed_balcony__c,Deck_Carpet_Area__c,
                                       Proposed_Area__c,Proposed_Area_c_in_sqmtr__c,Approved_Area__c,Approved_Area_in_sqmtr__c,Deck_Approved_Area__c,Deck_Proposed_Area__c,Proposed_Utility_Area__c,
                                       Proposed_Enclosed_Balcony_Area__c,Deck_Carpet_Area_c_in_sqmtr__c,Property_Area__c,Utility_Area_in_sqmtr__c,Enclosed_Balcony_in_sqmtr__c,
                                       Property_Area_in_sqmtr__c,Proposed_Deck_Area_in_sq_mt__c,Approved_Deck_Area_in_sq_mt__c,Proposed_Utility_Area_in_sq_mt__c,Proposed_Enclosed_Balcony_Area_sq_mt__c,
                                       Total_Area__c,Total_Area_in_sq_mt__c,Proposed_Total_Area__c,Proposed_Total_Area_in_sq_mt__c
                                       From Property__c Where Id=:suggProprtyRecord[0].Unit__c];
                   }
                   
                   selectedValue =  Opportunity.Walk_in_Source__c;
                   if(Opportunity.Walk_in_Source__c == 'Channel Partner')
                   {
                       
                       showChannelPartner = true;
                       system.debug('showChannelPartner'+showChannelPartner);
                       channelStringPartnerRecordID = Opportunity.Channel_Partner__c;
                       channelPartnerName = Opportunity.Channel_Partner__r.Name;
                       sourcingManagerName = Opportunity.Sourcing_Manager__r.Name;
                       sourcingManagerId = Opportunity.Sourcing_Manager__c;
                   }
                   if( Opportunity.Walk_in_Source__c == 'Referred by Existing Customer')
                   {
                       
                       showReferralByCustomer = true;
                       system.debug('showChannelPartner'+showChannelPartner);
                       referralId =Opportunity.Referral_By_Customer__c;
                       referralName = Opportunity.Referral_By_Customer__r.Name;
                       referralByCustomerId = Opportunity.Referral_By_Customer__c;
                   }
                   if( Opportunity.Walk_in_Source__c == 'Referred by Others')
                   {
                       
                       showReferralByOther = true;
                       system.debug('showChannelPartner'+showChannelPartner);
                       referralType = Opportunity.Referral_Type__c;
                       referralByMobileNumber = opportunity.Referral_Mobile_Number__c;
                       referralFirstName = Opportunity.Referral_Name__c.Substring(0,Opportunity.Referral_Name__c.indexOf(' '));
                       referralLastName = Opportunity.Referral_Name__c.Substring(Opportunity.Referral_Name__c.indexOf(' '),Opportunity.Referral_Name__c.length());
                   }
                   projectCarpetArea = Opportunity.Project_Carpet_Area__c;
                   salesManagerId = Opportunity.Sales_Manager__c;
                   salesManagerName = Opportunity.Sales_Manager__r.Name;
                   secondarySalesManagerId = Opportunity.Secondary_Sales_Manager__c;
                   secondarySalesManagerName = Opportunity.Secondary_Sales_Manager__r.Name;
                   selectedWalkInSourceAdd = Opportunity.Walk_in_Source__c;
                   selectedconstructionStatusAdd  = Opportunity.Construction_Status__c;
                   selectedSourceOfFundingStatus = Opportunity.Source_of_Funding__c ;
                   selectedNatureInUseAdd = Opportunity.Nature_of_Use__c;
                   selectedProjectConfigurationAdd = Opportunity.Interested_Configuration__c;
                   selectedBudgetPicklistValue = Opportunity.Budget1__c;
               }
        else
        {
            
        }
        
    }
    
    
    // OTP Code 
    
    Public PageReference sendOtpM(){
        system.debug('otpBtnValue'+otpBtnValue);
        if(Opportunity.AccountId != null)
        {
            try{
                Account accountRcd=new Account();
                Integer len = 5;
                String str = string.valueof(Math.abs(Crypto.getRandomLong()));
                String randomNumberStr = str.substring(0, len);
                randomNumber = Integer.valueOf(randomNumberStr);
                system.debug('Random Number-' + randomNumber);
                accountRcd.Id = Opportunity.AccountId;
                accountRcd.Account_Form_OTP__c = string.valueOf(randomNumber);
                try
                {
                    update accountRcd;
                }
                catch(DmlException ex){
                    ApexPages.addMessages(ex);
                    return null; 
                }
                
            }catch(Exception e){
                System.debug('The following exception has occurred: ' + e.getMessage());
                ApexPages.addMessages(e);
                return null; 
            } 
        }
        
        return null; 
    }
    
    Public PageReference callOut(){
        try{
            String  record  = ApexPages.currentPage().getParameters().get('Id');
            System.debug('recordId>>'+recordId);
            
            String msgBody = '';
            String cifMsgBody = '';
            List<BookingForm_OTP_Data__mdt> otpContent = BookingForm_OTP_Data__mdt.getAll().values();
            System.debug('otpContent:'+otpContent);
            List<Project__c> projectList = [SELECT id, name, Project_Header__c, Budgets__c, 
                                            Project_Footer__c, Configuration__c, Project_Email__c 
                                            from Project__c WHERE id =: opportunity.Project__c];
            
            if(otpContent.size()>0){
                
                String bearerToken= otpContent[0].Bearer_Token__c;
                System.debug('BearerToken:'+BearerToken);
                String endPoint= otpContent[0].End_Point__c;
                System.debug('endPoint:'+endPoint);
                String contentTypeHeader= otpContent[0].Content_Type_Header__c;
                System.debug('contentTypeHeader:'+contentTypeHeader);  
                String authorizationHeader= otpContent[0].Authorization_Header__c;
                System.debug('authorizationHeader:'+authorizationHeader);  
                msgBody= otpContent[0].Message_Body__c;
                System.debug('msgBody:'+msgBody);  
                
                cifMsgBody= otpContent[0].CIF_OTP_Message_Body__c;
                System.debug('cifMsgBody:'+cifMsgBody);  
                cifMsgBody = cifMsgBody.replace('{1}',projectList[0].name );
                cifMsgBody = cifMsgBody.replace('{2}',string.valueOf(randomNumber));
                System.debug('update msgBody:'+msgBody);
                //  String BearerToken =System.Label.Bearer_Token_For_OTP;
                String returnStat;
                EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'EOI/CA OTP' LIMIT 1];
                system.debug('smsEmailTemp'+smsEmailTemp);
                if(smsEmailTemp!=null && Opportunity.Account.PersonMobilePhone != null){
                    String templateBody=smsEmailTemp.HtmlValue;
                    templateBody=templateBody.stripHtmlTags();
                    String mobileNumber = Opportunity.Account.PersonMobilePhone;
                    templateBody = templateBody.replace('{{customerName}}',Opportunity.Account.Name);
                    templateBody = templateBody.replace('{{projectName}}', projectList[0].name);
                    templateBody = templateBody.replace('{{OTP}}', string.valueOf(randomNumber));
                    templateBody = templateBody.replace('{{EOI_CA_Number}}',Opportunity.EOI_CA_Number__c);
                    SendSMSUtility.sendSMSMethod(templateBody,mobileNumber,'DYNAMIX',otpContent[0].CIF_Template_Id__c);
                    
                }
                
            }          
            OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where Address = : projectList[0].Project_Email__c];
            if(Opportunity.Account.PersonEmail  != '' && Opportunity.Account.PersonEmail != null)
            {
                EmailTemplate otpEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'EOI/CA OTP' LIMIT 1];
                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                String[] sendingTo = new String[]{ Opportunity.Account.PersonEmail}; 
                semail.setToAddresses(sendingTo);
                String templateBody=otpEmailTemp.HtmlValue;
                templateBody=templateBody.stripHtmlTags();
                templateBody = templateBody.replace('{{customerName}}',Opportunity.Account.Name);
                templateBody = templateBody.replace('{{projectName}}', projectList[0].name);
                templateBody = templateBody.replace('{{OTP}}', string.valueOf(randomNumber));
                templateBody = templateBody.replace('{{EOI_CA_Number}}',Opportunity.EOI_CA_Number__c);
                semail.setSubject('OTP'); 
                semail.setPlainTextBody(templateBody);
                semail.setOrgWideEmailAddressId(orgEmail.Id);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
                
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
        
        return null;
    }
    
    
    Public PageReference verifyOtp(){  
        system.debug('verifyOtp'+Opportunity.AccountId);
        try{
            
            Account accountRecord = [select id,Account_Form_OTP__c, PersonMobilePhone from Account where id = :Opportunity.AccountId];
            if(accountRecord.Account_Form_OTP__c == otpCode){            
                sucessMsg = 'OTP Code Verified'; 
                errorMsg ='';
                sucessMsg = 'OTP Code Verified'; 
                system.debug('OTP Code Verified');
                otpBtnValue='Resend OTP';
                errorMsg ='';
                isverifyed = false;
                isSubmitButtonDisable = false;
                recordId = ApexPages.currentPage().getParameters().get('Id');
                Opportunity Opportunity = New Opportunity();
                Opportunity.EOI_CA_Form_Submission_OTP__c = otpCode;
                Opportunity.Id = recordId;
                
                update Opportunity;
            }
            else
            {
                errorMsg = 'Your entered OTP is Invalid / Expired';
                sucessMsg ='';
            }
            
            
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
        return null;
    }    
    
    
    // END OF OTP Code 
    
    //  Picklist
    public List<SelectOption> getprimaryAccountSalutationOption() {
        List<SelectOption> primaryAccountSalutationOption = new List<SelectOption>();
        primaryAccountSalutationOption.add(new SelectOption('','None'));
        primaryAccountSalutationOption.add(new SelectOption('Mr.','Mr.'));
        primaryAccountSalutationOption.add(new SelectOption('Mrs.','Mrs.')); 
        primaryAccountSalutationOption.add(new SelectOption('Ms.','Ms.')); 
        return primaryAccountSalutationOption;
    }
    public void onChangePrimaryAccNationality(){
        System.debug('selectedPrimaryAccNationality:'+selectedPrimaryAccNationality);
    }
    
    public void onChangeMaritalStatus(){
        System.debug('selectedPrimaryAccMaitalStatusAdd:'+selectedPrimaryAccMaitalStatusAdd);
        System.debug('selectedWalkInSourceAdd:----'+selectedWalkInSourceAdd);
    }
    public List<SelectOption> getselectedPrimaryAccNationalityOptions()
    {        
        List<SelectOption> selectedPrimaryAccNationalityOptions = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('Nationality__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // Add these values to the selectoption list.
        selectedPrimaryAccNationalityOptions.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : values){
            selectedPrimaryAccNationalityOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedPrimaryAccNationalityOptions;
    }
    public List<SelectOption> getselectedPrimaryAccAgeAddOption()
    {        
        List<SelectOption> selectedPrimaryAccAgeAddOption = new List<SelectOption>();
        Schema.sObjectType objType = Account.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        list<Schema.PicklistEntry> values = fieldMap.get('Age__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        for (Schema.PicklistEntry a : values){
            selectedPrimaryAccAgeAddOption.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedPrimaryAccAgeAddOption;
    } 
    
    public List<SelectOption> getselectedPrimaryAccCountryCodeAddOption()
    {        
        List<SelectOption> selectedPrimaryAccCountryCodeAddOption = new List<SelectOption>();
        Schema.sObjectType objType = Account.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        list<Schema.PicklistEntry> values = fieldMap.get('Country_Code__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        selectedPrimaryAccCountryCodeAddOption.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : values){
            selectedPrimaryAccCountryCodeAddOption.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedPrimaryAccCountryCodeAddOption;
    } 
    public List<SelectOption> getselectedPrimaryAccMaitalStatusAddOption()
    {        
        List<SelectOption> selectedPrimaryAccMaitalStatusAddOption = new List<SelectOption>();
        Schema.sObjectType objType = Account.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        list<Schema.PicklistEntry> values = fieldMap.get('Martial_Status__pc').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        for (Schema.PicklistEntry a : values){
            selectedPrimaryAccMaitalStatusAddOption.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedPrimaryAccMaitalStatusAddOption;
    }     
    
    public List<SelectOption> getlistSelectedContact() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Indian','Indian')); 
        options.add(new SelectOption('Non-Resident Indian','Non-Resident Indian'));
        options.add(new SelectOption('Foreign National of Indian Origin','Foreign National of Indian Origin')); 
        return options; 
    }
    
    public List<SelectOption> getEmploymentTypeOption()
    {        
        List<SelectOption> selectedEmploymentTypeAddOption = new List<SelectOption>();
        Schema.sObjectType objType = Account.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        list<Schema.PicklistEntry> values = fieldMap.get('Employment_Type__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        for (Schema.PicklistEntry a : values){
            selectedEmploymentTypeAddOption.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedEmploymentTypeAddOption;
    } 
    
    
    public List<List<SelectOption>> getselectedWalkInSourceAddOption()
    {        
        
        List<List<SelectOption>> selectedWalkInSourceAddOption = new List<List<SelectOption>>();
        Schema.sObjectType objType = Opportunity.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        list<Schema.PicklistEntry> values = fieldMap.get('Walk_in_Source__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // selectedPrimaryAccMaitalStatusAddOption.add(new SelectOption('','None'));
        List<SelectOption> internalList = new List<SelectOption>();
        List<SelectOption> internalListSize = new List<SelectOption>();
        Integer i=0;
        for (Schema.PicklistEntry a : values){
            internalListSize.add(new SelectOption(a.getValue(),a.getValue()));
        }
        Integer CountSize = internalListSize.size();
        System.debug('internalList.size()' +CountSize);
        for (Schema.PicklistEntry a : values){
            internalList.add(new SelectOption(a.getValue(),a.getValue()));
            System.debug('internalList.size()' +internalList.size() );
            if(internalList.size() == 5)
            {
                selectedWalkInSourceAddOption.add(internalList);
                internalList = new List<SelectOption>();
                
            }
            else if(internalList.size() == CountSize)
            {
                selectedWalkInSourceAddOption.add(internalList);
                internalList = new List<SelectOption>();
            }
            i++;
            //selectedWalkInSourceAddOption.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedWalkInSourceAddOption;
    }  
    
    
    
    public void  onChangeWalkInSource(){
        system.debug('selectedWalkInSourceAdd----'+ selectedWalkInSourceAdd);
        if(selectedWalkInSourceAdd== 'Channel Partner')
            showChannelPartner = true;
        else{
            showChannelPartner = false;
        }
    }
    public List<SelectOption> getselectedNatureOfSourceAddOption()
    {        
        List<SelectOption> selectedNatureOfSourceAddOption = new List<SelectOption>();
        Schema.sObjectType objType = Opportunity.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        list<Schema.PicklistEntry> values = fieldMap.get('Nature_of_Use__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // selectedPrimaryAccMaitalStatusAddOption.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : values){
            selectedNatureOfSourceAddOption.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedNatureOfSourceAddOption;
    } 
    
    public List<SelectOption> getselectedConstructionStatusAddOption()
    {        
        List<SelectOption> selectedConstructionStatusAddOption = new List<SelectOption>();
        Schema.sObjectType objType = Opportunity.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        list<Schema.PicklistEntry> values = fieldMap.get('Construction_Status__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // selectedPrimaryAccMaitalStatusAddOption.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : values){
            selectedConstructionStatusAddOption.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedConstructionStatusAddOption;
    } 
    
    public List<SelectOption> getselectedSourceOfFundingAddOption()
    {        
        List<SelectOption> selectedSourceOfFundingAddOption = new List<SelectOption>();
        Schema.sObjectType objType = Opportunity.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        list<Schema.PicklistEntry> values = fieldMap.get('Source_of_Funding__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // selectedPrimaryAccMaitalStatusAddOption.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : values){
            selectedSourceOfFundingAddOption.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedSourceOfFundingAddOption;
    } 
    
    public List<SelectOption> getselectedEmploymentTypeAddOption()
    {        
        List<SelectOption> selectedEmploymentTypeAddOption = new List<SelectOption>();
        Schema.sObjectType objType = Account.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        list<Schema.PicklistEntry> values = fieldMap.get('Employment_Type__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        for (Schema.PicklistEntry a : values){
            selectedEmploymentTypeAddOption.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedEmploymentTypeAddOption;
    } 
    
    public List<SelectOption> getselectedReferralTypeAddOption()
    {        
        List<SelectOption> selectedReferralTypeAddOption = new List<SelectOption>();
        Schema.sObjectType objType = Opportunity.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        list<Schema.PicklistEntry> values = fieldMap.get('Referral_Type__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        for (Schema.PicklistEntry a : values){
            selectedReferralTypeAddOption.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedReferralTypeAddOption;
    }
    public PageReference onChangeUnregisteredCP() {
        system.debug('UnregisteredCP'+UnregisteredCP);
        if(UnregisteredCP == true)
        {
            newchannelPartner = true;
        }
        else
        {
            newchannelPartner = false;
        }
        return null;
        // projectGSTApplicable = project.GST_Applicable__c;
    }
    public void submitSelectedItems() {
        system.debug('');
        selectedItems.clear();
        for (List<ItemWrapper> row : items) {
            for (ItemWrapper item : row) {
                if (item.selectedOption != null) {
                    selectedItems.add(item.selectedOption);
                }
            }
        }
        STring test;
        // Display selected items using System.debug
        for (String selectedItem : selectedItems) {
            test = selectedItem;
            System.debug('Selected Item: ' + selectedItem);
            
        }
        System.debug('Selected Item: ' + test);
        if(test== 'Channel Partner')
            showChannelPartner = true;
        else{
            showChannelPartner = false;
        }
    }
    
    
    public class ItemWrapper {
        public String name { get; set; }
        public String selectedOption { get; set; }
        
        public ItemWrapper(String name) {
            this.name = name;
            this.selectedOption = '';
        }
    }
    public PageReference updateSelectedValue() {
        // Handle the selected value here, which is available in selectedValue
        System.debug('Selected Value: ' + selectedValue);
        // You can perform any necessary logic with the selected value here
        if(selectedValue == 'Channel Partner')
        {
            showChannelPartner = true;
        }
        else
        {
            showChannelPartner = false;
        }
        if(selectedValue == 'Referred by Existing Customer')
        {
            showReferralByCustomer = true;
        }
        else
        {
            showReferralByCustomer = false;
        }
        if(selectedValue == 'Referred by Others')
        {
            showReferralByOther = true;
        }
        else
        {
            showReferralByOther = false;
        }
        // Return null or a PageReference based on your requirement
        return null;
    }
    
    
    public List<SelectOption> getselectedLocalityAddOption()
    {        
        List<SelectOption> selectedLocalityAddOption = new List<SelectOption>();
        List<Locality__mdt> localityList = [Select label,id FROM Locality__mdt ORDER BY Label ASC];
        selectedLocalityAddOption.add(new SelectOption('','--None--'));
        for (Locality__mdt locality : localityList){
            selectedLocalityAddOption.add(new SelectOption(locality.label,locality.label));
        }
        return selectedLocalityAddOption;
    }
    
    public List<SelectOption> getselectedEthnicityAddOption()
    {        
        List<SelectOption> selectedEthnicityAddOption = new List<SelectOption>();
        Schema.sObjectType objType = Contact.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        list<Schema.PicklistEntry> values = fieldMap.get('Ethnicity__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        selectedEthnicityAddOption.add(new SelectOption('','--None--'));
        for (Schema.PicklistEntry a : values){
            selectedEthnicityAddOption.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedEthnicityAddOption;
    }
    public List<SelectOption> getselectedFloorAddOption()
    {        
        List<SelectOption> selectedFloorAddOption = new List<SelectOption>();
        Schema.sObjectType objType = Project__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        list<Schema.PicklistEntry> values = fieldMap.get('EOI_CA_Floor__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        selectedFloorAddOption.add(new SelectOption('','--None--'));
        for (Schema.PicklistEntry a : values){
            selectedFloorAddOption.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedFloorAddOption;
    }
    
    // END OF PICKLIST CODE
    // 
    public PageReference submitEOICAForm(){
        System.debug('State from page: ' + stateFromPage);
        System.debug('Country from page: ' + countryFromPage);
        System.debug('City from page: ' + cityFromPage);
        System.debug('Pin Code from page: ' + pinCodeFromPage);
        
        if(CountryFromPage != null && CountryFromPage != '')
        {
            primaryAccMailingAddCountry = CountryFromPage;
        }
        if(stateFromPage != null && stateFromPage != '')
        {
            System.debug('stateFromPage'+stateFromPage);
            primaryAccMailingAddState = stateFromPage;
            System.debug('primaryAccMailingAddState'+primaryAccMailingAddState);
        }
        if(CityFromPage != null && CityFromPage != '')
        {
            primaryAccMailingAddCity = CityFromPage;
        }
        if(PinCodeFromPage != null && PinCodeFromPage != '')
        {
            primaryAccMailingAddPostalCode = PinCodeFromPage;
        }
        if(streetFromPage != null && streetFromPage != '')
        {
            primaryAccMailingAddStreet = streetFromPage;
        }
        if(localityFromPage != null && localityFromPage != '')
        {
            locality = localityFromPage;
        }
        if(localityFromPage == null || localityFromPage == '')
        {
            locality = '';
        }
        if(primaryAccountLastName=='' ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Last name.'));
        }
        if(primaryAccountFirstName=='' ){
        //    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in First name.'));
        }
        
        if(primaryAccountMobileNo=='' ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Phone Number.'));
        }
        if(primaryAccMailingAddCity=='' || primaryAccMailingAddCity == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in City.'));
        }
        if(primaryAccMailingAddStreet=='' || primaryAccMailingAddStreet == null){
            // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter Street.'));
        }
        if(primaryAccMailingAddPostalCode==''  || primaryAccMailingAddPostalCode == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Postal Code.'));
        }
        
        if(apartmentFlat =='' ){
            // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Apartment/Flat.'));
        }
        if(primaryAccMailingAddState ==''  || primaryAccMailingAddState == null ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in State.'));
        }
        if(primaryAccMailingAddCountry =='' || primaryAccMailingAddCountry == null ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Country.'));
        }
        
        if(selectedProjectConfigurationAdd == '' || selectedProjectConfigurationAdd == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Configuration.'));
        }
        
        if(selectedBudgetPicklistValue =='' || selectedBudgetPicklistValue == null ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Budget.'));
        }
        
        if(selectedWalkInSourceAdd =='' ||  selectedWalkInSourceAdd == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Walk in Source.'));
        }
        if(selectedWalkInSourceAdd !='' &&  selectedWalkInSourceAdd != null && myField != '' && UnregisteredCP == true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select one Channel Partner.'));
        }
        if(selectedWalkInSourceAdd !=''&&  selectedWalkInSourceAdd != null && UnregisteredCP == true && CPName == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in CP Name.'));
        }
        if(selectedWalkInSourceAdd !='' &&  selectedWalkInSourceAdd != null && UnregisteredCP == true && cpFirmName == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in CP Firm Name.'));
        }
        if(salesManagerId =='')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Sales Manager.'));            
        }
        if((sourcingManagerId =='' || sourcingManagerId == null) && selectedWalkInSourceAdd =='Channel Partner')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Sourcing Manager.'));            
        }
        if((channelStringPartnerRecordID =='' || channelStringPartnerRecordID == null) && selectedWalkInSourceAdd =='Channel Partner' && UnregisteredCP != true )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Channel Partner.'));            
        }
        if(channelStringPartnerRecordID !='' && selectedWalkInSourceAdd =='Channel Partner' && UnregisteredCP == true )
        {
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select one  Channel Partner.'));            
        }
        if(selectedWalkInSourceAdd !=''&& selectedWalkInSourceAdd != null && UnregisteredCP == true && channelPartnerNumber == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in CP Mobile Number.'));
        }
        /*if(selectedSourceOfFundingStatus =='' || selectedSourceOfFundingStatus == null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Source of Funding.'));
}*/
        //  System.debug('Length '+primaryAccountMobileNo.length() );
        /*if(primaryAccountMobileNo.length() != 10 && selectedPrimaryAccCountryCodeAdd == '+91')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter valid Phone Number.'));
            
        }
        
        if(primaryAccountMobileNo.length() == 12  && primaryAccountMobileNo.substring(0, 2) != '91' && selectedPrimaryAccCountryCodeAdd == '+91')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter valid Phone Number.'));
            
        }
        else if(primaryAccountMobileNo.length() == 13  && primaryAccountMobileNo.substring(0, 2) != '+91' && selectedPrimaryAccCountryCodeAdd == '+91')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter valid Phone Number.'));
            
        }
        else
        {
            if(primaryAccountMobileNo.length() != 10 && selectedPrimaryAccCountryCodeAdd == '+91')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter valid Phone Number.'));
                
            }
        }*/
        /*  if(selectedconstructionStatusAdd =='' || selectedconstructionStatusAdd == null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Construction Status.'));
}*/
        if(selectedProjectConfigurationAdd =='' || selectedProjectConfigurationAdd == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Configuration.'));
        }
        
        
        if(projectCarpetArea =='' || projectCarpetArea == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Carpet Area.'));
        }
        
       /* if(selectedPrimaryAccCountryCodeAdd  =='' ||  selectedPrimaryAccCountryCodeAdd == 'None' || selectedPrimaryAccCountryCodeAdd == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Country Code.'));
        }*/
        
        if(primaryAccountLastName.isAlphaSpace() == false)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Last Name Can only contains alphabets.'));
            
        }
        if(primaryAccountLastName  != '' //&& primaryAccountEmail  != '' 
           && primaryAccountMobileNo != '' && primaryAccountSalutation != '' && primaryAccountSalutation != 'None'
           && selectedPrimaryAccAgeAdd != '' && selectedconstructionStatusAdd  != ''   && 
           selectedProjectConfigurationAdd != '' &&  selectedProjectConfigurationAdd != null && 
           selectedBudgetPicklistValue != '' && selectedconstructionStatusAdd  != '' 
           // primaryAccMailingAddStreet != '' && apartmentFlat != '' &&  locality != ''  && selectedNatureInUseAdd  != ''&&
           
           && primaryAccMailingAddPostalCode != '' &&  primaryAccMailingAddPostalCode != null
           && primaryAccMailingAddState != ''  && primaryAccMailingAddState != null && primaryAccMailingAddCountry != ''   && primaryAccMailingAddCountry !=null 
           && primaryAccMailingAddCity != '' && primaryAccMailingAddCity != null
           && selectedEmploymentType != ''  &&
           //selectedSourceOfFundingStatus != '' && selectedSourceOfFundingStatus != null &&
           projectCarpetArea != '' 
           && projectCarpetArea!=null && /*((primaryAccountMobileNo.length() == 10 && selectedPrimaryAccCountryCodeAdd == '+91') || 
                                          (primaryAccountMobileNo.length() != 0 && selectedPrimaryAccCountryCodeAdd != '+91'))&&*/
           selectedPrimaryAccCountryCodeAdd!= '' && /*selectedPrimaryAccCountryCodeAdd !=  null && selectedPrimaryAccCountryCodeAdd  != 'None'&&*/
         /*  primaryAccountLastName.isAlphaSpace() == true && primaryAccountFirstName.isAlphaSpace() == true 
           &&*/ selectedWalkInSourceAdd != ''
          )
            
            
        {
            Account acc =New Account();
            acc.PersonMobilePhone = primaryAccountMobileNo;
            acc.PersonEmail = primaryAccountEmail;
           // acc.FirstName =  primaryAccountFirstName.subString(0 ,1).ToUpperCase() +primaryAccountFirstName.subString(1);
           // acc.LastName = primaryAccountLastName.subString(0 ,1).ToUpperCase() +primaryAccountLastName.subString(1);
            //acc.Salutation = primaryAccountSalutation;
            if(apartmentFlat != null && apartmentFlat != '')
            {
                  acc.PersonMailingStreet = apartmentFlat+' '+primaryAccMailingAddStreet;
            }
            else
            {
                acc.PersonMailingStreet = primaryAccMailingAddStreet;
            }
          
            acc.PersonMailingState = primaryAccMailingAddState;
            acc.PersonMailingPostalCode = primaryAccMailingAddPostalCode;
            acc.Apartment_Flat__c = apartmentFlat;
            acc.Locality__c	 = locality;
            acc.Phone = SecondaryMobileNo;
            acc.PersonMailingCountry = primaryAccMailingAddCountry;
            acc.PersonMailingCity = primaryAccMailingAddCity;
            acc.Age__c = selectedPrimaryAccAgeAdd;
         //   acc.Country_Code__c = selectedPrimaryAccCountryCodeAdd;
            acc.Nationality__c = selectedPrimaryAccNationality;
            acc.Company_Name__pc = companyName;
            acc.Designation_or_Position__pc = designation;
            acc.Industry__c = Industry;
            acc.Office_Locality__c = officeLocation;
            acc.Employment_Type__c = selectedEmploymentType;
            if(residenceAddress != null && residenceAddress != '')
            {
                acc.Residence_Address__c = residenceAddress;
            }
            
            if(primaryAccMailingAddStreet != null || primaryAccMailingAddStreet != '')
            {
                acc.PersonMailingStreet = residenceAddress;
            }
            
            acc.id = Opportunity.AccountId;
            system.debug('myField----'+myField);
            system.debug('selectedPrimaryAccMaitalStatusAdd----'+selectedPrimaryAccMaitalStatusAdd);
            system.debug('selectedPrimaryAccNationality----'+selectedPrimaryAccNationality);
            system.debug('selectedBudgetPicklistValue----'+selectedBudgetPicklistValue);
            system.debug('selectedWalkInSourceAdd----'+selectedWalkInSourceAdd);
            system.debug('selectedProjectConfigurationAdd----'+selectedProjectConfigurationAdd);
            acc.Martial_Status__pc = selectedPrimaryAccMaitalStatusAdd;
            //acc.PersonEmail = primaryAccountEmail;
            try{
                upsert acc;
            }
            catch(DmlException ex){
                ApexPages.addMessages(ex);
                return null;
            }
            selectedItems.clear();
            recordId = ApexPages.currentPage().getParameters().get('Id');
            Opportunity opportunityRecord = New Opportunity();
            //Opportunity.EOI_CA_Form_Submission_OTP__c = system.now();
            opportunityRecord.Source_of_Funding__c = selectedSourceOfFundingStatus;
            opportunityRecord.id = recordId;
            opportunityRecord.Nature_of_Use__c = selectedNatureInUseAdd;
            opportunityRecord.Interested_Configuration__c = selectedProjectConfigurationAdd;
            opportunityRecord.Budget1__c  = selectedBudgetPicklistValue;
            opportunityRecord.EOI_CA_Form_Submission_Date_and_Time__c	 = system.now();
            opportunityRecord.EOI_CA_stage__c = 'Confirmed';
            opportunityRecord.Project_Carpet_Area__c = projectCarpetArea ;
            if(selectedFloor != null && selectedFloor !='')
            {
                opportunityRecord.Floor_Preference__c = selectedFloor;
            }
            CustomNotificationType notificationType =  [SELECT Id, DeveloperName 
                                                        FROM CustomNotificationType 
                                                        WHERE DeveloperName='New_Opportunity'];
            
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setTitle(Opportunity.Name +' has submitted '+Opportunity.EOI_CA__c + ' Form');
            notification.setBody('Mr./Ms. '+Opportunity.Name+' has submitted '+Opportunity.EOI_CA_Number__c + ' Form for '+ProjectName+'.');
            // Set the notification type and target
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(Opportunity.id);
            Set<string> receipentId = New Set<string>();
            if(Opportunity.Sales_Manager__c != null){
                receipentId.add(Opportunity.Sales_Manager__c);
            }
            else
            {
                receipentId.add(Opportunity.ownerId);
            }
           
            // Actually send the notification
            try {
                notification.send(receipentId);
            }
            catch (Exception e) {
                System.debug('Problem sending notification: ' + e.getMessage());
            }
        
            try
            {
                update opportunityRecord;
                generateDOC(opportunityRecord.id);
            }
            catch(DmlException ex){
                ApexPages.addMessages(ex);
                return null;
            }
            PageReference pr = new PageReference('/apex/EOICAFormSubmittedMsg');
            pr.setRedirect(true);               
            return pr;
        }
        else
        {
            return null;
        }
    }
    public void Submitlocation() {
        PinCodeFromPage = System.currentPageReference().getParameters().get('PinCodeFromPage');
        CityFromPage = System.currentPageReference().getParameters().get('CityFromPage');
        CountryFromPage = System.currentPageReference().getParameters().get('CountryFromPage');
        stateFromPage = System.currentPageReference().getParameters().get('stateFromPage');
        streetFromPage  = System.currentPageReference().getParameters().get('streetFromPage');
        localityFromPage  = System.currentPageReference().getParameters().get('localityFromPage');
        residenceAddress  = System.currentPageReference().getParameters().get('residenceAddress');
        if((streetFromPage == null || streetFromPage == '') && localityFromPage != '' && localityFromPage != null)
        {
            streetFromPage = localityFromPage;
        }
        else
        {
            streetFromPage = streetFromPage+ ', '+localityFromPage;
        }
        
        //streetFromPage = streetFromPage.replace(stateFromPage,'').replace(CountryFromPage,'').replace(CityFromPage,'').replace(PinCodeFromPage,'');
        //  primaryAccMailingAddState = stateFromPage;
        System.debug('Received state value: ' + stateFromPage);
        System.debug('Received Country value: ' + CountryFromPage);
        System.debug('Received City value: ' + CityFromPage);
        
    }
    @future(callout = true)
    Global static Void generateDOC(String OpportunityId)
    {
        Opportunity Opportunity = [SELECT id, Name,AccountId, Project__c, Walk_in_Source__c,Budget1__c,Project__r.Name,
                                   Construction_Status__c, Source_of_Funding__c, Nature_of_Use__c,Last_Site_Visit_Date_CIF__c,
                                   Interested_Configuration__c,Date_of_Site_Visit__c,Channel_Partner__c,EOI_CA__c,
                                   Channel_Partner__r.Name, Sales_Manager__c,Sales_Manager__r.Name,Channel_Partner__r.RERA_Number__c,
                                   Sourcing_Manager__c,Sourcing_Manager__r.Name, Secondary_Sales_Manager__c,Channel_Partner__r.Phone,
                                   Secondary_Sales_Manager__r.Name,Referral_By_Customer__r.Name, Project_Carpet_Area__c, 
                                   Referral_By_Customer__c, Referral_Type__c, Referral_Name__c, Referral_Mobile_Number__c,
                                   Account.Salutation,Account.FirstName,Account.LastName,Account.PersonEmail,EOI_CA_stage__c,
                                   Account.PersonMobilePhone,EOI_CA_Payment_Received__c,EOI_CA_Form_Sent_Date_Time__c,
                                   Project__r.Configuration__c,Project__r.Budgets__c,Project__r.Project_Carpet_Area__c,
                                   Opportunity.Apartment_Number__c,Account.PersonMailingStreet,Account.PersonMailingState,
                                   Account.PersonMailingPostalCode,Account.PersonMailingCountry,Account.PersonMailingCity,
                                   Account.Locality__c,Account.Apartment_Flat__c,Account.Age__c,Account.Nationality__c,EOI_AutoNumber__c,
                                   Account.Employment_Type__c,Account.Designation_or_Position__pc,Account.Company_Name__pc,
                                   Account.Office_Locality__c,EOI_CA_Form_Submission_Date_and_Time__c,project__r.Project_Email__c,
                                   Project__r.CA_Terms_Conditions__c,Project__r.EOI_Terms_Conditions__c,EOI_CA_Number__c,
                                   Project__r.Launch_CA_Period_s_End_Date__c, Project__r.Launch_EOI_Period_s_End_Date__c
                                   FROM Opportunity 
                                   WHERE Id =: OpportunityId 
                                   Limit 1];
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        Blob body; 
        String Name = '';
        Site mySite = [select Id from Site where Name = 'EOI_CA'];
        SiteDetail mySiteDetail = [select SecureURL from SiteDetail where DurableId = :mySite.Id];
      //  PageReference ref = new PageReference( mySiteDetail.SecureURL + '/apex/EOI_CA_Document').getContentAsPDF();

        PageReference ref = new PageReference(mySiteDetail.SecureURL+'/apex/EOI_CA_Document?id=' + OpportunityId);
        ref.getParameters().put('id',OpportunityId);
        if(Test.isRunningTest()){
            body = Blob.valueOf('EOI CA Document');
        }
        else{
            body = ref.getContentAsPDF();
        }
        ContentVersion conVer =new ContentVersion(); 
        conVer.ContentLocation = 'S'; 
        conVer.PathOnClient = Opportunity.EOI_CA__c+'.pdf'; 
        conVer.Title = Opportunity.EOI_CA__c+'.pdf';
        conVer.VersionData = body;
        conVer.SObjectType__c = 'Opportunity';
        conVer.Document_Type__c = 'EOI/CA Form';
        conVer.FirstPublishLocationId = OpportunityId;
        insert conVer;
        if(Opportunity.Account.FirstName != '' && Opportunity.Account.FirstName != null
           && Opportunity.Account.LastName != '' && Opportunity.Account.LastName != null)
        {
            Name = Opportunity.Account.FirstName + ' ' +Opportunity.Account.LastName;
        }
        else
        {
            Name = Opportunity.Account.LastName; 
        }
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
                     List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();

        try
        {
        
        List<Contentversion> conlist = [select id,ContentDocumentId,Title,VersionData from Contentversion where ContentDocumentId = :conDoc];
        
        for (Contentversion cov : conlist) {
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(cov.Title);
            efa.setBody(cov.VersionData);
            // efa.setContentType(cov.ContentType);
            attachments.add(efa);
        }
        
        }
       catch(Exception ex)
       {
           
       }
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();     
        
        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                       from EmailTemplate 
                                       where DeveloperName = 'EOI_CA_submitted_Form' LIMIT 1];
         List<String> toMailList  = New  List<String> ();
        
        OrgWideEmailAddress OWEA = [Select Id, Address From OrgWideEmailAddress WHERE Address =: Opportunity.project__r.Project_Email__c];
        if(emailTemplate != null && Opportunity.Account.PersonEmail != null && Opportunity.Account.PersonEmail != ''){    
            String htmlbody = emailTemplate.HtmlValue;
            String plainbody = emailTemplate.Body;
            String subject = emailTemplate.Subject;
            toMailList.add(Opportunity.Account.PersonEmail);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Subject = Subject.replace('{EOI_CAForm}', Opportunity.EOI_CA__c);
            Subject = Subject.replace('{ProjectName}', Opportunity.Project__r.Name);
            htmlBody = htmlBody.replace('{EOI_CA}', Opportunity.EOI_CA__c);
            htmlBody = htmlBody.replace('{Project}', Opportunity.Project__r.Name);
            htmlBody = htmlBody.replace('{Customer}', Name);
            plainBody = plainBody.replace('{EOI_CA}', Opportunity.EOI_CA__c);
            plainBody = plainBody.replace('{Project}', Opportunity.Project__r.Name);
            plainBody = plainBody.replace('{Customer}', Name);
            plainBody = plainBody.replace('{EOI_CA_Number}', Opportunity.EOI_CA_Number__c);
            htmlBody = htmlBody.replace('{EOI_CA_Number}', Opportunity.EOI_CA_Number__c);
           SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,Subject,htmlBody,plainBody,new List<string>{Opportunity.Account.PersonEmail},null,true,opportunity.id,body,Opportunity.EOI_CA__c+'.pdf',owea.id);

            mail.setToAddresses(new List<string>{Opportunity.Account.PersonEmail});
            mail.setPlainTextBody(plainbody);
            mail.setHtmlBody(htmlbody);
            mail.setSubject(subject);
            mail.setOrgWideEmailAddressId(OWEA.id);
            mail.setSaveAsActivity(false);
            mail.setFileAttachments(attachments);
            emailMessages.add(mail);
            
            EmailMessage objEmailMessage = new EmailMessage();
            objEmailMessage.status = '3'; // email was sent
            objEmailMessage.RelatedToId = opportunity.id;
            objEmailMessage.fromName = 'Dynamix'; // from name
            objEmailMessage.ToAddress = Opportunity.Account.PersonEmail;
            objEmailMessage.FromAddress = OWEA.Address;
            objEmailMessage.Subject = 'Email sent to Customer for successfully completed '+Opportunity.EOI_CA__c;
            objEmailMessage.HtmlBody = htmlBody;
            insertEmailMessageList.add(objEmailMessage);
            insert insertEmailMessageList;
            Attachment attachmentEmailMessage = new Attachment( ParentId = insertEmailMessageList[0].Id,                         
                                                               Body = body,                         
                                                               ContentType = 'application/pdf',                         
                                                               Name = Opportunity.EOI_CA__c+'.pdf');
            insert attachmentEmailMessage;
        }
        if(!emailMessages.isempty())
        {
            try{
               List<Messaging.SendEmailResult> sendResults = Messaging.sendEmail(emailMessages);
            }
            Catch(Exception Ex)
            {
                system.debug('Error '+Ex.getMessage());
            }
        }
        
    }
    
}