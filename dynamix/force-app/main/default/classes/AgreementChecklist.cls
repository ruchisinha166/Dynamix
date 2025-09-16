public class AgreementChecklist
{
        public Account accountObject{get;set;}
        public Booking__c booking{get;set;}
        public Property__c properties{get;set;}
        public List<Suggested_Property__c> property{get;set;}
        public List<Bank_Loan_Details__c> bankloaddetails{get;set;}
        public List<Payment__c> paymentList{get;set;}
        public String TDSChalanNumber{get;set;}
        public decimal ParallelFundingApproval {get;set;} // Agreement - Loan Sanction Amount - OCR amount
        public decimal totalReceiveAmount{get;set;}
        public Decimal TotalReceived {get;set;}
        public Decimal TotalReceivedGST {get;set;}
        public Decimal TotalBilled {get;set;}
        public Decimal TotalbilledGST {get;set;}
        public Decimal TotalOutstanding {get;set;}
        public Decimal TotalOutstandingGST {get;set;}
        public List<Payment_Milestones__c> paymentMilestone {get;set;}
        public Decimal AmountcollectfromCustomer {get;set;}
        public Decimal AmountcollectfromCustomerGST {get;set;}
        public Decimal SDRAmount{get;set;}
        public Date SDRClearedDate {get;set;}
        public String StampDutyTrxNumber {get;set;}
        public User SalesUser{get;set;}
        public User PostSalesUser {get;set;}
        public Decimal OCRAmount{get;set;}
        public Decimal PDCAmount{get;set;}
        public Decimal PDCGSTAmount{get;set;}
        public AgreementChecklist(ApexPages.StandardController controller){
            TotalReceived = 0;
            TotalBilled = 0;
            TotalOutstanding = 0;
            TotalReceivedGST = 0;
            TotalbilledGST = 0;
            TotalOutstandingGST = 0;
            ParallelFundingApproval = 0;
            AmountcollectfromCustomer = 0;
            AmountcollectfromCustomerGST = 0;
            SDRAmount =0;
            OCRAmount = 0;
            PDCAmount = 0;
            PDCGSTAmount = 0;
            
            String sBookingId = ApexPages.CurrentPage().getparameters().get('id');
            booking = [select Id,Booking_Date__c,Sales_Manager__c,Sales_Manager__r.Name,Project_Name__r.Sales_Head__r.Name,Project_Name__r.Post_Sales_Head__r.Name,Project_Name__r.Project_Head__r.Name,Total_Amount__c,Agreement_Value__c,GST__c,Tower_Name__c,Tower_Name__r.Tower_Initials__c,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Tower_Name__r.Builder_Organisation__r.Bank_Name__c,POA__c,Project_Name__c,Project_Name__r.Project_Head__c,Primary_Applicant__c,Primary_Applicant__r.Name,Tower_Name__r.Builder_Organisation__r.GST_Bank_Name__c,Tower_Name__r.Builder_Organisation__r.Branch_Address__c,Tower_Name__r.Builder_Organisation__r.GST_Branch_Address__c,Tower_Name__r.Builder_Organisation__r.Bank_Account_Number__c,Tower_Name__r.Builder_Organisation__r.GST_Bank_Account_Number__c,Tower_Name__r.Builder_Organisation__r.IFSC_code__c,Tower_Name__r.Builder_Organisation__r.GST_IFSC_code__c,Related_Suggested_Property__c,Owner.Name,Owner.Email from Booking__c where Id =: sBookingId];
            
            if(booking != null){
                accountObject = [select Id,PAN_No__c,Aadhar_No__pc,PersonMobilePhone,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode from Account where Id =: booking.Primary_Applicant__c ];
                bankloaddetails = [select id,Home_LoanInstitution__c,Home_LoanInstitution__r.Name,Sanction_Amount__c from Bank_Loan_Details__c where Booking__c =: booking.id];
            }
            if(booking != null){
                property = [select Id,Unit__c,Payment_Plan__c,Payment_Plan__r.Name from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
            }
            if(property.size() > 0){
                for(Suggested_Property__c prop :property){
                properties = [select Id,Name,Floor__c from Property__c where Id =: prop.Unit__c];
                }
            }
            if(booking != null){
                paymentMilestone = [select Id,Due_Date__c,Milestone_Amount1__c,GST_Amount1__c from Payment_Milestones__c where Booking__c =: booking.id and Milestone_Status__c = 'Active'];
                for(Payment_Milestones__c pm : paymentMilestone)
                {
                    Totalbilled = Totalbilled + pm.Milestone_Amount1__c;
                    TotalbilledGST = TotalbilledGST + pm.GST_Amount1__c;
                }
            }
            
            if(bankloaddetails.size() > 0 && booking.Agreement_Value__c != null)
            {
                if(bankloaddetails.get(0).Sanction_Amount__c == null)
                {
                    bankloaddetails.get(0).Sanction_Amount__c = 0;
                }
                
               
            }
            //totalReceiveAmount = (booking.Agreement_Value__c * 10 ) / 100;
            //totalReceiveGSTAmount = (booking.Agreement_Value__c * 10 ) / 100;
            paymentList = [select Id,Name,Paid_by__c,Amount__c,BankName__c,Booking__c,Branch_Name__c,Cheque_Transaction_Number__c,Payment_Type__c,Payment_Status__c,Payment_Description__c,
                                 Payment_Date__c,Payment_Category__c,Date__c,Receipt_No__c from Payment__c where Booking__c =: booking.Id];
         
               
                for(Payment__c pay : paymentList)
                {
                    if(pay.Payment_Category__c == 'TDS')
                    {
                    TDSChalanNumber = pay.Cheque_Transaction_Number__c;
                    }
                     if(pay.Payment_Category__c == 'Unit Cost' && pay.Payment_Status__c!='Rejected')
                     {
                         TotalReceived = TotalReceived + pay.Amount__c;
                     }
                     if(pay.Payment_Category__c == 'GST' && pay.Payment_Status__c!='Rejected')
                     {
                         TotalReceivedGST = TotalReceivedGST + pay.Amount__c;
                     }
                     if(pay.Payment_Category__c == 'Stamp Duty ')
                     {
                         if(pay.Payment_Status__c!='Rejected')
                         {
                             SDRAmount = SDRAmount + pay.Amount__c;
                         }
                         SDRClearedDate = pay.Payment_Date__c;
                         StampDutyTrxNumber = pay.Cheque_Transaction_Number__c;
                     }
                      if(pay.Payment_Category__c == 'Unit Cost' && pay.Paid_By__c == 'Self' && pay.Payment_Status__c!='Rejected')
                     {
                         OCRAmount = OCRAmount + pay.Amount__c;
                     }
                     if(pay.Payment_Category__c == 'Unit Cost' && pay.Date__c > Date.Today() && pay.Payment_Status__c!='Rejected')
                     {
                         PDCAmount = PDCAmount + pay.Amount__c;
                     }
                      if(pay.Payment_Category__c == 'GST' && pay.Date__c > Date.Today() && pay.Payment_Status__c!='Rejected')
                     {
                         PDCGSTAmount = PDCGSTAmount + pay.Amount__c;
                     }
                     
                    
                }   
                TotalOutstanding = Totalbilled - TotalReceived;
                TotalOutstandingGST = TotalbilledGST - TotalReceivedGST;
                AmountcollectfromCustomer = Totalbilled - TotalOutstanding;
                AmountcollectfromCustomerGST = TotalbilledGST - TotalOutstandingGST;
                if(bankloaddetails.size() > 0)
                {
                ParallelFundingApproval = booking.Agreement_Value__c - bankloaddetails.get(0).Sanction_Amount__c - OCRAmount;
                }
               
                
               /*List<Profile> SalesProfie =  [select Id, Name from Profile where name ='Sales' Limit 1];
               if(SalesProfie.size() > 0)
               {
                   SalesUser = [select id,name from User where profile.id =: SalesProfie.get(0).id];
               }
               List<Profile> PostSalesProfie =  [select Id, Name from Profile where name ='Post Sales' Limit 1];
               if(PostSalesProfie.size() > 0)
               {
                   PostSalesUser = [select id,name from User where profile.id =: PostSalesProfie.get(0).id];
               }*/
                
                
      } 
}