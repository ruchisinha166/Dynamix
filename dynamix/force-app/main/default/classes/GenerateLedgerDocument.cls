public class GenerateLedgerDocument {
@InvocableMethod(label='Generate Ledger Document')
    public static List<String> execute(List<Request> Requests){
        ContentVersion conVer;
        list<ContentDocumentLink> contentDocList = new list<ContentDocumentLink>();
        list<ContentVersion> ContentVersionList =new  list<ContentVersion>();
        String contentId='';
        list<Id> ContentDocId = new list<Id>();
        list<ContentDocumentLink> conDocList = new list<ContentDocumentLink>();
        Blob body;            
            booking__c booking = [select id,Tower_Name__r.Name,Stamp_Duty_Status__c, Property_Name__c from Booking__c where id=: Requests[0].bookingId];
            
                PageReference ref =  Page.LedgerDocument;
                ref.getParameters().put('id',Requests[0].bookingId);
                
                if(Test.isRunningTest()){
                    body = Blob.valueOf('Ledger Document');
                }
                else{
                    body = ref.getContent();
                } 
            
            contentDocList =[select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:Requests[0].bookingId];
            
            if(contentDocList.size()>0)
            {
                for(ContentDocumentLink cd :contentDocList)
                {   
                    ContentDocId.add(cd.ContentDocumentId);
                }
                 ContentVersionlist =[SELECT ContentDocumentId,VersionData,isMajorVersion,PathOnClient,CreatedDate FROM ContentVersion where Title Like 'ALOT%' and ContentDocumentId IN :ContentDocId];
            }
            
            if(ContentVersionlist.size()>0)
            {
                conVer =new ContentVersion(); 
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient = 'Ledger/' + String.valueof(booking.Tower_Name__r.Name)+'/'+String.valueof(booking.Property_Name__c)+'.pdf';
                conVer.Title =  'Ledger/' + String.valueof(booking.Tower_Name__r.Name)+'/'+String.valueof(booking.Property_Name__c)+'.pdf';
                conVer.VersionData = body;
                conVer.SObjectType__c = 'Booking__c';
                conVer.Document_Type__c = 'Ledger';
                //conVer.ContentDocumentId=ContentDocId[0];
                conVer.ContentDocumentId=ContentVersionlist[0].ContentDocumentId;
               // system.debug('test'+conVer);
                insert conVer;
                system.debug('test'+conVer);
                contentId = conVer.ContentDocumentId;
                  
            }
            else
            {
                conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient ='Ledger/' + String.valueof(booking.Tower_Name__r.Name)+'/'+String.valueof(booking.Property_Name__c)+'.pdf';
                conVer.Title = 'Ledger/' + String.valueof(booking.Tower_Name__r.Name)+'/'+String.valueof(booking.Property_Name__c)+'.pdf';
                conVer.VersionData = body;
                conVer.SObjectType__c = 'Booking__c';
                conVer.Document_Type__c = 'Ledger';
                conVer.isMajorVersion=false;
                Insert conVer;
                list<ContentVersion> conVerList= [SELECT ContentDocumentId,CreatedDate FROM ContentVersion WHERE Id =:conVer.Id ];
                If(conVerList.size()>0)
                {
                    for(ContentVersion con :conVerList)
                    {
                        ContentDocumentLink conDocLink = New ContentDocumentLink();
                        conDocLink.LinkedEntityId = Requests[0].bookingId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                        conDocLink.ContentDocumentId = con.ContentDocumentId;  //ContentDocumentId Id from ContentVersion
                        conDocLink.shareType = 'V';
                        conDocList.add(conDocLink);
                    }
                }    
                insert conDocList;
                contentId = conVerList[0].ContentDocumentId;
            }
            system.debug('===>contentId ' +contentId);
            return new List<String>{contentId};
        
    }
    
    public class Request {
        @InvocableVariable(label='Booking Id' required=true)
        public id bookingId;
    }
}