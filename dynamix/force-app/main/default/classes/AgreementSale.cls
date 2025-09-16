Public class AgreementSale{
    public Booking__c booking{get;set;}
    public Account accountObject{get;set;}
    public Account CoapplicantAccountObject{get;set;}
    public Property__c properties{get;set;}
    public Project__c project{get;set;}
    public string daySup{get;set;}
    public List<Co_Applicant__c> Coapplicant{get;set;}
    public List<Suggested_Property__c> property{get;set;}
    public List<Payment__c> paymentList{get;set;}
    public List<Property__c> carParkingList{get;set;}
    public string TotalReceivedinword{get;set;}
    public string sBookingId {get;set;}
    public List<Payment_Milestones__c> pmlist {get;set;}
    public string bookingAgreementValueiwords {get;set;}
    public string bookingAgreementValuePendinginwords {get;set;}
    public integer day{get;set;}
    public String month{get;set;}
    public integer year{get;set;}
    public List<Co_Applicant__c> SingleCoapplicant{get;set;}
    public Builder_Organisation__c builderOrg {get;set;}
    public List<Project_Add_On_Charges__c> projectaddon{get;set;}
    public List<ContentDocumentLink> contentDoc {get;set;}
    public List<ContentVersion> contentVerObject{get;set;}
    public List<Co_Applicant__c> CoAccountList{get;set;}
    public Bank_Loan_Details__c bankDetails{get;set;}
    Public id ProjectHeader{get;set;}
    Public id ProjectFooter{get;set;}
    public string floorSup{get;set;}
    public List<Add_On__c> addonList{get;set;}
    public decimal largeParking{get;set;}
    public decimal smallParking{get;set;}
    public decimal carParking{get;set;}
    public decimal twowheelerParking{get;set;}
    public decimal totalCarParking{get;set;}
    public decimal totalParking{get;set;}
    public string NoOfParkInWords{get;set;}
    public String bookingTotalReceivedAmountinWords {get;set;}
    Public String phase {get;set;}
    Public String tower {get;set;}
    public string coapplicantNames{get;set;}
    public string coapplicantPANs{get;set;}
    public String coAppName{get;set;}
    public string carParkingUnits{get;set;}
    public string carParkingFloors{get;set;}
    public AgreementSale(ApexPages.StandardController controller){
        totalCarParking = 0;
        NoOfParkInWords = '';
        twowheelerParking = 0;
        smallParking =0;
        largeParking = 0;
        carParking=0;
        carParkingUnits='';
        carParkingFloors='';
        Date dt = system.today();
        DateTime dt1 = DateTime.now();
        day = dt.day();
        month = getMonthName(dt.month());
        year = dt.year();
        coapplicantNames = '';
        coapplicantPANs = '';
        // sBookingId = 'a0E0p000002oKrmEAE';
        sBookingId = ApexPages.CurrentPage().getparameters().get('id'); 
        booking = [SELECT Id,Agreement_Value__c,Primary_Applicant__r.Aadhar_No__pc,Primary_Applicant__r.PAN_No__pc,Payment_Received_Agreement__c,Total_Amount__c,Total_consolidated_amount__c,Stamp_Duty__c,Registration_Date__c,Registration_Charges__c,GST__c,Tower_Name__c,Booking_Date__c,
                   Tower_Name__r.Name,Tower_Name__r.Tower_Initials__c,Tower_Name__r.Building_Type__c,Agreement_Value_Pending__c,Tower_Name__r.Builder_Organisation__r.Bank_Name__c,Project_Name__c,Project_Name__r.Name,Primary_Applicant__c,Primary_Applicant__r.Name,Tower_Name__r.Builder_Organisation__r.GST_Bank_Name__c,
                   Tower_Name__r.Builder_Organisation__r.Branch_Address__c,Tower_Name__r.Builder_Organisation__r.GST_Branch_Address__c,Tower_Name__r.Builder_Organisation__r.Bank_Account_Number__c,Tower_Name__r.Builder_Organisation__r.GST_Bank_Account_Number__c,Tower_Name__r.Builder_Organisation__r.IFSC_code__c,
                   Tower_Name__r.Builder_Organisation__r.GST_IFSC_code__c,Related_Opportunity__c,Related_Suggested_Property__c,Owner.Name,Owner.Email,Primary_Applicant_Name_Formulla__c,Unit_Number__c,Primary_Applicant__r.PersonEmail,
                   Total_Amount_Received_Unit_Cost_TDS__c,Total_Received_Amount_Excluding_GST__c,Allotment_Letter_Generation_Date__c,Primary_Applicant__r.Salutation,Primary_Applicant__r.PersonMailingStreet,Primary_Applicant__r.PersonMailingPostalCode
                   FROM Booking__c 
                   WHERE Id =: sBookingId];
        bookingAgreementValueiwords = NumberTOWordConvertion.getNumberTOWordConvertion(booking.Agreement_Value__c);
        bookingAgreementValuePendinginwords = NumberTOWordConvertion.getNumberTOWordConvertion(booking.Agreement_Value_Pending__c);
        bookingTotalReceivedAmountinWords = NumberTOWordConvertion.getNumberTOWordConvertion(booking.Total_Amount_Received_Unit_Cost_TDS__c);  
        TotalReceivedinword = NumberTOWordConvertion.getNumberTOWordConvertion(booking.Total_Received_Amount_Excluding_GST__c); 
        if(booking != null){
            accountObject = [SELECT Id,Salutation,Name,PersonEmail,PersonMobilePhone,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode 
                             FROM Account 
                             WHERE Id =: booking.Primary_Applicant__c ];
            Coapplicant = [SELECT id,Name,Booking__c,Account__r.Name 
                           FROM Co_Applicant__c 
                           WHERE Booking__c  =: booking.id Order by Role__c];
            
            CoAccountList = [SELECT id,Name,Booking__c,PAN_Number__c,Role__c,Account_Name__c,Account__r.Name 
                             FROM Co_Applicant__c 
                             WHERE Booking__c  =: sBookingId AND Role__c = 'Co-Applicant'];
            addonList= [SELECT id,Opportunity__c,No_Of_Unit__c,Project_Add_On_Charges__r.Parking_Type__c,Project_Add_On_Charges__c,Project_Add_On_Charges__r.name 
                        FROM Add_On__c 
                        WHERE Opportunity__c =: booking.Related_Opportunity__c];
            
        }
        if(addonList.size()>0)
        {
            
            for(Add_On__c ad : addonList)
            {
                if(ad.Project_Add_On_Charges__r.Parking_Type__c == 'Large Car Parking')
                {
                    largeParking+=ad.No_Of_Unit__c;
                }
                else if(ad.Project_Add_On_Charges__r.Parking_Type__c == 'Small Car Parking')
                {
                    smallParking+=ad.No_Of_Unit__c;
                }
                else if(ad.Project_Add_On_Charges__r.Parking_Type__c == 'Car Parking')
                {
                    carParking+=ad.No_Of_Unit__c;
                }
                else if(ad.Project_Add_On_Charges__r.Parking_Type__c == 'Two Wheeler Parking')
                {
                    twowheelerParking+=ad.No_Of_Unit__c; 
                }
                
            }
            totalCarParking = largeParking+ smallParking+carParking;
            NoOfParkInWords = NumberTOWordConvertion.getNumberTOWordConvertion(totalCarParking);
            totalParking = totalCarParking + twowheelerParking;
            
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
            totalCarParking = carParkingList.size();
            for(Property__c carPark:carParkingList){
                if(carPark.Name!=''){
                    carParkingUnits = carParkingUnits+carPark.Name+',';
                }
                carParkingUnits = carParkingUnits.removeEnd(',');
                if(carPark.Floor__c!=''){
                    carParkingFloors = carParkingFloors+carPark.Floor__c+',';
                }
                carParkingFloors = carParkingFloors.removeEnd(',');
            }
            
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
            twowheelerParking = BikeParkingList.size();
            for(Property__c bikePark:BikeParkingList){
                if(bikePark.Name!=''){
                    carParkingUnits = carParkingUnits+bikePark.Name+',';
                }
                carParkingUnits = carParkingUnits.removeEnd(',');
            }
        }
        totalParking = totalCarParking + twowheelerParking;
        if(CoAccountList.size() > 0){
            
            SingleCoapplicant = [SELECT id,Name,Booking__c,PAN_Number__c,Role__c,Account_Name__c,Account__r.Name,Account__r.PAN_No__pc, 
                                 Account__r.salutation FROM Co_Applicant__c 
                                 WHERE Booking__c  =: sBookingId 
                                 AND Role__c = 'Co-Applicant'];
            if(SingleCoapplicant <> null)
            {            coAppName='';
             
             
             for(Co_Applicant__c ca : SingleCoapplicant)
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
                 if(coapplicantPANs == ''){
                     coapplicantPANs = ca.Account__r.PAN_No__pc;
                 }
                 else{
                     coapplicantPANs = coapplicantPANs + ' and ' + ca.Account__r.PAN_No__pc;
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
            pmlist= [SELECT id,Name,Milestone_age__c,Milestone_Activation_Date__c,Total_Amount__c,Due_Date__c 
                     FROM Payment_Milestones__c 
                     WHERE Booking__c = : booking.id];
        }
        if(property.size() > 0){
            for(Suggested_Property__c prop :property){
                properties = [SELECT Id,Enclosed_balcony__c,Deck_Carpet_Area_c_in_sqmtr__c,Approved_Area_in_sqmtr__c,
                              Proposed_Area_c_in_sqmtr__c,Total_Area__c,Deck_Carpet_Area__c,Approved_Area__c,
                              Proposed_Area__c,Property_Area_in_sqmtr__c,Name,Floor__c,RERA_Carpet_Area__c,
                              Utility_Area__c,Property_Area__c,RERA_Carpet_Area_in_sqmtr__c,Utility_Area_in_sqmtr__c,
                              Proposed_Deck_Area_in_sq_mt__c,Approved_Deck_Area_in_sq_mt__c,Proposed_Utility_Area_in_sq_mt__c
                              FROM Property__c 
                              WHERE Id =: prop.Unit__c];
            }
            
            if(integer.valueof(properties.Floor__c) >= 11 && integer.valueof(properties.Floor__c) <= 13)
            {
                floorSup = 'th';
            }
            else if(math.mod(integer.valueof(properties.Floor__c), 10) == 1)
            {
                floorSup = 'st';
            }
            else if(math.mod(integer.valueof(properties.Floor__c), 10) == 2)
            {
                floorSup = 'nd';
            }
            else if(math.mod(integer.valueof(properties.Floor__c), 10) == 3)
            {
                floorSup = 'rd';
            }
            else
            {
                floorSup = 'th';
            }
        }
        //------------------------------------------------------------------------
        
        if(day >= 11 && day <= 13)
        {
            daySup = 'th';
        }
        else if(math.mod(day, 10) == 1)
        {
            daySup = 'st';
        }
        else if(math.mod(day, 10) == 2)
        {
            daySup = 'nd';
        }
        else if(math.mod(day, 10) == 3)
        {
            daySup = 'rd';
        }
        else
        {
            daySup = 'th';
        }
        
        //------------------------------------------------------------------------
        
        if(booking.Project_Name__c != null){
            project = [SELECT Id,Name,Location__c,Project_Email__c,Builder_Organization__c,Sublocation__c,City__c,State__c 
                       FROM Project__c 
                       WHERE Id =: booking.Project_Name__c];
            if(project.Name == 'AVANYA Tower A' || project.Name == 'Avanya Tower A')
            {
                phase = 'I';
                tower = 'A'; 
            }
            if(project.Name == 'AVANYA Tower B' || project.Name == 'Avanya Tower B')
            {
                phase = 'II';
                tower = 'B'; 
            }
            if(project.Name == 'AVANYA Tower C' || project.Name == 'Avanya Tower C')
            {
                phase = 'III';
                tower = 'C';
            }
            if(project.Builder_Organization__c != null){
                
                builderOrg = [SELECT Id, Name, Bank_Account_Number__c, Bank_Name__c, Branch_Address__c, Branch_Name__c, City__c, Country__c, GST_Bank_Account_Number__c, GST_Bank_Name__c, GST_Branch_Address__c, GST_No__c, PAN_No__c, PIN_Code__c,
                              Registration_No__c, State__c, Street__c, GST_IFSC_Code__c, IFSC_Code__c,Account_Name__c 
                              FROM Builder_Organisation__c 
                              Where Id =: project.Builder_Organization__c LIMIT 1];
            }
        }
        Id devRecordTypeId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        projectaddon = [SELECT id,Total_Units__c,Name 
                        FROM Project_Add_On_Charges__c 
                        WHERE Project__c =: project.id 
                        AND RecordTypeId =: devRecordTypeId ];
        paymentList = [SELECT Id,Name,Amount__c,BankName__c,BankName__r.Name,Booking__c,Branch_Name__c,Cheque_Transaction_Number__c,Payment_Type__c,Payment_Status__c,Payment_Description__c,
                       Payment_Date__c,Payment_Category__c,Date__c,Receipt_No__c 
                       FROM Payment__c 
                       WHERE Booking__c =: booking.Id];
        system.debug('Car parking -->'+projectaddon);
        totalReceivedinword=NumberTOWordConvertion.getNumberTOWordConvertion((decimal)booking.Payment_Received_Agreement__c);
        bookingAgreementValueiwords = NumberTOWordConvertion.getNumberTOWordConvertion(booking.Agreement_Value__c);
        
        List<Bank_Loan_Details__c> BnkDatailsList = [SELECT Id, Name, Booking__c, Bank_NOC_Date__c 
                                                     FROM Bank_Loan_Details__c 
                                                     WHERE Booking__c =:booking.Id];
        if(BnkDatailsList.size()>0){
            bankDetails = [SELECT Id, Name, Booking__c, Bank_NOC_Date__c 
                           FROM Bank_Loan_Details__c 
                           WHERE Booking__c =: booking.Id limit 1];
        }
        
        if(booking.Project_Name__c != null){
            
            contentDoc = [SELECT id,LinkedEntityId,ContentDocumentId 
                          FROM ContentDocumentLink 
                          WHERE LinkedEntityId =: booking.Project_Name__c];
            
            if(contentDoc <> null)
            {
                List<id> ContentVersionIds = new List<id>();
                for(ContentDocumentLink cdl :contentDoc)
                {
                    ContentVersionIds.add(cdl.ContentDocumentId);
                }
                if(ContentVersionIds <> null)
                {
                    contentVerObject = [SELECT VersionData,Document_Type__c,ContentDocumentId 
                                        FROM ContentVersion 
                                        WHERE ContentDocumentId In: ContentVersionIds];
                    for(ContentVersion cv : contentVerObject)
                    {
                        if(cv.Document_Type__c == 'Project Header')
                        {
                            ProjectHeader = cv.Id;
                        }
                        if(cv.Document_Type__c == 'Project Footer')
                        {
                            ProjectFooter = cv.Id;
                        }
                    }
                }
            }
        }
    }
    
    
       public static String getMonthName(Integer monthNumber) {
        // List of month names
        List<String> monthNames = new List<String>{
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
        };
        
        // Validate month number
        if (monthNumber < 1 || monthNumber > 12) {
            throw new IllegalArgumentException('Invalid month number. It must be between 1 and 12.');
        }
        
        // Return the month name
        return monthNames[monthNumber - 1];
    }
}