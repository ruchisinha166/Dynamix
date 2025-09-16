public class GeneratePaymentReceipt {
    
    @InvocableMethod(label='Generate Payment Receipt')
    public static List<String> execute( List<Requests> requestLst){
        system.debug('Line number 5 ---------'+requestLst[0].paymentId);
        
        PageReference ref = Page.Payment_Receipt;
        ref.getParameters().put('id', requestLst[0].paymentId);
        Payment__c paymentRec = [Select Id,Receipt_No__c,Receipt_No_Hidden__c from Payment__c where Id =:requestLst[0].paymentId];
        Blob body; 
        if(Test.isRunningTest()){
            body = Blob.valueOf('Payment Receipt');
        }
        else{
            body = ref.getContent();
        }

        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient =  paymentRec.Receipt_No_Hidden__c +'.pdf';
        conVer.Title =  paymentRec.Receipt_No_Hidden__c +'.pdf';
        conVer.VersionData = body;
        conVer.SObjectType__c = 'Booking__c';
        conVer.Document_Type__c = 'Payment Receipt';
        insert conVer;    
       
        
        // First get the Content Document Id from ContentVersion Object
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = requestLst[0].bookingId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        
        insert conDocLink;

        ContentDocumentLink conDocLink1 = New ContentDocumentLink();
        conDocLink1.LinkedEntityId = requestLst[0].paymentId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink1.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink1.shareType = 'V';
        
        insert conDocLink1;
       
        SendEmail(conDocLink1,requestLst[0].bookingId);

        return new List<String>{conDoc};
    }
    public static void SendEmail(ContentDocumentLink conDocLink1, Id bkid){
            
           try{
           List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
          
            List<Contentversion> conlist = [select id,ContentDocumentId,Title,VersionData from Contentversion where ContentDocumentId = :conDocLink1.ContentDocumentId];
             
            for (Contentversion cov : conlist) {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(cov.Title);
                efa.setBody(cov.VersionData);
               // efa.setContentType(cov.ContentType);
                attachments.add(efa);
            }
            
           
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name =: 'Generate PMT Notification'];
            system.debug('emailTemplate'+emailTemplate);
            Booking__c booking = [select id,Disable_All_Reminders__c,Project_Name__r.Project_Email__c,Primary_Applicant__r.PersonEmail,Primary_Applicant__r.PersonContactId from Booking__c where id=: bkid];
            OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where Address =: booking.Project_Name__r.Project_Email__c];   
            
            
            List<Messaging.SingleEmailMessage> emailMsgList = New List<Messaging.SingleEmailMessage>();
             if(booking.Disable_All_Reminders__c == false)
            {
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(String.Valueof(emailTemplate.Id), booking.Primary_Applicant__r.PersonContactId, booking.id);
                email.setTargetObjectId(booking.Primary_Applicant__r.PersonContactId);
                email.setOrgWideEmailAddressId(orgEmail.Id);
                email.setFileAttachments(attachments);
                emailMsgList.add(email);
            }
            
              if (emailMsgList.size() > 0) 
            {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMsgList);
                if(results[0].success){
                    System.debug('The Payment Receipt email was sent successfully.');
                }
                else {
                    System.debug('The Payment Receipt email failed to send: ' +  results[0].errors[0].message);
                } 
            }
            }Catch(Exception e)
            {
                system.debug(e);
            }
      
            
    }
    public class Requests {
        @InvocableVariable(label='Payment Id' required=true)
        public String paymentId;

        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
    }
}