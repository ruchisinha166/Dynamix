Public class BookingCancellationChecklist {
    
    Public Booking__c bookingRecord{get;set;}
    Public String recordId{get;set;}
    Public List<Co_Applicant__c> coApplicantList {get;set;}
    Public Co_Applicant__c coAppllicantRecord {get;set;}
    
    Public BookingCancellationChecklist(ApexPages.StandardController controller){     
        recordId = ApexPages.CurrentPage().getparameters().get('id');   
       // recordId='a0CBh000000Msg5MAC';     
        bookingRecord = [select Id,Tower_Name__c,Related_Opportunity__c,Tower_Name__r.Name,Project_Name__r.Name,Primary_Applicant__c,Primary_Applicant__r.FirstName,Primary_Applicant__r.LastName,
                         Agreement_Value__c,Unit_Number__c,Stage__c,Source_of_Booking__c,Registration_Status__c,Cancellation_Request_Confirmation_Date__c,
                         Cancellation_Reasons__c,Cancellation_Sub_Reason__c,Total_Amount_Received__c,TDS_Received__c,Non_Recoverable_GST_of_Invoice_Raised__c,
                         Forfeiture__c,Forfeiture_Criteria__c,Forfeiture_Amount__c,Brokerage_Amount_Paid2__c,Brokerage_Paid__c,Interest_Accrued_on_Amount_Due__c,
                         MVAT__c,Service_Tax__c,TDS__c,Payment_Received_GST__c,Miscellaneous_Expense__c,Total_Forfeiture_Amount__c,Total_Refund_Amount__c
                         FROM Booking__c WHERE Id =: recordId];
        //get Co-Applicant
        coApplicantList=[Select Id,Name,Account__c,Role__c,Booking__c,Account__r.Name From Co_Applicant__c Where Booking__c=:recordId AND Role__c=:'Co-Applicant' ];
        if(coApplicantList.size()>0){
            coAppllicantRecord=coApplicantList[0];
        }
        
    }
}