public class SendSMSUtility {
    @future(callout=true)
    Public static void sendSMS(String templateBody,String mobileNumber,String senderId){
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
    
    @future(callout=true)
    Public static void sendSMSMethod(String templateBody,String mobileNumber,String senderId, string templateId){
        //get value From Custom Meta data
        List<BookingForm_OTP_Data__mdt> otpContent = BookingForm_OTP_Data__mdt.getAll().values();
        System.debug('otpContent:'+otpContent);
        senderId = 'DYNAMX';
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
       // mobileNo= '9728185517';
        Map<String, Object> payload = new Map<String, Object>();
        HttpRequest request = new HttpRequest();
        List<Vapp_SMS__mdt> vappSMSData = Vapp_SMS__mdt.getAll().values();
        Map<String, Map<String,String>> jsonMap = New Map<String,Map<String,String>>();
        Map<String,string> credentialsMap = New Map<String,string>();
        credentialsMap.put('user',vappSMSData[0].User__c);
        credentialsMap.put('password',vappSMSData[0].Password__c);
        payload.put('credentials',credentialsMap);
        
        Map<String,string> optionsMap = New Map<String,string>();
        optionsMap.put('dltPrincipalEntityId',vappSMSData[0].dltPrincipalEntityId__c);
        String uuid = new Uuid().getValue();
        payload.put('options',optionsMap);
        payload.put('from',senderId);
        Map<String,string> shortMessagesMap = New Map<String,string>();
        List<Map<String,string>> shortMessagesList = New List<Map<String,string>>();
        shortMessagesMap.put('message',msgBody);
        shortMessagesMap.put('corelationId',uuid);
        shortMessagesMap.put('dltContentId',templateId);
        shortMessagesMap.put('recipient',mobileNo);
        shortMessagesList.add(shortMessagesMap);
        payload.put('shortMessages',shortMessagesList);
        payload.put('unicode', 'false');
        
        system.debug('payload'+payload);
        request.setEndpoint(vappSMSData[0].End_Point__c);
        request.setMethod('POST');
        // request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Content-Type', 'application/json'); 
        String payloadJson = JSON.serialize(payload);
        request.setBody(payloadJson);
        system.debug('payloadJson'+payloadJson);
        Http http = new Http();
        HTTPResponse response = http.send(request); 
        system.debug('response'+response.getbody());
        if(response.getStatusCode() == 200){
            System.debug('SMS Sent');
        } 
        else{
            String errorMsg = string.valueOf(response.getStatus());
            System.debug('SMS Sending Error ==>'+errorMsg);
        }
    }
    
  
}