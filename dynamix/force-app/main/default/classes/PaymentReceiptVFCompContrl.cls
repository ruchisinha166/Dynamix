public class PaymentReceiptVFCompContrl {
    
    public Id PMId;
    public List<Booking__c> booking{get;set;}
    public Project__c project{get;set;}
    public Payment__c pay{get;set;}
    Public string ProjectHeader{get;set;}
    Public string ProjectFooter{get;set;}
    public String getPMId() {
            return PMId;
        }
        
        public void setPMId(String s) {
            PMId= s;
            init();
        }
              
        public void init(){
            
            system.debug('PMId'+ PMId);
            
            if(PMId <> null){
                
              	
                booking = [select Primary_Applicant__r.Name,Tower_Name__r.Name,Property_Name__c,Project_Name__c,Project_Name__r.Name from booking__c where id =: PMId];
                
                if(booking!=null && booking[0].Project_Name__c != null){
                    
                project = [select Id,Name,Builder_Organization__r.name,Project_Header__c,Project_Footer__c,Postal_Code__c,Location__c,Sublocation__c,City__c,State__c,Project_Email__c,Project_Phone__c from Project__c where Id =:booking[0].Project_Name__c ];//'a0K9D000003MLxXUAW'
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