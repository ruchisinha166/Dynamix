@isTest
public class OpportuntiyService_Test {

    @isTest static void oppServiceTest(){
        
        String JSONStr =  '{"accountMap":{"FirstName": "Rahul","LastName": "Kumar","PersonMobilePhone" : "5588446624","PersonEmail" : "rahul@gmail.com"},"opportunityMap":{"Name":"test","StageName":"Closed Won","CloseDate":"2021-06-30"}}';
	
        
        Test.startTest();
        Restrequest req  = New Restrequest();
         req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = blob.valueOf(JSONStr);
        req.requestURI = '/services/apexrest/opportunity/*';
         RestContext.request = req;
        
         Restresponse res = New Restresponse();
         RestContext.response = res;
        OpportuntiyService.doPost();
        Test.stopTest();
        
        
    }
    
    @isTest static void oppServiceTest1(){
        
        String JSONStr =  '{"accountMap":{"FirstName": "Sahil","LastName": "Kumar","PersonMobilePhone" : "5588446624","PersonEmail" : "sahil@gmail.com"},"opportunityMap":{"Name":"test1","StageName":"Closed Won","CloseDate":"10/07/2021","Source__c":"Channel Partner"}}';
	
        
        Test.startTest();
        Restrequest req  = New Restrequest();
         req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = blob.valueOf(JSONStr);
        req.requestURI = '/services/apexrest/opportunity/*';
         RestContext.request = req;
        
         Restresponse res = New Restresponse();
         RestContext.response = res;
        OpportuntiyService.doPost();
        Test.stopTest();
        
        
    }
    
      @isTest static void oppServiceTest2(){
          
          
        
        String JSONStr =  '{"accountMap":{"FirstName": "Sahil123","LastName": "Kumar456","PersonMobilePhone" : "5587846624","PersonEmail" : "testkumar145@gmail.com"},"opportunityMap":{"Name":"test2","StageName":"Closed Won","CloseDate":"12/05/2021","Source__c":"Channel Partner","Project__c":"a0L0w000001QlFlEAK","OwnerId":"0050w000002cFNcAAM"}}';
	
        
        Test.startTest();
        Restrequest req  = New Restrequest();
         req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = blob.valueOf(JSONStr);
        req.requestURI = '/services/apexrest/opportunity/*';
         RestContext.request = req;
        
         Restresponse res = New Restresponse();
         RestContext.response = res;
        OpportuntiyService.doPost();
        Test.stopTest();
        
        
    }
    
     @isTest static void oppServiceTest3(){
        
        String JSONStr =  '{"accountMap":{"FirstName": "Rohit123","LastName": "Kumar456","PersonMobilePhone" : "5747846624","PersonEmail" : "rohitkumar145@gmail.com"},"opportunityMap":{"Name":"test2","StageName":"Closed Won","CloseDate":"10/05/2021","Source__c":"Person Account","Project__c":"a0L0w000001QlFlEAK","OwnerId":"0050w000002cFNcAAM"}}';
	
        
        Test.startTest();
        Restrequest req  = New Restrequest();
         req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = blob.valueOf(JSONStr);
        req.requestURI = '/services/apexrest/opportunity/*';
         RestContext.request = req;
        
         Restresponse res = New Restresponse();
         RestContext.response = res;
        OpportuntiyService.doPost();
        Test.stopTest();
        
        
    }
    
      @isTest static void oppServiceTest4(){
        
        String JSONStr =  '{"accountMap":{"FirstName": "Sohit123","LastName": "Kumar456","PersonMobilePhone" : "5747844584","PersonEmail" : "sohitkumar145@gmail.com"},"opportunityMap":{"Name":"test5","StageName":"Closed Won","CloseDate":"11/07/2021","Source__c":"Person Account","OwnerId":"0050w000002cFNcAAM"}}';
	
        
        Test.startTest();
        Restrequest req  = New Restrequest();
         req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = blob.valueOf(JSONStr);
        req.requestURI = '/services/apexrest/opportunity/*';
         RestContext.request = req;
        
         Restresponse res = New Restresponse();
         RestContext.response = res;
        OpportuntiyService.doPost();
        Test.stopTest();
        
        
    }
   
   
   
   
    
   }