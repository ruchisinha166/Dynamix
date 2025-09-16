public class SendEOI_CAFormToCustomer {
    @InvocableMethod(callout=true label='SendEOI_CAFormToCustomer')
    
    public static void SendMethod(List<requestWrapper> requestWrapperList) {
        //Send SMS
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();     
        
        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = :requestWrapperList[0].emailTemplateName LIMIT 1];
        Site mySite = [select Id from Site where Name = 'EOI_CA'];
        SiteDetail mySiteDetail = [select SecureURL from SiteDetail where DurableId = :mySite.Id];
        if(emailTemplate != null && requestWrapperList[0].personEmail != null && requestWrapperList[0].personEmail != ''){
            String formLink = mySiteDetail.SecureURL+'?id='+requestWrapperList[0].opportunityId;
            String htmlbody = emailTemplate.HtmlValue;
            String plainbody = emailTemplate.Body;
            String Subject = emailTemplate.Subject;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Subject = Subject.replace('{Project}',requestWrapperList[0].projectName);
            htmlbody = htmlbody.replace('{customerName}',requestWrapperList[0].Name);
            plainbody = plainbody.replace('{customerName}',requestWrapperList[0].Name);
            htmlbody = htmlbody.replace('{!Link}',formLink);
            plainbody = plainbody.replace('{!Link}',formLink);
             htmlbody = htmlbody.replace('{EOICANumber}',requestWrapperList[0].EOI_CA_Number);
            plainbody = plainbody.replace('{EOICANumber}',requestWrapperList[0].EOI_CA_Number);
            htmlbody = htmlbody.replace('{Project}',requestWrapperList[0].projectName);
            plainbody = plainbody.replace('{Project}',requestWrapperList[0].projectName);
            if(requestWrapperList[0].UnitNumber != null)
            {
                htmlbody = htmlbody.replace('{UnitNumber}',requestWrapperList[0].UnitNumber);
                plainbody = plainbody.replace('{UnitNumber}',requestWrapperList[0].UnitNumber);
            }
           
            mail.setToAddresses(new List<string>{requestWrapperList[0].personEmail});
            mail.setPlainTextBody(plainbody);
            mail.setHtmlBody(htmlbody);
            mail.setSubject(Subject);
            mail.setOrgWideEmailAddressId(requestWrapperList[0].organisationWideAddressId);
            mail.setSaveAsActivity(false);
            emailMessages.add(mail);
            EmailMessage objEmailMessage = new EmailMessage();
            objEmailMessage.status = '3'; // email was sent
            objEmailMessage.RelatedToId = requestWrapperList[0].opportunityId;
            objEmailMessage.fromName = 'Dynamix'; // from name
            objEmailMessage.Subject = 'Email sent to customer for EOI/CA Form';
            objEmailMessage.HtmlBody = htmlbody;
            objEmailMessage.ToAddress = requestWrapperList[0].personEmail;
            insert objEmailMessage;  
            if(!emailMessages.isempty())
            {
                try{
                    List<Messaging.SendEmailResult> sendResults = Messaging.sendEmail(emailMessages);
                }
                Catch(Exception Ex)
                {
                    system.debug('Error '+Ex.getMessage());
                }
            }
        }
    }
    public class requestWrapper{
        @InvocableVariable
        public String organisationWideAddressId;
        
        @InvocableVariable
        public String primaryMobileNumber;
        
        @InvocableVariable
        public String Name;
        
        @InvocableVariable
        public String opportunityId;
        
        @InvocableVariable
        public String personEmail;
        
         @InvocableVariable
        public String EOICA;
        
        @InvocableVariable
        public String UnitNumber;
        
        @InvocableVariable
        public String projectName;
        
        @InvocableVariable
        public String emailTemplateName;
        
        @InvocableVariable
        public String EOI_CA_Number;
        
    } 
    
}