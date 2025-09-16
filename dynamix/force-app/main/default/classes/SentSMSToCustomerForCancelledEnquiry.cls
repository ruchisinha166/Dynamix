public class SentSMSToCustomerForCancelledEnquiry {
    
    @InvocableMethod(callout=true label='Send SMS To Customer For Cancelled Enquiry')
    
    public static void SentSMSToCustomerForCancelledEnquiryMethod(List<requestWrapper> requestWrapperList) {
        //Send SMS
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS Sent To Cancel Site Visit' LIMIT 1];
        if(smsEmailTemp!=null && requestWrapperList[0].primaryMobileNumber != null){
            String templateBody=smsEmailTemp.HtmlValue;
            templateBody=templateBody.stripHtmlTags();
            String mobileNumber=requestWrapperList[0].primaryMobileNumber;
            String siteVisitTime = requestWrapperList[0].siteVisitTime.format('HH:mm a'); 
            system.debug('requestWrapperList[0].projectName'+ requestWrapperList[0].projectName);
            templateBody = templateBody.replace('{{Enquiry__c.Site_Visit_Date__c}}',string.valueof(requestWrapperList[0].siteVisitDate ));
            templateBody = templateBody.replace('{{Enquiry__c.Site_Visit_Time__c}}',siteVisitTime);
            templateBody = templateBody.replace('{{Enquiry__c.contactNumber}}', requestWrapperList[0].contactNumber);
            templateBody = templateBody.replace('{{Enquiry__c.Project_Name__c}}', requestWrapperList[0].projectName);
            if(!Test.isRunningTest()){
                SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
            }
            
            EmailMessage objEmailMessage = new EmailMessage();
            objEmailMessage.status = '3'; // email was sent
            objEmailMessage.RelatedToId = requestWrapperList[0].enquiryId;
            objEmailMessage.fromName = 'Dynamix'; // from name
            objEmailMessage.Subject = 'SMS sent to customer for cancellation of site visit';
            objEmailMessage.HtmlBody = templateBody;
            insertEmailMessageList.add(objEmailMessage);
            
        }
        if(!insertEmailMessageList.isEmpty())
        {
            insert insertEmailMessageList;
        }
    }
    
    
    
    public class requestWrapper{
        @InvocableVariable
        public String projectName;
        
        @InvocableVariable
        public String contactNumber;
        
        @InvocableVariable
        public date siteVisitDate;
        
        @InvocableVariable
        public datetime siteVisitTime;
        
        @InvocableVariable
        public String primaryMobileNumber;
        
        @InvocableVariable
        public String enquiryId;
        
        @InvocableVariable
        public String personAccountId;
        
        
    }    
}