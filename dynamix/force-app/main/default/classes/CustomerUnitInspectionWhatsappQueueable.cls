public class CustomerUnitInspectionWhatsappQueueable implements Queueable  {
    private List<CustomerUnitInspectionWhatsappAndSMS.requestWrapper> requestWrapperList;
    public CustomerUnitInspectionWhatsappQueueable(List<CustomerUnitInspectionWhatsappAndSMS.requestWrapper> requestWrapperList) {
        system.debug('Here......' + requestWrapperList);
        this.requestWrapperList = requestWrapperList;  
    }
    
    public void execute(QueueableContext context) {
        for (CustomerUnitInspectionWhatsappAndSMS.requestWrapper request : requestWrapperList) {
            String templateName;
            Id recordId = id.valueof(requestWrapperList[0].bookingId);
            String objectName = recordId.getSObjectType().getDescribe().getName();
            //Send Whatsapp
            communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,communicat_o__External_Template_Id__c From communicat_o__Registered_Template__mdt Where QualifiedApiName=: 'unit_inspection' Limit 1];
            System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
            if(regWhatEmailTemp!=null){
                try{
                    String siteVisitTime = requestWrapperList[0].siteVisitTime.format('HH:mm a'); 
                    List<string> arguments = New List<string>{requestWrapperList[0].customerName,string.valueof(requestWrapperList[0].siteVisitDate ),siteVisitTime,requestWrapperList[0].projectName,requestWrapperList[0].meetingLocation,requestWrapperList[0].contactNumber};
                    String recipientAddress = requestWrapperList[0].primaryMobileNumber;
                    system.debug('requestWrapperList[0].primaryMobileNumber'+requestWrapperList[0].primaryMobileNumber);
                    String recipientId = requestWrapperList[0].personAccountId;
                    String emailTemplateId = String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
                    String relatedToId = requestWrapperList[0].bookingId;
                    System.debug('emailTemplateId:'+emailTemplateId);
                    if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                        if(!Test.isRunningTest()){
                            SendWhatsAppMessageUtility.SendWhatsappMessage(recipientAddress, recipientId,emailTemplateId, relatedToId ,regWhatEmailTemp.communicat_o__External_Template_Id__c ,arguments);
                        }
                    }
                }
                
                catch(Exception ex)
                {
                    system.debug('Error'+ex.getMessage());
                }
            }
            
        }
    }
}