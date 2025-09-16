@isTest
public class SentSMSToCustomerForNewEnquiry_Test {
    @isTest
   static void testSentSMSToCustomerForNewEnquiryMethod() {
        List<Enquiry__c> enquiryList = new List<Enquiry__c>();
      
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
            accountObject.PersonMobilePhone='12345678'; 
            try{
                insert accountObject;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }            
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Phone__c = '9012332112';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Budgets__c= '70 - 80 L';
            projectObject.Configuration__c = '1 BHK;2.5 BHK';
            projectObject.Project_Link__c = 'https://dynamixgroup2--uatdynamix.sandbox.lightning.force.com/lightning/r/Project__c/'+ProjectObject.Id+'/view?ws=%2Flightning%2Fr%2FEnquiry__c%2Fa0nFf000000AGbNIAW%2Fview';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK;600 - 2 BHK;900 - 3 BHk';
            insert projectObject;
            
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            insert testCampRcd;
            
            EmailTemplate testemailtemplate = new EmailTemplate(  
            Name = 'Send New Lead SMS To Customer',
            Subject = 'Test Subject',
            DeveloperName = 'Send_New_Lead_SMS_To_Customer',
            TemplateType = 'Text' ,
            FolderId = UserInfo.getUserId(),
            isActive = true
            );
            insert testemailtemplate;
          
            
            Test.startTest();
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c=accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Google';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c ='1234567890';
            testEnqRcd.Project_Name__c = 'abc';
            testEnqRcd.Send_SMS__c = True;
            testEnqRcd.OwnerId=testUserRcd1.Id;
            enquiryList.add(testEnqRcd);
            insert enquiryList;
            
            
             /*try{
                insert testEnqRcd;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }*/
            
            enquiryList.add(testEnqRcd);
            SentSMSToCustomerForNewEnquiry.SentSMSToCustomerForNewEnquiryMethod(enquiryList);
            Test.stopTest();
        }
    }
   @isTest
    static void testSentSMSInCaseOfCallMethod() {
        List<Enquiry__c> enquiryList = new List<Enquiry__c>();
        
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
            accountObject.PersonMobilePhone='12345678'; 
            try{
                insert accountObject;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }            
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Budgets__c= '70 - 80 L';
            projectObject.Project_Phone__c = '9012332112';
            projectObject.Configuration__c = '1 BHK;2.5 BHK';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK;600 - 2 BHK;900 - 3 BHk';
            projectObject.Project_Link__c = 'https://dynamixgroup2--uatdynamix.sandbox.lightning.force.com/lightning/r/Project__c/'+ProjectObject.Id+'/view?ws=%2Flightning%2Fr%2FEnquiry__c%2Fa0nFf000000AGbNIAW%2Fview';
            insert projectObject;
            
            Campaign testCampRcd=new Campaign();
            testCampRcd.Name='test Campaign';
            testCampRcd.Project__c=projectObject.Id;
            testCampRcd.Source__c='Google';
            testCampRcd.StartDate=System.today();
            testCampRcd.EndDate=System.today()+15;
            testCampRcd.ActualCost=2500000;
            insert testCampRcd;
            
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c=accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Google';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c ='1234567890';
            testEnqRcd.Project_Name__c = 'abc';
            testEnqRcd.Send_SMS__c = True;
            testEnqRcd.OwnerId=testUserRcd1.Id;
            enquiryList.add(testEnqRcd);
            insert enquiryList;
            
            Test.startTest();
            List<Task> taskList = new List<Task>();
            Task task = new Task();
            task.Subject = 'Call';
            task.Exotel_CTI__Call_Direction__c = 'Inbound';
            task.WhatId = testEnqRcd.Id;
            task.OwnerId	=testUserRcd1.Id;
            task.Priority ='Normal';
            task.Exotel_CTI__Leg2_Status__c = 'canceled';
            task.Status ='Open';
            task.ActivityDate= System.today();
            taskList.add(task);
            //insert taskList;
        

        Test.stopTest();
        }
        
    }
    @isTest
    static void testSentSMSInCaseOfMissedCall() {
        List<Enquiry__c> enquiryList = new List<Enquiry__c>();
        
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
            accountObject.PersonMobilePhone='12345678'; 
            try{
                insert accountObject;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }            
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Project_Link__c= 'www.gmail.com';
            projectObject.Budgets__c= '70 - 80 L';
            projectObject.Configuration__c = '1 BHK;2.5 BHK';
            projectObject.Project_Phone__c = '9012332112';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK;600 - 2 BHK;900 - 3 BHk';
            projectObject.Project_Link__c = 'https://dynamixgroup2--uatdynamix.sandbox.lightning.force.com/lightning/r/Project__c/'+ProjectObject.Id+'/view?ws=%2Flightning%2Fr%2FEnquiry__c%2Fa0nFf000000AGbNIAW%2Fview';
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
            testEnqRcd.Project_Name__c = 'abc';
            testEnqRcd.Send_SMS__c = True;
             testEnqRcd.Primary_Mobile_Number__c='1234567890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            enquiryList.add(testEnqRcd);
            
               
            EmailTemplate testemailtemplate = new EmailTemplate(  
            Name = 'SMS For a Missed Call form an Existing Enquiry',
            Subject = 'Test Subject',
            DeveloperName = 'SMS_For_a_Missed_Call_for_an_Existing_Enquiry',
            TemplateType = 'Text' ,
            FolderId = UserInfo.getUserId(),
            isActive = true
            );
            insert testemailtemplate;
            
            insert enquiryList;
            
            List<Task> taskList = new List<Task>();
            Task task = new Task();
            Task.Subject = 'Missed Call';
            task.Exotel_CTI__Call_Direction__c = 'Inbound';
            task.WhatId = testEnqRcd.Id;
            task.Exotel_CTI__Leg2_Status__c = 'canceled';
            task.OwnerId	=testUserRcd1.Id;
            task.Priority ='Normal';
            task.Status ='Open';
            task.ActivityDate= System.today();
            taskList.add(task);
            //insert taskList;
            
            Task task1 = new Task();
            Task1.Subject = 'Incoming Call';
            task1.Exotel_CTI__Call_Direction__c = 'Inbound';
            task1.WhatId = testEnqRcd.Id;
            task1.Exotel_CTI__Leg2_Status__c = 'canceled';
            task1.OwnerId	=testUserRcd1.Id;
            task1.Priority ='Normal';
            task1.Status ='Open';
            task1.ActivityDate= System.today();
            taskList.add(task1);
            
            Task task2 = new Task();
            Task2.Subject = 'Call';
            task2.Exotel_CTI__Call_Direction__c = 'Inbound';
            task2.WhatId = testEnqRcd.Id;
            task2.Exotel_CTI__Leg2_Status__c = 'canceled';
            task2.OwnerId	=testUserRcd1.Id;
            task2.Priority ='Normal';
            task2.Status ='Open';
            task2.ActivityDate= System.today();
            taskList.add(task2);
            insert taskList;
            SentSMSToCustomerForNewEnquiry.SentSMSInCaseOfMissedCall(taskList);
            Test.stopTest();
        }
        
    }
     @isTest
    static void testSentSMSInCaseOfIncomingCall() {
        List<Enquiry__c> enquiryList = new List<Enquiry__c>();
        
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
            accountObject.PersonMobilePhone='12345678'; 
            try{
                insert accountObject;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }            
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Budgets__c= '70 - 80 L';
            projectObject.Configuration__c = '1 BHK;2.5 BHK';
            projectObject.Project_Phone__c = '9012332112';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK;600 - 2 BHK;900 - 3 BHk';
            projectObject.Project_Link__c = 'https://dynamixgroup2--uatdynamix.sandbox.lightning.force.com/lightning/r/Project__c/'+ProjectObject.Id+'/view?ws=%2Flightning%2Fr%2FEnquiry__c%2Fa0nFf000000AGbNIAW%2Fview';
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
            testEnqRcd.Primary_Mobile_Number__c ='1234567890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            testEnqRcd.Project_Name__c = 'abc';
            testEnqRcd.Send_SMS__c = True;
            enquiryList.add(testEnqRcd);
            insert enquiryList;
            
            List<Task> taskList = new List<Task>();
            Task task = new Task();
            task.Subject = 'Incoming Call';
            task.Exotel_CTI__Call_Direction__c = 'Inbound';
            task.WhatId = testEnqRcd.Id;
            task.Exotel_CTI__Leg2_Status__c = 'canceled';
            task.OwnerId	=testUserRcd1.Id;
            task.Priority ='Normal';
            task.Status ='Open';
            task.ActivityDate= System.today();
            taskList.add(task);
            insert taskList;
            
            
           SentSMSToCustomerForNewEnquiry.SentSMSInCaseOfMissedCall(taskList);
            Test.stopTest();
        }
        
    }
         @isTest
    static void testSentSMSInCaseOfOutgoingCall() {
        List<Enquiry__c> enquiryList = new List<Enquiry__c>();
        
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
            accountObject.PersonMobilePhone='12345678'; 
            try{
                insert accountObject;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }            
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Test Project';
            projectObject.Project_Email__c= 'mayur.patel@manras.com';
            projectObject.Budgets__c = '70 - 80 L';
            projectObject.Project_Phone__c = '9012332112';
            projectObject.Configuration__c = '1 BHK;2.5 BHK';
            projectObject.Project_Carpet_Area__c = '475 - 1 BHK;600 - 2 BHK;900 - 3 BHk';
            projectObject.Project_Link__c = 'https://dynamixgroup2--uatdynamix.sandbox.lightning.force.com/lightning/r/Project__c/'+ProjectObject.Id+'/view?ws=%2Flightning%2Fr%2FEnquiry__c%2Fa0nFf000000AGbNIAW%2Fview';
            insert projectObject;
            
             Project__c projectObject1 = new Project__c();
            projectObject1.Name = 'Test Project';
            projectObject1.Project_Email__c= 'mayur.patel@manras.com';
            projectObject1.Budgets__c = '70 - 80 L';
            projectObject1.Project_Phone__c = '9012332112';
            projectObject1.Configuration__c = '1 BHK;2.5 BHK';
            projectObject1.Project_Carpet_Area__c = '475 - 1 BHK;600 - 2 BHK;900 - 3 BHk';
            projectObject1.Project_Link__c = 'https://dynamixgroup2--uatdynamix.sandbox.lightning.force.com/lightning/r/Project__c/'+ProjectObject.Id+'/view?ws=%2Flightning%2Fr%2FEnquiry__c%2Fa0nFf000000AGbNIAW%2Fview';
            insert projectObject1;
            
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
            testEnqRcd.Primary_Mobile_Number__c ='1234567890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            testEnqRcd.Project_Name__c = projectObject.Name;
            testEnqRcd.Send_SMS__c = True;
            enquiryList.add(testEnqRcd);
            insert enquiryList;
            testEnqRcd.id= enquiryList[0].id;
            testEnqRcd.Project__c =projectObject1.id;
            update testEnqRcd;
            
               
            EmailTemplate testemailtemplate = new EmailTemplate(  
            Name = 'SMS Sent Customer Missed the Call',
            Subject = 'Test Subject',
            DeveloperName = 'SMS_Sent_Customer_Missed_the_Call',
            TemplateType = 'Text' ,
            FolderId = UserInfo.getUserId(),
            Body = testEnqRcd.Project_Name__c,
            isActive = true
            );
            insert testemailtemplate;
            
            List<Task> taskList = new List<Task>();
            Task task = new Task();
            Task.Subject = 'Outgoing Call 9090909';
            task.Exotel_CTI__Call_Direction__c = 'Outbound';
            task.Exotel_CTI__Call_Duration__c ='00:00:00';
            task.WhatId = testEnqRcd.Id;
            task.OwnerId =testUserRcd1.Id;
            task.Priority ='Normal';
            task.Exotel_CTI__Leg2_Status__c ='canceled' ;
            task.Status ='Open';
            task.ActivityDate= System.today();
            taskList.add(task);
            insert taskList;
            SentSMSToCustomerForNewEnquiry.SentSMSInCaseOfMissedCall(taskList);
            Test.stopTest();
        }
        
    }
    
}