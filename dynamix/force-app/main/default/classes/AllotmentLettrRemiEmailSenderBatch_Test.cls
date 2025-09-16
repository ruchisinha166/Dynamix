@isTest
public class AllotmentLettrRemiEmailSenderBatch_Test {
    static testMethod void testMethod1(){
        //Test profile Record
        Profile pId = [select Id,Name From Profile Where Name = 'System Administrator' Limit 1];        
        String uniqueUserName1 = 'standarduser1' + DateTime.now().getTime() + '@testorg.com';        
        String personAccRcdTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        //Test User Record with Country manager Role
        User testUserRcd1 = new User();
        testUserRcd1.FirstName = 'Mayur';
        testUserRcd1.LastName = 'Patel';
        testUserRcd1.Email = 'mayur.patel@manras.com';
        testUserRcd1.Alias = 'MPatel';
        testUserRcd1.Username = uniqueUserName1;
        testUserRcd1.ProfileId = pId.Id;
        testUserRcd1.EmailEncodingKey = 'UTF-8';
        testUserRcd1.LanguageLocaleKey='en_US';
        testUserRcd1.LocaleSidKey='en_US';
        testUserRcd1.TimeZoneSidKey='America/Los_Angeles';
        testUserRcd1.Country='India';
        insert testUserRcd1;
        
        System.RunAs(testUserRcd1){
            //test account record
            Account testAccRcd = new Account();
            testAccRcd.Salutation='Mr.';
            testAccRcd.FirstName='Test FName';
            testAccRcd.LastName='Test LName';
            testAccRcd.BillingCountry = 'India';
            testAccRcd.PersonMobilePhone = '1234567890';
            testAccRcd.RecordTypeId=personAccRcdTypeId;         
            insert testAccRcd;
            
            //test opportunity record
            Opportunity testOppRcd = new Opportunity();
            testOppRcd.AccountId = testAccRcd.Id;
            testOppRcd.Name = 'Test Opportunity';
            testOppRcd.StageName = 'Site Visit';
            testOppRcd.CloseDate = System.Today()+3;
            insert testOppRcd;
            
            //test project record
            Project__c testProjectRcd = new Project__c();
            testProjectRcd.Name = 'Test Project';
            insert testProjectRcd;
            
            //test pricing Plan record
            Pricing_Plan__c testPricingPlanRcd = new Pricing_Plan__c();
            testPricingPlanRcd.Name = 'Pricing Plan Test';
            testPricingPlanRcd.Project__c = testProjectRcd.Id;
            insert testPricingPlanRcd;
            
            //test Property record
            Property__c testPropertyRcd = new Property__c();
            testPropertyRcd.Name = 'test property';
            testPropertyRcd.Project__c = testProjectRcd.Id;
            testPropertyRcd.Property_Price_Slab__c = testPricingPlanRcd.Id;
            testPropertyRcd.Floor__c= '5';
            insert testPropertyRcd;
            
            //test suggested property record
            Suggested_Property__c testSuggPropertyRcd = new Suggested_Property__c();
            testSuggPropertyRcd.Opportunity__c = testOppRcd.Id;
            testSuggPropertyRcd.Unit__c = testPropertyRcd.Id;
            testSuggPropertyRcd.Discount__c = 10;
            insert testSuggPropertyRcd;
            
            //test booking record
            TimeZone tz = UserInfo.getTimeZone();
            DateTime dt = Datetime.now();
            Id businessHourId = [SELECT Id FROM BusinessHours WHERE IsDefault = true].Id;
            Integer hours = -24;
            Datetime allotmentLettGenDate=BusinessHours.add(businessHourId,dt, hours * 60 * 60 * 1000L);
            
            //test booking record
            List<Booking__c> bookingList=new List<Booking__c>();
            
            Booking__c testBookingRcd = new Booking__c();
            testBookingRcd.Primary_Applicant__c = testAccRcd.Id;
            testBookingRcd.Related_Opportunity__c = testOppRcd.Id;
            testBookingRcd.Related_Suggested_Property__c = testSuggPropertyRcd.Id;
            testBookingRcd.Project_Name__c = testProjectRcd.Id;
            testBookingRcd.Allotment_Letter_Sent__c=false;
            testBookingRcd.Allotment_Letter_Generation_Date__c=allotmentLettGenDate;
            testBookingRcd.OwnerId=testUserRcd1.Id;
            insert testBookingRcd;
            
            bookingList=[Select Id,Name,CreatedDate,Allotment_Letter_Generation_Date__c,OwnerId,Owner.Name,Owner.Email,Allotment_Letter_Sent__c,Project_Name__r.Name,Project_Name__c From Booking__c Where Allotment_Letter_Generation_Date__c!=null AND Allotment_Letter_Sent__c=false AND Id=:testBookingRcd.Id];
            //insert bookingList;
            
            Map<String,List<Booking__c>> listOfBooking=new Map<String,List<Booking__c>>();
            
            for(Booking__c bookingRcd1:bookingList)
            {
                if(!listOfBooking.containsKey(bookingRcd1.Owner.Email))
                {
                    listOfBooking.put(bookingRcd1.Owner.Email, new List<Booking__c>());
                }
                listOfBooking.get(bookingRcd1.Owner.Email).add(bookingRcd1);
            }
            Test.startTest();
            Database.executeBatch(new AllotmentLettrRemiEmailSenderBatch(listOfBooking),10);
            Test.stopTest();
        }
    }
}