public without sharing class SuggestedPropertyTriggerHandler {
    
    public static void statusUpdate(Map<Id,Suggested_Property__c> sPropertyNewMap, Map<Id,Suggested_Property__c> sPropertyOldMap){   //considered bulk Processing
        List<Suggested_Property__c> requiredSPropertyList = new List<Suggested_Property__c>();
        
        for(Suggested_Property__c sp : sPropertyNewMap.values()){
            if(sPropertyOldMap.get(sp.Id).Status__c!=sPropertyNewMap.get(sp.Id).status__c){ 
                requiredSPropertyList.add(sp);
                system.debug('requiredSPropertyList=='+requiredSPropertyList);
            } 
        }
        
        Set<Id> ShortListedIds = new Set<Id>();
        Set<Id> ReservedIds = new Set<Id>();
        Set<Id> InProgressIds = new Set<Id>();
        Set<Id> BookedIds = new Set<Id>();
        Set<Id> UnavailableIds = new Set<Id>();
        Set<Id> RequiredListId = new Set<Id>();
        Set<Id> currentRelatedOpportunityIds = new Set<Id>();
        for(Suggested_Property__c sproperty : requiredSPropertyList){   
            currentRelatedOpportunityIds.add(sproperty.Opportunity__c);
            RequiredListId.add(sproperty.id);
            if(sproperty.status__c == 'Short Listed'){
                ShortListedIds.add(sproperty.Unit__c);
                system.debug('ShortListedIds=='+ShortListedIds);
            }
            else if(sproperty.Status__c == 'Reserved'){
                ReservedIds.add(sproperty.Unit__c);
            }
            else if(sproperty.Status__c == 'In Progress'){
                InProgressIds.add(sproperty.Unit__c);
            }
            else if(sproperty.Status__c == 'Booked'){
                BookedIds.add(sproperty.Unit__c);
            }
            else if(sproperty.Status__c == 'Unavailable'){
                UnavailableIds.add(sproperty.Unit__c);
            }
        }
        system.debug('ShortListedIds=='+ShortListedIds);
        system.debug('ReservedIds=='+ReservedIds);
        system.debug('InProgressIds=='+InProgressIds);
        system.debug('BookedIds=='+BookedIds);
         system.debug('UnavailableIds=='+UnavailableIds);
        
        List<Suggested_Property__c> suggestedPropertiesToUpdate = new List<Suggested_Property__c>();
        List<Property__c> PropertiesToUpdate = new List<Property__c>();
        //when sProperty status changed to Short Listed
        if(ShortListedIds!=null && ShortListedIds.size()>0){   
            
            for(Suggested_Property__c sProperty : [Select id,Status__c from Suggested_Property__c where Status__c='Unavailable' AND Unit__c IN: ShortListedIds]){
               sProperty.Status__c = 'Short Listed'; 
               suggestedPropertiesToUpdate.add(sProperty);
            }
            for(Property__c property : [Select id,Property_Status__c from Property__c where Id IN: ShortListedIds])
            {
                property.Property_Status__c = 'Available';
                PropertiesToUpdate.add(property);
            }
        }
        //when sProperty status changed to Reserved
        if(ReservedIds!=null && ReservedIds.size()>0){

            for(Suggested_Property__c sProperty : [SELECT id,Status__c FROM Suggested_Property__c WHERE Status__c= 'Short Listed' AND Unit__c IN: ReservedIds])
            {
               sProperty.Status__c = 'Unavailable'; 
               suggestedPropertiesToUpdate.add(sProperty);
            }
            for(Property__c property : [Select id,Property_Status__c from Property__c where Id IN: ReservedIds])
            {
                property.Property_Status__c = 'Reserved';
                PropertiesToUpdate.add(property);
            }
        }
        system.debug('suggestedPropertiesToUpdate=='+suggestedPropertiesToUpdate);
        system.debug('PropertiesToUpdate=='+PropertiesToUpdate);
        //when sProperty status changed to In Progress
        if(InProgressIds!=null && InProgressIds.size()>0){   
            
            for(Suggested_Property__c sProperty : [SELECT id,Status__c FROM Suggested_Property__c WHERE Status__c='Short Listed' AND Unit__c IN: InProgressIds]){
               sProperty.Status__c = 'Unavailable'; 
               suggestedPropertiesToUpdate.add(sProperty);
            }
            for(Property__c property : [Select id,Property_Status__c from Property__c where Id IN: InProgressIds])
            {
                property.Property_Status__c = 'In Progress';
                PropertiesToUpdate.add(property);
            }
        }
        //when sProperty status changed to Booked
        List<Opportunity> opportunityListToUpdate = new List<Opportunity>();
        Set<Id> opportunityIds = new Set<Id>();
        Set<Id> sPropertyIds = new Set<Id>();
        If(BookedIds!=null && BookedIds.size()>0)
        {   for(Suggested_Property__c sProperty : [Select id,Status__c,Opportunity__c from Suggested_Property__c where Status__c='Short Listed' AND Unit__c IN: BookedIds])
            {
               sProperty.Status__c = 'Unavailable'; 
               suggestedPropertiesToUpdate.add(sProperty);
               opportunityIds.add(sProperty.Opportunity__c);
               sPropertyIds.add(sProperty.id);
            }
            for(Property__c property : [Select id,Property_Status__c from Property__c where Id IN: BookedIds])
            {
                property.Property_Status__c = 'Booked';
                PropertiesToUpdate.add(property);
            }
            for(Opportunity opp : [Select id, StageName from Opportunity where Id IN: currentRelatedOpportunityIds])
            {   System.debug('opp--'+opp);
                opp.StageName = 'Closed Won';
                opportunityListToUpdate.add(opp);
            }
            System.debug('opportunityListToUpdate--'+opportunityListToUpdate);
            for(Suggested_Property__c OtherSProperty : [Select id,Status__c from Suggested_Property__c where Id Not IN: sPropertyIds AND Opportunity__c IN: currentRelatedOpportunityIds AND Id Not IN: RequiredListId])
            {
                OtherSProperty.Status__c = 'Cancelled';  
                suggestedPropertiesToUpdate.add(OtherSProperty);
            }
         }
                 
         //Update suggested properties, properties and opportunities
         if(suggestedPropertiesToUpdate!=null && suggestedPropertiesToUpdate.size()>0)
         {
             system.debug('suggestedPropertiesToUpdate=='+ suggestedPropertiesToUpdate);
             update suggestedPropertiesToUpdate;
           
         }
         if(PropertiesToUpdate!=null && PropertiesToUpdate.size()>0)
             update PropertiesToUpdate;
         if(opportunityListToUpdate!=null && opportunityListToUpdate.size()>0)
             update opportunityListToUpdate;
    }
}