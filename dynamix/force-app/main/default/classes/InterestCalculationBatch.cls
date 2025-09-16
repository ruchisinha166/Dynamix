public class InterestCalculationBatch implements Database.Batchable<sObject>{
 
   public final String Query;
   List<Interest_Charged__c> interestChargedList = new List<Interest_Charged__c>();
   List<Interest_Charged__c> interestChargedListToupsert = new List<Interest_Charged__c>();
   Set<Id> milestoneIds = new Set<Id>();
   Map<Id,Interest_Charged__c> interestMap = new Map<Id,Interest_Charged__c>();
   Interest_Rate__mdt ratemdt = [Select Rate__c, label from Interest_Rate__mdt where DeveloperName='Default_Rate'];
   public InterestCalculationBatch(){
   }
   
   public Database.QueryLocator start(Database.BatchableContext BC){
          list<Payment_Milestones__c> pm= [SELECT Id,Name,Milestone_Status__c,Remaining_GST1__c,Remaining_Milestone_Amount__c,Due_Date__c,Remaining_GST__c,Remaining_Amount__c  FROM Payment_Milestones__c where (Due_Date__c <:Date.today() AND Remaining_Amount__c > 0 and Milestone_Status__c ='Active')];
          system.debug('test Query locator== QA'+pm);
  
          return Database.getQueryLocator([SELECT Id,Name,Milestone_Status__c,Remaining_GST1__c,Due_Date__c,Remaining_Milestone_Amount__c,Remaining_GST__c,Remaining_Amount__c  FROM Payment_Milestones__c where (Due_Date__c <:Date.today() AND Remaining_Amount__c > 0 and Milestone_Status__c ='Active')]);
   }
 
   public void execute(Database.BatchableContext BC, List<sObject> scope)
   {
         system.debug('scope=='+scope);
         for(sobject s : scope)
         {
             Payment_Milestones__c p = (Payment_Milestones__c) s;
             milestoneIds.add(p.id);
         }
         
         interestChargedList = [SELECT id,createddate, Milestone__c,Interest_Rate__c,Intrest_calucation_GST__c,Intrest_calucation_Amount__c, Name, From_Date__c, To_Date__c FROM Interest_Charged__c WHERE Milestone__c IN:milestoneIds ORDER BY createddate ASC];
         for(Interest_Charged__c i : interestChargedList)
         {
             interestMap.put(i.Milestone__c, i);
         }
         for(sobject s : scope)
         {
             Payment_Milestones__c p = (Payment_Milestones__c) s;
             if(interestMap.containsKey(p.id) && interestMap.get(p.id).Interest_Rate__c == ratemdt.Rate__c && interestMap.get(p.id).Intrest_calucation_Amount__c== p.Remaining_Amount__c )
             {
             
                    interestMap.get(p.id).To_Date__c = Date.today();
                    interestChargedListToupsert.add(interestMap.get(p.id));
                         
             }
             else if(interestMap.containsKey(p.id) && (interestMap.get(p.id).Interest_Rate__c != ratemdt.Rate__c   || interestMap.get(p.id).Intrest_calucation_Amount__c != p.Remaining_Amount__c) )
             {  
                    Interest_Charged__c interest = new Interest_Charged__c();
                    interest.Milestone__c = p.id;
                    interest.Interest_Rate__c = ratemdt.Rate__c;
                    interest.Intrest_calucation_Amount__c=p.Remaining_Milestone_Amount__c;
                    interest.Intrest_calucation_GST__c=p.Remaining_GST1__c;
                    interest.From_Date__c =interestMap.get(p.id).From_Date__c;
                    interest.To_Date__c = Date.today();
                    interestChargedListToupsert.add(interest);  
              
            }
            else
            {
                 Interest_Charged__c interest = new Interest_Charged__c();
                 interest.Milestone__c = p.id;
                 interest.Interest_Rate__c = ratemdt.Rate__c;
                 interest.Intrest_calucation_Amount__c=p.Remaining_Milestone_Amount__c;
                 interest.Intrest_calucation_GST__c=p.Remaining_GST1__c;
                 interest.To_Date__c = Date.today();
                 interest.From_Date__c = p.Due_Date__c;
                 interestChargedListToupsert.add(interest);
            }
         }
       
         if(interestChargedListToupsert!=null && interestChargedListToupsert.size()>0)
             upsert interestChargedListToupsert;
   }
 
   public void finish(Database.BatchableContext BC){}
}