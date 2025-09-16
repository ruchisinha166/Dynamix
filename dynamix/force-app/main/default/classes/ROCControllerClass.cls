public class ROCControllerClass{
    public string recordId {get;set;}
    public Booking__c bookObj {get;set;}
    public Property__c proObj {get;set;} 
    public Suggested_Property__c suggObj {get;set;}
    public Project__c projectObj {get;set;}
    public Opportunity oppoObj {get;set;}
    public Builder_Organisation__c builderOrgObj {get;set;}
    public Bank_Loan_Details__c	BankLoanObj {get;set;}
    public Account primaryAppliObj {get;set;}
    public String TodayDate {get;set;}
    
    public ROCControllerClass(ApexPages.StandardController stdController) {
        recordId=ApexPages.currentPage().getParameters().get('id');
        loadDataInVfPage(recordId);  
    }
    public void loadDataInVfPage(Id recordId){
        
        try{
            bookObj = new Booking__c();
            TodayDate = String.valueOf(Date.today().Day()) + '/' + String.valueOf(Date.today().Month()) + '/' + String.valueOf(Date.today().Year());
            bookObj = [Select Id,Name,Primary_Applicant__c,Primary_Applicant_Name_Formulla__c,Tower_Name__r.Name,Loan_Sanction_Amount__c,Registration_Charges__c,Related_Suggested_Property__c,Related_Opportunity__c,Unit_Number__c,Agreement_Value__c,Project_Name__c,Stamp_Duty__c From Booking__c where Id =: recordId];
            projectObj = [Select Id,Name,Builder_Organization__c,Funding_Partner_Name__c,Sublocation__c,State__c,Postal_Code__c,Location__c,City__c from Project__c Where Id =: bookObj.Project_Name__c limit 1];
            oppoObj = [Select Id,name,Unit_Type__c From Opportunity Where Id =:bookObj.Related_Opportunity__c limit 1];
            suggObj = [Select Id,name,Unit__c From Suggested_Property__c Where Id =:bookObj.Related_Suggested_Property__c limit 1];
            proObj = [Select Id,name,Floor__c,RERA_Carpet_Area_in_sqmtr__c From Property__c Where Id =:suggObj.Unit__c limit 1];
            BankLoanObj = [Select Id,Name,Home_LoanInstitution__r.Name from Bank_Loan_Details__c Where Booking__c =: bookObj.Id limit 1];
            builderOrgObj = [Select Id,Name from Builder_Organisation__c Where Id =: projectObj.Builder_Organization__c limit 1];
            primaryAppliObj = [Select Id,Name,PersonMailingCity,PersonMailingPostalCode,PersonMailingState,PersonMailingStreet,PersonMailingCountry,PersonMobilePhone From Account Where Id =: bookObj.Primary_Applicant__c];

        }catch(Exception e){
            System.debug('Error :'+e);
        }
    }
}