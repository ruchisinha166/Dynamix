public class indemnityLetterExtension {
    
    public Booking__c booking{get;set;}
    public List<Suggested_Property__c> property{get;set;}
    public Property__c properties{get;set;}
    public list<Co_Applicant__c> coapplicant{get;set;}
    public string coApplicantName{get;set;}
    public string coApplicantAge{get;set;}
    public string coApplicantAdr{get;set;}
    public string coApplicantPan{get;set;}
    public List<ContentDocumentLink> contentDoc {get;set;}
    public List<ContentVersion> contentVerObject{get;set;}
    Public id ProjectHeader{get;set;}
    Public id ProjectFooter{get;set;}
    public string floorSub{get;set;}
    
    public indemnityLetterExtension(ApexPages.StandardController controller)
    {
        String sBookingId = ApexPages.CurrentPage().getparameters().get('id');
       // String sBookingId = 'a0C5g000001F4ZAEA0';
        
        booking = [select Id,Tower_Name__c,Primary_Applicant__r.PersonMailingCity,Primary_Applicant__r.PersonMailingStreet,Primary_Applicant__r.PersonMailingCountry,Primary_Applicant__r.PersonMailingState,Primary_Applicant__r.PersonMailingPostalCode,Primary_Applicant__r.PAN_No__pc,Primary_Applicant__r.Aadhar_No__pc,Primary_Applicant__r.age__c,Project_Name__r.Location__c,Project_Name__r.City__c,Project_Name__r.state__c,Project_Name__r.Sublocation__c,Project_Name__r.Postal_Code__c,Project_Name__r.name,Project_Name__r.Builder_Organization__r.Street__c,Project_Name__r.Builder_Organization__r.PIN_Code__c,Project_Name__r.Builder_Organization__r.State__c,Project_Name__r.Builder_Organization__r.Country__c,Project_Name__r.Builder_Organization__r.name,Project_Name__r.Builder_Organization__r.city__c,Registration_Date__c,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Tower_Name__r.Tower_Initials__c,Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.Name,Related_Suggested_Property__c,Agreement_Value__c,Booking_Date__c from Booking__c where Id =: sBookingId];
        
        if(booking <> null)
        {
            property = [select Id,Unit__c from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
            properties = [select Id,Name,Floor__c from Property__c where Id =: property[0].Unit__c];
            coapplicant = [select id,Account__r.name,Account__r.age__c,Account__r.Aadhar_No__pc,Account__r.PAN_No__pc from Co_Applicant__c where (Booking__c =: sBookingId AND role__c =: 'Co-Applicant') ORDER BY Account__r.name DESC];
            coApplicantName = '';
            coApplicantAge = '';
            coApplicantAdr = '';
            coApplicantPan = '';
            
            for(Co_Applicant__c cp : coapplicant)
            {
                coApplicantName = coApplicantName + cp.Account__r.name + ', aged '+cp.Account__r.age__c+' years, ';  
                coApplicantAge = coApplicantAge + cp.Account__r.age__c + ',';
                coApplicantAdr = coApplicantAdr + cp.Account__r.Aadhar_No__pc + ',';
                coApplicantPan = coApplicantPan + cp.Account__r.PAN_No__pc + ',';
            }
        }
        
        if(booking.Project_Name__c <> null)
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
        if(integer.valueof(properties.Floor__c) >= 11 && integer.valueof(properties.Floor__c) <= 13)
        {
            floorSub = 'th';
        }
        else if(math.mod(integer.valueof(properties.Floor__c), 10) == 1)
        {
            floorSub = 'st';
        }
        else if(math.mod(integer.valueof(properties.Floor__c), 10) == 2)
        {
            floorSub = 'nd';
        }
        else if(math.mod(integer.valueof(properties.Floor__c), 10) == 3)
        {
            floorSub = 'rd';
        }
        else
        {
            floorSub = 'th';
        }
    }
    
}