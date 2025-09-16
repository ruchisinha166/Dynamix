public class WelcomeEmailController {
    
    public Id bookingId;
    public Booking__c booking{get;set;}
    public Account account{get;set;}
    public List<Co_Applicant__c> coapplicantList{get;set;}
    public List<ContentDocumentLink> contentDoc {get;set;}
    public List<ContentVersion> contentVerObject{get;set;}
    public string coapplicantNames{get;set;}
    public Project__c project{get;set;}
    Public User currentUser{get;set;}
    Public string ProjectHeader{get;set;}
    Public string ProjectFooter{get;set;}
    public String imageURLT{get;set;}
    public String imageURLB{get;set;}
    public String sfdcBaseURL{get;set;}
    public List< document > documentList{get;set;}
    public String getbookingId() 
    {
        return bookingId;
    }
    public void setbookingId(String s) 
    {
        bookingId= s;
        init();
    }
    
    public void init(){
        
        string coapplicantNames = '';
        if(bookingId <> null)
        {
            booking = [select Id,Project_Name__r.Name,Booking_Date__c,Agreement_Value__c,Property_Name__c,Registration_Date__c,GST__c,Payment_Received_GST__c,Payment_Received_Unit__c,Payment_Milestones_Total_Amount__c,Payment_Milestones_Total_GST__c,Tower_Name__c,Tower_Name__r.Tower_Initials__c,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.Name from booking__c where id =: bookingId];
            account = [select id,Phone,salutation,PersonMobilePhone,PersonOtherPhone,name,PersonEmail from account where id = : booking.Primary_Applicant__c];
            coapplicantList = [select name,Account__r.name,Account__r.salutation from Co_Applicant__c where (Booking__c =: booking.id AND Role__c =: 'Co-Applicant')];    
            currentUser = [SELECT ID, Name FROM User WHERE ID = :UserInfo.getUserId()];
            for(Co_Applicant__c ca : coapplicantList)
            {
                if(coapplicantNames == '')
                {
                    coapplicantNames = ca.Account__r.salutation+' '+ca.Account__r.name;
                }
                else
                {
                    coapplicantNames = coapplicantNames+','+ca.Account__r.salutation+' '+ca.Account__r.name; 
                } 
            }
        }
        
        if(booking!=null && booking.Project_Name__c != null){
            project = [select Id,Project_Header__c,Project_Footer__c,Name,Builder_Organization__r.name,Postal_Code__c,Location__c,Sublocation__c,City__c,State__c,Project_Email__c,Project_Phone__c from Project__c where Id =:booking.Project_Name__c ];
        } 
        
        if(project <> null)
        {
            if(booking!=null && booking.Project_Name__c != null){
                    
               // project = [select Id,Name,Builder_Organization__r.name,Project_Header__c,Project_Footer__c,Postal_Code__c,Location__c,Sublocation__c,City__c,State__c,Project_Email__c,Project_Phone__c from Project__c where Id =:booking.Project_Name__c ];//'a0K9D000003MLxXUAW'
                if(project.Project_Header__c!='')
                {
                    ProjectHeader=project.Project_Header__c; 
                }
                if(project.Project_Footer__c!='')
                {
                    ProjectFooter =project.Project_Footer__c; 
                }
            }

        }
        
    }
  
}