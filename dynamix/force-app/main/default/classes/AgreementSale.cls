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
        public string TotalReceivedinword{get;set;}
        public string sBookingId {get;set;}
        public List<Payment_Milestones__c> pmlist {get;set;}
        public string bookingAgreementValueiwords {get;set;}
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
        public AgreementSale(ApexPages.StandardController controller){
            totalCarParking = 0;
            NoOfParkInWords = '';
            twowheelerParking = 0;
            smallParking =0;
            largeParking = 0;
            carParking=0;
            Date dt = system.today();
            DateTime dt1 = DateTime.now();
            day = dt.day();
            month = dt1.format('MMM');
            year = dt.year();
           // sBookingId = 'a0E0p000002oKrmEAE';
         	sBookingId = ApexPages.CurrentPage().getparameters().get('id'); 
            booking = [select Id,Agreement_Value__c,Primary_Applicant__r.Aadhar_No__pc,Primary_Applicant__r.PAN_No__pc,Payment_Received_Agreement__c,Total_Amount__c,Total_consolidated_amount__c,Stamp_Duty__c,Registration_Date__c,Registration_Charges__c,GST__c,Tower_Name__c,Booking_Date__c,
                       Tower_Name__r.Name,Tower_Name__r.Tower_Initials__c,Tower_Name__r.Building_Type__c,Tower_Name__r.Builder_Organisation__r.Bank_Name__c,Project_Name__c,Project_Name__r.Name,Primary_Applicant__c,Primary_Applicant__r.Name,Tower_Name__r.Builder_Organisation__r.GST_Bank_Name__c,
                       Tower_Name__r.Builder_Organisation__r.Branch_Address__c,Tower_Name__r.Builder_Organisation__r.GST_Branch_Address__c,Tower_Name__r.Builder_Organisation__r.Bank_Account_Number__c,Tower_Name__r.Builder_Organisation__r.GST_Bank_Account_Number__c,Tower_Name__r.Builder_Organisation__r.IFSC_code__c,
                       Tower_Name__r.Builder_Organisation__r.GST_IFSC_code__c,Related_Opportunity__c,Related_Suggested_Property__c,Owner.Name,Owner.Email from Booking__c where Id =: sBookingId];
            
            if(booking != null){
                accountObject = [select Id,Name,PersonEmail,PersonMobilePhone,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode from Account where Id =: booking.Primary_Applicant__c ];
                Coapplicant = [select id,Name,Booking__c,Account__r.Name from Co_Applicant__c where Booking__c  =: booking.id Order by Role__c];
                
                CoAccountList = [select id,Name,Booking__c,PAN_Number__c,Role__c,Account_Name__c,Account__r.Name from Co_Applicant__c where Booking__c  =: sBookingId AND Role__c = 'Co-Applicant'];
                addonList= [select id,Opportunity__c,No_Of_Unit__c,Project_Add_On_Charges__r.Parking_Type__c,Project_Add_On_Charges__c,Project_Add_On_Charges__r.name from Add_On__c where Opportunity__c =: booking.Related_Opportunity__c];
               
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
            
            if(CoAccountList.size() > 0){
                
                SingleCoapplicant = [select id,Name,Booking__c,PAN_Number__c,Role__c,Account_Name__c,Account__r.Name,Account__r.PAN_No__pc from Co_Applicant__c where Booking__c  =: sBookingId AND Role__c = 'Co-Applicant'];
                
            }
            
            if(booking != null){
                property = [select Id,Unit__c from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
                pmlist= [select id,Name,Milestone_age__c,Milestone_Activation_Date__c,Total_Amount__c,Due_Date__c from Payment_Milestones__c where Booking__c = : booking.id];
            }
            if(property.size() > 0){
                for(Suggested_Property__c prop :property){
                    properties = [select Id,Enclosed_balcony__c,Deck_Carpet_Area_c_in_sqmtr__c,Approved_Area_in_sqmtr__c,Proposed_Area_c_in_sqmtr__c,Total_Area__c,Deck_Carpet_Area__c,Approved_Area__c,Proposed_Area__c,Property_Area_in_sqmtr__c,Name,Floor__c,RERA_Carpet_Area__c,Utility_Area__c,Property_Area__c,RERA_Carpet_Area_in_sqmtr__c from Property__c where Id =: prop.Unit__c];
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
                project = [select Id,Name,Location__c,Project_Email__c,Builder_Organization__c,Sublocation__c,City__c,State__c from Project__c where Id =: booking.Project_Name__c];
                
                if(project.Builder_Organization__c != null){
                    
                    builderOrg = [SELECT Id, Name, Bank_Account_Number__c, Bank_Name__c, Branch_Address__c, Branch_Name__c, City__c, Country__c, GST_Bank_Account_Number__c, GST_Bank_Name__c, GST_Branch_Address__c, GST_No__c, PAN_No__c, PIN_Code__c,
                                  Registration_No__c, State__c, Street__c, GST_IFSC_Code__c, IFSC_Code__c FROM Builder_Organisation__c Where Id =: project.Builder_Organization__c limit 1];
                }
            }
            Id devRecordTypeId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
            projectaddon = [select id,Total_Units__c,Name from Project_Add_On_Charges__c where Project__c =: project.id and RecordTypeId =: devRecordTypeId ];
            paymentList = [select Id,Name,Amount__c,BankName__c,BankName__r.Name,Booking__c,Branch_Name__c,Cheque_Transaction_Number__c,Payment_Type__c,Payment_Status__c,Payment_Description__c,
                                 Payment_Date__c,Payment_Category__c,Date__c,Receipt_No__c from Payment__c where Booking__c =: booking.Id];
          system.debug('Car parking -->'+projectaddon);
          totalReceivedinword=NumberTOWordConvertion.getNumberTOWordConvertion((decimal)booking.Payment_Received_Agreement__c);
          bookingAgreementValueiwords = NumberTOWordConvertion.getNumberTOWordConvertion(booking.Agreement_Value__c);
            
             List<Bank_Loan_Details__c> BnkDatailsList = [SELECT Id, Name, Booking__c, Bank_NOC_Date__c FROM Bank_Loan_Details__c Where Booking__c =:booking.Id];
            if(BnkDatailsList.size()>0){
                
                bankDetails = [SELECT Id, Name, Booking__c, Bank_NOC_Date__c FROM Bank_Loan_Details__c Where Booking__c =: booking.Id limit 1];
            }
            
            
            if(booking.Project_Name__c != null){
                
                contentDoc = [select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId =: booking.Project_Name__c];
                
                if(contentDoc <> null)
                {
                    List<id> ContentVersionIds = new List<id>();
                    for(ContentDocumentLink cdl :contentDoc)
                    {
                        ContentVersionIds.add(cdl.ContentDocumentId);
                    }
                    if(ContentVersionIds <> null)
                    {
                        contentVerObject = [SELECT VersionData,Document_Type__c,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId In: ContentVersionIds];
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
        
}