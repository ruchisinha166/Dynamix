public class FlatCancelationNoteExtenstion{
    
    public Booking__c booking{get;set;}
    public Project__c projectObj{get;set;}
    public Property__c properties{get;set;}
    public Suggested_Property__c sPropertyobj{get;set;}
    public List<Bank_Loan_Details__c> bankloaddetails{get;set;}
    public List<Payment__c> paymentList{get;set;}
    public decimal totalReceiveAmount{get;set;}
    public Decimal totalReceived {get;set;}
    public Decimal totalReceivedGST {get;set;}
    public Decimal totalBilled {get;set;}
    public Decimal totalBilledGST {get;set;}
    public Decimal totalOutstanding {get;set;}
    public Decimal totalOutstandingGST {get;set;}
    public List<Payment_Milestones__c> paymentMilestone {get;set;}
    public Decimal AmountcollectfromCustomer {get;set;}
    public Decimal AmountcollectfromCustomerGST {get;set;}
    public Decimal sdrAmount{get;set;}
    public String Scheme{get;set;}
    public Decimal ocrReceived_FlatCost {get;set;}
    public Decimal ocrReceived_GST {get;set;}
    public Decimal ocrReceived_StampDuty{get;set;}
    public Decimal bankDisbursementReceived_FlatCost{get;set;}
    public Decimal bankDisbursementReceived_GST{get;set;}
    public Decimal bankDisbursementReceived_StampDuty{get;set;}
    public String projectHead{get;set;}
    public String postSalseHead{get;set;}   
    public String salseHead{get;set;}   
    public boolean address {get;set;}   
    public Account accountObject{get;set;}
    public List<Co_Applicant__c> Coapplicant{get;set;}
    public FlatCancelationNoteExtenstion(ApexPages.StandardController controller){
        totalReceived = 0;
        totalBilled = 0;
        totalOutstanding = 0;
        totalReceivedGST = 0;
        totalbilledGST = 0;
        totalOutstandingGST = 0;
        amountcollectfromCustomer = 0;
        amountcollectfromCustomerGST = 0;
        sdrAmount =0;
        ocrReceived_FlatCost =0;
        ocrReceived_GST=0;
        ocrReceived_StampDuty=0;
        bankDisbursementReceived_FlatCost=0;
        bankDisbursementReceived_GST=0;
        bankDisbursementReceived_StampDuty=0;
        projectHead='';
        postSalseHead='';
        salseHead='';
        Scheme='';
        sPropertyobj= new Suggested_Property__c();
        String sBookingId = ApexPages.CurrentPage().getparameters().get('id');
       // String sBookingId = 'a069D00000867jZQAQ';
        
        booking = [select Id,Booking_Date__c,Sales_Manager__r.Name,Project_Name__r.City__c,Project_Name__r.Postal_Code__c,Project_Name__r.Location__c,Project_Name__r.name,Refund_Reason__c,Registration_Status__c,Stamp_Duty_Status__c,Refund_Amount__c,Registration_Number__c,cancellation_fees__c,Stamp_Duty__c,Registration_Date__c,Sales_Manager__c,Agreement_Value__c,GST__c,Tower_Name__c,Tower_Name__r.Tower_Initials__c,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Tower_Name__r.Builder_Organisation__r.Bank_Name__c,Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.Name,Tower_Name__r.Builder_Organisation__r.GST_Bank_Name__c,Tower_Name__r.Builder_Organisation__r.Branch_Address__c,Tower_Name__r.Builder_Organisation__r.GST_Branch_Address__c,Tower_Name__r.Builder_Organisation__r.Bank_Account_Number__c,Tower_Name__r.Builder_Organisation__r.GST_Bank_Account_Number__c,Tower_Name__r.Builder_Organisation__r.IFSC_code__c,Tower_Name__r.Builder_Organisation__r.GST_IFSC_code__c,Related_Suggested_Property__c,Owner.Name,Owner.Email from Booking__c where Id =: sBookingId];
        if(booking.Project_Name__c!=null)
        {
            projectObj =[select id,Project_Head__r.name,Post_Sales_Head__r.name,Sales_Head__r.name from project__c where id =:booking.Project_Name__c];
            if(projectObj!=null)
            {
                projectHead =projectObj.Project_Head__r.name;
                postSalseHead = projectObj.Post_Sales_Head__r.name; 
                salseHead=projectObj.Sales_Head__r.name;
            }
        }  
          if(booking != null){
            accountObject = [select Id,PersonMobilePhone,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode,PersonMailingCountry,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Phone from Account where Id =: booking.Primary_Applicant__c ];
            Coapplicant = [select id,Booking__c,Account__r.Name from Co_Applicant__c where Booking__c  =: booking.id Order by Role__c];
        } 
         if(accountObject.BillingCountry != null)
        {
            address = true;
        }
        else
        {
            address = false;
        }
        if(booking != null){
            sPropertyobj= [select Id,Unit__c,Unit__r.name,Opportunity__r.Owner.Name,Unit__r.Floor__c,Payment_Plan__c,Payment_Plan__r.Name from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
            if(sPropertyobj!=null)
            {
                Scheme=sPropertyobj.Payment_Plan__r.Name; 
            }
        }
        if(booking != null){
            paymentMilestone = [select Id,Due_Date__c,Milestone_Amount1__c,GST_Amount1__c,First_Payment_Email_Reminder_Date__c,Third_Payment_Email_Reminder_Date__c,Second_Payment_Email_Reminder_Date__c from Payment_Milestones__c where Booking__c =: booking.id and Milestone_Status__c = 'Active'];
            if(paymentMilestone.size()>0)
            {
                for(Payment_Milestones__c pm : paymentMilestone)
                {
                    totalbilled = totalbilled + pm.Milestone_Amount1__c;
                    totalbilledGST = totalbilledGST + pm.GST_Amount1__c;
                }
            }   
        }   
        paymentList = [select Id,Name,Amount__c,BankName__c,Paid_By__c,Booking__c,Branch_Name__c,Cheque_Transaction_Number__c,Payment_Type__c,Payment_Status__c,Payment_Description__c,Payment_Date__c,Payment_Category__c,Date__c,Cheque_Status__c,Receipt_No__c from Payment__c where Booking__c =: booking.Id];
        system.debug('paymentList==='+paymentList); 
        if(paymentList.size()>0)
        {
            for(Payment__c pay : paymentList)
            {
                
                if(pay.Payment_Category__c == 'Unit Cost'&& pay.Amount__c!=null && pay.Payment_Status__c!='Rejected')
                {
                    totalReceived = totalReceived + pay.Amount__c;
                    if(pay.Paid_By__c=='Self')
                    {
                        ocrReceived_FlatCost =ocrReceived_FlatCost +pay.Amount__c;
                        system.debug('OCRReceived_FlatCost ==='+OCRReceived_FlatCost );
                    }
                    if(pay.Paid_By__c=='Loan Disbursement')
                    {
                        bankDisbursementReceived_FlatCost = bankDisbursementReceived_FlatCost+pay.Amount__c;
                        system.debug('BankDisbursementReceived_FlatCost ==='+bankDisbursementReceived_FlatCost );
                    }
                }
                if(pay.Payment_Category__c =='GST' && pay.Amount__c!=null && pay.Payment_Status__c!='Rejected' )
                {
                    totalReceivedGST = totalReceivedGST + pay.Amount__c;
                    if(pay.Paid_By__c=='Self')
                    {
                        ocrReceived_GST=OCRReceived_GST+pay.Amount__c;
                        system.debug('OCRReceived_GST==='+OCRReceived_GST);
                    }
                    if(pay.Paid_By__c=='Loan Disbursement')
                    {
                        bankDisbursementReceived_GST= bankDisbursementReceived_GST+pay.Amount__c;
                        system.debug('BankDisbursementReceived_GST==='+BankDisbursementReceived_GST);
                    }
                }
                if(pay.Payment_Category__c == 'Stamp Duty'  && pay.Amount__c!=null && pay.Payment_Status__c!='Rejected' )
                {
                    sdrAmount = sdrAmount + pay.Amount__c;
                    if(pay.Paid_By__c=='Self')
                    {
                        ocrReceived_StampDuty=ocrReceived_StampDuty+pay.Amount__c;
                        system.debug('OCRReceived_StampDuty==='+ocrReceived_StampDuty);
                    }
                    if(pay.Paid_By__c=='Loan Disbursement')
                    {
                        bankDisbursementReceived_StampDuty= bankDisbursementReceived_StampDuty+pay.Amount__c;
                        system.debug('BankDisbursementReceived_StampDuty==='+BankDisbursementReceived_StampDuty);
                    }
                }
            }  
        }
        totalOutstanding = totalbilled - totalReceived;
        totalOutstandingGST = totalbilledGST - totalReceivedGST;
        amountcollectfromCustomer = totalbilled - totalOutstanding;
        amountcollectfromCustomerGST = totalbilledGST - totalOutstandingGST;
    }
}