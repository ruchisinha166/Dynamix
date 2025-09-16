public class ChangeNoteController{
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
    public List<Co_Applicant__c> listCoApp {get;set;}
    public Map<Integer,String> MapOfdisplyNumber{get;set;}
    
    public ChangeNoteController(ApexPages.StandardController controller){
        
        MapOfdisplyNumber= new Map<Integer,String>();
        MapOfdisplyNumber.put(1,'First');
        MapOfdisplyNumber.put(2,'Seco nd');
        MapOfdisplyNumber.put(3,'Third');
        MapOfdisplyNumber.put(4,'Fourth');
        MapOfdisplyNumber.put(5,'Fifth');
        MapOfdisplyNumber.put(6,'Sixth');
        MapOfdisplyNumber.put(7,'Seventh');
        MapOfdisplyNumber.put(8,'Eightth');
        MapOfdisplyNumber.put(9,'Ninth');
        MapOfdisplyNumber.put(10,'Tenth');
                
        String sBookingId = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('sBookingId======='+sBookingId);
        booking = [select Id,Tower_Name__c,OwnerId,Owner.Name,Tower_Name__r.Name,Tower_Name__r.Building_Type__c,Tower_Name__r.Tower_Initials__c,Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.Name,Related_Suggested_Property__c,Agreement_Value__c,Booking_Date__c from Booking__c where Id =: sBookingId];
        system.debug('booking======='+booking);
        if(booking != null){
            accountObject = [select Id,PersonMobilePhone,PAN_No__pc,PAN_No__c,Aadhar_No__pc,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode,PersonMailingCountry,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Phone from Account where Id =: booking.Primary_Applicant__c ];
        }
       listCoApp = [select id,Account__c,Account__r.Relation__c,Account__r.PersonMobilePhone,Account__r.PAN_No__c,Account__r.Aadhar_No__pc,Account__r.PersonMailingStreet,Account__r.PersonMailingCity,Account__r.PersonMailingPostalCode,Account__r.PersonMailingCountry from Co_Applicant__c where Booking__c =: booking.id and Role__c = 'Co-Applicant'];
        
        /*for(Co_Applicant__c coapp : listCoApp)
        {
            accids(coapp.Account__c);
            
        }*/
        //List<CoappaccountObject> = [select Id,PersonMobilePhone,PAN_No__pc,PAN_No__c,Aadhar_No__pc,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode,PersonMailingCountry,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Phone from Account where Id IN: accids ];
         
        
        if(booking != null){
            property = [select Id,Unit__c from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
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
        }
        
}