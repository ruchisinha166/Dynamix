public with sharing class GenerateRefundletter{
    
    @InvocableMethod(label='Generate Refund letter')
    public static List<String> execute(List<Request> Requests){
        ContentVersion conVer;
        ContentVersion conVerRnote;
        list<ContentDocumentLink> conDocList = new list<ContentDocumentLink>();
        
        booking__c bookingobj = [select id,Name,Project_Name__r.Project_Email__c,Tower_Name__r.Name,Primary_Applicant__c,Property_Name__c,Primary_Applicant__r.PersonMobilePhone,Primary_Applicant_Name_Formulla__c,Booking_Owner_Name__c,Booking_Owner_Email__c from Booking__c where id=: Requests[0].bookingId];
        Account acc = [select id,personcontactid from Account where id=:bookingobj.Primary_Applicant__c];
        List<contact> conList = [select id,phone,AccountID from contact where AccountID=:bookingobj.Primary_Applicant__c ];
        PageReference refRnote;
        Blob bodyRnote;
        system.debug('closedReason=='+Requests[0].closedReason);
        system.debug('PaymentType=='+Requests[0].PaymentType);
        system.debug('bookingId=='+Requests[0].bookingId);
        system.debug('paymentId=='+Requests[0].paymentId);
        
        if(Requests[0].closedReason=='Cancelled' && Requests[0].PaymentType=='Cheque')
        {
            refRnote =  page.Cancellation_Refund_Letter_Cheque;
            refRnote.getParameters().put('payid', Requests[0].paymentId);
            system.debug('acc.personcontactid=='+acc.personcontactid);
            system.debug('System.Label.Refund_Note_Cancellation=='+System.Label.Refund_Note_Cancellation);
            system.debug('Requests[0].paymentId=='+Requests[0].paymentId);
            SendEmailClass.SendEmail(acc.personcontactid ,System.Label.Refund_Note_Cancellation,Requests[0].paymentId,bookingobj.Project_Name__r.Project_Email__c);
            SendSMSclass.SendSMS(Requests[0].bookingId,Requests[0].paymentId,System.Label.SMS_Cancellation_Booking_Cheque);
            //  SendSMS.sendSMSforPayment(Requests[0].bookingId,Requests[0].paymentId,System.Label.SMS_Cancellation_Booking_Cheque); 
            SendWhatsappMsg.sendwhsmsForPayment(System.Label.Whatsapp_Cheque_Refund_Details_Cancellat,bookingobj.Id,Requests[0].paymentId);
        }
        else if(Requests[0].closedReason=='Cancelled' && Requests[0].PaymentType=='NEFT/ RTGS/ IMPS')
        {
            refRnote =  page.Cancellation_Refund_Letter_RTGS;
            // refRnote.getParameters().put('id',Requests[0].bookingId);
            refRnote.getParameters().put('payid', Requests[0].paymentId);
            system.debug('acc.personcontactid=='+acc.personcontactid);
            system.debug('System.Label.Refund_Note_Cancellation=='+System.Label.Refund_Note_Cancellation);
            system.debug('Requests[0].paymentId=='+Requests[0].paymentId);
            SendEmailClass.SendEmail(acc.personcontactid ,System.Label.Refund_Note_Cancellation,Requests[0].paymentId,bookingobj.Project_Name__r.Project_Email__c);
            SendSMSclass.SendSMS(Requests[0].bookingId,Requests[0].paymentId,System.Label.SMS_Cancellation_Booking_RTGS);
            //  SendSMS.sendSMSforPayment(Requests[0].bookingId,Requests[0].paymentId,System.Label.SMS_Cancellation_Booking_RTGS);
            SendWhatsappMsg.sendwhsmsForPayment(System.Label.WhatsApp_Rtgs_refund_cancellation,bookingobj.Id,Requests[0].paymentId);
        }
        else if(Requests[0].closedReason=='Terminated' && Requests[0].PaymentType=='Cheque')
        {
            refRnote =  page.Termination_Refund_Letter_Cheque;
            //refRnote.getParameters().put('id',Requests[0].bookingId);
            refRnote.getParameters().put('payid', Requests[0].paymentId);
            system.debug('acc.personcontactid=='+acc.personcontactid);
            system.debug('System.Label.Refund_Note_Cancellation=='+System.Label.Refund_Note_Cancellation);
            system.debug('Requests[0].paymentId=='+Requests[0].paymentId);
            SendEmailClass.SendEmail(acc.personcontactid ,System.Label.Refund_Note_Termination,Requests[0].paymentId,bookingobj.Project_Name__r.Project_Email__c);
            SendSMSclass.SendSMS(Requests[0].bookingId,Requests[0].paymentId,System.Label.SMS_Termination_Booking_Cheque); 
            //    SendSMS.sendSMSforPayment(Requests[0].bookingId,Requests[0].paymentId,System.Label.SMS_Termination_Booking_Cheque);
            SendWhatsappMsg.sendwhsmsForPayment(System.Label.Whatsapp_Cheque_Refund_Details_Terminati,bookingobj.Id,Requests[0].paymentId);
        }
        else if(Requests[0].closedReason=='Terminated' && Requests[0].PaymentType=='NEFT/ RTGS/ IMPS')
        {
            refRnote =  page.Termination_Refund_Letter_RTGS;
            // refRnote.getParameters().put('id',Requests[0].bookingId);
            refRnote.getParameters().put('payid', Requests[0].paymentId);
            system.debug('acc.personcontactid=='+acc.personcontactid);
            system.debug('System.Label.Refund_Note_Cancellation=='+System.Label.Refund_Note_Cancellation);
            system.debug('Requests[0].paymentId=='+Requests[0].paymentId);
            SendEmailClass.SendEmail(acc.personcontactid ,System.Label.Refund_Note_Termination,Requests[0].paymentId,bookingobj.Project_Name__r.Project_Email__c);  
            SendSMSclass.SendSMS(Requests[0].bookingId,Requests[0].paymentId,System.Label.SMS_Termination_Booking_RTGS); 
            //   SendSMS.sendSMSforPayment(Requests[0].bookingId,Requests[0].paymentId,System.Label.SMS_Termination_Booking_RTGS);
            SendWhatsappMsg.sendwhsmsForPayment(System.Label.WhatsApp_RTgs_refund_termina,bookingobj.Id,Requests[0].paymentId);
        }
        
        
        
        
        
        if(Test.isRunningTest()){
            bodyRnote = Blob.valueOf('Refund Note');
        }
        else{
            bodyRnote = refRnote.getContent();
        }
        
        conVerRnote = new ContentVersion();
        conVerRnote.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVerRnote.PathOnClient = 'Refund Note/'+String.valueof(bookingobj.Tower_Name__r.Name)+'/'+String.valueof(bookingobj.Property_Name__c)+'.pdf'; 
        conVerRnote.Title = 'Refund Note/'+String.valueof(bookingobj.Tower_Name__r.Name)+'/'+String.valueof(bookingobj.Property_Name__c)+'.pdf'; 
        conVerRnote.VersionData = bodyRnote;
        conVerRnote.SObjectType__c = 'Booking__c';
        conVerRnote.Document_Type__c = 'Flat Refund';
        insert conVerRnote;
        system.debug('===> conVerRnote '+ conVerRnote);
        list<ContentVersion> conVerList= [SELECT ContentDocumentId,CreatedDate FROM ContentVersion WHERE Id =: conVerRnote.Id order by CreatedDate desc];
        system.debug('===> conVerList'+ conVerList);
        If(conVerList.size()>0)
        {
            for(ContentVersion con :conVerList)
            {
                ContentDocumentLink conDocLink = New ContentDocumentLink();
                conDocLink.LinkedEntityId = Requests[0].bookingId; 
                conDocLink.ContentDocumentId = con.ContentDocumentId;  
                conDocLink.shareType = 'V';
                conDocList.add(conDocLink);
            }
        }    
        insert conDocList;
        system.debug('===> conDocList'+ conDocList);
        
        //For Send WhatsApp Message       
        communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp Booking Refund' Limit 1];
        System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
        if(regWhatEmailTemp!=null){
            String recipientAddress=bookingobj.Primary_Applicant__r.PersonMobilePhone;
            String recipientId=bookingobj.Primary_Applicant__c;
            String emailTemplateId=String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
            String relatedToId=bookingobj.Id;
            System.debug('emailTemplateId:'+emailTemplateId);
            if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                SendWhatsAppMessageUtility.SendMessage(recipientAddress, recipientId, emailTemplateId,relatedToId);
            }
        }
        //for Send SMS
        EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Booking Refund' Limit 1];
        if(smsEmailTemp!=null && bookingobj.Primary_Applicant__r.PersonMobilePhone!=null){
            String templateBody=smsEmailTemp.HtmlValue;
            templateBody=templateBody.stripHtmlTags();
            String mobileNumber=bookingobj.Primary_Applicant__r.PersonMobilePhone;
            templateBody = templateBody.replace('{{{Booking__c.Primary_Applicant_Name_Formulla__c}}}', bookingobj.Primary_Applicant_Name_Formulla__c);
            templateBody = templateBody.replace('{{{Booking__c.Name}}}', bookingobj.Name);
            templateBody = templateBody.replace('{{{Booking__c.Booking_Owner_Name__c}}}', bookingobj.Booking_Owner_Name__c);
            templateBody = templateBody.replace('{{{Booking__c.Booking_Owner_Email__c}}}', bookingobj.Booking_Owner_Email__c);
            SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYMXGP');
        }
        return new List<String>{conVerList[0].ContentDocumentId};
           
            }
    
    public class Request {
        @InvocableVariable(label='Booking Id' required=true)
        public id bookingId;
        
        @InvocableVariable(label='Payment Id' required=true)
        public String paymentId;
        
        @InvocableVariable(label='closed Reson' required=true)
        public String closedReason;
        
        @InvocableVariable(label='Payment Type' required=true)
        public String PaymentType;
        
    }
}