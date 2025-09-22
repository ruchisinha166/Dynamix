public without sharing class GeneratePossessionLetter {
    public boolean data;
    @InvocableMethod(label='Generate Possession Letter')
    public static List<String> execute( List<Requests> requestLst){
		System.debug('----requestLst'+requestLst);
        return new List<String> {
            generateCS(requestLst[0].bookingId)
                };
    }

    public static String generateCS(String bookingId){
        
        ContentVersion conVer;
        list<ContentDocumentLink> contentDocList = new list<ContentDocumentLink>();
        list<ContentVersion> ContentVersionList =new  list<ContentVersion>();
           list<ContentVersion> ContentVersionLetterOfAmenitieslist =new  list<ContentVersion>();
        String contentId='';
        string whereCausLike;
        list<Id> ContentDocId = new list<Id>();
        List<user> collaborators = new List<user>();
        list<ContentDocumentLink> conDocList = new list<ContentDocumentLink>();
        list<ContentDocumentLink> conDocListC = new list<ContentDocumentLink>();
        Booking__c booking = [select Id,Tower_Name__c,Related_Opportunity__c,Registration_Date__c,Tower_Name__r.Name,
                           Tower_Name__r.Building_Type__c,Tower_Name__r.Tower_Initials__c,Project_Name__c,Primary_Applicant__c,
                           Primary_Applicant__r.Name,Related_Suggested_Property__c,Agreement_Value__c,Booking_Date__c,
                           Booking_Owner_Email__c,OwnerId,Booking_Owner_Name__c,Unit_Number__c,Name
                           from Booking__c where Id =: bookingId];

       
        List<ContentDocumentLink> cDLLst = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =: bookingId];
        
        PageReference refOfPossessionLetter = Page.PossessionLetter;
        refOfPossessionLetter.getParameters().put('id',booking.id);
        PageReference refOfPendingCommonAmenities = Page.LetterPendingCommonAmenities;
        refOfPendingCommonAmenities.getParameters().put('id',booking.id);
        
        Blob body; 
        if(Test.isRunningTest()){
            body = Blob.valueOf('Possession Letter');
        }
        else{
            body = refOfPossessionLetter.getContent();
        }
        
        Blob bodyLetterPendingCommonAmenities; 
        if(Test.isRunningTest()){
            bodyLetterPendingCommonAmenities = Blob.valueOf('Letter Pending Common Amenities');
        }
        else{
            bodyLetterPendingCommonAmenities = refOfPendingCommonAmenities.getContent();
        }
        
        String unitName;
        String whereCausLikebodyLetterPendingCommonAmenities;
        if(booking.Unit_Number__c.length() < 4)
        {
             unitName = 0 + booking.Unit_Number__c;
        }
        else{
             unitName = booking.Unit_Number__c;
        }
        if(booking.Tower_Name__r.Name <> null && unitName <> null && booking.Name <> null)
        {
          whereCausLike = 'Possession Letter/'+booking.Tower_Name__r.Name.left(3) + '/' + unitName  +'/'+'%';  
          whereCausLikebodyLetterPendingCommonAmenities = 'Letter Pending Common Amenities/'+booking.Tower_Name__r.Name.left(3) + '/' + unitName  +'/'+'%'; 
        } 
        System.debug('whereCausLike'+whereCausLike); 
        contentDocList =[select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId =: bookingId];
            system.debug('===> contentDocList ' + contentDocList );
            if(contentDocList.size()>0)
            {
                for(ContentDocumentLink cd :contentDocList)
                {   
                    ContentDocId.add(cd.ContentDocumentId);
                }
                ContentVersionlist =[SELECT ContentDocumentId,VersionData,isMajorVersion,PathOnClient,CreatedDate FROM ContentVersion where Title Like: whereCausLike and ContentDocumentId IN :ContentDocId];
                ContentVersionLetterOfAmenitieslist =[SELECT ContentDocumentId,VersionData,isMajorVersion,PathOnClient,CreatedDate FROM ContentVersion where Title Like: whereCausLikebodyLetterPendingCommonAmenities and ContentDocumentId IN :ContentDocId];

            }
            if(ContentVersionlist.size()>0)
            {
                conVer =new ContentVersion(); 
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient = 'Possession Letter/'+booking.Tower_Name__r.Name.left(3) + '/' + unitName  + cDLLst.size() +'.pdf'; 
                conVer.Title = 'Possession Letter/'+booking.Tower_Name__r.Name.left(3) + '/' + unitName + cDLLst.size() +'.pdf';
                conVer.VersionData = body;
                conVer.SObjectType__c = 'Booking__c';
                conVer.Document_Type__c = 'Handover of Possession Letter';
                conVer.ContentDocumentId=ContentVersionlist[0].ContentDocumentId;
                insert conVer;
                system.debug('test'+conVer);
                contentId = conVer.ContentDocumentId;
                  
            }
            else
            {
                conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient = 'Possession Letter/'+booking.Tower_Name__r.Name.left(3) + '/' + unitName  + cDLLst.size() +'.pdf'; 
                conVer.Title = 'Possession Letter/'+booking.Tower_Name__r.Name.left(3) + '/' + unitName   + cDLLst.size() +'.pdf';
                conVer.VersionData = body;
                conVer.SObjectType__c = 'Booking__c';
                conVer.Document_Type__c = 'Handover of Possession Letter';
                conVer.isMajorVersion=false;
                Insert conVer;
                ContentVersion contentverlink = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :conVer.Id LIMIT 1];
              
                        ContentDocumentLink conDocLink = New ContentDocumentLink();
                        conDocLink.LinkedEntityId = bookingId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                        conDocLink.ContentDocumentId = contentverlink.ContentDocumentId;  //ContentDocumentId Id from ContentVersion
                        conDocLink.shareType = 'V';
                        conDocList.add(conDocLink);
                        
                       /* for(user uId : collaborators)
                        {
                        ContentDocumentLink conDocLinkC = New ContentDocumentLink();
                        conDocLinkC.LinkedEntityId = uId.id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                        conDocLinkC.ContentDocumentId = contentverlink.ContentDocumentId;  //ContentDocumentId Id from ContentVersion
                        conDocLinkC.shareType = 'C';
                        conDocList.add(conDocLinkC); 
                        } */                            
                insert conDocList; 
                contentId = contentverlink.ContentDocumentId;
            }
         if(ContentVersionLetterOfAmenitieslist.size()>0)
            {
                conVer =new ContentVersion(); 
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient = 'Letter Pending Common Amenities/'+booking.Tower_Name__r.Name.left(3) + '/' + unitName  + cDLLst.size() +'.pdf'; 
                conVer.Title = 'Letter Pending Common Amenities/'+booking.Tower_Name__r.Name.left(3) + '/' + unitName + cDLLst.size() +'.pdf';
                conVer.VersionData = bodyLetterPendingCommonAmenities;
                conVer.SObjectType__c = 'Booking__c';
                conVer.Document_Type__c = 'Letter Pending Common Amenities';
                conVer.ContentDocumentId=ContentVersionlist[0].ContentDocumentId;
                insert conVer;
                system.debug('test'+conVer);
                contentId = conVer.ContentDocumentId;
                  
            }
            else
            {
                conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient = 'Letter Pending Common Amenities/'+booking.Tower_Name__r.Name.left(3) + '/' + unitName  + cDLLst.size() +'.pdf'; 
                conVer.Title = 'Letter Pending Common Amenities/'+booking.Tower_Name__r.Name.left(3) + '/' + unitName   + cDLLst.size() +'.pdf';
                conVer.VersionData = bodyLetterPendingCommonAmenities;
                conVer.SObjectType__c = 'Booking__c';
                conVer.Document_Type__c = 'Letter Pending Common Amenities';
                conVer.isMajorVersion=false;
                Insert conVer;
                ContentVersion contentverlink = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :conVer.Id LIMIT 1];
              
                        ContentDocumentLink conDocLink = New ContentDocumentLink();
                        conDocLink.LinkedEntityId = bookingId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                        conDocLink.ContentDocumentId = contentverlink.ContentDocumentId;  //ContentDocumentId Id from ContentVersion
                        conDocLink.shareType = 'V';
                        conDocList.add(conDocLink);
                        
                       /* for(user uId : collaborators)
                        {
                        ContentDocumentLink conDocLinkC = New ContentDocumentLink();
                        conDocLinkC.LinkedEntityId = uId.id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                        conDocLinkC.ContentDocumentId = contentverlink.ContentDocumentId;  //ContentDocumentId Id from ContentVersion
                        conDocLinkC.shareType = 'C';
                        conDocList.add(conDocLinkC); 
                        } */                            
                upsert conDocList; 
                contentId = contentverlink.ContentDocumentId;
            }
            return contentId;
    }

    public class Requests {
        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
    }
}