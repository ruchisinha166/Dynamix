public class GeneratePaymentReceiptForWaiveOff {
    @future(callout=true)
    public static void GeneratePaymentReceipt(string bookingld,string paymentId){
        system.debug('Line number  ---------' + paymentId);
        system.debug('Line number  ---------' + bookingld);
        PageReference ref = Page.Payment_Receipt;
        ref.getParameters().put('id', paymentId);
        
        Payment__c paymentRec = [Select Id,Receipt_No__c,Payment_Type__c,Project_Name__c, Booking__c from Payment__c where Id =:paymentId];
        system.debug('paymentRec----->' +paymentRec);
        
        Blob body; 
        
        if(Test.isRunningTest()){
            body = Blob.valueOf('Payment Receipt');
        }
        else{
            body = ref.getContent();
        }
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; 
        conVer.PathOnClient =  paymentRec.Receipt_No__c+'.pdf';
        conVer.Title =  paymentRec.Receipt_No__c+'.pdf';
        conVer.VersionData = body;
        conVer.SObjectType__c = 'Booking__c';
        conVer.BookingId__c = paymentRec.Booking__c;
        conVer.Document_Type__c = 'Payment Receipt';
        insert conVer; 
        System.debug('conVer--------->'+conVer);
        
        /* ContentVersion conVer2 = new ContentVersion();
conVer2.ContentLocation = 'S'; 
conVer2.PathOnClient =  paymentRec.Receipt_No__c+'.pdf';
conVer2.Title =  paymentRec.Receipt_No__c+'.pdf';
conVer2.VersionData = body;
conVer2.SObjectType__c = 'Payment__c';
conVer2.BookingId__c = paymentRec.Id;
//conVer2.Document_Type__c = 'Payment Receipt';
insert conVer2; 
System.debug('conVer--------->'+conVer2);*/
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        System.debug('conDoc----------->'+conDoc);
        
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = bookingld; 
        conDocLink.ContentDocumentId = conDoc;  
        conDocLink.shareType = 'V';
        insert conDocLink;
        
        ContentDocumentLink conDocLink1 = New ContentDocumentLink();
        conDocLink1.LinkedEntityId = paymentId; 
        conDocLink1.ContentDocumentId = conDoc; 
        conDocLink1.shareType = 'V';
        insert conDocLink1;
        Boolean checkEmailSending = Boolean.valueOf(System.Label.Credit_Note_Receipt_Email);
        Boolean checkCondition = Boolean.valueOf(System.Label.Payment_Receipt_Send_to_Cusomer);
        if(paymentRec.Payment_Type__c=='SAP Credit Note' && checkEmailSending){
            SendEmail(conDocLink1,bookingld,paymentId);
        }
        else if(paymentRec.Payment_Type__c!='SAP Credit Note' && checkCondition){
            SendEmail(conDocLink1,bookingld,paymentId);
        }
    }
    public static void SendEmail(ContentDocumentLink conDocLink1, Id bkid, id payId){
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        List<String> toMailList = New List<String>();
        Booking__c booking = [select id, Disable_All_Reminders__c,Related_Opportunity__c, Project_Name__c,Related_Suggested_Property__c,
                              Project_Name__r.Name,Unit_Number__c,Project_Name__r.Project_Email__c, Primary_Applicant__r.PersonEmail,
                              Primary_Applicant__r.PersonContactId
                              from Booking__c where id=: bkid];
        System.debug('booking----->'+booking);
        
        Suggested_Property__c suggestedProperty = [Select Id, Unit__c,Unit__r.Name from Suggested_Property__c where Id =:booking.Related_Suggested_Property__c ];
        
        List<Contentversion> conlist = [select id,ContentDocumentId,Title,VersionData from Contentversion where ContentDocumentId = :conDocLink1.ContentDocumentId];
        System.debug('conlist---------->'+conlist);
        
        for (Contentversion cov : conlist) {
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            String Title = booking.Project_Name__r.Name+ '/'+ booking.Unit_Number__c+'/'+cov.Title;
            System.debug('Title----------->'+Title);
            
            efa.setFileName(Title);
            efa.setBody(cov.VersionData);
            attachments.add(efa);
            System.debug('efa:--------' +efa);
        }
        system.debug('attachments'+attachments);  
        
        EmailTemplate emailTemplate = [SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body FROM EmailTemplate WHERE Name = 'Generate Payment Notification'];	//Receipt'];
        System.debug('emailTemplate---------->'+emailTemplate);
        OrgWideEmailAddress orgEmail = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address =: booking.Project_Name__r.Project_Email__c];
        System.debug('orgEmail--------->'+orgEmail);
        String bookingFormLink = Label.Booking_Form_Link;
        bookingFormLink += '?Id=' + booking.Id;
        
        String Subject = emailTemplate.Subject;
        if (booking != null && booking.Project_Name__c != null && booking.Project_Name__r.Name != null) {
            Subject = Subject.replace('Booking__c.Project_Name__r.Name', booking.Project_Name__r.Name);
        }
        if(suggestedProperty != null && suggestedProperty.Unit__c != null && suggestedProperty.Unit__r.Name != null){
            Subject = Subject.replace('suggestedProperty.Unit__r.Name', suggestedProperty.Unit__r.Name);
        }
        if(booking != null && booking.Unit_Number__c != null){
            Subject = Subject.replace('Booking__c.Unit_Number__c', booking.Unit_Number__c);
        }
        
        Subject = Subject.replace('{!bookingFormLink}', bookingFormLink);      
        
        List<Messaging.SingleEmailMessage> emailMsgList = New List<Messaging.SingleEmailMessage>();
        Boolean checkCondition = Boolean.valueOf(System.Label.Payment_Receipt_Send_to_Cusomer);
        if(checkCondition){
            if(booking.Primary_Applicant__r.PersonEmail != '' &&  booking.Primary_Applicant__r.PersonEmail != null)
            {
                List<Id> idList = new List<Id>();
                for (Contentversion con : conlist) {
                    idList.add(con.Id);
                }
                toMailList.add(booking.Primary_Applicant__r.PersonEmail);
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(String.Valueof(emailTemplate.Id), null, booking.id);
                // email.setTargetObjectId(booking.Primary_Applicant__r.PersonContactId);
                email.setOrgWideEmailAddressId(orgEmail.Id);
                email.setToAddresses(toMailList);
                email.setEntityAttachments(new List<Id>(idList));
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
        }
    }
}