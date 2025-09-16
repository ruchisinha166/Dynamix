public class BookingFormSubmitMsgController {
    Public String recordId {get;set;}
    Public String submittedBy {get;set;}
    Public BookingFormSubmitMsgController() {
        System.debug('Inside Booking Form Submit');
        recordId=ApexPages.currentPage().getParameters().get('Id'); 
        submittedBy=ApexPages.currentPage().getParameters().get('submittedBy'); 
        System.debug('BookingFormSubmitMsgController recordId:'+recordId);
    }
    public void saveBookingFormDocument(){
        if(submittedBy=='customer'){
            String bookingRecordId=recordId;
            ContentVersion conVer;
            list<ContentDocumentLink> contentDocList = new list<ContentDocumentLink>();
            list<ContentVersion> ContentVersionList =new  list<ContentVersion>();
            String contentId='';
            Set<Id> ContentDocId = new Set<Id>();
            list<ContentDocumentLink> conDocList = new list<ContentDocumentLink>();
            Blob body; 
            
            PageReference ref =  page.BookingFormDocument;
            ref.getParameters().put('Id',bookingRecordId);
            
            if(Test.isRunningTest()){
                body = Blob.valueOf('BookingFormDocument');
            }
            else{
                body = ref.getContent();
            }
            
            contentDocList =[select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:bookingRecordId];
            
            if(contentDocList.size()>0)
            {
                for(ContentDocumentLink cd :contentDocList)
                {   
                    if(cd.ContentDocumentId!=null){
                        ContentDocId.add(cd.ContentDocumentId);
                    }
                }
                ContentVersionlist =[SELECT ContentDocumentId,Title,VersionData,isMajorVersion,Document_Type__c,PathOnClient,CreatedDate FROM ContentVersion where Title ='Booking Form' and ContentDocumentId IN :ContentDocId];
            }
            
            if(ContentVersionlist.size()>0)
            {     
                //update Booking Form
                ContentVersion bookingFormContVersionRcd=ContentVersionlist[0];
                ContentVersion bookingFormRcdForUpdate=new ContentVersion();
                
                bookingFormRcdForUpdate.VersionData=body;
                bookingFormRcdForUpdate.Id=bookingFormContVersionRcd.Id;
                
                try{
                    update bookingFormRcdForUpdate;
                }
                catch(DmlException ex){
                    ApexPages.addMessages(ex);
                    system.debug('BookingForm document Save Error 1 ==>'  + ex.getMessage());
                    
                }
                contentId = bookingFormContVersionRcd.ContentDocumentId;
                try{
                    SendBookingEmail.SendEmail(bookingRecordId, contentId);
                }
                catch(Exception ex)
                {
                    system.debug('Error '+ex.getMessage());
                }
                
            }
            else
            {
                conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient = 'Booking Form' + '.pdf'; 
                conVer.Title = 'Booking Form';
                conVer.VersionData = body;
                conVer.origin = 'C';
                conVer.SObjectType__c = 'Booking__c';
                conVer.Document_Type__c = 'Booking Form';
                conVer.isMajorVersion=false;
                conVer.SharingOption = 'A';
                conVer.Origin = 'C';
                conVer.FirstPublishLocationId=userInfo.getUserId();
                try{
                    insert conVer;
                }
                catch(DmlException ex){
                    ApexPages.addMessages(ex);
                    system.debug('BookingForm document Save Error 2 ==>'  + ex.getMessage());
                }
                ContentVersion contentVersionRcd = [SELECT Id, Title, ContentDocumentId 
                                                    FROM ContentVersion WHERE Id = :conVer.Id LIMIT 1];
                String conDocId = contentVersionRcd.contentdocumentid;

                ContentDocumentLink contentlink = new ContentDocumentLink();
                contentlink.LinkedEntityId = bookingRecordId;
                contentlink.contentdocumentid = contentVersionRcd.contentdocumentid;
                contentlink.ShareType = 'V';
                
                try{
                    insert contentlink;
                    
                    system.debug('Hello');
                    SendBookingEmail.SendEmail(bookingRecordId, conDocId);
                }
                catch(DmlException ex){
                    ApexPages.addMessages(ex);
                    system.debug('BookingForm document Save Error 3==>'  + ex.getMessage());
                    
                }
            }
        }
    }
}