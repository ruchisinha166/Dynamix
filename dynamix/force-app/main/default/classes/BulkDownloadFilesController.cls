public with sharing class BulkDownloadFilesController {
    
    @AuraEnabled
    public static List <ContentVersion> fetchRelatedFiles(Id recordId,String docType) {
        try {
            System.debug('recordId:===>'+recordId);
            System.debug('docType:===>'+docType);
            
            Set<Id> contentDocumentIds = new Set<Id>();
            //List<Id> contentVersionIds = new List<Id>();
            List<ContentVersion> contentVersionList = new List<ContentVersion>();
            
            if(String.isNotBlank(recordId)) {
                List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
                contentDocumentLinkList= [SELECT ContentDocumentId,LinkedEntityId,ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:recordId];
                if(contentDocumentLinkList.size()>0){
                    for(ContentDocumentLink cdl :contentDocumentLinkList) {
                        contentDocumentIds.add(cdl.ContentDocumentId);
                    }
                }
            }
            if(contentDocumentIds.size() > 0) {
                
                contentVersionList=[SELECT Id,Document_Type__c,Title,CreatedDate,FileType FROM ContentVersion WHERE isLatest = true AND Document_Type__c=:docType AND ContentDocumentId IN :contentDocumentIds ORDER BY CreatedDate ASC];
                /*  if(contentVersionList.size()>0){
for(ContentVersion cdv : contentVersionList) {
contentVersionIds.add(cdv.Id);
}
}*/
            }
            // System.debug('contentVersionIds:===>'+contentVersionIds); 
            // return contentVersionIds;    
            System.debug('contentVersionList:===>'+contentVersionList); 
            return contentVersionList;  
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}