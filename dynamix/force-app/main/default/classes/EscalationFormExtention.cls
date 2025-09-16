public class EscalationFormExtention
{
    public Booking__c booking{get;set;}
    public Property__c properties{get;set;}
    public Suggested_Property__c sPropertylist{get;set;}
    public Bank_Loan_Details__c bankloaddetail {get;set;}
    public List<Payment__c> paymentList{get;set;}
    public decimal totalReceiveAmount{get;set;}
    public Decimal totalOutstanding {get;set;}
    public Decimal totalOutstandingGST {get;set;}
    public List<Payment_Milestones__c> paymentMilestone {get;set;}
   
    public EscalationFormExtention(ApexPages.StandardController controller){
      
        totalOutstanding = 0;
        totalOutstandingGST = 0;
        bankloaddetail =new  Bank_Loan_Details__c(); 
        sPropertylist = new Suggested_Property__c();
        properties = new Property__c(); 
        
        String sBookingId = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('sBookingId =='+sBookingId );
        booking = [select Id,Payment_Milestones_Total_GST__c,Payment_Milestones_Total_Amount__c,Booking_Date__c,Payment_Received_Agreement__c,Primary_Loan_Details__c,Payment_Received_GST__c,Sales_Manager__r.Name,Registration_Date__c,Sales_Manager__c,Agreement_Value__c,GST__c,Tower_Name__c,Tower_Name__r.Tower_Initials__c,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Tower_Name__r.Builder_Organisation__r.Bank_Name__c,Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.Name,Tower_Name__r.Builder_Organisation__r.GST_Bank_Name__c,Tower_Name__r.Builder_Organisation__r.Branch_Address__c,Tower_Name__r.Builder_Organisation__r.GST_Branch_Address__c,Tower_Name__r.Builder_Organisation__r.Bank_Account_Number__c,Tower_Name__r.Builder_Organisation__r.GST_Bank_Account_Number__c,Tower_Name__r.Builder_Organisation__r.IFSC_code__c,Tower_Name__r.Builder_Organisation__r.GST_IFSC_code__c,Related_Suggested_Property__c,Owner.Name,Owner.Email from Booking__c where Id =: sBookingId];
        if(booking != null && booking.Primary_Loan_Details__c!=null){
            bankloaddetail = [select id,Home_LoanInstitution__r.name,Sanction_Amount__c from Bank_Loan_Details__c where Booking__c =: booking.id and id=:booking.Primary_Loan_Details__c limit 1];
        }
        if(booking != null && booking.Related_Suggested_Property__c!=null){
            sPropertylist = [select Id,Unit__c,Payment_Plan__c,Unit__r.name,Payment_Plan__r.Name from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
        }
        if(sPropertylist!=null && sPropertylist.Unit__c!=null){
            properties = [select Id,Name,Floor__c from Property__c where Id =: sPropertylist.Unit__c];
           
        }
        totalOutstanding =Booking.Payment_Milestones_Total_Amount__c - booking.Payment_Received_Agreement__c;
        totalOutstandingGST =Booking.Payment_Milestones_Total_GST__c - booking.Payment_Received_GST__c;
    }
}