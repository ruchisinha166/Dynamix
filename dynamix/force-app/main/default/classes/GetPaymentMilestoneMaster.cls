public class GetPaymentMilestoneMaster {
    @AuraEnabled(cacheable=true)
    public static list<Milestone_Master__c> fetchMilestoneData(string searchKey ) {    
        List <Milestone_Master__c > returnList = new List <Milestone_Master__c> ();
        string sWildCardText = '%' + searchKey + '%';
        List<Milestone_Master__c> milestoneList = [Select Id,Name From Milestone_Master__c  Where Name Like : sWildCardText];
        if(!milestoneList.IsEmpty()){
            for (Milestone_Master__c obj: milestoneList) {
                returnList.add(obj);
            }
        }
           
        return returnList;     
        
    }
}