@isTest
global class EnquiryService_Test {
    
    @isTest  
    static void EnquiryServiceTestMethod1()
    { 
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        User userObject = new User();
        userObject.CompanyName = 'TST Comp';
        userObject.LastName = 'last';
        userObject.Email = 'puser000@amamama.com';
        userObject.Username = 'puser000@amamama.com' + System.currentTimeMillis();
        userObject.Title = 'title';
        userObject.Alias = 'alias';
        userObject.TimeZoneSidKey = 'America/Los_Angeles';
        userObject.EmailEncodingKey = 'UTF-8';
        userObject.LanguageLocaleKey = 'en_US';
        userObject.LocaleSidKey = 'en_US';
        userObject.ProfileId = pf.Id;
        insert userObject;
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account accountObject= new Account(
            RecordTypeID=recordTypeId ,
            FirstName='Test FName',
            LastName='Test LName',
            PersonMailingStreet='test@yahoo.com',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail='test@yahoo.com',
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678' 
        );
        insert accountObject;
        
        list<project__c> ProjectList = new list<project__c>();
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = userObject.Id;
        projectObject.Site_Head__c = userObject.id;
        projectObject.OTP_Disable_Till__c = System.now().addDays(1);
        projectObject.Project_Header__c = 'abc.com';
        insert projectObject;
        ProjectList.add(projectObject);
        Enquiry__c enquiry = new Enquiry__c(Stage__c = 'Site Visit Scheduled',Site_Visit_Scheduled_Date__c=Date.today()+4,
                                            /* Channel_Partner__c=null,*/Contact_Person__c=accountObject.id,Project__c=projectObject.id,
                                            Enquiry_Source__c = 'Offline',Primary_Mobile_Number__c='1234125678');
        
        Map<String,String> enquiryMap1= new  Map<String,String>();
        Map<String,String> contactMap1= new  Map<String,String>();
        enquiryMap1.put('OwnerId',userObject.Id);
        enquiryMap1.put('Country_Code__c','+91');
        enquiryMap1.put('Contact_Person__c',accountObject.Id);
        //enquiryMap1.put('Channel_Partner__c',accountObject.Id);
        enquiryMap1.put('ProjectId',projectObject.Id);
        enquiryMap1.put('Site_Visit_Scheduled_Date__c','2025-05-27 10:10:10');
        enquiryMap1.put('Enquiry_Source__c','Offline');
        contactMap1.put('FirstName','fgb');
        contactMap1.put('LastName','dfgs');
        contactMap1.put('Country_Code__c','+91');
        contactMap1.put('PersonMobilePhone','1234125678');
        contactMap1.put('Email__c','testmanras122@gmail.com');
        
        
        
        EnquiryRequest enq = new EnquiryRequest();
        enq.contactMap = contactMap1;
        enq.enquiryMap = enquiryMap1;
        String myJSON = JSON.serialize(enq);    
        RestRequest req = new RestRequest(); 
        req.requestUri = 'https://java-enterprise-1915-dev-ed.lightning.force.com/services/apexrest/enquiry/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req; 
        
        Test.startTest();
        EnquiryResponse enqWrp= EnquiryService.doPost();
        Test.stopTest();
    }
    @isTest 
    static void EnquiryServiceTestMethod2()
    {
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        User userObject = new User();
        userObject.CompanyName = 'TST Comp';
        userObject.LastName = 'last';
        userObject.Email = 'puser000@amamama.com';
        userObject.Username = 'puser000@amamama.com' + System.currentTimeMillis();
        userObject.Title = 'title';
        userObject.Alias = 'alias';
        userObject.TimeZoneSidKey = 'America/Los_Angeles';
        userObject.EmailEncodingKey = 'UTF-8';
        userObject.LanguageLocaleKey = 'en_US';
        userObject.LocaleSidKey = 'en_US';
        userObject.ProfileId = pf.Id;
        insert userObject;
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account accountObject= new Account(
            RecordTypeID=recordTypeId ,
            FirstName='Test FName',
            LastName='Test LName',
            PersonMailingStreet='test@yahoo.com',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail='test@yahoo.com',
            PersonHomePhone='1234567',
            PersonMobilePhone='1234125678' 
        );
        
        insert accountObject;
         list<project__c> ProjectList = new list<project__c>();
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = userObject.Id;
        projectObject.Site_Head__c = userObject.id;
        projectObject.OTP_Disable_Till__c = System.now().addDays(1);
        projectObject.Project_Header__c = 'abc.com';
        insert projectObject;
        ProjectList.add(projectObject);
        Map<String,String> enquiryMap1= new  Map<String,String>();
        Map<String,String> contactMap1= new  Map<String,String>();
       enquiryMap1.put('OwnerId',userObject.Id);
        enquiryMap1.put('Country_Code__c','+91');
        enquiryMap1.put('Contact_Person__c',accountObject.Id);
        //enquiryMap1.put('Channel_Partner__c',accountObject.Id);
        enquiryMap1.put('Project__c',projectObject.Id);
        enquiryMap1.put('Enquiry_Source__c','Offline');
        contactMap1.put('FirstName','fgb');
        contactMap1.put('LastName','dfgs');
        contactMap1.put('Country_Code__c','+91');
        contactMap1.put('PersonMobilePhone','1234125678');
        contactMap1.put('Email__c','testmanras122@gmail.com');
        
        EnquiryRequest enq = new EnquiryRequest();
        enq.contactMap = contactMap1;
        enq.enquiryMap = enquiryMap1;
        String myJSON = JSON.serialize(enq);    
        RestRequest req = new RestRequest(); 
        req.requestUri = 'https://java-enterprise-1915-dev-ed.lightning.force.com/services/apexrest/enquiry/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req; 
        
        Test.startTest();
        EnquiryResponse enqWrp= EnquiryService.doPost();
        Test.stopTest();
    }
    
    @isTest  
    static void EnquiryServiceTestMethod3()
    { 
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        User userObject = new User();
        userObject.CompanyName = 'TST Comp';
        userObject.LastName = 'last';
        userObject.Email = 'puser000@amamama.com';
        userObject.Username = 'puser000@amamama.com' + System.currentTimeMillis();
        userObject.Title = 'title';
        userObject.Alias = 'alias';
        userObject.TimeZoneSidKey = 'America/Los_Angeles';
        userObject.EmailEncodingKey = 'UTF-8';
        userObject.LanguageLocaleKey = 'en_US';
        userObject.LocaleSidKey = 'en_US';
        userObject.ProfileId = pf.Id;
        insert userObject;
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account accountObject= new Account(
            RecordTypeID=recordTypeId ,
            FirstName='Test FName',
            LastName='Test LName',
            PersonMailingStreet='test@yahoo.com',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail='test@yahoo.com',
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678' 
        );
        insert accountObject;
        
        list<project__c> ProjectList = new list<project__c>();
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = userObject.Id;
        projectObject.Site_Head__c = userObject.id;
        projectObject.OTP_Disable_Till__c = System.now().addDays(1);
        projectObject.Project_Header__c = 'abc.com';
        insert projectObject;
        ProjectList.add(projectObject);        
        Enquiry__c enquiry = new Enquiry__c(Stage__c = 'Site Visit Scheduled',Site_Visit_Scheduled_Date__c=Date.today()+4,
                                            /* Channel_Partner__c=null,*/Contact_Person__c=accountObject.id,Project__c=projectObject.id,
                                            Enquiry_Source__c = 'Offline',Primary_Mobile_Number__c='12345678');
        insert enquiry;
        
        Map<String,String> enquiryMap1= new  Map<String,String>();
        Map<String,String> contactMap1= new  Map<String,String>();
        enquiryMap1.put('OwnerId',userObject.Id);
        enquiryMap1.put('Budget__c','15 Lakhs to 20 Lakhs');
        enquiryMap1.put('Project_Integration_Id__c','1');
        enquiryMap1.put('Contact_Person__c',accountObject.Id);
        //  enquiryMap1.put('Channel_Partner__c',accountObject.Id);
        //  enquiryMap1.put('Project__c',projectObject.Id);
        enquiryMap1.put('Enquiry_Source_1__c',null);
        contactMap1.put('FirstName','fgb');
        contactMap1.put('LastName','dfgs');
        contactMap1.put('PersonMobilePhone','12345678');
        contactMap1.put('PersonEmail','testmanras122@gmail.com');
        
        EnquiryRequest enq = new EnquiryRequest();
        enq.contactMap = contactMap1;
        enq.enquiryMap = enquiryMap1;
        String myJSON = JSON.serialize(enq);    
        RestRequest req = new RestRequest(); 
        req.requestUri = 'https://java-enterprise-1915-dev-ed.lightning.force.com/services/apexrest/enquiry/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req; 
        
        Test.startTest();
        EnquiryResponse enqWrp= EnquiryService.doPost();
        Test.stopTest();
    }
     @isTest  
    static void EnquiryServiceTestMethod4()
    { 
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        User userObject = new User();
        userObject.CompanyName = 'TST Comp';
        userObject.LastName = 'last';
        userObject.Email = 'puser000@amamama.com';
        userObject.Username = 'puser000@amamama.com' + System.currentTimeMillis();
        userObject.Title = 'title';
        userObject.Alias = 'alias';
        userObject.TimeZoneSidKey = 'America/Los_Angeles';
        userObject.EmailEncodingKey = 'UTF-8';
        userObject.LanguageLocaleKey = 'en_US';
        userObject.LocaleSidKey = 'en_US';
        userObject.ProfileId = pf.Id;
        insert userObject;
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account accountObject= new Account(
            RecordTypeID=recordTypeId ,
            FirstName='Test FName',
            LastName='Test LName',
            PersonMailingStreet='test@yahoo.com',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail='test@yahoo.com',
            PersonHomePhone='1234567',
            PersonMobilePhone='1234125678' 
        );
        insert accountObject;
        
        list<project__c> ProjectList = new list<project__c>();
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'divum@dynamixgroup.co.in';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = userObject.Id;
        projectObject.Site_Head__c = userObject.id;
        projectObject.OTP_Disable_Till__c = System.now().addDays(1);
        projectObject.Project_Header__c = 'abc.com';
        insert projectObject;
        ProjectList.add(projectObject);        
        Enquiry__c enquiry = new Enquiry__c(Stage__c = 'Site Visit Scheduled',Site_Visit_Scheduled_Date__c=Date.today()+4,
                                            /* Channel_Partner__c=null,*/Contact_Person__c=accountObject.id,Project__c=projectObject.id,
                                            Enquiry_Source__c = 'Offline',Primary_Mobile_Number__c='1234125678');
        insert enquiry;
        Task task = New Task();
        task.Date_and_Time_of_Site_Visit__c = system.now().addDays(2);
        task.Subject = 'Site Visit Scheduled';
        task.whatId = enquiry.id;
        task.ActivityDate =system.today();
        task.Status ='Scheduled';
        insert task;
        
        Map<String,String> enquiryMap1= new  Map<String,String>();
        Map<String,String> contactMap1= new  Map<String,String>();
       enquiryMap1.put('OwnerId',userObject.Id);
        enquiryMap1.put('Country_Code__c','+91');
        enquiryMap1.put('Contact_Person__c',accountObject.Id);
        enquiryMap1.put('Site_Visit_Scheduled_Date__c','2025-05-27 10:10:10');
        enquiryMap1.put('ProjectId',projectObject.Id);
        enquiryMap1.put('Enquiry_Source__c','Offline');
        contactMap1.put('FirstName','fgb');
        contactMap1.put('LastName','dfgs');
        contactMap1.put('Country_Code__c','+91');
        contactMap1.put('PersonMobilePhone','1234125678');
        contactMap1.put('Email__c','testmanras122@gmail.com');
        
        EnquiryRequest enq = new EnquiryRequest();
        enq.contactMap = contactMap1;
        enq.enquiryMap = enquiryMap1;
        String myJSON = JSON.serialize(enq);    
        RestRequest req = new RestRequest(); 
        req.requestUri = 'https://java-enterprise-1915-dev-ed.lightning.force.com/services/apexrest/enquiry/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req; 
        
        Test.startTest();
        EnquiryResponse enqWrp= EnquiryService.doPost();
        Test.stopTest();
    }
}