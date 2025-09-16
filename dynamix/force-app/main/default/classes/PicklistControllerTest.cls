@isTest
private class PicklistControllerTest {
    
    @isTest
    static void testGetValues() {
        List<String> result = picklistController.getValues('Option1;Option2;Option3');
        System.assertEquals(4, result.size()); // Including '--None--'
        System.assertEquals('--None--', result[0]);
        System.assertEquals('Option1', result[1]);
        System.assertEquals('Option2', result[2]);
        System.assertEquals('Option3', result[3]);
    }
    
    @isTest
    static void testRecordValues() {
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
            testEnqRcd.Budget__c = 'None';
            testEnqRcd.Primary_Mobile_Number_Text__c='1234567890';
            testEnqRcd.OwnerId=testUserRcd1.Id;
            enquiryList.add(testEnqRcd);
            insert enquiryList;
            
            
            List<String> result = picklistController.getValues(testEnqRcd.Id);
           /* System.assertEquals(4, result.size());  
            System.assertEquals('None', result[0]);
            System.assertEquals('75 Lac	', result[1]);
            System.assertEquals('1.25 Cr', result[2]);
            System.assertEquals('₹1,000	', result[3]);*/
        }
    }
}