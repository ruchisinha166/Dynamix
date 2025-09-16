@istest
public class OpportunityServiceTest {
    
    @istest static void OpportunityServiceTestMethod()
    {
        map<string,string> accountMap = new map<string,string>();
        map<string,string> opportunityMap = new map<string,string>();
        Id ChannelPartnerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
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
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'test project';
        projectObject.Project_Id__c = '8';
        insert projectObject;
        
         accountMap.put('LastName','test 1545 ');
         accountMap.put('PersonMobilePhone','9671208382');
         accountMap.put('Gender__pc','female');
         accountMap.put('Age__c','31-35');
         accountMap.put('Ethnicity__pc','Muslim');
         accountMap.put('Occupation__pc','Business');
         accountMap.put('Anniversary_date__c','3/3/2021');
         accountMap.put('Is_This_Your_First_Home__c','false');
         accountMap.put('Annual_Income__pc','500000');
         
         
        
         opportunityMap.put('Name','test 1545 ');
         opportunityMap.put('CloseDate','1/6/2021');
         opportunityMap.put('StageName','Site Visit');
         opportunityMap.put('Interested_Property_Type__c','1 RK;1 BHK');
         opportunityMap.put('Preferred_Size_of_Unit_in_sq_ft__c','100');
         opportunityMap.put('Preferred_Floor__c','4');
         opportunityMap.put('Source__c','google');
         opportunityMap.put('Possession_In__c','Less than 1 Year;1-2 Years');
         opportunityMap.put('Decision_Maker_Visited__c','true');
         opportunityMap.put('Project_id','8');
         opportunityMap.put('OwnerId',string.valueOf(userObject.Email));
        
        
        opportunityRequest opp = new opportunityRequest();
        opp.accountMap = accountMap;
        opp.opportunityMap = opportunityMap;
        String myJSON = JSON.serialize(opp);   
        RestRequest req = new RestRequest(); 
        req.requestUri = '/services/apexrest/opportunity/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        
        Test.startTest();
        opportunityResponse oppreq = OpportuntiyService.doPost();
        system.assertEquals(oppreq.opportunityData.StageName,'Site Visit');
        Test.stopTest();
        
    }
    
     @istest static void OpportunityServiceTestMethod2()
    {
        map<string,string> accountMap = new map<string,string>();
        map<string,string> opportunityMap = new map<string,string>();
        Id ChannelPartnerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
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
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'test project';
        projectObject.Project_Id__c = '8';
        insert projectObject;
        
         accountMap.put('LastName','test 1545 ');
         accountMap.put('PersonMobilePhone','9671208382');
         accountMap.put('Gender__pc','female');
         accountMap.put('Age__c','31-35');
         accountMap.put('Ethnicity__pc','Muslim');
         accountMap.put('Occupation__pc','Business');
         accountMap.put('Anniversary_date__c','16/3/2021');
         accountMap.put('Is_This_Your_First_Home__c','false');
         accountMap.put('Annual_Income__pc','500000');
         accountMap.put('CP_Name__c','test test123');
         accountMap.put('CP_Number__c','9671204578');
         
         
        
         opportunityMap.put('Name','test 1545 ');
         opportunityMap.put('CloseDate','1/6/2021');
         opportunityMap.put('StageName','Site Visit');
         opportunityMap.put('Interested_Property_Type__c','1 RK;1 BHK');
         opportunityMap.put('Preferred_Size_of_Unit_in_sq_ft__c','100');
         opportunityMap.put('Preferred_Floor__c','4');
         opportunityMap.put('Source__c','Channel Partner');
         opportunityMap.put('Possession_In__c','Less than 1 Year;1-2 Years');
         opportunityMap.put('Decision_Maker_Visited__c','true');
         opportunityMap.put('Project_id','8');
         opportunityMap.put('OwnerId',string.valueOf(userObject.Email));
        
        
        opportunityRequest opp = new opportunityRequest();
        opp.accountMap = accountMap;
        opp.opportunityMap = opportunityMap;
        String myJSON = JSON.serialize(opp);   
        RestRequest req = new RestRequest(); 
        req.requestUri = '/services/apexrest/opportunity/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        
        Test.startTest();
        opportunityResponse oppreq = OpportuntiyService.doPost();
        system.assertEquals(oppreq.opportunityData.StageName,'Site Visit');
        Test.stopTest();
        
    }
     @istest static void OpportunityServiceTestMethod3()
    {
        map<string,string> accountMap = new map<string,string>();
        map<string,string> opportunityMap = new map<string,string>();
        Id ChannelPartnerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
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
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'test project';
        projectObject.Project_Id__c = '8';
        insert projectObject;
        
         accountMap.put('LastName','');
         accountMap.put('PersonEmail','');
         accountMap.put('PersonMobilePhone','9671208382');
         accountMap.put('Gender__pc','female');
         accountMap.put('Age__c','31-35');
         accountMap.put('Ethnicity__pc','Muslim');
         accountMap.put('Occupation__pc','Business');
         accountMap.put('Anniversary_date__c','16/3/2021');
         accountMap.put('Is_This_Your_First_Home__c','false');
         accountMap.put('Annual_Income__pc','500000');
         accountMap.put('CP_Name__c','test test123');
         accountMap.put('CP_Number__c','9671204578');
         
         
        
         opportunityMap.put('Name','');
         opportunityMap.put('CloseDate','');
         opportunityMap.put('StageName','Site Visit');
         opportunityMap.put('Interested_Property_Type__c','1 RK;1 BHK');
         opportunityMap.put('Preferred_Size_of_Unit_in_sq_ft__c','100');
         opportunityMap.put('Preferred_Floor__c','');
         opportunityMap.put('Possession_In__c','Less than 1 Year;1-2 Years');
         opportunityMap.put('Decision_Maker_Visited__c','true');
         opportunityMap.put('Project_id','8');
         opportunityMap.put('OwnerId',string.valueOf(userObject.Email));
        
        
        opportunityRequest opp = new opportunityRequest();
        opp.accountMap = accountMap;
        opp.opportunityMap = opportunityMap;
        String myJSON = JSON.serialize(opp);   
        RestRequest req = new RestRequest(); 
        req.requestUri = '/services/apexrest/opportunity/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        
        Test.startTest();
        opportunityResponse oppreq = OpportuntiyService.doPost();
        system.assertEquals(oppreq.Status,'error');
        Test.stopTest();
        
    }
    
    @istest static void OpportunityServiceTestMethod4()
    {
        map<string,string> accountMap = new map<string,string>();
        map<string,string> opportunityMap = new map<string,string>();
        Id ChannelPartnerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
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
        
        Project__c projectObject = new Project__c();
        projectObject.Name = 'test project';
        projectObject.Project_Id__c = '8';
        insert projectObject;
        
         accountMap.put('LastName','');
         accountMap.put('PersonEmail','');
         accountMap.put('PersonMobilePhone','9671208382');
         accountMap.put('Gender__pc','female');
         accountMap.put('Age__c','31-35');
         accountMap.put('Ethnicity__pc','Muslim');
         accountMap.put('Occupation__pc','Business');
         accountMap.put('Anniversary_date__c','16/3/2021');
         accountMap.put('Is_This_Your_First_Home__c','false');
         accountMap.put('Annual_Income__pc','500000');
         accountMap.put('CP_Name__c','test test123');
         accountMap.put('CP_Number__c','9671204578');
         
         
        
         opportunityMap.put('Name','');
         opportunityMap.put('CloseDate','');
         opportunityMap.put('StageName','Site Visit');
         opportunityMap.put('Interested_Property_Type__c','1 RK;1 BHK');
         opportunityMap.put('Preferred_Size_of_Unit_in_sq_ft__c','100');
         opportunityMap.put('Preferred_Floor__c','');
         opportunityMap.put('Possession_In__c','Less than 1 Year;1-2 Years');
         opportunityMap.put('Decision_Maker_Visited__c','true');
         opportunityMap.put('Project_id','8');
         opportunityMap.put('OwnerId',string.valueOf(userObject.Email));
        
        
        opportunityRequest opp = new opportunityRequest();
        opp.accountMap = accountMap;
        opp.opportunityMap = opportunityMap;
        String myJSON = 'test json';   
        RestRequest req = new RestRequest(); 
        req.requestUri = '/services/apexrest/opportunity/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        
        Test.startTest();
        opportunityResponse oppreq = OpportuntiyService.doPost();
      //  system.assertEquals(oppreq.Status,'error');
        Test.stopTest();
        
    }

}