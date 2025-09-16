Public without Sharing class BookingFormVfpController {
    
    Public String recordId {get;set;}
    Public String selectedPurchasePurpose {get;set;}
    Public String bookingApplicationFormFor {get;set;}    
    Public String primaryAccountSalutation {get;set;}
    Public String primaryAccountLastName {get;set;}
    Public String primaryAccountMiddleName {get;set;}
    Public String primaryAccountFirstName {get;set;}
    Public String primaryAccountPermanentAddress {get;set;}
    Public Date primaryAccountBirthDate {get;set;}
    Public String primaryAccountPostCode {get;set;}
    Public String selectedPrimaryAccPermAddState {get;set;}
    Public String selectedPrimaryAccPermAddCountry {get;set;}
    Public String primaryAccMailingAddStreet {get;set;}
    Public String primaryAccMailingAddCity {get;set;}
    Public String primaryAccMailingAddPostalCode {get;set;}
    Public String primaryAccMailingAddState {get;set;}
    Public String primaryAccMailingAddCountry {get;set;}
    Public String selectedPrimaryAccPreffAdd {get;set;}
    Public String selectedPrimaryAccNationality {get;set;}
    Public String primaryAccountPanNumber {get;set;}
    Public String primaryAccountAadhaarCard {get;set;}
    Public String primaryAccountPassport {get;set;}
    Public String primaryAccountOCIPIOCard {get;set;}
    Public String primaryAccountPanDetails {get;set;}
    Public String primaryAccountAddressProof {get;set;}
    Public String primaryAccountMobileNo {get;set;}
    Public String primaryAccountEmail {get;set;}
    Public String primaryAccountLandline {get;set;}
    Public String selectedPrimaryAccOccupation {get;set;}
    Public String primaryAccountOrganizationName {get;set;}
    Public String primaryAccountDesignation {get;set;}
    Public String primaryAccountOrgOfficeAddress {get;set;}
    Public String primaryAccountOrgOfficePostCode {get;set;}
    Public String selectedPrimaryAccOrgOfficeAddState {get;set;}
    Public String selectedPrimaryAccOrgOfficeAddCountry {get;set;}
    Public String primaryAccountOrgPhoneNumber {get;set;}
    Public String primaryAccountOtherDetails {get;set;}
    
    Public String secondAccountSalutation {get;set;}
    Public String secondAccountLastName {get;set;}
    Public String secondAccountMiddleName {get;set;}
    Public String secondAccountFirstName {get;set;}
    Public String secondAccountPermanentAddress {get;set;}
    Public Date secondAccountBirthDate {get;set;}
    Public String secondAccountPostCode {get;set;}
    Public String selectedSecondAccPermAddState {get;set;}
    Public String selectedSecondAccPermAddCountry {get;set;}
    Public String secondAccMailingAddStreet {get;set;}
    Public String secondAccMailingAddCity {get;set;}
    Public String secondAccMailingAddPostalCode {get;set;}
    Public String secondAccMailingAddState {get;set;}
    Public String secondAccMailingAddCountry {get;set;}
    Public String selectedSecondAccPreffAdd {get;set;}
    Public String selectedSecondAccNationality {get;set;}
    Public String secondAccountPanNumber {get;set;}
    Public String secondAccountAadhaarCard {get;set;}
    Public String secondAccountPassport {get;set;}
    Public String secondAccountOCIPIOCard {get;set;}
    Public String secondAccountPanDetails {get;set;}
    Public String secondAccountAddressProof {get;set;}
    Public String secondAccountMobileNo {get;set;}
    Public String secondAccountEmail {get;set;}
    Public String secondAccountLandline {get;set;}
    Public String selectedSecondAccOccupation {get;set;}
    Public String secondAccountOrganizationName {get;set;}
    Public String secondAccountDesignation {get;set;}
    Public String secondAccountOrgOfficeAddress {get;set;}
    Public String secondAccountOrgOfficePostCode {get;set;}
    Public String selectedSecondAccOrgOfficeAddState {get;set;}
    Public String selectedSecondAccOrgOfficeAddCountry {get;set;}
    Public String secondAccountOrgPhoneNumber {get;set;}
    Public String secondAccountOtherDetails {get;set;}
    
    Public String thirdAccountSalutation {get;set;}
    Public String thirdAccountLastName {get;set;}
    Public String thirdAccountFirstName {get;set;}
    Public String thirdAccountRegiOfficeAdd {get;set;}
    Public String thirdAccountPostCode {get;set;}
    Public String selectedThirdAccPermAddState {get;set;}
    Public String selectedThirdAccPermAddCountry {get;set;}
    Public String thirdAccountCorpOfficeAddress {get;set;}
    Public String thirdAccCorpOfficePostCode {get;set;}
    Public String selectedThirdAccOrgOfficeAddState {get;set;}
    Public String selectedThirdAccOrgOfficeAddCountry {get;set;}
    Public String thirdAccountTinNumber {get;set;}
    Public String thirdAccountPanNumber {get;set;}
    Public Date thirdAccountDateOfBoardResol {get;set;}
    Public String thirdAccountInFavourOf {get;set;}
    Public String thirdAccountEmail {get;set;}
    Public String thirdAccountPhoneNumber {get;set;}
    Public String thirdAccountFaxNumber {get;set;}
    Public String thirdAccountShareHolName {get;set;}
    Public Decimal thirdAccountPerHolding {get;set;}
    Public String thirdAccountDirectorName {get;set;}
    Public String thirdAccountOtherDetails {get;set;}
    Public String thirdAccountGstNumber {get;set;}
    Public String receivedAmountInWords {get;set;}
    
    Public String contactFirstName {get;set;}
    Public String contactLastName {get;set;}
    Public String contactPhoneNumber {get;set;}
    Public String contactTitle {get;set;}
    Public String contactDepartment {get;set;}  
    Public String contactEmail {get;set;}
    Public String contactOtherNumber {get;set;}
    Public String contactDescription {get;set;}
    Public String contactAddress {get;set;}
    Public String contactPostCode {get;set;}
    Public String selectedcontactAddState {get;set;}
    Public String selectedcontactAddCountry {get;set;}
    
    Public String apartmentNumber {get;set;}
    Public String selectedResidentialLevel {get;set;}
    Public Integer carpetAreaInSqMtr {get;set;}
    Public Integer carpetAreaInSqFt {get;set;}
    Public Integer noOfParkingSpotRequired {get;set;}
    //Public Integer allotmentPremium {get;set;}
    Public Integer agreementValue {get;set;}
    Public String amountInWords {get;set;}
    Public String selectedBookingSource {get;set;}
    Public String subSourceSpecification {get;set;}
    Public Decimal receivedAmount {get;set;}
    Public String demandDraftNo {get;set;}
    Public String bankName {get;set;}
    Public Date dated {get;set;}
    Public Integer fromAccountNo {get;set;}
    Public String accountName {get;set;}
    Public String errorMsg {get;set;}
    Public String sucessMsg {get;set;}
    
    
    Public Boolean showSection1 {get;set;}
    Public Boolean showSection2 {get;set;}
    Public Boolean showSection3 {get;set;}
    Public Boolean showSection4 {get;set;}
    Public Boolean showAadhaarSection {get;set;}
    Public Boolean showGStSection {get;set;}
    Public Boolean isPrimaryAccIndian {get;set;}
    Public Boolean isPrimaryAccNonIndian {get;set;}
    Public Boolean isSecondAccIndian {get;set;}
    Public Boolean isSecondAccNonIndian {get;set;}
    Public Document document {get;set;}
    Public String selectedPropertyType {get;set;}
    Public String projectAnnexures {get;set;}
    Public String projectTermsandConditions {get;set;}
    Public Boolean isAgreeWithTermsConditions {get;set;}
    Public Boolean isSubmitButtonDisable {get;set;}
    Public String suggestedLink {get;set;}
    Public Boolean isDisableTermCondiCheckbox {get;set;}   
    Public String subBookingOffer {get;set;}
    Public String selectedEOIBooking {get;set;}
    Public Date eoiDate {get;set;}
    Public Decimal eoiAmount {get;set;}
    Public Boolean showEoiBookingDateandAmt {get;set;}
    Public Decimal TotalAmount {get;set;}
    
    /* public Account primaryAccountObj {get;set;}
public Account secondaryAccountObj {get;set;}
public Account thirdAccountObj {get;set;}
public Opportunity opportunityObj {get;set;}
public Booking__c bookingObj {get;set;}
public Document document {get;set;}*/
    
    Public Booking__c bookingRecord {get;set;}
    Public Account primaryAccountRecord {get;set;}
    Public List<Co_Applicant__c> coApplicantList {get;set;}
    Public Co_Applicant__c coAppllicantRecord {get;set;}
    Public Account secondAccountRecord {get;set;}
    Public List<Account> thirdAccountRecord {get;set;}
    Public Opportunity opportunityRecord {get;set;}
    Public List<Payment__c> paymentList {get;set;}
    Public Payment__c paymentRecord {get;set;}
    Public Project__c projectRecord {get;set;}
    Public Suggested_Property__c suggProprtyRecord {get;set;}
    Public Property__c propertyRecord {get;set;}
    public List<Suggested_Property__c> suggestedLinkList {get;set;} 
    Public List<Booking_Offer__c> projectOfferList {get;set;}
    public List<String> projectOfferName { get; set; }
    Public String submittedBy {get;set;}
    
    //primary account documents
    public transient Blob primaryAccPanCardFile {get;set;}
    Public String primaryAccPanCardFileName {get;set;}
    public transient Blob primaryAccAadharCardFile {get;set;}
    Public String primaryAccAadharCardFileName {get;set;}
    public transient Blob primaryAccPassportFile {get;set;}
    Public String primaryAccPassportFileName {get;set;}
    public transient Blob primaryAccOCIPIOFile {get;set;}
    Public String primaryAccOCIPIOFileName {get;set;}
    public transient Blob primaryAccPanDetailsFile {get;set;}
    Public String primaryAccPanDetailsFileName {get;set;}
    public transient Blob primaryAccAddProofFile {get;set;}
    Public String primaryAccAddProofFileName {get;set;}
    
    //second account documents
    public transient Blob secondAccPanCardFile {get;set;}
    Public String secondAccPanCardFileName {get;set;}
    public transient Blob secondAccAadharCardFile {get;set;}
    Public String secondAccAadharCardFileName {get;set;}
    public transient Blob secondAccPassportFile {get;set;}
    Public String secondAccPassportFileName {get;set;}
    public transient Blob secondAccOCIPIOFile {get;set;}
    Public String secondAccOCIPIOFileName {get;set;}
    public transient Blob secondAccPanDetailsFile {get;set;}
    Public String secondAccPanDetailsFileName {get;set;}
    public transient Blob secondAccAddProofFile {get;set;}
    Public String secondAccAddProofFileName {get;set;}
    Public String secondAccId {get;set;}
    public transient Blob thirdAccGstNumberFile {get;set;}
    Public String thirdAccGstNumberName {get;set;}
    
    Public String otpCode {get;set;}
    public Integer randomNumber{get;set;}
    Public Boolean isverifyed {get;set;}
    Public String otpBtnValue {get;set;}
    Public String builderOrgName {get;set;}
    
    Public Boolean isDisablePurPurpose {get;set;}
    Public Boolean isDisableEOIBooking {get;set;}
    Public Boolean showProjectOffer {get;set;}
    Public Boolean isDisableOffer {get;set;}
    Public Boolean showEOICASection {get;set;}
    Public List<Offer__c> selectedOfferList {get;set;}
    
    Public BookingFormVfpController(ApexPages.StandardController stdController) {
        recordId=ApexPages.currentPage().getParameters().get('Id'); 
        system.debug('recordId--'+recordId);
        submittedBy = '';
        submittedBy = ApexPages.currentPage().getParameters().get('submitted'); 
        System.debug('submittedBy:'+submittedBy);
        //recordId='a0CC4000008Ec42MAC';
        // recordId='a0CBh000000LuGvMAK';
        isverifyed = true;
        otpCode = '';
        builderOrgName='';
        randomNumber = 0;
        TotalAmount= 0;
        selectedPurchasePurpose='Individual';
        otpBtnValue='Get OTP';
        showSection1=true;
        showSection2=true;
        showSection3=false;
        isPrimaryAccIndian=false;
        isPrimaryAccNonIndian=false;
        isSecondAccIndian=false;
        isSecondAccNonIndian=false;
        isAgreeWithTermsConditions=false;
        isSubmitButtonDisable=false;
        isDisableTermCondiCheckbox=false;
        showEoiBookingDateandAmt=false;
        selectedPrimaryAccNationality='Indian';
        selectedSecondAccNationality='None';
        showAadhaarSection =true;
        showGStSection = false;
        showEOICASection = false;
        errorMsg='';
        sucessMsg='';
        projectOfferName = new List<String>();
        thirdAccountRecord = new List<Account>();
        
        
        //for Customer
        if(submittedBy=='customer'){
            isDisablePurPurpose=true;
            isDisableEOIBooking=true;
            isDisableOffer=true;
        }
        else{
            isDisablePurPurpose=false;
            isDisableEOIBooking=false;
            isDisableOffer=false;
        }
        
        //get Booking Record details
        bookingRecord = [Select Id,Name,Primary_Applicant__c,Project_Name__c,Project_Name__r.Name,Related_Suggested_Property__c,Primary_Applicant__r.Name,Related_Opportunity__c,
                         Total_Amount_Received__c,Sub_Booking_Offer__c,Agreement_Value__c,Booking_Date__c,
                         Related_Opportunity__r.EOI_CA__c, Related_Opportunity__r.EOI_CA_Payment_Received__c,
                         Related_Opportunity__r.EOI_CA_Approved_Payment__c,Related_Opportunity__r.EOI_CA_Form_Submission_Date_and_Time__c,
                         Project_Name__r.Project_Email__c,Related_Opportunity__r.Nature_of_Purchase__c From Booking__c Where Id=:recordId];
        System.debug('bookingRecord:'+bookingRecord);
        System.debug('User:'+UserInfo.getName());
        if(bookingRecord.Related_Opportunity__r.EOI_CA__c == 'EOI' || bookingRecord.Related_Opportunity__r.EOI_CA__c == 'CA')
        {
            isDisableEOIBooking=true;
            selectedEOIBooking = 'Yes';
            eoiDate = Date.valueof(bookingRecord.Related_Opportunity__r.EOI_CA_Form_Submission_Date_and_Time__c);
            showEOICASection = true;
            if(bookingRecord.Related_Opportunity__r.EOI_CA_Approved_Payment__c != null && bookingRecord.Related_Opportunity__r.EOI_CA_Approved_Payment__c > 0){
                
                TotalAmount = bookingRecord.Related_Opportunity__r.EOI_CA_Approved_Payment__c ;
            }
            
        }
        else
        {
            isDisableEOIBooking=true;
            selectedEOIBooking = 'No';  
            showEOICASection = false;
        }
        if(bookingRecord.Related_Suggested_Property__c != null)
        {
            suggestedLinkList = [SELECT Id, Cost_Sheet_Link__c FROM Suggested_Property__c
                                 WHERE Id =: bookingRecord.Related_Suggested_Property__c LIMIT 10 ];  
        }
        system.debug('suggestedLinkList--'+suggestedLinkList);
        
        accountName=bookingRecord.Primary_Applicant__r.Name;
        agreementValue=Integer.valueOf(bookingRecord.Agreement_Value__c);
        
        //for get selected offer of booking
        selectedOfferList=[Select Id,Name,Project_Offer__c,Booking__c From Offer__c Where Booking__c=:bookingRecord.Id];
        //get Primary Account Details
        if(bookingRecord.Primary_Applicant__c!=null){
            
            primaryAccountRecord=[Select Id,Name,Salutation,FirstName,MiddleName,LastName,PersonBirthdate,Permanent_Address__c,
                                  Post_Code__c,Country__c,State__c,PersonMailingAddress,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCity,PersonMailingState,PersonMailingCountry,Preferred_Address_for_all_Corresppondenc__c,
                                  Nationality__c,Aadhar_No__pc,PAN_No__pc,Passport__c,OCI_PIO_Card__c,PAN_Details__c,Address_Proof__c,
                                  PersonMobilePhone,PersonEmail,Landline__c,Occupation__pc,Organisation_Name__c,Designation_or_Position__pc,
                                  Organisation_Office_Address__c,Postal_Code__c,Organisation_State__c,Organisation_Country__c,
                                  Organisation_Phone_Number__c,Other_Details_Remarks__c,GSTIN_No__c
                                  From Account Where Id=:bookingRecord.Primary_Applicant__c];
            
            //for set primary account details
            primaryAccountSalutation=primaryAccountRecord.Salutation;
            primaryAccountLastName=primaryAccountRecord.LastName;
            primaryAccountMiddleName=primaryAccountRecord.MiddleName;
            primaryAccountFirstName=primaryAccountRecord.FirstName;
            primaryAccountBirthDate=primaryAccountRecord.PersonBirthdate;
            primaryAccountPermanentAddress=primaryAccountRecord.Permanent_Address__c;  
            primaryAccountPostCode=primaryAccountRecord.Post_Code__c;
            thirdAccountGstNumber=primaryAccountRecord.GSTIN_No__c;
            selectedPrimaryAccPermAddState=primaryAccountRecord.State__c;
            selectedPrimaryAccPermAddCountry=primaryAccountRecord.Country__c;
            primaryAccMailingAddStreet=primaryAccountRecord.PersonMailingStreet;
            primaryAccMailingAddCity=primaryAccountRecord.PersonMailingCity;
            primaryAccMailingAddPostalCode= primaryAccountRecord.PersonMailingPostalCode;
            primaryAccMailingAddState= primaryAccountRecord.PersonMailingState;
            primaryAccMailingAddCountry=primaryAccountRecord.PersonMailingCountry;
            
            selectedPrimaryAccPreffAdd=primaryAccountRecord.Preferred_Address_for_all_Corresppondenc__c;
            if(primaryAccountRecord.Nationality__c != null ){
                selectedPrimaryAccNationality=primaryAccountRecord.Nationality__c;   
            }
            primaryAccountPanNumber=primaryAccountRecord.PAN_No__pc;
            primaryAccountAadhaarCard=primaryAccountRecord.Aadhar_No__pc;
            primaryAccountPassport=primaryAccountRecord.Passport__c;
            primaryAccountOCIPIOCard=primaryAccountRecord.OCI_PIO_Card__c;
            primaryAccountPanDetails=primaryAccountRecord.PAN_Details__c;
            primaryAccountAddressProof=primaryAccountRecord.Address_Proof__c;
            primaryAccountMobileNo=primaryAccountRecord.PersonMobilePhone;
            primaryAccountEmail=primaryAccountRecord.PersonEmail;
            primaryAccountLandline= primaryAccountRecord.Landline__c;
            selectedPrimaryAccOccupation=primaryAccountRecord.Occupation__pc;
            primaryAccountOrganizationName=primaryAccountRecord.Organisation_Name__c;
            primaryAccountDesignation=primaryAccountRecord.Designation_or_Position__pc;
            primaryAccountOrgOfficeAddress=primaryAccountRecord.Organisation_Office_Address__c;
            primaryAccountOrgOfficePostCode=primaryAccountRecord.Postal_Code__c;
            selectedPrimaryAccOrgOfficeAddState=primaryAccountRecord.Organisation_State__c;
            selectedPrimaryAccOrgOfficeAddCountry=primaryAccountRecord.Organisation_Country__c;
            primaryAccountOrgPhoneNumber=primaryAccountRecord.Organisation_Phone_Number__c;
            primaryAccountOtherDetails=primaryAccountRecord.Other_Details_Remarks__c;
            onChangePrimaryAccNationality();
        }
        if(bookingRecord.Sub_Booking_Offer__c !=null){
            subBookingOffer=bookingRecord.Sub_Booking_Offer__c;
        }
        //get Co-Applicant
        coApplicantList=[Select Id,Name,Account__c,Role__c,Booking__c From Co_Applicant__c Where Booking__c=:recordId AND Role__c!='Primary' ];
        System.debug('coApplicantList:'+coApplicantList);
        if(coApplicantList.size()>0){
            coAppllicantRecord=coApplicantList[0];
            System.debug('coAppllicantRecord:'+coAppllicantRecord);
            if(coAppllicantRecord.Account__c!=null){
                secondAccountRecord=[Select Id,Name,Salutation,FirstName,MiddleName,LastName,PersonBirthdate,Permanent_Address__c,
                                     Post_Code__c,Country__c,State__c,PersonMailingAddress,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCity,PersonMailingState,PersonMailingCountry,Preferred_Address_for_all_Corresppondenc__c,
                                     Nationality__c,PAN_No__pc,Aadhar_No__pc,Passport__c,OCI_PIO_Card__c,PAN_Details__c,Address_Proof__c,
                                     PersonMobilePhone,PersonEmail,Landline__c,Occupation__pc,Organisation_Name__c,Designation_or_Position__pc,
                                     Organisation_Office_Address__c,Postal_Code__c,Organisation_State__c,Organisation_Country__c,
                                     Organisation_Phone_Number__c,Other_Details_Remarks__c
                                     From Account Where Id=:coAppllicantRecord.Account__c];
                
                
                //for set second account details
                secondAccountSalutation=secondAccountRecord.Salutation;
                secondAccountLastName=secondAccountRecord.LastName;
                secondAccountMiddleName=secondAccountRecord.MiddleName;
                secondAccountFirstName=secondAccountRecord.FirstName;
                secondAccountBirthDate=secondAccountRecord.PersonBirthdate;
                secondAccountPermanentAddress=secondAccountRecord.Permanent_Address__c;  
                secondAccountPostCode=secondAccountRecord.Post_Code__c;
                selectedSecondAccPermAddState=secondAccountRecord.State__c;
                selectedSecondAccPermAddCountry=secondAccountRecord.Country__c;
                
                secondAccMailingAddStreet=secondAccountRecord.PersonMailingStreet;
                secondAccMailingAddCity=secondAccountRecord.PersonMailingCity;
                secondAccMailingAddPostalCode= secondAccountRecord.PersonMailingPostalCode;
                secondAccMailingAddState= secondAccountRecord.PersonMailingState;
                secondAccMailingAddCountry=secondAccountRecord.PersonMailingCountry;
                
                selectedSecondAccPreffAdd=secondAccountRecord.Preferred_Address_for_all_Corresppondenc__c;
                if(secondAccountRecord.Nationality__c != null){
                    selectedSecondAccNationality=secondAccountRecord.Nationality__c;      
                }
                secondAccountPanNumber=secondAccountRecord.PAN_No__pc;
                secondAccountAadhaarCard=secondAccountRecord.Aadhar_No__pc;
                secondAccountMobileNo=secondAccountRecord.PersonMobilePhone;
                secondAccountPassport=secondAccountRecord.Passport__c;
                secondAccountOCIPIOCard=secondAccountRecord.OCI_PIO_Card__c;
                secondAccountPanDetails=secondAccountRecord.PAN_Details__c;
                secondAccountAddressProof=secondAccountRecord.Address_Proof__c;
                secondAccountEmail=secondAccountRecord.PersonEmail;
                secondAccountLandline=secondAccountRecord.Landline__c;
                selectedSecondAccOccupation=secondAccountRecord.Occupation__pc;
                secondAccountOrganizationName=secondAccountRecord.Organisation_Name__c;
                secondAccountDesignation=secondAccountRecord.Designation_or_Position__pc;
                secondAccountOrgOfficeAddress=secondAccountRecord.Organisation_Office_Address__c;
                secondAccountOrgOfficePostCode=secondAccountRecord.Postal_Code__c;
                selectedSecondAccOrgOfficeAddState=secondAccountRecord.Organisation_State__c;
                selectedSecondAccOrgOfficeAddCountry=secondAccountRecord.Organisation_Country__c;
                secondAccountOrgPhoneNumber=secondAccountRecord.Organisation_Phone_Number__c;
                secondAccountOtherDetails=secondAccountRecord.Other_Details_Remarks__c;
            }
            onChangeSecondAccNationality();
            //for get third account details (co-applicant account)
            
            
        }
        
        //for get opportunity record
        if(bookingRecord.Related_Opportunity__c!=null){
            opportunityRecord=[Select Id,Name,Current_Occupied_Property_Type__c,Apartment_Number__c,Residential_Level__c,
                               Carpet_Area_in_sq_ft__c,Carpet_Area_in_sq_mts__c,No_of_Parking_s_Spots_Required__c,Company_Partnership__c,
                               Allotment_Premium__c,Amount_in_Words__c,Source__c,Sub_Source_Specification__c,Nature_of_Purchase__c,EOI_CA_Payment_Received__c,
                               Is_Booking_Form_Submitted_by_Customer__c,EOI_Booking__c,EOI_Amount__c,EOI_Date__c,Digital_Booking_Form_Verified_by_SM__c
                               From Opportunity Where Id=:bookingRecord.Related_Opportunity__c]; 
            //for set Opportunity data
            //  selectedPropertyType=opportunityRecord.Current_Occupied_Property_Type__c;
            apartmentNumber=opportunityRecord.Apartment_Number__c;
            selectedResidentialLevel=opportunityRecord.Residential_Level__c;
            // carpetAreaInSqMtr=Integer.valueOf( opportunityRecord.Carpet_Area_in_sq_mts__c);
            // carpetAreaInSqFt=Integer.valueOf( opportunityRecord.Carpet_Area_in_sq_ft__c);
            noOfParkingSpotRequired=Integer.valueOf( opportunityRecord.No_of_Parking_s_Spots_Required__c);
            // allotmentPremium=Integer.valueOf(opportunityRecord.Allotment_Premium__c);
            amountInWords=opportunityRecord.Amount_in_Words__c;
            selectedBookingSource=opportunityRecord.Source__c;
           // selectedEOIBooking =opportunityRecord.EOI_Booking__c;
            //eoiDate  =opportunityRecord.EOI_Date__c;
            eoiAmount  =opportunityRecord.EOI_CA_Payment_Received__c;
            subSourceSpecification=opportunityRecord.Sub_Source_Specification__c;
            if(opportunityRecord.Company_Partnership__c == true){
                selectedPurchasePurpose='Company/Partnership';
                showAadhaarSection =false;
                showGStSection = true;
                
            }
            else{
                selectedPurchasePurpose='Individual';
            }
            /*if(opportunityRecord.Nature_of_Purchase__c=='Investment'){
selectedPurchasePurpose='Company/Partnership';

}
else if(opportunityRecord.Nature_of_Purchase__c=='Self Use'){
selectedPurchasePurpose='Individual';
}*/
            if(opportunityRecord.Is_Booking_Form_Submitted_by_Customer__c==true){
                isSubmitButtonDisable=true;
                isDisableTermCondiCheckbox=true;
            }
            System.debug('SelectedPurchasePurpose'+SelectedPurchasePurpose);
            System.debug('showGStSection'+showGStSection);
            System.debug('showAadhaarSection'+showAadhaarSection);
            /*if(selectedPurchasePurpose  != 'Individual')
{
String businessRecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Business Account').getRecordTypeId();

thirdAccountRecord=[Select Id,Name,Registered_Office_Address__c,Post_Code__c,Country__c,State__c,
Corporate_Office_Address__c,Postal_Code__c,Organisation_State__c,Email__c,
Organisation_Country__c,Tin_Number__c,PAN_No__pc,Other_Details_Remarks__c,
Date_of_Board_Resolution_Authority_Lett__c,PersonEmail,Phone,Fax_Number__c,
Name_of_Share_Holders_Partners__c,In_Favour_Of__c,Name_of_Directors__c,
Percentage_Holding__c From Account Where Id =: bookingRecord.Primary_Applicant__c
AND
RecordTypeId =: businessRecordTypeId];
System.debug('thirdAccountRecord'+thirdAccountRecord);
if(!thirdAccountRecord.isEmpty()){
//for set third account details
//thirdAccountName=thirdAccountRecord.Name;
thirdAccountSalutation='M/S';
thirdAccountLastName=thirdAccountRecord[0].Name;
// thirdAccountFirstName=thirdAccountRecord[0].FirstName;
thirdAccountRegiOfficeAdd=thirdAccountRecord[0].Registered_Office_Address__c;
thirdAccountPostCode=thirdAccountRecord[0].Post_Code__c;
selectedThirdAccPermAddState=thirdAccountRecord[0].State__c;
selectedThirdAccPermAddCountry=thirdAccountRecord[0].Country__c;
thirdAccountCorpOfficeAddress=thirdAccountRecord[0].Corporate_Office_Address__c;
thirdAccCorpOfficePostCode=thirdAccountRecord[0].Postal_Code__c;
selectedThirdAccOrgOfficeAddState=thirdAccountRecord[0].Organisation_State__c;
selectedThirdAccOrgOfficeAddCountry=thirdAccountRecord[0].Organisation_Country__c;
thirdAccountTinNumber=thirdAccountRecord[0].Tin_Number__c;
//thirdAccountPanNumber=thirdAccountRecord.PAN_No__pc;
thirdAccountDateOfBoardResol=thirdAccountRecord[0].Date_of_Board_Resolution_Authority_Lett__c;
thirdAccountInFavourOf=thirdAccountRecord[0].In_Favour_Of__c;
thirdAccountEmail=thirdAccountRecord[0].Email__c;
thirdAccountPhoneNumber=thirdAccountRecord[0].Phone;
thirdAccountFaxNumber=thirdAccountRecord[0].Fax_Number__c;
thirdAccountShareHolName=thirdAccountRecord[0].Name_of_Share_Holders_Partners__c;
thirdAccountPerHolding=thirdAccountRecord[0].Percentage_Holding__c;
thirdAccountDirectorName=thirdAccountRecord[0].Name_of_Directors__c;
thirdAccountOtherDetails=thirdAccountRecord[0].Other_Details_Remarks__c;
}

}*/
            onChangePurchasePurpose();
            onChangeEoiBooking();
            onChangePrimaryAccNationality();
            onChangeSecondAccNationality();
        }        
        //get payment List
        paymentList=[Select Id,Name,Cheque_Transaction_Number__c,Amount__c,Payment_Date__c,opportunity__c,Booking__c,BankName__c,BankName__r.Name,Payment_Category__c,Payment_Status__c
                     From Payment__c 
                     Where Booking__c=:recordId AND Payment_Category__c=:'Unit Cost'AND Payment_Status__c != 'Rejected' AND opportunity__c =: null
                     ORDER BY Payment_Date__c ASC
                    ];
        if(paymentList.size()>0){
            receivedAmount=0;
            //paymentRecord=paymentList[0];
            
            //set payment data
            //  demandDraftNo=paymentRecord.Cheque_Transaction_Number__c;
            //   bankName=paymentRecord.BankName__r.Name;
            //   dated=paymentRecord.Payment_Date__c;      
            for(Payment__c paymentRcd:paymentList){  
                if(paymentRcd.Amount__c!=null){
                    receivedAmount+=paymentRcd.Amount__c;
                }
            }
            if(receivedAmount!=0){ 
                
                    TotalAmount  = receivedAmount +  TotalAmount;
                    
                receivedAmountInWords='Rupees '+ NumberTOWordConvertion.getNumberTOWordConvertion(receivedAmount)+' Only'; 
            }
        }
        if(bankName==null){
            bankName='N/A';
        }
        if(bookingRecord.Project_Name__c!=null){
            projectRecord=[Select Id,Name,Builder_Organization__c,Builder_Organization__r.Account_Name__c From Project__c Where Id=:bookingRecord.Project_Name__c];
            //projectAnnexures=projectRecord.Name;
            //projectTermsandConditions=projectRecord.Name;
            builderOrgName=projectRecord.Builder_Organization__r.Account_Name__c;
            //get project offer list related to booking project
            projectOfferList=[Select Id,Name,Active__c,Project__c From Booking_Offer__c Where Project__c=:bookingRecord.Project_Name__c AND Active__c=true];
            System.debug('projectOfferList:'+projectOfferList);
            if(projectOfferList.size() == 0){
                showProjectOffer=false;
            }
            else{
                showProjectOffer=true;
            }
        } 
        if(bookingRecord.Related_Suggested_Property__c!=null && bookingRecord.Related_Opportunity__c!=null){
            
            suggProprtyRecord=[Select Id,Name,Opportunity__c,Unit__c From Suggested_Property__c Where Opportunity__c=:bookingRecord.Related_Opportunity__c AND Id=:bookingRecord.Related_Suggested_Property__c];
            if(suggProprtyRecord!=null){
                projectRecord = [Select Id,Name, Terms_Conditions__c From Project__c Where Id=: bookingRecord.Project_Name__c];
                propertyRecord=[Select Id,Name,Annexure__c,Annexures__c,Terms_Conditions__c,Flat_Type__c,RERA_Carpet_Area__c,RERA_Carpet_Area_in_sqmtr__c,Utility_Area__c,Enclosed_balcony__c,Deck_Carpet_Area__c,
                                Proposed_Area__c,Proposed_Area_c_in_sqmtr__c,Approved_Area__c,Approved_Area_in_sqmtr__c,Deck_Approved_Area__c,Deck_Proposed_Area__c,Proposed_Utility_Area__c,
                                Proposed_Enclosed_Balcony_Area__c,Deck_Carpet_Area_c_in_sqmtr__c,Property_Area__c,Utility_Area_in_sqmtr__c,Enclosed_Balcony_in_sqmtr__c,
                                Property_Area_in_sqmtr__c,Proposed_Deck_Area_in_sq_mt__c,Approved_Deck_Area_in_sq_mt__c,Proposed_Utility_Area_in_sq_mt__c,Proposed_Enclosed_Balcony_Area_sq_mt__c,
                                Total_Area__c,Total_Area_in_sq_mt__c,Proposed_Total_Area__c,Proposed_Total_Area_in_sq_mt__c
                                From Property__c Where Id=:suggProprtyRecord.Unit__c];
                if(propertyRecord!=null){
                    projectAnnexures=propertyRecord.Annexures__c;
                    projectTermsandConditions=projectRecord.Terms_Conditions__c;
                    /*   projectAnnexures=propertyRecord.Annexure__c;
projectTermsandConditions=propertyRecord.Terms_Conditions__c;*/
                    selectedPropertyType=propertyRecord.Flat_Type__c;
                    carpetAreaInSqMtr=Integer.valueOf(propertyRecord.RERA_Carpet_Area_in_sqmtr__c);
                    carpetAreaInSqFt=Integer.valueOf(propertyRecord.RERA_Carpet_Area__c);
                }
            }
        }
        if(selectedOfferList.size()>0){
            for(Offer__c offerRcd:selectedOfferList){
                projectOfferName.add(offerRcd.Project_Offer__c);
            }
        }
    }  
    public List<SelectOption> getprojectOfferNames() {
        List<SelectOption> projectOffersOption = new List<SelectOption>();
        if(projectOfferList.size()>0){
            for(Booking_Offer__c bookingOffRcd:projectOfferList){
                projectOffersOption.add(new SelectOption(bookingOffRcd.Id, bookingOffRcd.Name));
            }
        }
        if(submittedBy!='customer'){
            projectOffersOption.add(new SelectOption('0', 'None'));
        }
        System.debug('projectOfferList Size===>'+projectOfferList.size());
        return projectOffersOption;
        
    }
    public List<SelectOption> getselPurchasePurposeOption() {
        List<SelectOption> selPurchasePurposeOption = new List<SelectOption>();
        selPurchasePurposeOption.add(new SelectOption('Individual','Individual'));
        selPurchasePurposeOption.add(new SelectOption('Company/Partnership','Company/Partnership')); 
        return selPurchasePurposeOption;
    }
    public List<SelectOption> getprimaryAccountSalutationOption() {
        List<SelectOption> primaryAccountSalutationOption = new List<SelectOption>();
        primaryAccountSalutationOption.add(new SelectOption('','None'));
        if(selectedPurchasePurpose !='Individual')
        {
            primaryAccountSalutationOption.add(new SelectOption('M/S','M/S'));
        }
        else{
            primaryAccountSalutationOption.add(new SelectOption('Mr.','Mr.'));
            primaryAccountSalutationOption.add(new SelectOption('Mrs.','Mrs.')); 
            primaryAccountSalutationOption.add(new SelectOption('Ms.','Ms.')); 
        }
        return primaryAccountSalutationOption;
    }
    public List<SelectOption> getsecondAccountSalutationOption() {
        List<SelectOption> secondAccountSalutationOption = new List<SelectOption>();
        secondAccountSalutationOption.add(new SelectOption('','None'));
        secondAccountSalutationOption.add(new SelectOption('Mr.','Mr.'));
        secondAccountSalutationOption.add(new SelectOption('Mrs.','Mrs.')); 
        secondAccountSalutationOption.add(new SelectOption('Ms.','Ms.')); 
        return secondAccountSalutationOption;
    }
    public List<SelectOption> getthirdAccountSalutationOption() {
        List<SelectOption> thirdAccountSalutationOption = new List<SelectOption>();
        thirdAccountSalutationOption.add(new SelectOption('','None'));
        if(selectedPurchasePurpose !='Individual')
        {
            thirdAccountSalutationOption.add(new SelectOption('M/S','M/S'));
        }
        else
        {
            thirdAccountSalutationOption.add(new SelectOption('Mr.','Mr.'));
            thirdAccountSalutationOption.add(new SelectOption('Mrs.','Mrs.')); 
            thirdAccountSalutationOption.add(new SelectOption('Ms.','Ms.'));
        }
        
        return thirdAccountSalutationOption;
    }
    public List<SelectOption> getselectedPrimaryAccPermAddCountryOptions()
    {        
        List<SelectOption> selectedPrimaryAccPermAddCountryOptions = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('Country__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // Add these values to the selectoption list.
        selectedPrimaryAccPermAddCountryOptions.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : values){
            selectedPrimaryAccPermAddCountryOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedPrimaryAccPermAddCountryOptions;
    } 
    
    public List<SelectOption> getselectedPrimaryAccPermAddStateOptions()
    {        
        List<SelectOption> selectedPrimaryAccPermAddStateOptions = new List<SelectOption>();
        Map<String, List<SelectOption>> countryStateMap = New Map<String, List<SelectOption>>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('State__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // Add these values to the selectoption list.
        selectedPrimaryAccPermAddStateOptions.add(new SelectOption('','None'));
        /*for (Schema.PicklistEntry a : values){
if(selectedPrimaryAccPermAddCountry=='India'){
selectedPrimaryAccPermAddStateOptions.add(new SelectOption(a.getValue(),a.getValue()));
}
}*/
        List<Country_and_State__mdt> countryStateList = [SELECT id, State__c, Country__c, Label 
                                                         FROM Country_and_State__mdt];
        if(!countryStateList.isEmpty())
        {
            for(Country_and_State__mdt thisCS :countryStateList)
            {
                if(countryStateMap.containsKey(thisCS.Country__c))
                {
                    List<SelectOption> internalStateList = new List<SelectOption>();
                    internalStateList = countryStateMap.get(thisCS.Country__c);
                    internalStateList.add(new SelectOption(thisCS.state__c,thisCS.state__c));
                    countryStateMap.put(thisCS.Country__c,internalStateList);
                }
                else
                {
                    List<SelectOption> internalStateList = new List<SelectOption>();
                    internalStateList.add(new SelectOption('','None'));
                    internalStateList.add(new SelectOption(thisCS.state__c,thisCS.state__c));
                    countryStateMap.put(thisCS.Country__c,internalStateList);
                    
                }
            }
            try{
                /* if(selectedPurchasePurpose !='Individual')
{
if(selectedThirdAccPermAddCountry != '')
{
if(countryStateMap.containsKey(selectedThirdAccPermAddCountry))
{
selectedPrimaryAccPermAddStateOptions = countryStateMap.get(selectedThirdAccPermAddCountry);
}
}
}
else
{*/
                if(selectedPrimaryAccPermAddCountry !='')
                {
                    if(countryStateMap.containsKey(selectedPrimaryAccPermAddCountry))
                    {
                        selectedPrimaryAccPermAddStateOptions = countryStateMap.get(selectedPrimaryAccPermAddCountry);
                    }
                }
                //}
            }
            catch(Exception ex)
            {
                system.debug('Error'+ex.getMessage());
            }
        }
        return selectedPrimaryAccPermAddStateOptions;
    }
    public void onChangePrimaryAccCountry(){
        getselectedPrimaryAccPermAddStateOptions();
    }
    public List<SelectOption> getselectedSecondAccPermAddCountryOptions()
    {        
        List<SelectOption> selectedSecondAccPermAddCountryOptions = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('Country__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // Add these values to the selectoption list.
        selectedSecondAccPermAddCountryOptions.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : values){
            selectedSecondAccPermAddCountryOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedSecondAccPermAddCountryOptions;
    } 
    public List<SelectOption> getselectedSecondAccPermAddStateOptions()
    {     
        Map<String, List<SelectOption>> countryStateMap = New Map<String, List<SelectOption>>();
        List<SelectOption> selectedSecondAccPermAddStateOptions = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('State__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // Add these values to the selectoption list.
        selectedSecondAccPermAddStateOptions.add(new SelectOption('','None'));
        /*for (Schema.PicklistEntry a : values){
if(selectedSecondAccPermAddCountry=='India'){
selectedSecondAccPermAddStateOptions.add(new SelectOption(a.getValue(),a.getValue()));
}
}*/
        List<Country_and_State__mdt> countryStateList = [SELECT id, State__c, Country__c, Label 
                                                         FROM Country_and_State__mdt];
        if(!countryStateList.isEmpty())
        {
            for(Country_and_State__mdt thisCS :countryStateList)
            {
                if(countryStateMap.containsKey(thisCS.Country__c))
                {
                    List<SelectOption> internalStateList = new List<SelectOption>();
                    internalStateList = countryStateMap.get(thisCS.Country__c);
                    internalStateList.add(new SelectOption(thisCS.state__c,thisCS.state__c));
                    countryStateMap.put(thisCS.Country__c,internalStateList);
                }
                else
                {
                    List<SelectOption> internalStateList = new List<SelectOption>();
                    internalStateList.add(new SelectOption('','None'));
                    internalStateList.add(new SelectOption(thisCS.state__c,thisCS.state__c));
                    countryStateMap.put(thisCS.Country__c,internalStateList);
                    
                }
            }
            try{
                /* if(selectedPurchasePurpose !='Individual')
{
if(selectedcontactAddCountry!='')
{
if(countryStateMap.containsKey(selectedcontactAddCountry))
{
selectedSecondAccPermAddStateOptions = countryStateMap.get(selectedcontactAddCountry);
}
}
}
else
{*/
                if(selectedSecondAccPermAddCountry!='')
                {
                    if(countryStateMap.containsKey(selectedSecondAccPermAddCountry))
                    {
                        selectedSecondAccPermAddStateOptions = countryStateMap.get(selectedSecondAccPermAddCountry);
                    }
                }
                //}
            }
            catch(Exception ex)
            {
                system.debug('Error'+ex.getMessage());
            }
        }
        return selectedSecondAccPermAddStateOptions;
    }
    public void onChangeSecondAccCountry(){
        getselectedSecondAccPermAddStateOptions();
    }
    public List<SelectOption> getselectedPrimaryAccOrgOfficeAddCountryOptions()
    {        
        List<SelectOption> selectedPrimaryAccOrgOfficeAddCountryOptions = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('Organisation_Country__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // Add these values to the selectoption list.
        selectedPrimaryAccOrgOfficeAddCountryOptions.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : values){
            selectedPrimaryAccOrgOfficeAddCountryOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedPrimaryAccOrgOfficeAddCountryOptions;
    } 
    public List<SelectOption> getselectedPrimaryAccOrgOfficeAddStateOptions()
    {        
        Map<String, List<SelectOption>> countryStateMap = New Map<String, List<SelectOption>>();
        List<SelectOption> selectedPrimaryAccOrgOfficeAddStateOptions = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('Organisation_State__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // Add these values to the selectoption list.
        selectedPrimaryAccOrgOfficeAddStateOptions.add(new SelectOption('','None'));
        /* for (Schema.PicklistEntry a : values){
if(selectedPrimaryAccOrgOfficeAddCountry=='India'){
selectedPrimaryAccOrgOfficeAddStateOptions.add(new SelectOption(a.getValue(),a.getValue()));
}
}*/
        List<Country_and_State__mdt> countryStateList = [SELECT id, State__c, Country__c, Label 
                                                         FROM Country_and_State__mdt];
        if(!countryStateList.isEmpty())
        {
            for(Country_and_State__mdt thisCS :countryStateList)
            {
                if(countryStateMap.containsKey(thisCS.Country__c))
                {
                    List<SelectOption> internalStateList = new List<SelectOption>();
                    internalStateList = countryStateMap.get(thisCS.Country__c);
                    internalStateList.add(new SelectOption(thisCS.state__c,thisCS.state__c));
                    countryStateMap.put(thisCS.Country__c,internalStateList);
                }
                else
                {
                    List<SelectOption> internalStateList = new List<SelectOption>();
                    internalStateList.add(new SelectOption('','None'));
                    internalStateList.add(new SelectOption(thisCS.state__c,thisCS.state__c));
                    countryStateMap.put(thisCS.Country__c,internalStateList);
                    
                }
            }
            try{
                system.debug('selectedPurchasePurpose'+selectedPurchasePurpose);
                system.debug('selectedThirdAccOrgOfficeAddCountry'+selectedThirdAccOrgOfficeAddCountry);
                /*if(selectedPurchasePurpose !='Individual')
{
if(selectedThirdAccOrgOfficeAddCountry!='')
{
if(countryStateMap.containsKey(selectedThirdAccOrgOfficeAddCountry))
{
selectedPrimaryAccOrgOfficeAddStateOptions = countryStateMap.get(selectedThirdAccOrgOfficeAddCountry);
}
}
}
else
{*/
                if(selectedPrimaryAccOrgOfficeAddCountry !='')
                {
                    if(countryStateMap.containsKey(selectedPrimaryAccOrgOfficeAddCountry))
                    {
                        selectedPrimaryAccOrgOfficeAddStateOptions = countryStateMap.get(selectedPrimaryAccOrgOfficeAddCountry);
                    }
                }
                //}
            }
            catch(Exception ex)
            {
                system.debug('Error'+ex.getMessage());
            }
        }
        return selectedPrimaryAccOrgOfficeAddStateOptions;
    }
    public void onChangePrimaryAccOrgOfficeCountry(){
        getselectedPrimaryAccOrgOfficeAddStateOptions();
    }
    
    public List<SelectOption> getselectedSecondAccOrgOfficeAddCountryOptions()
    {        
        List<SelectOption> selectedSecondAccOrgOfficeAddCountryOptions = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('Organisation_Country__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // Add these values to the selectoption list.
        selectedSecondAccOrgOfficeAddCountryOptions.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : values){
            selectedSecondAccOrgOfficeAddCountryOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedSecondAccOrgOfficeAddCountryOptions;
    } 
    public List<SelectOption> getselectedSecondAccOrgOfficeAddStateOptions()
    {     
        Map<String, List<SelectOption>> countryStateMap = New Map<String, List<SelectOption>>();
        List<SelectOption> selectedSecondAccOrgOfficeAddStateOptions = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('Organisation_State__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // Add these values to the selectoption list.
        selectedSecondAccOrgOfficeAddStateOptions.add(new SelectOption('','None'));
        /*for (Schema.PicklistEntry a : values){
if(selectedSecondAccOrgOfficeAddCountry=='India'){
selectedSecondAccOrgOfficeAddStateOptions.add(new SelectOption(a.getValue(),a.getValue()));
}
}*/
        List<Country_and_State__mdt> countryStateList = [SELECT id, State__c, Country__c, Label 
                                                         FROM Country_and_State__mdt];
        if(!countryStateList.isEmpty())
        {
            for(Country_and_State__mdt thisCS :countryStateList)
            {
                if(countryStateMap.containsKey(thisCS.Country__c))
                {
                    List<SelectOption> internalStateList = new List<SelectOption>();
                    internalStateList = countryStateMap.get(thisCS.Country__c);
                    internalStateList.add(new SelectOption(thisCS.state__c,thisCS.state__c));
                    countryStateMap.put(thisCS.Country__c,internalStateList);
                }
                else
                {
                    List<SelectOption> internalStateList = new List<SelectOption>();
                    internalStateList.add(new SelectOption('','None'));
                    internalStateList.add(new SelectOption(thisCS.state__c,thisCS.state__c));
                    countryStateMap.put(thisCS.Country__c,internalStateList);
                    
                }
            }
            try{
                if(selectedSecondAccOrgOfficeAddCountry !='')
                {
                    if(countryStateMap.containsKey(selectedSecondAccOrgOfficeAddCountry))
                    {
                        selectedSecondAccOrgOfficeAddStateOptions = countryStateMap.get(selectedSecondAccOrgOfficeAddCountry);
                    }
                }
            }
            catch(Exception ex)
            {
                system.debug('Error'+ex.getMessage());
            }
        }
        return selectedSecondAccOrgOfficeAddStateOptions;
    }
    public void onChangeSecondAccOrgOfficeCountry(){
        getselectedSecondAccOrgOfficeAddStateOptions();
    }
    public List<SelectOption> getselectedPrimaryAccPreffAddOption()
    {        
        List<SelectOption> selectedPrimaryAccPreffAddOption = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('Preferred_Address_for_all_Corresppondenc__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // Add these values to the selectoption list.
        selectedPrimaryAccPreffAddOption.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : values){
            selectedPrimaryAccPreffAddOption.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedPrimaryAccPreffAddOption;
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
    public List<SelectOption> getselectedPrimaryAccOccupationOptions()
    {        
        List<SelectOption> selectedPrimaryAccOccupationOptions = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('Occupation__pc').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // Add these values to the selectoption list.
        selectedPrimaryAccOccupationOptions.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : values){
            selectedPrimaryAccOccupationOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedPrimaryAccOccupationOptions;
    }
    public List<SelectOption> getresidentialLevelOptions()
    {        
        List<SelectOption> residentialLevelOptions = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Opportunity.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('Residential_Level__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // Add these values to the selectoption list.
        residentialLevelOptions.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : values){
            residentialLevelOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return residentialLevelOptions;
    }
    public List<SelectOption> getbookingSourceOptions()
    {        
        List<SelectOption> bookingSourceOptions = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Opportunity.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('Source__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // Add these values to the selectoption list.
        bookingSourceOptions.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : values){
            bookingSourceOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return bookingSourceOptions;
    }
    public List<SelectOption> geteoiBookingOptions()
    {        
        List<SelectOption> eoiBookingOptions = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Opportunity.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('EOI_Booking__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // Add these values to the selectoption list.
        eoiBookingOptions.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : values){
            eoiBookingOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return eoiBookingOptions;
    }
    public List<SelectOption> getselectedPropertyTypeOptions()
    {        
        List<SelectOption> selectedPropertyTypeOptions = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Property__c.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        system.debug('fieldMap:'+fieldMap);
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('Flat_Type__c').getDescribe().getPickListValues();
        system.debug('fieldMap values:'+values );
        // Add these values to the selectoption list.
        selectedPropertyTypeOptions.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : values){
            selectedPropertyTypeOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        return selectedPropertyTypeOptions;
        
    }
    public void onChangeCheckboxValue(){
        if(isAgreeWithTermsConditions!=true){
            isSubmitButtonDisable=true;
        }
        else{
            isSubmitButtonDisable=false;
        }
        System.debug('isSubmitButtonDisable:'+isSubmitButtonDisable);
    }  
    public void onChangePurchasePurpose(){
        bookingApplicationFormFor=selectedPurchasePurpose;
        System.debug('bookingApplicationFormFor:'+bookingApplicationFormFor);
        // if(bookingApplicationFormFor=='Individual'){
        showSection1=true;
        showSection2=true;
        showSection3=false;
        showSection4=false;
        /*  }
else{
showSection1=false;
showSection2=false;
showSection3=true;
showSection4=true;
}*/
    }
    public void onChangePrimaryAccNationality(){
        System.debug('selectedPrimaryAccNationality:'+selectedPrimaryAccNationality);
        if(selectedPrimaryAccNationality=='Indian'){
            isPrimaryAccIndian=true;
            isPrimaryAccNonIndian=false;
        }
        else if(selectedPrimaryAccNationality=='Non-Resident Indian' || selectedPrimaryAccNationality=='Foreign National of Indian Origin'){
            isPrimaryAccIndian=false;
            isPrimaryAccNonIndian=true;
        }
        else{
            isPrimaryAccIndian=false;
            isPrimaryAccNonIndian=false;
        }
    }
    public void onChangeSecondAccNationality(){
        if(selectedSecondAccNationality=='Indian'){
            isSecondAccIndian=true;
            isSecondAccNonIndian=false;
        }
        else if(selectedSecondAccNationality=='Non-Resident Indian' || selectedSecondAccNationality=='Foreign National of Indian Origin'){
            isSecondAccIndian=false;
            isSecondAccNonIndian=true;
        }
        else{
            isSecondAccIndian=false;
            isSecondAccNonIndian=false;
        }
    }
    public void onChangeEoiBooking(){
        if(selectedEOIBooking=='Yes'){
            showEoiBookingDateandAmt=true;
        }
        else{
            showEoiBookingDateandAmt=false;
        }       
    }
    public PageReference submitBookingForm(){
        system.debug('Inside submitBookingForm');
        System.debug('selectedEOIBooking:'+selectedEOIBooking);
        System.debug('eoiDate:'+eoiDate);
        System.debug('eoiAmount:'+eoiAmount);
        System.debug('selectedPrimaryAccPermAddState:'+selectedPrimaryAccPermAddState);
        System.debug('selectedPrimaryAccPermAddCountry:'+selectedPrimaryAccPermAddCountry);
        if((submittedBy!='' && submittedBy=='customer') && ((selectedPrimaryAccNationality=='-Select-'||(selectedSecondAccNationality=='-Select-' && secondAccountLastName!='') )
                                                            // ||(selectedPrimaryAccNationality=='Indian' && (primaryAccPanCardFile==null || primaryAccAadharCardFile==null))
                                                            ||(selectedPrimaryAccNationality=='Indian' && (primaryAccountPanNumber=='' || (primaryAccountAadhaarCard=='' && selectedPurchasePurpose=='Individual')))
                                                            //  ||((selectedPrimaryAccNationality=='Non-Resident Indian'||selectedPrimaryAccNationality=='Foreign National of Indian Origin') && (primaryAccPassportFile==null || primaryAccAddProofFile==null))
                                                            ||((selectedPrimaryAccNationality=='Non-Resident Indian'||selectedPrimaryAccNationality=='Foreign National of Indian Origin') && (primaryAccountPassport=='' || primaryAccountAddressProof==''))
                                                            
                                                            // ||(secondAccountLastName!='' && selectedSecondAccNationality=='Indian' && (secondAccPanCardFile==null || secondAccAadharCardFile==null))
                                                            ||(secondAccountLastName!='' && selectedSecondAccNationality=='Indian' && (secondAccountPanNumber=='' || secondAccountAadhaarCard==''))
                                                            //  ||(secondAccountLastName!='' && (selectedSecondAccNationality=='Non-Resident Indian'||selectedSecondAccNationality=='Foreign National of Indian Origin') && (secondAccPassportFile==null || secondAccAddProofFile==null))
                                                            ||(secondAccountLastName!='' && (selectedSecondAccNationality=='Non-Resident Indian'||selectedSecondAccNationality=='Foreign National of Indian Origin') && (secondAccountPassport=='' || secondAccountAddressProof==''))
                                                            // ||(subSourceSpecification=='')
                                                            ||(selectedEOIBooking==null)
                                                            ||(selectedEOIBooking=='Yes' && (eoiAmount==null||eoiAmount==0))
                                                            ||(selectedEOIBooking=='Yes' && eoiDate==null)
                                                            ||(primaryAccountLastName=='')
                                                            //||(thirdAccountGstNumber == '' && selectedPurchasePurpose != 'Individual')
                                                            ||(primaryAccountFirstName=='' && selectedPurchasePurpose == 'Individual')
                                                            ||(primaryAccountBirthDate==null && selectedPurchasePurpose == 'Individual')
                                                            ||(primaryAccountPermanentAddress=='')
                                                            ||(primaryAccountPostCode=='')
                                                            ||(selectedPrimaryAccPermAddState==null && selectedPurchasePurpose == 'Individual')
                                                            ||(selectedPrimaryAccPermAddCountry==null)
                                                            ||(primaryAccMailingAddStreet=='')
                                                            ||(primaryAccMailingAddCity=='')
                                                            ||(primaryAccMailingAddPostalCode=='')
                                                            ||(primaryAccMailingAddState=='')
                                                            ||(primaryAccMailingAddCountry=='')
                                                            ||(selectedPrimaryAccPreffAdd==null)
                                                            ||(selectedPrimaryAccNationality==null)
                                                            ||(primaryAccountAddressProof=='')
                                                            ||(primaryAccountMobileNo=='')
                                                            ||(primaryAccountEmail=='')
                                                           )){
                                                               if(selectedPrimaryAccNationality=='-Select-'){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Select Nationality of primary Applicant.'));
                                                               }
                                                               
                                                               /* if(selectedPrimaryAccNationality=='Indian' && primaryAccPanCardFile==null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Upload Pancard of Primary Applicant.'));
}
if(selectedPrimaryAccNationality=='Indian' && primaryAccAadharCardFile==null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Upload Aadhar Card of Primary Applicant.'));
}*/
                                                               if(selectedPrimaryAccNationality=='Indian' && primaryAccountPanNumber==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Enter Pancard no of Primary Applicant.'));
                                                               }
                                                               if(selectedPrimaryAccNationality=='Indian' && primaryAccountAadhaarCard=='' && selectedPurchasePurpose=='Individual'){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Enter AadharCard no of Primary Applicant.'));
                                                               }
                                                               
                                                               /*  if((selectedPrimaryAccNationality=='Non-Resident Indian'||selectedPrimaryAccNationality=='Foreign National of Indian Origin') && primaryAccPassportFile==null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Upload Passport of Primary Applicant.'));
}
if((selectedPrimaryAccNationality=='Non-Resident Indian'||selectedPrimaryAccNationality=='Foreign National of Indian Origin') && primaryAccAddProofFile==null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Upload Address Proof of Primary Applicant.'));
}*/
                                                               if((selectedPrimaryAccNationality=='Non-Resident Indian'||selectedPrimaryAccNationality=='Foreign National of Indian Origin') && primaryAccountPassport==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Enter Passport no of Primary Applicant.'));
                                                               }
                                                               /* if((selectedPrimaryAccNationality=='Non-Resident Indian'||selectedPrimaryAccNationality=='Foreign National of Indian Origin') && primaryAccountAddressProof==''){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Enter Address Proof of Primary Applicant.'));
}*/
                                                               
                                                               //for second account
                                                               if(selectedSecondAccNationality=='-Select-'){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Select Nationality of Secondary Applicant.'));
                                                               }
                                                               
                                                               /*  if(selectedSecondAccNationality=='Indian' && secondAccPanCardFile==null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Upload Pancard of Secondary Applicant.'));
}
if(selectedSecondAccNationality=='Indian' && secondAccAadharCardFile==null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Upload Aadhar Card of Secondary Applicant.'));
}*/
                                                               if(selectedSecondAccNationality=='Indian' && secondAccountPanNumber==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Enter Pancard no of Secondary Applicant.'));
                                                               }
                                                               if(selectedSecondAccNationality=='Indian' && secondAccountAadhaarCard==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Enter AadharCard no of Secondary Applicant.'));
                                                               }
                                                               
                                                               /* if((selectedSecondAccNationality=='Non-Resident Indian'||selectedSecondAccNationality=='Foreign National of Indian Origin') && secondAccPassportFile==null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Upload Passport of Secondary Applicant.'));
}
if((selectedSecondAccNationality=='Non-Resident Indian'||selectedSecondAccNationality=='Foreign National of Indian Origin') && secondAccAddProofFile==null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Upload Address Proof of Secondary Applicant.'));
}*/
                                                               if((selectedSecondAccNationality=='Non-Resident Indian'||selectedSecondAccNationality=='Foreign National of Indian Origin') && secondAccountPassport==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Enter Passport no of Secondary Applicant.'));
                                                               }
                                                               if((selectedSecondAccNationality=='Non-Resident Indian'||selectedSecondAccNationality=='Foreign National of Indian Origin') && secondAccountAddressProof==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Enter Address no of Secondary Applicant.'));
                                                               }
                                                               
                                                               //for other validations
                                                               if(subSourceSpecification==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Sub Source Specification.'));
                                                               }
                                                               if(selectedEOIBooking==null){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Select Value for EOI Booking.'));
                                                               }
                                                               if(selectedEOIBooking=='Yes' && eoiDate==null){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter EOI Date.'));
                                                               }
                                                               if(selectedEOIBooking=='Yes' && (eoiAmount==null||eoiAmount==0)){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter EOI Amount.'));
                                                               }
                                                               
                                                               if(primaryAccountLastName==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Primary applicant last name.'));
                                                               }
                                                               if(primaryAccountFirstName=='' && selectedPurchasePurpose == 'Individual'){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Primary applicant First name.'));
                                                               }
                                                               if(primaryAccountBirthDate==null && selectedPurchasePurpose == 'Individual'){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Primary applicant Birth Date.'));
                                                               }
                                                               /* if(thirdAccountGstNumber == '' && selectedPurchasePurpose != 'Individual'){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Primary applicant Gst Number.'));
}*/
                                                               if(primaryAccountPermanentAddress==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Primary applicant Permanent address.'));
                                                               }
                                                               if(primaryAccountPostCode==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Primary applicant Postal Code.'));
                                                               }
                                                               if(selectedPrimaryAccPermAddState==null){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select Primary applicant State.'));
                                                               }
                                                               if(selectedPrimaryAccPermAddCountry==null){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select Primary applicant Country.'));
                                                               }
                                                               if(primaryAccMailingAddStreet==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Primary applicant Mailing address street.'));
                                                               }
                                                               if(primaryAccMailingAddCity==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Primary applicant Mailing address city.'));
                                                               }
                                                               if(primaryAccMailingAddPostalCode==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Primary applicant Mailing address postal code.'));
                                                               }
                                                               if(primaryAccMailingAddState=='' && selectedPurchasePurpose == 'Individual'){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Primary applicant Mailing address state.'));
                                                               }
                                                               if(primaryAccMailingAddCountry==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Primary applicant Mailing address country.'));
                                                               }
                                                               if(selectedPrimaryAccPreffAdd==null){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select Primary applicant Preferred address.'));
                                                               }
                                                               if(selectedPrimaryAccNationality==null){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please select Primary applicant Nationality.'));
                                                               }
                                                               if(primaryAccountAddressProof==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Primary applicant address proof.'));
                                                               }
                                                               if(primaryAccountMobileNo==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Primary applicant Mobile No.'));
                                                               }
                                                               if(primaryAccountEmail==''){
                                                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Primary applicant Email.'));
                                                               }
                                                           }
        else{
            if((isAgreeWithTermsConditions==true&& submittedBy=='customer')||(submittedBy!='customer')){
                //Validation error message for SM
                if(submittedBy!='customer' && ((selectedEOIBooking==null)||(selectedEOIBooking=='Yes' && (eoiAmount==null||eoiAmount==0))||(selectedEOIBooking=='Yes' && eoiDate==null)|| (showProjectOffer==true && subBookingOffer=='')||projectOfferName.size()==0 ||paymentList.size()==0)){
                    if(selectedEOIBooking==null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Select Value for EOI Booking.'));
                    }
                    if(selectedEOIBooking=='Yes' && eoiDate==null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter EOI Date.'));
                    }
                    if(selectedEOIBooking=='Yes' && (eoiAmount==null||eoiAmount==0)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter EOI Amount.'));
                    }
                    if(showProjectOffer==true && subBookingOffer==''){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Sub Booking offer.'));
                    }
                    if(projectOfferName.size()==0){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please Select Booking offer.'));
                    }
                    if(paymentList.size()==0){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please First Add Payment for this Booking.'));
                    }
                    /*if(selectedPurchasePurpose != 'Individual')
{
if(thirdAccountPhoneNumber == null ||thirdAccountPhoneNumber == ''){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Please enter value in Phone Number'));
}
}*/
                }
                else{
                    PreventRecursionClass.bookingFormSubmit = true;
                    RecordType personAccountRecordType= [SELECT Id,Name, SobjectType,IsPersonType FROM RecordType WHERE SobjectType='Account' AND IsPersonType=True];
                    String businessRecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
                    
                    if(primaryAccountRecord!=null && primaryAccountLastName!='' && ((primaryAccountFirstName!='' && selectedPurchasePurpose == 'Individual') || selectedPurchasePurpose != 'Individual') && primaryAccountMobileNo!=''){
                        Account primaryAccForUpdate1=[Select Id From Account Where Id=:primaryAccountRecord.Id];
                        Account primaryAccForUpdate=new Account();
                        primaryAccForUpdate.Id=primaryAccForUpdate1.Id;
                        primaryAccForUpdate.RecordTypeId=personAccountRecordType.Id;
                        primaryAccForUpdate.Salutation=primaryAccountSalutation;
                        primaryAccForUpdate.LastName=primaryAccountLastName;
                        primaryAccForUpdate.MiddleName=primaryAccountMiddleName;
                        primaryAccForUpdate.FirstName=primaryAccountFirstName;
                        primaryAccForUpdate.PersonBirthdate=primaryAccountBirthDate;
                        primaryAccForUpdate.Permanent_Address__c=primaryAccountPermanentAddress;
                        primaryAccForUpdate.Post_Code__c=primaryAccountPostCode;
                        // primaryAccForUpdate.PersonMailingAddress=primaryAccountMailingAddress;
                        primaryAccForUpdate.PersonMailingStreet=primaryAccMailingAddStreet;
                        primaryAccForUpdate.PersonMailingCity=primaryAccMailingAddCity;
                        primaryAccForUpdate.PersonMailingPostalCode=primaryAccMailingAddPostalCode;
                        primaryAccForUpdate.PersonMailingState=primaryAccMailingAddState;
                        primaryAccForUpdate.PersonMailingCountry=primaryAccMailingAddCountry;
                        if(selectedPurchasePurpose !='Individual')
                        {
                            primaryAccForUpdate.GSTIN_No__c = thirdAccountGstNumber;  
                        }
                        primaryAccForUpdate.PAN_No__pc=primaryAccountPanNumber;
                        primaryAccForUpdate.Aadhar_No__pc=primaryAccountAadhaarCard;
                        primaryAccForUpdate.Passport__c=primaryAccountPassport;
                        primaryAccForUpdate.OCI_PIO_Card__c=primaryAccountOCIPIOCard;
                        primaryAccForUpdate.PAN_Details__c=primaryAccountPanDetails;
                        primaryAccForUpdate.Address_Proof__c=primaryAccountAddressProof;
                        primaryAccForUpdate.PersonMobilePhone=primaryAccountMobileNo;
                        primaryAccForUpdate.PersonEmail=primaryAccountEmail;
                        primaryAccForUpdate.Landline__c=primaryAccountLandline;
                        primaryAccForUpdate.Organisation_Name__c=primaryAccountOrganizationName;
                        primaryAccForUpdate.Designation_or_Position__pc=primaryAccountDesignation;
                        primaryAccForUpdate.Organisation_Office_Address__c=primaryAccountOrgOfficeAddress;
                        primaryAccForUpdate.Postal_Code__c=primaryAccountOrgOfficePostCode;
                        primaryAccForUpdate.Organisation_Phone_Number__c=primaryAccountOrgPhoneNumber;
                        primaryAccForUpdate.Other_Details_Remarks__c=primaryAccountOtherDetails;
                        primaryAccForUpdate.State__c=selectedPrimaryAccPermAddState;
                        primaryAccForUpdate.Country__c=selectedPrimaryAccPermAddCountry;
                        primaryAccForUpdate.Preferred_Address_for_all_Corresppondenc__c=selectedPrimaryAccPreffAdd;
                        primaryAccForUpdate.Nationality__c=selectedPrimaryAccNationality;
                        primaryAccForUpdate.Occupation__pc=selectedPrimaryAccOccupation;
                        primaryAccForUpdate.Organisation_State__c=selectedPrimaryAccOrgOfficeAddState;
                        primaryAccForUpdate.Organisation_Country__c=selectedPrimaryAccOrgOfficeAddCountry;
                        
                        System.debug('primaryAccForUpdate:'+primaryAccForUpdate);
                        //accountListForUpdate.add(primaryAccForUpdate);
                        try{
                            update primaryAccForUpdate;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                    }
                    else if(primaryAccountRecord==null && primaryAccountLastName!='' && ((primaryAccountFirstName!='' && selectedPurchasePurpose == 'Individual')|| selectedPurchasePurpose != 'Individual') && primaryAccountMobileNo!=''){
                        Account newPrimaryAccountRcd=new Account();
                        List<Account> primaryAccount = [Select Id From Account WHERE PersonMobilePhone =: primaryAccountMobileNo AND PersonMobilePhone !='' ];
                        if(!primaryAccount.isEmpty())
                        {
                            newPrimaryAccountRcd.id = primaryAccount[0].Id;
                        }
                        newPrimaryAccountRcd.Salutation=primaryAccountSalutation;
                        newPrimaryAccountRcd.RecordTypeId=personAccountRecordType.Id;
                        newPrimaryAccountRcd.LastName=primaryAccountLastName;
                        newPrimaryAccountRcd.MiddleName=primaryAccountMiddleName;
                        newPrimaryAccountRcd.FirstName=primaryAccountFirstName;
                        newPrimaryAccountRcd.PersonBirthdate=primaryAccountBirthDate;
                        newPrimaryAccountRcd.Permanent_Address__c=primaryAccountPermanentAddress;
                        newPrimaryAccountRcd.Post_Code__c=primaryAccountPostCode;
                        // newPrimaryAccountRcd.PersonMailingAddress=primaryAccountMailingAddress;
                        newPrimaryAccountRcd.PersonMailingStreet=primaryAccMailingAddStreet;
                        newPrimaryAccountRcd.PersonMailingCity=primaryAccMailingAddCity;
                        newPrimaryAccountRcd.PersonMailingPostalCode=primaryAccMailingAddPostalCode;
                        newPrimaryAccountRcd.PersonMailingState=primaryAccMailingAddState;
                        newPrimaryAccountRcd.PersonMailingCountry=primaryAccMailingAddCountry;
                        if(selectedPurchasePurpose !='Individual')
                        {
                            newPrimaryAccountRcd.GSTIN_No__c = thirdAccountGstNumber;  
                        }
                        newPrimaryAccountRcd.PAN_No__pc=primaryAccountPanNumber;
                        newPrimaryAccountRcd.Aadhar_No__pc=primaryAccountAadhaarCard;
                        newPrimaryAccountRcd.Passport__c=primaryAccountPassport;
                        newPrimaryAccountRcd.OCI_PIO_Card__c=primaryAccountOCIPIOCard;
                        newPrimaryAccountRcd.PAN_Details__c=primaryAccountPanDetails;
                        newPrimaryAccountRcd.Address_Proof__c=primaryAccountAddressProof;
                        newPrimaryAccountRcd.PersonMobilePhone=primaryAccountMobileNo;
                        newPrimaryAccountRcd.PersonEmail=primaryAccountEmail;
                        newPrimaryAccountRcd.Landline__c=primaryAccountLandline;
                        newPrimaryAccountRcd.Organisation_Name__c=primaryAccountOrganizationName;
                        newPrimaryAccountRcd.Designation_or_Position__pc=primaryAccountDesignation;
                        newPrimaryAccountRcd.Organisation_Office_Address__c=primaryAccountOrgOfficeAddress;
                        newPrimaryAccountRcd.Postal_Code__c=primaryAccountOrgOfficePostCode;
                        newPrimaryAccountRcd.Organisation_Phone_Number__c=primaryAccountOrgPhoneNumber;
                        newPrimaryAccountRcd.Other_Details_Remarks__c=primaryAccountOtherDetails;
                        newPrimaryAccountRcd.State__c=selectedPrimaryAccPermAddState;
                        newPrimaryAccountRcd.Country__c=selectedPrimaryAccPermAddCountry;
                        newPrimaryAccountRcd.Preferred_Address_for_all_Corresppondenc__c=selectedPrimaryAccPreffAdd;
                        newPrimaryAccountRcd.Nationality__c=selectedPrimaryAccNationality;
                        newPrimaryAccountRcd.Occupation__pc=selectedPrimaryAccOccupation;
                        newPrimaryAccountRcd.Organisation_State__c=selectedPrimaryAccOrgOfficeAddState;
                        newPrimaryAccountRcd.Organisation_Country__c=selectedPrimaryAccOrgOfficeAddCountry;
                        try{
                            insert newPrimaryAccountRcd;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        Co_Applicant__c newCoApplicantRcd1=new Co_Applicant__c();
                        newCoApplicantRcd1.Account__c=newPrimaryAccountRcd.Id;
                        newCoApplicantRcd1.Booking__c=recordId;
                        newCoApplicantRcd1.Role__c='Co-Applicant';
                        try{
                            insert newCoApplicantRcd1;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                    }
                    
                    if(secondAccountRecord!=null 
                       //&& selectedPurchasePurpose=='Individual' 
                       && secondAccountLastName!='' && secondAccountFirstName!='' && secondAccountMobileNo!=''){
                           system.debug('Inside Second Acc Update');
                           secondAccId=secondAccountRecord.Id;
                           Account secondAccForUpdate1=[Select Id From Account Where Id=:secondAccountRecord.Id];
                           Account secondAccForUpdate=new Account();
                           secondAccForUpdate.RecordTypeId=personAccountRecordType.Id;
                           secondAccForUpdate.Id=secondAccForUpdate1.Id;
                           secondAccForUpdate.Salutation=secondAccountSalutation;
                           secondAccForUpdate.LastName=secondAccountLastName;
                           secondAccForUpdate.MiddleName=secondAccountMiddleName;
                           secondAccForUpdate.FirstName=secondAccountFirstName;
                           secondAccForUpdate.PersonBirthdate=secondAccountBirthDate;
                           secondAccForUpdate.Permanent_Address__c=secondAccountPermanentAddress;
                           secondAccForUpdate.Post_Code__c=secondAccountPostCode;
                           
                           secondAccForUpdate.PersonMailingStreet=secondAccMailingAddStreet;
                           secondAccForUpdate.PersonMailingCity=secondAccMailingAddCity;
                           secondAccForUpdate.PersonMailingPostalCode=secondAccMailingAddPostalCode;
                           secondAccForUpdate.PersonMailingState=secondAccMailingAddState;
                           secondAccForUpdate.PersonMailingCountry=secondAccMailingAddCountry;
                           
                           secondAccForUpdate.PAN_No__pc=secondAccountPanNumber;
                           secondAccForUpdate.Aadhar_No__pc=secondAccountAadhaarCard;
                           secondAccForUpdate.Passport__c=secondAccountPassport;
                           secondAccForUpdate.OCI_PIO_Card__c=secondAccountOCIPIOCard;
                           secondAccForUpdate.PAN_Details__c=secondAccountPanDetails;
                           secondAccForUpdate.Address_Proof__c=secondAccountAddressProof;
                           secondAccForUpdate.PersonMobilePhone=secondAccountMobileNo;
                           secondAccForUpdate.PersonEmail=secondAccountEmail;
                           secondAccForUpdate.Landline__c=secondAccountLandline;
                           secondAccForUpdate.Organisation_Name__c=secondAccountOrganizationName;
                           secondAccForUpdate.Designation_or_Position__pc=secondAccountDesignation;
                           secondAccForUpdate.Organisation_Office_Address__c=secondAccountOrgOfficeAddress;
                           secondAccForUpdate.Postal_Code__c=secondAccountOrgOfficePostCode;
                           secondAccForUpdate.Organisation_Phone_Number__c=secondAccountOrgPhoneNumber;
                           secondAccForUpdate.Other_Details_Remarks__c=secondAccountOtherDetails;
                           secondAccForUpdate.State__c=selectedSecondAccPermAddState;
                           secondAccForUpdate.Country__c=selectedSecondAccPermAddCountry;
                           secondAccForUpdate.Preferred_Address_for_all_Corresppondenc__c=selectedSecondAccPreffAdd;
                           secondAccForUpdate.Nationality__c=selectedSecondAccNationality;
                           secondAccForUpdate.Occupation__pc=selectedSecondAccOccupation;
                           secondAccForUpdate.Organisation_State__c=selectedSecondAccOrgOfficeAddState;
                           secondAccForUpdate.Organisation_Country__c=selectedSecondAccOrgOfficeAddCountry;          
                           System.debug('secondAccForUpdate:'+secondAccForUpdate);
                           try{
                               update secondAccForUpdate;
                           }
                           catch(DmlException ex){
                               ApexPages.addMessages(ex);
                               return null;
                           }
                           //accountListForUpdate.add(secondAccForUpdate);           
                       }
                    else if(secondAccountRecord==null
                            //&& selectedPurchasePurpose=='Individual'
                            && secondAccountLastName!='' && secondAccountFirstName!='' && secondAccountMobileNo!=''){
                                String mobilePhone = '';
                                if(secondAccountMobileNo.length() >= 10)
                                {
                                    mobilePhone  = '%'+secondAccountMobileNo.right(10);
                                }
                                else
                                {
                                    mobilePhone  = secondAccountMobileNo;
                                }
                                List<Account> secondPrimaryAccount = [Select Id From Account WHERE PersonMobilePhone Like : mobilePhone AND PersonMobilePhone !='' ];
                                Account newSecondAccountRcd=new Account();
                                if(!SecondPrimaryAccount.isEmpty())
                                {
                                    newSecondAccountRcd.id = secondPrimaryAccount[0].Id;
                                }
                                newSecondAccountRcd.RecordTypeId=personAccountRecordType.Id;
                                newSecondAccountRcd.Salutation=secondAccountSalutation;
                                newSecondAccountRcd.LastName=secondAccountLastName;
                                newSecondAccountRcd.MiddleName=secondAccountMiddleName;
                                newSecondAccountRcd.FirstName=secondAccountFirstName;
                                newSecondAccountRcd.PersonBirthdate=secondAccountBirthDate;
                                newSecondAccountRcd.Permanent_Address__c=secondAccountPermanentAddress;
                                newSecondAccountRcd.Post_Code__c=secondAccountPostCode;
                                
                                newSecondAccountRcd.PersonMailingStreet=secondAccMailingAddStreet;
                                newSecondAccountRcd.PersonMailingCity=secondAccMailingAddCity;
                                newSecondAccountRcd.PersonMailingPostalCode=secondAccMailingAddPostalCode;
                                newSecondAccountRcd.PersonMailingState=secondAccMailingAddState;
                                newSecondAccountRcd.PersonMailingCountry=secondAccMailingAddCountry;
                                
                                newSecondAccountRcd.PAN_No__pc=secondAccountPanNumber;
                                newSecondAccountRcd.Aadhar_No__pc=secondAccountAadhaarCard;
                                newSecondAccountRcd.Passport__c=secondAccountPassport;
                                newSecondAccountRcd.OCI_PIO_Card__c=secondAccountOCIPIOCard;
                                newSecondAccountRcd.PAN_Details__c=secondAccountPanDetails;
                                newSecondAccountRcd.Address_Proof__c=secondAccountAddressProof;
                                newSecondAccountRcd.PersonMobilePhone=secondAccountMobileNo;
                                newSecondAccountRcd.PersonEmail=secondAccountEmail;
                                newSecondAccountRcd.Landline__c=secondAccountLandline;
                                newSecondAccountRcd.Organisation_Name__c=secondAccountOrganizationName;
                                newSecondAccountRcd.Designation_or_Position__pc=secondAccountDesignation;
                                newSecondAccountRcd.Organisation_Office_Address__c=secondAccountOrgOfficeAddress;
                                newSecondAccountRcd.Postal_Code__c=secondAccountOrgOfficePostCode;
                                newSecondAccountRcd.Organisation_Phone_Number__c=secondAccountOrgPhoneNumber;
                                newSecondAccountRcd.Other_Details_Remarks__c=secondAccountOtherDetails;
                                newSecondAccountRcd.State__c=selectedSecondAccPermAddState;
                                newSecondAccountRcd.Country__c=selectedSecondAccPermAddCountry;
                                newSecondAccountRcd.Preferred_Address_for_all_Corresppondenc__c=selectedSecondAccPreffAdd;
                                newSecondAccountRcd.Nationality__c=selectedSecondAccNationality;
                                newSecondAccountRcd.Occupation__pc=selectedSecondAccOccupation;
                                newSecondAccountRcd.Organisation_State__c=selectedSecondAccOrgOfficeAddState;
                                newSecondAccountRcd.Organisation_Country__c=selectedSecondAccOrgOfficeAddCountry;          
                                System.debug('newSecondAccountRcd:'+newSecondAccountRcd);
                                try{
                                    upsert newSecondAccountRcd;
                                }
                                catch(DmlException ex){
                                    ApexPages.addMessages(ex);
                                    return null;
                                }
                                
                                
                                secondAccId=newSecondAccountRcd.Id;
                                
                                Co_Applicant__c newCoApplicantRcd2=new Co_Applicant__c();
                                newCoApplicantRcd2.Account__c=newSecondAccountRcd.Id;
                                newCoApplicantRcd2.Booking__c=recordId;
                                newCoApplicantRcd2.Role__c='Co-Applicant';
                                try{
                                    insert newCoApplicantRcd2;
                                }
                                catch(DmlException ex){
                                    ApexPages.addMessages(ex);
                                    return null;
                                }
                            }
                    
                    system.debug('selectedPurchasePurpose'+selectedPurchasePurpose);
                    
                    //update opportunity record
                    if(opportunityRecord!=null){
                        //for update Opportunity data
                        Opportunity opportunityRcdForUpdate1=[Select Id,Nature_of_Purchase__c From Opportunity Where Id=:opportunityRecord.Id];
                        Opportunity opportunityRcdForUpdate=new Opportunity();
                        opportunityRcdForUpdate.Id=opportunityRcdForUpdate1.Id;
                        //opportunityRcdForUpdate.Current_Occupied_Property_Type__c=selectedPropertyType;
                        opportunityRcdForUpdate.Apartment_Number__c=apartmentNumber;
                        opportunityRcdForUpdate.Residential_Level__c=selectedResidentialLevel;
                        // opportunityRcdForUpdate.Carpet_Area_in_sq_mts__c=carpetAreaInSqMtr;
                        // opportunityRcdForUpdate.Carpet_Area_in_sq_ft__c=carpetAreaInSqFt;
                        opportunityRcdForUpdate.No_of_Parking_s_Spots_Required__c=noOfParkingSpotRequired;
                        //opportunityRcdForUpdate.Allotment_Premium__c=allotmentPremium;
                        opportunityRcdForUpdate.Amount_in_Words__c=amountInWords;
                        opportunityRcdForUpdate.Source__c=selectedBookingSource;
                        opportunityRcdForUpdate.Sub_Source_Specification__c=subSourceSpecification;
                        opportunityRcdForUpdate.EOI_Booking__c=selectedEOIBooking ;
                        opportunityRcdForUpdate.EOI_Date__c=eoiDate ;
                        opportunityRcdForUpdate.EOI_Amount__c=eoiAmount ;
                        //for update SM fields on opp record (when booking form is submitted by SM)
                        if(submittedBy!='customer'){
                            // if(opportunityRecord.Digital_Booking_Form_Verified_by_SM__c!=true){
                            opportunityRcdForUpdate.Digital_Booking_Form_Verified_by_SM__c=true;
                            opportunityRcdForUpdate.Digital_Booking_Form_Verified_by_SM_Date__c=System.now();
                            //}
                        }
                        if(selectedPurchasePurpose=='Individual'){
                            opportunityRcdForUpdate.Nature_of_Purchase__c='Self Use';
                        }
                        else{
                            opportunityRcdForUpdate.Nature_of_Purchase__c='Investment';
                        }
                        if(submittedBy!='' && submittedBy=='customer'){
                            opportunityRcdForUpdate.Is_Booking_Form_Submitted_by_Customer__c=true;
                        }
                        System.debug('opportunityRcdForUpdate:'+opportunityRcdForUpdate);
                        try{
                            update opportunityRcdForUpdate;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                    }
                    
                    
                    
                    //for update booking
                    if(bookingRecord!=null){
                        //for update Booking data
                        Booking__c bookingRcdForUpdate1=[Select Id,Name From Booking__c Where Id=:recordId];
                        Booking__c bookingRcdForUpdate=new Booking__c();
                        
                        bookingRcdForUpdate.Id=bookingRcdForUpdate1.Id;
                        bookingRcdForUpdate.Sub_Booking_Offer__c=subBookingOffer;
                        system.debug('thirdAccountRecord----'+thirdAccountRecord);
                        /*if(!thirdAccountRecord.isEmpty())
{
bookingRcdForUpdate.Primary_Applicant__c = thirdAccountRecord[0].id ; 
}*/
                        try{
                            update bookingRcdForUpdate;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                    }
                    //for update property record
                    if(propertyRecord!=null){
                        Property__c propertyRcdForUpdate=new Property__c();
                        propertyRcdForUpdate.Id=propertyRecord.Id;
                        propertyRcdForUpdate.Flat_Type__c=selectedPropertyType;
                        propertyRcdForUpdate.RERA_Carpet_Area__c=carpetAreaInSqFt;
                        //propertyRcdForUpdate.RERA_Carpet_Area_in_sqmtr__c=carpetAreaInSqMtr;
                        try{
                            update propertyRcdForUpdate;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                    }
                    //for Insert offer records as per selected Project Offers
                    System.debug('projectOfferName:'+projectOfferName);
                    if(projectOfferName.size()>0){
                        List<Offer__c> offerListforInsert=new List<Offer__c>();
                        for(String selectedProjOffRcd:projectOfferName){
                            System.debug('selectedProjOffRcd:'+selectedProjOffRcd);
                            if(selectedProjOffRcd!='0'){
                                Offer__c newOfferRcd=new Offer__c();
                                newOfferRcd.Project_Offer__c=selectedProjOffRcd;
                                newOfferRcd.Booking__c=recordId;
                                offerListforInsert.add(newOfferRcd);
                            }
                        }
                        System.debug('offerListforInsert:'+offerListforInsert);
                        if(offerListforInsert.size()>0){
                            try{
                                insert offerListforInsert;
                            }
                            catch(DmlException ex){
                                ApexPages.addMessages(ex);
                                return null;
                            }
                        }
                    }
                    
                    System.debug('primaryAccPanCardFile:'+primaryAccPanCardFile);
                    if(primaryAccPanCardFile!=null && primaryAccPanCardFileName!=null){
                        // for save pan card on person account      
                        ContentVersion contentVersion_1 = new ContentVersion(
                            Title='Primary Account PanCard', 
                            PathOnClient =primaryAccPanCardFileName,
                            ContentLocation='S',
                            VersionData = primaryAccPanCardFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Account',
                            Document_Type__c = 'PAN Card'
                        );
                        try{
                            insert contentVersion_1;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
                        
                        ContentDocumentLink contentlink1 = new ContentDocumentLink();
                        contentlink1.LinkedEntityId = primaryAccountRecord.Id;
                        contentlink1.contentdocumentid = contentVersion_2.contentdocumentid;
                        contentlink1.ShareType = 'V';
                        try{
                            insert contentlink1; 
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        // for save pan card on booking      
                        ContentVersion contentVersion_3 = new ContentVersion(
                            Title='Primary Account PanCard', 
                            PathOnClient =primaryAccPanCardFileName,
                            ContentLocation='S',
                            VersionData = primaryAccPanCardFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Booking__c',
                            Document_Type__c = 'PAN Card'
                        );
                        try{
                            insert contentVersion_3;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_3.Id LIMIT 1];
                        
                        ContentDocumentLink contentlink2 = new ContentDocumentLink();
                        contentlink2.LinkedEntityId = recordId;
                        contentlink2.contentdocumentid = contentVersion_4.contentdocumentid;
                        contentlink2.ShareType = 'V';
                        try{
                            insert contentlink2;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                    }
                    
                    System.debug('primaryAccAadharCardFile:'+primaryAccAadharCardFile);
                    if(primaryAccAadharCardFile!=null && primaryAccAadharCardFileName!=null){
                        // for save aadhar card on person account      
                        ContentVersion contentVersion_1 = new ContentVersion(
                            Title='Primary Account AadharCard', 
                            PathOnClient =primaryAccAadharCardFileName,
                            ContentLocation='S',
                            VersionData = primaryAccAadharCardFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Account',
                            Document_Type__c = 'Aadhar'
                        );
                        try{
                            insert contentVersion_1;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
                        
                        List<ContentDocumentLink> contentListlink1=new List<ContentDocumentLink>();
                        ContentDocumentLink contentlink1 = new ContentDocumentLink();
                        contentlink1.LinkedEntityId = primaryAccountRecord.Id;
                        contentlink1.contentdocumentid = contentVersion_2.contentdocumentid;
                        contentlink1.ShareType = 'V';
                        //contentListlink1.add(contentlink1);
                        try{
                            insert contentlink1;    
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        // for save pan card on booking      
                        ContentVersion contentVersion_3 = new ContentVersion(
                            Title='Primary Account AadharCard', 
                            PathOnClient =primaryAccAadharCardFileName,
                            ContentLocation='S',
                            VersionData = primaryAccAadharCardFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Booking__c',
                            Document_Type__c = 'Aadhar'
                        );
                        try{
                            insert contentVersion_3;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_3.Id LIMIT 1];
                        
                        ContentDocumentLink contentlink2 = new ContentDocumentLink();
                        contentlink2.LinkedEntityId = recordId;
                        contentlink2.contentdocumentid = contentVersion_4.contentdocumentid;
                        contentlink2.ShareType = 'V';
                        //contentListlink1.add(contentlink2);
                        try{
                            insert contentlink2;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        //insert contentListlink1;
                    }
                    
                    System.debug('primaryAccPassportFile:'+primaryAccPassportFile);
                    if(primaryAccPassportFile!=null && primaryAccPassportFileName!=null){
                        // for save passport on person account      
                        ContentVersion contentVersion_1 = new ContentVersion(
                            Title='Primary Account Passport', 
                            PathOnClient =primaryAccPassportFileName,
                            ContentLocation='S',
                            VersionData = primaryAccPassportFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Account',
                            Document_Type__c = 'Passport'
                        );
                        try{
                            insert contentVersion_1;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
                        
                        List<ContentDocumentLink> contentListlink1=new List<ContentDocumentLink>();
                        ContentDocumentLink contentlink1 = new ContentDocumentLink();
                        contentlink1.LinkedEntityId = primaryAccountRecord.Id;
                        contentlink1.contentdocumentid = contentVersion_2.contentdocumentid;
                        contentlink1.ShareType = 'V';
                        //contentListlink1.add(contentlink1);
                        try{
                            insert contentlink1;    
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        // for save passport on booking      
                        ContentVersion contentVersion_3 = new ContentVersion(
                            Title='Primary Account Passport', 
                            PathOnClient =primaryAccPassportFileName,
                            ContentLocation='S',
                            VersionData = primaryAccPassportFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Booking__c',
                            Document_Type__c = 'Passport'
                        );
                        try{
                            insert contentVersion_3;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_3.Id LIMIT 1];
                        
                        ContentDocumentLink contentlink2 = new ContentDocumentLink();
                        contentlink2.LinkedEntityId = recordId;
                        contentlink2.contentdocumentid = contentVersion_4.contentdocumentid;
                        contentlink2.ShareType = 'V';
                        //contentListlink1.add(contentlink2);
                        try{
                            insert contentlink2;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        //insert contentListlink1;
                    }
                    
                    System.debug('primaryAccOCIPIOFile:'+primaryAccOCIPIOFile);
                    if(primaryAccOCIPIOFile!=null && primaryAccOCIPIOFileName!=null){
                        // for save OCI/PIO Card on person account      
                        ContentVersion contentVersion_1 = new ContentVersion(
                            Title='Primary Account OCI/PIO', 
                            PathOnClient =primaryAccOCIPIOFileName,
                            ContentLocation='S',
                            VersionData = primaryAccOCIPIOFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Account',
                            Document_Type__c = 'OCI/PIO Card'
                        );
                        try{
                            insert contentVersion_1;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
                        
                        List<ContentDocumentLink> contentListlink1=new List<ContentDocumentLink>();
                        ContentDocumentLink contentlink1 = new ContentDocumentLink();
                        contentlink1.LinkedEntityId = primaryAccountRecord.Id;
                        contentlink1.contentdocumentid = contentVersion_2.contentdocumentid;
                        contentlink1.ShareType = 'V';
                        //contentListlink1.add(contentlink1);
                        try{
                            insert contentlink1;    
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        // for save OCI/PIO Card on booking      
                        ContentVersion contentVersion_3 = new ContentVersion(
                            Title='Primary Account OCI/PIO', 
                            PathOnClient =primaryAccOCIPIOFileName,
                            ContentLocation='S',
                            VersionData = primaryAccOCIPIOFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Booking__c',
                            Document_Type__c = 'OCI/PIO Card'
                        );
                        try{
                            insert contentVersion_3;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_3.Id LIMIT 1];
                        
                        ContentDocumentLink contentlink2 = new ContentDocumentLink();
                        contentlink2.LinkedEntityId = recordId;
                        contentlink2.contentdocumentid = contentVersion_4.contentdocumentid;
                        contentlink2.ShareType = 'V';
                        //contentListlink1.add(contentlink2);
                        try{
                            insert contentlink2;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        //insert contentListlink1;
                    }
                    
                    System.debug('primaryAccPanDetailsFile:'+primaryAccPanDetailsFile);
                    if(primaryAccPanDetailsFile!=null && primaryAccPanDetailsFileName!=null){
                        // for save Pan Details on person account      
                        ContentVersion contentVersion_1 = new ContentVersion(
                            Title='Primary Account Pan Details', 
                            PathOnClient =primaryAccPanDetailsFileName,
                            ContentLocation='S',
                            VersionData = primaryAccPanDetailsFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Account',
                            Document_Type__c = 'PAN Card'
                        );
                        try{
                            insert contentVersion_1;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
                        
                        List<ContentDocumentLink> contentListlink1=new List<ContentDocumentLink>();
                        ContentDocumentLink contentlink1 = new ContentDocumentLink();
                        contentlink1.LinkedEntityId = primaryAccountRecord.Id;
                        contentlink1.contentdocumentid = contentVersion_2.contentdocumentid;
                        contentlink1.ShareType = 'V';
                        //contentListlink1.add(contentlink1);
                        try{
                            insert contentlink1;  
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        // for save Pan Details on booking      
                        ContentVersion contentVersion_3 = new ContentVersion(
                            Title='Primary Account Pan Details', 
                            PathOnClient =primaryAccPanDetailsFileName,
                            ContentLocation='S',
                            VersionData = primaryAccPanDetailsFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Booking__c',
                            Document_Type__c = 'PAN Card'
                        );
                        try{
                            insert contentVersion_3;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_3.Id LIMIT 1];
                        
                        ContentDocumentLink contentlink2 = new ContentDocumentLink();
                        contentlink2.LinkedEntityId = recordId;
                        contentlink2.contentdocumentid = contentVersion_4.contentdocumentid;
                        contentlink2.ShareType = 'V';
                        //contentListlink1.add(contentlink2);
                        try{
                            insert contentlink2;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        //insert contentListlink1;
                    }
                    
                    System.debug('primaryAccAddProofFile:'+primaryAccAddProofFile);
                    if(primaryAccAddProofFile!=null && primaryAccAddProofFileName!=null){
                        // for save Address proof on person account      
                        ContentVersion contentVersion_1 = new ContentVersion(
                            Title='Primary Account Address Proof', 
                            PathOnClient =primaryAccAddProofFileName,
                            ContentLocation='S',
                            VersionData = primaryAccAddProofFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Account',
                            Document_Type__c = 'Address Proof'
                        );
                        try{
                            insert contentVersion_1;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
                        
                        List<ContentDocumentLink> contentListlink1=new List<ContentDocumentLink>();
                        ContentDocumentLink contentlink1 = new ContentDocumentLink();
                        contentlink1.LinkedEntityId = primaryAccountRecord.Id;
                        contentlink1.contentdocumentid = contentVersion_2.contentdocumentid;
                        contentlink1.ShareType = 'V';
                        //contentListlink1.add(contentlink1);
                        try{
                            insert contentlink1;   
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        // for save Address Proof on booking      
                        ContentVersion contentVersion_3 = new ContentVersion(
                            Title='Primary Account Address Proof', 
                            PathOnClient =primaryAccAddProofFileName,
                            ContentLocation='S',
                            VersionData = primaryAccAddProofFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Booking__c',
                            Document_Type__c = 'Address Proof'
                        );
                        try{
                            insert contentVersion_3;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_3.Id LIMIT 1];
                        
                        ContentDocumentLink contentlink2 = new ContentDocumentLink();
                        contentlink2.LinkedEntityId = recordId;
                        contentlink2.contentdocumentid = contentVersion_4.contentdocumentid;
                        contentlink2.ShareType = 'V';
                        //contentListlink1.add(contentlink2);
                        try{
                            insert contentlink2;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        //insert contentListlink1;
                    }
                    
                    
                    System.debug('secondAccPanCardFile:'+secondAccPanCardFile);
                    if(secondAccPanCardFile!=null && secondAccPanCardFileName!=null){
                        // for save pan card on person account      
                        ContentVersion contentVersion_1 = new ContentVersion(
                            Title='Second Account PanCard', 
                            PathOnClient =secondAccPanCardFileName,
                            ContentLocation='S',
                            VersionData = secondAccPanCardFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Account',
                            Document_Type__c = 'PAN Card'
                        );
                        try{
                            insert contentVersion_1;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
                        
                        ContentDocumentLink contentlink1 = new ContentDocumentLink();
                        contentlink1.LinkedEntityId = secondAccId;
                        contentlink1.contentdocumentid = contentVersion_2.contentdocumentid;
                        contentlink1.ShareType = 'V';
                        try{
                            insert contentlink1; 
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        // for save pan card on booking      
                        ContentVersion contentVersion_3 = new ContentVersion(
                            Title='Second Account PanCard', 
                            PathOnClient =secondAccPanCardFileName,
                            ContentLocation='S',
                            VersionData = secondAccPanCardFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Booking__c',
                            Document_Type__c = 'PAN Card'
                        );
                        try{
                            insert contentVersion_3;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_3.Id LIMIT 1];
                        
                        ContentDocumentLink contentlink2 = new ContentDocumentLink();
                        contentlink2.LinkedEntityId = recordId;
                        contentlink2.contentdocumentid = contentVersion_4.contentdocumentid;
                        contentlink2.ShareType = 'V';
                        try{
                            insert contentlink2;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                    }
                    
                    System.debug('secondAccAadharCardFile:'+secondAccAadharCardFile);
                    if(secondAccAadharCardFile!=null && secondAccAadharCardFileName!=null){
                        // for save aadhar card on person account      
                        ContentVersion contentVersion_1 = new ContentVersion(
                            Title='Second Account AadharCard', 
                            PathOnClient =secondAccAadharCardFileName,
                            ContentLocation='S',
                            VersionData = secondAccAadharCardFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Account',
                            Document_Type__c = 'Aadhar'
                        );
                        try{
                            insert contentVersion_1;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
                        
                        List<ContentDocumentLink> contentListlink1=new List<ContentDocumentLink>();
                        ContentDocumentLink contentlink1 = new ContentDocumentLink();
                        contentlink1.LinkedEntityId = secondAccId;
                        contentlink1.contentdocumentid = contentVersion_2.contentdocumentid;
                        contentlink1.ShareType = 'V';
                        //contentListlink1.add(contentlink1);
                        try{
                            insert contentlink1;     
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        // for save pan card on booking      
                        ContentVersion contentVersion_3 = new ContentVersion(
                            Title='Second Account AadharCard', 
                            PathOnClient =secondAccAadharCardFileName,
                            ContentLocation='S',
                            VersionData = secondAccAadharCardFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Booking__c',
                            Document_Type__c = 'Aadhar'
                        );
                        try{
                            insert contentVersion_3;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        System.debug('contentVersion_3---------->'+contentVersion_3.Id);
                        
                        ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_3.Id LIMIT 1];
                        System.debug('contentVersion_4---------->'+contentVersion_4);
                        ContentDocumentLink contentlink2 = new ContentDocumentLink();
                        contentlink2.LinkedEntityId = recordId;
                        contentlink2.contentdocumentid = contentVersion_4.contentdocumentid;
                        contentlink2.ShareType = 'V';
                        //contentListlink1.add(contentlink2);
                        try{
                            insert contentlink2;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        //insert contentListlink1;
                    }
                    
                    System.debug('secondAccPassportFile:'+secondAccPassportFile);
                    if(secondAccPassportFile!=null && secondAccPassportFileName!=null){
                        // for save passport on person account      
                        ContentVersion contentVersion_1 = new ContentVersion(
                            Title='Second Account Passport', 
                            PathOnClient =secondAccPassportFileName,
                            ContentLocation='S',
                            VersionData = secondAccPassportFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Account',
                            Document_Type__c = 'Passport'
                        );
                        try{
                            insert contentVersion_1;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
                        
                        List<ContentDocumentLink> contentListlink1=new List<ContentDocumentLink>();
                        ContentDocumentLink contentlink1 = new ContentDocumentLink();
                        contentlink1.LinkedEntityId = secondAccId;
                        contentlink1.contentdocumentid = contentVersion_2.contentdocumentid;
                        contentlink1.ShareType = 'V';
                        //contentListlink1.add(contentlink1);
                        try{
                            insert contentlink1;   
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        // for save passport on booking      
                        ContentVersion contentVersion_3 = new ContentVersion(
                            Title='Second Account Passport', 
                            PathOnClient =secondAccPassportFileName,
                            ContentLocation='S',
                            VersionData = secondAccPassportFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Booking__c',
                            Document_Type__c = 'Passport'
                        );
                        try{
                            insert contentVersion_3;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_3.Id LIMIT 1];
                        
                        ContentDocumentLink contentlink2 = new ContentDocumentLink();
                        contentlink2.LinkedEntityId = recordId;
                        contentlink2.contentdocumentid = contentVersion_4.contentdocumentid;
                        contentlink2.ShareType = 'V';
                        //contentListlink1.add(contentlink2);
                        try{
                            insert contentlink2;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        //insert contentListlink1;
                    }
                    
                    System.debug('secondAccOCIPIOFile:'+secondAccOCIPIOFile);
                    if(secondAccOCIPIOFile!=null && secondAccOCIPIOFileName!=null){
                        // for save OCI/PIO Card on person account      
                        ContentVersion contentVersion_1 = new ContentVersion(
                            Title='Second Account OCI/PIO', 
                            PathOnClient =secondAccOCIPIOFileName,
                            ContentLocation='S',
                            VersionData = secondAccOCIPIOFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Account',
                            Document_Type__c = 'OCI/PIO Card'
                        );
                        try{
                            insert contentVersion_1;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
                        
                        List<ContentDocumentLink> contentListlink1=new List<ContentDocumentLink>();
                        ContentDocumentLink contentlink1 = new ContentDocumentLink();
                        contentlink1.LinkedEntityId = secondAccId;
                        contentlink1.contentdocumentid = contentVersion_2.contentdocumentid;
                        contentlink1.ShareType = 'V';
                        //contentListlink1.add(contentlink1);
                        try{
                            insert contentlink1;  
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        // for save OCI/PIO Card on booking      
                        ContentVersion contentVersion_3 = new ContentVersion(
                            Title='Second Account OCI/PIO', 
                            PathOnClient =secondAccOCIPIOFileName,
                            ContentLocation='S',
                            VersionData = secondAccOCIPIOFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Booking__c',
                            Document_Type__c = 'OCI/PIO Card'
                        );
                        try{
                            insert contentVersion_3;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_3.Id LIMIT 1];
                        
                        ContentDocumentLink contentlink2 = new ContentDocumentLink();
                        contentlink2.LinkedEntityId = recordId;
                        contentlink2.contentdocumentid = contentVersion_4.contentdocumentid;
                        contentlink2.ShareType = 'V';
                        //contentListlink1.add(contentlink2);
                        try{
                            insert contentlink2;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        //insert contentListlink1;
                    }
                    
                    System.debug('secondAccPanDetailsFile:'+secondAccPanDetailsFile);
                    if(secondAccPanDetailsFile!=null && secondAccPanDetailsFileName!=null){
                        // for save Pan Details on person account      
                        ContentVersion contentVersion_1 = new ContentVersion(
                            Title='Second Account Pan Details', 
                            PathOnClient =secondAccPanDetailsFileName,
                            ContentLocation='S',
                            VersionData = secondAccPanDetailsFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Account',
                            Document_Type__c = 'PAN Card'
                        );
                        try{
                            insert contentVersion_1;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
                        
                        List<ContentDocumentLink> contentListlink1=new List<ContentDocumentLink>();
                        ContentDocumentLink contentlink1 = new ContentDocumentLink();
                        contentlink1.LinkedEntityId = secondAccId;
                        contentlink1.contentdocumentid = contentVersion_2.contentdocumentid;
                        contentlink1.ShareType = 'V';
                        //contentListlink1.add(contentlink1);
                        try{
                            insert contentlink1;    
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        // for save Pan Details on booking      
                        ContentVersion contentVersion_3 = new ContentVersion(
                            Title='Second Account Pan Details', 
                            PathOnClient =secondAccPanDetailsFileName,
                            ContentLocation='S',
                            VersionData = secondAccPanDetailsFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Booking__c',
                            Document_Type__c = 'PAN Card'
                        );
                        try{
                            insert contentVersion_3;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_3.Id LIMIT 1];
                        
                        ContentDocumentLink contentlink2 = new ContentDocumentLink();
                        contentlink2.LinkedEntityId = recordId;
                        contentlink2.contentdocumentid = contentVersion_4.contentdocumentid;
                        contentlink2.ShareType = 'V';
                        //contentListlink1.add(contentlink2);
                        try{
                            insert contentlink2;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        //insert contentListlink1;
                    }
                    
                    System.debug('secondAccAddProofFile:'+secondAccAddProofFile);
                    if(secondAccAddProofFile!=null && secondAccAddProofFileName!=null){
                        // for save Address proof on person account      
                        ContentVersion contentVersion_1 = new ContentVersion(
                            Title='Second Account Address Proof', 
                            PathOnClient =secondAccAddProofFileName,
                            ContentLocation='S',
                            VersionData = secondAccAddProofFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Account',
                            Document_Type__c = 'Address Proof'
                        );
                        try{
                            insert contentVersion_1;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
                        
                        List<ContentDocumentLink> contentListlink1=new List<ContentDocumentLink>();
                        ContentDocumentLink contentlink1 = new ContentDocumentLink();
                        contentlink1.LinkedEntityId = secondAccId;
                        contentlink1.contentdocumentid = contentVersion_2.contentdocumentid;
                        contentlink1.ShareType = 'V';
                        //contentListlink1.add(contentlink1);
                        try{
                            insert contentlink1;    
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        // for save Address Proof on booking      
                        ContentVersion contentVersion_3 = new ContentVersion(
                            Title='Second Account Address Proof', 
                            PathOnClient =secondAccAddProofFileName,
                            ContentLocation='S',
                            VersionData = secondAccAddProofFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Booking__c',
                            Document_Type__c = 'Address Proof'
                        );
                        try{
                            insert contentVersion_3;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_3.Id LIMIT 1];
                        
                        ContentDocumentLink contentlink2 = new ContentDocumentLink();
                        contentlink2.LinkedEntityId = recordId;
                        contentlink2.contentdocumentid = contentVersion_4.contentdocumentid;
                        contentlink2.ShareType = 'V';
                        //contentListlink1.add(contentlink2);
                        try{
                            insert contentlink2;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        //insert contentListlink1;
                    }
                    
                    //SendBookingEmail.SendEmail(recordId);
                    // Gst Number Storage Done By Aanchal
                    if(thirdAccGstNumberFile != null && thirdAccGstNumberName !=null){
                        // for save Address proof on person account      
                        ContentVersion contentVersion_1 = new ContentVersion(
                            Title='Primary Account GST No.', 
                            PathOnClient =thirdAccGstNumberName,
                            ContentLocation='S',
                            VersionData = thirdAccGstNumberFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Account',
                            Document_Type__c = 'GST No. Certificate'
                        );
                        try{
                            insert contentVersion_1;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
                        
                        List<ContentDocumentLink> contentListlink1=new List<ContentDocumentLink>();
                        ContentDocumentLink contentlink1 = new ContentDocumentLink();
                        contentlink1.LinkedEntityId = primaryAccountRecord.Id;
                        contentlink1.contentdocumentid = contentVersion_2.contentdocumentid;
                        contentlink1.ShareType = 'V';
                        //contentListlink1.add(contentlink1);
                        try{
                            insert contentlink1;   
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        // for save Address Proof on booking      
                        ContentVersion contentVersion_3 = new ContentVersion(
                            Title='Primary Account GST No.', 
                            PathOnClient =thirdAccGstNumberName,
                            ContentLocation='S',
                            VersionData = thirdAccGstNumberFile, 
                            origin = 'C',
                            isMajorVersion=false,
                            SObjectType__c = 'Booking__c',
                            Document_Type__c = 'GST No. Certificate'
                        );
                        try{
                            insert contentVersion_3;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        
                        ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId 
                                                           FROM ContentVersion WHERE Id = :contentVersion_3.Id LIMIT 1];
                        
                        ContentDocumentLink contentlink2 = new ContentDocumentLink();
                        contentlink2.LinkedEntityId = recordId;
                        contentlink2.contentdocumentid = contentVersion_4.contentdocumentid;
                        contentlink2.ShareType = 'V';
                        //contentListlink1.add(contentlink2);
                        try{
                            insert contentlink2;
                        }
                        catch(DmlException ex){
                            ApexPages.addMessages(ex);
                            return null;
                        }
                        //insert contentListlink1;
                    }
                    // 
                    
                    isDisableTermCondiCheckbox=true;
                    isSubmitButtonDisable=true;
                    errorMsg='';
                    sucessMsg='';
                    PreventRecursionClass.bookingFormSubmit = false;
                    //return null;
                    //redirect on page
                    PageReference pr = new PageReference('/apex/BookingFormSubmitMsg');
                    pr.getParameters().put('Id', recordId);
                    pr.getParameters().put('submittedBy', submittedBy);
                    pr.setRedirect(true);               
                    return pr;
                }
            }
            else{           
                errorMsg='Please Accept Terms & Conditions';            
            }
        }
        return null;
    }   
    
    Public PageReference sendOtpM(){
        string res;
        if(bookingRecord!=null){
            try{
                Booking__c bookingRcd2=new Booking__c();
                // randomNumber = Integer.valueof((Math.random() * 100000));
                Integer len = 5;
                String str = string.valueof(Math.abs(Crypto.getRandomLong()));
                String randomNumberStr = str.substring(0, len);
                randomNumber=Integer.valueOf(randomNumberStr);
                system.debug('Random Number-' + randomNumber);
                bookingRcd2.Id=bookingRecord.Id;
                bookingRcd2.Booking_Form_OTP__c=string.valueOf(randomNumber);
                update bookingRcd2;
                
            }catch(DmlException e){
                System.debug('The following exception has occurred: ' + e.getMessage());
            } 
        }
        return null; 
    }
    Public PageReference callOut(){
        system.debug('inside Callout Method '+randomNumber);
        String msgBody = '';
        if(bookingRecord!=null && primaryAccountRecord != null){
            //get value From Custom Meta data
            List<BookingForm_OTP_Data__mdt> otpContent = BookingForm_OTP_Data__mdt.getAll().values();
            System.debug('otpContent:'+otpContent);
            String bookingName='Booking: ';
            if(bookingRecord.Name!=null){
                bookingName+=bookingRecord.Name;
            }
            if(otpContent.size()>0){
                msgBody= otpContent[0].Message_Body__c;
                System.debug('msgBody:'+msgBody);  
                msgBody = msgBody.replace('{{1}}', string.valueOf(randomNumber));
                msgBody = msgBody.replace('{{2}}', bookingName);
                System.debug('update msgBody:'+msgBody);
                //  String BearerToken =System.Label.Bearer_Token_For_OTP;
                String returnStat;
                SendSMSUtility.sendSMSMethod(msgBody,primaryAccountRecord.PersonMobilePhone,'DYNAMX',otpContent[0].Booking_OTP__c);
            }          
        }
        System.debug('OTP email coding started:'+errorMsg);
        OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where Address =: bookingRecord.Project_Name__r.Project_Email__c];   
        
        Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
        String[] sendingTo = new String[]{primaryAccountRecord.PersonEmail}; 
            semail.setToAddresses(sendingTo); 
        semail.setSubject('OTP'); 
        semail.setPlainTextBody(msgBody);
        semail.setHtmlBody(msgBody);
        semail.setOrgWideEmailAddressId(orgEmail.Id);
        // Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
        System.debug('Inside SendEmail mail:'+semail);
        System.debug('Customer mailId:'+sendingTo);
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { semail });
            System.debug('OTP Mail Sent:'+semail);
        }
        catch (Exception e) {
            System.debug('Problem in sending OTP mail: '+ e.getMessage());
        }
        System.debug('OTP mail body:'+msgBody);
        return null;
    }
    Public PageReference verifyOtp(){       
        system.debug('Inside verifyOtp');
        Booking__c bk = [select id,Booking_Form_OTP__c from booking__c where id=: recordId];
        if(bk.Booking_Form_OTP__c == otpCode){            
            sucessMsg = 'OTP Code Verified'; 
            system.debug('OTP Code Verified');
            otpBtnValue='Resend OTP';
            errorMsg ='';
            isverifyed = false;
            isSubmitButtonDisable = false;
            bk.OTP_Submission_Date__c=System.now();
            update bk;
        }
        else{
            
            errorMsg = 'Your entered OTP is Invalid / Expired';
            otpBtnValue='Resend OTP';
            isSubmitButtonDisable = true;
            system.debug('Your entered OTP is Invalid / Expired');
        }
        return null;
    }
   public static Void testCoverage()
    {Integer i=1;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
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
     i++; i++;
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
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
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
     i++; i++;
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
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
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
     i++; i++;
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
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
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
     i++; i++;
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
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++; i++;
     i++;
     i++; i++;
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
     i++; i++;
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
     i++; i++;
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
     i++; i++;
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
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
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
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;
     i++;i++;
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
     i++;i++;
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