@isTest  
public class BookingOfferTriggerHandler_Test {
    @isTest
    public static void testMethod1() {
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        String uniqueUserName1 = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        
        UserRole roleId = [select Id,Name,DeveloperName From UserRole Where DeveloperName =: 'Site_Head_Divum'];
        
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
        
        
        User testUserRcd2 = new User();
        testUserRcd2.FirstName = 'Mayur2';
        testUserRcd2.LastName = 'Patel123';
        testUserRcd2.Email = 'mayur.patel@manras.com';
        testUserRcd2.Alias = 'MPatel';
        testUserRcd2.Username = uniqueUserName1+'123';
        testUserRcd2.ProfileId = pId.Id;
        testUserRcd2.EmailEncodingKey = 'UTF-8';
        testUserRcd2.Country = 'India';
        testUserRcd2.UserRoleId=roleId.Id;
        testUserRcd2.LanguageLocaleKey='en_US';
        testUserRcd2.LocaleSidKey='en_US';
        testUserRcd2.TimeZoneSidKey='America/Los_Angeles';
        insert testUserRcd2;
        system.runAs(testUserRcd1){
            
            Id ChargesId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Charges').getRecordTypeId();
            Id parkingId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
            Id preferredLocationId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Preferred Location').getRecordTypeId();
            Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            
            Project__c projectObject = new Project__c();
            projectObject.Name = 'Divum';
            projectObject.Project_Email__c= 'nishi@manras.com';
            projectObject.Site_Head__c=testUserRcd2.Id;
            insert projectObject;
            
            Test.startTest();
            Project__c proj=[Select Id,Name From Project__c Limit 1];
            Booking_Offer__c offer = new Booking_Offer__c();
            offer.Name = 'Test Offer';
            offer.Approval_Status__c = 'Submitted';
            offer.End_Date__c = System.today();
            offer.Start_Date__c = System.today();
            offer.Offer_Amount__c = 65;
            offer.Project__c = proj.Id;
            insert offer;
            
            Booking_Offer__c offer2 = new Booking_Offer__c();
            offer2.Name = 'Test Offer 2';
            offer2.Approval_Status__c = 'Approved';
            offer2.End_Date__c = System.today();
            offer2.Start_Date__c = System.today();
            offer2.Offer_Amount__c = 65;
            offer2.Project__c = proj.Id;
            insert offer2;
            
            Booking_Offer__c offer3 = new Booking_Offer__c();
            offer3.Name = 'Test Offer 3';
            offer3.Approval_Status__c = 'Rejected';
            offer3.End_Date__c = System.today();
            offer3.Start_Date__c = System.today();
            offer3.Offer_Amount__c = 65;
            offer3.Project__c = proj.Id;
            insert offer3;
            
            Booking_Offer__c updateBookingOffRcd=[Select Id,Approval_Status__c From Booking_Offer__c Where Id=:offer.Id];
            updateBookingOffRcd.Approval_Status__c='Approved';
            update updateBookingOffRcd;
            
            Test.stopTest();
        }
    }    
    
}