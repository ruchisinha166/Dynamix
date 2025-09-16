public class SentBrochuresToCustomer {
    @InvocableMethod(callout=true label='Send Brochure Throw Whatapp')
    
    public static void SendBrochureThroughSMSMethod(List<requestWrapper> requestWrapperList) {
        communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,communicat_o__External_Template_Id__c From communicat_o__Registered_Template__mdt Where QualifiedApiName=:'Whatsapp_Brochures' Limit 1];
        System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
        if(regWhatEmailTemp!=null){
            String recipientAddress = requestWrapperList[0].primaryMobileNumber;
            String recipientId = requestWrapperList[0].personAccountId;
            String emailTemplateId = String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
            String relatedToId = requestWrapperList[0].enquiryId;
            List<string> arguments = New List<string>{requestWrapperList[0].projectName,requestWrapperList[0].projectArea,requestWrapperList[0].Location,requestWrapperList[0].brochure,requestWrapperList[0].flatVideo,requestWrapperList[0].projectPhone};
            System.debug('emailTemplateId:'+emailTemplateId);
            if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                if(!Test.isRunningTest()){
                    SendWhatsAppMessageUtility.SendWhatsappMessage(recipientAddress, recipientId,emailTemplateId, relatedToId ,regWhatEmailTemp.communicat_o__External_Template_Id__c ,arguments);
                }
                
            }
        }
        
    }public class requestWrapper{
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