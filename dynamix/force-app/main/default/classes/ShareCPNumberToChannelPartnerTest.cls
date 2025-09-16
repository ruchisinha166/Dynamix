@isTest
private class ShareCPNumberToChannelPartnerTest {
    @isTest
    static void testShareCPNumberToChannelPartnerMethod() {
        EmailTemplate emailTemplateforSMS = [SELECT Id, Name, Subject, HtmlValue, Body, DeveloperName 
                                             FROM EmailTemplate 
                                             WHERE Name = 'SMS for New CP Registration' 
                                             LIMIT 1];
        
        EmailTemplate emailTemplateforWhatsapp = [SELECT Id, Name, Subject, HtmlValue, Body, DeveloperName 
                                                  FROM EmailTemplate 
                                                  WHERE DeveloperName = 'New_CP_Registration_Through_Website' 
                                                  LIMIT 1];
        communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,
                                                                 communicat_o__External_Template_Id__c
                                                                 From communicat_o__Registered_Template__mdt
                                                                 Where QualifiedApiName=: 'New_CP_Registration_Through_Website' Limit 1];
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        RecordType channelPartnerRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Channel Partner' LIMIT 1];
        
        List<User> user = new List<User>();
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
        user.add(testUserRcd1);
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'mayur.patel@manras.com';
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='1 BHK';
        projectObject.Project_Head__c = testUserRcd1.Id;
        projectObject.Site_Head__c = testUserRcd1.id;
        insert projectObject;
        
        Account testAcc = new Account();
        testAcc.Name = 'Channel Partner Account1';
        testAcc.BillingCountry = 'India';
        testAcc.Phone = '4569825678';
        testAcc.Email__c = 'tanu@manras.com';
        testAcc.OwnerId = testUserRcd1.Id;
        testAcc.RERA_Number__c = null;
        testAcc.RecordTypeId = channelPartnerRecordType.Id;
        insert testAcc;
        
        Channel_Partner_Project__c cpProject = new Channel_Partner_Project__c();
        cpProject.Channel_Partner__c = testAcc.Id;
        cpProject.Project__c = projectObject.Id;
        insert cpProject;
        
        
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        EmailMessage TestObjEmailMessage = new EmailMessage();
        TestObjEmailMessage.status = '3'; // email was sent
        TestObjEmailMessage.RelatedToId =cpProject.Id ;
        TestObjEmailMessage.fromName = 'Dynamix'; // from name
        TestObjEmailMessage.Subject = 'Whatsapp sent to CP for Registration';
        // TestObjEmailMessage.HtmlBody = plainBodyforWhatsapp;
        insertEmailMessageList.add(TestObjEmailMessage);
        
        
        ShareCPNumberToChannelPartner.requestWrapper testRequestWrapper = new ShareCPNumberToChannelPartner.requestWrapper();
        testRequestWrapper.CPUniqueNumber = 'TestUniqueNumber';
        testRequestWrapper.cpId = testAcc.Id;
        testRequestWrapper.cpPhoneNumber = '1234567890';
        testRequestWrapper.cpEmail = 'test@example.com';
        
        List<ShareCPNumberToChannelPartner.requestWrapper> testWrapperList = new List<ShareCPNumberToChannelPartner.requestWrapper>();
        testWrapperList.add(testRequestWrapper);
        
        // Execute the method under test
        Test.startTest();
        ShareCPNumberToChannelPartner.ShareCPNumberToChannelPartnerMethod(testWrapperList);
        Test.stopTest();
        
        /*List<EmailMessage> createdEmailMessages = [SELECT Id, Status, RelatedToId, FromName, Subject, HtmlBody 
                                                   FROM EmailMessage 
                                                   WHERE RelatedToId = :cpProject.Id 
                                                   AND Subject = 'Whatsapp sent to CP for Registration' 
                                                   LIMIT 1];
        System.assertEquals(1, createdEmailMessages.size(), 'Expected one EmailMessage to be created');
        
        EmailMessage createdEmailMessage = createdEmailMessages[0];
        System.assertEquals('3', createdEmailMessage.Status, 'EmailMessage status should be 3');
        System.assertEquals('Dynamix', createdEmailMessage.FromName, 'Incorrect from name');
        System.assertEquals('Whatsapp sent to CP for Registration', createdEmailMessage.Subject, 'Incorrect subject');
        System.assertEquals('Expected HTML body', createdEmailMessage.HtmlBody, 'Incorrect HTML body');
        // Verify the count of EmailMessages created for the given cpId
        Integer expectedEmailCount = 3; 
        Integer actualEmailCount = [SELECT COUNT() FROM EmailMessage WHERE RelatedToId = :testRequestWrapper.cpId];*/
    }
}