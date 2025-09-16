public class SendBookingEmail {
    @future(Callout=true)
    public static void SendEmail(string bookingId, string ContentDocumentId) {
        
        String AttachmentName;
        Blob Data;
        String filetype;
        String AttcacmentNameAnnexure;
        Blob DataAnnexure;
        String fileTypeAnnexure;
        /*PageReference ref = Page.BookingForm;
        ref.getParameters().put('id', bookingId);*/
        
        Booking__c bookingRcd = [select Id, Name,Primary_Applicant__c,Related_Opportunity__c,Unit_Number__c,Project_Name_Formulla__c,
                                 Related_Opportunity__r.Owner.Name,Related_Opportunity__r.Owner.Email,Related_Opportunity__r.Owner.Id,Project_Name__c,Project_Name__r.Builder_Organization__r.Name,Primary_Applicant__r.PersonMobilePhone,Primary_Applicant__r.PersonEmail,
                                 Primary_Applicant_Name_Formulla__c,Related_Suggested_Property__r.Unit__c,Record_Link__c,Project_Name__r.Project_Email__c,Project_Name__r.Name,Primary_Applicant__r.PersonContactId FROM Booking__c WHERE Id=: bookingId];
        System.debug('bookingRcd:'+bookingRcd);
        
        /*Blob body; 
        
        if(Test.isRunningTest()){
            body = Blob.valueOf('Booking Form'); 
        }
        else{
            body = ref.getContent();
        }
            
                
        ContentVersion conVe = new ContentVersion();
        conVe.ContentLocation = 'S'; 
        conVe.PathOnClient =  'BookingForm.pdf';
        conVe.Title =  'BookingForm.pdf';
        conVe.VersionData = body;
        conVe.SObjectType__c = 'Booking__c';
        conVe.Document_Type__c = 'Booking Form';
        insert conVe; 
    
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVe.Id].ContentDocumentId;
        System.debug('conDoc----------->'+conDoc);
        
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = bookingId; 
        conDocLink.ContentDocumentId = conDoc;  
        conDocLink.shareType = 'V';
        insert conDocLink;*/
        
        //for send Email to Customer
        List<String> toMailList = New List<String>();
        if(bookingRcd.Primary_Applicant__c!=null){
            Account customerRecord=[Select Id,Name,PersonEmail From Account Where Id=:bookingRcd.Primary_Applicant__c];
            System.debug('customerRecord:'+customerRecord);
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'generatr_Booking_form_mail' LIMIT 1];
            System.debug('emailTemplate:'+emailTemplate);

            String projectLink='';
            String projectName='';
            if(bookingRcd.Project_Name__c!=null){
                projectLink = URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Project_Name__c;
                projectName = '<a href="'+projectLink+'">'+bookingRcd.Project_Name_Formulla__c+'</a>';
            }
            String bookLink='';
            String bookName='';
            if(bookingRcd.Name!=null){
                bookLink = URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Id;
                bookName = '<a href="'+bookLink+'">'+bookingRcd.Name+'</a>';
            }
            
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Name}',bookName);
            if(customerRecord.Name != null){
                htmlBody = htmlBody.replace('{!SM}', customerRecord.Name);
            }
            if(bookingRcd.Project_Name__r.Builder_Organization__r.Name != null){
                htmlBody = htmlBody.replace('{!builderOrgName}', bookingRcd.Project_Name__r.Builder_Organization__r.Name);
            }
            if(bookingRcd.Related_Opportunity__r.Owner.Email != null){
                htmlBody = htmlBody.replace('{!OEmail}', bookingRcd.Related_Opportunity__r.Owner.Email);
            }
            if(bookingRcd.Related_Opportunity__r.Owner.Name != null){
                htmlBody = htmlBody.replace('{!OName}', bookingRcd.Related_Opportunity__r.Owner.Name);
            }
            if(bookingRcd.Project_Name_Formulla__c != null){
                htmlBody = htmlBody.replace('{!Project}', projectName);
            }
            if(bookingRcd.Unit_Number__c != null){
                htmlBody = htmlBody.replace('{!Unit}', bookingRcd.Unit_Number__c);
            }
            
            String plainBody = emailTemplate.Body;
            
            plainBody = plainBody.replace('{!Name}',bookName); 
            if(customerRecord.Name != null){
                plainBody = plainBody.replace('{!SM}', customerRecord.Name);
            }
            if(bookingRcd.Project_Name__r.Builder_Organization__r.Name != null){
                plainBody = plainBody.replace('{!builderOrgName}', bookingRcd.Project_Name__r.Builder_Organization__r.Name);
            }
            if(bookingRcd.Related_Opportunity__r.Owner.Name != null){
                plainBody = plainBody.replace('{!OName}', bookingRcd.Related_Opportunity__r.Owner.Name);
            }
            if(bookingRcd.Related_Opportunity__r.Owner.Email != null){
                plainBody = plainBody.replace('{!OEmail}', bookingRcd.Related_Opportunity__r.Owner.Email);
            }
            if(bookingRcd.Project_Name_Formulla__c != null){
                plainBody = plainBody.replace('{!Project}', projectName);
            }
            if(bookingRcd.Unit_Number__c != null){
                plainBody = plainBody.replace('{!Unit}', bookingRcd.Unit_Number__c);
            }
            
            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
            
            Contentversion conVer = [select id,ContentDocumentId,Title,VersionData,FileType from Contentversion where 
                                     ContentDocumentId = :ContentDocumentId];
            
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            String Title = bookingRcd.Name+'/'+conVer.Title+'.'+ conVer.FileType;
            efa.setFileName(Title);
            efa.setBody(conVer.VersionData);
            attachments.add(efa);
            
            //for send Email to Customer
        // Terms and Conditions Attchment
        List<id> ContentDocumentidsTC = new List<id>();

         for(contentDocumentLink CDLink : [SELECT LinkedEntityid, ContentDocumentid FROM contentDocumentLink WHERE LinkedEntityid=:bookingRcd.Project_Name__c ])
        {
            ContentDocumentidsTC.add(CDLink.ContentDocumentid);  
        }
        if (ContentDocumentidsTC != null && !ContentDocumentidsTC.isEmpty()) {
    	List<ContentVersion> cvList = [SELECT title, PathOnClient, FileType, versiondata, Document_Type__c,SObjectType__c
                                   FROM contentversion 
                                   WHERE ContentDocumentId IN :ContentDocumentidsTC order by CreatedDate desc limit 1];
            if (cvList != null && !cvList.isEmpty()){
                for (ContentVersion cv1 : cvList){
                    if(cv1.Document_Type__c=='Terms & Conditions' && cv1.SObjectType__c=='Project__c'){
                	Data = cv1.VersionData;
             		AttachmentName = cv1.Title;
                    filetype = cv1.FileType;
            }
            Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
            efa1.setFileName(AttachmentName+'.'+filetype);
            efa1.setBody(Data);
            attachments.add(efa1);
                }
            }
            
            
        } else {
            System.debug('List has no rows');
        }
        
        //Annexures Attchment
        //
        List<id> ContentDocumentidsAnnexure = new List<id>();
        for(contentDocumentLink CDLink : [SELECT LinkedEntityid, ContentDocumentid FROM contentDocumentLink WHERE LinkedEntityid=:bookingRcd.Related_Suggested_Property__r.Unit__c])
        {
            ContentDocumentidsAnnexure.add(CDLink.ContentDocumentid);  
        }
        
        if (ContentDocumentidsAnnexure != null && !ContentDocumentidsAnnexure.isEmpty()){
            List<ContentVersion> cvList2 = [SELECT title, PathOnClient, FileType, versiondata, Document_Type__c,SObjectType__c
                                   FROM contentversion 
                                   WHERE ContentDocumentId IN :ContentDocumentidsAnnexure order by CreatedDate desc limit 1];
            if (cvList2 != null && !cvList2.isEmpty()){
                for (ContentVersion cv2 : cvList2){
                    if(cv2.Document_Type__c=='Annexures' && cv2.SObjectType__c=='Property__c'){
                	DataAnnexure = cv2.VersionData;
             		AttcacmentNameAnnexure = cv2.Title;
                    fileTypeAnnexure = cv2.FileType;
            }
            Messaging.EmailFileAttachment efa2 = new Messaging.EmailFileAttachment();
            efa2.setFileName(AttcacmentNameAnnexure+'.'+fileTypeAnnexure);
            efa2.setBody(DataAnnexure);
            attachments.add(efa2);
            }
        }
        
        }
            
            
            OrgWideEmailAddress orgEmail;
            List<OrgWideEmailAddress> orgEmailList = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address = :bookingRcd.Project_Name__r.Project_Email__c];
            if (!orgEmailList.isEmpty()) {
                orgEmail = orgEmailList[0];
            } else {
            }

            //OrgWideEmailAddress orgEmail = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address = :bookingRcd.Project_Name__r.Project_Email__c];
            System.debug('orgEmail---->'+orgEmail);
            
            
            String Subject = emailTemplate.Subject;
            system.debug('subject ---'+emailTemplate.Subject);
            Subject = Subject.replace('{!Project}', bookingRcd.Project_Name__r.Name);
            Subject = Subject.replace('{!Unit}', bookingRcd.Unit_Number__c);
            
            List<Id> idList = new List<Id>();
                idList.add(conVer.Id);
            
            List<Messaging.SingleEmailMessage> emailMsgList = New List<Messaging.SingleEmailMessage>();

            if(bookingRcd.Primary_Applicant__r.PersonEmail != '' &&  bookingRcd.Primary_Applicant__r.PersonEmail != null)
            {   toMailList.add(bookingRcd.Primary_Applicant__r.PersonEmail );
                //Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(String.Valueof(emailTemplate.Id), bookingRcd.Primary_Applicant__r.PersonContactId, bookingRcd.id);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setHtmlBody(htmlBody);
                email.setPlainTextBody(plainBody);
                //email.setTargetObjectId(bookingRcd.Primary_Applicant__c);
                email.setToAddresses(toMailList);
                //email.setOrgWideEmailAddressId(orgEmail.Id);
                if (orgEmail != null) {
                    email.setOrgWideEmailAddressId(orgEmail.Id);
                } else {
                    System.debug('orgEmail.Id------>'+email);
                }
                email.setFileAttachments(attachments);
                email.setSubject(Subject);
                emailMsgList.add(email);
            }
            if (emailMsgList.size() > 0) 
            {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMsgList);
                if(results[0].success)
                {
                    System.debug('The email was sent successfully.');
                }
                else {
                    System.debug('The email failed to send: ' +  results[0].errors[0].message);
                } 
            }
            
            /*if(emailTemplate!=null && customerRecord.PersonEmail!=null){                
                List<String> emailList=new List<String>();           
                emailList.add(customerRecord.PersonEmail);            
                SendEmailandBellNotificationUtility.SendEmail(emailTemplate.Id,htmlBody,plainBody,emailList,null);           
            }*/
        }   
    }
}