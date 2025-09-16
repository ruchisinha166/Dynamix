public class InterestWaiverExtention {
    
    public Account accountObject{get;set;}
    public List<Payment__c> paymentList{get;set;}
    public List<Add_On__c> addOnList{get;set;}
    Public Decimal noOf2WheelerParking{get;set;}
    Public Decimal noOfCarParking{get;set;}
    Public string addonVals{get;set;}
    public Payment__c payment{get;set;}
    public Booking__c booking{get;set;}
    public Property__c properties{get;set;}
    public Project__c project{get;set;}
    public List<Suggested_Property__c> property{get;set;}
    public boolean dateValue {get;set;}
    public boolean address {get;set;}
    public boolean phone {get;set;}
    public List<Co_Applicant__c> Coapplicant{get;set;}
    public String bookingAgreementValueiwords {get;set;}
    public List<ContentDocumentLink> contentDoc {get;set;}
    public List<ContentVersion> contentVerObject{get;set;}
    Public id ProjectHeader{get;set;}
    Public id ProjectFooter{get;set;}
    public Payment_Milestones__c pm {get;set;}
    public Integer monthDiff {get;set;}
    public Integer daysEnd {get;set;}
    public Decimal factor {get;set;}
    public string floor{get;set;}
    
    public InterestWaiverExtention(ApexPages.StandardController controller){
        
        String milestoneId = ApexPages.CurrentPage().getparameters().get('id');
        //String milestoneId ='a0J0p000003Q2KnEAK';
        noOfCarParking =0;
        noOf2WheelerParking =0;
        pm = [select id, name,Letter_Email_Date__c,First_Payment_Email_Reminder_Date__c,Second_Payment_Email_Reminder_Date__c,Third_Payment_Email_Reminder_Date__c,forth_Payment_Email_Reminder_Date__c,Milestone_Amount1__c,GST_Amount1__c,Booking__c,Total_Interest_Amount__c,Interest_Wave_Off_Amount__c,Milestone_Activation_Date__c from Payment_Milestones__c where id=: milestoneId];
            
        system.debug('pm=='+pm.id);
        Date a = pm.Milestone_Activation_Date__c;
        Date b = system.today();
        
        monthDiff = a.monthsBetween(b);
        daysEnd = Date.daysInMonth(b.year(), b.month());
        Decimal day_s = a.day();
        Decimal day_e = b.day();
         factor = 0;
        if(day_s != day_e){
        factor = day_e - day_s;
        }
        System.debug(monthDiff);
        System.debug(factor);
        System.debug(monthDiff+factor);
        Integer monthDiff = a.monthsBetween(b);
        if (b.day() > a.day()) monthDiff++;
        System.debug(monthDiff);
        
        booking = [select Id,Hidden_Interest_Wave_Off_Amount__c,Project_Name__r.Name,Primary_Applicant__r.PersonMailingCity,Primary_Applicant__r.Salutation,Tower_Name__c,Related_Opportunity__c,Registration_Date__c,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Tower_Name__r.Tower_Initials__c,Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.Name,Primary_Applicant__r.PersonMailingStreet,Primary_Applicant__r.PersonMailingState,Primary_Applicant__r.PersonMailingCountry,Primary_Applicant__r.PersonMailingPostalCode,Primary_Applicant__r.PersonMobilePhone,Related_Suggested_Property__c,Agreement_Value__c,Booking_Date__c from Booking__c where Id =: pm.Booking__c];
        addOnList = [select Name,No_Of_Unit__c,Project_Add_On_Charges__r.name,Project_Add_On_Charges__r.Parking_Type__c from Add_On__c where Opportunity__c =: booking.Related_Opportunity__c];
        bookingAgreementValueiwords = NumberTOWordConvertion.getNumberTOWordConvertion(booking.Agreement_Value__c);
        
        if(booking != null){
            accountObject = [select Id,PersonMobilePhone,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode,PersonMailingCountry,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Phone from Account where Id =: booking.Primary_Applicant__c ];
            Coapplicant = [select id,Booking__c,Account__r.Name from Co_Applicant__c where Booking__c  =: booking.id Order by Role__c];
        }
        
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
        
        if(booking != null){
            property = [select Id,Unit__c from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
        }
        
        if(property.size() > 0){
            properties = [select Id,Name,Floor__c,RERA_Carpet_Area_in_sqmtr__c,RERA_Carpet_Area__c,Flower_Bed_Area__c,Deck_Carpet_Area__c from Property__c where Id =: property[0].Unit__c];
            if(integer.valueof(properties.Floor__c) >= 11 && integer.valueof(properties.Floor__c) <= 13)
            {
                floor = 'th';
            }
            else if(math.mod(integer.valueof(properties.Floor__c), 10) == 1)
            {
                 floor = 'st';
            }
            else if(math.mod(integer.valueof(properties.Floor__c), 10) == 2)
            {
                 floor = 'nd';
            }
            else if(math.mod(integer.valueof(properties.Floor__c), 10) == 3)
            {
                 floor = 'rd';
            }
            else
            {
                floor = 'th';
            }
        }
        
        if(booking.Project_Name__c != null){
            project = [select Id,Postal_Code__c,Builder_Organization__r.name,Name,Project_Phone__c,Project_Email__c,Location__c,Sublocation__c,city__c,state__c from Project__c where Id =: booking.Project_Name__c];
        }
        
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
        
        if(project <> null)
        {
            contentDoc = [select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId =: project.Id];
            
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
        
        if(addOnList.size() <> 0)
        {
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
                    noOf2WheelerParking += adon.No_Of_Unit__c;
                }
            }
        }
        
    }

}