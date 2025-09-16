public class BookingTaskTargetCount {
    public static void bookingTaskTarget(List<Booking__c> bookingList)
    {
        Set<Id> projectIdSet = New Set<Id>();
        Set<Id> salesIdSet = New Set<Id>();
        Set<Id> projectId = New Set<Id>();
        for(Booking__c thisBooking: bookingList)
        {
            ProjectIdSet.add(thisBooking.Project_Name__c);
            if(thisBooking.Sales_Manager__c != null)
            {
                salesIdSet.add(thisBooking.Sales_Manager__c);
            }
        }
        List<Task_Target__c> taskTargetList = [SELECT Id, Name, User__c, Month__c,Type__c,
                                               Year__c, Number_of_Targets_Achievement__c,
                                               X1st_Week__c, X2nd_Week__c, X3rd_Week__c,
                                               X4th_Week__c, X5th_Week__c, Project__c,
                                               Number_of_Connected_Call__c, No_of_Walk_ins__c, No_of_Follow_Ups__c
                                               FROM Task_Target__c
                                               WHERE User__c IN :salesIdSet  AND Year__c = :String.valueof(System.today().year()) 
                                               AND Month__c =: System.now().format('MMMMM')
                                               AND Project__c IN: ProjectIdSet AND Type__c =: 'Bookings'];
        Map<String, Task_Target__c> updateTaskTarget = New Map<String, Task_Target__c>();
        
        Map<String, Task_Target__c> mapOfUserToGetTaskTargetId = New Map<String, Task_Target__c>();
        Map<String, Integer> mapUserForBooking = New Map<String, Integer>();
        for(Task_Target__c taskTarget : taskTargetList)
        {
            
            String Key = taskTarget.Month__c+'-'+taskTarget.Year__c+'-'+String.valueOf(taskTarget.Project__c)+'-'+String.valueOf(taskTarget.User__c);
            mapOfUserToGetTaskTargetId.put(Key,taskTarget);
            system.debug('Task Target---');
            System.debug('Key' + Key);
            if( taskTarget.Type__c == 'Bookings'){
                if(taskTarget.Number_of_Targets_Achievement__c == null)
                {
                    mapUserForBooking.put(Key,0);
                }
                else
                {
                    mapUserForBooking.put(Key,Integer.valueof(taskTarget.Number_of_Targets_Achievement__c));
                }
            }
        }
        for(Booking__c thisBooking: bookingList)
        {
            String Key = thisBooking.CreatedDate.format('MMMMM')+'-'+thisBooking.CreatedDate.year()+'-'+String.valueOf(thisBooking.Project_Name__c)+'-'+String.valueOf(thisBooking.Sales_Manager__c);
            
            if(mapOfUserToGetTaskTargetId.containsKey(Key))
            {
                Task_Target__c taskTarget = New Task_Target__c();
                taskTarget.id = mapOfUserToGetTaskTargetId.get(Key).id;
                mapUserForBooking.put(Key, mapUserForBooking.get(Key)+1);
                taskTarget.Number_of_Targets_Achievement__c = mapUserForBooking.get(Key);
                updateTaskTarget.put(taskTarget.id,taskTarget);
                
            }
        }
        if(!updateTaskTarget.values().IsEmpty())
        {
            update updateTaskTarget.values();
        }
    }
    public static void bookingCancellationTaskTarget(List<Booking__c> bookingList, Map<Id,Booking__c> mapOfBooking)
    {
        Set<Id> projectIdSet = New Set<Id>();
        Set<Id> salesIdSet = New Set<Id>();
        List<Booking__c> cancellationBookingList = New List<Booking__c>();
        for(Booking__c thisBooking: bookingList)
        {
            if((thisBooking.Stage__c == 'Terminated' ||  thisBooking.Stage__c =='Cancellation Initiated' ||
                thisBooking.Stage__c == 'Booking Cancelled – Refund Pending' ||  thisBooking.Stage__c =='Booking Cancelled – Refund Ready')
               && thisBooking.Stage__c != mapOfBooking.get(thisBooking.id).Stage__c )
            {
                if(thisBooking.Sales_Manager__c != null)
                {
                    salesIdSet.add(thisBooking.Sales_Manager__c);
                }
                if(thisBooking.Project_Name__c != null)
                {
                    ProjectIdSet.add(thisBooking.Project_Name__c);
                }
                
                cancellationBookingList.add(thisBooking);
                
            }
        }
        if(!cancellationBookingList.isEmpty()){
            List<Task_Target__c> taskTargetList = [SELECT Id, Name, User__c, Month__c,Type__c,
                                                   Year__c, Number_of_Targets_Achievement__c,
                                                   X1st_Week__c, X2nd_Week__c, X3rd_Week__c,
                                                   X4th_Week__c, X5th_Week__c, Project__c,
                                                   Number_of_Connected_Call__c, No_of_Walk_ins__c, No_of_Follow_Ups__c
                                                   FROM Task_Target__c
                                                   WHERE User__c IN :salesIdSet  AND Year__c = :String.valueof(System.today().year()) 
                                                   AND Month__c =: System.now().format('MMMMM')
                                                   AND Project__c IN: ProjectIdSet AND Type__c =: 'Bookings'];
            Map<String, Task_Target__c> updateTaskTarget = New Map<String, Task_Target__c>();
            
            Map<String, Task_Target__c> mapOfUserToGetTaskTargetId = New Map<String, Task_Target__c>();
            Map<String, Integer> mapUserForBooking = New Map<String, Integer>();
            for(Task_Target__c taskTarget : taskTargetList)
            {
                
                String Key = taskTarget.Month__c+'-'+taskTarget.Year__c+'-'+String.valueOf(taskTarget.Project__c)+'-'+String.valueOf(taskTarget.User__c);
                mapOfUserToGetTaskTargetId.put(Key,taskTarget);
                system.debug('Task Target---');
                System.debug('Key' + Key);
                if( taskTarget.Type__c == 'Bookings'){
                    if(taskTarget.Number_of_Targets_Achievement__c == null)
                    {
                        mapUserForBooking.put(Key,0);
                    }
                    else
                    {
                        mapUserForBooking.put(Key,Integer.valueof(taskTarget.Number_of_Targets_Achievement__c));
                    }
                }
            }
            for(Booking__c thisBooking: cancellationBookingList)
            {
                String Key = thisBooking.CreatedDate.format('MMMMM')+'-'+thisBooking.CreatedDate.year()+'-'+String.valueOf(thisBooking.Project_Name__c)+'-'+String.valueOf(thisBooking.Sales_Manager__c);
                
                if(mapOfUserToGetTaskTargetId.containsKey(Key))
                {
                    Task_Target__c taskTarget = New Task_Target__c();
                    taskTarget.id = mapOfUserToGetTaskTargetId.get(Key).id;
                    mapUserForBooking.put(Key, mapUserForBooking.get(Key)-1);
                    taskTarget.Number_of_Targets_Achievement__c = mapUserForBooking.get(Key);
                    updateTaskTarget.put(taskTarget.id,taskTarget);
                    
                }
            }
            if(!updateTaskTarget.values().IsEmpty())
            {
                update updateTaskTarget.values();
            }
        }
    }
    
}