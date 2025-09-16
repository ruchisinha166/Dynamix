public with sharing class GenerateFlatCostChangNote{
    
    @InvocableMethod(label='Generate Flat Cost Change Note')
    public static List<String> execute(List<Request> Requests){
       
        list<ContentDocumentLink> contentDocList = new list<ContentDocumentLink>();
        list<ContentVersion> ContentVersionList =new  list<ContentVersion>();
        String contentId='';
        list<Id> ContentDocId = new list<Id>();
        list<ContentDocumentLink> conDocList = new list<ContentDocumentLink>();
        Blob body;  
        
        String newAgreementValue = String.Valueof(Requests[0].newAgreementValue);
        
        booking__c bookingobj = [select id,Tower_Name__r.Name,Stamp_Duty_Status__c, Property_Name__c from Booking__c where id=: Requests[0].bookingId];     
        PageReference ref =  page.FlatCostChangeNote;
        ref.getParameters().put('id',Requests[0].bookingId);
        ref.getParameters().put('newAgreementValue',newAgreementValue);
        
         
        if(Test.isRunningTest()){
            body = Blob.valueOf('Flat Cost Chanre Note');
        }
        else{
            body = ref.getContent();
        }
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient =  'FlatCostChange' +'/'+String.valueof(bookingobj.Tower_Name__r.Name)+'/'+String.valueof(bookingobj.Property_Name__c)+'.pdf'; 
        conVer.Title = 'FlatCostChange' + '/'+ String.valueof(bookingobj.Tower_Name__r.Name)+'/'+String.valueof(bookingobj.Property_Name__c)+'.pdf';
        conVer.VersionData = body;
        conVer.SObjectType__c = 'Booking__c';
        conVer.Document_Type__c = 'Flat Cost Change Note';
        insert conVer;
            
        // First get the Content Document Id from ContentVersion Object
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = Requests[0].bookingId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        
        insert conDocLink;

        
        return new List<String>{conDoc};
        
    }
     public class Request {
        @InvocableVariable(label='Booking Id' required=true)
        public id bookingId;
        
        @InvocableVariable(label='New Agreemane Value' required=true)
        public Decimal newAgreementValue;
        
       /* @InvocableVariable(label='Old Agreemane Value' required=true)
        public Decimal oldAgreementValue;*/
        
        
    }
   
    
 }