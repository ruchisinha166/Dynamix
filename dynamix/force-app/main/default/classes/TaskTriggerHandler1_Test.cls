@isTest
public class TaskTriggerHandler1_Test {
    @isTest
    public static void testTaskTriggerHandler1Method(){
        
        List<BusinessHours> bhs=[select id from BusinessHours where IsDefault=true];
        System.assert(bhs.size()==1);
        List<Task> task=[select id from Task];
        System.assert(task.size()==0);

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
            accountObject.PersonEmail = 'tanu321@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.PersonMobilePhone='123456786'; 
            insert accountObject;
            
            
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
            
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c=accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Google';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='1234567890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            insert testEnqRcd;
            
            test.startTest();
            Task thisTask = New Task();
            thisTask.subject = 'Outgoing Call';
            thisTask.WhatId = testEnqRcd.id;
            insert thisTask;
            
            Task thisTask1 = New Task();
            thisTask1.subject = 'Missed Call';
            thisTask1.WhatId = testEnqRcd.id;
            insert thisTask1;
            
            Task thisTask2 = New Task();
            thisTask2.subject = 'test';
            thisTask2.WhatId = testEnqRcd.id;
            try{
                insert thisTask2;
            }catch(exception ex)
            {
                
            }
            test.stopTest();
            
        }
    }
    @isTest
    public static void eTestMethod7(){
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
            accountObject.PersonMobilePhone='123456'; 
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
            testEnqRcd.Enquiry_Source__c='Hoarding';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='7894567890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            
            Enquiry__c testEnqRcd1=new Enquiry__c();
            testEnqRcd1.Campaign__c = testCampRcd.Id;
            testEnqRcd1.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='7894567890';
            try{
               // insert testEnqRcd;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }
            
            List<Task> taskList = new List<Task>();
            Task task2 = new Task();
            task2.WhatId = testEnqRcd.Id;
            task2.Exotel_CTI__Virtual_Number__c = '02241598344';
           
            Test.stopTest();
            
        }
    }
     @isTest
    public static void Primarymobilenull(){
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
            accountObject.Phone = '7894567890';
            accountObject.RecordTypeId = PersonRecId;
            accountObject.PersonEmail = 'dynamix.project@gmail.com';
            accountObject.Aadhar_No__pc = '458785698547';
            accountObject.PAN_No__c = 'ABCTY1234D';
            accountObject.Aadhar_Uploaded__pc = true;
            accountObject.PAN_Card_Uploaded__pc = true;
            accountObject.Upload_PAN_Card__c=true;
            accountObject.PersonMobilePhone='7894567890'; 
            insert accountObject;
            
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
             insert testCampRcd;
            
            Test.startTest();
            Enquiry__c testEnqRcd=new Enquiry__c();
            testEnqRcd.Project__c=projectObject.Id;
            testEnqRcd.Contact_Person__c=accountObject.Id;
            testEnqRcd.Enquiry_Source__c='Hoarding';
            testEnqRcd.Campaign__c=testCampRcd.Id;
            testEnqRcd.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='7894567890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            
            Enquiry__c testEnqRcd1=new Enquiry__c();
            testEnqRcd1.Campaign__c = testCampRcd.Id;
            testEnqRcd1.Country_Code__c='+91';
            testEnqRcd.Primary_Mobile_Number__c='7894567890';
            try{
               // insert testEnqRcd;
            }
            catch(Exception e){
                System.debug('Exception:'+e);
            }
            
            List<Task> taskLists = new List<Task>();
            Task task1 = new Task();
            task1.WhatId = testEnqRcd.Id;
            TaskTriggerHandler1.method();
            
            TaskTriggerHandler1.setAndValidateDueDate(taskLists);
            Test.stopTest();
            
        }
    }
}