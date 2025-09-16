global class EnquiryResponse {
    global Enquiry__c enquiryData;
    global Task taskData;
    global String Status;
    global Map<String,String> errorMessage {get;set;}
}