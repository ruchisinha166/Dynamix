public with sharing class GenerateCostSheet {
    public boolean data;
    @InvocableMethod(label='Generate Cost Sheet')
    public static List<String> execute( List<Requests> requestLst){
        
        return new List<String> {generateCS(requestLst[0].propertyId)};
            }
    
    public static String generateCS(String pId){
        
        ContentVersion conVer;
        list<ContentDocumentLink> contentDocList = new list<ContentDocumentLink>();
        list<ContentVersion> ContentVersionList =new  list<ContentVersion>();
        String contentId='';
        string whereCausLike;
        list<Id> ContentDocId = new list<Id>();
        List<user> collaborators = new List<user>();
        list<ContentDocumentLink> conDocList = new list<ContentDocumentLink>();
        list<ContentDocumentLink> conDocListC = new list<ContentDocumentLink>();
        
        Suggested_Property__c sp = [SELECT Id, Name, Discount__c,Cost_Sheet_Provided__c, Opportunity__c,Unit__r.Tower__r.Name,Unit__r.Property_Status__c, Payment_Plan__c,
                                    Unit__r.Property_Price_Slab__c, Unit__r.Flat_Type__c, Unit__r.Name,Site_Head__c, Payment_Plan_Detail__c 
                                    FROM Suggested_Property__c WHERE Id =: pId];
        collaborators = [select id from user where ((id=: sp.Site_Head__c OR Profile.Name = 'System Administrator')AND (id !=: UserInfo.getUserId()) AND IsActive=true)];
        List<ContentDocumentLink> cDLLst = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =: sp.Opportunity__c];
        
        PageReference ref = Page.CostSheet;
        ref.getParameters().put('id',sp.id);
        ref.getParameters().put('customp',String.valueof(sp.Cost_Sheet_Provided__c));
        
        Blob body; 
        if(Test.isRunningTest()){
            body = Blob.valueOf('Cost Sheet');
        }
        else{
            body = ref.getContent();
        }
        
        String unitName;
        if(sp.Unit__r.Name.length() < 4)
        {
            unitName = 0 + sp.Unit__r.Name;
        }
        else{
            unitName = sp.Unit__r.Name;
        }
        if(sp.Unit__r.Tower__r.Name <> null && unitName <> null && sp.Name <> null)
        {
            whereCausLike = 'Cost Sheet/'+sp.Unit__r.Tower__r.Name.left(3) + '/' + unitName  +'/'+'%';  
        } 
        contentDocList =[select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:sp.Opportunity__c];
        system.debug('===> contentDocList ' + contentDocList );
        if(contentDocList.size()>0)
        {
            for(ContentDocumentLink cd :contentDocList)
            {   
                ContentDocId.add(cd.ContentDocumentId);
            }
            ContentVersionlist =[SELECT ContentDocumentId,VersionData,isMajorVersion,PathOnClient,CreatedDate FROM ContentVersion where Title Like: whereCausLike and ContentDocumentId IN :ContentDocId];
        }
        if(ContentVersionlist.size()>0)
        {
            conVer =new ContentVersion(); 
            conVer.ContentLocation = 'S'; 
            conVer.PathOnClient = 'Cost Sheet/'+sp.Unit__r.Tower__r.Name.left(3) + '/' + unitName + '/' + sp.Name.right(4) + cDLLst.size() +'.pdf'; 
            conVer.Title = 'Cost Sheet/'+sp.Unit__r.Tower__r.Name.left(3) + '/' + unitName  + '/' + sp.Name.right(4) + cDLLst.size() +'.pdf';
            conVer.VersionData = body;
            conVer.SObjectType__c = 'Opportunity';
            conVer.Document_Type__c = 'Cost Sheet';
            conVer.ContentDocumentId=ContentVersionlist[0].ContentDocumentId;
            insert conVer;
            system.debug('test'+conVer);
            contentId = conVer.ContentDocumentId;
            try{
                ContentDistribution newDist = new ContentDistribution();
                newDist.ContentVersionId = conVer.id;
                newDist.Name = 'Cost Sheet/'+sp.Unit__r.Tower__r.Name.left(3) + '/' + unitName + '/' + sp.Name.right(4) + cDLLst.size();
                newDist.PreferencesAllowViewInBrowser = true;
                newDist.RelatedRecordId = conVer.FirstPublishLocationId;
                insert newDist;
                
                List<ContentDistribution> ContentDistributionList =[SELECT id, RelatedRecordId, Name,ContentDownloadUrl, DistributionPublicUrl 
                                                                    FROM ContentDistribution
                                                                    WHERE ContentVersionId = :conVer.id];
                Suggested_Property__c suggestedProperty = New Suggested_Property__c();
                suggestedProperty.id = pId;
                system.debug('pId'+pId);
                suggestedProperty.Cost_Sheet_Link__c = ContentDistributionList[0].DistributionPublicUrl;
                suggestedProperty.Lock_Record__c = true;
                update suggestedProperty;            }
            catch(Exception ex)
            {
                System.debug('Error--- ' +ex.getMessage()+ ' LineNumber- '+ex.getlineNumber());
                
            }
            
        }
        
        else
        {
            conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; 
            conVer.PathOnClient = 'Cost Sheet/'+sp.Unit__r.Tower__r.Name.left(3) + '/' + unitName + '/' + sp.Name.right(4) + cDLLst.size() +'.pdf'; 
            conVer.Title = 'Cost Sheet/'+sp.Unit__r.Tower__r.Name.left(3) + '/' + unitName  + '/' + sp.Name.right(4) + cDLLst.size() +'.pdf';
            conVer.VersionData = body;
            conVer.SObjectType__c = 'Opportunity';
            conVer.Document_Type__c = 'Cost Sheet';
            conVer.isMajorVersion=false;
            Insert conVer;
            ContentVersion contentverlink = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :conVer.Id LIMIT 1];
            
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId = sp.Opportunity__c; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
            conDocLink.ContentDocumentId = contentverlink.ContentDocumentId;  //ContentDocumentId Id from ContentVersion
            conDocLink.shareType = 'V';
            conDocList.add(conDocLink);
            
            for(user uId : collaborators)
            {
                ContentDocumentLink conDocLinkC = New ContentDocumentLink();
                conDocLinkC.LinkedEntityId = uId.id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                conDocLinkC.ContentDocumentId = contentverlink.ContentDocumentId;  //ContentDocumentId Id from ContentVersion
                conDocLinkC.shareType = 'C';
                conDocList.add(conDocLinkC); 
            }                             
            insert conDocList; 
            contentId = contentverlink.ContentDocumentId;
            try{
                ContentDistribution newDist = new ContentDistribution();
                newDist.ContentVersionId = conVer.id;
                newDist.Name = 'Cost Sheet/'+sp.Unit__r.Tower__r.Name.left(3) + '/' + unitName + '/' + sp.Name.right(4) + cDLLst.size();
                newDist.PreferencesAllowViewInBrowser = true;
                newDist.RelatedRecordId = conVer.FirstPublishLocationId;
                insert newDist;
                
                List<ContentDistribution> ContentDistributionList =[SELECT id, RelatedRecordId, Name,ContentDownloadUrl, DistributionPublicUrl 
                                                                    FROM ContentDistribution
                                                                    WHERE ContentVersionId = :conVer.id];
                Suggested_Property__c suggestedProperty = New Suggested_Property__c();
                suggestedProperty.id = pId;
                system.debug('pId'+pId);
                suggestedProperty.Cost_Sheet_Link__c = ContentDistributionList[0].DistributionPublicUrl;
                suggestedProperty.Lock_Record__c = true;
                update suggestedProperty;
            }
            catch(Exception ex)
            {
                System.debug('Error--- ' +ex.getMessage()+ ' LineNumber- '+ex.getlineNumber());
            }
        }
        
        return contentId;
    }
    
    public class Requests {
        @InvocableVariable(label='Suggested Property Id' required=true)
        public String propertyId;
        
        @InvocableVariable(label='Discount')
        public Decimal discount;
        
        @InvocableVariable(label='Payment Plan' required=true)
        public String paymentPlanId;
        
        
    }
}