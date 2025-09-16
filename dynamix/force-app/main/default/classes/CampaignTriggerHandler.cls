public class CampaignTriggerHandler {
    //public static boolean Isfirst = True ;
    public static void makeApprovalCommentsMandatory(List<Campaign> campList,Map<id,Campaign> oldMap){
        //If User Rejects Approval Process then comments are mandatory     
        System.debug(' method --');      
        for(Campaign camp : campList){ 
            system.debug('camp status-->'+camp.Approval_Status__c);
            If( camp.Approval_Status__c == 'Rejected' &&  camp.Approval_Status__c != oldMap.get(camp.Id).Approval_Status__c ){
                //For(ProcessInstance pi :[SELECT Id, Status, TargetObjectId FROM ProcessInstance WHERE TargetObjectId =: camp.Id]){
                //    ProcessInstanceStep piStep = [SELECT Id, ProcessInstanceId, StepStatus, Comments FROM ProcessInstanceStep WHERE ProcessInstanceId =: pi.Id AND StepStatus =: 'Rejected' limit 1];
                for (ProcessInstance pi :[SELECT Status,TargetObjectId, (SELECT Id, stepStatus, Comments FROM Steps WHERE StepStatus =: 'Rejected' ORDER BY CreatedDate DESC  LIMIT 1) FROM ProcessInstance WHERE TargetObjectId =: camp.Id]){
                    system.debug('pi ==>'+ pi);
                    system.debug('pi.Status ==> '+pi.Status);
                    system.debug('pi.StepStatus ==> '+pi.steps);
                    //system.debug('comments'+pi.Steps[0].Comments);
                    if(pi.Steps.size()>0 && pi.Steps[0].Comments == null){                       
                        camp.addError('Please provide a reason for your rejection!');                
                    } 
                }
            }
        }
    }
    public static void makeApprovalCommentsMandatory2(List<Campaign> campList,Map<id,Campaign> oldMap){
        //If User Rejects Approval Process then comments are mandatory     
        System.debug(' method2 --');      
        for(Campaign camp : campList){ 
            system.debug('camp status-->'+camp.Approval_Status2__c);
            //If( camp.Approval_Status2__c == 'Pending'){
            //For(ProcessInstance pi :[SELECT Id, Status, TargetObjectId FROM ProcessInstance WHERE TargetObjectId =: camp.Id]){
            //    ProcessInstanceStep piStep = [SELECT Id, ProcessInstanceId, StepStatus, Comments FROM ProcessInstanceStep WHERE ProcessInstanceId =: pi.Id AND StepStatus =: 'Rejected' limit 1];
            ProcessDefinition pd = [Select Id,DeveloperName from ProcessDefinition where DeveloperName = 'Approval_on_Planned_Budget_Update'];
            for (ProcessInstance pi :[SELECT Id,ProcessDefinitionId,Status,TargetObjectId, (SELECT Id, stepStatus, Comments FROM Steps WHERE StepStatus =: 'Rejected' ORDER BY CreatedDate DESC  LIMIT 1) FROM ProcessInstance WHERE TargetObjectId =: camp.Id AND ProcessDefinitionId=:pd.Id]){
                system.debug('pi ==>'+ pi);
                system.debug('pi.Status ==> '+pi.Status);
                //system.debug('pi.StepStatus ==> '+pi.steps);
                //system.debug('comments'+pi.Steps[0].Comments);
                if(pi.Steps.size()>0 && pi.Steps != null && pi.Status != 'Approved'){
                    if(pi.Steps[0].StepStatus == 'Rejected'){
                        if(pi.Steps[0].Comments == null){                       
                            camp.addError('Please provide a reason for your rejection!');                
                        }
                    }   
                }                
            }
            // }
        }
    }
    public static void main(List<Campaign> campList, Map<Id,Campaign> oldMap){
        system.debug('campList--'+campList);
        Set<Id> parentCampaignIds = new Set<Id>();
        Set<Id> currentChildId = new Set<Id>();
        if(!campList.isEmpty()){
            for (Campaign campaign : campList) {
                if (campaign.ParentId != null) {
                    parentCampaignIds.add(campaign.ParentId);
                }
                currentChildId.add(campaign.Id);
            }
        }
        List<Campaign> parentCampaigns = [SELECT Id, Available_Budget__c,ActualCost, StartDate, EndDate,Project__c,Project__r.Name,
                                          (SELECT Id, ActualCost FROM ChildCampaigns where Id NOT IN:currentChildId)
                                          FROM Campaign
                                          WHERE Id IN :parentCampaignIds];
        
        Map<Id, Decimal> parentCampaignActualCosts = new Map<Id, Decimal>();
        Map<Id, Date> parentCampaignStartDate = new Map<Id, Date>();
        Map<Id, Date> parentCampaignEndDate = new Map<Id, Date>();
        Map<Id, String> parentCampaignProject = new Map<Id, String>();
        Map<Id, String> parentCampaignProjectName = new Map<Id, String>();
        Map<Id, List<Campaign>> childCampaignsByParent = new Map<Id, List<Campaign>>();
        
        if(!parentCampaigns.isEmpty()){
            for (Campaign parentCampaign : parentCampaigns) {
                parentCampaignActualCosts.put(parentCampaign.Id, parentCampaign.Available_Budget__c);
                parentCampaignStartDate.put(parentCampaign.Id, parentCampaign.StartDate);
                parentCampaignEndDate.put(parentCampaign.Id, parentCampaign.EndDate);
                parentCampaignProject.put(parentCampaign.Id, parentCampaign.Project__c);
                parentCampaignProjectName.put(parentCampaign.Id, parentCampaign.Project__r.Name);
                
                List<Campaign> childCampaigns = parentCampaign.ChildCampaigns;
                if (!childCampaigns.isEmpty()) {
                    childCampaignsByParent.put(parentCampaign.Id, childCampaigns);
                }
            }
            
            for (Campaign parentCampaign : parentCampaigns) {
                List<Campaign> childCampaigns = childCampaignsByParent.get(parentCampaign.Id);
                
                Decimal totalChildCampaignActualCost = 0;
                
                if (childCampaigns != null) {    
                    // Calculate the total ActualCost of existing child campaigns
                    for (Campaign childCampaign : childCampaigns) {
                        totalChildCampaignActualCost += childCampaign.ActualCost;
                    }
                }
                Decimal parentCampaignActualCost = parentCampaignActualCosts.get(parentCampaign.Id);
                
                Decimal newChildCampaignActualCost = parentCampaignActualCost - totalChildCampaignActualCost;
                system.debug('newChildCampaignActualCost-->'+newChildCampaignActualCost);
                for (Campaign camp : campList) {
                    if(camp.ActualCost > newChildCampaignActualCost){
                        camp.ActualCost.addError('Planned Budget of this Child Campaign cannot be greater than : '+newChildCampaignActualCost);
                    }
                    else if(camp.StartDate < parentCampaignStartDate.get(camp.ParentId) || camp.StartDate > parentCampaignEndDate.get(camp.ParentId)){
                        camp.StartDate.addError('Start Date must Lie between Range : '+date.valueOf(parentCampaignStartDate.get(camp.ParentId))+' and '+date.valueOf(parentCampaignEndDate.get(camp.ParentId)));
                    }
                    else if(camp.EndDate > parentCampaignEndDate.get(camp.ParentId)){
                        camp.EndDate.addError('End Date must not exceed: '+parentCampaignEndDate.get(camp.ParentId));
                    }
                    else if(camp.EndDate < camp.StartDate){
                        camp.EndDate.addError('End Date must be greater than or equal to start date.');
                    }
                    else if(camp.Project__c != parentCampaignProject.get(camp.ParentId)){
                        camp.Project__c.addError('Selected Project must be same as Parent i.e - '+parentCampaignProjectName.get(camp.ParentId));
                    }
                    else if(camp.StartDate == system.today()){
                        camp.Status = 'In Progress';
                    }
                }
            }
        }
        else {
            for(Campaign camp : campList){
                if(camp.IsActive == true && camp.StartDate == system.today() && (camp.Status != 'Completed' && camp.Status != 'Aborted')){
                    camp.Status = 'In Progress';
                }
                else if(camp.EndDate < camp.StartDate){
                    camp.EndDate.addError('End Date must be greater than or equal to start date.');
                }
            }
        }
    }
}