public class PmtNotifiVfCompContrl {

    public Id PMId;
    
    public String getPMId() 
    {
        return PMId;
    }
    public void setPMId(String s) 
    {
        PMId= s;
        init();
    }
    
    public void init(){
        
        if(PMId <> null)
        {
            
           payment__c pay = [select id from payment__c where id =: PMId];
            
        }
    }
}