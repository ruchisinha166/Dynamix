public class GeneratePublicURL {
   public static void generatePublicLink(Id contentDocumentId){
       system.debug('Trigger Hit');
        /* Getting ContentVersion file using ContentDocument Id */
       if(contentDocumentID!=null){
           
       List<ContentVersion> cvlst = [SELECT Id, Title, Document_Type__c, SObjectType__c,FirstPublishLocationId FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId order by CreatedDate desc limit 1 ];
       Set<Id> projectIds = new Set<Id>();
       Set<Id> propertyIds = new Set<Id>();
       
       system.debug('Cvlst>>' + cvlst);
       List<ContentDistribution> conDisList = new List<ContentDistribution>();
       for(ContentVersion cv:cvlst){
           system.debug('cv Found>>' + cv.Document_Type__c);
           if(cv.Document_Type__c=='Terms & Conditions' && cv.SObjectType__c == 'Project__c'){
               
               projectIds.add(cv.FirstPublishLocationId);
               system.debug('Proj Id>>' + projectIds);
               ContentDistribution conDis = new ContentDistribution();
               conDis.Name = cv.Title;
               conDis.ContentVersionId = cv.Id;
               conDis.PreferencesAllowViewInBrowser= true;
               conDisList.add(conDis);
           }
           if(cv.Document_Type__c=='Annexures' && cv.SObjectType__c=='Property__c'){
               propertyIds.add(cv.FirstPublishLocationId);
               system.debug('Prop Id>>' + propertyIds);
               
               ContentDistribution conDis = new ContentDistribution();
               conDis.Name = cv.Title;
               conDis.ContentVersionId = cv.Id;
               conDis.PreferencesAllowViewInBrowser= true;
               conDisList.add(conDis);
       }
           else{
               system.debug('Different File Uploaded');
           }
       }
       insert conDisList;
       List<ContentDistribution> ContentDistributionList =[SELECT id, Name , DistributionPublicUrl FROM ContentDistribution Where id In :conDisList];
       
       if (!projectIds.isEmpty()){
           Project__c proj = [Select Id, Name, Terms_Conditions__c From Project__c Where Id IN :projectIds];
           system.debug('Proj Found>>' + proj.Id);
           proj.Terms_Conditions__c = ContentDistributionList[0].DistributionPublicUrl;
           update proj;
       }
       
       if(!propertyIds.isEmpty()){
           Property__c prop = [Select Id, Name, Annexures__c From Property__c Where ID IN :propertyIds];
           system.debug('Proj Found>>' + prop.Id);
           prop.Annexures__c = ContentDistributionList[0].DistributionPublicUrl;
           update prop;
       }
       }
       
    }
}