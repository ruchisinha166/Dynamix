public without sharing class PossessionLetterController{
    public Account accountObject{get;set;}
    public List<Payment__c> paymentList{get;set;}
    public List<Add_On__c> addOnList{get;set;}
    Public Decimal noOf2WheelerParking{get;set;}
    Public Decimal noOfCarParking{get;set;}
    public Payment__c payment{get;set;}
    public Booking__c booking{get;set;}
    public Property__c propertyRecord{get;set;}
    public Project__c project{get;set;}
    public String coAppName{get;set;}
    public List<Suggested_Property__c> property{get;set;}
    public boolean dateValue {get;set;}
    public boolean address {get;set;}
    public boolean phone {get;set;}
    public List<Co_Applicant__c> Coapplicant{get;set;}
    public String bookingAgreementValueiwords {get;set;}
    public List<ContentDocumentLink> contentDoc {get;set;}
    public List<ContentVersion> contentVerObject{get;set;}
    Public string ProjectHeader{get;set;}
    Public string ProjectFooter{get;set;}
    public boolean showHeader {get;set;}
    public boolean showFooter {get;set;}
    public string floor{get;set;}
    public string coapplicantNames{get;set;}
    public User bookingOwner {get;set;}
    
    public PossessionLetterController(ApexPages.StandardController controller){
        
        noOfCarParking = 0;
        noOf2WheelerParking= 0;
        
        String sBookingId = ApexPages.CurrentPage().getparameters().get('id');
        //String sBookingId='a0CC4000008Ec42MAC'; //a0CBh000000DEMwMAO //a0CBh000000BWarMAG
        showHeader=false;
        showFooter=false;
        coapplicantNames = '';
        booking = [select Id,Tower_Name__c,Related_Opportunity__c,Car_Parking_Number_1__c,Car_Parking_Number_3__c,Car_Parking_Number_2__c,Car_Parking_Number_4__c,
                   Registration_Date__c,Unit_Number__c,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Tower_Name__r.Tower_Initials__c,
                   Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.Name,Related_Suggested_Property__c,Agreement_Value__c,
                   Booking_Date__c,Booking_Owner_Email__c,OwnerId,Booking_Owner_Name__c,Car_Parking_Number_1_Type__c,
                   Car_Parking_Number_2_Type__c, Car_Parking_Number_3_Type__c, Car_Parking_Number_4_Type__c,Primary_Applicant__r.Business_Account_Signatory_Name__c,Primary_Applicant__r.Business_Account_Signatory_Designation__c
                   from Booking__c where Id =: sBookingId];
        addOnList = [select Name,No_Of_Unit__c,Project_Add_On_Charges__r.name,Project_Add_On_Charges__r.Parking_Type__c from Add_On__c where Opportunity__c =: booking.Related_Opportunity__c];
        bookingAgreementValueiwords = NumberTOWordConvertion.getNumberTOWordConvertion(booking.Agreement_Value__c);
        bookingOwner=[Select Id,MobilePhone From User Where Id=:booking.OwnerId];
        System.debug('booking:'+booking);
        System.debug('addOnList:'+addOnList);
        System.debug('bookingAgreementValueiwords:'+bookingAgreementValueiwords);
        if(booking != null){
            if( booking.Primary_Applicant__c!=null){
                accountObject = [select Id,Name,PersonMobilePhone,salutation,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode,PersonMailingCountry,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Phone from Account where Id =: booking.Primary_Applicant__c ];
                System.debug('accountObject:'+accountObject);
                if(accountObject.BillingCountry != null)
                {
                    address = true;
                }
                else
                {
                    address = false;
                }
                if(accountObject.Phone != null)
                {
                    phone = true;
                }
                else
                {
                    phone = false;
                }
            }
            Coapplicant = [select id,Account__r.salutation,Booking__c,Account__r.Name,Role__c from Co_Applicant__c where Booking__c  =: booking.id AND Role__c=: 'Co-Applicant'];
            System.debug('Coapplicant:'+Coapplicant);
            if(Coapplicant <> null)
            {            coAppName='';

                
                for(Co_Applicant__c ca : Coapplicant)
                {
                    if(ca.Account__r.salutation==null){
                        ca.Account__r.salutation=''
                            ;                    }
                    if(coapplicantNames == '')
                    {
                        coapplicantNames = ca.Account__r.salutation+' '+ca.Account__r.name;
                    }
                    else
                    {
                        coapplicantNames = coapplicantNames+' and '+ca.Account__r.salutation+' '+ca.Account__r.name; 
                    }
                     if(ca.Role__c!='Primary')
                    {
                        coAppName = coAppName+ca.Account__r.name+',';
                    }
                }
                 coAppName = coAppName.removeEnd(',');
            }
        }
        
        if(booking != null){
            property = [select Id,Unit__c from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
        }
        if(property.size() > 0){
            for(Suggested_Property__c prop :property){
                propertyRecord = [select Id,Name,Floor__c,Tower__r.Name,Parking_Type__c,
                                  RERA_Carpet_Area__c,Approved_Area__c,RERA_Carpet_Area_in_sqmtr__c,
                                  Flower_Bed_Area__c,Deck_Carpet_Area__c,Utility_Area_in_sqmtr__c,
                                  Enclosed_Balcony_in_sqmtr__c,Approved_Deck_Area_in_sq_mt__c,
                                  Proposed_Area_c_in_sqmtr__c,Approved_Area_in_sqmtr__c,
                                  Proposed_Utility_Area_in_sq_mt__c,Proposed_Enclosed_Balcony_Area_sq_mt__c,
                                  Proposed_Deck_Area_in_sq_mt__c from Property__c where Id =: prop.Unit__c]; 
            }
            if(integer.valueof(propertyRecord.Floor__c) >= 11 && integer.valueof(propertyRecord.Floor__c) <= 13)
            {
                floor = 'th';
            }
            else if(math.mod(integer.valueof(propertyRecord.Floor__c), 10) == 1)
            {
                floor = 'st';
            }
            else if(math.mod(integer.valueof(propertyRecord.Floor__c), 10) == 2)
            {
                floor = 'nd';
            }
            else if(math.mod(integer.valueof(propertyRecord.Floor__c), 10) == 3)
            {
                floor = 'rd';
            }
            else
            {
                floor = 'th';
            }
        }
        if(booking.Project_Name__c != null){
            project = [select Id,Name,Project_Phone__c,Project_Header__c,Project_Footer__c,OC_Receival_Date__c,OC_Number__c,
                       Postal_Code__c,Builder_Organization__r.name,Project_Email__c,Location__c,RERA_Number__c,
                       Builder_Organization_Signatory_Name__c,Builder_Org_Signatory_Designation__c,
                       Sublocation__c,city__c,state__c from Project__c where Id =: booking.Project_Name__c]; 
            if(project.Project_Header__c!=null)
            {
                ProjectHeader=project.Project_Header__c;
                showHeader=true;
            }
            if(project.Project_Footer__c!=null)
            {
                ProjectFooter =project.Project_Footer__c; 
                showFooter=true;
            }
        }
        System.debug('showHeader:'+showHeader);
        System.debug('showFooter:'+showFooter);
        System.debug('ProjectHeader:'+ProjectHeader);
        System.debug('ProjectHeader:'+ProjectHeader);
        if(booking != null){
            paymentList = [select Id,Name,Amount__c,BankName__c,Booking__c,Branch_Name__c,Cheque_Transaction_Number__c,Payment_Type__c,Payment_Status__c,Payment_Description__c,
                           Payment_Date__c,Payment_Category__c,Date__c,Receipt_No__c from Payment__c where Booking__c =: booking.Id];
            for(Payment__c paymnt:paymentList){
                payment  = paymnt;
                if(paymnt.Cheque_Transaction_Number__c != null && payment.Payment_Type__c == 'Cheque'){
                    dateValue = true;   
                } 
                else{
                    dateValue =false;
                }
            } 
        }
        
        
        for(Add_On__c adon : addOnList)
        {
            if(adon.Project_Add_On_Charges__r.Parking_Type__c == 'Large Car Parking')
            {
                noOfCarParking += adon.No_Of_Unit__c;
            }
            if(adon.Project_Add_On_Charges__r.Parking_Type__c == 'Small Car Parking')
            {
                noOfCarParking += adon.No_Of_Unit__c;
            }
            if(adon.Project_Add_On_Charges__r.Parking_Type__c == 'Car Parking')
            {
                noOfCarParking += adon.No_Of_Unit__c;
            }
            if(adon.Project_Add_On_Charges__r.Parking_Type__c == 'Two Wheeler Parking')
            {
                noOf2WheelerParking = adon.No_Of_Unit__c;
            }
        }
    }
}