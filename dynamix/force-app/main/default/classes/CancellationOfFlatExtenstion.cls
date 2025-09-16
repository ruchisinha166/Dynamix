public class CancellationOfFlatExtenstion {
    
    public Account accountObject{get;set;}
    public List<Co_Applicant__c> coApplicant {get;set;}
    public List<Payment__c> paymentList{get;set;}
    public Payment__c payment{get;set;}
    public Booking__c booking{get;set;}
    public Property__c properties{get;set;}
    public Project__c project{get;set;}
    public List<Suggested_Property__c> property{get;set;}
    public List<Payment_Milestones__c> paymentMilestone {get;set;}
    public List<AggregateResult> PMDueDate {get;set;}
  
    public boolean dateValue {get;set;}
    public Decimal TotalReceived {get;set;}
    public Decimal TotalBilled {get;set;}
    public Decimal TotalOutstanding {get;set;}
    public Decimal TotalReceivedGST {get;set;}
    public Decimal TotalbilledGST {get;set;}
    public Decimal TotalOutstandingGST {get;set;}
    public Date DueDate{get;set;}
         public CancellationOfFlatExtenstion(ApexPages.StandardController controller){
            TotalReceived = 0;
            TotalBilled = 0;
            TotalOutstanding = 0;
            TotalReceivedGST = 0;
            TotalbilledGST = 0;
            TotalOutstandingGST = 0;
              
            String sBookingId = ApexPages.CurrentPage().getparameters().get('id');
            booking = [select Id,Agreement_Value__c,GST__c,Cancellation_Reasons__c,Tower_Name__c,Tower_Name__r.Tower_Initials__c,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Tower_Name__r.Builder_Organisation__r.Bank_Name__c,Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.Name,Tower_Name__r.Builder_Organisation__r.GST_Bank_Name__c,Tower_Name__r.Builder_Organisation__r.Branch_Address__c,Tower_Name__r.Builder_Organisation__r.GST_Branch_Address__c,Tower_Name__r.Builder_Organisation__r.Bank_Account_Number__c,Tower_Name__r.Builder_Organisation__r.GST_Bank_Account_Number__c,Tower_Name__r.Builder_Organisation__r.IFSC_code__c,Tower_Name__r.Builder_Organisation__r.GST_IFSC_code__c,Related_Suggested_Property__c,Owner.Name,Owner.Email from Booking__c where Id =: sBookingId];
            
                if(booking != null){
                    accountObject = [select Id,Name,Age__c,PersonMobilePhone,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode from Account where Id =: booking.Primary_Applicant__c ];
                    coApplicant = [select Id,Name,Applicant_Name__c,Account__r.Age__c  from Co_Applicant__c where Booking__c =: booking.Id ];
                }
                if(booking != null){
                    property = [select Id,Unit__c from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
                    
                }
                if(property.size() > 0){
                    for(Suggested_Property__c prop :property){
                    properties = [select Id,Name,Floor__c from Property__c where Id =: prop.Unit__c];
                    
                }
                }
                if(booking.Project_Name__c != null){
                    project = [select Id,Name,Location__c,Sublocation__c,City__c,State__c,Project_Email__c from Project__c where Id =: booking.Project_Name__c];
                }
                // Fetch Payment milestone Due Date
                if(booking != null){
                    paymentMilestone = [select Id,Due_Date__c,Milestone_Amount1__c,GST_Amount1__c from Payment_Milestones__c where Booking__c =: booking.id and Milestone_Status__c = 'Active'];
                    PMDueDate = [SELECT MAX(Due_Date__c) FROM Payment_Milestones__c where Booking__c =: booking.id and Milestone_Status__c = 'Active' GROUP BY Booking__c];
                  
                    for(AggregateResult du : PMDueDate)
                    {
                        Duedate = (Date)du.get('expr0');
                    }
                    
                    for(Payment_Milestones__c pm : paymentMilestone)
                    {
                        Totalbilled = Totalbilled + pm.Milestone_Amount1__c;
                        TotalbilledGST = TotalbilledGST + pm.GST_Amount1__c;
                    }
                }
                
               paymentList = [select Id,Name,Amount__c,BankName__c,Booking__c,Branch_Name__c,Cheque_Transaction_Number__c,Payment_Type__c,Payment_Status__c,Payment_Description__c,
                                 Payment_Date__c,Payment_Category__c,Date__c,Receipt_No__c from Payment__c where Booking__c =: booking.Id];
         
               
                 for(Payment__c pay : paymentList)
                 {
                     if(pay.Payment_Category__c == 'Unit Cost')
                     {
                         TotalReceived = TotalReceived + pay.Amount__c;
                     }
                     if(pay.Payment_Category__c == 'GST')
                     {
                         TotalReceivedGST = TotalReceivedGST + pay.Amount__c;
                     }
                 }
             
                 TotalOutstanding = Totalbilled - TotalReceived;
                 TotalOutstandingGST = TotalbilledGST - TotalReceivedGST;
           }

}