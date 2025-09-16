@RestResource(urlMapping='/enquiry/*')
global class EnquiryService {
 	@HttpPost
    global static EnquiryResponse doPost() {
        
        String enqJSON = RestContext.request.requestBody.toString();
        EnquiryRequest request = (EnquiryRequest)(JSON.deserialize(enqJSON, EnquiryRequest.Class));
        
        return CreateEnquiryAndAccount.createEnquiry(request);
   }
}