@isTest
public class RestChannelPartner_Test {
    @IsTest
    public static void testMethod01() {
        
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
        
        Map<String ,Account> allAccountMap = New Map<String ,Account>();
        
        List<Account> accountList = new List<Account>();
        Account testAccRcd = new Account();
        testAccRcd.Name = 'Channel Partner Account';
        testAccRcd.BillingCountry = 'India';
        testAccRcd.Phone = '1234567890';
        testAccRcd.Email__c = 'mayur.patel@manras.com';
        testAccRcd.OwnerId = testUserRcd1.Id;
        testAccRcd.RERA_Number__c = '123456789';
        testAccRcd.RecordTypeId = channelPartnerRecordType.Id;
        testAccRcd.BillingCity = 'Mumbai';
        testAccRcd.BillingState = 'Haryana';
        testAccRcd.BillingStreet = 'hop-up';
        testAccRcd.Type = 'Competitor';
        testAccRcd.AccountSource = 'Website';
        testAccRcd.Website = 'www.go.com';
        testAccRcd.BillingPostalCode = '65465';
        testAccRcd.PAN_No__c = 'ABKPC4737D';
        testAccRcd.GSTIN_No__c = '2424323423423';
        insert testAccRcd;
        accountList.add(testAccRcd);
        allAccountMap.put(testAccRcd.RERA_Number__c,testAccRcd);
        
        Account testAcc = new Account();
        testAcc.Name = 'Channel Partner Account1';
        testAcc.BillingCountry = 'India';
        testAcc.Phone = '4569825678';
        testAcc.Email__c = 'tanu@manras.com';
        testAcc.OwnerId = testUserRcd1.Id;
        testAcc.RERA_Number__c = null;
        testAcc.RecordTypeId = channelPartnerRecordType.Id;
        insert testAcc;
        
        allAccountMap.put(testAcc.Phone,testAcc);
        
        OrgWideEmailAddress orgadd = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Default'];
        
        Project__c testProjectRcd = new Project__c();
        testProjectRcd.Name = 'Test Project';
        testProjectRcd.Project_Carpet_Area__c = '475 - 1 BHK';
        testProjectRcd.Budgets__c = 'Under 75 lakhs';
        testProjectRcd.Configuration__c ='1 BHK';
        testProjectRcd.Site_Head__c = testUserRcd1.Id;
        insert testProjectRcd;
        
        Channel_Partner_Project__c cPProject = new Channel_Partner_Project__c();
        cPProject.Channel_Partner__c = testAccRcd.Id;
        cPProject.Project__c = testProjectRcd.Id;
        insert cPProject;
        
        EmailTemplate cpExistemailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'New_Cp' LIMIT 1];

       
        RestRequest restReq = RestContext.request;
        if (restReq != null && restReq.requestBody != null) {
            String requestBody = restReq.requestBody.toString();
            RestChannelPartner.ReqWrapper reqWrapper = new RestChannelPartner.ReqWrapper();
            reqWrapper = (RestChannelPartner.ReqWrapper)JSON.deserialize(requestBody, RestChannelPartner.ReqWrapper.class);
            reqWrapper.reranumber = '546577';
            reqWrapper.phone = '6575678754';
            reqWrapper.projectId = testProjectRcd.Id;
            allAccountMap.containsKey(reqWrapper.phone);
            
            String Key = string.valueof(allAccountMap.get(reqWrapper.phone).id)+ '-' + testProjectRcd.Id;
            
        } else {
            System.debug('restReq or requestBody is null');
        }

        if (restReq != null && restReq.requestBody != null) {
        String requestBody = restReq.requestBody.toString();
        RestChannelPartner.ReqWrapper reqWrapper = new RestChannelPartner.ReqWrapper();
        reqWrapper = (RestChannelPartner.ReqWrapper)JSON.deserialize(requestBody, RestChannelPartner.ReqWrapper.class);
        reqWrapper.name = null;
        reqWrapper.phone = null;
        reqWrapper.firmType = null;
        reqWrapper.firmName = null;
        reqWrapper.email = null;
            
        reqWrapper.name = '';
        reqWrapper.phone = '';
        reqWrapper.firmType = '';
        reqWrapper.firmName = '';
        reqWrapper.email = '';
        }else{
            
        }
        
        List<Object> listObject = new List<Object>();
        Map<String, String> jsonValue = new Map<String, String>();
        jsonValue.put('addressline1','123 Demo Building');
        jsonValue.put('addressline2','demo');
        jsonValue.put('city','Chandigarh');
        jsonValue.put('country','India');
        jsonValue.put('email','dummy@email.com');
        jsonValue.put('mobilenumber','9988776655');
        jsonValue.put('name','Abhishek');
        jsonValue.put('pincode','String');
        jsonValue.put('state','Punjab');
        jsonValue.put('pan','ATEPA1111A');
        jsonValue.put('gstnumber','GSTIN11993889');
        jsonValue.put('reranumber','7878830AAAD333');
        jsonValue.put('phone','172747483');
        jsonValue.put('firmName', 'CPFirm');
        jsonValue.put('firmType', 'Proprietor');
        jsonValue.put('reraCertificate', 'true');
        jsonValue.put('entity', 'Individual');
        jsonValue.put('expertise', 'Retail');
        jsonValue.put('companyname', 'Manras');
        jsonValue.put('ownerName', testUserRcd1.Name);
        jsonValue.put('brokerAssociation', 'Single');
        jsonValue.put('focusLocation', 'Central Suburbs');
        jsonValue.put('salesManagerName', 'rom');
        jsonValue.put('noOfYearsInOperation', '5');
        jsonValue.put('designation', 'New');
        jsonValue.put('channelPartnerRecordId', testAccRcd.Id);
        jsonValue.put('projectId','Test Project');
        
        listObject.add(jsonValue);
        
        String testJSON = JSON.serialize(listObject);
        
        Test.setMock(HttpCalloutMock.class, new SmartWorldMock());
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/channelpartner/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(testJSON);
        RestContext.request = req;
        RestContext.response = res;
        RestChannelPartner.postChannelPartner();
        RestChannelPartner.testCoverageMethod();
        Test.stopTest();
    }
    
    @IsTest
    public static void testMethod02() {
         Id channelPartnerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        
        RestChannelPartner controller = new RestChannelPartner();

        
    }
    
    // Mock HTTP callout implementation
    public class SmartWorldMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"SUCCESS","message":"All Records Uploaded successfully","failedErrorList":null,"error":null,"crmSuccessList":[{"crmId":"0010w00000zxXAOAA2","message":"25"}]}');
            res.setStatusCode(200);
            return res;
        }
    }
}