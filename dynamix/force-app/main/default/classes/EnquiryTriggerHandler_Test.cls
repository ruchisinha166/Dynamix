@isTest
public class EnquiryTriggerHandler_Test {
    @testSetup static void setup() {
        EmailTemplate emailTemplate = [select Id,Subject,HtmlValue,Body from EmailTemplate where Name =: 'OC Receival Certificate Email'];
        SMS_Template_Id__mdt smsTemplate = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='OC Receival Certificate SMS' Limit 1];
        EmailTemplate smsEmailTemp = [Select Id,Name,HtmlValue From EmailTemplate Where Name = 'OC Receival Certificate SMS' Limit 1];
        EmailTemplate emailTemplateforWhatsapp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'New_CP_Registration_Through_Website' LIMIT 1];
        EmailTemplate emailTemplateforSMS = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS for New CP Registration' LIMIT 1];
        
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
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1){
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Test.startTest();
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
            accountObject.PersonMobilePhone='123456786'; 
            accountObject.OwnerId = testUserRcd1.id;
            insert accountObject;
            
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            projectObject.OC_Number__c ='Test 123';
            projectObject.OC_Receival_Date__c = system.today();
            projectObject.Project_Link__c = 'https://dynamixgroup2.com';
            insert projectObject;
            
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            testCampRcd.Virtual_Phone_Number__c = '02241642245';
            insert testCampRcd;
            
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c=accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Google';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='1234567890';
            testEnqRcd.Stage__c = 'New Enquiry';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            insert testEnqRcd;
            
            Task thisTask = New Task();
            thisTask.subject = 'Outgoing Call';
            thisTask.WhatId = testEnqRcd.id;
            insert thisTask;
            Test.stopTest();            
        }
    }
    @isTest
    public static void testMethod7(){
        EmailTemplate emailTemplate = [select Id,Subject,HtmlValue,Body from EmailTemplate where Name =: 'OC Receival Certificate Email'];
        SMS_Template_Id__mdt smsTemplate = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='OC Receival Certificate SMS' Limit 1];
        EmailTemplate smsEmailTemp = [Select Id,Name,HtmlValue From EmailTemplate Where Name = 'OC Receival Certificate SMS' Limit 1];
        EmailTemplate emailTemplateforWhatsapp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'New_CP_Registration_Through_Website' LIMIT 1];
        EmailTemplate emailTemplateforSMS = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS for New CP Registration' LIMIT 1];
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        OrgWideEmailAddress owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Default'];
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1){
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Test.startTest();
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.PersonMobilePhone='123456';
            accountObject.OwnerId = testUserRcd1.id;
            try{
                insert accountObject;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }            
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            insert projectObject;
            
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            testCampRcd.Virtual_Phone_Number__c = '02241642246';
            insert testCampRcd;
            
            
            List<Enquiry__c> enqList = new  List<Enquiry__c>();
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c=accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Google';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number_Text__c='123456789899';//above 10 Digits Phone Number
            testEnqRcd.Stage__c = 'Site Visit Done';
            testEnqRcd.Primary_Mobile_Number__c='1234545890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            enqList.add(testEnqRcd);
            try{
                insert testEnqRcd;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }
            EnquiryTriggerHandler.main(enqList);
            Test.stopTest();
            
        }
    }
    
    @isTest
    public static void Virtualnumber(){
        EmailTemplate emailTemplate = [select Id,Subject,HtmlValue,Body from EmailTemplate where Name =: 'OC Receival Certificate Email'];
        SMS_Template_Id__mdt smsTemplate = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='OC Receival Certificate SMS' Limit 1];
        EmailTemplate smsEmailTemp = [Select Id,Name,HtmlValue From EmailTemplate Where Name = 'OC Receival Certificate SMS' Limit 1];
        EmailTemplate emailTemplateforWhatsapp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'New_CP_Registration_Through_Website' LIMIT 1];
        EmailTemplate emailTemplateforSMS = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS for New CP Registration' LIMIT 1];
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        OrgWideEmailAddress owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Default'];
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1){
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Test.startTest();
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.PersonMobilePhone='127788'; 
            accountObject.OwnerId = testUserRcd1.id;
            try{
                insert accountObject;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }            
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            insert projectObject;
            
            List<Campaign> testCampaigns = new List<Campaign>();
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            testCampRcd.Virtual_Phone_Number__c = '02241642246';
            testCampRcd.Sub_Source__c = 'Facebook Paid';
            //insert testCampRcd;
            
            insert testCampaigns;
            
            List<Enquiry__c> enqList = new  List<Enquiry__c>();
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            ///testEnqRcd.Contact_Person__c=accountObject.Id;
            testEnqRcd.Enquiry_Source__c = null;
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='1234567860';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            testEnqRcd.Stage__c = 'Site Visit Scheduled';
            testEnqRcd.Exotel_Call__c = true;
            //   testEnqRcd.Primary_Mobile_Number__c='1234877890';
            enqList.add(testEnqRcd);
            //insert enqList;
            
            try{
                insert testEnqRcd;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }
            EnquiryTriggerHandler.createAccount(enqList);
            Test.stopTest();
            
        }
    }
    
    @isTest
    public static void DuplicateLead(){
        EmailTemplate emailTemplate = [select Id,Subject,HtmlValue,Body from EmailTemplate where Name =: 'OC Receival Certificate Email'];
        SMS_Template_Id__mdt smsTemplate = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='OC Receival Certificate SMS' Limit 1];
        EmailTemplate smsEmailTemp = [Select Id,Name,HtmlValue From EmailTemplate Where Name = 'OC Receival Certificate SMS' Limit 1];
        EmailTemplate emailTemplateforWhatsapp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'New_CP_Registration_Through_Website' LIMIT 1];
        EmailTemplate emailTemplateforSMS = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS for New CP Registration' LIMIT 1];
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        OrgWideEmailAddress owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Default'];
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1){
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Test.startTest();
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.OwnerId = testUserRcd1.id;
            accountObject.PersonMobilePhone='46464'; 
            try{
                insert accountObject;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            insert projectObject;
            
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            insert testCampRcd;
            
            Task_Target__c tasktarget = new Task_Target__c();
            tasktarget.Month__c =System.now().format('MMMMM');
            tasktarget.User__c = testUserRcd1.Id;
            tasktarget.Year__c = String.valueof(System.today().year());
            tasktarget.Number_of_Targets_Achievement__c = null;
            tasktarget.X1st_Week__c = 0;
            tasktarget.X2nd_Week__c =null;
            tasktarget.X3rd_Week__c = null;
            tasktarget.X4th_Week__c = null;
            tasktarget.X5th_Week__c =null;
            tasktarget.Project__c = projectObject.Id;
            tasktarget.Number_of_Connected_Call__c = 0;
            tasktarget.No_of_Walk_ins__c = 0;
            tasktarget.No_of_Follow_Ups__c =0;
            tasktarget.Number_of_Targets__c = 100;
            tasktarget.Type__c = 'Unique Outbound';
            insert tasktarget;
            
            List<Enquiry__c> enqList = new  List<Enquiry__c>();
            
            Enquiry__c testEnqRcd=new Enquiry__c();
            //   testEnqRcd.Lost_Reasons__c='Duplicate Lead';
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c=accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Google';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='6767676767';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            testEnqRcd.Stage__c='New Enquiry';
            insert testEnqRcd;
            
            Enquiry__c testEnqRcd1=new Enquiry__c();
            // testEnqRcd1.Lost_Reasons__c='Duplicate Lead';
            testEnqRcd1.Project__c=projectObject.Id;
            testEnqRcd1.Contact_Person__c=accountObject.Id;
            testEnqRcd1.Enquiry_Source__c='Google';
            testEnqRcd1.Campaign__c=testCampRcd.Id;
            testEnqRcd1.Country_Code__c='+91';
            testEnqRcd1.Primary_Mobile_Number__c='6767676767';
            testEnqRcd1.OwnerId=testUserRcd1.Id;
            testEnqRcd1.Stage__c='New Enquiry';
            enqList.add(testEnqRcd1);
            
            Enquiry__c testEnqRcd2=new Enquiry__c();
            testEnqRcd2.Lost_Reasons__c='Duplicate Lead';
            testEnqRcd2.Project__c=projectObject.Id;
            testEnqRcd2.Contact_Person__c=accountObject.Id;
            testEnqRcd2.Enquiry_Source__c='Google';
            testEnqRcd2.Campaign__c=testCampRcd.Id;
            testEnqRcd2.Country_Code__c='+91';
            testEnqRcd2.Primary_Mobile_Number__c='6767676767';
            testEnqRcd2.OwnerId=testUserRcd1.Id;
            testEnqRcd2.Stage__c='open';
            //enqList.add(testEnqRcd2);
            try{
                insert enqList;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }
            // EnquiryTriggerHandler.markEnquiryAsDuplicate(enqList);
            Test.stopTest();
            
        }
    }
    @isTest
    public static void EnqQualificationQualified(){
        EmailTemplate emailTemplate = [select Id,Subject,HtmlValue,Body from EmailTemplate where Name =: 'OC Receival Certificate Email'];
        SMS_Template_Id__mdt smsTemplate = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='OC Receival Certificate SMS' Limit 1];
        EmailTemplate smsEmailTemp = [Select Id,Name,HtmlValue From EmailTemplate Where Name = 'OC Receival Certificate SMS' Limit 1];
        EmailTemplate emailTemplateforWhatsapp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'New_CP_Registration_Through_Website' LIMIT 1];
        EmailTemplate emailTemplateforSMS = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS for New CP Registration' LIMIT 1];
        
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        OrgWideEmailAddress owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Default'];
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        
        System.runAs(testUserRcd1){
            Test.startTest();
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.OwnerId = testUserRcd1.id;
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.PersonMobilePhone='128988'; 
            try{
                insert accountObject;
            }    catch(Exception e){
                System.debug('Exception:'+e);
            }
            
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            insert projectObject;
            
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            insert testCampRcd;
            
            List<Enquiry__c> enqList = new  List<Enquiry__c>();
            
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c=accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Google';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='1234567890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            testEnqRcd.Stage__c='Site Visit Done'; 
            testEnqRcd.Enquiry_Qualification_Tags__c='Qualified';
            enqList.add(testEnqRcd);
            try{
                insert testEnqRcd;
                
                Enquiry__c testEnqUpdate=[Select Id,Stage__c,Enquiry_Qualification_Tags__c from Enquiry__c Where Id=:testEnqRcd.Id];
                testEnqUpdate.Stage__c='Contacted';
                
                try{
                    update testEnqUpdate;
                }
                catch(Exception e){
                    System.debug('update Exception:'+e);
                }
                
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }
            EnquiryTriggerHandler.UpdateTotalChildRecords(enqList);
            Test.stopTest();
        }
    }
    
    /*  @isTest
public static void testMethod1(){
Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
OrgWideEmailAddress owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Default'];
User testUserRcd1 = new User();
testUserRcd1.FirstName = 'Mayur1';
testUserRcd1.LastName = 'Patel123';
testUserRcd1.Email = 'mayur.patel@manras.com';
testUserRcd1.Alias = 'MPatel';
testUserRcd1.Username = uniqueUserName;
testUserRcd1.ProfileId = pId.Id;
testUserRcd1.EmailEncodingKey = 'UTF-8';
testUserRcd1.Country = 'India';
testUserRcd1.IsActive=true;
testUserRcd1.LanguageLocaleKey='en_US';
testUserRcd1.LocaleSidKey='en_US';
testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
insert testUserRcd1;

System.runAs(testUserRcd1){

Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

Account accountObject = new Account();
accountObject.FirstName = 'test';
accountObject.LastName = 'Account';
accountObject.BillingCountry = 'India';
accountObject.Phone = '455546565';
accountObject.RecordTypeId = PersonRecId;
accountObject.PersonEmail = 'dynamix.project@gmail.com';
accountObject.Aadhar_No__pc = '458785698547';
accountObject.PAN_No__c = 'ABCTY1234D';
accountObject.Aadhar_Uploaded__pc = true;
accountObject.PAN_Card_Uploaded__pc = true;
accountObject.Upload_PAN_Card__c=true;
accountObject.PersonMobilePhone='18988'; 
try{
insert accountObject;
}
catch(Exception e){
System.debug('Exception:'+e);
}            

Project__c projectObject = new Project__c();
projectObject.Name = 'Test Project';
projectObject.Project_Email__c= 'mayur.patel@manras.com';
projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
projectObject.Budgets__c = 'Under 75 lakhs';
projectObject.Configuration__c ='1 BHK';
projectObject.Project_Head__c = testUserRcd1.Id;
projectObject.Site_Head__c = testUserRcd1.id;
insert projectObject;

Campaign testCampRcd=new Campaign();
testCampRcd.Name='test Campaign';
testCampRcd.Project__c=projectObject.Id;
testCampRcd.Source__c='Google';
testCampRcd.StartDate=System.today();
testCampRcd.EndDate=System.today()+15;
testCampRcd.ActualCost=2500000;
insert testCampRcd;

Test.startTest();
Enquiry__c testEnqRcd=new Enquiry__c();
testEnqRcd.Project__c=projectObject.Id;
testEnqRcd.Contact_Person__c=accountObject.Id;
testEnqRcd.Enquiry_Source__c='Google';
testEnqRcd.Campaign__c=testCampRcd.Id;
testEnqRcd.Country_Code__c='+91';
testEnqRcd.Primary_Mobile_Number__c='123456';
testEnqRcd.OwnerId=testUserRcd1.Id;
try{
insert testEnqRcd;
}
catch(Exception e){
System.debug('Exception:'+e);
}
Test.stopTest();
}
}*/
    @isTest
    public static void testMethod2(){
        EmailTemplate emailTemplate = [select Id,Subject,HtmlValue,Body from EmailTemplate where Name =: 'OC Receival Certificate Email'];
        SMS_Template_Id__mdt smsTemplate = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='OC Receival Certificate SMS' Limit 1];
        EmailTemplate smsEmailTemp = [Select Id,Name,HtmlValue From EmailTemplate Where Name = 'OC Receival Certificate SMS' Limit 1];
        EmailTemplate emailTemplateforWhatsapp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'New_CP_Registration_Through_Website' LIMIT 1];
        EmailTemplate emailTemplateforSMS = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS for New CP Registration' LIMIT 1];
        
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
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        
        System.runAs(testUserRcd1){
            
            Test.startTest();
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.PersonMobilePhone='123458988'; 
            accountObject.OwnerId = testUserRcd1.id;
            try{
                insert accountObject;
            }    catch(Exception e){
                System.debug('Exception:'+e);
            }
            
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            insert projectObject;
            
            List < Campaign> testCampaigns = new List <Campaign>();
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            
            insert testCampRcd;
            testCampaigns.add(testCampRcd);
            
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c=accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Google';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='1234567890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            testEnqRcd.Stage__c='New Enquiry'; 
            insert testEnqRcd;
            
            List<Enquiry__c> enquiriesToDelete = [SELECT Id FROM Enquiry__c WHERE Campaign__c = :testCampaigns[0].Id];
            EnquiryTriggerHandler.UpdateTotalChildRecordsOnDelete(enquiriesToDelete);
            
            Test.stopTest();
        }
    }
    
    @isTest
    public static void testMethod3(){
        EmailTemplate emailTemplate = [select Id,Subject,HtmlValue,Body from EmailTemplate where Name =: 'OC Receival Certificate Email'];
        SMS_Template_Id__mdt smsTemplate = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='OC Receival Certificate SMS' Limit 1];
        EmailTemplate smsEmailTemp = [Select Id,Name,HtmlValue From EmailTemplate Where Name = 'OC Receival Certificate SMS' Limit 1];
        EmailTemplate emailTemplateforWhatsapp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'New_CP_Registration_Through_Website' LIMIT 1];
        
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
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1){
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Test.startTest();
            List<Account> acc = new List<Account>();
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.PersonMobilePhone='123458988'; 
            accountObject.OwnerId = testUserRcd1.id;
            insert accountObject;
            acc.add(accountObject);
            
            Account accountObject1 = new Account();
            accountObject1.FirstName = 'New';
            accountObject1.LastName = 'Test';
            accountObject1.BillingCountry = 'India';
            accountObject1.Phone = '4555465345';
            accountObject1.RecordTypeId = PersonRecId;
            accountObject1.PersonEmail = 'dynamix.newproject@gmail.com';
            accountObject1.Aadhar_No__pc = '458724698456';
            accountObject1.PAN_No__c = 'ABCTY1567D';
            accountObject1.Aadhar_Uploaded__pc = true;
            accountObject1.PAN_Card_Uploaded__pc = true;
            accountObject1.Upload_PAN_Card__c=true;
            accountObject1.PersonMobilePhone='1234583543';   
            accountObject1.OwnerId = testUserRcd1.id;
            
            insert accountObject1;
            
            set<String> projectIdSet = New set<String>();
            set<String> SourceSet = New set<String>();
            set<String> phoneNumber = New set<String>();
            set<String> virtualPhoneNumber = New set<String>();
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            insert projectObject;
            
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            testCampRcd.Virtual_Phone_Number__c = '02241642245';
            insert testCampRcd;
            
            List<Enquiry__c> enquList = new List<Enquiry__c>();
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Enquiry_Source__c='Google';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='1234567890';
            testEnqRcd.Stage__c = 'Interested';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            testEnqRcd.Contact_Person__c = accountObject.Id;
            insert testEnqRcd;
            enquList.add(testEnqRcd);
            
            Enquiry__c testEnqRcd1=new Enquiry__c();
            testEnqRcd1.Project__c=projectObject.Id;
            testEnqRcd1.Enquiry_Source__c='Google';
            testEnqRcd1.Country_Code__c='+91';
            testEnqRcd1.Primary_Mobile_Number__c='1234567890';
            testEnqRcd1.Stage__c = 'Interested';
            testEnqRcd1.OwnerId=testUserRcd1.Id;
            testEnqRcd1.Contact_Person__c = accountObject1.Id;
            insert testEnqRcd1;
            
            
            EnquiryTriggerHandler.createAccount(new List<Enquiry__c>{testEnqRcd1});
            Test.stopTest();
        }
    }
    @isTest
    public static void TaskTargetNull(){
        EmailTemplate emailTemplate = [select Id,Subject,HtmlValue,Body from EmailTemplate where Name =: 'OC Receival Certificate Email'];
        SMS_Template_Id__mdt smsTemplate = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='OC Receival Certificate SMS' Limit 1];
        EmailTemplate smsEmailTemp = [Select Id,Name,HtmlValue From EmailTemplate Where Name = 'OC Receival Certificate SMS' Limit 1];
        EmailTemplate emailTemplateforWhatsapp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'New_CP_Registration_Through_Website' LIMIT 1];
        EmailTemplate emailTemplateforSMS = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS for New CP Registration' LIMIT 1];
        
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
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1){
            
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Test.startTest();
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.PersonMobilePhone='123678988'; 
            accountObject.OwnerId = testUserRcd1.id;
            try{
                insert accountObject;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            insert projectObject;
            
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            insert testCampRcd;
            
            
            
            
            Set<Id> ownerId = New Set<Id>();
            List<Enquiry__c> enqList = new  List<Enquiry__c>();
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c=accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Google';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='2234565890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            testEnqRcd.Task_Target__c = null;
            testEnqRcd.Site_Visit_Done_Date__c = System.today();
            testEnqRcd.Stage__c = 'New Enquiry';
            enqList.add(testEnqRcd);
            insert testEnqRcd;
            ownerId.add(testEnqRcd.OwnerId);
            Integer yr = testEnqRcd.Site_Visit_Done_Date__c.year();
            string month = testEnqRcd.Site_Visit_Done_Date__c.format('MMMM');
            string Keys = month+'-'+String.valueOf(yr)+'-'+String.valueOf(testEnqRcd.Project__c)+'-'+String.valueOf(testEnqRcd.OwnerId);
            
            
            
            Enquiry__c enqForUpdate2=[Select Id,OwnerId,Stage__c,Site_Visit_Done_Date__c From Enquiry__c Where Id=:testEnqRcd.Id];            
            enqForUpdate2.OwnerId=testUserRcd1.Id;   
            enqForUpdate2.Stage__c='Site Visit Done';
            enqForUpdate2.Site_Visit_Done_Date__c = system.today().addDays(3);
            try{
                update enqForUpdate2;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }
            
            /*Task_Target__c testTaskTgtRcd1=new Task_Target__c();
testTaskTgtRcd1.user__c=testUserRcd1.Id;
testTaskTgtRcd1.Month__c='August';
testTaskTgtRcd1.Type__c='Walk-In';
testTaskTgtRcd1.Year__c='2023';
testTaskTgtRcd1.Number_of_Targets__c=11;
testTaskTgtRcd1.Project__c=projectObject.Id;
testTaskTgtRcd1.No_of_Walk_ins__c=6;
testTaskTgtRcd1.Number_of_Targets_Achievement__c = null;
insert testTaskTgtRcd1;*/
            
            Map<String, Task_Target__c> mapOfUserToGetEnquiryTargetId = New Map<String, Task_Target__c>();
            Map<String, Integer> mapUserForCountEnquiry = New Map<String, Integer>();
            Task_Target__c testTaskTgtRcd=new Task_Target__c();
            testTaskTgtRcd.user__c=testUserRcd1.Id;
            testTaskTgtRcd.Month__c='July';
            testTaskTgtRcd.Type__c='Walk-In';
            testTaskTgtRcd.Year__c='2023';
            testTaskTgtRcd.Number_of_Targets__c=12;
            testTaskTgtRcd.Project__c=projectObject.Id;
            testTaskTgtRcd.No_of_Walk_ins__c=5;
            testTaskTgtRcd.Number_of_Targets_Achievement__c = null;
            insert testTaskTgtRcd;
            
            
            string Key = testTaskTgtRcd.Month__c+'-'+testTaskTgtRcd.Year__c+'-'+String.valueOf(testTaskTgtRcd.Project__c)+'-'+String.valueOf(testTaskTgtRcd.User__c);
            mapOfUserToGetEnquiryTargetId.put(Key,testTaskTgtRcd);
            
            mapUserForCountEnquiry.put(Key,Integer.valueof(testTaskTgtRcd.Number_of_Targets_Achievement__c));
            mapUserForCountEnquiry.containsKey(Keys);
            EnquiryTriggerHandler.countEnquiryAndAddOnEnquiryTarget(new List<Enquiry__c>{testEnqRcd});
            Enquiry__c updatedEnquiry = [SELECT Task_Target__c FROM Enquiry__c WHERE Id = :testEnqRcd.Id];
            Task_Target__c updatedTaskTarget = [SELECT Number_of_Targets_Achievement__c FROM Task_Target__c WHERE Id = :testTaskTgtRcd.Id];
            
            Test.stopTest();
        }
    }
    @isTest
    public static void testMethod4(){
        EmailTemplate emailTemplate = [select Id,Subject,HtmlValue,Body from EmailTemplate where Name =: 'OC Receival Certificate Email'];
        SMS_Template_Id__mdt smsTemplate = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='OC Receival Certificate SMS' Limit 1];
        EmailTemplate smsEmailTemp = [Select Id,Name,HtmlValue From EmailTemplate Where Name = 'OC Receival Certificate SMS' Limit 1];
        EmailTemplate emailTemplateforWhatsapp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'New_CP_Registration_Through_Website' LIMIT 1];
        EmailTemplate emailTemplateforSMS = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS for New CP Registration' LIMIT 1];
        
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
        testUserRcd1.IsActive=true;
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        System.runAs(testUserRcd1){
            Test.startTest();
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account accountObject = new Account();
            accountObject.FirstName = 'test';
            accountObject.LastName = 'Account';
            accountObject.BillingCountry = 'India';
            accountObject.Phone = '455546565';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.PersonMobilePhone='123458988'; 
            accountObject.OwnerId = testUserRcd1.id;
            try{
                insert accountObject;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
            projectObject.Budgets__c = 'Under 75 lakhs';
            projectObject.Configuration__c ='1 BHK';
            projectObject.Project_Head__c = testUserRcd1.Id;
            projectObject.Site_Head__c = testUserRcd1.id;
            insert projectObject;
            
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            insert testCampRcd;
            
            
            
            List<Enquiry__c> enqList = new  List<Enquiry__c>();
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c=accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Google';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='2234565890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            testEnqRcd.stage__c='Interested';
            enqList.add(testEnqRcd);
            
            
            insert testEnqRcd;
            Enquiry__c enqForUpdate2=[Select Id,OwnerId,Stage__c,Site_Visit_Done_Date__c From Enquiry__c Where Id=:testEnqRcd.Id];            
            enqForUpdate2.OwnerId=testUserRcd1.Id;   
            enqForUpdate2.Stage__c='Contacted';
            try{
                update enqForUpdate2;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }
            Enquiry__c testEnqRcd1=new Enquiry__c();
            testEnqRcd1.Project__c=projectObject.Id;
            testEnqRcd1.Contact_Person__c=accountObject.Id;
            testEnqRcd1.Enquiry_Source__c='Google';
            // testEnqRcd1.Campaign__c=testCampRcd.Id;
            testEnqRcd1.Country_Code__c='+91';
            testEnqRcd1.Primary_Mobile_Number__c='2234565890';
            testEnqRcd1.OwnerId=testUserRcd1.Id;
            testEnqRcd1.Site_Visit_Scheduled_Date__c = system.now().addDays(5);
            testEnqRcd1.stage__c='Site Visit Scheduled';
            // enqList.add(testEnqRcd);
            insert testEnqRcd1;
            testEnqRcd1.Stage__c='Contacted';
            try{
                update testEnqRcd1;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }
            Test.stopTest();
        }
    }
}