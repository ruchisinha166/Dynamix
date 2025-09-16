public class InterestChargedTriggerHandler {
    public static void InterestOnPaymentMilestone(List<Interest_Charged__c> intChargeList , Map<Id,Interest_Charged__c> oldMap){
        
        set<Id> MilestoneIdSet = new set<Id>();
        Map<Id,Interest_Charged__c> MapMilestoneToInterestCharged = new Map<Id,Interest_Charged__c>();
        for(Interest_Charged__c objIntCharged : intChargeList){
            if(oldMap.get(objIntCharged.Id).Interest_Amount_GST__c == null && objIntCharged.Interest_Amount_GST__c != null &&
              oldMap.get(objIntCharged.Id).Interest_Amount__c == null && objIntCharged.Interest_Amount__c != null){
              MilestoneIdSet.add(objIntCharged.Milestone__c);
              MapMilestoneToInterestCharged.put(objIntCharged.Milestone__c,objIntCharged);  
            }
        }
        List<Payment_Milestones__c> ListToUpdate = new List<Payment_Milestones__c>();
        List<Payment_Milestones__c> pmList = [Select Id,Name,Interest_on_milestone_amount__c,Interest_on_GST__c from Payment_Milestones__c where id in: MilestoneIdSet];
        for(Payment_Milestones__c pm : pmList){
            pm.Interest_on_GST__c = pm.Interest_on_GST__c + MapMilestoneToInterestCharged.get(pm.Id).Interest_Amount_GST__c;
            pm.Interest_on_milestone_amount__c = pm.Interest_on_milestone_amount__c + MapMilestoneToInterestCharged.get(pm.Id).Interest_Amount__c;
            ListToUpdate.add(pm);
        }
        if(!ListToUpdate.isEmpty()){
          update ListToUpdate;
        }
    }
}