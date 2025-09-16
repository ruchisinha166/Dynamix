public class CreateEmailMessage {
    @InvocableMethod(callout=true label='Create Email Message')
    public static void CreateEmailMessageMethod(List<requestWrapper> requestWrapperList) 
    {
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        
        EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name =: requestWrapperList[0].TemplateName LIMIT 1];
        if(smsEmailTemp!=null){
            try{
                String templateBody=smsEmailTemp.HtmlValue;
                templateBody=templateBody.stripHtmlTags();
                templateBody = templateBody.replace('{ProjectName}',requestWrapperList[0].projectName);
                templateBody = templateBody.replace('{GPS_location__c}', requestWrapperList[0].Location);
                templateBody = templateBody.replace('{brochureLink}', requestWrapperList[0].brochure);
                if(requestWrapperList[0].flatVideo != null && requestWrapperList[0].flatVideo != '')
                {
                  templateBody = templateBody.replace('{walkThrough}', requestWrapperList[0].flatVideo);  
                }
                templateBody = templateBody.replace('{contactNumber}', requestWrapperList[0].projectPhone);
                EmailMessage objEmailMessage = new EmailMessage();
                objEmailMessage.status = '3'; // email was sent
                objEmailMessage.RelatedToId = requestWrapperList[0].recordId;
                objEmailMessage.fromName = 'Dynamix'; // from name
                objEmailMessage.Subject = requestWrapperList[0].Subject;
                objEmailMessage.HtmlBody = templateBody;
                insertEmailMessageList.add(objEmailMessage);
                
            }
            catch(Exception ex)
            {
                system.debug('Error'+ex.getMessage()+' Line Number----' +ex.getLineNumber());
                
            }
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
        public String recordId;
        
        @InvocableVariable
        public String personAccountId;
        
        
        @InvocableVariable
        public String Subject;
        
        @InvocableVariable
        public String TemplateName;
        
        @InvocableVariable
        public String projectPhone;
        
    } 
    
}