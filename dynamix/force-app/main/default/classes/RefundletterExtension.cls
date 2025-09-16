public Class RefundletterExtension{
        
    public Suggested_Property__c sPropertyobj{get;set;}
    public Account accountObject{get;set;}
    public Booking__c booking{get;set;}
    //public Payment_Milestones__c payMilestone{get;set;}
    public Project__c project{get;set;}
    public List<Suggested_Property__c> property{get;set;}
    public User user{get;set;}
    public List<ContentDocumentLink> contentDoc {get;set;}
    public List<ContentVersion> contentVerObject{get;set;}
    Public id ProjectHeader{get;set;}
    Public id ProjectFooter{get;set;}
    Public string floor{get;set;}
    public string AmountInWords{get;set;}
    public list<Co_Applicant__c> coApp{get;set;}
    public  Payment__c paymentObj{get;set;}
    public String coAppName{get;set;}
    public String sfdcBaseURL{get;set;}
    
    
        public RefundletterExtension(ApexPages.StandardController controller){
            sPropertyobj= new Suggested_Property__c();
            coAppName ='';
            paymentObj = new Payment__c(); 
            sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            //String sBookingId = ApexPages.CurrentPage().getparameters().get('id');
                    String PaymentId = ApexPages.CurrentPage().getparameters().get('payid');
            //String sBookingId='a06N000000SkcM0IAJ';
            //String PaymentId='a0EN000000Iw3OUMAZ';
            paymentObj =[select id,Amount__c,Payment_Date__c,Booking__c,BankName__r.name,Reference_No__c,Receipt_No__c,Branch_Name__c,Date__c,Cheque_Transaction_Number__c from Payment__c  where id=:PaymentId];
            booking = [select Id,Cancel_or_Termination_date__c,Registration_Number__c,Registration_Status__c,Registration_Date__c,Booking_Date__c,Agreement_Value__c,Owner.ID,GST__c,Project_Name__c,Project_Name__r.Name, Payment_Received_GST__c,Payment_Received_Unit__c,Payment_Milestones_Total_Amount__c,Payment_Milestones_Total_GST__c,Tower_Name__c,Tower_Name__r.Tower_Initials__c,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Primary_Applicant__c,Primary_Applicant__r.Name,Related_Suggested_Property__c,Owner.phone,Owner.Name,Owner.Email from Booking__c where Id =: paymentObj.Booking__c ];
            AmountInWords= NumberTOWordConvertion.getNumberTOWordConvertion(paymentObj.Amount__c); 
            //payMilestone =[select id,booking__c,Milestone_Amount1__c,forth_Payment_Email_Reminder_Date__c,Third_Payment_Email_Reminder_Date__c,GST_Amount1__c,First_Payment_Email_Reminder_Date__c,Second_Payment_Email_Reminder_Date__c,Remaining_Amount__c,Remaining_GST__c from Payment_Milestones__c where id=:milstoneId];
            coApp = [select id,Applicant_Name__c,Account__c,Account__r.name,Booking__c from Co_Applicant__c where Booking__c=:booking.id AND Role__c =: 'Co-Applicant'];
            coAppName='';
             if(coApp.size()>0)
            {   
                    for(Co_Applicant__c  c:coApp)
                    {
                        coAppName = coAppName+c.Account__r.name+', ';
                    }
                    coAppName = coAppName.removeEnd(', ');
                    
            }
            if(booking.Owner.ID != null ){
                user =[select Id,name,mobilephone from user where id=:booking.Owner.ID];
            }
            if(booking.Primary_Applicant__c != null ){
                accountObject = [select Id,Salutation,PersonMobilePhone,Phone,PersonMailingStreet,PersonMailingCountry,PersonMailingCity,PersonMailingState,PersonMailingPostalCode from Account where Id =: booking.Primary_Applicant__c ];
            }
            if(booking != null){
             sPropertyobj= [select Id,Unit__c,Unit__r.name,Unit__r.Project__c,Opportunity__r.Owner.Name,Unit__r.Floor__c,Payment_Plan__c,Payment_Plan__r.Name from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
            }
            if(booking.Project_Name__c != null){
                project = [select Id,Name,Postal_Code__c,Location__c,Sublocation__c,Builder_Organization__r.PAN_No__c,Builder_Organization__r.GST_No__c,Builder_Organization__r.IFSC_Code__c,Builder_Organization__r.Name,Builder_Organization__c,Builder_Organization__r.Bank_Account_Number__c,Builder_Organization__r.Bank_Name__c,Builder_Organization__r.Branch_Address__c,Builder_Organization__r.Branch_Name__c,Builder_Organization__r.GST_Bank_Account_Number__c,Builder_Organization__r.GST_Bank_Name__c,Builder_Organization__r.GST_Branch_Address__c,Builder_Organization__r.GST_IFSC_Code__c,City__c,State__c,Project_Email__c from Project__c where Id =: booking.Project_Name__c];
            }
            
            if(project <> null)
            {
            contentDoc = [select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId =: project.id];
            
            if(contentDoc <> null)
            {
                List<id> ContentVersionIds = new List<id>();
                for(ContentDocumentLink cdl :contentDoc)
                {
                    ContentVersionIds.add(cdl.ContentDocumentId);
                }
                if(ContentVersionIds <> null)
                {
                    contentVerObject = [SELECT VersionData,Document_Type__c,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId In: ContentVersionIds];
                    for(ContentVersion cv : contentVerObject)
                    {
                        if(cv.Document_Type__c == 'Project Header')
                        {
                            ProjectHeader = cv.Id;
                        }
                        if(cv.Document_Type__c == 'Project Footer')
                        {
                            ProjectFooter = cv.Id;
                        }
                    }
                }
            }
        }
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