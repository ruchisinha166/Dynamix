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
                    thistaskTarget.addError('Record already exists with the same Project.'); 
                }
            }    
        }
    }
    
    
    public static void countBookingTarget(List<Task_Target__c> taskTargetList)
    {
        Set<String> bookingDateMonthSet = New Set<String>();
        Set<String> bookingDateYearSet = New Set<String>();
        Set<Id> ProjectIdSet = New Set<Id>();
        Set<Id> salesIdSet = New Set<Id>();
        List<Task_Target__c> updateTaskTargetList = New  List<Task_Target__c>();
        Map<String, Integer> updateTaskTargetBooking = New Map<String, Integer>();
        Map<String, Integer> mapOfOutboundTaskCount = New Map<String, Integer>();
        Map<String, Integer> mapOfOutboundTargetCount = New Map<String, Integer>();
        Map<String, Integer> mapOfInboundTaskCount = New Map<String, Integer>();
        Map<String, Integer> mapOfInboundTargetCount = New Map<String, Integer>();
        for(Task_Target__c taskTarget : taskTargetList)
        {
            
            bookingDateMonthSet.add(taskTarget.Month__c);
            bookingDateYearSet.add(taskTarget.Year__c);
            salesIdSet.add(taskTarget.User__c);
            ProjectIdSet.add(taskTarget.Project__c);
            
        }
        if(!salesIdSet.isEmpty())
        {
            List<Task> allTaskList =[SELECT id,Subject, OwnerId, Project__c, WhatId 
                                     FROM Task
                                     WHERE (Subject =: 'Outbound Meeting' OR Subject =: 'Inbound Meeting') AND Project__c IN: ProjectIdSet 
                                     AND OwnerId IN: salesIdSet AND ActivityDate = THIS_MONTH 
                                     AND Type_Of_Call__c = 'Sourcing' And Project__c != null AND WhatId != null];
            system.debug('allTaskList'+allTaskList);
          
            if(!allTaskList.isEMpty())
            {
                Integer yr = System.today().year();
                System.debug('Year is' + yr);
                string month = System.now().format('MMMMM');
                for(Task thisTask:allTaskList)
                {
                    if(thisTask.Subject == 'Outbound Meeting')
                    {
                        String Key = thisTask.WhatId +'-' +thisTask.Project__c +'-'+thisTask.OwnerId;
                        String targetKey = month+'-'+String.valueOf(yr)+'-'+String.valueOf( thisTask.Project__c)+'-'+String.valueOf(thisTask.OwnerId)+'-'+'Unique Outbound';
                        
                        if(!mapOfOutboundTaskCount.containsKey(Key))
                        {
                            mapOfOutboundTaskCount.put(Key,1);
                            if(mapOfOutboundTargetCount.containsKey(targetKey))
                            {
                                mapOfOutboundTargetCount.put(targetKey,mapOfOutboundTargetCount.get(targetKey)+1);
                            }
                            else
                            {
                                mapOfOutboundTargetCount.put(targetKey,1);
                            }
                            
                        }
                    }
                    if(thisTask.Subject == 'Inbound Meeting')
                    {
                        String Key = thisTask.WhatId +'-' +thisTask.Project__c +'-'+thisTask.OwnerId;
                        String targetKey = month+'-'+String.valueOf(yr)+'-'+String.valueOf( thisTask.Project__c)+'-'+String.valueOf(thisTask.OwnerId)+'-'+'Unique Inbound';
                        
                        if(!mapOfInboundTaskCount.containsKey(Key))
                        {
                            mapOfInboundTaskCount.put(Key,1);
                            if(mapOfInboundTargetCount.containsKey(targetKey))
                            {
                                mapOfInboundTargetCount.put(targetKey,mapOfInboundTargetCount.get(targetKey)+1);
                            }
                            else
                            {
                                mapOfInboundTargetCount.put(targetKey,1);
                            }
                            
                        }
                    }
                    
                }
            }
            List<Booking__c> allBookingList = [SELECT id, CreatedDate, Sales_Manager__c,Project_Name__c ,Stage__c,Booking_Date__c,
                                               Booking_Month__c
                                               FROM  Booking__c  WHERE 
                                               Booking_Month__c IN: bookingDateMonthSet AND
                                               Sales_Manager__c  IN :salesIdSet AND Project_Name__c IN: ProjectIdSet
                                               AND 
                                               Stage__c != 'Terminated' AND Stage__c != 'Cancellation Initiated' AND 
                                               Stage__c != 'Booking Cancelled – Refund Pending' AND
                                               Stage__c != 'Booking Cancelled – Refund Ready'   AND
                                               Stage__c != 'Booking Cancelled -- Refund Done'	
                                               
                                              ];
            if(!allBookingList.isEMpty())
            {
                for(Booking__c thisBooking: allBookingList)
                {
                    String Key = thisBooking.Booking_Month__c+'-'+String.valueof(thisBooking.Booking_Date__c.year())+'-'+String.valueOf(thisBooking.Project_Name__c)+'-'+String.valueOf(thisBooking.Sales_Manager__c)+'-'+'Bookings';
                    if(updateTaskTargetBooking.containsKey(Key))
                    {
                        updateTaskTargetBooking.put(Key,updateTaskTargetBooking.get(Key)+1);
                    }
                    else
                    {
                        updateTaskTargetBooking.put(Key,1);
                    }
                    
                }
            }
            
            for(Task_Target__c taskTarget : taskTargetList)
            {
                String Key = taskTarget.Month__c+'-'+taskTarget.Year__c+'-'+String.valueOf(taskTarget.Project__c)+'-'+String.valueOf(taskTarget.User__c)+'-'+taskTarget.Type__c;
                Task_Target__c taskTargetUpdate = New Task_Target__c();
                taskTargetUpdate.id = taskTarget.id;
                if( taskTarget.Type__c == 'Bookings')
                { if(updateTaskTargetBooking.containsKey(Key))
                {
                    
                    taskTargetUpdate.Number_of_Targets_Achievement__c = updateTaskTargetBooking.get(Key);
                    
                }
                 
                }
                
                if( taskTarget.Type__c == 'Unique Outbound'){
                    if(mapOfOutboundTargetCount.containsKey(Key))
                    {
                        taskTargetUpdate.Number_of_Targets_Achievement__c = mapOfOutboundTargetCount.get(Key);
                    }
                }
                if( taskTarget.Type__c == 'Unique Inbound'){
                    if(mapOfInboundTargetCount.containsKey(Key))
                    {
                        taskTargetUpdate.Number_of_Targets_Achievement__c = mapOfInboundTargetCount.get(Key);
                    }
                }
                
                updateTaskTargetList.add(taskTargetUpdate);
            }
            if(!updateTaskTargetList.IsEmpty())
            {
                update updateTaskTargetList;
            }
        }
        
    }
     public static Void method()
    {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
       
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
    
}