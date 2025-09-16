public class EOI_CARefundEmail {
    @InvocableMethod
    public static void getOpportunityId(List<request> reqList){
        if(reqList != null){
            for(request req :reqList){
                EOI_CARefundEmail.sendRefundEmail(req.opportunityIds,req.fromAddress);
            }
        }
    }
    public static void sendRefundEmail(String opportunityIds,String fromAddress){
        List<EmailTemplate> emailTemp = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate 
                                             where DeveloperName =: 'EOI_CA_Refund_Email' limit 1];
        Opportunity opp = [Select Id,OwnerId,Owner.Email,Sales_Manager__c,Sales_Manager__r.Email from Opportunity where Id=:opportunityIds];
        List<String> receiverEmails = new List<String>();
        if(opp!=null){
            if(opp.OwnerId!=null){
                receiverEmails.add(opp.Owner.Email);
            }
            if(opp.Sales_Manager__c!=null){
                receiverEmails.add(opp.Sales_Manager__r.Email);
            }            
        }
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(emailTemp[0].Id, null, opp.Id);
        mail.setToAddresses(receiverEmails);
        mail.setOrgWideEmailAddressId(fromAddress);
        mail.setSaveAsActivity(true);
        mails.add(mail);
        if(!mails.isEmpty()){
            system.debug('Mail Message:- '+mails);
            Messaging.sendEmail(mails);
        }
    }
    public class request{
        @InvocableVariable (required=true)
        public string opportunityIds;
        @InvocableVariable (required=true)
        public string fromAddress;
    }
}