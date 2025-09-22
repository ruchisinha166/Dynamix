public class BrokerageHandler {
    public class ProjectWrapper {
        @AuraEnabled public List<Project__c> availableProjects;
        @AuraEnabled public String selectedProjectJson;
    }
    @AuraEnabled(cacheable=true)
    public static ProjectWrapper getProjectData(String brokerageSchemeId) {
        ProjectWrapper wrapper = new ProjectWrapper();
        wrapper.availableProjects = new List<Project__c>(); 
        AOP_Ladder__c ba = [SELECT Id, Project_Details__c, Name 
                                                          FROM AOP_Ladder__c            
                                                          WHERE Id = :brokerageSchemeId
                                                          LIMIT 1
                                                         ];
        wrapper.availableProjects = [
            SELECT Id,Name
            FROM Project__c
        ];
        wrapper.selectedProjectJson = ba.Project_Details__c;
        return wrapper;
    }
    @AuraEnabled
    public static void saveSelectedProjects(String brokerageSchemeId, String projectJson) {
        AOP_Ladder__c ba = new AOP_Ladder__c(
            Id = brokerageSchemeId,
            Project_Details__c = projectJson
        );
        update ba;
    }
}