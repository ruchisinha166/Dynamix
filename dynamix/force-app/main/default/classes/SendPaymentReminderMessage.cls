public class SendPaymentReminderMessage {
    Public static void sendTextMessage(String templateBody,String mobileNumber,String senderId){
        //get value From Custom Meta data
        List<BookingForm_OTP_Data__mdt> otpContent = BookingForm_OTP_Data__mdt.getAll().values();
        System.debug('otpContent:'+otpContent);
        
        String bearerToken= otpContent[0].Bearer_Token__c;
        System.debug('BearerToken:'+BearerToken);
        String endPoint= otpContent[0].End_Point__c;
        System.debug('endPoint:'+endPoint);
        String contentTypeHeader= otpContent[0].Content_Type_Header__c;
        System.debug('contentTypeHeader:'+contentTypeHeader);  
        String authorizationHeader= otpContent[0].Authorization_Header__c;
        System.debug('authorizationHeader:'+authorizationHeader);  
        String msgBody= templateBody;
        System.debug('msgBody:'+msgBody);  
        String mobileNo= mobileNumber;
        HttpRequest request = new HttpRequest();
        
        String body;
        if(Test.isRunningTest()){
            body ='test body';
        }
        else{
            body = 'Accept='+EncodingUtil.urlEncode('application/json','UTF-8')+'&Authorization='+EncodingUtil.urlEncode(bearerToken,'UTF-8')+'&sender='+EncodingUtil.urlEncode(senderId,'UTF-8')+'&to='+EncodingUtil.urlEncode(mobileNo,'UTF-8')+'&service='+EncodingUtil.urlEncode('T','UTF-8')+'&message='+EncodingUtil.urlEncode(msgBody,'UTF-8');                
        }
        System.debug('body:'+body);  
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Content-Type', contentTypeHeader); 
        request.setBody(body);
        Http http = new Http();
        HTTPResponse response = http.send(request); 
        if(response.getStatusCode() == 200){
            System.debug('SMS Sent');
        } 
        else{
            String errorMsg = string.valueOf(response.getStatus());
            System.debug('SMS Sending Error ==>'+errorMsg);
        }
    }
    Public static Void SendWhatsAppMessage(String recipientAddress,String recipientId,String emailTemplateId,String relatedToId){
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