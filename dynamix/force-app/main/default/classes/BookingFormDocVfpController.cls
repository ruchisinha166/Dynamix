public class BookingFormDocVfpController {
    
    Public String recordId {get;set;}
    Public String selectedPurchasePurpose {get;set;}    
    Public String receivedAmountInWords {get;set;}
    Public String projectTermsandConditions {get;set;}
    Public String priAppGSTNo {get;set;}
    Public Boolean showSection1 {get;set;}
    Public Boolean showSection2 {get;set;}
    Public Boolean showSection3 {get;set;}
    Public Boolean showAadhaarSection {get;set;}
    Public Boolean showGStSection {get;set;}
    Public Boolean isPrimaryAccIndian {get;set;}
    Public Boolean isPrimaryAccNonIndian {get;set;}
    Public Boolean isSecondAccIndian {get;set;}
    Public Boolean isSecondAccNonIndian {get;set;}
    Public Boolean showEoiBookingDateandAmt {get;set;}
    
    Public Booking__c bookingRecord {get;set;}
    Public List<Co_Applicant__c> coApplicantList {get;set;}
    Public Co_Applicant__c coAppllicantRecord {get;set;}
    Public Account secondAccountRecord {get;set;}
    Public Account thirdAccountRecord {get;set;}
    Public List<Payment__c> paymentList {get;set;}
    Public Project__c projectRecord {get;set;}
    Public Payment__c paymentRecord {get;set;}
    Public Suggested_Property__c suggProprtyRecord {get;set;}
    Public List<Offer__c> offerList {get;set;}
    public List<String> projectOfferName { get; set; }
    Public string ProjectHeader{get;set;}
    Public string ProjectFooter{get;set;}
    public boolean showHeader {get;set;}
    public boolean showFooter {get;set;}
    Public Boolean showEOICASection {get;set;}
    public Date primaryApplicantBirthDate {get;set;}
    public Date secondaryApplicantBirthDate {get;set;}
    Public String builderOrgName {get;set;}
    //  Public Datetime dateTimeOfApplication {get;set;}
    Public String dateTimeOfAppStr {get;set;}
    Public String priAppPanCardNo {get;set;}
    Public String priAppAadharCardNo {get;set;}
    Public String secAppPanCardNo {get;set;}
    Public String secAppAadharCardNo {get;set;}
    Public String thirdAppPanCardNo {get;set;}
    Public String priAppOccupation {get;set;}
    Public String priAppDesignation {get;set;}
    Public String secAppOccupation {get;set;}
    Public String secAppDesignation {get;set;}
    Public Decimal receivedAmount {get;set;}
    Public Decimal TotalAmount {get;set;}
    public List<Suggested_Property__c> suggestedLinkList {get;set;} 
    
    Public BookingFormDocVfpController(ApexPages.StandardController stdController) {
        recordId=ApexPages.currentPage().getParameters().get('Id'); 
        //recordId='a0CC4000008Ec42MAC';
        showSection1=true;
        showSection2=true;
        showSection3=false;
        isPrimaryAccIndian=false;
        isPrimaryAccNonIndian=false;
        isSecondAccIndian=false;
        isSecondAccNonIndian=false;
        showEoiBookingDateandAmt=false; 
        showHeader=false;
        showFooter=false;
        projectOfferName = new List<String>();
        builderOrgName='';
        dateTimeOfAppStr='';
        priAppPanCardNo='';
        priAppAadharCardNo='';
        secAppPanCardNo='';
        secAppAadharCardNo='';
        thirdAppPanCardNo='';
        priAppOccupation='';
        priAppDesignation='';
        secAppOccupation='';
        secAppDesignation='';
        showAadhaarSection =true;
        showGStSection = false;
        showEOICASection = false;
         TotalAmount= 0;
        //get Booking Record details
        bookingRecord=[Select Id,Name,Primary_Applicant__c,Project_Name__c,Project_Name__r.Name,Related_Suggested_Property__c,Agreement_Value__c,Primary_Applicant__r.Name,Related_Opportunity__c,Total_Amount_Received__c,Booking_Date__c,Sub_Booking_Offer__c 
                       ,Primary_Applicant__r.Salutation,Primary_Applicant__r.FirstName,Primary_Applicant__r.LastName,
                       Primary_Applicant__r.PersonBirthdate,Primary_Applicant__r.Permanent_Address__c,Primary_Applicant__r.Post_Code__c,
                       Primary_Applicant__r.Country__c,Primary_Applicant__r.State__c,Primary_Applicant__r.PersonMailingAddress,
                       Primary_Applicant__r.PersonMailingStreet,Primary_Applicant__r.PersonMailingPostalCode,Primary_Applicant__r.PersonMailingCity,
                       Primary_Applicant__r.PersonMailingState,Primary_Applicant__r.PersonMailingCountry,Primary_Applicant__r.Preferred_Address_for_all_Corresppondenc__c,
                       Primary_Applicant__r.Nationality__c,Primary_Applicant__r.Aadhar_No__pc,Primary_Applicant__r.PAN_No__pc,
                       Primary_Applicant__r.Passport__c,Primary_Applicant__r.OCI_PIO_Card__c,Primary_Applicant__r.PAN_Details__c,
                       Primary_Applicant__r.Address_Proof__c,Primary_Applicant__r.PersonMobilePhone,Primary_Applicant__r.PersonEmail,
                       Primary_Applicant__r.Landline__c,Primary_Applicant__r.Occupation__pc,Primary_Applicant__r.Organisation_Name__c,
                       Primary_Applicant__r.Designation_or_Position__pc,Primary_Applicant__r.Postal_Code__c,Primary_Applicant__r.Organisation_State__c,
                       Primary_Applicant__r.Organisation_Country__c,Primary_Applicant__r.Other_Details_Remarks__c,
                       Primary_Applicant__r.Organisation_Phone_Number__c,Primary_Applicant__r.Organisation_Office_Address__c,
                       Related_Opportunity__r.Name,Related_Opportunity__r.Current_Occupied_Property_Type__c,Related_Opportunity__r.Apartment_Number__c,
                       Related_Opportunity__r.Residential_Level__c,Related_Opportunity__r.Carpet_Area_in_sq_ft__c,Related_Opportunity__r.Carpet_Area_in_sq_mts__c,
                       Related_Opportunity__r.No_of_Parking_s_Spots_Required__c,Related_Opportunity__r.Allotment_Premium__c,Related_Opportunity__r.Amount_in_Words__c,
                       Related_Opportunity__r.Source__c,Related_Opportunity__r.Sub_Source_Specification__c,Related_Opportunity__r.Nature_of_Purchase__c,
                       Related_Opportunity__r.EOI_Booking__c,Related_Opportunity__r.EOI_Amount__c,Related_Opportunity__r.EOI_Date__c,Related_Opportunity__r.Company_Partnership__c,
                       Project_Name__r.Project_Header__c,Primary_Applicant__r.GSTIN_No__c,
                       Project_Name__r.Project_Footer__c,Project_Name__r.Builder_Organization__r.Account_Name__c,OTP_Submission_Date__c,
                       Related_Opportunity__r.EOI_CA__c, Related_Opportunity__r.EOI_CA_Payment_Received__c,
                       Related_Opportunity__r.EOI_CA_Approved_Payment__c,Related_Opportunity__r.EOI_CA_Form_Submission_Date_and_Time__c
                       From Booking__c Where Id=:recordId];
        
        builderOrgName=bookingRecord.Project_Name__r.Builder_Organization__r.Account_Name__c;
         if(bookingRecord.Related_Opportunity__r.EOI_CA__c == 'EOI' || bookingRecord.Related_Opportunity__r.EOI_CA__c == 'CA')
        {
            showEOICASection = true;
            showEoiBookingDateandAmt=true;
            if(bookingRecord.Related_Opportunity__r.EOI_CA_Approved_Payment__c != null && bookingRecord.Related_Opportunity__r.EOI_CA_Approved_Payment__c > 0){
                
                TotalAmount = bookingRecord.Related_Opportunity__r.EOI_CA_Approved_Payment__c ;
            }
            
        }
        if(bookingRecord.OTP_Submission_Date__c!=null){
            dateTimeOfAppStr=bookingRecord.OTP_Submission_Date__c.format('dd/MM/yyyy hh:mm:ss a', 'Asia/Kolkata');
            System.debug('dateTimeOfAppStr:'+dateTimeOfAppStr);
        }
        if(bookingRecord.Related_Suggested_Property__c != null)
        {
            suggestedLinkList = [SELECT Id, Cost_Sheet_Link__c FROM Suggested_Property__c
                                 WHERE Id =: bookingRecord.Related_Suggested_Property__c LIMIT 10 ];  
        }        
        //get Primary Account Details
        if(bookingRecord.Primary_Applicant__c!=null){   
            primaryApplicantBirthDate=bookingRecord.Primary_Applicant__r.PersonBirthdate;
            priAppPanCardNo=bookingRecord.Primary_Applicant__r.PAN_No__pc;
            priAppAadharCardNo=bookingRecord.Primary_Applicant__r.Aadhar_No__pc;
            priAppOccupation=bookingRecord.Primary_Applicant__r.Occupation__pc;
            priAppDesignation=bookingRecord.Primary_Applicant__r.Designation_or_Position__pc;
            priAppGSTNo = bookingRecord.Primary_Applicant__r.GSTIN_No__c;
            
            System.debug('priAppPanCardNo:====>'+priAppPanCardNo);
            System.debug('priAppAadharCardNo:====>'+priAppAadharCardNo);
            if(bookingRecord.Primary_Applicant__r.Nationality__c=='Indian'){
                isPrimaryAccIndian=true;
                isPrimaryAccNonIndian=false;
            }
            else if(bookingRecord.Primary_Applicant__r.Nationality__c=='Non-Resident Indian' || bookingRecord.Primary_Applicant__r.Nationality__c=='Foreign National of Indian Origin'){
                isPrimaryAccIndian=false;
                isPrimaryAccNonIndian=true;
            }
            else{
                isPrimaryAccIndian=false;
                isPrimaryAccNonIndian=false;
            }
        }
        
        //get Co-Applicant
        coApplicantList=[Select Id,Name,Account__c,Role__c,Booking__c From Co_Applicant__c Where Booking__c=:recordId AND Role__c!='Primary' ];
        if(coApplicantList.size()>0){
            coAppllicantRecord=coApplicantList[0];
            System.debug('coAppllicantRecord:'+coAppllicantRecord);
            if(coAppllicantRecord.Account__c!=null){
                if(bookingRecord.Related_Opportunity__r.Nature_of_Purchase__c=='Self Use'){
                    secondAccountRecord=[Select Id,Name,Salutation,FirstName,LastName,PersonBirthdate,Permanent_Address__c,
                                         Post_Code__c,Country__c,State__c,PersonMailingAddress,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCity,PersonMailingState,PersonMailingCountry,Preferred_Address_for_all_Corresppondenc__c,
                                         Nationality__c,PAN_No__pc,Aadhar_No__pc,Passport__c,OCI_PIO_Card__c,PAN_Details__c,Address_Proof__c,
                                         PersonMobilePhone,PersonEmail,Landline__c,Occupation__pc,Organisation_Name__c,Designation_or_Position__pc,
                                         Organisation_Office_Address__c,Postal_Code__c,Organisation_State__c,Organisation_Country__c,
                                         Organisation_Phone_Number__c,Other_Details_Remarks__c
                                         From Account Where Id=:coAppllicantRecord.Account__c];
                    
                    secondaryApplicantBirthDate=secondAccountRecord.PersonBirthdate;
                    secAppPanCardNo=secondAccountRecord.PAN_No__pc;
                    secAppAadharCardNo=secondAccountRecord.Aadhar_No__pc;
                    secAppOccupation=secondAccountRecord.Occupation__pc;
                    secAppDesignation=secondAccountRecord.Designation_or_Position__pc;
                    
                    if(secondAccountRecord.Nationality__c=='Indian'){
                        isSecondAccIndian=true;
                        isSecondAccNonIndian=false;
                    }
                    else if(secondAccountRecord.Nationality__c=='Non-Resident Indian' || secondAccountRecord.Nationality__c=='Foreign National of Indian Origin'){
                        isSecondAccIndian=false;
                        isSecondAccNonIndian=true;
                    }
                    else{
                        isSecondAccIndian=false;
                        isSecondAccNonIndian=false;
                    }
                }
                else if(bookingRecord.Related_Opportunity__r.Nature_of_Purchase__c=='Investment'){
                    //for get third account details (co-applicant account)
                    thirdAccountRecord=[Select Id,Name,Salutation,FirstName,LastName,Registered_Office_Address__c,Post_Code__c,Country__c,State__c,
                                        Corporate_Office_Address__c,Postal_Code__c,Organisation_State__c,
                                        Organisation_Country__c,Tin_Number__c,PAN_No__pc,Other_Details_Remarks__c,
                                        Date_of_Board_Resolution_Authority_Lett__c,PersonEmail,Phone,Fax_Number__c,
                                        Name_of_Share_Holders_Partners__c,In_Favour_Of__c,Name_of_Directors__c,
                                        Percentage_Holding__c From Account Where Id=:coAppllicantRecord.Account__c];
                    
                    thirdAppPanCardNo=thirdAccountRecord.PAN_No__pc;
                }
            }
        }
        
        //for get opportunity record
        if(bookingRecord.Related_Opportunity__c!=null){
            //for set Opportunity data'
             if(bookingRecord.Related_Opportunity__r.Company_Partnership__c == true){
                selectedPurchasePurpose='Company/Partnership';
                showAadhaarSection =false;
                showGStSection = true;
                
            }
            else{
                selectedPurchasePurpose='Individual';
            }
            showSection1=true;
            showSection2=true;
            /*if(bookingRecord.Related_Opportunity__r.Nature_of_Purchase__c=='Investment'){
                selectedPurchasePurpose='Company/Partnership';
                showSection1=false;
                showSection2=false;
                showSection3=true;
            }
            else if(bookingRecord.Related_Opportunity__r.Nature_of_Purchase__c=='Self Use'){
                selectedPurchasePurpose='Individual';
                showSection1=true;
                showSection2=true;
                showSection3=false;
            }*/
            /*if(bookingRecord.Related_Opportunity__r.EOI_Booking__c=='Yes'){
                showEoiBookingDateandAmt=true;
            }
            else{
                showEoiBookingDateandAmt=false;
            }*/
        }        
        //get payment List
        paymentList=[Select Id,Name,Cheque_Transaction_Number__c,Amount__c,Payment_Date__c,Booking__c,BankName__c,BankName__r.Name,Payment_Category__c,Payment_Status__c From Payment__c Where Booking__c=:recordId AND Payment_Category__c=:'Unit Cost'AND Payment_Status__c IN ('Approved','Pending') ORDER BY Payment_Date__c ASC];
        if(paymentList.size()>0){
            // paymentRecord=paymentList[0];   
            receivedAmount=0;         
            //set payment data   
            for(Payment__c paymentRcd:paymentList){  
                if(paymentRcd.Amount__c!=null){
                    receivedAmount+=paymentRcd.Amount__c;
                }
            }   
            if(receivedAmount!=0){
                TotalAmount  = receivedAmount +  TotalAmount;
                receivedAmountInWords='Rupees '+  NumberTOWordConvertion.getNumberTOWordConvertion(receivedAmount)+' Only'; 
            }
        }
        
        if(bookingRecord.Project_Name__c!=null){
            //get project offer list related to booking project
            offerList=[Select Id,Name,Booking__c,Project_Offer__r.Project__c From Offer__c Where Booking__c=:recordId AND Project_Offer__r.Project__c=:bookingRecord.Project_Name__c];
            System.debug('offerList:'+offerList);
            if(bookingRecord.Project_Name__r.Project_Header__c!=null)
            {
                ProjectHeader=bookingRecord.Project_Name__r.Project_Header__c;
                showHeader=true;
            }
            if(bookingRecord.Project_Name__r.Project_Footer__c!=null)
            {
                ProjectFooter =bookingRecord.Project_Name__r.Project_Footer__c; 
                showFooter=true;
            }
        }
        if(bookingRecord.Related_Suggested_Property__c!=null && bookingRecord.Related_Opportunity__c!=null){
            
            projectRecord = [Select Id, Name, Terms_Conditions__c From Project__c Where Id =: bookingRecord.Project_Name__c];
            
            suggProprtyRecord=[Select Id,Name,Opportunity__c,Unit__c,Unit__r.Annexures__c,Unit__r.Terms_Conditions__c,
                               Unit__r.Flat_Type__c,Unit__r.RERA_Carpet_Area_in_sqmtr__c,Unit__r.RERA_Carpet_Area__c,
                               Unit__r.Utility_Area__c,Unit__r.Enclosed_balcony__c,Unit__r.Deck_Carpet_Area__c,
                               Unit__r.Proposed_Area__c,Unit__r.Proposed_Area_c_in_sqmtr__c,Unit__r.Approved_Area__c,
                               Unit__r.Approved_Area_in_sqmtr__c,Unit__r.Deck_Approved_Area__c,Unit__r.Deck_Proposed_Area__c,
                               Unit__r.Proposed_Utility_Area__c,Unit__r.Proposed_Enclosed_Balcony_Area__c,Unit__r.Deck_Carpet_Area_c_in_sqmtr__c,
                               Unit__r.Property_Area__c,Unit__r.Utility_Area_in_sqmtr__c,Unit__r.Enclosed_Balcony_in_sqmtr__c,
                               Unit__r.Property_Area_in_sqmtr__c,Unit__r.Proposed_Deck_Area_in_sq_mt__c,Unit__r.Approved_Deck_Area_in_sq_mt__c,
                               Unit__r.Proposed_Utility_Area_in_sq_mt__c,Unit__r.Proposed_Enclosed_Balcony_Area_sq_mt__c,
                               Unit__r.Total_Area__c,Unit__r.Total_Area_in_sq_mt__c,Unit__r.Proposed_Total_Area__c,Unit__r.Proposed_Total_Area_in_sq_mt__c
                               From Suggested_Property__c Where Opportunity__c=:bookingRecord.Related_Opportunity__c AND Id=:bookingRecord.Related_Suggested_Property__c];
            
        }
    } 
}