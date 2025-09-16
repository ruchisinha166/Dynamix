public class generateIndemnityLetter {

    @InvocableMethod(label='Generate Indemnity Letter')
    public static void generateIndemnityLetter(List<Requests> requestLst)
    {
        id bookingId = requestLst[0].bookingId;
        PageReference ref = Page.indemnityLetter;
        ref.getParameters().put('id',bookingId);
        
        Blob body; 
                if(Test.isRunningTest()){
                    body = Blob.valueOf('indemnityLetter');
                }
                else{
                    body = ref.getContent();
                }
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
                conVer.PathOnClient = 'Indemnity Form'+'.pdf'; 
                conVer.Title = 'Indemnity Form'+'.pdf';
                conVer.VersionData = body;
                conVer.SObjectType__c = 'Booking__c';
                conVer.Document_Type__c = 'Indemnity';
                insert conVer;    
                system.debug('conVer' + conVer);
                
                ContentVersion contentverlink = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :conVer.Id LIMIT 1];
                ContentDocumentLink contentlink = new ContentDocumentLink();
                contentlink.LinkedEntityId = bookingId;
                contentlink.contentdocumentid = contentverlink.contentdocumentid;
                contentlink.ShareType = 'V';
                insert contentlink;
                system.debug(contentlink);
        
    }
    public class Requests {
        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
    }
}