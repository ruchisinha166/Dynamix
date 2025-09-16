@isTest
public class SuggestedPropertyTrigger_Test 
{   
    @isTest
    public static void statusChangedToShortListed()
    {
        
        Property__c prop1 = new Property__c(Name='Testing property1',Floor__c='1');
        insert prop1;
        
        Account accountObject = new Account();
        accountObject.Name= 'Test Account';
        insert accountObject; 
        
        Opportunity opp1 = new Opportunity(Name='Opp 1', CloseDate=Date.today()+45,stageName='Site Visit', AccountId = accountObject.Id);
        insert opp1;
        
        Suggested_Property__c sp1 = new Suggested_Property__c(Opportunity__c=opp1.id,Status__c='Unavailable',Unit__c=prop1.id);
        insert sp1;
        Suggested_Property__c sp2 = new Suggested_Property__c(Opportunity__c=opp1.id,Status__c='Unavailable',Unit__c=prop1.id);
        insert sp2;
        Suggested_Property__c sp3 = new Suggested_Property__c(Opportunity__c=opp1.id,Status__c='Unavailable',Unit__c=prop1.id);
        insert sp3;
        
        Test.startTest();
           sp3.Status__c='Short Listed';
           update sp3;
        Test.stopTest();
    }
    
    @isTest
    public static void statusChangedToReserved()
    {
        Property__c prop1 = new Property__c(Name='Testing property1',Floor__c='1');
        insert prop1;
        
        Account accountObject = new Account();
        accountObject.Name= 'Test Account';
        insert accountObject;
        
        Opportunity opp1 = new Opportunity(Name='Opp 1', CloseDate=Date.today()+45,stageName='Site Visit',AccountId = accountObject.Id);
        insert opp1;
        
        Suggested_Property__c sp1 = new Suggested_Property__c(Opportunity__c=opp1.id,Status__c='Short Listed',Unit__c=prop1.id);
        insert sp1;
        Suggested_Property__c sp2 = new Suggested_Property__c(Opportunity__c=opp1.id,Status__c='Short Listed',Unit__c=prop1.id);
        insert sp2;
        Suggested_Property__c sp3 = new Suggested_Property__c(Opportunity__c=opp1.id,Status__c='Short Listed',Unit__c=prop1.id);
        insert sp3;
        
        Test.startTest();
           sp3.Status__c = 'Reserved';
           update sp3;
        Test.stopTest();
    }
    
    @isTest
    public static void statusChangedToInProgress()
    {
        Property__c prop1 = new Property__c(Name='Testing property1',Floor__c='1');
        insert prop1;
        
        Account accountObject = new Account();
        accountObject.Name= 'Test Account';
        insert accountObject;
        
        Opportunity opp1 = new Opportunity(Name='Opp 1', CloseDate=Date.today()+45,stageName='Site Visit',AccountId = accountObject.Id);
        insert opp1;
        
        Suggested_Property__c sp1 = new Suggested_Property__c(Opportunity__c=opp1.id,Status__c='Short Listed',Unit__c=prop1.id);
        insert sp1;
        Suggested_Property__c sp2 = new Suggested_Property__c(Opportunity__c=opp1.id,Status__c='Short Listed',Unit__c=prop1.id);
        insert sp2;
        Suggested_Property__c sp3 = new Suggested_Property__c(Opportunity__c=opp1.id,Status__c='Short Listed',Unit__c=prop1.id);
        insert sp3;
        
        Test.startTest();
           sp3.Status__c = 'In Progress';
          // update sp3;
        Test.stopTest();
    }
    
    @isTest
    public static void statusChangedToBooked()
    {
        Property__c prop1 = new Property__c(Name='Testing property1',Floor__c='1');
        insert prop1;
        
        Account accountObject = new Account();
        accountObject.Name= 'Test Account';
        insert accountObject; 
        
        Opportunity opp1 = new Opportunity(Name='Opp 1', CloseDate=Date.today()+45,stageName='Site Visit',AccountId = accountObject.Id);
        insert opp1;
        
        Suggested_Property__c sp1 = new Suggested_Property__c(Opportunity__c=opp1.id,Status__c='Short Listed',Unit__c=prop1.id);
        insert sp1;
        Suggested_Property__c sp2 = new Suggested_Property__c(Opportunity__c=opp1.id,Status__c='Short Listed',Unit__c=prop1.id);
        insert sp2;
        Suggested_Property__c sp3 = new Suggested_Property__c(Opportunity__c=opp1.id,Status__c='Short Listed',Unit__c=prop1.id);
        insert sp3;
        Suggested_Property__c sp4 = new Suggested_Property__c(Opportunity__c=opp1.id,Status__c='Unavailable',Unit__c=prop1.id);
        insert sp4;
        Test.startTest();
           sp3.Status__c = 'Booked';
           update sp3;
        Test.stopTest();
    }
}