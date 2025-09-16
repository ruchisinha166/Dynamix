public class GenerateInvoicePDF{
    @future(callout=true)
    public static void generateInvoice(String BookingId){
        Booking__c booking = [SELECT Id, Name,Project_Name__c,Project_Name__r.Project_Initials__c,Project_Name__r.Last_Receipt_Number__c,Project_Name__r.Last_Invoice_Number__c from Booking__c WHERE Id =: BookingId];
        Map<Id,Project__c> ProMap=New Map<Id,Project__c>([select id,Builder_Organization__r.name,Project_Initials__c,Last_Invoice_Number__c from project__c where id = :booking.Project_Name__c]);
        Project__c ProjList = [select id,Last_Invoice_Number__c from project__c where id =: booking.Project_Name__c];
        if(ProjList.Last_Invoice_Number__c == null)
        {
            ProjList.Last_Invoice_Number__c = 100;
        }
        else{
            ProjList.Last_Invoice_Number__c = ProjList.Last_Invoice_Number__c + 1;
        }
        List<ContentDocumentLink> cDLLst = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =: booking.id];
        system.debug('===> cDLLst ' + cDLLst );
        PageReference ref = Page.InvoiceFormat;
        ref.getParameters().put('id',booking.id);
        
        Blob body; 
        if(Test.isRunningTest()){
            body = Blob.valueOf('Invoice');
        }
        else{
            body = ref.getContent();
        }
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient = 'INV'+ '/' +booking.Project_Name__r.Project_Initials__c+ '/' +String.valueOf(ProjList.Last_Invoice_Number__c).leftPad(5, '0')+'.pdf'; 
        conVer.Title = 'INV'+ '/' + booking.Project_Name__r.Project_Initials__c+ '/' + String.valueOf(ProjList.Last_Invoice_Number__c).leftPad(5, '0') +'.pdf';
        conVer.VersionData = body;
        conVer.SObjectType__c = 'Booking__c';
        conVer.Document_Type__c = 'Invoice';
        insert conVer;    
        system.debug('conVer' + conVer);
        
        Update ProjList;
        
        ContentVersion contentverlink = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :conVer.Id LIMIT 1];
        system.debug('contentverlink==' + contentverlink);
        ContentDocumentLink contentlink = new ContentDocumentLink();
        system.debug('booking.id=='+booking.id);
        contentlink.LinkedEntityId = booking.id;
        system.debug('contentverlink.contentdocumentid=='+contentverlink.contentdocumentid);
        contentlink.contentdocumentid = contentverlink.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;
        system.debug('contentlink' + contentlink);
        SendEmail(contentlink,bookingId);
        
    }
    
    @future(callout=true)
    public static void generateInvoicelist(list<id> PaymentMilestonesId,Boolean isNewBooking){
        
        
        system.debug('PaymentMilestonesId : '+PaymentMilestonesId);
         system.debug('isNewBooking : '+isNewBooking);
        list<ContentVersion> conVerList = new list<ContentVersion>();
        list<id> conVerid = new list<id> ();
        list<id> bID = new list<id>();
        list<Payment_Milestones__c> paymentMilestone=[select id,Booking__c,Milestone_Status__c  from Payment_Milestones__c where id in :PaymentMilestonesId and Milestone_Status__c =:'Active'];
        list<id> BookingId=new list<id>();
        map<id,Booking__c> PBMap = new map<id,Booking__c>();
        for(Payment_Milestones__c pm:paymentMilestone){
            BookingId.add(pm.Booking__c);
        }
        list<Booking__c> booking = [SELECT Id, Name,Project_Name__c,Project_Name__r.Project_Initials__c,Project_Name__r.Last_Receipt_Number__c,Project_Name__r.Last_Invoice_Number__c from Booking__c WHERE Id in :BookingId];
        Map<String,String> bookingPMId=new Map<String,String>();
        for(Payment_Milestones__c p:paymentMilestone)
        {
            for(Booking__c b:booking)
            {
                system.debug('b.id=='+b.id);
                
                if(p.Booking__c==b.id)
                {
                    PBMap.put(p.id,b);
                    bookingPMId.put(b.Id, p.Id);
                }
            }
        }
        system.debug('booking :'+booking );
        list<id> ProjId=new list<id>();
        for(Booking__c b:booking)
        {
            ProjId.add(b.Project_Name__c);
        }
        Map<Id,Project__c> ProMap=New Map<Id,Project__c>([select id,Builder_Organization__r.Builder_Organisation_Initials__c,Project_Initials__c,Last_Invoice_Number__c from project__c where id =:ProjId]);
        Project__c ProjList;
        String builderOrg='';
        system.debug('ProMap: '+ProMap);
        for (booking__c pm : booking)
        {
            Booking__c b= pm;
            bID.add(pm.id); 
            ProjList=ProMap.get(b.Project_Name__c);
            if(ProjList != null)
            {
                if(ProjList.Last_Invoice_Number__c == null)
                {
                    ProjList.Last_Invoice_Number__c = 1000;
                }
                else{
                    ProjList.Last_Invoice_Number__c = ProjList.Last_Invoice_Number__c + 1;
                }
                
            }
            System.debug('bookingPMId:===>'+bookingPMId);
            System.debug('booking PaymentMilestoneId:===>'+bookingPMId.get(b.id));
            PageReference ref = Page.InvoiceFormat;
            ref.getParameters().put('id',b.id);
            ref.getParameters().put('InvoiceID',ProjList.Builder_Organization__r.Builder_Organisation_Initials__c+ '/' + b.Project_Name__r.Project_Initials__c+ '/' + Date.Today().Year() +'/'+ String.valueOf(ProjList.Last_Invoice_Number__c).leftPad(5, '0'));
            ref.getParameters().put('PaymentMilestoneId',bookingPMId.get(b.id));
            ref.getParameters().put('isNewBooking',String.valueOf(isNewBooking));
            
            Blob body; 
            if(Test.isRunningTest()){
                body = Blob.valueOf('Invoice');
            }
            else{
                body = ref.getContent();
            }
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
            conVer.PathOnClient = ProjList.Builder_Organization__r.Builder_Organisation_Initials__c+ '/' +b.Project_Name__r.Project_Initials__c+ '/' + Date.Today().Year() +'/'+String.valueOf(ProjList.Last_Invoice_Number__c).leftPad(5, '0')+'.pdf'; 
            conVer.Title =ProjList.Builder_Organization__r.Builder_Organisation_Initials__c+ '/' + b.Project_Name__r.Project_Initials__c+ '/' + Date.Today().Year() +'/'+ String.valueOf(ProjList.Last_Invoice_Number__c).leftPad(5, '0') +'.pdf';
            conVer.VersionData = body;
            conVer.SObjectType__c = 'Booking__c';
            conVer.Document_Type__c = 'Invoice';
            conVer.LinkedId__c=b.id;
            //insert conVer;
            conVerList.add(conVer);
            ProMap.put(b.Project_Name__c,ProjList);
            //Update ProjList;
            
            
        }
        insert conVerList;
        system.debug('conVerList=='+conVerList);
        for(ContentVersion c: conVerList)
        {
            conVerid.add(c.id);
        }
        system.debug('conVeridtest=='+conVerList);
        
        
        list<ContentVersion> contentverlink = [SELECT Id, Title,LinkedId__c, ContentDocumentId FROM ContentVersion WHERE Id IN: conVerid];
        list<ContentDocumentLink> cdlList= new list<ContentDocumentLink> ();
        for(ContentVersion cv:contentverlink)
        {
            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = cv.LinkedId__c;
            contentlink.contentdocumentid = cv.contentdocumentid;
            contentlink.ShareType = 'V';
            cdlList.add(contentlink);
        }   
        insert cdlList;
        update ProMap.values();
        // sendEmail(conVerid);
        
    }
    public static void SendEmail(list<id> conVerid){
        try{
            system.debug('conVerid=='+conVerid);
            set<string> emailAddress = new set<string>();
            map<string,id> emailAddressAndIdMap = new map<string,id>();
            List<Messaging.SingleEmailMessage> emailMsgList = New List<Messaging.SingleEmailMessage>();
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name =: 'Invoice Generate Notification'];
            
            List<Contentversion> conlist = [select id,LinkedId__c,ContentDocumentId,Title,VersionData from Contentversion where id IN : conVerid];
            map<string,Booking__c> conmap = new map<string,Booking__c>();
            list<id>  cid = new list<id>(); 
            for(Contentversion c: conlist)
            {
                cid.add(c.LinkedId__c);
            }   
            list<Booking__c> booking = [select id,Disable_All_Reminders__c,Project_Email__c,Project_Name__r.Project_Email__c,Primary_Applicant__r.PersonEmail,Primary_Applicant__r.PersonContactId from Booking__c where id IN:cid];
            for(Booking__c b: booking)
            {
                conmap.put(b.id,b);
                emailAddress.add(b.Project_Name__r.Project_Email__c);
                
            }
            List<OrgWideEmailAddress> orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where Address IN: emailAddress];   
            for(OrgWideEmailAddress org : orgEmail){
                emailAddressAndIdMap.put(org.Address,org.id);
            }
            system.debug('conlist=='+conlist);
            for (Contentversion cov : conlist) {
                List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(cov.Title);
                efa.setBody(cov.VersionData);
                attachments.add(efa);
                booking__c b= conmap.get(cov.LinkedId__c);
                if(b!=null)
                {
                    if(b.Disable_All_Reminders__c == false && b.Primary_Applicant__r.PersonContactId !=null)
                    {
                        Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(String.Valueof(emailTemplate.Id), b.Primary_Applicant__r.PersonContactId, b.id);
                        email.setTargetObjectId(b.Primary_Applicant__r.PersonContactId);
                        email.setOrgWideEmailAddressId(emailAddressAndIdMap.get(b.Project_Email__c));
                        email.setFileAttachments(attachments);
                        emailMsgList.add(email);
                        system.debug('emailMsgList=='+emailMsgList);
                    }
                }
            }
            if (emailMsgList.size() > 0) 
            {
                system.debug('emailMsgList=='+emailMsgList);
                Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMsgList);
                if(results[0].success){
                    System.debug('The email was sent successfully.');
                }
                else {
                    System.debug('The email failed to send: ' +  results[0].errors[0].message);
                } 
            }
            
        }
        Catch(Exception e)
        {
            system.debug(e );
        }       
    }
    public static void sendSMS(list<id> ids)
    {
        list<Payment_Milestones__c> paymentMilestone=[select id,Booking__c,Milestone_Status__c  from Payment_Milestones__c where id in :ids and Milestone_Status__c =:'Active'];
        set<id> BookingId=new set<id>();
        for(Payment_Milestones__c pm:paymentMilestone){
            BookingId.add(pm.Booking__c);
        }
        
        for(id b:BookingId){
            system.debug('b==='+b);
            SendSMS.sendSMSfun(b,System.Label.SMS_Demand_Letter); 
        }
    }
    public static void SendEmail(ContentDocumentLink contentlink, Id bkid){
        try{
            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
            List<Contentversion> conlist = [select id,ContentDocumentId,Title,LinkedId__c,VersionData from Contentversion where ContentDocumentId = :contentlink.ContentDocumentId];
            system.debug('===> conlist ' + conlist );
            for (Contentversion cov : conlist) {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(cov.Title);
                efa.setBody(cov.VersionData);
                // efa.setContentType(cov.ContentType);
                attachments.add(efa);
            }
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name =: 'Invoice Generate Notification'];
            
            Booking__c booking = [select id,Project_Name__r.Project_Email__c,Disable_All_Reminders__c,Primary_Applicant__r.PersonEmail,Primary_Applicant__r.PersonContactId from Booking__c where id=: bkid];
            set<string> emailAddress = new set<string>(); 
            if(booking.Project_Name__r.Project_Email__c != null)
            {
                emailAddress.add(booking.Project_Name__r.Project_Email__c);
            }
            
            OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where Address IN: emailAddress];
            
            
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
                    System.debug('The email was sent successfully.');
                }
                else {
                    System.debug('The email failed to send: ' +  results[0].errors[0].message);
                } 
            }
            
        }Catch(Exception e)
        {
            system.debug(e);
        }        
    }
}