public class AllotmentController{
    public Account accountObject{get;set;}
    public List<Payment__c> paymentList{get;set;}
    public List<Add_On__c> addOnList{get;set;}
    public List<ParkingSpace> carParkingDimentionsList{get;set;}
    Public Decimal noOf2WheelerParking{get;set;}
    Public Decimal noOfCarParking{get;set;}
    Public Decimal agreementReceivedPercentage{get;set;}
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
    public String bookingTotalReceivedAmountinWords {get;set;}
    public List<ContentDocumentLink> contentDoc {get;set;}
    public List<ContentVersion> contentVerObject{get;set;}
    public List<Payment_Milestones__c> paymentMilestoneList{get;set;}
    Public string ProjectHeader{get;set;}
    Public string ProjectFooter{get;set;}
    public boolean showHeader {get;set;}
    public boolean showFooter {get;set;}
    public string floor{get;set;}
    public string coapplicantNames{get;set;}
    public string carParkingUnitNumbers{get;set;}
    public User bookingOwner {get;set;}
    Public String flatBHK {get;set;}
    
    public AllotmentController(ApexPages.StandardController controller){
        
        noOfCarParking = 0;
        noOf2WheelerParking= 0;
        carParkingUnitNumbers = '';
        
        String sBookingId = ApexPages.CurrentPage().getparameters().get('id');
        //String sBookingId='a0CC4000008Ec42MAC'; //a0CBh000000DEMwMAO //a0CBh000000BWarMAG
        showHeader=false;
        showFooter=false;
        coapplicantNames = '';
        booking = [SELECT Id,Tower_Name__c,Related_Opportunity__c,Car_Parking_Number_1__c,Car_Parking_Number_3__c,Car_Parking_Number_2__c,Car_Parking_Number_4__c,
                   Registration_Date__c,Unit_Number__c,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Tower_Name__r.Tower_Initials__c,
                   Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.Name,Related_Suggested_Property__c,Agreement_Value__c,
                   Booking_Date__c,Booking_Owner_Email__c,OwnerId,Booking_Owner_Name__c,Car_Parking_Number_1_Type__c,Project_Name__r.Name,
                   Related_Opportunity__r.Booking_Form_Submitted_by_Customer_Date__c,Total_Received_Amount_Excluding_GST__c,
                   Car_Parking_Number_2_Type__c, Car_Parking_Number_3_Type__c, Car_Parking_Number_4_Type__c,Primary_Applicant__r.PersonEmail,
                   Primary_Applicant__r.Business_Account_Signatory_Name__c,Primary_Applicant__r.Business_Account_Signatory_Designation__c
                   FROM Booking__c 
                   WHERE Id =: sBookingId];
        if(booking.Agreement_Value__c != null && booking.Agreement_Value__c >0 && booking.Total_Received_Amount_Excluding_GST__c != null && booking.Total_Received_Amount_Excluding_GST__c >0)
        {
            agreementReceivedPercentage = (booking.Total_Received_Amount_Excluding_GST__c/booking.Agreement_Value__c )*100;
        }
        else
        {
            agreementReceivedPercentage = 0;
        }
        
        addOnList = [SELECT Name,No_Of_Unit__c,Parking_Number__c,Project_Add_On_Charges__r.name,Project_Add_On_Charges__r.Parking_Type__c,
                     Length__c,Breadth__c,Height__c from Add_On__c where Opportunity__c =: booking.Related_Opportunity__c];
        bookingAgreementValueiwords = NumberTOWordConvertion.getNumberTOWordConvertion(booking.Agreement_Value__c);
        bookingTotalReceivedAmountinWords = NumberTOWordConvertion.getNumberTOWordConvertion(booking.Total_Received_Amount_Excluding_GST__c);
        bookingOwner=[Select Id,MobilePhone From User Where Id=:booking.OwnerId];
        System.debug('booking:'+booking);
        System.debug('addOnList:'+addOnList);
        System.debug('bookingAgreementValueiwords:'+bookingAgreementValueiwords);
        if(booking != null){
            if( booking.Primary_Applicant__c!=null){
                accountObject = [SELECT Id,Name,PersonMobilePhone,salutation,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode,PersonMailingCountry,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Phone 
                                 FROM Account 
                                 WHERE Id =: booking.Primary_Applicant__c ];
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
            Coapplicant = [SELECT id,Account__r.salutation,Booking__c,Account__r.Name,Role__c 
                           FROM Co_Applicant__c 
                           WHERE Booking__c  =: booking.id 
                           AND Role__c=: 'Co-Applicant'];
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
                 if(ca.Role__c != 'Primary')
                 {
                     coAppName = coAppName+ca.Account__r.name+',';
                 }
             }
             coAppName = coAppName.removeEnd(',');
            }
        }
        
        if(booking != null){
            property = [SELECT Id,Unit__c 
                        FROM Suggested_Property__c 
                        WHERE Id =: booking.Related_Suggested_Property__c];
        }
        if(property.size() > 0){
            for(Suggested_Property__c prop :property){
                propertyRecord = [SELECT Id,Name,Floor__c,Tower__r.Name,Parking_Type__c,Proposed_Area_c_in_sqmtr__c	,Proposed_Area__c,
                                  RERA_Carpet_Area__c,Approved_Area__c,RERA_Carpet_Area_in_sqmtr__c,Flower_Bed_Area__c,
                                  Deck_Carpet_Area__c,Utility_Area_in_sqmtr__c,Enclosed_Balcony_in_sqmtr__c,
                                  Approved_Deck_Area_in_sq_mt__c,Approved_Area_in_sqmtr__c,Flat_Type__c,First_Possession_Date__c,
                                  Proposed_Utility_Area_in_sq_mt__c,Proposed_Enclosed_Balcony_Area_sq_mt__c,
                                  Proposed_Utility_Area__c,Proposed_Deck_Area_in_sq_mt__c,Deck_Proposed_Area__c,
                                  Proposed_Enclosed_Balcony_Area__c
                                  FROM Property__c 
                                  WHERE Id =: prop.Unit__c]; 
            }
            flatBHK = propertyRecord.Flat_Type__c.replace('BHK','');
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
        paymentMilestoneList = [SELECT Id,Sequence_No__c, NAME,Due_Date__c, Booking__c
                                FROM Payment_Milestones__c
                                WHERE Booking__c =: sBookingId order By Sequence_No__c ASC ];
        
        if(booking.Project_Name__c != null){
            project = [SELECT Id,Name,Project_Phone__c,Project_Header__c,Project_Footer__c,Postal_Code__c,Builder_Organization__r.name,Project_Email__c,
                       Location__c,Builder_Organization__r.Street__c,Builder_Organization__r.City__c,Builder_Organization__r.State__c,Builder_Organization__r.Country__c,
                       Sublocation__c,city__c,state__c, RERA_Number__c,CTS_No__c,Survey_No__c,Rera_Date__c,Builder_Organization__r.Account_Name__c,First_Possession_Date__c
                       FROM Project__c 
                       WHERE Id =: booking.Project_Name__c]; 
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
            paymentList = [SELECT Id,Name,Amount__c,BankName__c,Booking__c,Branch_Name__c,Cheque_Transaction_Number__c,Payment_Type__c,Payment_Status__c,Payment_Description__c,
                           Payment_Date__c,Payment_Category__c,Date__c,Receipt_No__c,BankName__r.Name 
                           FROM Payment__c 
                           WHERE Booking__c =: booking.Id
                           ORDER BY  Payment_Date__c ASC LIMIT 1];
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
            carParkingDimentionsList = new List<ParkingSpace>();
            List<ParkingSpace> parkingSpaces = new List<ParkingSpace>();
            if(adon.Project_Add_On_Charges__r.Parking_Type__c == 'Large Car Parking')
            {
                noOfCarParking += adon.No_Of_Unit__c;
                for(Integer i=1;i<=adon.No_Of_Unit__c;i++){
                    parkingSpaces.add(new ParkingSpace(
                        adon.Length__c != null ? adon.Length__c : 0, 
                        adon.Breadth__c != null ? adon.Breadth__c : 0, 
                        adon.Height__c != null ? adon.Height__c : 0
                    ));
                }
                if(!parkingSpaces.isEmpty()){
                    carParkingDimentionsList.addAll(parkingSpaces);
                }
            }
            if(adon.Project_Add_On_Charges__r.Parking_Type__c == 'Small Car Parking')
            {
                noOfCarParking += adon.No_Of_Unit__c;
                for(Integer i=1;i<=adon.No_Of_Unit__c;i++){
                    parkingSpaces.add(new ParkingSpace(
                        adon.Length__c != null ? adon.Length__c : 0, 
                        adon.Breadth__c != null ? adon.Breadth__c : 0, 
                        adon.Height__c != null ? adon.Height__c : 0
                    ));
                }
                if(!parkingSpaces.isEmpty()){
                    carParkingDimentionsList.addAll(parkingSpaces);
                }
            }
            if(adon.Project_Add_On_Charges__r.Parking_Type__c == 'Car Parking')
            {
                noOfCarParking += adon.No_Of_Unit__c;
                if(adon.Parking_Number__c!=''){
                    carParkingUnitNumbers = carParkingUnitNumbers+adon.Parking_Number__c+',';
                }
                if(carParkingUnitNumbers!=''){
                    carParkingUnitNumbers = carParkingUnitNumbers.removeEnd(',');
                }
                for(Integer i=1;i<=adon.No_Of_Unit__c;i++){
                    parkingSpaces.add(new ParkingSpace(
                        adon.Length__c != null ? adon.Length__c : 0, 
                        adon.Breadth__c != null ? adon.Breadth__c : 0, 
                        adon.Height__c != null ? adon.Height__c : 0
                    ));
                }
                if(!parkingSpaces.isEmpty()){
                    system.debug('parkingSpaces--> '+parkingSpaces);
                    carParkingDimentionsList.addAll(parkingSpaces);
                }
            }
            if(adon.Project_Add_On_Charges__r.Parking_Type__c == 'Two Wheeler Parking')
            {
                noOf2WheelerParking = adon.No_Of_Unit__c;
            }
        }
        List<Property__c> carParkingList = [SELECT Id, Name, Tower__c,Parking_Type__c, Tower__r.Name, Floor__c, Property_Status__c, Flat_Type__c,Snag_Status__c,
                                            Total_Area__c, Property_Price_Slab__c,RERA_Carpet_Area__c,Deck_Carpet_Area__c,Utility_Area__c, Pricing_Plan_Detail__c,
                                            Booking__c,Booking__r.Name,Booking__r.Primary_Applicant_Name_Formulla__c,Booking__r.Sales_Manager__r.Name,
                                            Booking__r.Booking_Date__c,Booking__r.Stage__c
                                            FROM Property__c 
                                            WHERE   Flat_Type__c = 'CAR PARKING' 
                                            AND Booking__c =: sBookingId];
        if(carParkingList.size()>0)
        {
            noOfCarParking = carParkingList.size();
            
        }
        List<Property__c> BikeParkingList = [SELECT Id, Name, Tower__c,Parking_Type__c, Tower__r.Name, Floor__c, Property_Status__c, Flat_Type__c,Snag_Status__c,
                                             Total_Area__c, Property_Price_Slab__c,RERA_Carpet_Area__c,Deck_Carpet_Area__c,Utility_Area__c, Pricing_Plan_Detail__c,
                                             Booking__c,Booking__r.Name,Booking__r.Primary_Applicant_Name_Formulla__c,Booking__r.Sales_Manager__r.Name,
                                             Booking__r.Booking_Date__c,Booking__r.Stage__c
                                             FROM Property__c 
                                             WHERE   Flat_Type__c = 'BIKE PARKING' 
                                             AND Booking__c =: sBookingId];
        
        if(BikeParkingList.size()>0)
        {
            noOf2WheelerParking = BikeParkingList.size();
        }
    }
    public class ParkingSpace {
        public Decimal length { get; set; }
        public Decimal breadth { get; set; }
        public Decimal height { get; set; }

        public ParkingSpace(Decimal length, Decimal breadth, Decimal height) {
            this.length = length;
            this.breadth = breadth;
            this.height = height;
        }
    }
}