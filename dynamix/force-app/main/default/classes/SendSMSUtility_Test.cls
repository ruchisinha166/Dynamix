@isTest
public class SendSMSUtility_Test{
    @isTest  
    public static void testMethod1(){
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        system.runAs(testUserRcd1){           
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.PersonMobilePhone = '1234567890';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            insert accountObject;
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'test@manras.com';
            projectObject.Site_Head__c = testUserRcd1.Id;
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='3 BHK';
            insert projectObject;
            
            Opportunity oppoObject = new Opportunity();
            oppoObject.AccountId = accountObject.Id;
            oppoObject.Name = 'test Opportunity';
            oppoObject.StageName = 'Site Visit';
            oppoObject.CloseDate = System.Today()+3;
            oppoObject.Booking_Form_Submitted_by_Customer_Date__c = System.now().addHours(-24);
            oppoObject.KYC_Completed__c = false;
            oppoObject.Is_Booking_Form_Submitted_by_Customer__c = true;
            oppoObject.KYC_Completed__c = true;
            oppoObject.Stamp_Duty_Payable_By__c = 'Dynamix';
            oppoObject.Project__c = projectObject.Id;
            oppoObject.Walk_in_Source__c = 'Hoarding';
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
            
            Booking__c booking = new Booking__c();
            booking.Primary_Applicant__c = accountObject.Id;
            booking.Related_Opportunity__c = oppoObject.Id;
            booking.Related_Suggested_Property__c = suggestedProperty.Id;
            booking.Project_Name__c = projectObject.Id;
            booking.OwnerId = testUserRcd1.Id;
            insert booking;
            //  Test.startTest();
            Booking__c getBookingRcd=[Select Id,Name,Primary_Applicant_Name_Formulla__c From Booking__c Where Id=:booking.Id];
            
            EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Booking Form Link Sent' Limit 1];
            String templateBody=smsEmailTemp.HtmlValue;
            String mobileNumber=booking.Primary_Applicant__r.PersonMobilePhone;
            templateBody = templateBody.replace('{{{Booking__c.Primary_Applicant_Name_Formulla__c}}}',getBookingRcd.Primary_Applicant_Name_Formulla__c);
            templateBody = templateBody.replace('{{{Booking__c.Name}}}',getBookingRcd.Name);
            templateBody=templateBody.stripHtmlTags();
            
            Test.setMock(HttpCalloutMock.class, new SendSMSMock());  
            SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYMXGP'); 
            SendSMSUtility.sendSMSMethod( templateBody,mobileNumber,'DYMXGP',  'Test1234');
            Map<String,String> templateBodyMap = New Map<String,String> ();
            templateBodyMap.put(booking.Primary_Applicant__r.PersonMobilePhone,templateBody);
            SendSMSUtility.sendBulkSMSMethod(templateBodyMap,new List<string>{booking.Primary_Applicant__r.PersonMobilePhone},'DYMXGP',  'Test1234');
        }   
    }
}