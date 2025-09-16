public class FileTransferNoteController {
    
    public Account accountObject{get;set;}
    public List<Payment__c> paymentList{get;set;}
    public Payment__c payment{get;set;}
    public Booking__c booking{get;set;}
    public Property__c properties{get;set;}
    public Project__c project{get;set;}
    public List<Suggested_Property__c> property{get;set;}
    public boolean dateValue {get;set;}
    public boolean address {get;set;}
    public boolean phone {get;set;}
    public User PostSalesUser {get;set;}
    public User SalesUser{get;set;}
    public Decimal FlatTotalAmount{get;set;}
    public Decimal GSTAmount{get;set;}
    public Decimal StampDutyAmount{get;set;}
    
    public FileTransferNoteController(ApexPages.StandardController controller){
        
        FlatTotalAmount = 0;
        GSTAmount = 0;
        StampDutyAmount = 0;
        
        
        String sBookingId = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('sBookingId======='+sBookingId);
        booking = [select Id,Tower_Name__c,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Tower_Name__r.Tower_Initials__c,Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.Name,Related_Suggested_Property__c,Agreement_Value__c,Booking_Date__c,Sales_Manager__r.Name, GST__c from Booking__c where Id =: sBookingId];
        system.debug('booking======='+booking);
        if(booking != null){
            accountObject = [select Id,PersonMobilePhone,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode,PersonMailingCountry,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Phone from Account where Id =: booking.Primary_Applicant__c ];
        }
        if(accountObject.BillingCountry != null)
        {
            address = true;
        }
        else
        {
            address = false;
        }
        if(accountObject.Phone != null)
        {
            phone = true;
        }
        else
        {
            phone = false;
        }
        if(booking != null){
            property = [select Id,Unit__c,Payment_Plan__r.Name from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
            system.debug('property======='+property);
        }
        if(property.size() > 0){
            for(Suggested_Property__c prop :property){
                properties = [select Id,Name,Floor__c,RERA_Carpet_Area__c,Flower_Bed_Area__c,Deck_Carpet_Area__c from Property__c where Id =: prop.Unit__c];
                system.debug('properties==='+properties); 
            }
        }
        if(booking.Project_Name__c != null){
            project = [select Id,Name,Project_Email__c from Project__c where Id =: booking.Project_Name__c];
            system.debug('project==='+project); 
        }
        if(booking != null){
            paymentList = [select Id,Name,Amount__c,BankName__c,Booking__c,Branch_Name__c,Cheque_Transaction_Number__c,Payment_Type__c,Payment_Status__c,Payment_Description__c,
                           Payment_Date__c,Payment_Category__c,Date__c,Receipt_No__c from Payment__c where Booking__c =: booking.Id];
                      
            for(Payment__c TPayment : paymentList){
                
                if(TPayment.Payment_Category__c == 'Unit Cost')
                {
                    FlatTotalAmount = FlatTotalAmount + TPayment.Amount__c;
                    System.debug('FlatAmount Amount-->'+FlatTotalAmount);
                    
                }
                
                if(TPayment.Payment_Category__c == 'GST')
                {
                    GSTAmount = GSTAmount + TPayment.Amount__c;
                    System.debug('GSTAmount Amount-->'+GSTAmount);
                }
                if(TPayment.Payment_Category__c == 'Stamp Duty'){
                    
                    StampDutyAmount = StampDutyAmount + TPayment.Amount__c;
                    System.debug('Stamp Amount-->'+StampDutyAmount);
                } 
            }
            
            for(Payment__c paymnt:paymentList){
                payment  = paymnt;
               
                if(paymnt.Cheque_Transaction_Number__c != null && payment.Payment_Type__c == 'Cheque'){
                    dateValue = true;
                    
                } 
                else{
                    dateValue =false;
                    
                }
            }
            system.debug('payment==='+payment); 
            
        }  
        
        List<Profile> PostSalesProfie =  [select Id, Name from Profile where name ='Post Sales' Limit 1];
        if(PostSalesProfie.size() > 0)
        {
           // PostSalesUser = [select id,name from User where profile.id =: PostSalesProfie.get(0).id];
        }
        
        List<Profile> SalesProfie =  [select Id, Name from Profile where name ='Sales' Limit 1];
        if(SalesProfie.size() > 0)
        {
            //SalesUser = [select id,name from User where profile.id =: SalesProfie.get(0).id];
        }
    }
    
    
}