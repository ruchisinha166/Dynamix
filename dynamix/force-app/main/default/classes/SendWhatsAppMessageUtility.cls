Public class SendWhatsAppMessageUtility {
    @future(callout=true)
    Public static Void SendMessage(String recipientAddress,String recipientId,String emailTemplateId,String relatedToId){
        String whatsAppSenderAdd = Label.WhatsApp_Sender_Address;
        System.debug('whatsAppSenderAdd:'+whatsAppSenderAdd);
        communicat_o.OutboundWrapper.OutboundActivity acti = new communicat_o.OutboundWrapper.OutboundActivity();
        acti.recipientAddress = recipientAddress; //'919803645055'
        acti.recipientId =  recipientId; //'0015g00000UBlbyAAD'
        if(relatedToId!=null){
            acti.relatedToId=relatedToId;
        }
        List<communicat_o.OutboundWrapper.OutboundActivity> liact = new List<communicat_o.OutboundWrapper.OutboundActivity>();
        liact.add(acti);
        communicat_o.OutboundWrapper out= new communicat_o.OutboundWrapper();
        out.activities=liact;
        out.sendDateTime=datetime.now();
        out.templateId= emailTemplateId ;//'m05Bh000000AcVR'(Test without Merge field) //'m055g000000Aegw' (OldId)
        out.senderAddress= whatsAppSenderAdd; //'Dynamix_919152915208'
        system.debug('emailTemplateId'+emailTemplateId);
        system.debug('whatsAppSenderAdd'+whatsAppSenderAdd);
        system.debug('out'+out);
        try{
            communicat_o.OSMS.sendSMS(out);
            system.debug('WhatsApp Msg Sent');
        }
        Catch(Exception e)
        {
            system.debug('WhatsApp Msg Sending Error==>'  + e.getMessage());
        }
    }
    
    //
    @future(callout=true)
    Public static Void SendWhatsappMessage(String recipientAddress, String recipientId, String emailTemplateId, String relatedToId, String externalTemplateId, List<string> arrays){
        String whatsAppSenderAdd = Label.WhatsApp_Sender_Address;
        System.debug('whatsAppSenderAdd:'+whatsAppSenderAdd);
        System.debug('recipientAddress:'+recipientAddress);
        communicat_o.OutboundWrapper.OutboundActivity acti = new communicat_o.OutboundWrapper.OutboundActivity();
        acti.recipientAddress = recipientAddress;
        acti.recipientId = recipientId;
        if(relatedToId!=null){
            acti.relatedToId=relatedToId;
        }
        acti.externalTemplateId = externalTemplateId;
        acti.templateArgs = arrays;
        List<communicat_o.OutboundWrapper.OutboundActivity> liact = new List<communicat_o.OutboundWrapper.OutboundActivity>();
        liact.add(acti);
        communicat_o.OutboundWrapper out= new communicat_o.OutboundWrapper();
        out.activities=liact;
        out.sendDateTime=datetime.now();
        //out.templateId= emailTemplateId;
        out.senderAddress= whatsAppSenderAdd;
        communicat_o.OSMS.sendSMS(out);
        system.debug('send sms');
        try{
            communicat_o.OSMS.sendSMS(out);
            system.debug('WhatsApp Msg Sent');
        }
        Catch(Exception e)
        {
            system.debug('WhatsApp Msg Sending Error==>'  + e.getMessage());
        }
    }
}