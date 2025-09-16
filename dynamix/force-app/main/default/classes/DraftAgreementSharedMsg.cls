public class DraftAgreementSharedMsg {
    @InvocableMethod(label='Send Message For Draft Agreement Shared')
    public static void execute(List<Request> Requests){
        Booking__c bookingRcd = [select Id, Name,Primary_Applicant__c,Project_Name_Formulla__c,Primary_Applicant__r.PersonMobilePhone,Owner.Name,Primary_Applicant_Name_Formulla__c FROM Booking__c WHERE Id=: Requests[0].bookingRecodId];
        System.debug('bookingRcd:'+bookingRcd);
        if(bookingRcd!=null){
            //For Send WhatsApp Message
            communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp Draft Agreement Sent' Limit 1];
            System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
            if(regWhatEmailTemp!=null){
                String recipientAddress=bookingRcd.Primary_Applicant__r.PersonMobilePhone;
                String recipientId=bookingRcd.Primary_Applicant__c;
                String emailTemplateId=String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
                String relatedToId=bookingRcd.Id;
                System.debug('emailTemplateId:'+emailTemplateId);
                if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                    SendWhatsAppMessageUtility.SendMessage(recipientAddress, recipientId, emailTemplateId,relatedToId);
                }
            }
            //for Send SMS
            EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Draft Agreement Sent' Limit 1];
            if(smsEmailTemp!=null && bookingRcd.Primary_Applicant__r.PersonMobilePhone!=null){
                String templateBody=smsEmailTemp.HtmlValue;
                String mobileNumber=bookingRcd.Primary_Applicant__r.PersonMobilePhone;
                templateBody = templateBody.replace('{{{Booking__c.Primary_Applicant_Name_Formulla__c}}}',bookingRcd.Primary_Applicant_Name_Formulla__c);
                templateBody = templateBody.replace('{{{Booking__c.Name}}}',bookingRcd.Name);
                templateBody = templateBody.replace('{{{Booking__c.Booking_Owner_Name__c}}}',bookingRcd.Owner.Name);
                templateBody=templateBody.stripHtmlTags();
                System.debug('templateBody:'+templateBody);
                SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
            }            
        }      
    }
    public class Request {
        @InvocableVariable(label='Booking Record Id' required=true)
        public Id bookingRecodId;
    }
}