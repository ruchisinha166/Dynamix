public class NOCControllerCLass{
    public Booking__c booking {get;set;}
    public String sBookingId {get;set;}
    public Account accountObject{get;set;}
    public List<Co_Applicant__c> Coapplicant{get;set;}
    public String TodayDate {get;set;}
    public String currentYear {get;set;}
    public Decimal agreementValue {get;set;}
    public Bank_Loan_Details__c	BankLoanObj {get;set;}
    public Property__c	property {get;set;}
    public Builder_Organisation__c builderOrgObj {get;set;}
    public Project__c projectObj {get;set;}
    public string coapplicantNames{get;set;}
    public boolean address {get;set;}
    public boolean phone {get;set;}
    public String convertedValue {get;set;}
    public String bankName { get; set; }
    public String ifscCode { get; set; }
    public String bankType { get; set; }
    public String remainingDigits { get; set; }
    public String spaces { get; set; }
    public Decimal sanctionedamount {get;set;}
    public String convertedSancValue {get;set;}
    public Decimal totalAmountRecValue {get;set;}
    public String convertedAmountValue {get;set;}
    public String loanId {get;set;}
    public String hdfcBank {get;set;}
    public string iciciBank {get;set;}
    public string axisBank {get;set;}
    public string lic {get;set;}
    public Boolean isStateBankOfIndia {get;set;}
    
    public NOCControllerCLass(ApexPages.StandardController controller){ 
        isStateBankOfIndia = false;
        currentYear = String.valueOf(Date.today().Year());
        TodayDate = String.valueOf(Date.today().Day()) + '/' + String.valueOf(Date.today().Month()) + '/' + String.valueOf(Date.today().Year());
        System.debug('TodayDate----------->'+TodayDate);
        
        hdfcBank = System.Label.HDFC;
        iciciBank = System.Label.ICICI;
        axisBank = System.Label.Axis;
        lic = System.Label.LIC;
        List<String> stateBankOfIndia = System.Label.SBI.split(',');
        
        sBookingId = ApexPages.CurrentPage().getparameters().get('id');
        loanId = ApexPages.CurrentPage().getparameters().get('loanid');
        System.debug('sBookingId------'+sBookingId);
        System.debug('loanId------'+loanId);
        booking = [select Id,Total_Received_Amount_Excluding_GST__c,Related_Opportunity__c,Project_Name__r.Name,Tower_Name__r.Name,Floor_No__c,Unit_Number__c,
                   Registration_Date__c,Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.Name,Agreement_Value__c,
                   Related_Suggested_Property__c,Related_Suggested_Property__r.Unit__r.Proposed_Area__c from Booking__c where Id =: sBookingId];
        System.debug('booking----------->'+booking);
        System.debug('Project Id-----'+booking.Project_Name__c);
        
        projectObj = [Select Id,Name,Builder_Organization__c,Builder_Organization__r.IFSC_Code__c,Builder_Organization__r.Branch_Name__c,
                      Builder_Organization__r.GST_Bank_Account_Number__c,Builder_Organization__r.Account_Name__c,Builder_Organization__r.GST_Account_Name__c,Builder_Organization__r.Name,
                      Finance_Name__c,Builder_Organization__r.City__c,Builder_Organization__r.PIN_Code__c,Builder_Organization__r.Street__c,
                      Builder_Organization__r.Bank_Name__c,Builder_Organization__r.GST_IFSC_Code__c,Builder_Organization__r.Bank_Account_Number__c,
                      Postal_Code__c,Location__c,City__c from Project__c Where Id =: booking.Project_Name__c limit 1];
        System.debug('projectObj----------->'+projectObj);
        
        
        ifscCode = projectObj.Builder_Organization__r.GST_IFSC_Code__c;
        bankName = ifscCode.substring(0, 4);
        spaces = '';
        for (Integer i=0; i<bankName.length(); i++) {
            spaces += ' ';
        }
        remainingDigits = ifscCode.substring(4);
        bankType = spaces + remainingDigits;
        System.debug('bankType----------->'+bankType);
        System.debug('loanId----------->'+loanId);
        BankLoanObj = [Select Id,Name,Sanction_Amount__c,Home_LoanInstitution__r.Name from Bank_Loan_Details__c 
                       Where Id=:loanId]; //Booking__c =: sBookingId ORDER BY CreatedDate DESC LIMIT 1];
        System.debug('BankLoanObj----------->'+BankLoanObj);
        if(stateBankOfIndia.contains(BankLoanObj.Home_LoanInstitution__r.Name)){
            isStateBankOfIndia = true;
        }
        system.debug('isStateBankOfIndia--> '+isStateBankOfIndia);
        builderOrgObj = [Select Id,Name,PIN_Code__c,Branch_Address__c,GST_Bank_Name__c,Bank_Name__c from Builder_Organisation__c Where Id =: projectObj.Builder_Organization__c limit 1];
        System.debug('builderOrgObj----------->'+builderOrgObj);
        
        //bankType = projectObj.Builder_Organization__r.GST_IFSC_Code__c.replaceAll('^\\w{4}', '    ');
        //bankType = builderOrgObj.IF SC_Code__c.replaceAll('PUNB|HDFC|ICIC|UTIB|SBIN',' ');
        
        /*sanctionedamount = BankLoanObj.Sanction_Amount__c;
		convertedSancValue = NumberTOWordConvertion.getNumberTOWordConvertion(sanctionedamount);
		System.debug(convertedSancValue);*/
        if (BankLoanObj.Sanction_Amount__c != null) {
            sanctionedamount = BankLoanObj.Sanction_Amount__c;
            convertedSancValue = NumberTOWordConvertion.getNumberTOWordConvertion(sanctionedamount);
            System.debug(convertedSancValue);
        } else {
            System.debug('Sanctioned Amount is null. Unable to convert to words.');
            
        }
        System.debug('booking------'+booking);
        System.debug('booking.Primary_Applicant__c------'+booking.Primary_Applicant__c);
        
        if (booking != null && booking.Primary_Applicant__c != null) {
            accountObject = [SELECT Id, Name, Salutation, Phone FROM Account WHERE Id = :booking.Primary_Applicant__c];
            System.debug('accountObject: ' + accountObject);
            System.debug('accountObject.Name----------->'+accountObject.Name);
            
            Coapplicant = [select id,Account__r.salutation,Booking__c,Account__r.Name from Co_Applicant__c where Booking__c  =: booking.id AND Role__c=: 'Co-Applicant'];
            System.debug('Coapplicant:'+Coapplicant);
            if(Coapplicant != null)
            {
                System.debug('Coapplicant----'+Coapplicant);
                
                for(Co_Applicant__c ca : Coapplicant)
                    
                {
                    System.debug('ca.Account__r.salutation---'+ca.Account__r.salutation);
                    if(ca.Account__r.salutation==null){
                        System.debug('ca.Account__r.salutation---'+ca.Account__r.salutation);
                        ca.Account__r.salutation='';
                    }
                    if(coapplicantNames == '' && coapplicantNames == null)
                    {
                        System.debug('coapplicantNames1---'+coapplicantNames);
                        coapplicantNames = ca.Account__r.salutation+' '+ca.Account__r.name;
                    }
                    else
                    {
                        
                        System.debug('coapplicantNames2---'+coapplicantNames);
                        coapplicantNames = coapplicantNames+ ', '+ca.Account__r.salutation+' '+ca.Account__r.name; 
                        if (coapplicantNames != null) {
                            coapplicantNames = coapplicantNames.replaceAll('null','');
                        }
                    } 
                    System.debug('Co-applicant---'+ca.Account__r.name);
                    System.debug('coapplicantNames--------------'+coapplicantNames);
                }
            }
        }
        agreementValue = booking.Agreement_Value__c;
        convertedValue = NumberTOWordConvertion.getNumberTOWordConvertion(agreementValue);
        System.debug(convertedValue);
        
        totalAmountRecValue = booking.Total_Received_Amount_Excluding_GST__c;
        convertedAmountValue = NumberTOWordConvertion.getNumberTOWordConvertion(totalAmountRecValue);
        System.debug(totalAmountRecValue);
    }
}