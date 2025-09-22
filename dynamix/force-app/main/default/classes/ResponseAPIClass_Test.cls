@isTest
private class ResponseAPIClass_Test {
    @isTest static void getResponse_Test(){
        //HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        response.setBody('{"item":[{"SFDC_ID":"a0C7100000poDmlEAE","VBELN":"3010000177","STATUS":"Success","MESSAGE":"Sales Booking Created Sucessfully."}]}');
        Test.startTest();
        ResponseAPIClass.getResponse(response);
        Test.stopTest();
   
    }
    @isTest static void getPaymentMilestoneUpdateTest(){
        Profile prf = [Select id , name from Profile where name = 'System Administrator'];
        Profile prf1 = [Select id , name from Profile where name = 'Sales Manager'];
        
        User testUser = new User(Username='ABC006@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf.Id);
        insert testUser;
        
        User testUser1 = new User(Username='ABC01206@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf1.Id);
        Insert testUser1;
        
        String recordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = recordtypeId;
        acc.Email__c = 'sunfeast@gmail.com';
        acc.PersonMobilePhone = '9856984569';
        acc.PersonBirthdate = system.today().addMonths(-240);
        acc.Aadhar_No__pc = '789456213245';
        acc.FirstName = 'Kumar';
        acc.LastName = 'Sachin';
        Insert acc;
        
        Project__c proj = new Project__c();
        proj.Name = 'test';
        proj.Project_SAP_Code__c = '1400';
        proj.Project_Type__c = '10';
        proj.Project_Email__c = 'divum@dynamixgroup.co.in';
        proj.Project_Head__c = testUser.id;
        proj.Site_Head__c = testUser.id;
        proj.Configuration__c = '2 BHK';
        proj.Budgets__c = 'Under 75 lakhs';
        proj.Project_Carpet_Area__c = '750 – 800 sq.ft.' ;
        Insert proj;
        
        Opportunity opp = new Opportunity ();
        opp.Name = 'opp1';
        opp.AccountId = acc.Id;
        opp.StageName = 'Site Visit Done';
        opp.Budget1__c = 'Under 75 lakhs';
        opp.No_of_Total_Visits__c = 1;
        opp.Sales_Manager__c = testUser1.Id;
        opp.KYC_Completed__c = true;
        opp.Is_Booking_Form_Submitted_by_Customer__c = true;
        opp.Walk_in_Source__c = 'Social Media';
        opp.Stamp_Duty_Payable_By__c = 'Dynamix';
        opp.Project__c = proj.Id;
        opp.CloseDate = system.today().addDays(30);
        Insert opp;
        
        Booking__c booking = new Booking__c();
        booking.Primary_Applicant__c = acc.Id;
        booking.Related_Opportunity__c = opp.Id;
        booking.Project_Name__c = proj.Id;
        booking.OwnerId = testUser.Id;
        booking.Primary_Secondary_info_Updated__c = false;
        booking.Shared_SDR_Letter__c = false;
        booking.Date_of_First_Disbursement__c = Date.today();
        booking.Amount_of_First_Disbursement__c = 43;
        booking.Sap_Code__c = '741852663';
        insert booking;
        
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        response.setBody('{"item":[{"SFDC_ID":"'+booking.Id+'","VBELN":"'+booking.Sap_Code__c+'","CUSTOMER":"0020000595","STATUS":"Success","MESSAGE":"Bill plan updated successfully"}]}');
        Test.startTest();
        ResponseAPIClass.getResponse(response);
        Test.stopTest();
    }
    @isTest static void get_EoiCustomer_Test(){
        Profile prf = [Select id , name from Profile where name = 'System Administrator'];
        Profile prf1 = [Select id , name from Profile where name = 'Sales Manager'];
        
        User testUser = new User(Username='ABC006@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf.Id);
        insert testUser;
        
        User testUser1 = new User(Username='ABC01206@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf1.Id);
        Insert testUser1;
        
        String recordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = recordtypeId;
        acc.Email__c = 'sunfeast@gmail.com';
        acc.PersonMobilePhone = '9856984569';
        acc.PersonBirthdate = system.today().addMonths(-240);
        acc.Aadhar_No__pc = '789456213245';
        acc.FirstName = 'Kumar';
        acc.LastName = 'Sachin';
        Insert acc;
        
        Project__c proj = new Project__c();
        proj.Name = 'test';
        proj.Project_SAP_Code__c = '1400';
        proj.Project_Type__c = '10';
        proj.Project_Email__c = 'divum@dynamixgroup.co.in';
        proj.Project_Head__c = testUser.id;
        proj.Site_Head__c = testUser.id;
        proj.Configuration__c = '2 BHK';
        proj.Budgets__c = 'Under 75 lakhs';
        proj.Project_Carpet_Area__c = '750 – 800 sq.ft.' ;
        Insert proj;
        
        Opportunity opp = new Opportunity ();
        opp.Name = 'opp1';
        opp.AccountId = acc.Id;
        opp.StageName = 'Site Visit Done';
        opp.Budget1__c = 'Under 75 lakhs';
        opp.No_of_Total_Visits__c = 1;
        opp.Sales_Manager__c = testUser1.Id;
        opp.KYC_Completed__c = true;
        opp.Is_Booking_Form_Submitted_by_Customer__c = true;
        opp.Walk_in_Source__c = 'Social Media';
        opp.Stamp_Duty_Payable_By__c = 'Dynamix';
        opp.Project__c = proj.Id;
        opp.CloseDate = system.today().addDays(30);
        Insert opp;
        
        HttpResponse res = new HttpResponse();
        res.setBody('{"item":[{"SFDC_ID":"'+opp.Id+'","CUSTOMER":"0040000031","STATUS":"Success","MESSAGE":"EOI Customer Successfully Created."}]}');
       	Test.startTest();
        ResponseAPIClass.getResponse(res);
        Test.stopTest();
    }
    @isTest static void get_channelPartner_Test(){
        Profile prf = [Select id , name from Profile where name = 'System Administrator'];
        Profile prf1 = [Select id , name from Profile where name = 'Sales Manager'];
        
        User testUser = new User(Username='ABC006@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf.Id);
        insert testUser;
        
        User testUser1 = new User(Username='ABC01206@gmail.com', LanguageLocaleKey = 'en_US', Alias = 'alias',EmailEncodingKey = 'UTF-8',LastName= 'qwe',Email='testuser@example.com',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', ProfileId = prf1.Id);
        Insert testUser1;
        
        String recordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = recordtypeId;
        acc.Email__c = 'sunfeast@gmail.com';
        acc.PersonMobilePhone = '9856984569';
        acc.PersonBirthdate = system.today().addMonths(-240);
        acc.Aadhar_No__pc = '789456213245';
        acc.FirstName = 'Kumar';
        acc.LastName = 'Sachin';
        Insert acc;
        
        HttpResponse res = new HttpResponse();
        res.setBody('{"item":[{"SFDC_ID":"'+acc.Id+'","LIFNR":"2400000054","STATUS":"Success","MESSAGE":"Broker Created Successfully"}]}');
       	Test.startTest();
        ResponseAPIClass.getResponse(res);
        Test.stopTest();
    }
}