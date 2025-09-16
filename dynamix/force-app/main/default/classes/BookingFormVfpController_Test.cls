@isTest
public class BookingFormVfpController_Test {
    
    static testMethod void bookingFormControllertestMethod1(){    
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName1 = 'standarduser2' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur';
        testUserRcd1.LastName = 'Patel';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName1;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        testUserRcd1.Country='India';
        insert testUserRcd1;
        String personAccRcdTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account testAccRcd1 = new Account();
        testAccRcd1.Salutation='Mr.';
        testAccRcd1.FirstName='Test FName';
        testAccRcd1.LastName='Test LName';
        testAccRcd1.BillingCountry = 'India';
        testAccRcd1.PersonMobilePhone = '1234567890';
        testAccRcd1.RecordTypeId=personAccRcdTypeId;         
        testAccRcd1.Country__c='India';
        testAccRcd1.Organisation_Country__c='India';
        testAccRcd1.Permanent_Address__c='test address';
        testAccRcd1.Post_Code__c='396430';
        testAccRcd1.State__c='Gujarat';
        testAccRcd1.PersonMailingStreet='Jay Hind Street';
        testAccRcd1.PersonBirthdate=System.today();
        testAccRcd1.Nationality__c='Indian';
        testAccRcd1.Address_Proof__c='Pan Card';
        testAccRcd1.PersonMobilePhone='1234567890';
        testAccRcd1.PersonEmail='abc@outlook.com';
        testAccRcd1.Preferred_Address_for_all_Corresppondenc__c='Permanent';
        
        insert testAccRcd1;
        
        Account testAccRcd2 = new Account();
        testAccRcd2.Salutation='Ms.';
        testAccRcd2.FirstName='Test FName1';
        testAccRcd2.LastName='Test LName1';
        testAccRcd2.BillingCountry = 'India';
        testAccRcd2.PersonMobilePhone = '6568766876';
        testAccRcd2.RecordTypeId=personAccRcdTypeId;  
        testAccRcd2.Country__c='India';
        testAccRcd2.Organisation_Country__c='India';
        insert testAccRcd2;
        
        Project__c testProjectRcd = new Project__c();
        testProjectRcd.Name = 'Test Project';
        testProjectRcd.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        testProjectRcd.Budgets__c = 'Under 75 lakhs';
        testProjectRcd.Configuration__c ='3 BHK';
        testProjectRcd.Project_Email__c = 'parkwoods@dynamixgroup.co.in';
        insert testProjectRcd;
        
        Opportunity testOppRcd = new Opportunity();
        testOppRcd.AccountId = testAccRcd1.Id;
        testOppRcd.Name = 'Test Opportunity';
        testOppRcd.StageName = 'Site Visit';
        testOppRcd.CloseDate = System.Today()+3;
        testOppRcd.Nature_of_Purchase__c='Self Use';
        testOppRcd.Is_Booking_Form_Submitted_by_Customer__c=true;
        testOppRcd.KYC_Completed__c = true;
        testOppRcd.Stamp_Duty_Payable_By__c = 'Dynamix';
        testOppRcd.EOI_Booking__c='Yes';
        testOppRcd.EOI_Date__c=System.today();
        testOppRcd.EOI_Amount__c=5000;
        testOppRcd.Project__c = testProjectRcd.Id;
        insert testOppRcd;
        
        Booking_Offer__c testBookingOfferRcd=new Booking_Offer__c();
        testBookingOfferRcd.Start_Date__c=System.today()-3;
        testBookingOfferRcd.End_Date__c=System.today()+3;
        testBookingOfferRcd.Project__c=testProjectRcd.Id;
        testBookingOfferRcd.Approval_Status__c='Rejected';
        //testBookingOfferRcd.Active__c=true;
        insert testBookingOfferRcd;
        
        Pricing_Plan__c testPricingPlanRcd = new Pricing_Plan__c();
        testPricingPlanRcd.Name = 'Pricing Plan Test';
        testPricingPlanRcd.Project__c = testProjectRcd.Id;
        insert testPricingPlanRcd;
        
        Property__c testPropertyRcd = new Property__c();
        testPropertyRcd.Name = 'test property';
        testPropertyRcd.Project__c = testProjectRcd.Id;
        testPropertyRcd.Property_Price_Slab__c = testPricingPlanRcd.Id;
        testPropertyRcd.Floor__c= '5';
        insert testPropertyRcd;
        
        Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
        testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
        testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
        testSuggPropertyRcd.Discount__c = 10;
        insert testSuggPropertyRcd;      
        test.startTest();
        
        
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd1.Id;
        testBookingRcd.Prior_Primary_Applicant__c = testAccRcd1.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        insert testBookingRcd;
        
        Payment__c testPaymentRcd=new Payment__c();
        testPaymentRcd.Booking__c=testBookingRcd.Id;
        testPaymentRcd.Cheque_Transaction_Number__c='12345';
        testPaymentRcd.Amount__c=50000;
        testPaymentRcd.Payment_Date__c=System.today();
        testPaymentRcd.Bank_Name__c='ICICI';
        //insert testPaymentRcd;
        
        Co_Applicant__c testCoAppRcd1=new Co_Applicant__c();
        testCoAppRcd1.Account__c=String.valueOf(testAccRcd2.Id) ;
        testCoAppRcd1.Booking__c=testBookingRcd.Id;
        //insert testCoAppRcd1;
        
        Offer__c testOffer=new Offer__c();
        testOffer.Booking__c=testBookingRcd.Id;
        testOffer.Project_Offer__c=testBookingOfferRcd.Id;      
        insert testOffer;
        
        List<ContentDocumentLink> Aadharcdlist = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink];
        
        if (Aadharcdlist != null && Aadharcdlist.size() > 0) {
            for (ContentDocumentLink link : Aadharcdlist) {
            }
        } else {
            System.debug('No ContentDocumentLink records found.');
        }
        
        List<Attachment> attach =[select id, name,OwnerId,Body,ParentId from Attachment where parent.id=:testBookingRcd.id];
        if (attach != null ) {
            for (Attachment att : attach) {
                
                ContentVersion cVersion = new ContentVersion();
                cVersion.ContentLocation = 'S'; 
                cVersion.PathOnClient = att.Name;
                cVersion.Origin = 'H';
                cVersion.OwnerId = att.OwnerId;
                cVersion.Title = att.Name;
                cVersion.VersionData = att.Body;
                cVersion.Document_Type__c = 'SDR Challan Copy';
                cVersion.SObjectType__c = 'Booking__c';
                cVersion.BookingId__c = testBookingRcd.Id;
                Insert cVersion;
            }
        } else {
            System.debug('No ContentDocumentLink records found.');
        }
        
        
        
        
        
        pagereference testPage = page.bookingform; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(testBookingRcd.Id));       
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(testBookingRcd);   
        BookingFormVfpController ext = new BookingFormVfpController(sc);  
        
        //ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id =: cvlst LIMIT 1];
        ext.selectedPrimaryAccNationality='Indian';
        ext.selectedEOIBooking='Yes';
        ext.primaryAccPanCardFile=Blob.valueOf('Test primaryAccPanCardFile'); 
        ext.primaryAccPanCardFileName='primaryAccPanCardFileName';
        ext.primaryAccAadharCardFile=Blob.valueOf('Test primaryAccAadharCardFile'); 
        ext.primaryAccAadharCardFileName='primaryAccAadharCardFileName';
        
        ext.selectedSecondAccNationality='Indian';
        ext.secondAccountLastName='Test LName1';
        ext.secondAccPanCardFile=Blob.valueOf('Test secondAccPanCardFile'); 
        ext.secondAccPanCardFileName='secondAccPanCardFileName';
        ext.secondAccAadharCardFile=Blob.valueOf('Test secondAccAadharCardFile'); 
        ext.secondAccAadharCardFileName='secondAccAadharCardFileName';        
        ext.isAgreeWithTermsConditions=true;
        ext.submittedBy='customer';
        
        
        ext.getprimaryAccountSalutationOption();
        ext.getsecondAccountSalutationOption();
        ext.getthirdAccountSalutationOption();
        ext.getprojectOfferNames(); 
        ext.getselPurchasePurposeOption();     
        ext.getselectedPrimaryAccPermAddCountryOptions();     
        ext.getselectedPrimaryAccPermAddStateOptions();     
        ext.onChangePrimaryAccCountry();
        ext.getselectedSecondAccPermAddCountryOptions();
        ext.getselectedSecondAccPermAddStateOptions();
        ext.onChangeSecondAccCountry();
        ext.getselectedPrimaryAccOrgOfficeAddCountryOptions();
        ext.getselectedPrimaryAccOrgOfficeAddStateOptions();
        ext.onChangePrimaryAccOrgOfficeCountry();
        ext.getselectedSecondAccOrgOfficeAddCountryOptions();
        ext.getselectedSecondAccOrgOfficeAddStateOptions();
        ext.onChangeSecondAccOrgOfficeCountry();
        ext.getselectedPrimaryAccPreffAddOption();
        ext.getselectedPrimaryAccNationalityOptions();
        ext.getselectedPrimaryAccOccupationOptions();
        ext.getresidentialLevelOptions();
        ext.getbookingSourceOptions();
        ext.geteoiBookingOptions();
        ext.getselectedPropertyTypeOptions();
        ext.onChangeCheckboxValue();
        ext.onChangePurchasePurpose();
        ext.onChangePrimaryAccNationality();
        ext.onChangeSecondAccNationality();
        ext.onChangeEoiBooking();
        
        ext.sendOtpM();
        ext.verifyOtp();
        ext.submitBookingForm();
        Test.stopTest();
    }
    
    
    
    //for cover second account insert code
    
    static testMethod void bookingFormControllertestMethod3(){   
        
        String personAccRcdTypeId1  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account testAccRcd3 = new Account();
        testAccRcd3.Salutation='Mr.';
        testAccRcd3.FirstName='Test FName3';
        testAccRcd3.LastName='Test LName3';
        testAccRcd3.BillingCountry = 'India';
        testAccRcd3.PersonMobilePhone = '1234567890';
        testAccRcd3.RecordTypeId=personAccRcdTypeId1;         
        testAccRcd3.Country__c='India';
        testAccRcd3.Organisation_Country__c='India';
        testAccRcd3.Permanent_Address__c='test address';
        testAccRcd3.Post_Code__c='396430';
        testAccRcd3.State__c='Gujarat';
        testAccRcd3.PersonMailingStreet='Jay Hind Street';
        testAccRcd3.PersonBirthdate=System.today();
        testAccRcd3.Nationality__c='Indian';
        testAccRcd3.Address_Proof__c='Pan Card';
        testAccRcd3.PersonMobilePhone='1234567890';
        testAccRcd3.PersonEmail='abc@outlook.com';
        testAccRcd3.Preferred_Address_for_all_Corresppondenc__c='Permanent';
        
        insert testAccRcd3;
        
        
        Project__c testProjectRcd2 = new Project__c();
        testProjectRcd2.Name = 'Test Project 2';
        testProjectRcd2.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        testProjectRcd2.Budgets__c = 'Under 75 lakhs';
        testProjectRcd2.Configuration__c ='3 BHK';
        testProjectRcd2.Project_Email__c = 'parkwoods@dynamixgroup.co.in';
        insert testProjectRcd2;
        
        Opportunity testOppRcd3 = new Opportunity();
        testOppRcd3.AccountId = testAccRcd3.Id;
        testOppRcd3.Name = 'Test Opportunity 3';
        testOppRcd3.StageName = 'Site Visit';
        testOppRcd3.CloseDate = System.Today()+3;
        testOppRcd3.Nature_of_Purchase__c='Investment';
        testOppRcd3.Is_Booking_Form_Submitted_by_Customer__c=true;
        testOppRcd3.KYC_Completed__c = true;
        testOppRcd3.Stamp_Duty_Payable_By__c = 'Dynamix';
        testOppRcd3.EOI_Booking__c='No';
        testOppRcd3.Project__c = testProjectRcd2.Id;
        insert testOppRcd3;
        
        
        Pricing_Plan__c testPricingPlanRcd2 = new Pricing_Plan__c();
        testPricingPlanRcd2.Name = 'Pricing Plan Test 2';
        testPricingPlanRcd2.Project__c = testProjectRcd2.Id;
        insert testPricingPlanRcd2;
        
        Property__c testPropertyRcd2 = new Property__c();
        testPropertyRcd2.Name = 'test property 2';
        testPropertyRcd2.Project__c = testProjectRcd2.Id;
        testPropertyRcd2.Property_Price_Slab__c = testPricingPlanRcd2.Id;
        testPropertyRcd2.Floor__c= '15';
        insert testPropertyRcd2;
        
        Suggested_Property__c testSuggPropertyRcd2 = new Suggested_Property__c();
        testSuggPropertyRcd2.Opportunity__c = testOppRcd3.Id;
        testSuggPropertyRcd2.Unit__c = testPropertyRcd2.Id;
        testSuggPropertyRcd2.Discount__c = 15;
        insert testSuggPropertyRcd2;      
        
        
        Booking__c testBookingRcd3 = new Booking__c();
        testBookingRcd3.Primary_Applicant__c = testAccRcd3.Id;
        testBookingRcd3.Related_Opportunity__c = testOppRcd3.Id;
        testBookingRcd3.Related_Suggested_Property__c = testSuggPropertyRcd2.Id;
        testBookingRcd3.Project_Name__c = testProjectRcd2.Id;
        testBookingRcd3.Sub_Booking_Offer__c='Test 123';
        testBookingRcd3.Booking_Form_OTP__c='12345';
        insert testBookingRcd3;
        
        Payment__c testPaymentRcd2=new Payment__c();
        testPaymentRcd2.Booking__c=testBookingRcd3.Id;
        testPaymentRcd2.Cheque_Transaction_Number__c='12345';
        testPaymentRcd2.Amount__c=25000;
        testPaymentRcd2.Payment_Date__c=System.today();
        testPaymentRcd2.Bank_Name__c='ICICI';
        // insert testPaymentRcd2;       
        
        Test.startTest();        
        pagereference testPage2 = page.bookingform; 
        Test.setCurrentPage(testPage2);
        testPage2.getParameters().put('Id', String.valueOf(testBookingRcd3.Id));              
        ApexPages.StandardController sc1 = new  ApexPages.StandardController(testBookingRcd3);   
        BookingFormVfpController ext1 = new BookingFormVfpController(sc1);  
        
        
        ext1.selectedEOIBooking='NO';
        ext1.thirdAccountLastName='Patel333';
        ext1.thirdAccountFirstName='Test333';
        ext1.thirdAccountPhoneNumber='1234567234';
        ext1.onChangePurchasePurpose();
        ext1.selectedPurchasePurpose='Company/Partnership';
        ext1.isAgreeWithTermsConditions=true;
        ext1.submittedBy='customer';
        
        ext1.sendOtpM();
        ext1.verifyOtp();
        ext1.thirdAccountRecord=null;
        try{
            ext1.submitBookingForm();
        }
        catch(Exception e){
            
        }
        Test.stopTest();
    }
    static testMethod void bookingFormControllertestMethod4(){       
        String personAccRcdTypeId1  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName1 = 'standarduser1' + DateTime.now().getTime() + '@testorg.com';
        
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur';
        testUserRcd1.LastName = 'Patel';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName1;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        testUserRcd1.Country='India';
        insert testUserRcd1;
        
        Account testAccRcd3 = new Account();
        testAccRcd3.Salutation='Mr.';
        testAccRcd3.FirstName='Test FName3';
        testAccRcd3.LastName='Test LName3';
        testAccRcd3.BillingCountry = 'India';
        testAccRcd3.PersonMobilePhone = '1234567890';
        testAccRcd3.RecordTypeId=personAccRcdTypeId1;         
        testAccRcd3.Country__c='India';
        testAccRcd3.Organisation_Country__c='India';
        testAccRcd3.Permanent_Address__c='test address';
        testAccRcd3.Post_Code__c='396430';
        testAccRcd3.State__c='Gujarat';
        testAccRcd3.PersonMailingStreet='Jay Hind Street';
        testAccRcd3.PersonBirthdate=System.today();
        testAccRcd3.Nationality__c='Indian';
        testAccRcd3.Address_Proof__c='Pan Card';
        testAccRcd3.PersonMobilePhone='1234567890';
        testAccRcd3.PersonEmail='abc@outlook.com';
        testAccRcd3.Preferred_Address_for_all_Corresppondenc__c='Permanent';
        insert testAccRcd3;
        
        Project__c testProjectRcd2 = new Project__c();
        testProjectRcd2.Name = 'Test Project 2';
        testProjectRcd2.Site_Head__c=testUserRcd1.Id;
        testProjectRcd2.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        testProjectRcd2.Budgets__c = 'Under 75 lakhs';
        testProjectRcd2.Configuration__c ='3 BHK';
        testProjectRcd2.Project_Email__c = 'parkwoods@dynamixgroup.co.in';
        insert testProjectRcd2;
        
        
        Opportunity testOppRcd3 = new Opportunity();
        testOppRcd3.AccountId = testAccRcd3.Id;
        testOppRcd3.Name = 'Test Opportunity 3';
        testOppRcd3.StageName = 'Site Visit';
        testOppRcd3.CloseDate = System.Today()+3;
        testOppRcd3.Nature_of_Purchase__c='Investment';
        testOppRcd3.Is_Booking_Form_Submitted_by_Customer__c=true;
        testOppRcd3.KYC_Completed__c = true;
        testOppRcd3.Stamp_Duty_Payable_By__c = 'Dynamix';
        testOppRcd3.EOI_Booking__c='No';
        testOppRcd3.Project__c = testProjectRcd2.Id;
        insert testOppRcd3;
        
        
        Booking_Offer__c testBookingOfferRcd=new Booking_Offer__c();
        testBookingOfferRcd.Start_Date__c=System.today()-3;
        testBookingOfferRcd.End_Date__c=System.today()+3;
        testBookingOfferRcd.Project__c=testProjectRcd2.Id;
        testBookingOfferRcd.Approval_Status__c='Approved';
        //testBookingOfferRcd.Active__c=true;
        insert testBookingOfferRcd;
        
        List <String> selectedProjectOffer=new List<String>();
        selectedProjectOffer.add(testBookingOfferRcd.Name);
        
        Pricing_Plan__c testPricingPlanRcd2 = new Pricing_Plan__c();
        testPricingPlanRcd2.Name = 'Pricing Plan Test 2';
        testPricingPlanRcd2.Project__c = testProjectRcd2.Id;
        insert testPricingPlanRcd2;
        
        Property__c testPropertyRcd2 = new Property__c();
        testPropertyRcd2.Name = 'test property 2';
        testPropertyRcd2.Project__c = testProjectRcd2.Id;
        testPropertyRcd2.Property_Price_Slab__c = testPricingPlanRcd2.Id;
        testPropertyRcd2.Floor__c= '15';
        insert testPropertyRcd2;
        
        Suggested_Property__c testSuggPropertyRcd2 = new Suggested_Property__c();
        testSuggPropertyRcd2.Opportunity__c = testOppRcd3.Id;
        testSuggPropertyRcd2.Unit__c = testPropertyRcd2.Id;
        testSuggPropertyRcd2.Discount__c = 15;
        insert testSuggPropertyRcd2;      
        
        
        Booking__c testBookingRcd3 = new Booking__c();
        testBookingRcd3.Primary_Applicant__c = testAccRcd3.Id;
        testBookingRcd3.Related_Opportunity__c = testOppRcd3.Id;
        testBookingRcd3.Related_Suggested_Property__c = testSuggPropertyRcd2.Id;
        testBookingRcd3.Project_Name__c = testProjectRcd2.Id;
        testBookingRcd3.Sub_Booking_Offer__c='Test 123';
        testBookingRcd3.Booking_Form_OTP__c='12345';
        insert testBookingRcd3;
        
        Payment__c testPaymentRcd2=new Payment__c();
        testPaymentRcd2.Booking__c=testBookingRcd3.Id;
        testPaymentRcd2.Cheque_Transaction_Number__c='12345';
        testPaymentRcd2.Amount__c=25000;
        testPaymentRcd2.Payment_Date__c=System.today();
        testPaymentRcd2.Bank_Name__c='ICICI';
        // insert testPaymentRcd2;       
        
        Test.startTest();        
        pagereference testPage2 = page.bookingform; 
        Test.setCurrentPage(testPage2);
        testPage2.getParameters().put('Id', String.valueOf(testBookingRcd3.Id));              
        ApexPages.StandardController sc1 = new  ApexPages.StandardController(testBookingRcd3);   
        BookingFormVfpController ext1 = new BookingFormVfpController(sc1);  
        
        ext1.thirdAccountRecord=[Select Id,Name,FirstName,LastName,Phone From Account Where Id=:testAccRcd3.Id];
        //ext1.thirdAccountLastName=ext1.thirdAccountRecord.LastName;
        // ext1.thirdAccountFirstName=ext1.thirdAccountRecord.FirstName;
        //  ext1.thirdAccountPhoneNumber=ext1.thirdAccountRecord.Phone;
        ext1.projectOfferName=selectedProjectOffer;
        ext1.onChangePurchasePurpose();
        ext1.selectedPurchasePurpose='Company/Partnership';
        ext1.selectedEOIBooking='YES';
        ext1.isAgreeWithTermsConditions=true;
        ext1.submittedBy='customer';
        try{
            ext1.eoiDate=system.today();
            ext1.eoiAmount=100000;
            
            ext1.sendOtpM();
            ext1.verifyOtp();
            ext1.submitBookingForm();
            
            Test.stopTest();
        }
        catch(Exception e){
            
        }
    }
    static testMethod void bookingFormControllertestMethod5(){  
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName1 = 'standarduser5' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur';
        testUserRcd1.LastName = 'Patel';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName1;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        testUserRcd1.Country='India';
        insert testUserRcd1;
        String personAccRcdTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account testAccRcd1 = new Account();
        testAccRcd1.Salutation='Mr.';
        testAccRcd1.FirstName='Test FName';
        testAccRcd1.LastName='Test LName';
        //testAccRcd1.BillingCountry = 'India';
        testAccRcd1.PersonMobilePhone = '1234567890';
        testAccRcd1.RecordTypeId=personAccRcdTypeId;         
        testAccRcd1.Country__c='India';
        testAccRcd1.Organisation_Country__c='India';
        testAccRcd1.Permanent_Address__c='test address';
        testAccRcd1.Post_Code__c='396430';
        testAccRcd1.State__c='Gujarat';
        testAccRcd1.PersonMailingStreet='Jay Hind Street';
        testAccRcd1.PersonBirthdate=System.today();
        testAccRcd1.Nationality__c='Indian';
        testAccRcd1.Address_Proof__c='Pan Card';
        testAccRcd1.PersonMobilePhone='1234567890';
        testAccRcd1.PersonEmail='abc@outlook.com';
        testAccRcd1.Aadhar_Uploaded__pc = true;
        testAccRcd1.PAN_Card_Uploaded__pc = true;
        testAccRcd1.Preferred_Address_for_all_Corresppondenc__c='Permanent';
        insert testAccRcd1;
        
        Account testAccRcd2 = new Account();
        testAccRcd2.Salutation='Ms.';
        testAccRcd2.FirstName='Test FName1';
        testAccRcd2.LastName='Test LName1';
        testAccRcd2.BillingCountry = 'India';
        testAccRcd2.PersonMobilePhone = '454645765';
        testAccRcd2.RecordTypeId=personAccRcdTypeId;  
        testAccRcd2.Country__c='India';
        testAccRcd2.Organisation_Country__c='India';
        testAccRcd2.Aadhar_Uploaded__pc = true;
        testAccRcd2.PAN_Card_Uploaded__pc = true;
        insert testAccRcd2;
        
        Project__c testProjectRcd = new Project__c();
        testProjectRcd.Name = 'Test Project';
        testProjectRcd.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        testProjectRcd.Budgets__c = 'Under 75 lakhs';
        testProjectRcd.Configuration__c ='3 BHK';
        testProjectRcd.Project_Email__c = 'parkwoods@dynamixgroup.co.in';
        insert testProjectRcd;
        
        Opportunity testOppRcd = new Opportunity();
        testOppRcd.AccountId = testAccRcd1.Id;
        testOppRcd.Name = 'Test Opportunity';
        testOppRcd.StageName = 'Site Visit';
        testOppRcd.CloseDate = System.Today()+3;
        testOppRcd.Nature_of_Purchase__c='Self Use';
        testOppRcd.Is_Booking_Form_Submitted_by_Customer__c=true;
        testOppRcd.KYC_Completed__c = true;
        testOppRcd.Stamp_Duty_Payable_By__c = 'Dynamix';
        testOppRcd.EOI_Booking__c='Yes';
        testOppRcd.EOI_Date__c=System.today();
        testOppRcd.EOI_Amount__c=5000;
        testOppRcd.Project__c = testProjectRcd.Id;
        insert testOppRcd;
        
        Booking_Offer__c testBookingOfferRcd=new Booking_Offer__c();
        testBookingOfferRcd.Start_Date__c=System.today()-3;
        testBookingOfferRcd.End_Date__c=System.today()+3;
        testBookingOfferRcd.Project__c=testProjectRcd.Id;
        testBookingOfferRcd.Approval_Status__c='Rejected';
        //testBookingOfferRcd.Active__c=true;
        insert testBookingOfferRcd;
        
        Pricing_Plan__c testPricingPlanRcd = new Pricing_Plan__c();
        testPricingPlanRcd.Name = 'Pricing Plan Test';
        testPricingPlanRcd.Project__c = testProjectRcd.Id;
        insert testPricingPlanRcd;
        
        Property__c testPropertyRcd = new Property__c();
        testPropertyRcd.Name = 'test property';
        testPropertyRcd.Project__c = testProjectRcd.Id;
        testPropertyRcd.Property_Price_Slab__c = testPricingPlanRcd.Id;
        testPropertyRcd.Floor__c= '5';
        insert testPropertyRcd;
        
        Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
        testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
        testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
        testSuggPropertyRcd.Discount__c = 10;
        insert testSuggPropertyRcd;      
        
        test.startTest();
        
        
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd1.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        insert testBookingRcd;
        
        Payment__c testPaymentRcd=new Payment__c();
        testPaymentRcd.Booking__c=testBookingRcd.Id;
        testPaymentRcd.Cheque_Transaction_Number__c='12345';
        testPaymentRcd.Amount__c=50000;
        testPaymentRcd.Payment_Date__c=System.today();
        testPaymentRcd.Bank_Name__c='ICICI';
        //insert testPaymentRcd;
        
        /*List<Attachment> attach =[select id, name,OwnerId,Body,ParentId from Attachment where parent.id=:testAccRcd1.id];
if (attach != null && attach.size() > 0) {
for (Attachment att : attach) {
ContentVersion cVersion = new ContentVersion();
cVersion.ContentLocation = 'S'; 
cVersion.PathOnClient = att.Name;
cVersion.Origin = 'H';
cVersion.OwnerId = att.OwnerId;
cVersion.Title = att.Name;
cVersion.VersionData = att.Body;
cVersion.Document_Type__c = 'Pan Card';
cVersion.SObjectType__c = 'Account';
cVersion.BookingId__c = testAccRcd1.Id;
Insert cVersion;

List<ContentDocumentLink> PANcdlist = [select LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId =: cVersion.ContentDocumentId];

}
}else {
System.debug('No Attachment records found.');
}
*/
        
        
        
        Co_Applicant__c testCoAppRcd1=new Co_Applicant__c();
        testCoAppRcd1.Account__c=String.valueOf(testAccRcd2.Id) ;
        testCoAppRcd1.Booking__c=testBookingRcd.Id;
        //insert testCoAppRcd1;
        
        pagereference testPage = page.bookingform; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(testBookingRcd.Id));       
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(testBookingRcd);   
        BookingFormVfpController ext = new BookingFormVfpController(sc);  
        
        ext.selectedPrimaryAccNationality='Non-Resident Indian';
        ext.selectedEOIBooking='No';
        ext.primaryAccPassportFile=Blob.valueOf('Test primaryAccPassportFile'); 
        ext.primaryAccPassportFileName='primaryAccPassportFileName';
        /*ext.primaryAccOCIPIOFile=Blob.valueOf('Test primaryAccOCIPIOFile'); 
ext.primaryAccOCIPIOFileName='primaryAccOCIPIOFileName';
ext.primaryAccPanDetailsFile=Blob.valueOf('Test primaryAccPanDetailsFile'); 
ext.primaryAccPanDetailsFileName='primaryAccPanDetailsFileName';
ext.primaryAccAddProofFile=Blob.valueOf('Test primaryAccAddProofFile'); 
ext.primaryAccAddProofFileName='primaryAccAddProofFileName'; */
        ext.isAgreeWithTermsConditions=true;
        ext.submittedBy='customer';
        
        
        ext.getprimaryAccountSalutationOption();
        ext.getsecondAccountSalutationOption();
        ext.getthirdAccountSalutationOption();
        ext.getprojectOfferNames(); 
        ext.getselPurchasePurposeOption();     
        ext.getselectedPrimaryAccPermAddCountryOptions();     
        ext.getselectedPrimaryAccPermAddStateOptions();     
        ext.onChangePrimaryAccCountry();
        ext.getselectedSecondAccPermAddCountryOptions();
        ext.getselectedSecondAccPermAddStateOptions();
        ext.onChangeSecondAccCountry();
        ext.getselectedPrimaryAccOrgOfficeAddCountryOptions();
        ext.getselectedPrimaryAccOrgOfficeAddStateOptions();
        ext.onChangePrimaryAccOrgOfficeCountry();
        ext.getselectedSecondAccOrgOfficeAddCountryOptions();
        ext.getselectedSecondAccOrgOfficeAddStateOptions();
        ext.onChangeSecondAccOrgOfficeCountry();
        ext.getselectedPrimaryAccPreffAddOption();
        ext.getselectedPrimaryAccNationalityOptions();
        ext.getselectedPrimaryAccOccupationOptions();
        ext.getresidentialLevelOptions();
        ext.getbookingSourceOptions();
        try{
            ext.geteoiBookingOptions();
            ext.getselectedPropertyTypeOptions();
            ext.onChangeCheckboxValue();
            ext.onChangePurchasePurpose();
            ext.onChangePrimaryAccNationality();
            ext.onChangeSecondAccNationality();
            ext.onChangeEoiBooking();
            
            ext.sendOtpM();
            ext.verifyOtp();
            ext.submitBookingForm();
            Test.stopTest();
        }
        catch(Exception e){
            
        }
    }
    static testMethod void bookingFormControllertestMethod6(){  
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName1 = 'standarduser6' + DateTime.now().getTime() + '@testorg.com';
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur';
        testUserRcd1.LastName = 'Patel';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName1;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        testUserRcd1.Country='India';
        insert testUserRcd1;
        String personAccRcdTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account testAccRcd1 = new Account();
        testAccRcd1.Salutation='Mr.';
        testAccRcd1.FirstName='Test FName';
        testAccRcd1.LastName='Test LName';
        testAccRcd1.BillingCountry = 'India';
        testAccRcd1.PersonMobilePhone = '1234567890';
        testAccRcd1.RecordTypeId=personAccRcdTypeId;         
        testAccRcd1.Country__c='India';
        testAccRcd1.Organisation_Country__c='India';
        testAccRcd1.Permanent_Address__c='test address';
        testAccRcd1.Post_Code__c='396430';
        testAccRcd1.State__c='Gujarat';
        testAccRcd1.PersonMailingStreet='Jay Hind Street';
        insert testAccRcd1;
        
        Account testAccRcd2 = new Account();
        testAccRcd2.Salutation='Ms.';
        testAccRcd2.FirstName='Test FName1';
        testAccRcd2.LastName='Test LName1';
        testAccRcd2.BillingCountry = 'India';
        testAccRcd2.PersonMobilePhone = '4343678545';
        testAccRcd2.RecordTypeId=personAccRcdTypeId;  
        testAccRcd2.Country__c='India';
        testAccRcd2.Organisation_Country__c='India';
        insert testAccRcd2;
        
        Project__c testProjectRcd = new Project__c();
        testProjectRcd.Name = 'Test Project';
        testProjectRcd.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        testProjectRcd.Budgets__c = 'Under 75 lakhs';
        testProjectRcd.Configuration__c ='3 BHK';
        testProjectRcd.Project_Email__c = 'parkwoods@dynamixgroup.co.in';
        insert testProjectRcd;
        
        
        Opportunity testOppRcd = new Opportunity();
        testOppRcd.AccountId = testAccRcd1.Id;
        testOppRcd.Name = 'Test Opportunity';
        testOppRcd.StageName = 'Site Visit';
        testOppRcd.CloseDate = System.Today()+3;
        testOppRcd.Nature_of_Purchase__c='Self Use';
        testOppRcd.Is_Booking_Form_Submitted_by_Customer__c=true;
        testOppRcd.KYC_Completed__c = true;
        testOppRcd.Stamp_Duty_Payable_By__c = 'Dynamix';
        testOppRcd.EOI_Booking__c='Yes';
        testOppRcd.EOI_Date__c=System.today();
        testOppRcd.EOI_Amount__c=5000;
        testOppRcd.Project__c = testProjectRcd.Id;
        insert testOppRcd;
        
        
        Booking_Offer__c testBookingOfferRcd=new Booking_Offer__c();
        testBookingOfferRcd.Start_Date__c=System.today()-3;
        testBookingOfferRcd.End_Date__c=System.today()+3;
        testBookingOfferRcd.Project__c=testProjectRcd.Id;
        testBookingOfferRcd.Approval_Status__c='Rejected';
        //testBookingOfferRcd.Active__c=true;
        insert testBookingOfferRcd;
        
        Pricing_Plan__c testPricingPlanRcd = new Pricing_Plan__c();
        testPricingPlanRcd.Name = 'Pricing Plan Test';
        testPricingPlanRcd.Project__c = testProjectRcd.Id;
        insert testPricingPlanRcd;
        
        Property__c testPropertyRcd = new Property__c();
        testPropertyRcd.Name = 'test property';
        testPropertyRcd.Project__c = testProjectRcd.Id;
        testPropertyRcd.Property_Price_Slab__c = testPricingPlanRcd.Id;
        testPropertyRcd.Floor__c= '5';
        insert testPropertyRcd;
        
        Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
        testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
        testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
        testSuggPropertyRcd.Discount__c = 10;
        insert testSuggPropertyRcd;   
        
        Test.StartTest();
        
        
        Booking__c testBookingRcd = new Booking__c();
        testBookingRcd.Primary_Applicant__c = testAccRcd1.Id;
        testBookingRcd.Prior_Primary_Applicant__c = testAccRcd1.Id;
        testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
        testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
        testBookingRcd.Project_Name__c = testProjectRcd.Id;
        testBookingRcd.Sub_Booking_Offer__c='Test 123';
        testBookingRcd.Booking_Form_OTP__c='12345';
        insert testBookingRcd;
        
        Payment__c testPaymentRcd=new Payment__c();
        testPaymentRcd.Booking__c=testBookingRcd.Id;
        testPaymentRcd.Cheque_Transaction_Number__c='12345';
        testPaymentRcd.Amount__c=50000;
        testPaymentRcd.Payment_Date__c=System.today();
        testPaymentRcd.Bank_Name__c='ICICI';
        // insert testPaymentRcd;
        
        
        Co_Applicant__c testCoAppRcd1=new Co_Applicant__c();
        testCoAppRcd1.Account__c=String.valueOf(testAccRcd2.Id) ;
        testCoAppRcd1.Booking__c=testBookingRcd.Id;
        //insert testCoAppRcd1;
        
        // List<String> projectOfferNameList=new List<String>();
        
        Offer__c testOffer=new Offer__c();
        testOffer.Booking__c=testBookingRcd.Id;
        testOffer.Project_Offer__c=testBookingOfferRcd.Id;      
        insert testOffer;
        
        
        
        pagereference testPage = page.bookingform; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(testBookingRcd.Id));       
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(testBookingRcd);   
        BookingFormVfpController ext = new BookingFormVfpController(sc);  
        
        ext.selectedPrimaryAccNationality='Non-Resident Indian';
        ext.selectedEOIBooking='Yes';
        ext.primaryAccPassportFile=Blob.valueOf('Test primaryAccPassportFile'); 
        ext.primaryAccPassportFileName='primaryAccPassportFileName';
        /* ext.primaryAccOCIPIOFile=Blob.valueOf('Test primaryAccOCIPIOFile'); 
ext.primaryAccOCIPIOFileName='primaryAccOCIPIOFileName';
ext.primaryAccPanDetailsFile=Blob.valueOf('Test primaryAccPanDetailsFile'); 
ext.primaryAccPanDetailsFileName='primaryAccPanDetailsFileName';
ext.primaryAccAddProofFile=Blob.valueOf('Test primaryAccAddProofFile'); 
ext.primaryAccAddProofFileName='primaryAccAddProofFileName'; */
        ext.isAgreeWithTermsConditions=true;
        ext.submittedBy='';
        
        
        ext.getprimaryAccountSalutationOption();
        ext.getsecondAccountSalutationOption();
        ext.getthirdAccountSalutationOption();
        ext.getprojectOfferNames(); 
        ext.getselPurchasePurposeOption();     
        ext.getselectedPrimaryAccPermAddCountryOptions();     
        ext.getselectedPrimaryAccPermAddStateOptions();     
        ext.onChangePrimaryAccCountry();
        ext.getselectedSecondAccPermAddCountryOptions();
        ext.getselectedSecondAccPermAddStateOptions();
        ext.onChangeSecondAccCountry();
        ext.getselectedPrimaryAccOrgOfficeAddCountryOptions();
        ext.getselectedPrimaryAccOrgOfficeAddStateOptions();
        ext.onChangePrimaryAccOrgOfficeCountry();
        ext.getselectedSecondAccOrgOfficeAddCountryOptions();
        ext.getselectedSecondAccOrgOfficeAddStateOptions();
        ext.onChangeSecondAccOrgOfficeCountry();
        ext.getselectedPrimaryAccPreffAddOption();
        ext.getselectedPrimaryAccNationalityOptions();
        ext.getselectedPrimaryAccOccupationOptions();
        ext.getresidentialLevelOptions();
        ext.getbookingSourceOptions();
        ext.geteoiBookingOptions();
        ext.getselectedPropertyTypeOptions();
        ext.onChangeCheckboxValue();
        ext.onChangePurchasePurpose();
        ext.onChangePrimaryAccNationality();
        ext.onChangeSecondAccNationality();
        ext.onChangeEoiBooking();
        
        ext.sendOtpM();
        ext.verifyOtp();
        ext.submitBookingForm();
        
        BookingFormVfpController.testCoverage();
        Test.stopTest();
    }
}