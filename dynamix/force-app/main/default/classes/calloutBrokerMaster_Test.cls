@isTest
private class calloutBrokerMaster_Test {
    @isTest static void getChannelPartner_Test(){
        RecordType channelPartnerRecordType = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Channel_Partner' LIMIT 1];

        Account testAccount = new Account();
        testAccount.Name = 'Channel Partner Account';
        testAccount.RecordTypeId = channelPartnerRecordType.Id;
        testAccount.Rera_Expiry_Date__c = system.today()+30;
        //testAccount.Project__c = testProject.Id;
        insert testAccount;
        
        Data_Sync__c ds = new Data_Sync__c();
        ds.RecordId__c = testAccount.Id;
        ds.Status__c = 'Pending';
        ds.Event_Type__c = 'Channel Partner';
        insert ds;
        
        List<calloutBrokerMaster.request> reqList = new List<calloutBrokerMaster.request>();
        calloutBrokerMaster.request req = new calloutBrokerMaster.request();
        req.accountId = testAccount.Id;
        req.deletionFlag = '';
        reqList.add(req);
        
        Test.startTest();
       	Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        calloutBrokerMaster.getChannelPartner(reqList);
        Test.stopTest();
    }
}