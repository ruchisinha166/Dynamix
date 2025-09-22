public class PaymentReminderClass{
        
    public Id PMId;
    public Account accountObject{get;set;}
    public List<Payment__c> paymentList{get;set;}
 //   public Payment__c payment{get;set;}
    public Booking__c booking{get;set;}
    public Property__c properties{get;set;}
    public Project__c project{get;set;}
    public Project__c projectobj{get;set;}
    public List<Suggested_Property__c> property{get;set;}
    public List<Payment_Milestones__c> paymentMilestone {get;set;}
    public Payment_Milestones__c paymentMilestoneobj {get;set;}
    public List<id> paymentMilestoneId {get;set;}
  //  public List<AggregateResult> PMDueDate {get;set;}
    public Suggested_Property__c sPropertyobj{get;set;}
 //   public boolean dateValue {get;set;}
    public Decimal TotalReceivedAmount {get;set;}
  //  public Decimal TotalBilled {get;set;}
    public Decimal Amount{get;set;}
    public Decimal GST{get;set;}
    public Decimal TotalOutstanding {get;set;}
    public Decimal TotalReceivedGST {get;set;}
  //  public Decimal TotalbilledGST {get;set;}
    public Decimal TotalAmountwihIntrest{get;set;}
    public Decimal TotalOutstandingGST {get;set;}
    public Decimal gstInterest{get;set;}
    public Decimal TotalRemainingAmount {get;set;}
    public Decimal totalRecived{get;set;}
    public Decimal interestRate{get;set;}
    public Decimal amountInterest{get;set;}
  //  public Decimal totalPayableInterest{get;set;}
  //  public Date DueDate{get;set;}
    public String Scheme{get;set;}
    public List<Interest_Charged__c> Intrestlist{get;set;}
    public Builder_Organisation__c builderOrg{get;set;}
    public List<Co_Applicant__c> Coapplicant{get;set;}
 //   public string secoundReminder{get;set;}
    public string MilestoneAmountInWord{get;set;}   
    public string TotalAmountwihIntrestInWord{get;set;}  
    public string  TotalRemainingInWord{get;set;} 
    public string TotalOutstandingGSTInWord{get;set;}
    public string totalRecivedInWord{get;set;}
    public Decimal gstOnTotalAmount{get;set;}
    public List<ContentDocumentLink> contentDoc {get;set;}
    public List<ContentVersion> contentVerObject{get;set;}
    Public string ProjectHeader{get;set;}
    Public string ProjectFooter{get;set;}
 //   public String imageURLT{get;set;}
 //   public String imageURLB{get;set;}
    public String milstonName{get;set;}
 //   public String sfdcBaseURL{get;set;}
    public string CoApplicantNames{get;set;}
    Public User currentUser{get;set;}
    public string floor{get;set;}
    
    Public string AccountHolder{get;set;}
    public String bankName{get;set;}
    public String accountNo{get;set;}
    public String IFSCcode{get;set;}

   
    
    List< document > documentList{get;set;}
        public String getPMId() {
            return PMId;
        }
        
        public void setPMId(String s) {
            PMId= s;
            init();
        }
              
        public void init(){
          builderOrg = new Builder_Organisation__c ();
          Intrestlist = new List<Interest_Charged__c>();
      //    sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            
            TotalReceivedAmount = 0;
         //   TotalBilled = 0;
            TotalRemainingAmount =0;
            TotalOutstanding = 0;
            TotalReceivedGST = 0;
      //      TotalbilledGST = 0;
            gstInterest=0;
            totalRecived=0;
            interestRate=0;
            amountInterest=0;
            gstOnTotalAmount=0;
            milstonName='';
            paymentMilestoneobj = new Payment_Milestones__c(); 
            paymentMilestone= new list<Payment_Milestones__c>(); 
            Amount=0;
            GST=0;
            projectobj  = new Project__c(); 
            TotalOutstandingGST = 0;
            documentList = new list<document>();
            sPropertyobj= new Suggested_Property__c();
            paymentMilestoneId = new list<id>();
            system.debug('PMId =='+PMId );
            List<Payment_Milestones__c> bllist = new List<Payment_Milestones__c>(); 
            if(PMId!= null || PMId!= '')
            {
                bllist = [select Id,Last_Amount_Due_Outstanding_Due__c,CGST_On_Total_Amount_Due__c,CGST_On_Milestone_Remining_Amount_Due__c,Interest_on_CGST_SGST__c,Total_Interest_Due__c,Total_Due_Amount_of_Milestones__c,SGST_on_Milestone_Remining_Amount__c,SGST_On_Total_Amount_Due__c,Interest_on_Total_Amount_of_Milestones__c,Gst_On_Total_Interest_Due__c,Total_Payable_Interest__c,Interest_On_Remaining_GST_And_Milestone__c,Total_GST_on_Interest__c,name,Booking__c,Milestone_Activation_Date__c,First_Payment_Email_Reminder_Date__c,Second_Payment_Email_Reminder_Date__c,Third_Payment_Email_Reminder_Date__c,forth_Payment_Email_Reminder_Date__c from Payment_Milestones__c where Id =: PMId];
            }
            system.debug('bllist =='+bllist );
            if(bllist.size() > 0)
            {
                booking = [select Id,Project_Name__r.GST_Applicable__c,Project_Name__r.Name,Booking_Date__c,Agreement_Value__c,Property_Name__c,Registration_Status__c,Registration_Date__c,GST__c,Payment_Received_GST__c,Payment_Received_Unit__c,Payment_Milestones_Total_Amount__c,Payment_Milestones_Total_GST__c,Tower_Name__c,Tower_Name__r.Tower_Initials__c,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.Name,Related_Suggested_Property__c,Owner.Name,Owner.Email from Booking__c where Id =: bllist[0].Booking__c];
                if(bllist[0].First_Payment_Email_Reminder_Date__c==date.today())
                {
                    paymentMilestone = [select Id,Last_Amount_Due_Outstanding_Due__c,CGST_On_Total_Amount_Due__c,CGST_On_Milestone_Remining_Amount_Due__c,Interest_on_CGST_SGST__c,Total_Interest_Due__c,Total_Due_Amount_of_Milestones__c,SGST_on_Milestone_Remining_Amount__c,SGST_On_Total_Amount_Due__c,Interest_on_Total_Amount_of_Milestones__c,Gst_On_Total_Interest_Due__c,Total_Payable_Interest__c,Interest_On_Remaining_GST_And_Milestone__c,Total_GST_on_Interest__c,name,First_Payment_Email_Reminder_Date__c,Second_Payment_Email_Reminder_Date__c,Third_Payment_Email_Reminder_Date__c,forth_Payment_Email_Reminder_Date__c, Milestone_Activation_Date__c,Due_Date__c,Remaining_Amount__c,Remaining_GST__c,Milestone_Amount1__c,GST_Amount1__c,booking__c from Payment_Milestones__c where First_Payment_Email_Reminder_Date__c=:date.today() and booking__c=:booking.id ];
                    paymentMilestoneobj =paymentMilestone[0];
                } 
                if(bllist[0].Second_Payment_Email_Reminder_Date__c==date.today())
                {
                    paymentMilestone = [select Id,Last_Amount_Due_Outstanding_Due__c,CGST_On_Total_Amount_Due__c,CGST_On_Milestone_Remining_Amount_Due__c,Interest_on_CGST_SGST__c,Total_Interest_Due__c,Total_Due_Amount_of_Milestones__c,SGST_on_Milestone_Remining_Amount__c,SGST_On_Total_Amount_Due__c,Interest_on_Total_Amount_of_Milestones__c,Gst_On_Total_Interest_Due__c,Total_Payable_Interest__c,Interest_On_Remaining_GST_And_Milestone__c,name,Total_GST_on_Interest__c,First_Payment_Email_Reminder_Date__c,Second_Payment_Email_Reminder_Date__c,Third_Payment_Email_Reminder_Date__c,forth_Payment_Email_Reminder_Date__c, Milestone_Activation_Date__c,Due_Date__c,Remaining_Amount__c,Remaining_GST__c,Milestone_Amount1__c,GST_Amount1__c from Payment_Milestones__c where Second_Payment_Email_Reminder_Date__c=:date.today() and booking__c=:booking.id];
                    paymentMilestoneobj =paymentMilestone[0];
                }
                if(bllist[0].Third_Payment_Email_Reminder_Date__c==date.today())
                {
                    paymentMilestone = [select Id,Last_Amount_Due_Outstanding_Due__c,CGST_On_Total_Amount_Due__c,CGST_On_Milestone_Remining_Amount_Due__c,Interest_on_CGST_SGST__c,Total_Interest_Due__c,Total_Due_Amount_of_Milestones__c,SGST_on_Milestone_Remining_Amount__c,SGST_On_Total_Amount_Due__c,Interest_on_Total_Amount_of_Milestones__c,Gst_On_Total_Interest_Due__c,Total_Payable_Interest__c,Interest_On_Remaining_GST_And_Milestone__c,name,Total_GST_on_Interest__c,First_Payment_Email_Reminder_Date__c,Second_Payment_Email_Reminder_Date__c,Third_Payment_Email_Reminder_Date__c,forth_Payment_Email_Reminder_Date__c, Milestone_Activation_Date__c,Due_Date__c,Remaining_Amount__c,Remaining_GST__c,Milestone_Amount1__c,GST_Amount1__c from Payment_Milestones__c where Third_Payment_Email_Reminder_Date__c=:date.today() and booking__c=:booking.id];
                    paymentMilestoneobj =paymentMilestone[0];
                }
                if(bllist[0].forth_Payment_Email_Reminder_Date__c==date.today())
                {
                    paymentMilestone = [select Id,Last_Amount_Due_Outstanding_Due__c,CGST_On_Total_Amount_Due__c,CGST_On_Milestone_Remining_Amount_Due__c,Interest_on_CGST_SGST__c,Total_Interest_Due__c,Total_Due_Amount_of_Milestones__c,SGST_on_Milestone_Remining_Amount__c,SGST_On_Total_Amount_Due__c,Interest_on_Total_Amount_of_Milestones__c,Gst_On_Total_Interest_Due__c,Total_Payable_Interest__c,name,Interest_On_Remaining_GST_And_Milestone__c,Total_GST_on_Interest__c,First_Payment_Email_Reminder_Date__c,Second_Payment_Email_Reminder_Date__c,Third_Payment_Email_Reminder_Date__c,forth_Payment_Email_Reminder_Date__c, Milestone_Activation_Date__c,Due_Date__c,Remaining_Amount__c,Remaining_GST__c,Milestone_Amount1__c,GST_Amount1__c from Payment_Milestones__c where forth_Payment_Email_Reminder_Date__c=:date.today() and booking__c=:booking.id];
                    paymentMilestoneobj =paymentMilestone[0];
                }
            }    
                 if(paymentMilestone.size()>0)
                {
                    for(Payment_Milestones__c p: paymentMilestone)
                    {
                        paymentMilestoneId.add(p.id);
                    }
                 
                }
                if(paymentMilestoneId.size()>0)
                {       
                    Intrestlist =[select id,Milestone__c,Interest_Amount__c,createddate,Interest_Rate__c,Interest_Amount_GST__c,Interest_on_total_Amount__c,Intrest_calucation_Amount__c from Interest_Charged__c where Milestone__c In: paymentMilestoneId  ORDER BY  createddate  desc ];
                    if(Intrestlist.size()>0)
                    {
                        interestRate =Intrestlist [0].Interest_Rate__c;
                        for(Interest_Charged__c i : Intrestlist)
                        {
                            amountInterest=amountInterest +i.Interest_Amount__c;
                            gstInterest =gstInterest +i.Interest_Amount_GST__c ;
                            gstOnTotalAmount=gstOnTotalAmount+i.Interest_on_total_Amount__c;
                        }
                    }
                } 
                 
                if(paymentMilestone.size()>0)
                {
                    for(Payment_Milestones__c p: paymentMilestone)
                    {
                        milstonName = milstonName+p.name+', ';
                        Amount=Amount+p.Milestone_Amount1__c;
                        GST=GST+p.GST_Amount1__c ;
                        TotalOutstanding = (TotalOutstanding + p.Remaining_Amount__c+p.Remaining_GST__c).round();
                        TotalRemainingAmount =(TotalRemainingAmount+p.Remaining_Amount__c).round();
                        TotalOutstandingGST =(TotalOutstandingGST+p.Remaining_GST__c).round();   
                        
                        TotalReceivedAmount =TotalReceivedAmount+(p.Milestone_Amount1__c-p.Remaining_Amount__c) ;
                        TotalReceivedGST =TotalReceivedGST+(p.GST_Amount1__c -p.Remaining_GST__c) ;
                        } 
                      TotalAmountwihIntrest = (TotalOutstanding +amountInterest+gstInterest +gstOnTotalAmount).round();
                      totalRecived=(TotalReceivedAmount +TotalReceivedGST).round();
                      totalRecivedInWord=NumberTOWordConvertion.getNumberTOWordConvertion(totalRecived);
                      TotalAmountwihIntrestInWord = NumberTOWordConvertion.getNumberTOWordConvertion(TotalAmountwihIntrest); 
                      MilestoneAmountInWord = NumberTOWordConvertion.getNumberTOWordConvertion(TotalOutstanding); 
                      TotalRemainingInWord = NumberTOWordConvertion.getNumberTOWordConvertion(TotalRemainingAmount);
                      TotalOutstandingGSTInWord=NumberTOWordConvertion.getNumberTOWordConvertion(TotalOutstandingGST);
                      milstonName = milstonName.removeEnd(', ');
                }
            
               
                 
                 
               
                
            if(booking != null){
            accountObject = [select Id,Salutation,Name,PersonMobilePhone,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode,PersonMailingCountry,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Phone from Account where Id =: booking.Primary_Applicant__c ];
            Coapplicant = [select id,Booking__c,Account__r.Name,Account__r.salutation,Name from Co_Applicant__c where Booking__c  =: booking.id Order by Role__c];
            currentUser = [SELECT ID, Name FROM User WHERE ID = :UserInfo.getUserId()];
                for(Co_Applicant__c ca : Coapplicant)
                {
                    if(CoApplicantNames == '')
                    {
                        CoApplicantNames = ca.Account__r.salutation+' '+ca.Account__r.name;
                    }
                    else
                    {
                        CoApplicantNames = CoApplicantNames+','+ca.Account__r.salutation+' '+ca.Account__r.name; 
                    } 
                }
            
        } 
            system.debug('booking =='+booking );
             
           
             if(booking != null){
                    property = [select Id,Unit__c from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
                    
            }
             if(booking != null){
             sPropertyobj= [select Id,Unit__c,Unit__r.name,Unit__r.Project__c,Opportunity__r.Owner.Name,Unit__r.Floor__c,Payment_Plan__c,Payment_Plan__r.Name from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];   
            if(sPropertyobj!=null)
            {
                Scheme=sPropertyobj.Payment_Plan__r.Name; 
                if(integer.valueof(sPropertyobj.Unit__r.Floor__c) >= 11 && integer.valueof(sPropertyobj.Unit__r.Floor__c) <= 13)
            {
                floor = 'th';
            }
            else if(math.mod(integer.valueof(sPropertyobj.Unit__r.Floor__c), 10) == 1)
            {
                 floor = 'st';
            }
            else if(math.mod(integer.valueof(sPropertyobj.Unit__r.Floor__c), 10) == 2)
            {
                 floor = 'nd';
            }
            else if(math.mod(integer.valueof(sPropertyobj.Unit__r.Floor__c), 10) == 3)
            {
                 floor = 'rd';
            }
            else
            {
                floor = 'th';
            }
            }
        }
            list<ID> unitid = new List<ID>();
            
             if(property != null && property.size() > 0){
                    for(Suggested_Property__c prop :property){
                    unitid.add(prop.Unit__c);
                   
                }
               }
            if(booking!=null && unitid !=null){
              properties = [select Id,Name,Floor__c from Property__c where Id IN: unitid ];
            } 
             
            if(booking!=null && booking.Project_Name__c != null){
                 project = [select Id,Name,Builder_Organization__r.Bank_Name__c,Builder_Organization__r.IFSC_Code__c,Builder_Organization__r.name,Builder_Organization__r.Bank_Account_Number__c,Project_Header__c,Project_Footer__c,Postal_Code__c,Location__c,Sublocation__c,City__c,State__c,Project_Email__c,Project_Phone__c from Project__c where Id =:booking.Project_Name__c ];//'a0K9D000003MLxXUAW'
                
                 AccountHolder = project.Builder_Organization__r.name;
                 bankName= project.Builder_Organization__r.Bank_Name__c;
                 accountNo= project.Builder_Organization__r.Bank_Account_Number__c;
                 IFSCcode= project.Builder_Organization__r.IFSC_Code__c;
                
                if(project.Project_Header__c!='')
                {
                    ProjectHeader=project.Project_Header__c; 
                }
                if(project.Project_Footer__c!='')
                {
                    ProjectFooter =project.Project_Footer__c; 
                }
            } 
            
   } 
      
}