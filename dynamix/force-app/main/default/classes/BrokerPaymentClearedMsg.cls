public class BrokerPaymentClearedMsg {
    @InvocableMethod(label='Send Message For Broker Payment Cleared')
    public static void execute(List<Request> Requests){
        //Get Broker Payment record
        Broker_Payment__c brokerPaymentRcd=[Select Id,Name,Booking__r.Name,Invoice_no__c,Broker_Payment_Owner_Email__c,Channel_Partner__c,Channel_Partner_Name__c,Channel_Partner__r.Phone,Booking__r.Primary_Applicant__c From Broker_Payment__c Where Id=:Requests[0].brokerPaymentId Limit 1];
        if(brokerPaymentRcd!=null){
            //For Send WhatsApp Message
            communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp CP Brokerage Invoice Payment Cl' Limit 1];
            System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
            if(regWhatEmailTemp!=null){
                String recipientAddress=brokerPaymentRcd.Channel_Partner__r.Phone;
                String recipientId=brokerPaymentRcd.Booking__r.Primary_Applicant__c;
                String emailTemplateId=String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
                String relatedToId=brokerPaymentRcd.Id;
                System.debug('recipientId:'+recipientId);
                System.debug('recipientAddress:'+recipientAddress);
                System.debug('emailTemplateId:'+emailTemplateId);
                if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                    SendWhatsAppMessageUtility.SendMessage(recipientAddress, recipientId, emailTemplateId,relatedToId);
                }
            }
            //for Send SMS
            EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS CP Brokerage Invoice Payment Cleared' Limit 1];
            if(smsEmailTemp!=null && brokerPaymentRcd.Channel_Partner__r.Phone!=null){
                String templateBody=smsEmailTemp.HtmlValue;
                String mobileNumber=brokerPaymentRcd.Channel_Partner__r.Phone;
                templateBody = templateBody.replace('{{{Broker_Payment__c.Channel_Partner_Name__c}}}',brokerPaymentRcd.Channel_Partner_Name__c);
                templateBody = templateBody.replace('{{{Broker_Payment__c.Invoice_no__c}}}',brokerPaymentRcd.Invoice_no__c);
                templateBody = templateBody.replace('{{{Broker_Payment__c.Booking__c}}}',brokerPaymentRcd.Booking__r.Name);
                templateBody = templateBody.replace('{{{Broker_Payment__c.Broker_Payment_Owner_Email__c}}}',brokerPaymentRcd.Broker_Payment_Owner_Email__c);
                templateBody=templateBody.stripHtmlTags();
                System.debug('templateBody:'+templateBody);
                SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
            }            
        }      
    }
    public class Request {
        @InvocableVariable(label='Broker Payment Id' required=true)
        public Id brokerPaymentId;
    }
}