@isTest()
public class CaseTriggerHandler_Test {
    static testMethod void testMethod1(){
        //get queue 
        Group testGrp1 = [Select Id,DeveloperNAME from Group where Type = 'Queue' AND DeveloperNAME = 'Support_Executive_Queue' ];
        
        //Insert test case record
        Case caseRcd1=new Case();
        caseRcd1.Subject='Test Case 1';
        caseRcd1.Description='Test Desc';
        caseRcd1.Origin='Email';
        caseRcd1.OwnerId=testGrp1.Id;
        caseRcd1.Status='New';
        caseRcd1.Type='Channel Partner Complaint';
        insert caseRcd1;
        
        //update record
        Case caseRcd2=[Select Id,Subject,OwnerId From Case Where Id=:caseRcd1.Id];
        caseRcd2.OwnerId=UserInfo.getUserId();        
        update caseRcd2;  
        
        Case caseRcd3=new Case();
        caseRcd3.Subject='Test Case 2';
        caseRcd3.Description='Test Desc 2';
        caseRcd3.Origin='Email';
        caseRcd3.OwnerId=testGrp1.Id;
        caseRcd3.Status='New';
        caseRcd3.Type='Customer Complaint';
        insert caseRcd3;
        
        Case caseRcd4=[Select Id,Subject,OwnerId From Case Where Id=:caseRcd3.Id];
        caseRcd4.OwnerId=UserInfo.getUserId();        
        update caseRcd4;  
        
    }
}