public class customerLedgerExtenstion {
    
    public Booking__c booking{get;set;}
    public List<Add_On__c> addOnList{get;set;}
    public List<Suggested_Property__c> property{get;set;}
    public Property__c properties{get;set;}
    public User usr{get;set;}
    public  List<Booking_Line_Items__c> bookingLineItems{get;set;}
    public List<Payment__c> payments{get;set;}
    public list<Co_Applicant__c> coapplicant{get;set;}
    public list<Payment_Milestones__c> paymentMilestons {get;set;}
    public List<ContentDocumentLink> contentDoc {get;set;}
    public List<ContentVersion> contentVerObject{get;set;}
    public Pricing_Plan_Components__c PricingPlanList {get;set;}
    Public decimal totalFC{get;set;}
    Public id ProjectHeader{get;set;}
    Public id ProjectFooter{get;set;}
    public string coApplicantName{get;set;}
    public string coApplicantAge{get;set;}
    public string coApplicantAdr{get;set;}
    public string coApplicantPan{get;set;}
    Public Decimal noOf2WheelerParking{get;set;}
    Public Decimal noOfCarParking{get;set;}
    public Decimal PossessionCharges{get;set;}
    public Decimal TotalInterest{get;set;}
    public list<Payment_Milestones__c> payMilestonelist{get;set;}
    public Decimal TotalOutstanding {get;set;}
    public Decimal TotalOutstandingGST {get;set;}
    public Decimal CGST{get;set;}
    public Decimal SGST{get;set;}
    public Decimal TDS{get;set;}
    public Decimal AmountDue{get;set;}
    public String InvoiceId{get;set;}
    
    public customerLedgerExtenstion(ApexPages.StandardController controller)
    {
        totalFC = 0;
        noOf2WheelerParking = 0;
        noOfCarParking = 0;
        PossessionCharges = 0;
        TotalInterest =0;
        TotalOutstanding = 0;
        TotalOutstandingGST = 0;
        CGST=0;
        SGST=0; 
        TDS=0;
        String sBookingId = ApexPages.CurrentPage().getparameters().get('id');
        
        usr = [SELECT ID, Name FROM User WHERE ID = :UserInfo.getUserId()];
        
        booking = [select Id,Registration_Number__c,Related_Opportunity__c,Tower_Name__c,Channel_Partner__r.name,Lien_Date__c,Possession_Date__c,Registration_Charges__c,Agreement_Sent_to_Agent_Date__c,GST__c,Stamp_Duty_Date__c,Stamp_Duty__c,Primary_Applicant__r.PersonMobilePhone,Primary_Applicant__r.PersonMailingCity,Primary_Applicant__r.PersonMailingStreet,Primary_Applicant__r.PersonMailingCountry,Primary_Applicant__r.PersonMailingState,Primary_Applicant__r.PersonMailingPostalCode,Primary_Applicant__r.PAN_No__pc,Primary_Applicant__r.Aadhar_No__pc,Primary_Applicant__r.age__c,Project_Name__r.Project_Initials__c,Project_Name__r.Last_Invoice_Number__c,Project_Name__r.Location__c,Project_Name__r.name,Project_Name__r.Builder_Organization__r.Builder_Organisation_Initials__c,Project_Name__r.Builder_Organization__r.Street__c,Project_Name__r.Builder_Organization__r.State__c,Project_Name__r.Builder_Organization__r.Country__c,Project_Name__r.Builder_Organization__r.name,Project_Name__r.Builder_Organization__r.city__c,Registration_Date__c,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Tower_Name__r.Tower_Initials__c,Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.Name,Primary_Applicant__r.PersonEmail,Related_Suggested_Property__c,Agreement_Value__c,Booking_Date__c from Booking__c where Id =: sBookingId];
        totalFC = booking.Registration_Charges__c + booking.Agreement_Value__c+booking.GST__c+booking.Stamp_Duty__c;
        
        payments = [select id,Amount__c,GST__c,Branch_Name__c,Cheque_Transaction_Number__c,Date__c,BankName__r.name,Receipt_No__c,Payment_Date__c,Payment_Category__c from payment__c where ((Payment_Category__c =: 'Unit Cost' OR Payment_Category__c =: 'GST') AND Booking__c=: booking.id AND Payment_Status__c =: 'Approved') ORDER BY Payment_Date__c];
        paymentMilestons = [select id,name,Total_Interest_Amount__c,Milestone_age__c,Milestone_Amount1__c,Milestone_Activation_Date__c,Due_Date__c,GST_Amount1__c from Payment_Milestones__c where Booking__c =: booking.Id];
        
        string recordtypeId = Schema.Sobjecttype.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        bookingLineItems = [SELECT Id,Name,Project_Add_On_Charges__c,Property__c,Booking__c,Booking__r.Related_Property__c FROM Booking_Line_Items__c where (Booking__c =: booking.Id AND Project_Add_On_Charges__r.RecordtypeId =: recordtypeId)];
        
        if(booking <> null)
        {
            property = [select Id,Unit__c from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
          	properties = [select Id,Pricing_Plan_Detail__c,Property_Price_Slab__c,Property_Price_Slab__r.Name,RERA_Carpet_Area__c,Name,Floor__c from Property__c where Id =: property[0].Unit__c];
            if(properties <> null)
            {
                PricingPlanList = [select id,Price_Lumpsum__c from Pricing_Plan_Components__c where (Pricing_Plan__c =: properties.Property_Price_Slab__c AND (Name =: 'Basic Price' OR Project_Add_On_Charges__r.name = 'Basic Price'))];  
            }
            coapplicant = [select id,Account__r.name,Account__r.salutation,Account__r.age__c,Account__r.Aadhar_No__pc,Account__r.PAN_No__pc from Co_Applicant__c where (Booking__c =: sBookingId AND role__c =: 'Co-Applicant') ORDER BY Account__r.name DESC];
            coApplicantName = '';
            coApplicantAge = '';
            coApplicantAdr = '';
            coApplicantPan = '';
            
            for(Co_Applicant__c cp : coapplicant)
            {
					coApplicantName = coApplicantName + cp.Account__r.name + ',';  
                	coApplicantAge = coApplicantAge + cp.Account__r.age__c + ',';
                	coApplicantAdr = coApplicantAdr + cp.Account__r.Aadhar_No__pc + ',';
                	coApplicantPan = coApplicantPan + cp.Account__r.PAN_No__pc + ',';
            }
            
            if(booking.Related_Opportunity__c <> null)
            {
                addOnList = [select Name,No_Of_Unit__c,Project_Add_On_Charges__r.name,Project_Add_On_Charges__r.Parking_Type__c from Add_On__c where Opportunity__c =: booking.Related_Opportunity__c];
                
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
            
            InvoiceId = booking.Project_Name__r.Builder_Organization__r.Builder_Organisation_Initials__c+'/'+booking.Project_Name__r.Project_Initials__c+ '/' + Date.Today().Year() +'/'+ String.valueOf(booking.Project_Name__r.Last_Invoice_Number__c).leftPad(5, '0');
            
        }
        
        if(booking.Project_Name__r.name <> null)
        {
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
        if(paymentMilestons.size() <> 0)
        {
            for(Payment_Milestones__c pay : paymentMilestons)
            {
                if(pay.name == 'Possession/Handover(Other)Charge')
                {
                    PossessionCharges += pay.Milestone_Amount1__c;
                }
                TotalInterest += pay.Total_Interest_Amount__c;
            }
        }
        payMilestonelist = [select id,booking__c,Milestone_Amount1__c,GST_Amount1__c,Remaining_Amount__c,Remaining_GST__c from Payment_Milestones__c where Booking__c =: booking.id and Milestone_Status__c = 'Active'];
               for(Payment_Milestones__c pm : payMilestonelist)
               {
                   TotalOutstanding = TotalOutstanding + pm.Remaining_Amount__c;
                   TotalOutstandingGST = TotalOutstandingGST + pm.Remaining_GST__c ;
               }
            CGST=(TotalOutstanding*2.5)/100;
            SGST=(TotalOutstanding*2.5)/100; 
            TDS=(TotalOutstanding*1)/100;
            AmountDue=TotalOutstanding-TDS;
        
        
    }

}