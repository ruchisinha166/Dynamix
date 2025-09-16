public class GenerateAgreementChecklist {
    
    @InvocableMethod(label='Generate Agreement Checklist')
    public static List<String> execute( List<Requests> requestLst){

        PageReference ref = Page.Agreement_Checklist;
         ref.getParameters().put('id', requestLst[0].bookingId);
        //ref.getParameters().put('id', requestLst[0].paymentId);
        
        Blob body; 
        if(Test.isRunningTest()){
            body = Blob.valueOf('Agreement Checklist');
        }
        else{
            body = ref.getContent();
        }

        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient = 'Agreement Checklist ' + Date.today() +'.pdf';
        conVer.Title = 'Agreement Checklist ' + Date.today() +'.pdf';
        conVer.VersionData = body;
        conVer.SObjectType__c = 'Booking__c';
        conVer.Document_Type__c = 'Agreement Checklist';
        insert conVer;    
       
        
        // First get the Content Document Id from ContentVersion Object
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = requestLst[0].bookingId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        
        insert conDocLink;

        //ContentDocumentLink conDocLink1 = New ContentDocumentLink();
        //conDocLink1.LinkedEntityId = requestLst[0].paymentId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        //conDocLink1.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        //conDocLink1.shareType = 'V';
        
        //insert conDocLink1;

        return new List<String>{conDoc};
    }

    public class Requests {
        @InvocableVariable(label='Payment Id' required=true)
        public String paymentId;

        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
    }
}