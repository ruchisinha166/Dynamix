@isTest
public class ContentVersionTriggerHandler_Test {
    @isTest
    public static void Method1(){ 
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
        
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        
        Account accountObject = new Account();
        accountObject.Name = 'Channel Partner';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '4555465655';
        accountObject.RecordTypeId = PersonRecId;
        accountObject.Email__c = 'dynamix.project@gmail.com';
        accountObject.Rera_Certificate_Upload__c = true;
        insert accountObject;
        
        Attachment attach1=new Attachment();   	
        attach1.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach1.body=bodyBlob;
        attach1.parentId=accountObject.id;
        attach1.OwnerId = testUserRcd1.Id;
        insert attach1;
        
        Attachment attach =[select id, name,OwnerId,Body,ParentId from Attachment where parent.id=:accountObject.id];
        
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; 
        cVersion.Origin = 'H';
        cVersion.PathOnClient = attach.Name;
        cVersion.Title = attach.Name;
        cVersion.VersionData = attach.Body;
        cVersion.Document_Type__c = 'Rera Certificate';
        cVersion.SObjectType__c = 'Account';
        cVersion.Title = 'Rera';
        cVersion.FirstPublishLocationId = accountObject.Id;
        Insert cVersion;
        
         Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'nishi@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='3 BHK';
        projectObject.GPS_location__c = 'www.testLocation.com';
        projectObject.Project_Phone__c = '9090123567';
        //projectObject.FM_Head__c = testUserRcd1.id;
        insert projectObject;
        
        ContentVersion snagContentVersion = new ContentVersion();
        snagContentVersion.ContentLocation = 'S'; 
        snagContentVersion.Origin = 'H';
        snagContentVersion.PathOnClient = attach.Name;
        snagContentVersion.Title = attach.Name;
        snagContentVersion.VersionData = attach.Body;
        snagContentVersion.Title = 'Rera';
        snagContentVersion.FirstPublishLocationId = projectObject.Id;
        Insert snagContentVersion;
        
        snagContentVersion.Document_Type__c = 'Intimation of Completion of Unit Check';
        snagContentVersion.SObjectType__c = 'Project__c';
        update snagContentVersion;
        
        
        System.debug('cVersion'+cVersion.Id);
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
        System.debug('conDocId'+conDocId);
        
        Test.startTest();
        List<ContentVersion> cVersion1 = [Select ID From ContentVersion Where Document_Type__c = 'Rera Certificate' limit 1];
        ContentVersionTriggerHandler.ReraCertificateDocumentsUploadedCheckbox(cVersion1);
        Test.stopTest();
        
    }
    @isTest
    public static void Method2(){ 
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
        
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        
        Account accountObject = new Account();
        accountObject.Name = 'Channel Partner';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '4555465655';
        accountObject.RecordTypeId = PersonRecId;
        accountObject.Email__c = 'dynamix.project@gmail.com';
        accountObject.Rera_Certificate_Upload__c = true;
        insert accountObject;
        
        Attachment attach1=new Attachment();   	
        attach1.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach1.body=bodyBlob;
        attach1.parentId=accountObject.id;
        attach1.OwnerId = testUserRcd1.Id;
        insert attach1;
        
        Attachment attach =[select id, name,OwnerId,Body,ParentId from Attachment where parent.id=:accountObject.id];
        
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; 
        cVersion.Origin = 'H';
        cVersion.PathOnClient = attach.Name;
        cVersion.Title = attach.Name;
        cVersion.VersionData = attach.Body;
        cVersion.Document_Type__c = 'Rera Certificate';
        cVersion.SObjectType__c = 'Account';
        cVersion.Title = 'Rera';
        cVersion.FirstPublishLocationId = accountObject.Id;
        Insert cVersion;
        
         Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'nishi@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='3 BHK';
        projectObject.GPS_location__c = 'www.testLocation.com';
        projectObject.Project_Phone__c = '9090123567';
        //projectObject.FM_Head__c = testUserRcd1.id;
        insert projectObject;
        
        ContentVersion snagContentVersion = new ContentVersion();
        snagContentVersion.ContentLocation = 'S'; 
        snagContentVersion.Origin = 'H';
        snagContentVersion.PathOnClient = attach.Name;
        snagContentVersion.Title = attach.Name;
        snagContentVersion.VersionData = attach.Body;
        snagContentVersion.Title = 'Rera';
        snagContentVersion.FirstPublishLocationId = projectObject.Id;
        Insert snagContentVersion;
        
        snagContentVersion.Document_Type__c = 'EOI Terms & Conditions';
        snagContentVersion.SObjectType__c = 'Project__c';
        update snagContentVersion;
        
        
        System.debug('cVersion'+cVersion.Id);
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
        System.debug('conDocId'+conDocId);
        
        Test.startTest();
        List<ContentVersion> cVersion1 = [Select ID From ContentVersion Where Document_Type__c = 'Rera Certificate' limit 1];
        ContentVersionTriggerHandler.ReraCertificateDocumentsUploadedCheckbox(cVersion1);
        Test.stopTest();
        
    }
    
    @isTest
    public static void Method3(){ 
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
        
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        
        Account accountObject = new Account();
        accountObject.Name = 'Channel Partner';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '4555465655';
        accountObject.RecordTypeId = PersonRecId;
        accountObject.Email__c = 'dynamix.project@gmail.com';
        accountObject.Rera_Certificate_Upload__c = true;
        insert accountObject;
        
        Attachment attach1=new Attachment();   	
        attach1.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach1.body=bodyBlob;
        attach1.parentId=accountObject.id;
        attach1.OwnerId = testUserRcd1.Id;
        insert attach1;
        
        Attachment attach =[select id, name,OwnerId,Body,ParentId from Attachment where parent.id=:accountObject.id];
        
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; 
        cVersion.Origin = 'H';
        cVersion.PathOnClient = attach.Name;
        cVersion.Title = attach.Name;
        cVersion.VersionData = attach.Body;
        cVersion.Document_Type__c = 'Rera Certificate';
        cVersion.SObjectType__c = 'Account';
        cVersion.Title = 'Rera';
        cVersion.FirstPublishLocationId = accountObject.Id;
        Insert cVersion;
        
         Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'nishi@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='3 BHK';
        projectObject.GPS_location__c = 'www.testLocation.com';
        projectObject.Project_Phone__c = '9090123567';
        //projectObject.FM_Head__c = testUserRcd1.id;
        insert projectObject;
        
        ContentVersion snagContentVersion = new ContentVersion();
        snagContentVersion.ContentLocation = 'S'; 
        snagContentVersion.Origin = 'H';
        snagContentVersion.PathOnClient = attach.Name;
        snagContentVersion.Title = attach.Name;
        snagContentVersion.VersionData = attach.Body;
        snagContentVersion.Title = 'Rera';
        snagContentVersion.FirstPublishLocationId = projectObject.Id;
        Insert snagContentVersion;
        
        snagContentVersion.Document_Type__c = 'CA Terms & Conditions';
        snagContentVersion.SObjectType__c = 'Project__c';
        update snagContentVersion;
        
        
        System.debug('cVersion'+cVersion.Id);
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
        System.debug('conDocId'+conDocId);
        
        Test.startTest();
        List<ContentVersion> cVersion1 = [Select ID From ContentVersion Where Document_Type__c = 'Rera Certificate' limit 1];
        ContentVersionTriggerHandler.ReraCertificateDocumentsUploadedCheckbox(cVersion1);
        Test.stopTest();
        
    }
    
    @isTest
    public static void cancellationDeedTest(){
        Profile p1=[SELECT Id From Profile WHERE Name='Post Sales'];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User u2 =new User( Alias = uniqueName.substring(18, 23),
                          Email = uniqueName + '@test' + orgId + '.org',
                          EmailEncodingKey = 'UTF-8',
                          LastName = 'Testing',
                          Username = uniqueName + '@test' + orgId + '.org',
                          LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US',
                          ProfileId=p1.Id,
                          TimeZoneSidKey = 'America/Los_Angeles');
        insert u2;
        
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
        accountObject.PAN_No__pc = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.PersonMobilePhone ='8989898989';
        insert accountObject;
        
        Project__c projObj = new Project__c();
        projObj.Name = 'test project';
        projObj.Last_Invoice_Number__c = 1;
        projobj.Post_Sales_Head__c = u2.Id;
        projobj.Budgets__c = 'above 3.5 crs';
        projobj.Configuration__c = '1 BHK';
        projobj.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        insert projObj;
        
        Test.startTest();
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Walk_in_Source__c = 'Channel Partner';
        oppoObject.Project__c = projObj.Id;
        oppoObject.OwnerId = u2.Id;
        insert oppoObject;
        
        Booking__c bookingObject = new Booking__c();
        bookingObject.Stage__c = 'Draft';
        bookingObject.Registration_Status__c = 'Not Started';
        bookingObject.Sales_Manager__c = oppoObject.OwnerId;
        bookingObject.Related_Opportunity__c = oppoObject.id;
        insert bookingObject;
        
        ContentVersion cancellationDeedDocument = new ContentVersion();
        cancellationDeedDocument.ContentLocation = 'S'; 
        cancellationDeedDocument.Origin = 'H';
        cancellationDeedDocument.PathOnClient = 'PDF';
        cancellationDeedDocument.VersionData = Blob.valueOf('qwerty');
        cancellationDeedDocument.Title = 'Cancellation Deed';
        cancellationDeedDocument.FirstPublishLocationId = bookingObject.Id;
        cancellationDeedDocument.SObjectType__c = 'Booking__c';
        cancellationDeedDocument.Document_Type__c = 'Cancellation Deed';
        Insert cancellationDeedDocument;
        cancellationDeedDocument.Title = 'Cancellation Deed Updated';
        update cancellationDeedDocument;
    }
}