public class TaskTargetTriggerHandler {
    public static void duplicate(List<Task_Target__c> taskTargetList)
    {
        Set<Id> projectId = New Set<Id>();
        Set<String> month = New Set<String>();
        Set<String> year = New Set<String>();
        Set<Id> userId = New Set<Id>();
        for(Task_Target__c thistaskTarget : taskTargetList){
            projectId.add(thistaskTarget.Project__c);
            month.add(thistaskTarget.Month__c);
            year.add(thistaskTarget.Year__c);
            userId.add(thistaskTarget.user__c);
        }
        
        List<Task_Target__c> allTaskTargetList = [SELECT Id, Project__c, Year__c, Month__c,
                                                  user__c, Type__c 
                                                  FROM Task_Target__c WHERE Id != :taskTargetList 
                                                 // AND Type__c = 'Walk-In'
                                                  AND user__c IN : userId
                                                  AND Year__c IN : year
                                                  AND Month__c IN : month
                                                 ];
        system.debug('allTaskTargetList----'+allTaskTargetList);
        Map<String,Task_Target__c> taskTargetMap = new Map<String,Task_Target__c>();
        for(Task_Target__c thistaskTarget : allTaskTargetList){
            string Key = thistaskTarget.Month__c+'-'+thistaskTarget.Year__c+'-'+thistaskTarget.Type__c+'-'+String.valueOf(thistaskTarget.Project__c)+'-'+String.valueOf(thistaskTarget.User__c);
            system.debug('Key 1'+Key);
            taskTargetMap.put(Key,thistaskTarget);
        }
        if(!taskTargetMap.keyset().isEmpty()){
            for(Task_Target__c thistaskTarget : taskTargetList){
                string Key = thistaskTarget.Month__c+'-'+thistaskTarget.Year__c+'-'+thistaskTarget.Type__c+'-'+String.valueOf(thistaskTarget.Project__c)+'-'+String.valueOf(thistaskTarget.User__c);
                if(taskTargetMap.containsKey(Key)){
                    thistaskTarget.addError('Already exist a record with same Project.'); 
                }
            }    
        }
    }
    
}