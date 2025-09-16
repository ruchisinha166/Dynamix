public class GenerateInterestWvaveierLetter{
     
     @InvocableMethod(label='Generate Interest Waiver Letter')
     public static List<String> execute(List<Requests> Requests){
     
        ContentVersion conVer;
        list<ContentDocumentLink> contentDocList = new list<ContentDocumentLink>();
        list<ContentVersion> ContentVersionList =new  list<ContentVersion>();
        String contentId='';
        list<Id> ContentDocId = new list<Id>();
        list<ContentDocumentLink> conDocList = new list<ContentDocumentLink>();
                   
        Payment_Milestones__c pm = [select id, name from Payment_Milestones__c where id=: Requests[0].paymentMilestoneId];
            
            PageReference ref =  page.InterestWaiverDoc;
            ref.getParameters().put('id',Requests[0].paymentMilestoneId);
            Blob body; 
            if(Test.isRunningTest()){
                body = Blob.valueOf('Interest Wavier Letter');
            }
            else{
                body = ref.getContent();
            }
            
                conVer =new ContentVersion(); 
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient = 'Interest Waiver' + '.pdf'; 
                conVer.Title = 'Interest Waiver'+' - '+pm.Name +'.pdf';
                conVer.VersionData = body;
                conVer.SObjectType__c = 'Payment_Milestones__c ';
                conVer.Document_Type__c = 'Interest Waiver';
                //conVer.ContentDocumentId=ContentDocId[0];
               // system.debug('test'+conVer);
                insert conVer;
                system.debug('test'+conVer);
                contentId = conVer.ContentDocumentId;
                
                // First get the Content Document Id from ContentVersion Object
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = Requests[0].paymentMilestoneId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        
        insert conDocLink;
                  
            
            /*else
            {
                conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient = 'Interest Waiver' + '.pdf'; 
                conVer.Title = 'Interest Waiver' +' - '+ pm.Name +'.pdf';
                conVer.VersionData = body;
                conVer.SObjectType__c = 'Payment_Milestones__c ';
                conVer.Document_Type__c = 'Interest Waiver';
                conVer.isMajorVersion=false;
                Insert conVer;
                list<ContentVersion> conVerList= [SELECT ContentDocumentId,CreatedDate FROM ContentVersion WHERE Id =:conVer.Id ];
                If(conVerList.size()>0)
                {
                    for(ContentVersion con :conVerList)
                    {
                        ContentDocumentLink conDocLink = New ContentDocumentLink();
                        conDocLink.LinkedEntityId = Requests[0].paymentMilestoneId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                        conDocLink.ContentDocumentId = con.ContentDocumentId;  //ContentDocumentId Id from ContentVersion
                        conDocLink.shareType = 'V';
                        conDocList.add(conDocLink);
                    }
                }    
                insert conDocList;
                //contentId = conVerList[0].ContentDocumentId;
            }*/
            return new List<String>{contentId};
        
    }
             
     
      public class Requests {
      
        @InvocableVariable(label='Payment Milestone Id' required=true)
        public String paymentMilestoneId;
      }
     
    

}