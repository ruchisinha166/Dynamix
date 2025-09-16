public class LedgerDocumentController {
    public Booking__c booking{get;set;}
    public List<Payment_Line__c> PaymentLine{get;set;}
    public List<Payment_Milestones__c> PaymentMilestone{get;set;}
    public String InvoiceId{get;set;}
    String dateFormatString = 'yyyy-MM-dd';
    public LedgerDocumentController(ApexPages.StandardController controller){
        
        String sBookingId = ApexPages.CurrentPage().getparameters().get('id');
        //String sBookingId = 'a0CC4000004obq6MAA';
        system.debug('sBookingId======='+sBookingId);
        
        booking = [select Id,Agreement_Value_Pending__c,Total_Amount_Received__c,Tower_Name__c,Registration_Date__c,
                   Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Tower_Name__r.Car_Parking__c,Project_Name__c,
                   Project_Name__r.Name,Primary_Applicant__c,Primary_Applicant__r.Name,Primary_Applicant__r.PersonMailingStreet,
                   Related_Suggested_Property__c,Related_Suggested_Property__r.Unit__r.Name,Agreement_Value__c,Booking_Date__c,
                   Related_Suggested_Property__r.Unit__r.Unit__c,Related_Suggested_Property__r.Unit__r.Approved_Area__c,Total_Amount_Due__c,Primary_Applicant__r.PersonMailingCity,
                   Primary_Applicant__r.PersonMailingState, Primary_Applicant__r.PersonMailingCountry,Primary_Applicant__r.PersonMobilePhone,
                   Primary_Applicant__r.PersonEmail,Project_Name__r.Project_Area_in_sqft__c, Other_Charges__c,Project_Name__r.Builder_Organization__r.Builder_Organisation_Initials__c,
                   Project_Name__r.Project_Initials__c,Project_Name__r.Last_Invoice_Number__c, GST__c, Total_interest_amount__c,
                   Total_Amount__c,Discount__c,Project_Phone__c,Payment_Milestones_Total_Amount__c,Total_Amount_Received_in_Percentage__c
                   from Booking__c where Id =: sBookingId];
        
        system.debug('booking======='+booking);	
        InvoiceId = booking.Project_Name__r.Builder_Organization__r.Builder_Organisation_Initials__c+'/'+booking.Project_Name__r.Project_Initials__c+ '/ ' + Date.Today().Year() +'/'+ String.valueOf(booking.Project_Name__r.Last_Invoice_Number__c).leftPad(5, '0');
        
        if(booking != null){
            PaymentLine = [Select Id,Amount__c,Milestone__r.Remaining_Amount__c,Milestone__r.Due_Date__c,Milestone__r.GST_Amount1__c,
                           Milestone__r.Remaining_GST__c,Adjusted_against__c,Credit_Amount__c,Milestone__r.Name,Milestone__r.Milestone_Activation_Date__c,Milestone__r.Milestone_Amount1__c,
                           Payment__c,Payment__r.Name,Payment__r.Payment_Status__c,Payment__r.Payment_Type__c,Payment__r.Booking__c,Payment__r.Payment_Date__c,
                           Payment_Category__c,Balance__c,Payment_Status__c,Milestone__r.Payment_Received__c,Payment__r.Amount__c,Payment__r.Cheque_Transaction_Number__c,Payment__r.BankName__r.Name
                           From Payment_Line__c where Payment__r.Booking__c =:booking.Id And Payment__r.Payment_Status__c = 'Approved' And (Amount__c > 0 OR Credit_Amount__c <> null)]; 
            set<Id> PmIds = new set<Id>();
            PaymentMilestone = [Select Id, Name, Booking__c, Milestone_Amount1__c 
                                From Payment_Milestones__c Where Booking__c =: booking.Id];
            for(Payment_Milestones__c objPm : PaymentMilestone){
                PmIds.add(objPm.Id);
            }  
            AggregateResult[] AgResultList = [Select Id, SUM(Milestone_Amount1__c) amountSum From Payment_Milestones__c where Id in: PmIds GROUP BY Id];
            for(AggregateResult ar : AgResultList){
                system.debug('ar');
            }   
        }  
    }
}