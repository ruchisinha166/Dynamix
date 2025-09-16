public class GenerateAllotmentLetter {
    @InvocableMethod(label='Allotment Lettter')
    public static List<String> execute(List<Request> Requests){
        ContentVersion conVer;
        list<ContentDocumentLink> contentDocList = new list<ContentDocumentLink>();
        list<ContentVersion> ContentVersionList =new  list<ContentVersion>();
        String contentId='';
        Set<Id> ContentDocId = new Set<Id>();
        list<ContentDocumentLink> conDocList = new list<ContentDocumentLink>();
        Blob body; 
        
        PageReference ref =  page.LetterOfConfirmationAllotementLetter;
        ref.getParameters().put('id',Requests[0].bookingId);
        
        if(Test.isRunningTest()){
            body = Blob.valueOf('LetterOfConfirmationAllotementLetter');
        }
        else{
            body = ref.getContent();
        }
        
        contentDocList =[select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:Requests[0].bookingId];
        
        if(contentDocList.size()>0)
        {
            for(ContentDocumentLink cd :contentDocList)
            {   
                if(cd.ContentDocumentId!=null){
                    ContentDocId.add(cd.ContentDocumentId);
                }
            }
            ContentVersionlist =[SELECT ContentDocumentId,Title,VersionData,isMajorVersion,Document_Type__c,PathOnClient,CreatedDate FROM ContentVersion where Title ='Allotment Letter' and ContentDocumentId IN :ContentDocId];
        }
        
        if(ContentVersionlist.size()>0)
        {     
            //update Allotment Letter
            ContentVersion allotmenLettContVersionRcd=ContentVersionlist[0];
            ContentVersion allotmenLettRcdForUpdate=new ContentVersion();
            PageReference ref1 = Page.LetterOfConfirmationAllotementLetter;
            
            allotmenLettRcdForUpdate.VersionData=body;
            allotmenLettRcdForUpdate.Id=allotmenLettContVersionRcd.Id;
            update allotmenLettRcdForUpdate;
            system.debug('allotmenLettRcdForUpdate'+allotmenLettRcdForUpdate);          
            contentId = allotmenLettContVersionRcd.ContentDocumentId;      
        }
        else
        {
            conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; 
            conVer.PathOnClient = 'Allotment Letter' + '.pdf'; 
            conVer.Title = 'Allotment Letter';
            conVer.VersionData = body;
            conVer.SObjectType__c = 'Booking__c';
            conVer.Document_Type__c = 'Allotment';
            conVer.isMajorVersion=false;
            insert conVer;
            
            ContentVersion contentVersionRcd = [SELECT Id, Title, ContentDocumentId 
                                                FROM ContentVersion WHERE Id = :conVer.Id LIMIT 1];
            
            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = Requests[0].bookingId;
            contentlink.contentdocumentid = contentVersionRcd.contentdocumentid;
            contentlink.ShareType = 'V';
            insert contentlink;           
            contentId = contentVersionRcd.ContentDocumentId;
            
            //for send Email to Booking Owner
            Booking__c bookingRcd = [select Id, Name,OwnerId,Owner.Email,Owner.Name,Project_Name__r.Name,Project_Name__c from Booking__c where id=: Requests[0].bookingId];
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Allotment_Letter_Generated_Email' LIMIT 1];
            System.debug('emailTemplate:'+emailTemplate);
            String bookingLink=URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Id;
            String projectLink=URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Project_Name__c;
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Booking__c.Name}', '<a href="'+bookingLink+'">' + bookingRcd.Name +'</a>');
            htmlBody = htmlBody.replace('{!Booking__c.Owner.Name}', bookingRcd.Owner.Name);
            htmlBody = htmlBody.replace('{!projectName}', '<a href="'+projectLink+'">' + bookingRcd.Project_Name__r.Name +'</a>');
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Booking__c.Name}', '<a href="'+bookingLink+'">' + bookingRcd.Name +'</a>'); 
            plainBody = plainBody.replace('{!Booking__c.Owner.Name}', bookingRcd.Owner.Name);
            plainBody = plainBody.replace('{!projectName}', '<a href="'+projectLink+'">' + bookingRcd.Project_Name__r.Name +'</a>');
            if(emailTemplate!=null){ 
                List<String> emailList=new List<String>();           
                emailList.add(bookingRcd.Owner.Email);  
                SendEmailandBellNotificationUtility.SendEmail(emailTemplate.Id,htmlBody,plainBody,emailList,null);
            }
            
            //For Send Bell Notification to Booking Owner
            // Get the Id for our custom notification type
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Notification_For_Allotment_Letter']; 
            if(notificationType!=null){
                String notificationTitle='Booking - Allotment Letter';
                //String notificationBody='Allotment Letter has been Generated for Booking: '+ bookingRcd.Name;
                String notificationBody='The Allotment Letter for Booking:'+ bookingRcd.Name +' of Project:'+ bookingRcd.Project_Name__r.Name + ' has been generated. Please share the Allotment Letter with the client to proceed.';
                String targetId=bookingRcd.Id;
                Set <String> recipientIds= new Set <String> ();
                recipientIds.add(bookingRcd.OwnerId);
                SendEmailandBellNotificationUtility.SendBellNotification(notificationType.Id, notificationTitle, notificationBody, targetId, recipientIds);
            }
        }
        system.debug('contentId:'+contentId);
        return new List<String>{contentId};   
            }  
    public class Request {
        @InvocableVariable(label='Booking Id' required=true)
        public id bookingId;
    }
    @Future(callout=true)
    public static void execute2(String bookingId){
        ContentVersion conVer;
        list<ContentDocumentLink> contentDocList = new list<ContentDocumentLink>();
        list<ContentVersion> ContentVersionList =new  list<ContentVersion>();
        String contentId='';
        Set<Id> ContentDocId = new Set<Id>();
        list<ContentDocumentLink> conDocList = new list<ContentDocumentLink>();
        Blob body; 
        
        PageReference ref =  page.LetterOfConfirmationAllotementLetter;
        ref.getParameters().put('id',bookingId);
        
        if(Test.isRunningTest()){
            body = Blob.valueOf('LetterOfConfirmationAllotementLetter');
        }
        else{
            body = ref.getContent();
        }
        
        contentDocList =[select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:bookingId];
        
        if(contentDocList.size()>0)
        {
            for(ContentDocumentLink cd :contentDocList)
            {   
                if(cd.ContentDocumentId!=null){
                    ContentDocId.add(cd.ContentDocumentId);
                }
            }
            ContentVersionlist =[SELECT ContentDocumentId,Title,VersionData,isMajorVersion,Document_Type__c,PathOnClient,CreatedDate FROM ContentVersion where Title ='Allotment Letter' and ContentDocumentId IN :ContentDocId];
        }
        system.debug('ContentVersionlist>>> '+ContentVersionlist);
        if(ContentVersionlist.size()>0)
        {     
            //update Allotment Letter
            ContentVersion allotmenLettContVersionRcd=ContentVersionlist[0];
            ContentVersion allotmenLettRcdForUpdate=new ContentVersion();
            PageReference ref1 = Page.LetterOfConfirmationAllotementLetter;
            
            allotmenLettRcdForUpdate.VersionData=body;
            allotmenLettRcdForUpdate.Id=allotmenLettContVersionRcd.Id;
            update allotmenLettRcdForUpdate;
            system.debug('allotmenLettRcdForUpdate'+allotmenLettRcdForUpdate);          
            contentId = allotmenLettContVersionRcd.ContentDocumentId;      
        }
        else
        {
            conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; 
            conVer.PathOnClient = 'Allotment Letter' + '.pdf'; 
            conVer.Title = 'Allotment Letter';
            conVer.VersionData = body;
            conVer.SObjectType__c = 'Booking__c';
            conVer.Document_Type__c = 'Allotment';
            conVer.isMajorVersion=false;
            insert conVer;
            
            ContentVersion contentVersionRcd = [SELECT Id, Title, ContentDocumentId 
                                                FROM ContentVersion WHERE Id = :conVer.Id LIMIT 1];
            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = bookingId;
            contentlink.contentdocumentid = contentVersionRcd.contentdocumentid;
            contentlink.ShareType = 'V';
            insert contentlink;           
            contentId = contentVersionRcd.ContentDocumentId;
            
            Booking__c bookingRcd = [select Id, Name,OwnerId,Owner.Email,Owner.Name,Project_Name__r.Name,Project_Name__c from Booking__c where id=: bookingId];
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Allotment_Letter_Generated_Email' LIMIT 1];
            System.debug('emailTemplate:'+emailTemplate);
            String bookingLink=URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Id;
            String projectLink=URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Project_Name__c;
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Booking__c.Name}', '<a href="'+bookingLink+'">' + bookingRcd.Name +'</a>');
            htmlBody = htmlBody.replace('{!Booking__c.Owner.Name}', bookingRcd.Owner.Name);
            htmlBody = htmlBody.replace('{!projectName}', '<a href="'+projectLink+'">' + bookingRcd.Project_Name__r.Name +'</a>');
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Booking__c.Name}', '<a href="'+bookingLink+'">' + bookingRcd.Name +'</a>'); 
            plainBody = plainBody.replace('{!Booking__c.Owner.Name}', bookingRcd.Owner.Name);
            plainBody = plainBody.replace('{!projectName}', '<a href="'+projectLink+'">' + bookingRcd.Project_Name__r.Name +'</a>');
            if(emailTemplate!=null){ 
                List<String> emailList=new List<String>();           
                emailList.add(bookingRcd.Owner.Email);  
                SendEmailandBellNotificationUtility.SendEmail(emailTemplate.Id,htmlBody,plainBody,emailList,null);
            }
            
            //For Send Bell Notification to Booking Owner
            // Get the Id for our custom notification type
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Notification_For_Allotment_Letter']; 
            if(notificationType!=null){
                String notificationTitle='Booking - Allotment Letter';
                //String notificationBody='Allotment Letter has been Generated for Booking: '+ bookingRcd.Name;
                String notificationBody='The Allotment Letter for Booking:'+ bookingRcd.Name +' of Project:'+ bookingRcd.Project_Name__r.Name + ' has been generated. Please share the Allotment Letter with the client to proceed.';
                String targetId=bookingRcd.Id;
                Set <String> recipientIds= new Set <String> ();
                recipientIds.add(bookingRcd.OwnerId);
                SendEmailandBellNotificationUtility.SendBellNotification(notificationType.Id, notificationTitle, notificationBody, targetId, recipientIds);
            }
        }
        system.debug('contentId:'+contentId);
        //return new List<String>{contentId};   
            }
}