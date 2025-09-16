@isTest
public class ProjectTriggerHandler_Test {
    @isTest  
    public static void generateCIFFormLink_Method(){
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'nishi@manras.com';
        projectObject.Budgets__c = 'above 3.5 crs';
        projectObject.Configuration__c = '1 BHK;2.5 BHK';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK;600 - 2 BHK;900 - 3 BHk	';
        insert projectObject;
    }
}