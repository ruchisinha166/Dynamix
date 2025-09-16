public class SendEmailClass {
    
    
    @InvocableMethod(label='Send Email Reminder')
    public static List<String> execute(List<Requests> requestLst){
        //system.debug('===> book Id ' + requestLst[0].bookingId);
        system.debug('===> Person Acc Id ' + requestLst[0].personAccountId);
        system.debug('===> Email Tem Id ' + requestLst[0].emailTemplateId);
        system.debug('===> Milestone Id ' + requestLst[0].MilestoneId);
        system.debug('===> Project Email '+requestLst[0].ProjectEmail);
        
        //Get Broker Payment record
        List<Broker_Payment__c> brokerPaymentList=[Select Id,Name,Booking__r.Name,Invoice_no__c,Broker_Payment_Owner_Email__c,Channel_Partner__c,Channel_Partner_Name__c,Channel_Partner__r.Phone,Booking__r.Primary_Applicant__c From Broker_Payment__c Where Id=:requestLst[0].MilestoneId];
        if(brokerPaymentList.size()>0){
            Broker_Payment__c brokerPaymentRcd=brokerPaymentList[0];
            //For Send WhatsApp Message
            communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp CP Brokerage Invoice Submit' Limit 1];
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
            EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS CP Brokerage Invoice Submit' Limit 1];
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
        return new List<String> {SendEmail(requestLst[0].personAccountId,requestLst[0].emailTemplateId,requestLst[0].MilestoneId,requestLst[0].ProjectEmail)};
            } 
    
    public static String SendEmail(String pId,String eId,String MId,string ProjectEmail){
        try{            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where Id =: eId];
            
            OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where Address =: ProjectEmail];
            
            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(String.Valueof(eId), String.Valueof(pId), MId);
            email.setTargetObjectId(String.Valueof(pId));
            email.setOrgWideEmailAddressId(orgEmail.Id);
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {email};
                try{
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    if(results[0].success){
                        System.debug('The email was sent successfully.');
                    }
                    else {
                        System.debug('The email failed to send: ' +  results[0].errors[0].message);
                    }   
                }
            catch(Exception e){
                
                system.debug(e);
            }
            
        }Catch(Exception e)
        {
            system.debug('==> e'  + e.getMessage()+e.getLineNumber());
        }
        
        
        
        return null;
    }
    public static String SendEmailReminder(map<id,id> mapBM,String EmailTemplateId){
        try{
            system.debug('EmailTemplateId=='+EmailTemplateId);
            system.debug('mapBM=='+mapBM);
            system.debug('mapBM.keyset()=='+mapBM.keyset());
            EmailTemplate emailTemplate = [Select Id,name,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where id=:EmailTemplateId];
            
            List<booking__c> bookinglist = new list<booking__c>();
            list<Co_Applicant__c> coAppList = new list<Co_Applicant__c>();
            bookinglist =[select id,Primary_Applicant__r.personcontactid,Project_Name__r.Project_Email__c from booking__c where id IN:mapBM.keyset()];
            coAppList= [select id,Account__c,Account__r.PersonContactId,Booking__c  from Co_Applicant__c where   Booking__c IN:mapBM.keyset()];
            system.debug('coAppList=='+coAppList);
            OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where Address =: bookinglist[0].Project_Name__r.Project_Email__c];
            system.debug('bookinglist=='+bookinglist);
            List<Messaging.SingleEmailMessage> emailMsgList = New List<Messaging.SingleEmailMessage>();
            if(bookinglist.size()>0 && coAppList.size()>0)
            {
                for(Co_Applicant__c c: coAppList)
                {
                    system.debug('c=='+c);
                    for(booking__c b: bookinglist)
                    {
                        if(c.booking__c==b.id && c.Account__r.PersonContactId!=null)
                        {  
                            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(String.Valueof(emailTemplate.Id), c.Account__r.PersonContactId, mapBM.get(b.id));
                            email.setTargetObjectId(c.Account__r.PersonContactId);
                            email.setOrgWideEmailAddressId(orgEmail.Id);
                            emailMsgList.add(email);
                        }    
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
            
        }Catch(Exception e)
        {
            system.debug('==> e'  + e.getMessage()+e.getLineNumber());
        }
        return null;
    }
    public class Requests {
        /*
@InvocableVariable(label='Booking Id' required=true)
public String bookingId ;
*/
        @InvocableVariable(label='Person Account Id' required=true)
        public String personAccountId;
        
        @InvocableVariable(label='Email Template Id' required=true)
        public String emailTemplateId;
        
        @InvocableVariable(label='Milestone Id' required=true)
        public String MilestoneId;
        
        @InvocableVariable(label='Project Email Address' required=true)
        public String ProjectEmail;
    }
}