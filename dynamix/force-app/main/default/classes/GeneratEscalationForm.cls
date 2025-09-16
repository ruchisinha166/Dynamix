public class GeneratEscalationForm {
    
    @InvocableMethod(label='Generat Escalation Form')
    public static List<String> execute( List<Requests> requestLst){

        Booking__c booking = [SELECT Id,Tower_Name__r.Name,Property_Name__c,Tower_Name__r.Building_Type__c, Name from Booking__c WHERE Id =: requestLst[0].bookingId];
        PageReference ref = Page.Escalation_Form;
        ref.getParameters().put('id', requestLst[0].bookingId);
        
        Blob body; 
        if(Test.isRunningTest()){
            body = Blob.valueOf('Escalation Form');
        }
        else{
            body = ref.getContent();
        }

        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient = 'Escalation Form'+ '-' + booking.Property_Name__c +'.pdf'; 
        conVer.Title = 'Escalation Form'+ '-' +booking.Property_Name__c +'.pdf';
        conVer.VersionData = body;
        conVer.SObjectType__c = 'Booking__c';
        conVer.Document_Type__c = 'Escalation';
        insert conVer;    
       
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = requestLst[0].bookingId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        
        insert conDocLink;

       
        return new List<String>{conDoc};
    }

    public class Requests {
       

        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
    }
}