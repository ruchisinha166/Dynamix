@isTest
public class SendEmailWithTDStoCustomerTest {
    @isTest
    static void testSendEmail(){
        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Send_TDS_Receipt_to_Customer' LIMIT 1];
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '4555465655';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.PersonMobilePhone = '4568214569';
            accountObject.PAN_No__pc = 'ABCTY1234D';
            accountObject.PersonMailingCity = 'Zirakpur';
            accountObject.PersonMailingState = 'Punjab';
            accountObject.PersonMailingCountry = 'India';
            accountObject.PersonMailingStreet = 'Test Street';
            accountObject.PersonMailingPostalCode = '140603';
            accountObject.NRI__c = True;
            insert accountObject;
        
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'nishi@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            insert projectObject;
            
            Opportunity oppoObject = new Opportunity();
            oppoObject.AccountId = accountObject.Id;
            oppoObject.Name = 'test Opportunity';
            oppoObject.StageName = 'Site Visit';
            oppoObject.CloseDate = System.Today()+3;
            oppoObject.Project__c = projectObject.Id;
            oppoObject.Walk_in_Source__c = 'Direct';
            insert oppoObject;
            
            Pricing_Plan__c pricingPlanObject = new Pricing_Plan__c();
            pricingPlanObject.Name = 'Pricing Plan Test';
            pricingPlanObject.Project__c = projectObject.Id;
            insert pricingPlanObject;
            
            Property__c propertyObject = new Property__c();
            propertyObject.Name = 'test property';
            propertyObject.Project__c = projectObject.Id;
            propertyObject.Property_Price_Slab__c = pricingPlanObject.Id;
            propertyObject.Floor__c= '5';
            insert propertyObject;
            
            Suggested_Property__c suggestedProperty = new Suggested_Property__c();
            suggestedProperty.Opportunity__c = oppoObject.Id;
            suggestedProperty.Unit__c = propertyObject.Id;
            suggestedProperty.Discount__c = 10;
            insert suggestedProperty;
            
            SDR_Agent__c SDRAgent = new SDR_Agent__c();
            SDRAgent.Account_Name__c = accountObject.ID;
            SDRAgent.Project__c = projectObject.ID;
            insert SDRAgent;
        
            Booking__c booking = new Booking__c();
            booking.Primary_Applicant__c = accountObject.Id;
            booking.Related_Opportunity__c = oppoObject.Id;
            booking.Related_Suggested_Property__c = suggestedProperty.Id;
            booking.Project_Name__c = projectObject.Id;
            booking.Primary_Secondary_info_Updated__c = false;
            booking.Shared_SDR_Letter__c = false;
            booking.Date_of_First_Disbursement__c = Date.today();
            booking.Amount_of_First_Disbursement__c = 43;
            booking.Cancellation_Approval_Status__c = 'Approved';
            booking.Booking_Cancellation__c = false;
            booking.Welcome_Email_Checker__c = false;
            booking.Cancellation_Checkbox__c = false;
            booking.Cancellation_Requested_Status__c = 'Cancellation Confirmed';
            booking.Cancellation_Approval_Status__c = 'Submitted';
            booking.Source_of_Finance__c = 'Self Funded';
            insert booking;
        Payment__c pay = new Payment__c();
        //pay.Project_Name__c = 'Test';
        pay.Booking__c = booking.ID;
        pay.Payment_Category__c = 'TDS';
        pay.Payment_Status__c = 'Approved';
        pay.Receipt_No__c = '1234';
        insert pay;
        
            Attachment attach1=new Attachment();    
            attach1.Name='1234';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach1.body=bodyBlob;
            attach1.parentId=booking.id;
            insert attach1;
            
            Attachment attach =[select id, name,OwnerId,Body,ParentId from Attachment where parent.id=:booking.id];
            
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; 
            cVersion.PathOnClient = attach.Name;
            cVersion.Origin = 'H';
            cVersion.OwnerId = attach.OwnerId;
            cVersion.Title = '1234';
            cVersion.VersionData = attach.Body;
            //cVersion.Document_Type__c = 'Payment Receipt';
            //cVersion.SObjectType__c = 'Booking__c';
            cVersion.BookingId__c = booking.Id;
            Insert cVersion;
            cVersion.Document_Type__c = 'Payment Receipt';
            cVersion.SObjectType__c = 'Booking__c';
            update cVersion;
            //cVersion.Origin ='D';
            //update cVersion;
    }
}