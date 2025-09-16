public class generateInterestWaiver {

    @InvocableMethod(label='Generate Interest Waiver')
    public static List<String> execute(List<Request> Requests){
        ContentVersion conVer;
        list<ContentDocumentLink> contentDocList = new list<ContentDocumentLink>();
        list<ContentVersion> ContentVersionList =new  list<ContentVersion>();
        String contentId='';
        list<Id> ContentDocId = new list<Id>();
        list<ContentDocumentLink> conDocList = new list<ContentDocumentLink>();
        Blob body; 
                   
            booking__c bookingobj = [select id, Property_Name__c from Booking__c where id=: Requests[0].bookingId];
          
                PageReference ref =  page.interestWaiverDoc;
                ref.getParameters().put('id',Requests[0].bookingId);
                
                if(Test.isRunningTest()){
                body = Blob.valueOf('interestWaiverDoc');
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
                ContentVersionlist =[SELECT ContentDocumentId,VersionData,isMajorVersion,PathOnClient,CreatedDate FROM ContentVersion where PathOnClient ='Agreement of Sale.pdf' and ContentDocumentId IN :ContentDocId];
            }
            
            if(ContentVersionlist.size()>0)
            {
                conVer =new ContentVersion(); 
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient = 'interestWaiverDoc' + '.pdf'; 
                conVer.Title = 'interestWaiverDoc'+'.pdf';
                conVer.VersionData = body;
                conVer.SObjectType__c = 'Booking__c';
                conVer.Document_Type__c = 'Allotment';
                conVer.ContentDocumentId=ContentDocId[0];
               // system.debug('test'+conVer);
                insert conVer;
                system.debug('test'+conVer);
                contentId = conVer.ContentDocumentId;
                  
            }
            else
            {
                conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient = 'interestWaiverDoc' + '.pdf'; 
                conVer.Title = 'interestWaiverDoc'+'.pdf';
                conVer.VersionData = body;
                conVer.SObjectType__c = 'Booking__c';
                conVer.Document_Type__c = 'Allotment';
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
            return new List<String>{contentId};
        
    }
    
    
    public class Request {
        @InvocableVariable(label='Booking Id' required=true)
        public id bookingId;
    }
}