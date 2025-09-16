public class BatchForActiveEOICA implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, Name,Launch_CA_Period_s_Start_Date__c,Launch_CA_Period_s_End_Date__c,Minimum_amount_for_CA__c,Project_Email__c,
                                         Launch_EOI_Period_s_Start_Date__c,Launch_EOI_Period_s_End_Date__c,Minimum_amount_for_EOI__c
                                         FROM Project__c WHERE Launch_EOI_Period_s_End_Date__c  <: System.today() OR Launch_CA_Period_s_End_Date__c <: System.today()
                                        OR  Launch_EOI_Period_s_Start_Date__c  =: System.today() OR Launch_CA_Period_s_Start_Date__c =: System.today()]);
    }
    
    public void execute(Database.BatchableContext bc, List<Project__c> projectList)
    {       
        System.debug('projectList'+projectList);
        List<Project__c>  updateProjectList = New  List<Project__c> ();
        for(Project__c thisProject: projectList){
          Project__c Project = New Project__c();
            Project.id = thisProject.id;
            if(thisProject.Launch_EOI_Period_s_End_Date__c < system.today())
            {
                Project.EOI__c = false;
            }
            if(thisProject.Launch_CA_Period_s_End_Date__c < system.today())
            {
                Project.CA__c = false;
            }
            if(thisProject.Launch_EOI_Period_s_Start_Date__c == system.today())
            {
                Project.EOI__c = true;
            }
            if(thisProject.Launch_CA_Period_s_Start_Date__c == system.today())
            {
                Project.CA__c = true;
            }
            updateProjectList.add(Project);
        }
        if(!updateProjectList.isEmpty())
        {
            update updateProjectList;
        }
    }
        
        
      
    
    public void finish(Database.BatchableContext bc)
    {
    }
}