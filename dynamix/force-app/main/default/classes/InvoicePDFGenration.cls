public Class InvoicePDFGenration{
    
    public Account accountObject{get;set;}
    public Booking__c booking{get;set;}
    public list<Payment_Milestones__c> payMilestonelist{get;set;}
    public Property__c properties{get;set;}
    public Project__c project{get;set;}
    public List<Suggested_Property__c> property{get;set;}
    public Decimal TotalOutstanding {get;set;}
    public Decimal TotalReceivedGST {get;set;}
    public Decimal TotalbilledGST {get;set;}
    public Decimal TotalOutstandingGST {get;set;}
    public Decimal CGST{get;set;}
    public Decimal SGST{get;set;}
    public Decimal TDS{get;set;}
    public Decimal AmountDue{get;set;}
    public User user{get;set;}
    public List<ContentDocumentLink> contentDoc {get;set;}
    public List<ContentVersion> contentVerObject{get;set;}
    Public String ProjectHeader{get;set;}
    Public String ProjectFooter{get;set;}
    Public String InvoiceID{get;set;}
    public list<Co_Applicant__c> coApp{get;set;}
    public String coAppName{get;set;}
    public String TotalOutstandingInWords{get;set;}
    public String TotalOutstandingGSTInWords{get;set;}
    public String TDSInWords{get;set;}
    public String AmountDueInWords{get;set;}
    public String paymentMilestoneId{get;set;}
    public String isNewBooking{get;set;}
    public String AgreementValueInWords{get;set;}
    public List<Payment_Milestones__c> milestoneNamesList{get;set;}
    
    public Date invoiceDate {get;set;}
    
    public InvoicePDFGenration(ApexPages.StandardController controller){
        TotalOutstanding = 0;
        TotalReceivedGST = 0;
        TotalbilledGST = 0;
        TotalOutstandingGST = 0;
        CGST=0;
        SGST=0; 
        TDS=0;
        milestoneNamesList=new List<Payment_Milestones__c>();
        String bookingId= ApexPages.CurrentPage().getparameters().get('id');
        // String bookingId= 'a0CC4000005ZIiLMAW';
        InvoiceID=ApexPages.CurrentPage().getparameters().get('InvoiceID');
        paymentMilestoneId=ApexPages.CurrentPage().getparameters().get('PaymentMilestoneId');
        isNewBooking=ApexPages.CurrentPage().getparameters().get('isNewBooking');
        System.debug('isNewBooking:'+isNewBooking);
        System.debug('paymentMilestoneId Vf Page Controller:'+paymentMilestoneId);
        booking = [select Id,Booking_Date__c,Agreement_Sent_to_Agent_Date__c,Project_Name__r.GST_Applicable__c,Agreement_Value__c,Registration_Status__c,Owner.ID,GST__c,Project_Name__c,Project_Name__r.Name, Payment_Received_GST__c,Payment_Received_Unit__c,Payment_Milestones_Total_Amount__c,Payment_Milestones_Total_GST__c,Tower_Name__c,Tower_Name__r.Tower_Initials__c,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Primary_Applicant__c,Primary_Applicant__r.Name,Related_Suggested_Property__c,Owner.phone,Owner.Name,Owner.Email from Booking__c where Id =: bookingId];
        if(booking!=null)
        {
            coApp = [select id,Applicant_Name__c,Role__c,Account__c,Account__r.name,Booking__c from Co_Applicant__c where Booking__c=:booking.id];
            coAppName='';
            if(coApp.size()>0)
            {   
                for(Co_Applicant__c  c:coApp)
                {
                    if(c.Role__c!='Primary')
                    {
                        coAppName = coAppName+c.Account__r.name+',';
                    }
                }
                coAppName = coAppName.removeEnd(',');
                
            }
        } 
        payMilestonelist = [select id,Name,booking__c,Milestone_Amount1__c,GST_Amount1__c,Remaining_Amount__c,Remaining_GST__c,Milestone_Activation_Date__c from Payment_Milestones__c where Booking__c =: booking.id and Milestone_Status__c = 'Active'];
        System.debug('payMilestonelist:'+payMilestonelist);
        for(Payment_Milestones__c pm : payMilestonelist)
        {
            System.debug('pm.name=>'+pm.Name);
            if(paymentMilestoneId!=null && paymentMilestoneId==pm.id && isNewBooking=='false'){
                invoiceDate=pm.Milestone_Activation_Date__c;
                TotalOutstanding = TotalOutstanding + pm.Remaining_Amount__c;
                TotalOutstandingGST = TotalOutstandingGST + pm.Remaining_GST__c ;
                if(pm.Name!=null){
                    milestoneNamesList.add(pm);
                }
            }
            else if(isNewBooking=='true'){
                invoiceDate=pm.Milestone_Activation_Date__c;
                TotalOutstanding = TotalOutstanding + pm.Remaining_Amount__c;
                TotalOutstandingGST = TotalOutstandingGST + pm.Remaining_GST__c ;
                if(pm.Name!=null){
                    milestoneNamesList.add(pm);
                }
            }
        }
        if(booking.Project_Name__c != null){
            project = [select Id,GST_Applicable__c,Name,Location__c,Sublocation__c,Project_Header__c,Project_Footer__c,Builder_Organization__r.PAN_No__c,Builder_Organization__r.GST_No__c,Builder_Organization__r.IFSC_Code__c,Builder_Organization__r.Name,Builder_Organization__c,Builder_Organization__r.Account_Name__c,Builder_Organization__r.GST_Account_Name__c,Builder_Organization__r.Bank_Account_Number__c,Builder_Organization__r.Bank_Name__c,Builder_Organization__r.Branch_Address__c,Builder_Organization__r.Branch_Name__c,Builder_Organization__r.GST_Bank_Account_Number__c,Builder_Organization__r.GST_Bank_Name__c,Builder_Organization__r.GST_Branch_Address__c,Builder_Organization__r.GST_IFSC_Code__c,City__c,State__c,Project_Email__c from Project__c where Id =: booking.Project_Name__c];
            if(project.Project_Header__c!='')
            {
                ProjectHeader=project.Project_Header__c; 
            }
            if(project.Project_Footer__c!='')
            {
                ProjectFooter =project.Project_Footer__c; 
            }
        }
        if(project!=null && project.Name == 'Parkwoods D5'){
            CGST=(TotalOutstanding*0.5)/100;
            SGST=(TotalOutstanding*0.5)/100; 
        }
        else{
            CGST=(TotalOutstanding*2.5)/100;
            SGST=(TotalOutstanding*2.5)/100; 
        }
        TDS=(TotalOutstanding*1)/100;
        AmountDue=TotalOutstanding-TDS;
        TotalOutstandingInWords=NumberTOWordConvertion.getNumberTOWordConvertion(TotalOutstanding.setscale(0)).removeStart(' ');
        TotalOutstandingGSTInWords=NumberTOWordConvertion.getNumberTOWordConvertion(TotalOutstandingGST.setscale(0)).removeStart(' ');
        TDSInWords=NumberTOWordConvertion.getNumberTOWordConvertion(TDS.setscale(0)).removeStart(' ');
        AmountDueInWords=NumberTOWordConvertion.getNumberTOWordConvertion(AmountDue.setscale(0)).removeStart(' ');
        AgreementValueInWords=NumberTOWordConvertion.getNumberTOWordConvertion(booking.Agreement_Value__c.setscale(0)).removeStart(' ');
        if(booking.Owner.ID != null ){
            user =[select Id,name,mobilephone from user where id=:booking.Owner.ID];
        }
        if(booking.Primary_Applicant__c != null ){
            accountObject = [select Id,PersonMobilePhone,PersonMailingStreet,PersonMailingCountry,PersonMailingCity,PersonMailingState,PersonMailingPostalCode from Account where Id =: booking.Primary_Applicant__c ];
        }
        if(booking.Related_Suggested_Property__c != null ){
            property = [select Id,Unit__c from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
        }
        System.debug('property:'+property);
        if(property!=null && property.size() > 0){
            for(Suggested_Property__c prop :property){
                properties = [select Id,Name,Floor__c  from Property__c where Id =: prop.Unit__c];
                
            }
        }
        
    }
}