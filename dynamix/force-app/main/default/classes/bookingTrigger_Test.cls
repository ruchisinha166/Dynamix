@isTest
public class bookingTrigger_Test {
    @isTest 
    public static void bookingTriggerMethod()
    {
        String developerNameValue = 'Booking_Form_Link_Email_SM'; 
        EmailTemplate emailTemplate = [SELECT Developername , Name FROM EmailTemplate WHERE DeveloperName =:developerNameValue LIMIT 1] ;
        
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
                          LocaleSidKey='en_US', // changed for to avoid: INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST, Locale: bad value for restricted picklist field: America/Los_Angeles
                          
                          ProfileId=p1.Id,
                          TimeZoneSidKey    = 'America/Los_Angeles');
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
        bookingObject.cancellation_fees__c=10000;
        bookingObject.Registration_Status__c = 'Not Started';
        bookingObject.Index_II_Document__c = true;
        bookingObject.Sales_Manager__c = oppoObject.OwnerId;
        bookingObject.Related_Opportunity__c = oppoObject.id;
        insert bookingObject;
        
        Booking__c bookingObj = new Booking__c();
        bookingObj.Stage__c = 'Registration';
        bookingObj.cancellation_fees__c=10000;
        bookingObj.Index_II_Document__c = true;
        bookingObj.Registration_Status__c = 'Not Started';
      //  bookingObject.Sales_Manager__c = oppoObject.OwnerId;
        bookingObj.Sales_Manager__c = oppoObject.OwnerId;
        bookingObj.Related_Opportunity__c = oppoObject.id;
        
        insert bookingObj;
        
        Booking__c Book = [Select Id,Stage__c From Booking__c Where Id=:bookingObject.Id];
        Book.Stage__c = 'Registration';
        Book.Registration_Status__c = 'Completed';
        bookingObject.Sales_Manager__c = oppoObject.OwnerId;
        Update Book;
        EmailTemplate insertedTemplate = [SELECT Id, Name FROM EmailTemplate WHERE Id = :emailTemplate.Id];
        Test.stopTest();
        
    }
    @isTest 
    public static void bookingTriggerMethod1()
    {
        String developerNameValue = 'Booking_Form_Link_Email_SM'; 
        EmailTemplate emailTemplate = [SELECT Developername , Name FROM EmailTemplate WHERE DeveloperName =:developerNameValue LIMIT 1] ;
        
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
                          LocaleSidKey='en_US', // changed for to avoid: INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST, Locale: bad value for restricted picklist field: America/Los_Angeles
                          
                          ProfileId=p1.Id,
                          TimeZoneSidKey    = 'America/Los_Angeles');
        insert u2;  
        
        Project__c projObj = new Project__c();
        projObj.Name = 'test project';
        projObj.Last_Invoice_Number__c = 1;
        projobj.Post_Sales_Head__c = u2.Id;
        projobj.Budgets__c = 'above 3.5 crs';
        projobj.Configuration__c = '1 BHK';
        projobj.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        insert projObj;
        
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
        accountObject.PAN_No__pc = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.PersonMobilePhone ='8989898989';
        insert accountObject;
        
        Account accountObject1 = new Account();
        accountObject1.FirstName = 'test';
        accountObject1.LastName = 'Account';
        accountObject1.BillingCountry = 'India';
        accountObject1.Phone = '455546565';
        accountObject1.RecordTypeId = PersonRecId;
        accountObject1.PersonEmail = 'dynamix.project@gmail.com';
        accountObject1.Aadhar_No__pc = '458785698549';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject1.PAN_No__pc = 'ABCTY1234C';
        accountObject1.Aadhar_Uploaded__pc = true;
        accountObject1.PAN_Card_Uploaded__pc = true;
        accountObject1.PersonMobilePhone ='7789898989';
        insert accountObject1;
        
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
        bookingObject.Stage__c = 'Registration';
        bookingObject.cancellation_fees__c=10000;
        bookingObject.Registration_Status__c = 'Not Started';
        bookingObject.Index_II_Document__c = true;
        bookingObject.Primary_Applicant__c = accountObject.id;
        bookingObject.Sales_Manager__c = oppoObject.OwnerId;
        bookingObject.Related_Opportunity__c = oppoObject.Id;
        insert bookingObject;
        
        Co_Applicant__c ca = new Co_Applicant__c();
        ca.Account__c = accountObject1.id;
        ca.Role__c = 'Co-Applicant';
        ca.Booking__c = bookingObject.id;
        //insert ca;
        
        bookingObject.Stage__c = 'Booked';
        bookingObject.Primary_Applicant__c = accountObject.id;
        update bookingObject;        
        Test.stopTest();
        
    }
    
    
}