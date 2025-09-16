Public class FlatCostChangeNoteDetail{

         public string sBookingId {get;set;}
         public Decimal newAgreementValue {get;set;}
         public Booking__c booking{get;set;}
         public Decimal DifferenceAmount {get;set;}
         public List<Suggested_Property__c> property{get;set;}
         public Property__c properties{get;set;}
         public String SchemeName {get;set;}
         public Payment_Plan__c payPlan{get;set;}
         public List<Bank_Loan_Details__c> bankloandetails{get;set;}
         public Decimal OCRAmount{get;set;}
         public List<Payment__c> paymentList{get;set;}
         public Decimal totalBilled {get;set;}
         public Decimal totalbilledGST {get;set;}
         public Decimal totalReceived {get;set;}
         public Decimal totalReceivedGST {get;set;}
         public Decimal totalOutstanding {get;set;}
         public Decimal totalOutstandingGST {get;set;}
         public List<Payment_Milestones__c> paymentMilestone {get;set;}
         
         public FlatCostChangeNoteDetail(ApexPages.StandardController controller){
         
              OCRAmount = 0;
              totalBilled = 0;
              totalbilledGST = 0;
              totalReceived = 0;
              totalReceivedGST = 0;
              totalOutstanding = 0;
              totalOutstandingGST = 0;
              
             sBookingId = ApexPages.CurrentPage().getparameters().get('id');
           	  
             newAgreementValue =  Decimal.ValueOf(ApexPages.CurrentPage().getparameters().get('newAgreementValue'));
                
              
              booking = [select Id,Booking_Date__c,Sales_Manager__r.Name,Project_Name__r.Project_Head__r.Name,Project_Name__r.Post_Sales_Head__r.Name,Project_Name__r.Sales_Head__r.Name,Agreement_Value__c,Primary_Applicant__r.Aadhar_No__pc,Primary_Applicant__r.PAN_No__pc,Payment_Received_Agreement__c,Total_Amount__c,Total_consolidated_amount__c,Stamp_Duty__c,Registration_Date__c,Registration_Charges__c,GST__c,Tower_Name__c,Tower_Name__r.Name,Tower_Name__r.Tower_Initials__c,Tower_Name__r.Building_Type__c,Tower_Name__r.Builder_Organisation__r.Bank_Name__c,Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.Name,Tower_Name__r.Builder_Organisation__r.GST_Bank_Name__c,Tower_Name__r.Builder_Organisation__r.Branch_Address__c,Tower_Name__r.Builder_Organisation__r.GST_Branch_Address__c,Tower_Name__r.Builder_Organisation__r.Bank_Account_Number__c,Tower_Name__r.Builder_Organisation__r.GST_Bank_Account_Number__c,Tower_Name__r.Builder_Organisation__r.IFSC_code__c,Tower_Name__r.Builder_Organisation__r.GST_IFSC_code__c,Related_Suggested_Property__c,Owner.Name,Owner.Email from Booking__c where Id =: sBookingId];
              
              if(newAgreementValue != null && booking.Agreement_Value__c != null)
              {
                  DifferenceAmount = newAgreementValue - booking.Agreement_Value__c;
              }
              if(booking != null){
                property = [select Id,Unit__c,Payment_Plan__c,Payment_Plan_Detail__c,Payment_Plan__r.Name from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
                bankloandetails = [select id,Home_LoanInstitution__c,Home_LoanInstitution__r.Name,Sanction_Amount__c from Bank_Loan_Details__c where Booking__c =: booking.id];
              
                paymentMilestone = [select Id,Due_Date__c,Milestone_Amount1__c,GST_Amount1__c from Payment_Milestones__c where Booking__c =: booking.id and Milestone_Status__c = 'Active'];
                for(Payment_Milestones__c pm : paymentMilestone)
                {
                    Totalbilled = Totalbilled + pm.Milestone_Amount1__c;
                    TotalbilledGST = TotalbilledGST + pm.GST_Amount1__c;
                }
              }
            
            list<Payment_Plan_Milestones__c> SuggesList =(List<Payment_Plan_Milestones__c>)JSON.deserialize(property[0].Payment_Plan_Detail__c, List<Payment_Plan_Milestones__c>.class);
            
            if(SuggesList.size() <> 0)
            {
               SchemeName = SuggesList[0].Payment_Plan__c; 
            }
             
            if(SchemeName != null && SchemeName != '')
            {
                payPlan = [select Name from Payment_Plan__c where id = : SchemeName ];
            }
                  
            if(property.size() > 0){
                for(Suggested_Property__c prop :property){
                    properties = [select Id,Name,Floor__c from Property__c where Id =: prop.Unit__c];
                }
            }
            
            paymentList = [select Id,Name,Paid_by__c,Amount__c,BankName__c,Booking__c,Branch_Name__c,Cheque_Transaction_Number__c,Payment_Type__c,Payment_Status__c,Payment_Description__c,
                                 Payment_Date__c,Payment_Category__c,Date__c,Receipt_No__c from Payment__c where Booking__c =: booking.Id];
         
               
            for(Payment__c pay : paymentList)
            {
                if(pay.Payment_Category__c == 'Unit Cost' && pay.Paid_By__c == 'Self' && pay.Payment_Status__c!='Rejected')
                {
                     OCRAmount = OCRAmount + pay.Amount__c;
                }
                if(pay.Payment_Category__c == 'Unit Cost' && pay.Payment_Status__c!='Rejected')
                {
                    TotalReceived = TotalReceived + pay.Amount__c;
                }
                if(pay.Payment_Category__c == 'GST' && pay.Payment_Status__c!='Rejected')
                {
                    TotalReceivedGST = TotalReceivedGST + pay.Amount__c;
                }
            }
            totalOutstanding = Totalbilled - TotalReceived;
            totalOutstandingGST = TotalbilledGST - TotalReceivedGST;
            
         }

}