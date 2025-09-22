@isTest
public class SendSMSHandlerTest {
@isTest
    public static void method1(){
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile pId = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];        
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur1';
        testUserRcd1.LastName = 'Patel123';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.Country = 'India';
        testUserRcd1.Phone = '8168915345';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd1;
        
        Account accountObject = new Account();
        accountObject.Name = 'test Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '455546565';
        insert accountObject;
        
        Builder_Organisation__c bo = new Builder_Organisation__c();
        bo.Builder_Organisation_Initials__c = 'c';
        insert bo;
        
        Project__c projObj = new Project__c();
        projObj.Name = 'test project';
        projObj.Builder_Organization__c = bo.id;
        projObj.Project_Initials__c = 'c';
        projObj.Project_Email__c= 'harshita.sharma@manras.com';
        projObj.Project_Carpet_Area__c = '475 - 1 BHK';
        projObj.Budgets__c = 'Under 75 lakhs';
        projObj.Configuration__c ='1 BHK';
        projObj.OTP_Disable_Till__c = System.now().addDays(1);
        projObj.Project_Header__c = 'abc.com';
        insert projObj;
        
        list<opportunity> oplist = new list<opportunity>();
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.KYC_Completed__c = true;
        oppoObject.Project__c = projObj.Id;
        oppoObject.Walk_in_Source__c ='Presales' ;
        oppoObject.KYC_Completed__c = true;
        oppoObject.Is_Booking_Form_Submitted_by_Customer__c=true;
        oppoObject.Stamp_Duty_Payable_By__c = 'Dynamix';
        oppoObject.Sales_Manager__c = testUserRcd1.id;
        insert oppoObject;
        oplist.add(oppoObject);
        
        //EmailTemplate smsEmailTemp = [SELECT Id, Name, Subject, HtmlValue, Body, DeveloperName FROM EmailTemplate WHERE Name = 'SMS for New Opportunity to Sales Manager' LIMIT 1];
        test.startTest();
        SendSMSHandler.sendSMSOnNewOpportunity(oplist);
        test.stoptest();
    }
}