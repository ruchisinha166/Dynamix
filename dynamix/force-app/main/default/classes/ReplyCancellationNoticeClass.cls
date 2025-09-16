public class ReplyCancellationNoticeClass
{        
    public Id PMId;
   
     public String sfdcBaseURL{get;set;}
     public Suggested_Property__c sPropertyobj{get;set;}
    public Account accountObject{get;set;}
    public Booking__c booking{get;set;}
    //public Payment_Milestones__c payMilestone{get;set;}
    public Project__c project{get;set;}
    public List<Suggested_Property__c> property{get;set;}
    public User user{get;set;}
    public List<ContentDocumentLink> contentDoc {get;set;}
    public List<ContentVersion> contentVerObject{get;set;}
    Public id ProjectHeader{get;set;}
    Public id ProjectFooter{get;set;}
    public string AmountInWords{get;set;}
    public list<Co_Applicant__c> coApp{get;set;}
    public String coAppName{get;set;}
    Public id PaymentId{get;set;}
    Public boolean checkModeofPayment{get;set;}
    Public list<payment__c> paymentObj {get;set;}
    Public payment__c payment{get;set;}
    Public boolean paymentModeCheck{get;set;}
    public booking__c bookingObj{get;set;} 
    public List<booking__c> bookinglist{get;set;} 
        public String getPMId() {
            return PMId;
        }
        
        public void setPMId(String s) {
            PMId= s;
            init();
        }
              
        public void init(){
         sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
         sPropertyobj= new Suggested_Property__c();
            if(PMId!= null || PMId!= '')
            {
                bookinglist= [select Id,Cancel_or_Termination_date__c,Registration_Number__c,Booking_Date__c,Agreement_Value__c,Owner.ID,GST__c,Project_Name__c,Project_Name__r.Name, Payment_Received_GST__c,Payment_Received_Unit__c,Payment_Milestones_Total_Amount__c,Payment_Milestones_Total_GST__c,Tower_Name__c,Tower_Name__r.Tower_Initials__c,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Primary_Applicant__c,Primary_Applicant__r.Name,Related_Suggested_Property__c,Owner.phone,Owner.Name,Owner.Email from Booking__c where id=:PMId];
            }
            if(bookinglist.size()>0)
            {
                booking= bookinglist[0];
            }
            if(booking!=null)
            {
                sPropertyobj= [select Id,Unit__c,Unit__r.name,Unit__r.Project__c,Opportunity__r.Owner.Name,Unit__r.Floor__c,Payment_Plan__c,Payment_Plan__r.Name from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c]; 
                coApp = [select id,Applicant_Name__c,Booking__c from Co_Applicant__c where Booking__c=:booking.id];
                if(coApp.size()>0)
                {   
                    for(Co_Applicant__c  c:coApp)
                    {
                        coAppName = coAppName+c.Applicant_Name__c+',';
                    }
                    coAppName = coAppName.removeEnd(',');
                    
                }
            }
             if(booking!=null  && booking.Primary_Applicant__c != null ){
                accountObject = [select Id,PersonMobilePhone,Phone,PersonMailingStreet,PersonMailingCountry,PersonMailingCity,PersonMailingState,PersonMailingPostalCode from Account where Id =: booking.Primary_Applicant__c ];
            }
             if(booking!=null  && booking.Project_Name__c != null){
                project = [select Id,Name,Postal_Code__c,Project_Header__c,Project_Footer__c,Location__c,Sublocation__c,Builder_Organization__r.PAN_No__c,Builder_Organization__r.GST_No__c,Builder_Organization__r.IFSC_Code__c,Builder_Organization__r.Name,Builder_Organization__c,Builder_Organization__r.Bank_Account_Number__c,Builder_Organization__r.Bank_Name__c,Builder_Organization__r.Branch_Address__c,Builder_Organization__r.Branch_Name__c,Builder_Organization__r.GST_Bank_Account_Number__c,Builder_Organization__r.GST_Bank_Name__c,Builder_Organization__r.GST_Branch_Address__c,Builder_Organization__r.GST_IFSC_Code__c,City__c,State__c,Project_Email__c from Project__c where Id =: booking.Project_Name__c];
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