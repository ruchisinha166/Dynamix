public class PaymentReceiptController{
    public Account accountObject{get;set;}
    public List<Payment__c> paymentList{get;set;}
    public List<ContentDocumentLink> contentDoc {get;set;}
    public List<Co_Applicant__c> coApplicantList{get;set;}
    public Payment__c payment{get;set;}
    public Booking__c booking{get;set;}
    public Property__c properties{get;set;}
    public Project__c project{get;set;}
    public List<Suggested_Property__c> property{get;set;}
    public boolean dateValue {get;set;}
    public Payment__c pay{get;set;}
    public List<ContentVersion> contentVersionList;
    public ContentVersion contentVerObject{get;set;}
    public Id conVersionObject{get;set;}
    public string ammountInWords{get;set;}
    public List<ContentDocumentLink> contentDocHeaderNfooter {get;set;}
    public List<ContentVersion> contentVerObjectHeaderNfooter{get;set;}
    Public id ProjectHeader{get;set;}
    Public id ProjectFooter{get;set;}
    public string coapplicantNames{get;set;}
    
    public PaymentReceiptController(ApexPages.StandardController controller){
        
        String PaymentId = ApexPages.CurrentPage().getparameters().get('id');
       // String PaymentId  ='a0KC4000002LicoMAC';
        //conVersionObject=null;
        pay = [select id,Booking__c,Receipt_No_Hidden__c,Date__c,BankName__c,BankName__r.Name,Payment_Date__c,Amount__c,Payment_Type__c,Branch_Name__c,Payment_Category__c,Receipt_No__c,Cheque_Transaction_Number__c from Payment__c where id = :PaymentId];
        coApplicantList = [select id, Account__r.name from Co_Applicant__c where (Booking__c=: pay.Booking__c AND Role__c=: 'Co-Applicant')];
        coapplicantNames = '';
        for(Co_Applicant__c cp : coApplicantList){if(coapplicantNames == '')
            { coapplicantNames = ','+cp.Account__r.name;}
            else{coapplicantNames = coapplicantNames+','+cp.Account__r.name; } 
        }
        
        contentDoc = [select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId =: PaymentId];
        system.debug(contentDoc);
        contentVersionList = new List<contentVersion>();
        for(Integer i=0; i<contentDoc.size(); i++){contentVerObject = [SELECT VersionData,Document_Type__c,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId = : contentDoc[i].ContentDocumentId]; 
            contentVersionList.add(contentVerObject);
            system.debug('contentVerObject:'+ contentVerObject);
        }
        system.debug('contentVersionList: ' + contentVersionList);
        
        if(contentVersionList.size()> 0)
        {for(Integer i=0; i<contentVersionList.size(); i++){conVersionObject  = contentVersionList[i].Id;}
        }
        System.debug('conVersionObject:'+conVersionObject);
        
        booking = [select Id,Tower_Name__c,Agreement_Value__c,Total_consolidated_amount__c,Tower_Name__r.Name,Tower_Name__r.Tower_Initials__c,Tower_Name__r.Building_Type__c,Project_Name__c,Primary_Applicant__c,Primary_Applicant__r.Name,Related_Suggested_Property__c from Booking__c where Id =: pay.Booking__c];
        ammountInWords = NumberTOWordConvertion.getNumberTOWordConvertion(pay.Amount__c);
        
        if(booking != null){
            accountObject = [select Id,PersonMobilePhone,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode from Account where Id =: booking.Primary_Applicant__c ];
        }
        if(booking != null){
            property = [select Id,Unit__c from Suggested_Property__c where Id =: booking.Related_Suggested_Property__c];
            system.debug('property======='+property);
        }
        if(property.size() > 0){
            for(Suggested_Property__c prop :property){
                properties = [select Id,Name,Floor__c from Property__c where Id =: prop.Unit__c];
                system.debug('properties==='+properties); 
            }
        }
        if(booking.Project_Name__c != null){
            project = [select Id,Name,Builder_Organization__r.Name,Possession_Other_Charges_Narration__c,Security_and_Share_Money_Narration__c from Project__c where Id =: booking.Project_Name__c];
            system.debug('project==='+project); 
        }
        
        if(booking.Project_Name__c <> null)
        {
            contentDocHeaderNfooter = [select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId =: booking.Project_Name__c];
            system.debug('contentDocHeaderNfooter'+contentDocHeaderNfooter);
            
            if(contentDocHeaderNfooter <> null)
            {
                List<id> ContentVersionIds = new List<id>();
                for(ContentDocumentLink cdl :contentDocHeaderNfooter){ContentVersionIds.add(cdl.ContentDocumentId);}
                if(ContentVersionIds <> null)
                {
                    contentVerObjectHeaderNfooter = [SELECT VersionData,Document_Type__c,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId In: ContentVersionIds];
                    system.debug('contentDocHeaderNfooter'+contentVerObjectHeaderNfooter);
                    for(ContentVersion cv : contentVerObjectHeaderNfooter){
                        if(cv.Document_Type__c == 'Project Header'){ProjectHeader = cv.Id;}
                        if(cv.Document_Type__c == 'Project Footer'){ProjectFooter = cv.Id;}
                    }
                }
            }
        } 
    }
}