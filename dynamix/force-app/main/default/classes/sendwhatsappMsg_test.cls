@isTest
public class sendwhatsappMsg_test {
    
    @isTest static void emailReminderTest(){
        
        Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
        Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
     
        
        Account accountObject = new Account();
        accountObject.FirstName = 'test';
        accountObject.LastName = 'Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '455546565';
        accountObject.PersonMobilePhone = '9677784515';
        accountObject.RecordTypeId = PersonRecId;
        accountObject.PersonEmail = 'dynamix.project@gmail.com';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        insert accountObject;
        
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        insert oppoObject;
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c = 'neeraj.saini@manras.com';
        insert projectObject; 
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        //propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
        propertyObject.Floor__c= '5';
        insert propertyObject;
      
        Suggested_Property__c suggestedProperty = new Suggested_Property__c();
        suggestedProperty.Opportunity__c = oppoObject.Id;
        suggestedProperty.Unit__c = propertyObject.Id;
        suggestedProperty.Discount__c = 10;
        insert suggestedProperty;
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = accountObject.Id;
        booking.Related_Opportunity__c = oppoObject.Id;
        booking.Related_Suggested_Property__c = suggestedProperty.Id;
        booking.Project_Name__c = projectObject.Id;
        booking.Stage__c = 'Draft';
        insert booking;
        
        Price_Details__c priceDetailObject = new Price_Details__c();
        priceDetailObject.Name = 'Price Test1';
        priceDetailObject.Charge_Group__c= 'Agreement';
        priceDetailObject.GST_Type__c = 'Standard';
        priceDetailObject.Booking__c = booking.Id;
        priceDetailObject.Amount__c = 1000000;
        insert priceDetailObject;
        
        Payment__c  PaymentObj = New Payment__c();
        PaymentObj.Date__c = date.today();
        
        //PaymentObj.BankName__c = Bank.Id;
        PaymentObj.Payment_Date__c = Date.today().addDays(20);
        PaymentObj.Amount__c = 500000;
        PaymentObj.Payment_Category__c = 'Unit Cost';
        PaymentObj.Payment_Type__c = 'NEFT/ RTGS/ IMPS';
        //PaymentObj.Cheque_Status__c = 'Cleared';
        PaymentObj.Cheque_Transaction_Number__c = 'Cheque No';
        PaymentObj.Booking__c = booking.id;
        PaymentObj.Branch_Name__c = 'Mohali';
        PaymentObj.Paid_By__c = 'Self';
        insert PaymentObj;
        
        Co_Applicant__c COAPP = New Co_Applicant__c();
        COAPP.Role__c = 'Co-Applicant';
        COAPP.Account__c = accountObject.Id;
        COAPP.Booking__c = booking.Id;
        Insert COAPP;
        
         //List<EmailTemplate> emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate];
        List<communicat_o__Registered_Template__mdt> empList = [select id from communicat_o__Registered_Template__mdt where masterlabel = 'Whatsapp Possession'];
        
        
        Test.startTest();
        SendWhatsappMsg.sendwhsms(empList[0].id,booking.id,null);
        SendWhatsappMsg.sendwhsmsForPayment(empList[0].id,null,PaymentObj.id);
        Test.stopTest();
        
    }

}