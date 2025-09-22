public class SendSMSHandler {
    public static void sendSMSOnNewOpportunity(list<opportunity> oppList) {
        set<id> oppids = new set<id>();
        
        for(Opportunity opp : oppList){
            oppids.add(opp.id);
        }
        list<Opportunity> requestWrapperList = [Select id,Name , Project__r.Name ,Sales_Manager__r.Phone From opportunity where id IN : oppids LIMIT 1  ];
        List<EmailMessage> insertEmailMessageList = new List<EmailMessage>();
        SMS_Template_Id__mdt smsTemplate = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='SMS for New Opportunity to Sales Manager' Limit 1];
        EmailTemplate smsEmailTemp = [SELECT Id, Name, Subject, HtmlValue, Body, DeveloperName FROM EmailTemplate WHERE Name = 'SMS for New Opportunity to Sales Manager' LIMIT 1];

        if (smsEmailTemp != null && smsTemplate!=null && !requestWrapperList.isEmpty() && requestWrapperList[0].Sales_Manager__r.Phone != null) {
            String templateBody = smsEmailTemp.HtmlValue;
            templateBody = templateBody.stripHtmlTags();
            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            String sfdcRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + requestWrapperList[0].id;
            String mobileNumber = requestWrapperList[0].Sales_Manager__r.Phone;
            templateBody = templateBody.replace('{{accountName}}', requestWrapperList[0].Name);
            templateBody = templateBody.replace('{{projectName}}', requestWrapperList[0].Project__r.Name);
            templateBody = templateBody.replace('{{opportunityLink}}', '{{3}}');
            if(!Test.isRunningTest())
            {
                //SendSMSUtility.sendSMS(templateBody, mobileNumber, 'DYNAMX'); 
                SendSMSUtility.sendSMSMethod(templateBody,mobileNumber,'DYNAMX',smsTemplate.External_Template_Id__c);
                
            }
           
            EmailMessage objEmailMessage = new EmailMessage();
            objEmailMessage.Status = '3'; // email was sent
            objEmailMessage.RelatedToId = requestWrapperList[0].id;
            objEmailMessage.FromName = 'Dynamix'; // from name
            objEmailMessage.Subject = 'SMS sent to Sales Manager for Opportunity Creation';
            objEmailMessage.HtmlBody = templateBody;
            insertEmailMessageList.add(objEmailMessage);
        }
        if (!insertEmailMessageList.isEmpty()) {
            insert insertEmailMessageList;
        }
    }
}


/*public class SendSMSonNewOpportunity {
    @InvocableMethod(callout=true label='Send SMS To Customer On New Opportunity')
    
    public static void SendNotificationToCustomerOnSVSMethod(List<requestWrapper> requestWrapperList) {
        //Send SMS
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        
        EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS for New Opportunity to Sales Manager' LIMIT 1];
        system.debug('smsEmailTemp'+smsEmailTemp);
        if(smsEmailTemp!=null && requestWrapperList[0].salesManagerNumber != null){
            String templateBody=smsEmailTemp.HtmlValue;
            templateBody=templateBody.stripHtmlTags();
            string sfdcBaseURL=URL.getSalesforceBaseUrl().toExternalForm();
            string sfdcRecordURL= URL.getSalesforceBaseUrl().toExternalForm()+'/'+ requestWrapperList[0].recordId;
            String mobileNumber = requestWrapperList[0].salesManagerNumber;
            templateBody = templateBody.replace('{{accountName}}', requestWrapperList[0].opportunityName);
            templateBody = templateBody.replace('{{projectName}}', requestWrapperList[0].projectName);
            templateBody = templateBody.replace('{{opportunityLink}}', sfdcRecordURL);
            SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
            EmailMessage objEmailMessage = new EmailMessage();
            objEmailMessage.status = '3'; // email was sent
            objEmailMessage.RelatedToId = requestWrapperList[0].recordId;
            objEmailMessage.fromName = 'Dynamix'; // from name
            objEmailMessage.Subject = 'SMS sent to Sales Manager for Opportunity Creation';
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
        public date siteVisitDate;
        
        @InvocableVariable
        public datetime siteVisitTime;
        
        @InvocableVariable
        public String primaryMobileNumber;
        
        @InvocableVariable
        public String meetingLocation;
        
        @InvocableVariable
        public String salesManagerNumber;
        
        @InvocableVariable
        public String recordId;
        
        @InvocableVariable
        public String opportunityName;
        
        @InvocableVariable
        public String contactNumber;
    }    
}*/