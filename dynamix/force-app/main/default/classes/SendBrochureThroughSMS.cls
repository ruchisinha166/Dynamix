public class SendBrochureThroughSMS {
    @InvocableMethod(callout=true label='Send Brochure Throw Whatapp And SMS')
    
    public static void SendBrochureThroughSMSMethod(List<requestWrapper> requestWrapperList) {
        //Send SMS
        EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS Brochure sent' LIMIT 1];
        system.debug('smsEmailTemp----'+smsEmailTemp);
        if(smsEmailTemp!=null && requestWrapperList[0].primaryMobileNumber != null){
            String templateBody=smsEmailTemp.HtmlValue;
            templateBody=templateBody.stripHtmlTags();
            String mobileNumber=requestWrapperList[0].primaryMobileNumber;
            system.debug('requestWrapperList[0].projectName'+ requestWrapperList[0].projectName);
            templateBody = templateBody.replace('{{{Project__c.GPS_location__c}}}',requestWrapperList[0].Location);
            templateBody = templateBody.replace('{{{Project__c.Brochure__c}}}', requestWrapperList[0].brochure);
            templateBody = templateBody.replace('{{{Enquiry__c.ProjectName__c}}}', requestWrapperList[0].projectName);
            templateBody = templateBody.replace('{{{Project__c.Project_Area__c}}}', requestWrapperList[0].projectArea);
            templateBody = templateBody.replace('{{{contactNumber}}}', requestWrapperList[0].projectPhone);
            templateBody = templateBody.replace('{{{Project__c.Show_flat_walkthrough_video__c}}}',+requestWrapperList[0].flatVideo );
            system.debug('templateBody----'+templateBody);
            if(!Test.isRunningTest())
            {
                SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
            }
            
        }
    }
    public class requestWrapper{
        @InvocableVariable
        public String projectName;
        
        @InvocableVariable
        public String projectArea;
        
        @InvocableVariable
        public String flatVideo;
        
        @InvocableVariable
        public String primaryMobileNumber;
        
        @InvocableVariable
        public String Location;
        
        @InvocableVariable
        public String brochure;
        
        @InvocableVariable
        public String enquiryId;
        
        @InvocableVariable
        public String personAccountId;
        
        @InvocableVariable
        public String projectPhone;
    }  
}