public class SDRPaymentReminderVFCompContrl {
    public Id bookingId;
    public List<Booking__c> bookingList{get;set;}
    public Project__c project{get;set;}
    public Payment__c pay{get;set;}
    Public string ProjectHeader{get;set;}
    Public string ProjectFooter{get;set;}
    public String getbookingId() {
        return bookingId;
    }
    
    public void setbookingId(String s) {
        bookingId= s;
        init();
    }
    
    public void init(){        
        system.debug('bookingId'+ bookingId); 
        //bookingId='a0CC4000007DcrUMAS';
        if(bookingId != null){           
            
            bookingList = [select Primary_Applicant__r.Name,Tower_Name__r.Name,Property_Name__c,Project_Name__c,Project_Name__r.Name from booking__c where id =: bookingId];
            
            if(bookingList!=null && bookingList[0].Project_Name__c != null){
                
                project = [select Id,Name,Builder_Organization__r.name,Project_Header__c,Project_Footer__c,Postal_Code__c,Location__c,Sublocation__c,City__c,State__c,Project_Email__c,Project_Phone__c from Project__c where Id =:bookingList[0].Project_Name__c ];//'a0K9D000003MLxXUAW'
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