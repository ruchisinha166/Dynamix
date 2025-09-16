public class GenerateBookingCancellationChecklist {
    @InvocableMethod(label='Generate Booking Cancellation Checklist')
    public static List<String> execute(List<Request> Requests){
        ContentVersion conVer;
        list<ContentDocumentLink> contentDocList = new list<ContentDocumentLink>();
        list<ContentVersion> ContentVersionList =new  list<ContentVersion>();
        String contentId='';
        Set<Id> ContentDocId = new Set<Id>();
        list<ContentDocumentLink> conDocList = new list<ContentDocumentLink>();
        Blob body; 
        
        PageReference ref =  page.BookingCancellationChecklist;
        ref.getParameters().put('id',Requests[0].bookingId);
        
        if(Test.isRunningTest()){
            body = Blob.valueOf('BookingCancellationChecklist');
        }
        else{
            body = ref.getContent();
        }
        
        contentDocList =[select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:Requests[0].bookingId];
        
        if(contentDocList.size()>0)
        {
            for(ContentDocumentLink cd :contentDocList)
            {   
                if(cd.ContentDocumentId!=null){
                    ContentDocId.add(cd.ContentDocumentId);
                }
            }
            ContentVersionlist =[SELECT ContentDocumentId,Title,VersionData,isMajorVersion,Document_Type__c,PathOnClient,CreatedDate FROM ContentVersion where Title ='Booking Cancellation Checklist' AND Document_Type__c='Checklist - Booking Cancellation' AND ContentDocumentId IN :ContentDocId];
        }
        
        if(ContentVersionlist.size()>0)
        {     
            //update Booking Cancellation Checklist document
            ContentVersion contVersionRcd=ContentVersionlist[0];
            ContentVersion bookingCancelDocRcdForUpdate=new ContentVersion();
            PageReference ref1 = Page.BookingCancellationChecklist;
            
            bookingCancelDocRcdForUpdate.VersionData=body;
            bookingCancelDocRcdForUpdate.Id=contVersionRcd.Id;
            update bookingCancelDocRcdForUpdate;
            system.debug('bookingCancelDocRcdForUpdate'+bookingCancelDocRcdForUpdate);          
            contentId = contVersionRcd.ContentDocumentId;      
        }
        else
        {
            conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; 
            conVer.PathOnClient = 'Booking Cancellation Checklist' + '.pdf'; 
            conVer.Title = 'Booking Cancellation Checklist';
            conVer.VersionData = body;
            conVer.SObjectType__c = 'Booking__c';
            conVer.Document_Type__c = 'Checklist - Booking Cancellation';
            conVer.isMajorVersion=false;
            insert conVer;
            
            ContentVersion contentVersionRcd = [SELECT Id, Title, ContentDocumentId 
                                                FROM ContentVersion WHERE Id = :conVer.Id LIMIT 1];
            
            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = Requests[0].bookingId;
            contentlink.contentdocumentid = contentVersionRcd.contentdocumentid;
            contentlink.ShareType = 'V';
            insert contentlink;           
            contentId = contentVersionRcd.ContentDocumentId;
            
        }
        		system.debug('contentId:'+contentId);
        		return new List<String>{contentId};   
    }  
    public class Request {
        @InvocableVariable(label='Booking Id' required=true)
        public id bookingId;
    }
}