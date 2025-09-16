public class ContentVersionTriggerHandler {
    public static Boolean reraCertificateFlag = false;
    public static Boolean projectIntimationofCompletionFlag = false;
    public static void ReraCertificateDocumentsUploadedCheckbox(List<ContentVersion> listOfContentDocumentLink){
        
        List<Account> accountList = new List<Account>(); 
        List<ContentVersion> converList = [Select Id,Document_Type__c,FirstPublishLocationId from ContentVersion Where Id IN:listOfContentDocumentLink];
        for(ContentVersion ContentDocumentLinkObj : converList){
            if(ContentDocumentLinkObj.Document_Type__c == 'Rera Certificate' && ContentDocumentLinkObj.FirstPublishLocationId != null){
                String objectName = ContentDocumentLinkObj.FirstPublishLocationId.getSObjectType().getDescribe().getName();
                if( objectName == 'Account')
                {
                    Account acc = New Account();
                    acc.Rera_Certificate_Upload__c =  true;
                    acc.id = ContentDocumentLinkObj.FirstPublishLocationId;
                    accountList.add(acc);
                }
            }
        }
        if(!accountList.isEmpty())
        {
            update accountList;
        }
        
    }
    public static void projectIntimationofCompletionofUnitCheckCheckbox(List<ContentVersion> listOfContentDocumentLink){
        
        List<Project__c> projectList = new List<Project__c>(); 
        List<Booking__c> bookingList = new List<Booking__c>(); 
        List<ContentDocumentLink> insertContentDocumentLink = New List<ContentDocumentLink>();
        List<ContentDistribution> insertContentDistribution = New List<ContentDistribution>();
        
        List<ContentVersion> converList = [Select Id,Document_Type__c,FirstPublishLocationId from ContentVersion Where Id IN:listOfContentDocumentLink];
        for(ContentVersion ContentDocumentLinkObj : converList){
            if(ContentDocumentLinkObj.Document_Type__c == 'Intimation of Completion of Unit Check' && ContentDocumentLinkObj.FirstPublishLocationId != null){
                String objectName = ContentDocumentLinkObj.FirstPublishLocationId.getSObjectType().getDescribe().getName();
                if( objectName == 'Project__c')
                {
                    Project__c project = New Project__c();
                    project.Intimation_of_Completion_of_Unit_Check__c =  true;
                    project.id = ContentDocumentLinkObj.FirstPublishLocationId;
                    projectList.add(project);
                }
            }
            if(ContentDocumentLinkObj.Document_Type__c == 'EOI Terms & Conditions' && ContentDocumentLinkObj.FirstPublishLocationId != null){
                String objectName = ContentDocumentLinkObj.FirstPublishLocationId.getSObjectType().getDescribe().getName();
                if( objectName == 'Project__c')
                {
                    ContentDistribution conDis = new ContentDistribution();
                    conDis.Name = 'EOI';
                    conDis.ContentVersionId = ContentDocumentLinkObj.Id;
                    conDis.PreferencesAllowViewInBrowser= true;
                    insertContentDistribution.add(conDis);
                }
            }
            if(ContentDocumentLinkObj.Document_Type__c == 'CA Terms & Conditions' && ContentDocumentLinkObj.FirstPublishLocationId != null){
                String objectName = ContentDocumentLinkObj.FirstPublishLocationId.getSObjectType().getDescribe().getName();
                if( objectName == 'Project__c')
                {
                    ContentDistribution conDis = new ContentDistribution();
                    conDis.Name = 'CA';
                    conDis.ContentVersionId = ContentDocumentLinkObj.Id;
                    conDis.PreferencesAllowViewInBrowser= true;
                    insertContentDistribution.add(conDis);
                }
            }
             if(ContentDocumentLinkObj.Document_Type__c == 'CA Terms & Conditions' && ContentDocumentLinkObj.FirstPublishLocationId != null){
                String objectName = ContentDocumentLinkObj.FirstPublishLocationId.getSObjectType().getDescribe().getName();
                if( objectName == 'Property')
                {
                    ContentDistribution conDis = new ContentDistribution();
                    conDis.Name = 'CA';
                    conDis.ContentVersionId = ContentDocumentLinkObj.Id;
                    conDis.PreferencesAllowViewInBrowser= true;
                    insertContentDistribution.add(conDis);
                }
            }
            if(ContentDocumentLinkObj.Document_Type__c == 'NDC' && ContentDocumentLinkObj.FirstPublishLocationId != null)
            {
                String objectName = ContentDocumentLinkObj.FirstPublishLocationId.getSObjectType().getDescribe().getName();
                
                if( objectName == 'Booking__c')
                {
                    Booking__c booking = New Booking__c();
                    booking.NDC_Received__c =  true;
                    booking.id = ContentDocumentLinkObj.FirstPublishLocationId;
                    bookingList.add(booking);
                    
                } 
            }
            /*  if(ContentDocumentLinkObj.Document_Type__c == 'Copy of the Signed Customer Snag List' && ContentDocumentLinkObj.FirstPublishLocationId != null)
{
String objectName = ContentDocumentLinkObj.FirstPublishLocationId.getSObjectType().getDescribe().getName();

if( objectName == 'Booking__c')
{
ContentDocumentLink cdl = new ContentDocumentLink();
cdl.ContentDocumentId = ContentDocumentLinkObj.ContentDocumentId;
cdl.ShareType = 'I';
cdl.Visibility = 'AllUsers';
cdl.LinkedEntityId = ContentDocumentLinkObj.FirstPublishLocationId; //Magic happens here
insertContentDocumentLink.add(cdl);
// insert cdl;
} 
}*/
            
            
        }
        
        if(!bookingList.isEmpty())
        {
            update bookingList;
        }
        if(!insertContentDocumentLink.isEmpty())
        {
            // update insertContentDocumentLink;
        }
        System.debug('insertContentDistribution--'+insertContentDistribution);
        if(!insertContentDistribution.isEmpty())
        {
            insert insertContentDistribution;
            List<ContentDistribution> ContentDistributionList =[SELECT id, Name,ContentVersionId, DistributionPublicUrl FROM ContentDistribution Where id In :insertContentDistribution];
            Map<Id,ContentDistribution> MapOFCD = New Map<Id,ContentDistribution>();
            for(ContentDistribution thisCD :ContentDistributionList)
            {
                MapOFCD.put(thisCD.ContentVersionId,thisCD);
            }
            System.debug('MapOFCD--'+MapOFCD);
            for(ContentVersion ContentDocumentLinkObj : converList){
                if(ContentDocumentLinkObj.Document_Type__c == 'EOI Terms & Conditions' && ContentDocumentLinkObj.FirstPublishLocationId != null){
                    String objectName = ContentDocumentLinkObj.FirstPublishLocationId.getSObjectType().getDescribe().getName();
                    if( objectName == 'Project__c')
                    {
                        if(MapOFCD.containsKey(ContentDocumentLinkObj.id)){
                            Project__c project = New Project__c();
                            if(MapOFCD.get(ContentDocumentLinkObj.id).Name == 'EOI')
                            {
                                project.EOI_Terms_Conditions__c =  MapOFCD.get(ContentDocumentLinkObj.id).DistributionPublicUrl;
                            }
                            if(MapOFCD.get(ContentDocumentLinkObj.id).Name == 'CA')
                            {
                                project.CA_Terms_Conditions__c =  MapOFCD.get(ContentDocumentLinkObj.id).DistributionPublicUrl;
                            }
                            
                            project.id = ContentDocumentLinkObj.FirstPublishLocationId;
                            projectList.add(project);
                        }
                    }
                }
                if(ContentDocumentLinkObj.Document_Type__c == 'CA_Terms_Conditions__c' && ContentDocumentLinkObj.FirstPublishLocationId != null){
                    String objectName = ContentDocumentLinkObj.FirstPublishLocationId.getSObjectType().getDescribe().getName();
                    if( objectName == 'Project__c')
                    {
                        if(MapOFCD.containsKey(ContentDocumentLinkObj.id)){
                            Project__c project = New Project__c();
                            project.CA_Terms_Conditions__c =  MapOFCD.get(ContentDocumentLinkObj.id).DistributionPublicUrl;
                            project.id = ContentDocumentLinkObj.FirstPublishLocationId;
                            projectList.add(project);
                        }
                    }
                }
            }
            
        }
        if(!projectList.isEmpty())
        {
            update projectList;
        }
        
    }
    public static void updateCancellationDeedDate(List<ContentVersion> contentVersionList){
        List<Booking__c> bookingToUpdate = new List<Booking__c>();
        List<ContentVersion> converList = [Select Id,Document_Type__c,FirstPublishLocationId,CreatedDate from ContentVersion Where Id IN:contentVersionList];
        for(ContentVersion conver : converList){
            if(conver.Document_Type__c == 'Cancellation Deed' && conver.FirstPublishLocationId != null){
                String objectName = conver.FirstPublishLocationId.getSObjectType().getDescribe().getName();
                if(objectName == 'Booking__c'){
                    Booking__c book = new Booking__c();
                    book.Id = conver.FirstPublishLocationId;
                    book.Cancellation_Deed_Date__c = Date.valueOf(conver.CreatedDate);
                    bookingToUpdate.add(book);
                }
            }
        }
        if(!bookingToUpdate.isEmpty()){
            update bookingToUpdate;
        }
    }
}