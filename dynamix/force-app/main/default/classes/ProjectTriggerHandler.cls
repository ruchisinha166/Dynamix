public class ProjectTriggerHandler {
    public static void generateCIFFormLink(List<Project__c> newProjectList) {
        Set<id> projectIdSet =New Set<id>();
        for(Project__c thisProject : newProjectList)
        {
            projectIdSet.add(thisProject.id);
        }
        List<Project__C> projectList =[SELECT id, name, Project_URL__c FROM Project__C WHERE id IN: projectIdSet];
        Site mySite = [select Id from Site where Name = 'OpportunityForm'];
        SiteDetail mySiteDetail = [select SecureURL from SiteDetail where DurableId = :mySite.Id];
        System.debug(mySiteDetail.SecureURL);
        
        List<Project__c> updateProjectList = new List<Project__c>();
        for (Project__c thisProject : projectList) {
            String formLink = mySiteDetail.SecureURL+'?id='+thisProject.Id;
            system.debug('formLink'+formLink);
            thisProject.Project_URL__c = formLink;
            updateProjectList.add(thisProject);
        }
        
        if (!updateProjectList.isEmpty()) {
            update updateProjectList;
        }
    }
}