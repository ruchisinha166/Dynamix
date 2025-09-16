trigger SetTrueArchitectureCertificate on ContentVersion (after update) {
    List<Id> AadharConDocIDs = New List<Id>();
    List<Id> PANConDocIDs = New List<Id>();
    List<ID> cvIDs = new List<ID>();
    List<ID> SansLetterIds = new List<ID>();
    List<ID> indexIds = new List<ID>();
     List<ID> cId = new List<ID>();
    List<ID> snagAndDesnagIds = new List<Id>();
    List<ContentVersion > cvList = new List<ContentVersion >();
    List<ContentDistribution>condlist = new List<ContentDistribution>();
    List<ContentDocumentLink> cdlist = new List<ContentDocumentLink>();
    List<ContentDistribution> ContentDistributionlist  = new List<ContentDistribution>();
    list<project__c> projList = new  list<project__c>(); 
    list<id> contentDistributionID = new list<id>();  
    Id accountRecordTypeId ;        
    if(Trigger.isUpdate)
    {
        for(ContentVersion cv : trigger.New)
        {
            system.debug('cvvv==='+cv);
            if(cv.ContentDocumentId != null)
            {
                if(cv.Document_Type__c == 'Architecture Certificate')
                {
                    cvIDs.add(cv.ContentDocumentId); 
                }
                if(cv.Document_Type__c =='Aadhar'){
                    system.debug('Aadhar uploaded Successfully');
                    AadharConDocIDs.add(cv.ContentDocumentId);
                }
                if(cv.Document_Type__c =='PAN Card'){
                    system.debug('PAN uploaded Successfully');
                    PANConDocIDs.add(cv.ContentDocumentId);
                }
                if(cv.Document_Type__c =='Sanction Letter'){
                    SansLetterIds.add(cv.ContentDocumentId);
                }
                if(cv.Document_Type__c =='Index II Document'){
                
                    indexIds.add(cv.ContentDocumentId);
                }
                if(cv.Document_Type__c =='Snag/Desnag'){
                
                    snagAndDesnagIds.add(cv.ContentDocumentId);
                }
                if(cv.Document_Type__c == 'Project Footer' ||cv.Document_Type__c == 'Project Header')
                {
                    cvList.add(cv); 
                    system.debug('cv=='+cv);
                 }
            }
        }
        if(cvList.size()>0)
         {
             for(ContentVersion  cv:cvList)
             {
                 cId.add(cv.ContentDocumentId); 
                 ContentDistribution c = new ContentDistribution();
                 c.Name =  cv.Title;
                 c.ContentVersionId =  cv.Id;
                 c.PreferencesAllowViewInBrowser= true;
                 condlist.add(c); 
             }
             insert condlist;
             for(ContentDistribution  cd : condlist)
             {
                contentDistributionID.add(cd.id);     
             } 
         }
         if(cId.size()>0)
         {
             system.debug('cId=='+cId);   
             projList =[select id, Project_Header__c,Project_Footer__c from project__c]; 
             list<project__c> projListNew = new list<project__c>();
             list<ContentDistribution> ContentDistributionlist  = [select id,ContentDownloadUrl,ContentVersion.Document_Type__c from ContentDistribution  where id In: contentDistributionID];
             system.debug('ContentDistribution=='+ContentDistributionlist );
             
             list<ContentDocumentLink > condoclist=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId IN:cId]; 
             system.debug('condoclist=='+condoclist);  
             for(ContentDistribution cd: ContentDistributionlist)
             {
                 system.debug('cd=='+cd); 
                 for(ContentDocumentLink cdo: condoclist)
                 {
                     system.debug('cdo=='+cdo); 
                      for(project__c p :projList )
                     {
                         system.debug('p=='+ p); 
                        if(p.id==cdo.LinkedEntityId)
                        {
                             system.debug('p=='+ p); 
                             system.debug('cd.ContentVersion.Document_Type__c=='+ cd.ContentVersion.Document_Type__c);
                             if(cd.ContentVersion.Document_Type__c=='Project Header')
                             { 
                                 system.debug('inside project header=='); 
                                 p.Project_Header__c =cd.ContentDownloadUrl;
                                 projListNew.add(p); 
                             }
                             if(cd.ContentVersion.Document_Type__c=='Project Footer')
                             { 
                                 system.debug('inside project footer=='); 
                                 p.Project_Footer__c =cd.ContentDownloadUrl;
                                 projListNew.add(p); 
                             }
                        }                            
                     }
                 }
             }
             update projListNew;
         }
        Id AdrId;
        Id PanCardId;
        Id cvid;
        Id SansLetterid;
        Id indexId;
        Id snagAndDesnagId;
    
        Map<ID,ContentDocumentLink> AdrMapofParentID = new Map<ID,ContentDocumentLink>();
        Map<ID,ContentDocumentLink> PanMapofParentID = new Map<ID,ContentDocumentLink>();
        Map<ID,ContentDocumentLink> MapofParentID = new Map<ID,ContentDocumentLink>();
        Map<ID,ContentDocumentLink> MapofSansLetterParentID = new Map<ID,ContentDocumentLink>();
        Map<ID,ContentDocumentLink> MapofIndexId = new Map<ID,ContentDocumentLink>();
        Map<ID,ContentDocumentLink> MapofsnagAndDesnagId = new Map<ID,ContentDocumentLink>();
    
    
        if(cvIDs.size() > 0 )
        {
            cvid = cvIDs[0];
            cdlist = [select LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId = : cvid ];
        
            if(cdlist <> null){
                for(ContentDocumentLink cd : cdlist)
                {
                    MapofParentID.put(cd.LinkedEntityId,cd);
                }
            
                List<Project_Progress__c> PRlist = [select id,Architecture_Certificate__c from Project_Progress__c  where id  = : MapofParentID.keyset()];
                for(Project_Progress__c pr : PRlist)
                {
                    if(MapofParentID.containskey(pr.id))
                    {
                        pr.Architecture_Certificate__c = true;
                    }
                }
                if(PRlist.size() > 0)
                {
                    update PRlist;
                }
            }
        }
    
         if(!AadharConDocIDs.isEmpty()){
            AdrId = AadharConDocIDs[0];
            
            System.debug('AdrList'+AadharConDocIDs);
            
            List<ContentDocumentLink> Aadharcdlist = [select LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId =: AdrId];
            
            
            if(!Aadharcdlist.isEmpty()){
                for(ContentDocumentLink AdrCDLink : Aadharcdlist){
                    
                    AdrMapofParentID.put(AdrCDLink.LinkedEntityId,AdrCDLink);
                }
                System.debug('Aadhar list Id'+Aadharcdlist);
                accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                List<Account> AdrAccRecList = [Select Id,RecordtypeID,Aadhar_Uploaded__pc,PAN_Card_Uploaded__pc From Account Where Id =:AdrMapofParentID.keySet() and RecordtypeID=:accountRecordTypeId ];
                
                
                for(Account Acc: AdrAccRecList){
                    
                    if(AdrMapofParentID.containskey(Acc.Id))
                    {
                        System.debug('Update Aadhar Checkbox');
                        
                        Acc.Aadhar_Uploaded__pc = true;
                        
                    }
                }
                
                if(!AdrAccRecList.isEmpty()){
                    update AdrAccRecList;
                }
            }
        }
    
    
        if(!PANConDocIDs.isEmpty()){
            
            PANCardId = PANConDocIDs[0];
           
            System.debug('PanList'+PANConDocIDs);
            List<ContentDocumentLink> PANcdlist = [select LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId =: PANCardId];
            
            
            if(!PANcdlist.isEmpty()){
                for(ContentDocumentLink PanCDLink : PANcdlist){
                    
                    PanMapofParentID.put(PanCDLink.LinkedEntityId,PanCDLink);
                }
                
                System.debug('Pan list Id'+PANcdlist);
                accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                
                List<Account> PanAccRecList = [Select Id,Aadhar_Uploaded__pc,PAN_Card_Uploaded__pc From Account Where Id =:PanMapofParentID.keySet() and RecordtypeID=:accountRecordTypeId ];
                
                
                
                for(Account Acct: PanAccRecList){
                    
                    if(PanMapofParentID.containskey(Acct.Id))
                    {
                        System.debug('Update PAN Checkbox');
                        
                        Acct.PAN_Card_Uploaded__pc = true;
                       
                      
                    }
                }
                
                
                if(!PanAccRecList.isEmpty()){
                    update PanAccRecList;
                }
            }
        }
        
        if(SansLetterIds.size() > 0 )
        {
            SansLetterid = SansLetterIds[0];
            
                cdlist = [select LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId = : SansLetterid ];
            
                if(cdlist <> null){
                for(ContentDocumentLink cd : cdlist)
                {
                    MapofSansLetterParentID.put(cd.LinkedEntityId,cd);
                }
                
                List<Bank_Loan_Details__c> bankLoanlist = [select id,Sanction_Letter__c from Bank_Loan_Details__c where id  = : MapofSansLetterParentID.keyset()];
                
                for(Bank_Loan_Details__c bl : bankLoanlist)
                {
                    if(MapofSansLetterParentID.containskey(bl.id))
                    {
                        bl.Sanction_Letter__c = true;
                    }
                }
                
                if(bankLoanlist.size() > 0)
                {
                    update bankLoanlist;
                }
            }
            
        }
        
        if(indexIds.size() > 0 )
        {
            indexId = indexIds[0];
            
            cdlist = [select LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId = : indexId ];
            
            if(cdlist <> null){
                for(ContentDocumentLink cd : cdlist)
                {
                    MapofIndexId.put(cd.LinkedEntityId,cd);
                }
                
                List<Booking__c> Brlist = [select id,Index_II_Document__c from Booking__c where id  = : MapofIndexId.keyset()];
                for(Booking__c pr : Brlist)
                {
                    if(MapofIndexId.containskey(pr.id))
                    {
                        pr.Index_II_Document__c = true;
                    }
                }
                if(Brlist.size() > 0)
                {
                    update Brlist;
                }
            }
            
        }
    
        if(snagAndDesnagIds.size() > 0 )
        {
            snagAndDesnagId = snagAndDesnagIds[0];
        
            cdlist = [select LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId = : snagAndDesnagId ];
        
            if(cdlist <> null){
                for(ContentDocumentLink cd : cdlist)
                {
                    MapofsnagAndDesnagId.put(cd.LinkedEntityId,cd);
                }
            
                List<Booking__c> Brlist = [select id,Snag_Desnag__c from Booking__c where id  = : MapofsnagAndDesnagId.keyset()];
                for(Booking__c pr : Brlist)
                {
                    if(MapofsnagAndDesnagId.containskey(pr.id))
                    {
                        pr.Snag_Desnag__c = true;
                    }
                }
                if(Brlist.size() > 0)
                {
                    update Brlist;
                }
            }
        }
   } 
}