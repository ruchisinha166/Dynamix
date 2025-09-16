public class ShareCollateralForOppOnWhatsapp {
    
    @InvocableMethod(callout=true label='Share Collateral For Opportunity On Whatsapp')
    
    public static void ShareCollateralForOppOnWhatsappMethod(List<requestWrapper> requestWrapperList) {
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        //Whatsapp
        if(requestWrapperList[0].walkThrough == true){
            communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,communicat_o__External_Template_Id__c From communicat_o__Registered_Template__mdt Where QualifiedApiName=:'Whatsapp_Of_Share_Collateral_With_Walk_T' Limit 1];
            System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
            if(regWhatEmailTemp != null ){
                String recipientAddress = requestWrapperList[0].primaryMobileNumber;
                String recipientId = requestWrapperList[0].personAccountId;
                String emailTemplateId = String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
                String relatedToId = requestWrapperList[0].opportunityId;
                List<string> arguments = New List<string>{requestWrapperList[0].projectName,requestWrapperList[0].Location,requestWrapperList[0].brochure,requestWrapperList[0].flatVideo,requestWrapperList[0].projectPhone};
                System.debug('emailTemplateId:'+emailTemplateId);
                if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                    if(!Test.isRunningTest())
                    {
                        SendWhatsAppMessageUtility.SendWhatsappMessage(recipientAddress, recipientId,emailTemplateId, relatedToId ,regWhatEmailTemp.communicat_o__External_Template_Id__c ,arguments);
                    }
                }
                
                EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'Whatsapp Of Share Collateral With Walk Through' LIMIT 1];
                if(smsEmailTemp!=null && requestWrapperList[0].primaryMobileNumber != null){
                    try{
                        String templateBody=smsEmailTemp.HtmlValue;
                        templateBody=templateBody.stripHtmlTags();
                        String mobileNumber=requestWrapperList[0].primaryMobileNumber;
                        templateBody = templateBody.replace('{ProjectName}',requestWrapperList[0].projectName);
                        templateBody = templateBody.replace('{GPS_location__c}', requestWrapperList[0].Location);
                        templateBody = templateBody.replace('{brochureLink}', requestWrapperList[0].brochure);
                        templateBody = templateBody.replace('{walkThrough}', requestWrapperList[0].flatVideo);
                        templateBody = templateBody.replace('{contactNumber}', requestWrapperList[0].projectPhone);
                        if(!Test.isRunningTest())
                        {
                            SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
                        }
                        EmailMessage objEmailMessage = new EmailMessage();
                        objEmailMessage.status = '3'; // email was sent
                        objEmailMessage.RelatedToId = requestWrapperList[0].opportunityId;
                        objEmailMessage.fromName = 'Dynamix'; // from name
                        objEmailMessage.Subject = 'WhatsApp sent to customer for Collateral with walkthrough';
                        objEmailMessage.HtmlBody = templateBody;
                        insertEmailMessageList.add(objEmailMessage);
                        
                    }
                    catch(Exception ex)
                    {
                        system.debug('Error'+ex.getMessage()+' Line Number----' +ex.getLineNumber());
                    }           
                }
            }
        }
        else{
            communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,communicat_o__External_Template_Id__c From communicat_o__Registered_Template__mdt Where QualifiedApiName=:'Whatsapp_Of_Share_Collateral_Without_Wal' Limit 1];
            System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
            
            if(regWhatEmailTemp!=null){
                String recipientAddress = requestWrapperList[0].primaryMobileNumber;
                String recipientId = requestWrapperList[0].personAccountId;
                String emailTemplateId = String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
                String relatedToId = requestWrapperList[0].opportunityId;
                List<string> arguments = New List<string>{requestWrapperList[0].projectName,requestWrapperList[0].Location,requestWrapperList[0].brochure,requestWrapperList[0].projectPhone};
                //  List<string> arguments = New List<string>{requestWrapperList[0].projectName,requestWrapperList[0].projectArea,requestWrapperList[0].Location,requestWrapperList[0].brochure,requestWrapperList[0].flatVideo,requestWrapperList[0].projectPhone};
                System.debug('emailTemplateId:'+emailTemplateId);
                if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                    if(!Test.isRunningTest())
                    {
                        SendWhatsAppMessageUtility.SendWhatsappMessage(recipientAddress, recipientId,emailTemplateId, relatedToId ,regWhatEmailTemp.communicat_o__External_Template_Id__c ,arguments);
                    }
                }
                EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'Whatsapp Of Share Collateral Without Walk Through' LIMIT 1];
                if(smsEmailTemp!=null && requestWrapperList[0].primaryMobileNumber != null){
                    try{
                        String templateBody=smsEmailTemp.HtmlValue;
                        templateBody=templateBody.stripHtmlTags();
                        String mobileNumber=requestWrapperList[0].primaryMobileNumber;
                        templateBody = templateBody.replace('{ProjectName}',requestWrapperList[0].projectName);
                        templateBody = templateBody.replace('{GPS_location__c}', requestWrapperList[0].Location);
                        templateBody = templateBody.replace('{brochureLink}', requestWrapperList[0].brochure);
                        templateBody = templateBody.replace('{contactNumber}', requestWrapperList[0].projectPhone);
                        if(!Test.isRunningTest())
                        {
                        	SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
                        }
                        EmailMessage objEmailMessage = new EmailMessage();
                        objEmailMessage.status = '3'; // email was sent
                        objEmailMessage.RelatedToId = requestWrapperList[0].opportunityId;
                        objEmailMessage.fromName = 'Dynamix'; // from name
                        objEmailMessage.Subject = 'WhatsApp sent to customer for Collateral without walkthrough';
                        objEmailMessage.HtmlBody = templateBody;
                        insertEmailMessageList.add(objEmailMessage);
                        
                    }
                    catch(Exception ex)
                    {
                        system.debug('Error'+ex.getMessage()+' Line Number----' +ex.getLineNumber());
                    }           
                }
            }
        }
        if(!insertEmailMessageList.isEmpty())
        {
            emailMessageInsert(insertEmailMessageList);
        }
       // insert insertEmailMessageList;
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
        public String opportunityId;
        
        @InvocableVariable
        public String personAccountId;
        
        @InvocableVariable
        public Boolean walkThrough;
        
        @InvocableVariable
        public String projectPhone;
        
    } 
    public Static Void emailMessageInsert(List<EmailMessage> emailList)
    {
        if(!emailList.isEmpty())
        {
            insert emailList;
        }
    }
    
}