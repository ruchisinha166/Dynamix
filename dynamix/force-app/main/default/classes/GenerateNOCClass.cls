public with sharing class GenerateNOCClass {
    
    @InvocableMethod(label='Generate NOC')
    public static List<String> execute(List<Request> Requests){
        system.debug('in Generate NOC Letter');
        ContentVersion conVer;
        list<ContentDocumentLink> contentDocList = new list<ContentDocumentLink>();
        list<ContentVersion> ContentVersionList =new  list<ContentVersion>();
        String contentId='';
        list<Id> ContentDocId = new list<Id>();
        list<ContentDocumentLink> conDocList = new list<ContentDocumentLink>();
        Blob body;       
        if(Requests.size() > 0 && Requests[0].bookingId != null){
            
            
            booking__c booking = [select id,Tower_Name__r.Name,Project_Name__c,Project_Name__r.Name,Stamp_Duty_Status__c, Property_Name__c from Booking__c 
                                  where id=: Requests[0].bookingId];
            
            PageReference ref =  Page.NOCPage;
            system.debug('booking req ----'+Requests[0].bookingId);
            ref.getParameters().put('id',Requests[0].bookingId);
            ref.getParameters().put('loanId',Requests[0].loanId);
            
            if(Test.isRunningTest()){
                body = Blob.valueOf('NOCPage');
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
            
            if(ContentVersionlist.size()>0 && ContentVersionlist[0].ContentDocumentId != null)
            {
                conVer =new ContentVersion(); 
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient = 'NOC' + String.valueof(booking.Project_Name__r.Name)+'.pdf';
                conVer.Title =  'NOC/' + String.valueof(booking.Project_Name__r.Name)+'.pdf';
                conVer.VersionData = body;
                conVer.SObjectType__c = 'Booking__c';
                conVer.Document_Type__c = 'NOC';
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
                conVer.PathOnClient ='NOC' + String.valueof(booking.Project_Name__r.Name)+'.pdf';
                conVer.Title = 'NOC/' + String.valueof(booking.Project_Name__r.Name)+'.pdf';
                conVer.VersionData = body;
                conVer.SObjectType__c = 'Booking__c';
                conVer.Document_Type__c = 'NOC';
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
                if(conVerList[0].ContentDocumentId != null){
                    contentId = conVerList[0].ContentDocumentId;
                }
            }
            return new List<String>{contentId};
        }
        else{
            return null;
        }
        
    }
    
    public class Request {
        @InvocableVariable(label='Booking Id' required=true)
        public id bookingId;
        
        @InvocableVariable(label='Bank Loan Id' required=true)
        public id loanId;
    }
}