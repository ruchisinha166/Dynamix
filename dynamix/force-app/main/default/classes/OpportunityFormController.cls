Public without Sharing class OpportunityFormController {
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
    Public String primaryAccountFirstName {get;set;}
    Public String primaryAccountMiddleName {get;set;}
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
    Public Boolean makeItdefaultReadOnly {get;set;}
    
    Public string ProjectHeader{get;set;}
    Public string ProjectFooter{get;set;}
    public boolean showFooter {get;set;}
    public boolean showHeader {get;set;}
    Public string ProjectName{get;set;}
    Public string residenceAddress{get;set;}
    
    public String secondarySalesManagerName {get;set;}
    public String secondarySalesManagerId {get;set;}
    public String secondarySalesManager {get;set;}
    public String setReadOnlyChannelPartner {get;set;}
    public List<String> multiSelectBudgetValues { get; set; }
    public List<SelectOption> budgetPicklistOptions { get; set; }
    public List<SelectOption> projectConfigurationPicklistOptions { get; set; }
    public List<SelectOption> selectedCarpetAreaAddOption { get; set; }
    Public String selectedBudgetPicklistValue {get;set;}
    
    Public Account accountList {get;set;}
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
    
    public String stateFromPage { get; set; }
    public String countryFromPage { get; set; }
    public String cityFromPage { get; set; }
    public String pinCodeFromPage { get; set; }
    public String streetFromPage { get; set; }
    public String localityFromPage { get; set; }
    // public List<SelectOption> selectedLocalityAddOption { get; set; }
    
    
    Public OpportunityFormController(ApexPages.StandardController stdController) {
        recordId = ApexPages.currentPage().getParameters().get('Id');
        String accounRecordId = ApexPages.currentPage().getParameters().get('AccounId');
        List<Project__c> projectList = [SELECT id, name,OTP_Disable_Till__c, Project_Header__c,Budgets__c, 
                                        Project_Footer__c, Configuration__c,Project_Carpet_Area__c  
                                        from Project__c WHERE id =: recordId];
        System.debug('recordid----->'+recordId);
        System.debug('projectlist----->'+projectList);
        items = new List<List<ItemWrapper>>();
        selectedProjectConfigurationAdd = '';
        selectedWalkInSourceAdd = '';
        selectedPrimaryAccAgeAdd = '';
        showReferralByCustomer = false;
        selectedItems = new List<String>();
        List<String> values = New List<String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Walk_In_Source__c.getDescribe();
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
        this.standardController = stdController;
        disableOTP = false;
        System.debug('Controller initialized');
        List<CIF_Form__c> cifForm = CIF_Form__c.getall().values();
        if (projectList != null && !projectList.isEmpty()) {
            if(projectList[0].OTP_Disable_Till__c != null)
            {
                if(projectList[0].OTP_Disable_Till__c >= system.now())
                    
                {
                    disableOTP = true;
                }
            }
        }else {
            System.debug('The projectList is empty.');
        }
        
        isAgreeWithTermsConditions = false;
        CountOtp = 0;
        showFooter = true;
        submittedBy = 'customer';
        otpBtnValue = 'Get OTP';
        showHeader=true;
        makeItdefaultReadOnly  = true;
        newchannelPartner = false;
        selectedPrimaryAccCountryCodeAdd = '+91';
        showChannelPartner = false;
        UnregisteredCP = false;
        makeItReadOnly = false;
        secondarySalesManager = 'No';
        setReadOnlyChannelPartner = 'No';
        selectedSecondaryAccCountryCodeAdd = '+91';
        countryCodeValue  = '+91';
        System.debug('recordId>>'+recordId);
        system.debug(accounRecordId);
        Map<String,String> enquirySourceMap = New Map<String,String>();
        List<Enquiry_Source__mdt> enquirySourceMetaData = [SELECT Id, Label, Enquiry_Source__c, Walk_in_Source__c 
                                                           FROM Enquiry_Source__mdt];
        if(!enquirySourceMetaData.isEmpty())
        {
            for(Enquiry_Source__mdt enquirySource :enquirySourceMetaData)
            {
                enquirySourceMap.put(enquirySource.Enquiry_Source__c,enquirySource.Walk_in_Source__c);
                // enquirySourceMap.put(enquirySource.Label,enquirySource.Walk_in_Source__c);																																																																																																						);
            }
        }
        
        
        
        List<Account> accountExistList = [SELECT id, Name,PersonMobilePhone,PersonEmail,FirstName,LastName,MiddleName,Salutation,
                                          Locality__c,Apartment_Flat__c,Office_Pin_Code__c,PersonOtherPhone,Phone,	
                                          Office_Locality__c, Industry__c, Company_Name__pc,
                                          Nationality__c, Country_Code__c, Martial_Status__pc, Designation_or_Position__pc,
                                          Age__c, PersonMailingStreet, PersonMailingState,PersonMailingPostalCode,
                                          PersonMailingCountry,PersonMailingCity,Employment_Type__c
                                          From Account WHERE id	=: accounRecordId Limit 1];
        
        multiSelectBudgetValues = new List<String>();
        budgetPicklistOptions = new List<SelectOption>();
        if (!projectList.isEmpty()&& projectList[0].Budgets__c != null) {
            multiSelectBudgetValues = projectList[0].Budgets__c.split(';'); // Assuming values are separated by semicolon
        }
        // Create picklist options from multi-select values
        for (String value : multiSelectBudgetValues) {
            budgetPicklistOptions.add(new SelectOption(value, value));
        }
        List<String> multiSelectprojectConfigurationValues = new List<String>();
        projectConfigurationPicklistOptions = new List<SelectOption>();
        if (!projectList.isEmpty()&& projectList[0].Configuration__c != null) {
            multiSelectprojectConfigurationValues = projectList[0].Configuration__c.split(';'); // Assuming values are separated by semicolon
        }
        // Create picklist options from multi-select values
        for (String value : multiSelectprojectConfigurationValues) {
            projectConfigurationPicklistOptions.add(new SelectOption(value, value));
        }
        // Carpet Area
        List<String> multiSelectprojectCarpetValues = new List<String>();
        selectedCarpetAreaAddOption = new List<SelectOption>();
        if (!projectList.isEmpty()&& projectList[0].Project_Carpet_Area__c != null) {
            multiSelectprojectCarpetValues = projectList[0].Project_Carpet_Area__c.split(';'); // Assuming values are separated by semicolon
        }
        // Create picklist options from multi-select values
        for (String value : multiSelectprojectCarpetValues) {
            selectedCarpetAreaAddOption.add(new SelectOption(value, value));
        }
        
        system.debug('accountExistList----'+accountExistList);
        system.debug('recordId----'+recordId);
        if(!accountExistList.isEmpty())
        {
            List<Opportunity> opportunityList = [SELECT id, Name,AccountId, Project__c, Walk_in_Source__c,Budget1__c,
                                                 Construction_Status__c, Source_of_Funding__c, Nature_of_Use__c,Last_Site_Visit_Date_CIF__c,
                                                 Interested_Configuration__c,Date_of_Site_Visit__c,Channel_Partner__c,
                                                 Channel_Partner__r.Name, Sales_Manager__c,Sales_Manager__r.Name,
                                                 Sourcing_Manager__c,Sourcing_Manager__r.Name, Secondary_Sales_Manager__c,
                                                 Secondary_Sales_Manager__r.Name,Referral_By_Customer__r.Name, Project_Carpet_Area__c, 
                                                 Referral_By_Customer__c, Referral_Type__c, Referral_Name__c, Referral_Mobile_Number__c		
                                                 FROM Opportunity 
                                                 WHERE Project__c =: recordId AND  AccountId =: accountExistList[0].id 
                                                 AND StageName != 'Closed Won' AND StageName != 'Closed Lost'
                                                 AND StageName != 'Booking Cancelled – Refund Pending' AND StageName != 'Cancellation Initiated' Limit 1];
            List <Enquiry__c> enquiryList = [SELECT id, Contact_Person__c, Site_Visit_Done_Date__c, Stage__c,
                                             Location__c, Construction_Status__c, Configuration__c,Budget__c,
                                             Enquiry_Source__c	
                                             FROM Enquiry__c 
                                             WHERE Contact_Person__c =:  accountExistList[0].id AND
                                             Project__c =: recordId 
                                             AND Stage__c != 'Lost' AND Stage__c != 'Site Visit Done' 
                                             Limit 1];
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
            
            System.debug('accountExistList[0].PersonMailingCity'+accountExistList[0].PersonMailingCity);
            primaryAccMailingAddCity=accountExistList[0].PersonMailingCity;
            System.debug('z'+primaryAccMailingAddCity);
            
            apartmentFlat=accountExistList[0].Apartment_Flat__c;
            locality=accountExistList[0].Locality__c	;
            officeLocation = accountExistList[0].Office_Locality__c;
            Industry = accountExistList[0].Industry__c;
            selectedEmploymentType = accountExistList[0].Employment_Type__c;
            Industry = accountExistList[0].Industry__c;
            officePinCode = accountExistList[0].Office_Pin_Code__c;
            officeLocation = accountExistList[0].Office_Locality__c;
            designation = accountExistList[0].Designation_or_Position__pc;
            companyName = accountExistList[0].Company_Name__pc;
            
            system.debug('selectedBudgetPicklistValue----'+selectedBudgetPicklistValue);
            system.debug('opportunityList'+opportunityList);
            system.debug('enquiryList'+enquiryList);
            if(!opportunityList.isEmpty())
            {
                if(opportunityList[0].Sales_Manager__c != null)
                {
                    selectedValue =  opportunityList[0].Walk_in_Source__c;
                    secondarySalesManager = 'Yes';
                }
                
                
                if(opportunityList[0].Date_of_Site_Visit__c != null && cifForm[0].Set_Opportunity_Feild_as_Read_Only__c	!= null)
                    
                { Integer Days = Integer.valueof(cifForm[0].Set_Opportunity_Feild_as_Read_Only__c);
                 system.debug('Yes'+opportunityList[0].Date_of_Site_Visit__c.addDays(Days));
                 if(opportunityList[0].Date_of_Site_Visit__c.addDays(Days) > system.today() )
                 {
                     system.debug('Yes');
                     setReadOnlyChannelPartner = 'Yes';
                     makeItReadOnly = true;
                 }}
                for (List<ItemWrapper> row : items) {
                    for (ItemWrapper item : row) {
                        item.selectedOption = opportunityList[0].Walk_in_Source__c;
                        
                    }
                }
                selectedValue =  opportunityList[0].Walk_in_Source__c;
                system.debug('selectedValue'+selectedValue);
                if( opportunityList[0].Walk_in_Source__c == 'Channel Partner')
                {
                    
                    showChannelPartner = true;
                    system.debug('showChannelPartner'+showChannelPartner);
                    channelStringPartnerRecordID = opportunityList[0].Channel_Partner__c;
                    channelPartnerName = opportunityList[0].Channel_Partner__r.Name;
                    sourcingManagerName = opportunityList[0].Sourcing_Manager__r.Name;
                    sourcingManagerId = opportunityList[0].Sourcing_Manager__c;
                }
                if( opportunityList[0].Walk_in_Source__c == 'Referred by Existing Customer')
                {
                    
                    showReferralByCustomer = true;
                    system.debug('showChannelPartner'+showChannelPartner);
                    referralId = opportunityList[0].Referral_By_Customer__c;
                    referralName = opportunityList[0].Referral_By_Customer__r.Name;
                    referralByCustomerId = opportunityList[0].Referral_By_Customer__c;
                }
                if( opportunityList[0].Walk_in_Source__c == 'Referred by Others')
                {
                    
                    showReferralByOther = true;
                    system.debug('showChannelPartner'+showChannelPartner);
                    referralType = opportunityList[0].Referral_Type__c;
                    referralByMobileNumber = opportunityList[0].Referral_Mobile_Number__c;
                    referralFirstName = opportunityList[0].Referral_Name__c.Substring(0,opportunityList[0].Referral_Name__c.indexOf(' '));
                    referralLastName =  opportunityList[0].Referral_Name__c.Substring(opportunityList[0].Referral_Name__c.indexOf(' '),opportunityList[0].Referral_Name__c.length());
                }
                projectCarpetArea = opportunityList[0].Project_Carpet_Area__c;
                salesManagerId = opportunityList[0].Sales_Manager__c;
                salesManagerName = opportunityList[0].Sales_Manager__r.Name;
                secondarySalesManagerId = opportunityList[0].Secondary_Sales_Manager__c;
                secondarySalesManagerName = opportunityList[0].Secondary_Sales_Manager__r.Name;
                selectedWalkInSourceAdd = opportunityList[0].Walk_in_Source__c;
                selectedconstructionStatusAdd  = opportunityList[0].Construction_Status__c;
                selectedSourceOfFundingStatus = opportunityList[0].Source_of_Funding__c ;
                selectedNatureInUseAdd = opportunityList[0].Nature_of_Use__c;
                selectedProjectConfigurationAdd = opportunityList[0].Interested_Configuration__c;
                selectedBudgetPicklistValue = opportunityList[0].Budget1__c;
                
            }
            else if(!enquiryList.isEmpty())
            {
                System.debug('enquiryList[0].Enquiry_Source__c'+enquiryList[0].Enquiry_Source__c);
                if(enquirySourceMap.containsKey(enquiryList[0].Enquiry_Source__c))
                { System.debug('Yes'+enquirySourceMap.get(enquiryList[0].Enquiry_Source__c));
                 selectedValue = enquirySourceMap.get(enquiryList[0].Enquiry_Source__c)	;
                }
                system.debug('selectedWalkInSourceAdd'+selectedWalkInSourceAdd);
                system.debug('enquiryList'+enquiryList);
                selectedconstructionStatusAdd  = enquiryList[0].Construction_Status__c;
                selectedProjectConfigurationAdd = enquiryList[0].Configuration__c;
                selectedBudgetPicklistValue = enquiryList[0].Budget__c;
            }
        }
        
        // system.debug('projectList[0].Project_Header__c'+projectList[0].Project_Header__c);
        if(!projectList.isempty()){
            ProjectHeader = projectList[0].Project_Header__c;
            ProjectFooter = projectList[0].Project_Footer__c;
            ProjectName = projectList[0].Name;
        }
        
    }
    public PageReference submitFirstForm(){
        if(primaryAccountLastName==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Last name.'));
        }
        if(primaryAccountFirstName==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in First name.'));
        }
        System.debug('Length '+primaryAccountMobileNo.length() );
        if(primaryAccountMobileNo.length() != 10 && selectedPrimaryAccCountryCodeAdd == '+91')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter valid Phone Number.'));
            
        }
        if(primaryAccountMobileNo==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Phone Number.'));
        }
        if(primaryAccountEmail==''){
            // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Email.'));
        }
        if(primaryAccountSalutation=='' ||  primaryAccountSalutation == 'None' || primaryAccountSalutation == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Salutation.'));
        }
        if(selectedPrimaryAccCountryCodeAdd  =='' ||  selectedPrimaryAccCountryCodeAdd == 'None' || selectedPrimaryAccCountryCodeAdd == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Country Code.'));
        }
        if(primaryAccountFirstName.isAlphaSpace() == false)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: First Name Can only contains alphabets.'));
            
        }
        if(String.isNotBlank(primaryAccountMiddleName))
        {
            if(primaryAccountMiddleName.isAlphaSpace() == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Middle Name Can only contains alphabets.'));
            }
        }
        if(primaryAccountLastName.isAlphaSpace() == false)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Last Name Can only contains alphabets.'));
            
        }
        
        system.debug('primaryAccountEmail'+primaryAccountEmail);
        system.debug('primaryAccountFirstName'+primaryAccountFirstName);
        system.debug('primaryAccountLastName'+primaryAccountLastName);
        system.debug('primaryAccountMobileNo'+primaryAccountMobileNo);
        system.debug('primaryAccountSalutation'+primaryAccountSalutation);
        
        if(primaryAccountFirstName  != ''   && primaryAccountLastName  != '' && 
           //primaryAccountEmail  != '' && 
           primaryAccountMobileNo != '' &&
           primaryAccountSalutation != '' && primaryAccountSalutation != 'None' && primaryAccountSalutation != null
           && primaryAccountLastName.isAlphaSpace() == true && primaryAccountFirstName.isAlphaSpace() == true &&
           selectedPrimaryAccCountryCodeAdd!= '' && selectedPrimaryAccCountryCodeAdd !=  null && selectedPrimaryAccCountryCodeAdd  != 'None' 
           && ((primaryAccountMobileNo.length() == 10 && selectedPrimaryAccCountryCodeAdd == '+91') || primaryAccountMobileNo.length() != 0 && selectedPrimaryAccCountryCodeAdd != '+91'))
        {
            String SearchKeyword = '';
            if(primaryAccountMobileNo.length() >= 10)
            {
                SearchKeyword  = '%'+primaryAccountMobileNo.right(10);
            }
            else
            {
                SearchKeyword  = primaryAccountMobileNo;
            }
           
            List<Account> accountExistList = [SELECT id, Name From Account WHERE PersonMobilePhone	like :SearchKeyword Limit 1];
            Account acc =New Account();
            if(!accountExistList.isEmpty())
            {
                acc.id = accountExistList[0].id;
            }
            acc.PersonMobilePhone = primaryAccountMobileNo;
            acc.PersonEmail = primaryAccountEmail;
            acc.FirstName =  primaryAccountFirstName.subString(0 ,1).ToUpperCase() +primaryAccountFirstName.subString(1);
            if(String.isNotBlank(primaryAccountMiddleName) && primaryAccountMiddleName.isAlphaSpace() == true){
                acc.MiddleName = primaryAccountMiddleName.subString(0 ,1).ToUpperCase() +primaryAccountMiddleName.subString(1);
            }
            acc.LastName = primaryAccountLastName.subString(0 ,1).ToUpperCase() +primaryAccountLastName.subString(1);
            acc.Salutation = primaryAccountSalutation;
            acc.Country_Code__c = selectedPrimaryAccCountryCodeAdd;  
            
            try{
                upsert acc; 
            }
            catch(DmlException ex){
                ApexPages.addMessages(ex);
                return null;
            }
            
            system.debug('acc'+acc.id);
            if(disableOTP == true)
            {
                pageReference pg = new pageReference('/apex/CIF2');
                pg.getParameters().put('Id', ApexPages.currentPage().getParameters().get('Id'));
                pg.getParameters().put('AccounId',acc.id);
                pg.getParameters().put('Verified','false');
                pg.getParameters().put('code','0');
                return pg.setRedirect(true);
            }
            else
            {
                pageReference pg = new pageReference('/apex/OTPPage');
                pg.getParameters().put('Id', ApexPages.currentPage().getParameters().get('Id'));
                pg.getParameters().put('AccounId',acc.id);
                return pg.setRedirect(true);
            }
            
        }
        else
        {
            return null;
        }
    }
    /*public void passState() {
        // Do something with the received state value
        String stateFromPage = System.currentPageReference().getParameters().get('stateFromPage');
      //  primaryAccMailingAddState = stateFromPage;
        System.debug('Received state value: ' + stateFromPage);
    }
    
      public void passCountry() {
        // Do something with the received state value
          String CountryFromPage = System.currentPageReference().getParameters().get('CountryFromPage');
          System.debug('Received Country value: ' + CountryFromPage);
          //primaryAccMailingAddCountry = CountryFromPage;
          System.debug('Received Country value: ' + CountryFromPage);
    }
    public void passCity() {
        // Do something with the received state value
        String CityFromPage = System.currentPageReference().getParameters().get('CityFromPage');
      //  primaryAccMailingAddCity = CityFromPage;
        System.debug('Received City value: ' + CityFromPage);
    }*/
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
    public PageReference submitBookingForm(){
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
        System.debug('Received state value: ' + stateFromPage);
        System.debug('selectedValue'+selectedValue);
        System.debug('primaryAccMailingAddCountry'+primaryAccMailingAddCountry);
        System.debug('primaryAccMailingAddState'+primaryAccMailingAddState);
        System.debug('primaryAccMailingAddCity'+primaryAccMailingAddCity);
        System.debug('primaryAccMailingAddPostalCode'+primaryAccMailingAddPostalCode);
        selectedWalkInSourceAdd = selectedValue;
        System.debug('channelStringPartnerRecordID'+channelStringPartnerRecordID);
        System.debug('channelStringPartnerRecordID'+channelStringPartnerRecordID);
        System.debug('selectedWalkInSourceAdd'+selectedWalkInSourceAdd);
        System.debug('selectedPrimaryAccAgeAdd'+selectedPrimaryAccAgeAdd);
        System.debug('selectedWalkInSourceAdd'+selectedWalkInSourceAdd);
        System.debug('selectedPrimaryAccAgeAdd'+selectedPrimaryAccAgeAdd);
        System.debug('selectedProjectConfigurationAdd'+selectedProjectConfigurationAdd);
        System.debug('referralByCustomerId'+referralByCustomerId);
        if(primaryAccountLastName=='' ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Last name.'));
        }
        if(primaryAccountFirstName=='' ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in First name.'));
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
        /*if(locality ==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Locality.'));
        }*/
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
        if(selectedPrimaryAccAgeAdd == '' || selectedPrimaryAccAgeAdd == null ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Age.'));
        }
        if(selectedBudgetPicklistValue =='' || selectedBudgetPicklistValue == null ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Budget.'));
        }
        if(selectedEmploymentType =='' ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Employment Type.'));
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
        if(primaryAccountMobileNo.length() != 10 && selectedPrimaryAccCountryCodeAdd == '+91')
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
        }
      /*  if(selectedconstructionStatusAdd =='' || selectedconstructionStatusAdd == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Construction Status.'));
        }*/
        if(selectedProjectConfigurationAdd =='' || selectedProjectConfigurationAdd == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Configuration.'));
        }
        /*if(selectedNatureInUseAdd =='' || selectedNatureInUseAdd == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Nature of Use.'));
        }*/
        if(selectedWalkInSourceAdd == 'Referred by Existing Customer' && (referralByCustomerId == null || referralByCustomerId == '')) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Referral By Customer.'));
        }
        if(selectedWalkInSourceAdd == 'Referred by Others' && (referralType == null || referralType == '')) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Referral Type.'));
        }
        if(selectedWalkInSourceAdd == 'Referred by Others' && (referralFirstName == null || referralFirstName == '')) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Referral First Name.'));
        }
        if(selectedWalkInSourceAdd == 'Referred by Others' && (referralFirstName != null && referralFirstName != '' && referralFirstName.isAlphaSpace() != true )) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error:Referral First Name should only contains Alphabets and Space.'));
        }
        if(selectedWalkInSourceAdd == 'Referred by Others' && (referralLastName != null && referralLastName != '' && referralLastName.isAlphaSpace() != true )) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error:Referral Last Name should only contains Alphabets and Space.'));
        }
        if(selectedWalkInSourceAdd == 'Referred by Others' && (referralLastName == null || referralLastName == '')) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Referral Last Name.'));
        }
        if(selectedWalkInSourceAdd == 'Referred by Others' && (countryCodeValue == null || countryCodeValue == '')) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Referral Country Code.'));
        }
        if(selectedWalkInSourceAdd == 'Referred by Others' && referralByMobileNumber == '') {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Referral Mobile Number.'));
        }
        if(selectedWalkInSourceAdd == 'Referred by Others' && referralByMobileNumber != '' && referralByMobileNumber.length() != 10) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter valid Mobile Number in Referral Mobile Number.'));
        }
        if(projectCarpetArea =='' || projectCarpetArea == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select value in Carpet Area.'));
        }
        
        if(selectedPrimaryAccCountryCodeAdd  =='' ||  selectedPrimaryAccCountryCodeAdd == 'None' || selectedPrimaryAccCountryCodeAdd == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Country Code.'));
        }
        if(primaryAccountFirstName.isAlphaSpace() == false)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: First Name Can only contains alphabets.'));
            
        }
        if(String.isNotBlank(primaryAccountMiddleName))
        {
            if(primaryAccountMiddleName.isAlphaSpace() == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Middle Name Can only contains alphabets.'));
            }
        }
        if(primaryAccountLastName.isAlphaSpace() == false)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Last Name Can only contains alphabets.'));
            
        }
        
        String projectId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('projectid-------------> '+ projectId);
        String otpCode = ApexPages.currentPage().getParameters().get('code');
        String otpverified = ApexPages.currentPage().getParameters().get('Verified');
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();  
        String SearchPhoneNumberKeyword = '';
        if(primaryAccountMobileNo.length() >= 10)
        {
            SearchPhoneNumberKeyword  = '%'+primaryAccountMobileNo.right(10);
        }
        else
        {
            SearchPhoneNumberKeyword  = primaryAccountMobileNo;
        }
        List<Account> accountExistList = [SELECT id, Name,Phone From Account WHERE PersonMobilePhone	like : SearchPhoneNumberKeyword Limit 1];
        List<Opportunity> opportunityList = New List<Opportunity>();
        List <Enquiry__c> enquiryList = New List <Enquiry__c>();
        if(!accountExistList.isEmpty())
        {
            opportunityList = [SELECT id, Name,AccountId, Project__c, No_of_Total_Visits__c, 
                               Linked_Enquiry__c, OTP_Submitted__c, OTP_Submission_Date__c 
                               FROM Opportunity 
                               WHERE Project__c =: projectId AND  AccountId =: accountExistList[0].id 
                               AND StageName != 'Closed Won' AND StageName != 'Closed Lost'
                               AND StageName != 'Booking Cancelled – Refund Pending' AND StageName != 'Cancellation Initiated' Limit 1];
            enquiryList = [SELECT id, Contact_Person__c, Site_Visit_Done_Date__c, Stage__c,
                           Location__c, Construction_Status__c, Configuration__c, Enquiry_Source__c,Enquiry_Sub_Source__c
                           FROM Enquiry__c 
                           WHERE Contact_Person__c =:  accountExistList[0].id AND
                           Project__c =: projectId AND Stage__c != 'Lost' AND Stage__c != 'Site Visit Done' Limit 1];
            /*  List <Enquiry__c> enquiryList = [SELECT id, Contact_Person__c, Site_Visit_Done_Date__c, Stage__c
FROM Enquiry__c 
WHERE Contact_Person__c =:  accountExistList[0].id AND
Project__c =: projectId AND Stage__c != 'Lost' && Stage__c != 'Site Visit Done' Limit 1];*/
            
        }
        if(primaryAccountFirstName  != ''   && primaryAccountLastName  != '' //&& primaryAccountEmail  != '' 
           && primaryAccountMobileNo != '' && primaryAccountSalutation != '' && primaryAccountSalutation != 'None'
           && selectedPrimaryAccAgeAdd != '' && selectedconstructionStatusAdd  != ''   && 
           selectedProjectConfigurationAdd != '' &&  selectedProjectConfigurationAdd != null && 
           selectedBudgetPicklistValue != '' && selectedconstructionStatusAdd  != '' 
           // primaryAccMailingAddStreet != '' && apartmentFlat != '' &&  locality != ''  && selectedNatureInUseAdd  != ''&&
           
             && primaryAccMailingAddPostalCode != '' &&  primaryAccMailingAddPostalCode != null
             && primaryAccMailingAddState != ''  && primaryAccMailingAddState != null && primaryAccMailingAddCountry != ''   && primaryAccMailingAddCountry !=null 
          && primaryAccMailingAddCity != '' && primaryAccMailingAddCity != null
           && selectedEmploymentType != '' && salesManagerId != '' && salesManagerId != null &&
           //selectedSourceOfFundingStatus != '' && selectedSourceOfFundingStatus != null &&
           projectCarpetArea != '' 
           && projectCarpetArea!=null && ((primaryAccountMobileNo.length() == 10 && selectedPrimaryAccCountryCodeAdd == '+91') || 
                                          (primaryAccountMobileNo.length() != 0 && selectedPrimaryAccCountryCodeAdd != '+91'))&&
           selectedPrimaryAccCountryCodeAdd!= '' && selectedPrimaryAccCountryCodeAdd !=  null && selectedPrimaryAccCountryCodeAdd  != 'None'&&
           primaryAccountLastName.isAlphaSpace() == true && primaryAccountFirstName.isAlphaSpace() == true 
           
          // && selectedconstructionStatusAdd != '' && selectedconstructionStatusAdd != null
           &&(selectedWalkInSourceAdd != '' &&((selectedWalkInSourceAdd != 'Channel Partner' && selectedWalkInSourceAdd != 'Referred by Existing Customer' 
                                                && selectedWalkInSourceAdd != 'Referred by Others') || 
                                               (selectedWalkInSourceAdd == 'Channel Partner' && sourcingManagerId !='' 
                                                && sourcingManagerId !=null  && ((//channelStringPartnerRecordID != null && channelStringPartnerRecordID != '' && 
                                                    UnregisteredCP != true )
                                                                                 ||(channelPartnerNumber != ''&& ((channelPartnerNumber.length()==10 && countryCodeValue=='+91') 
                                                                                                                  || (channelPartnerNumber.length()!=0 && countryCodeValue !='+91')) && countryCodeValue!= '' && countryCodeValue!=null && cpFirmName != '' && CPName !='' && UnregisteredCP == true )))|| 
                                               (selectedWalkInSourceAdd == 'Referred by Existing Customer' && referralByCustomerId != null
                                                &&  referralByCustomerId != '') || selectedWalkInSourceAdd == 'Referred by Others'
                                               && referralFirstName != '' && referralFirstName.isAlphaSpace() == true && referralLastName != '' && referralLastName.isAlphaSpace() == true  &&
                                               referralByMobileNumber != '' && ((referralByMobileNumber.length()==10 && countryCodeValue=='+91') 
                                                                                || (referralByMobileNumber.length()!=0 && countryCodeValue !='+91'))  &&  countryCodeValue!= '' && countryCodeValue!=null
                                               && referralType != '' && referralType != null)  )
          )
            
        {
            Account acc =New Account();
            if(!accountExistList.isEmpty())
            {
                acc.id = accountExistList[0].id;
                  if(ethnicity != null && ethnicity != '')
                    {
                        try{
                            List<Contact> contactList = [Select id, name, AccountId From Contact Where AccountId =: accountExistList[0].id];
                            Contact contact = New Contact();
                            if(!contactList.isEmpty())
                            {
                                contact.id = contactList[0].id;
                            }
                            contact.Ethnicity__c = ethnicity;
                            upsert contact;
                        }
                        catch(Exception ex)
                        {
                            
                        }
                    }
            }
            System.debug('primaryAccMailingAddPostalCode'+primaryAccMailingAddPostalCode);
            acc.PersonMobilePhone = primaryAccountMobileNo;
            acc.PersonEmail = primaryAccountEmail;
            acc.FirstName =  primaryAccountFirstName.subString(0 ,1).ToUpperCase() +primaryAccountFirstName.subString(1);
            if(String.isNotBlank(primaryAccountMiddleName) && primaryAccountMiddleName.isAlphaSpace() == true){
                acc.MiddleName = primaryAccountMiddleName.subString(0 ,1).ToUpperCase() +primaryAccountMiddleName.subString(1);
            }
            acc.LastName = primaryAccountLastName.subString(0 ,1).ToUpperCase() +primaryAccountLastName.subString(1);
            acc.Salutation = primaryAccountSalutation;
            acc.PersonMailingStreet = primaryAccMailingAddStreet;
            acc.PersonMailingState = primaryAccMailingAddState;
            acc.PersonMailingPostalCode = primaryAccMailingAddPostalCode;
            acc.Apartment_Flat__c = apartmentFlat;
            acc.Locality__c	 = locality;
            acc.Phone = SecondaryMobileNo;
            acc.PersonMailingCountry = primaryAccMailingAddCountry;
            acc.PersonMailingCity = primaryAccMailingAddCity;
            acc.Age__c = selectedPrimaryAccAgeAdd;
            acc.Country_Code__c = selectedPrimaryAccCountryCodeAdd;
            acc.Nationality__c = selectedPrimaryAccNationality;
            acc.Company_Name__pc = companyName;
            acc.Designation_or_Position__pc = designation;
            acc.Industry__c = Industry;
            acc.Office_Locality__c = officeLocation;
            acc.Employment_Type__c = selectedEmploymentType;
            acc.Residence_Address__c = residenceAddress;
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
            if(sourcingManagerId != null && sourcingManagerId != ''){
                
                List<Task_Target__c> taskTargetList = [SELECT Id, Name, user__c, Month__c,Type__c,
                                                       Year__c, Number_of_Targets_Achievement__c,
                                                       X1st_Week__c, X2nd_Week__c, X3rd_Week__c,
                                                       X4th_Week__c, X5th_Week__c, Project__c,
                                                       Number_of_Connected_Call__c, No_of_Walk_ins__c, No_of_Follow_Ups__c
                                                       FROM Task_Target__c
                                                       WHERE user__c =: sourcingManagerId 
                                                       AND Type__c = :'Customer Walk In(CP)' AND Year__c = :String.valueof(System.today().year()) 
                                                       AND Month__c =: System.now().format('MMMMM')];
                Map<String, Task_Target__c> updateTaskTarget = New Map<String, Task_Target__c>();
                Map<String, Integer> mapUserForWalkInTask = New Map<String, Integer>();
                Map<String, Task_Target__c> mapOfUserToGetTaskTargetId = New Map<String, Task_Target__c>();
                for(Task_Target__c taskTarget : taskTargetList)
                {
                    String Key = taskTarget.Month__c+'-'+taskTarget.Year__c+'-'+projectId+'-'+sourcingManagerId;
                    mapOfUserToGetTaskTargetId.put(Key,taskTarget);
                    if(taskTarget.Number_of_Targets_Achievement__c == null)
                    {
                        mapUserForWalkInTask.put(Key,0);
                    }
                    else
                    {
                        system.debug('Integer.valueof(taskTarget.Number_of_Targets_Achievement__c)'+Integer.valueof(taskTarget.Number_of_Targets_Achievement__c));
                        mapUserForWalkInTask.put(Key,Integer.valueof(taskTarget.Number_of_Targets_Achievement__c));
                    }
                }
                Integer yr = System.today().year();
                System.debug('Year is' + yr);
                string month = System.now().format('MMMMM');
                System.debug('Month is' + month);
                string Key = month+'-'+String.valueOf(yr)+'-'+projectId+'-'+sourcingManagerId;
                if(mapOfUserToGetTaskTargetId.containskey(Key)){
                    Task_Target__c taskTarget = New Task_Target__c();
                    taskTarget.id = mapOfUserToGetTaskTargetId.get(Key).id;
                    
                    system.debug('taskTarget.Number_of_Targets_Achievement__c---- '+taskTarget.Number_of_Targets_Achievement__c );
                    mapUserForWalkInTask.put(Key, mapUserForWalkInTask.get(Key)+1);
                    system.debug(' mapUserForWalkInTask.get(Key)'+ mapUserForWalkInTask.get(Key) );
                    taskTarget.Number_of_Targets_Achievement__c = mapUserForWalkInTask.get(Key);
                    updateTaskTarget.put(taskTarget.id,taskTarget);
                    
                }
                if(!updateTaskTarget.values().IsEmpty())
                {
                    try{
                        update updateTaskTarget.values();
                    }
                    catch(DmlException ex){
                        ApexPages.addMessages(ex);
                        return null;
                    }
                }
            }
            opportunity opportunityRecord = New Opportunity();
            if(!enquiryList.isEmpty())
            {
                
                
                Enquiry__c enquiry = New Enquiry__c();
                enquiry.Site_Visit_Done_Date__c = system.now();
                enquiry.Stage__c = 'Site Visit Done';
                enquiry.id = enquiryList[0].id;
                try{
                    update enquiry;
                }
                catch(DmlException ex){
                    ApexPages.addMessages(ex);
                    return null;
                }
                opportunityRecord.Linked_Enquiry__c = enquiryList[0].id;
                opportunityRecord.Enquiry_Source__c	 =enquiryList[0].Enquiry_Source__c;
                opportunityRecord.Enquiry_Sub_Source__c	 = enquiryList[0].Enquiry_Sub_Source__c;
            }
            if(!opportunityList.isEmpty())
            {
                opportunityRecord.id = opportunityList[0].id;
                opportunityRecord.Revisit_Datetime__c = system.today();
                if(opportunityList[0].No_of_Total_Visits__c == 0 || opportunityList[0].No_of_Total_Visits__c == null)
                {
                    opportunityRecord.No_of_Total_Visits__c =1;
                }
                else
                {
                    opportunityRecord.No_of_Total_Visits__c=opportunityList[0].No_of_Total_Visits__c+1;
                }
                if(opportunityList[0].OTP_Submitted__c == null ||opportunityList[0].OTP_Submitted__c == '')
                {
                    if(otpverified == 'True')
                    {
                        opportunityRecord.OTP_Submitted__c = otpCode;
                        opportunityRecord.OTP_Submission_Date__c = system.today();
                        opportunityRecord.Date_and_Time_of_OTP_Submission__c  = system.now();
                    }
                }
                
            }
            else
            {
                if(otpverified == 'True')
                {
                    opportunityRecord.OTP_Submitted__c = otpCode;
                    opportunityRecord.OTP_Submission_Date__c = system.today();
                    opportunityRecord.Date_and_Time_of_OTP_Submission__c  = system.now();
                }
                
                opportunityRecord.No_of_Total_Visits__c =1;
                opportunityRecord.Date_of_Site_Visit__c = system.today();
            }
            opportunityRecord.Walk_in_Source__c = selectedWalkInSourceAdd;
            system.debug('selectedWalkInSourceAdd'+selectedWalkInSourceAdd);
            opportunityRecord.Old_Source__c = selectedWalkInSourceAdd;
            opportunityRecord.AccountId = acc.id;
            opportunityRecord.StageName = 'Site Visit Done';
            opportunityRecord.Phone__c = primaryAccountMobileNo;
            opportunityRecord.project__c = projectId;
            opportunityRecord.Last_Site_Visit_Date_CIF__c = System.today();
            opportunityRecord.Project_Carpet_Area__c = projectCarpetArea;
            opportunityRecord.Email_Id__c = primaryAccountEmail;
            opportunityRecord.Name = primaryAccountFirstName+' '+ primaryAccountLastName;
            opportunityRecord.Construction_Status__c = selectedconstructionStatusAdd;
            system.debug('UnregisteredCP'+UnregisteredCP);
            
            system.debug('makeItReadOnly'+makeItReadOnly);
            system.debug('selectedWalkInSourceAdd'+selectedWalkInSourceAdd);
            if(selectedWalkInSourceAdd == 'Channel Partner' && makeItReadOnly == false && UnregisteredCP == false)
            {
                system.debug('UnregisteredCP'+UnregisteredCP);
                /*Harshita//Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName('Channel Partner').get('Account').getRecordTypeId();*/
                if(channelStringPartnerRecordID != null &&channelStringPartnerRecordID !='' )
                {System.debug('channelPartnerRecordID'+channelStringPartnerRecordID);
                 system.debug('Yes');
                 opportunityRecord.Channel_Partner__c = channelStringPartnerRecordID;
                }
                if(sourcingManagerId != '')
                {
                    opportunityRecord.Sourcing_Manager__c = sourcingManagerId;
                }
                
                
            }
            else if(selectedWalkInSourceAdd == 'Referred by Others')
            {
                opportunityRecord.Referral_Mobile_Number__c	 = countryCodeValue + referralByMobileNumber;
                opportunityRecord.Referral_Name__c = referralFirstName+' ' + referralLastName;
                opportunityRecord.Referral_Type__c = referralType;
            }
            else if(selectedWalkInSourceAdd == 'Channel Partner' && makeItReadOnly == false && UnregisteredCP == true)
            {
                /*Harshita//Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName('Channel Partner').get('Account').getRecordTypeId();*/
                
                Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
                List<Account> channelPartnerList = [SELECT id, name from Account where Phone =:channelPartnerNumber AND Phone != null];// AND RecordTypeId =: recordTypeId ];
                if(channelPartnerList.isEmpty())
                {
                    system.debug('CPName'+CPName);
                    system.debug('cpFirmName'+cpFirmName);
                    Account account =New Account();
                    account.CP_Name__c = CPName;
                    account.Name = cpFirmName;
                    account.Phone = channelPartnerNumber;
                    account.CP_Firm_Name__c = cpFirmName;
                    account.Country_Code__c = countryCodeValue;
                    /*Harshita*/
                    if(reraNumber != '')
                    {
                        account.RERA_Number__c=reraNumber;	
                    }
                    account.OwnerId = sourcingManagerId;
                    account.AccountSource = 'CIF';
                    account.CP_Empanelment_Stages__c = 'Unregistered';
                    account.RecordTypeId	 = recordTypeId;
                    //  account.Phone = channelPartnerNumber;
                    try{
                        insert account;
                    }
                    catch(DmlException ex){
                        ApexPages.addMessages(ex);
                        return null;
                    }
                    
                    
                    
                    Channel_Partner_Project__c ChannelPartner = New Channel_Partner_Project__c();
                    ChannelPartner.Channel_Partner__c =  account.id;
                    ChannelPartner.Project__c = projectId;
                    try{
                        insert ChannelPartner;
                    }
                    catch(DmlException ex){
                        ApexPages.addMessages(ex);
                        return null;
                    }
                    
                    opportunityRecord.Channel_Partner__c = account.id;
                }
            }
            opportunityRecord.Source_of_Funding__c = selectedSourceOfFundingStatus;
            opportunityRecord.Nature_of_Use__c = selectedNatureInUseAdd;
            opportunityRecord.Interested_Configuration__c = selectedProjectConfigurationAdd;
            opportunityRecord.Budget1__c  = selectedBudgetPicklistValue;
            opportunityRecord.CloseDate = system.today().addDays(30);
            
            opportunityRecord.Last_Site_Visit_Date__c = system.now();
            opportunityRecord.Sales_Manager__c = salesManagerId;
            opportunityRecord.ownerID = salesManagerId;
            if(secondarySalesManagerId != null && secondarySalesManagerId != '')
            {
                opportunityRecord.Secondary_Sales_Manager__c = secondarySalesManagerId;
            }
            if(referralByCustomerId != null && referralByCustomerId != '')
            {
                opportunityRecord.Referral_By_Customer__c = referralByCustomerId;
            }
            
            //}
            System.debug('projectId----------'+projectId);
            try{
                upsert opportunityRecord;
            }
            catch(DmlException ex){
                ApexPages.addMessages(ex);
                return null;
            } 
            Task task = New Task();
            task.WhatId = opportunityRecord.id;
            task.Subject = 'Site Visit Done';
            task.Project__c = projectId;
            task.OwnerId = salesManagerId;
            task.ReminderDateTime = system.now();
            task.ActivityDate= system.today();
            try{
                insert task;
            }
            catch(DmlException ex){
                ApexPages.addMessages(ex);
                return null;
            }
            
            System.debug('primaryAccountMobileNo'+primaryAccountMobileNo);
            System.debug('primaryAccountMobileNo'+primaryAccountMobileNo);
            System.debug('selectedNatureInUseAdd'+selectedNatureInUseAdd);
            System.debug('accountList'+accountList);
            user userList = [SELECT Id, Name, Email, Fax, Phone, MobilePhone FROM User WHERE id =: salesManagerId];
            CustomNotificationType notificationType =  [SELECT Id, DeveloperName 
                                                        FROM CustomNotificationType 
                                                        WHERE DeveloperName='New_Opportunity'];
            
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            
            List<Project__c> projectList = [SELECT id, name, Project_Header__c,Budgets__c, Project_Footer__c, Configuration__c 
                                            from Project__c WHERE id =: projectId];
            //Send Notification
            if(!opportunityList.isEmpty()){
                EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'Customer revisit on submission of CIF' LIMIT 1];
                SMS_Template_Id__mdt smsTemplateId = [SELECT id, Salesforce_Template_Id__c, External_Template_Id__c
                                                      FROM SMS_Template_Id__mdt 
                                                     WHERE Salesforce_Template_Id__c=: smsEmailTemp.id];
                system.debug('smsEmailTemp'+smsEmailTemp);
                if(smsEmailTemp!=null && userList.MobilePhone != null){
                    String templateBody=smsEmailTemp.HtmlValue;
                    templateBody=templateBody.stripHtmlTags();
                    String mobileNumber = userList.MobilePhone;
                    templateBody = templateBody.replace('{{accountName}}',opportunityRecord.Name);
                    templateBody = templateBody.replace('{{projectName}}', projectList[0].name);
                    templateBody = templateBody.replace('{{opportunityLink}}', projectList[0].name);
                    SendSMSUtility.sendSMSMethod(templateBody,mobileNumber,'DYNAMX',smsTemplateId.External_Template_Id__c);
                    EmailMessage objEmailMessage = new EmailMessage();
                    objEmailMessage.status = '3'; // email was sent
                    objEmailMessage.RelatedToId = opportunityRecord.Id;
                    objEmailMessage.fromName = 'Dynamix'; // from name
                    objEmailMessage.Subject = 'SMS sent to Sales Manager for Customer Revisit done';
                    objEmailMessage.HtmlBody = templateBody;
                    insertEmailMessageList.add(objEmailMessage);
                    
                }
                notification.setTitle('Revisit done by'+opportunityRecord.Name);
                notification.setBody('Mr./Ms. '+opportunityRecord.Name+' has just checked into '+ProjectName+' for a revisit.');
                // Set the notification type and target
                notification.setNotificationTypeId(notificationType.Id);
                notification.setTargetId(opportunityRecord.id);
                Set<string> receipentId = New Set<string>();
                receipentId.add(salesManagerId);
                // Actually send the notification
                try {
                    notification.send(receipentId);
                }
                catch (Exception e) {
                    System.debug('Problem sending notification: ' + e.getMessage());
                }
                // 1-sept-2023
            }   
            else
            {
            }
            if(!insertEmailMessageList.isEmpty())
            {
                insert insertEmailMessageList;
            }
            PageReference pr = new PageReference('/apex/CIFFormSubmittedMsg');
            //  pr.getParameters().put('Id', recordId);
            //  pr.getParameters().put('submittedBy', submittedBy);
            pr.setRedirect(true);               
            return pr;
            // 1-sept-2023
            // return null;
        }
        
        else
        {
            return null;
        }
        
    }
    Public PageReference disableOtp(){
        try{List<CIF_Form__c> updateCIFFormSetting  = New List<CIF_Form__c>();
            List<CIF_Form__c> cifForm = CIF_Form__c.getall().values();
            Integer addHour = integer.valueOf(cifForm[0].Disable_Time__c);
            cifForm[0].Disable_Till__c = system.now().addHours(addHour);
            updateCIFFormSetting.add(cifForm[0]);
            try{
                update updateCIFFormSetting;
            }
            catch(DmlException ex){
                system.debug('ex'+ex);
                ApexPages.addMessages(ex);
                return null;
            }
            String primaryAccountMobileNo = ApexPages.currentPage().getParameters().get('AccounId');
            
            Account accountRecord = [select id,Account_Form_OTP__c, PersonMobilePhone from Account where id = :primaryAccountMobileNo];
            Project__c project = New Project__c();
            project.id = ApexPages.currentPage().getParameters().get('Id');
            project.OTP_Disable_Till__c =system.now().addHours(addHour);
            try{
                update project;
            }
            catch(DmlException ex){
                system.debug('ex'+ex);
                ApexPages.addMessages(ex);
                return null;
            }
            pageReference pg = new pageReference('/apex/CIF2');
            pg.getParameters().put('Id', ApexPages.currentPage().getParameters().get('Id'));
            pg.getParameters().put('AccounId',accountRecord.id);
            return pg.setRedirect(true);
           }
        catch(Exception ex){
            
            system.debug('ex'+ex);
            ApexPages.addMessages(ex);
            return null;
        }   
    }
    
    Public PageReference sendOtpM(){
        system.debug('otpBtnValue'+otpBtnValue);
        String accountId = ApexPages.currentPage().getParameters().get('AccounId');
        //  accountList = [SELECT id, Name, Account_Form_OTP__c ,PersonEmail,PersonMobilePhone From Account WHERE PersonMobilePhone =: accountId Limit 1];
        accountList = [SELECT id, Name, Account_Form_OTP__c ,PersonEmail,PersonMobilePhone From Account WHERE id =: accountId Limit 1];
        if(accountList != null){
            try{
                Account accountRcd=new Account();
                // randomNumber = Integer.valueof((Math.random() * 100000));
                Integer len = 5;
                String str = string.valueof(Math.abs(Crypto.getRandomLong()));
                String randomNumberStr = str.substring(0, len);
                randomNumber=Integer.valueOf(randomNumberStr);
                system.debug('Random Number-' + randomNumber);
                accountRcd.Id=accountList.Id;
                accountRcd.Account_Form_OTP__c=string.valueOf(randomNumber);
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
            String accountId = ApexPages.currentPage().getParameters().get('AccounId');
            List<Account> otpAccountList = [SELECT id, Name, Account_Form_OTP__c ,PersonEmail,PersonMobilePhone From Account WHERE id =: accountId Limit 1];
            string projectId = ApexPages.currentPage().getParameters().get('Id');
            System.debug('recordId>>'+recordId);
            List<Project__c> projectList = [SELECT id, name, Project_Header__c, Budgets__c, 
                                            Project_Footer__c, Configuration__c, Project_Email__c 
                                            from Project__c WHERE id =: projectId];
            system.debug('inside Callout Method '+randomNumber);
            system.debug('projectList'+projectList);
            String msgBody = '';
            String cifMsgBody = '';
            if(!otpAccountList.isEmpty()){
                //get value From Custom Meta data
                List<BookingForm_OTP_Data__mdt> otpContent = BookingForm_OTP_Data__mdt.getAll().values();
                System.debug('otpContent:'+otpContent);
                
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
                   // msgBody = msgBody.replace('{1}', string.valueOf(randomNumber));
                   // msgBody = msgBody.replace('{2}', 'opportunity');
                   // System.debug('update msgBody:'+msgBody);
                    cifMsgBody= otpContent[0].CIF_OTP_Message_Body__c;
                    System.debug('cifMsgBody:'+cifMsgBody);  
                    cifMsgBody = cifMsgBody.replace('{1}',projectList[0].name );
                    cifMsgBody = cifMsgBody.replace('{2}',string.valueOf(randomNumber));
                    System.debug('update msgBody:'+msgBody);
                    //  String BearerToken =System.Label.Bearer_Token_For_OTP;
                    String returnStat;
                    EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'CIF OTP' LIMIT 1];
                    system.debug('smsEmailTemp'+smsEmailTemp);
                    if(smsEmailTemp!=null && otpAccountList[0].PersonMobilePhone != null){
                        String templateBody=smsEmailTemp.HtmlValue;
                        templateBody=templateBody.stripHtmlTags();
                        String mobileNumber=otpAccountList[0].PersonMobilePhone;
                        templateBody = templateBody.replace('{{projectName}}', projectList[0].name);
                        templateBody = templateBody.replace('{{OTP}}', string.valueOf(randomNumber));
                        SendSMSUtility.sendSMSMethod(templateBody,mobileNumber,'DYNAMX',otpContent[0].CIF_Template_Id__c);
                        
                    }
                    
                }          
            }
            OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where Address = : projectList[0].Project_Email__c];
            if(otpAccountList[0].PersonEmail  != '' && otpAccountList[0].PersonEmail != null)
            {
                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                String[] sendingTo = new String[]{otpAccountList[0].PersonEmail}; 
                    semail.setToAddresses(sendingTo); 
                semail.setSubject('OTP'); 
                semail.setPlainTextBody(cifMsgBody);
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
    
    Public PageReference isAgreeWithTermsConditions(){  
        system.debug('isAgreeWithTermsConditions'+isAgreeWithTermsConditions);
        return null;
    }
    
    Public PageReference verifyOtp(){  
        try{
            String primaryAccountMobileNo = ApexPages.currentPage().getParameters().get('AccounId');
            
            Account accountRecord = [select id,Account_Form_OTP__c, PersonMobilePhone from Account where id = :primaryAccountMobileNo];
            if(accountRecord.Account_Form_OTP__c == otpCode){            
                sucessMsg = 'OTP Code Verified'; 
                errorMsg ='';
            }
            else
            {
                errorMsg = 'Your entered OTP is Invalid / Expired';
                 sucessMsg ='';
            }
            if(isAgreeWithTermsConditions != true ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please selecct I agree and authorize Team Dynamix to contact me. This will override the registry with DNC/NDNC.'));
                return null;
            }
            else if(isAgreeWithTermsConditions == true)
            {
                try{
                    if(accountRecord.Account_Form_OTP__c == otpCode){            
                        sucessMsg = 'OTP Code Verified'; 
                        system.debug('OTP Code Verified');
                        otpBtnValue='Resend OTP';
                        errorMsg ='';
                        isverifyed = false;
                        isSubmitButtonDisable = false;
                        pageReference pg = new pageReference('/apex/CIF2');
                        pg.getParameters().put('Id', ApexPages.currentPage().getParameters().get('Id'));
                        pg.getParameters().put('AccounId',accountRecord.id);
                        pg.getParameters().put('Verified','True');
                        pg.getParameters().put('code',otpCode);
                        return pg.setRedirect(true);
                        
                    }
                    else{
                        
                        errorMsg = 'Your entered OTP is Invalid / Expired';
                        otpBtnValue='Resend OTP';
                        isSubmitButtonDisable = true;
                        system.debug('Your entered OTP is Invalid / Expired');
                        //errorMsg = ''
                        return null;
                    }
                }
                catch(Exception ex){
                    ApexPages.addMessages(ex);
                    return null;
                }
            }
            else
            {
                return null;
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
        //return null;
    }
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
 
}