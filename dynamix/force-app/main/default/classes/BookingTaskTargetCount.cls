public class BookingTaskTargetCount {
    public static void bookingTaskTarget(List<Booking__c> bookingList, Map<Id,Booking__c> oldMapOfBooking)
    {
        Set<Id> projectIdSet = New Set<Id>();
        Set<Id> salesIdSet = New Set<Id>();
        Set<Id> bookingIdSet = New Set<Id>();
        Set<Date> bookingDateSet = New Set<Date>();
        Set<Id> projectId = New Set<Id>();
        Set<String> bookingDateMonthSet = New Set<String>();
        Set<String> bookingDateYearSet = New Set<String>();
        List<Booking__c> updateBookingMap = New List<Booking__c> ();
        Map<String, Integer> updateTaskTargetBooking = New Map<String, Integer>();
        for(Booking__c thisBooking: bookingList)
        {
            if(thisBooking.Stage__c != 'Terminated' && thisBooking.Stage__c != 'Cancellation Initiated' && 
               thisBooking.Stage__c != 'Booking Cancelled – Refund Pending' &&
               thisBooking.Stage__c != 'Booking Cancelled – Refund Ready'   &&
               thisBooking.Stage__c != 'Booking Cancelled -- Refund Done')
            {
                if(oldMapOfBooking != null)
                {if( thisBooking.Sales_Manager__c != oldMapOfBooking.get(thisBooking.id).Sales_Manager__c 
                    || thisBooking.Booking_Date__c != oldMapOfBooking.get(thisBooking.id).Booking_Date__c
                    || thisBooking.Project_Name__c != oldMapOfBooking.get(thisBooking.id).Project_Name__c){
                        String Key = oldMapOfBooking.get(thisBooking.id).Booking_Month__c+'-'+String.valueof(oldMapOfBooking.get(thisBooking.id).Booking_Date__c.year())+'-'+String.valueOf(oldMapOfBooking.get(thisBooking.id).Project_Name__c)+'-'+String.valueOf( oldMapOfBooking.get(thisBooking.id).Sales_Manager__c);
                        
                        if(thisBooking.Project_Name__c != oldMapOfBooking.get(thisBooking.id).Project_Name__c && thisBooking.Project_Name__c != null)
                        {
                            ProjectIdSet.add(oldMapOfBooking.get(thisBooking.id).Project_Name__c);
                        }
                        ProjectIdSet.add(thisBooking.Project_Name__c);
                        if(thisBooking.Sales_Manager__c != null)
                        {
                            salesIdSet.add(thisBooking.Sales_Manager__c);
                        }
                        if(thisBooking.Sales_Manager__c != null && thisBooking.Sales_Manager__c != oldMapOfBooking.get(thisBooking.id).Sales_Manager__c )
                        {
                            salesIdSet.add(oldMapOfBooking.get(thisBooking.id).Sales_Manager__c);
                        }
                        if(thisBooking.Booking_Date__c != null )
                        {
                            bookingDateSet.add(thisBooking.Booking_Date__c);
                            bookingDateMonthSet.add(thisBooking.Booking_Month__c);
                            bookingDateYearSet.add(String.valueOf(thisBooking.Booking_Date__c.year()));
                        }
                        if(thisBooking.Booking_Date__c != null &&  thisBooking.Booking_Date__c !=  oldMapOfBooking.get(thisBooking.id).Booking_Date__c)
                        {
                            bookingDateSet.add(oldMapOfBooking.get(thisBooking.id).Booking_Date__c);
                            bookingDateMonthSet.add(oldMapOfBooking.get(thisBooking.id).Booking_Month__c);
                            bookingDateYearSet.add(String.valueOf(oldMapOfBooking.get(thisBooking.id).Booking_Date__c.year()));
                        }
                        
                        updateTaskTargetBooking.put(Key,0);
                        
                    }
                 
                }
                else
                {
                    ProjectIdSet.add(thisBooking.Project_Name__c);
                    if(thisBooking.Sales_Manager__c != null)
                    {
                        salesIdSet.add(thisBooking.Sales_Manager__c);
                    }
                    if(thisBooking.Booking_Date__c != null)
                    {
                        // bookingDateSet.add(thisBooking.Booking_Date__c);
                        bookingDateMonthSet.add(thisBooking.Booking_Month__c);
                        bookingDateYearSet.add(String.valueOf(thisBooking.Booking_Date__c.year()));
                    }
                    
                }
                bookingIdSet.add(thisBooking.id);
            }
        }
        List<Task_Target__c> taskTargetList = [SELECT Id, Name, User__c, Month__c,Type__c,
                                               Year__c, Number_of_Targets_Achievement__c,
                                               X1st_Week__c, X2nd_Week__c, X3rd_Week__c,
                                               X4th_Week__c, X5th_Week__c, Project__c,
                                               Number_of_Connected_Call__c, No_of_Walk_ins__c, No_of_Follow_Ups__c
                                               FROM Task_Target__c
                                               WHERE User__c IN :salesIdSet  AND Year__c IN :bookingDateYearSet 
                                               AND Month__c IN: bookingDateMonthSet
                                               AND Project__c IN: ProjectIdSet AND Type__c =: 'Bookings'];
        Map<String, ID> MapOfTaskTarget = New Map<String, ID>();
        for(Task_Target__c taskTarget : taskTargetList)
        {
            String Key = taskTarget.Month__c+'-'+taskTarget.Year__c+'-'+String.valueOf(taskTarget.Project__c)+'-'+String.valueOf(taskTarget.User__c);
            MapOfTaskTarget.put(Key,taskTarget.id);
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
        
        Map<Id, Task_Target__c> updateTaskTarget = New Map<Id, Task_Target__c>();
        //Map<Id, Booking__c> updateBookingMap= New Map<Id, Booking__c>();
        for(Booking__c thisBooking: allBookingList)
        {
            String monthName ;
            if(thisBooking.Booking_Date__c != null)
            {
                monthName = String.valueof(thisBooking.Booking_Date__c.year());
            }
            else
            {
                monthName   = String.valueof(system.today().year());
            }
            String Key = thisBooking.Booking_Month__c+'-'+String.valueof(thisBooking.Booking_Date__c.year())+'-'+String.valueOf(thisBooking.Project_Name__c)+'-'+String.valueOf(thisBooking.Sales_Manager__c);
            if(updateTaskTargetBooking.containsKey(Key))
            {
                updateTaskTargetBooking.put(Key,updateTaskTargetBooking.get(Key)+1);
            }
            else
            {
                updateTaskTargetBooking.put(Key,1);
            }
            /*if(MapOfTaskTarget.containsKey(Key))
{
thisBooking.Task_Target__c = MapOfTaskTarget.get(Key);
updateBookingMap.add(thisBooking);
}
else
{
thisBooking.Task_Target__c = null;
}*/
        }
        
        for(Task_Target__c taskTarget : taskTargetList)
        {
            String Key = taskTarget.Month__c+'-'+taskTarget.Year__c+'-'+String.valueOf(taskTarget.Project__c)+'-'+String.valueOf(taskTarget.User__c);
            system.debug('Task Target---');
            System.debug('Key' + Key);
            if( taskTarget.Type__c == 'Bookings' && updateTaskTargetBooking.containsKey(Key)){
                Task_Target__c taskTargetUpdate = New Task_Target__c();
                taskTargetUpdate.id = taskTarget.id;
                taskTargetUpdate.Number_of_Targets_Achievement__c = updateTaskTargetBooking.get(Key);
                updateTaskTarget.put(taskTargetUpdate.id,taskTargetUpdate);
                system.debug('taskTarget.id'+taskTarget.id);
            }
        }
        
        if(!updateTaskTarget.values().IsEmpty())
        {
            update updateTaskTarget.values();
        }
        if(!updateBookingMap.IsEmpty())
        {
            // update updateBookingMap;
        }
    }
    public static void bookingCancellationTaskTarget(List<Booking__c> bookingList, Map<Id,Booking__c> mapOfBooking)
    {
        Set<Id> projectIdSet = New Set<Id>();
        Set<Id> salesIdSet = New Set<Id>();
        Set<String> bookingDateMonthSet = New Set<String>();
        Set<String> bookingDateYearSet = New Set<String>();
        List<Booking__c> cancellationBookingList = New List<Booking__c>();
        for(Booking__c thisBooking: bookingList)
        {
            if((thisBooking.Stage__c == 'Terminated' ||  thisBooking.Stage__c == 'Cancellation Initiated' || thisBooking.Stage__c == 'Booking Cancelled -- Refund Done' || 
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
                if(thisBooking.Booking_Date__c != null )
                {
                    //  bookingDateSet.add(thisBooking.Booking_Date__c);
                    bookingDateMonthSet.add(thisBooking.Booking_Month__c);
                    bookingDateYearSet.add(String.valueOf(thisBooking.Booking_Date__c.year()));
                }
                
                cancellationBookingList.add(thisBooking);
                
            }
        }
        System.debug('cancellationBookingList'+cancellationBookingList);
        if(!cancellationBookingList.isEmpty()){
            List<Task_Target__c> taskTargetList = [SELECT Id, Name, User__c, Month__c,Type__c,
                                                   Year__c, Number_of_Targets_Achievement__c,
                                                   X1st_Week__c, X2nd_Week__c, X3rd_Week__c,
                                                   X4th_Week__c, X5th_Week__c, Project__c,
                                                   Number_of_Connected_Call__c, No_of_Walk_ins__c, No_of_Follow_Ups__c
                                                   FROM Task_Target__c
                                                   WHERE User__c IN :salesIdSet  AND Year__c IN :bookingDateYearSet 
                                                   AND Month__c IN: bookingDateMonthSet
                                                   AND Project__c IN: ProjectIdSet AND Type__c =: 'Bookings'];
            System.debug('taskTargetList'+taskTargetList);
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
                String Key = thisBooking.Booking_Month__c+'-'+String.valueof(thisBooking.Booking_Date__c.year())+'-'+String.valueOf(thisBooking.Project_Name__c)+'-'+String.valueOf(thisBooking.Sales_Manager__c);
                System.debug('Key'+Key);
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
                System.debug('updateTaskTarget'+updateTaskTarget);
                update updateTaskTarget.values();
            }
        }
    }
    
    public static void removeBookingFromTaskTarget(List<Booking__c> bookingList)
    {
        Set<Id> projectIdSet = New Set<Id>();
        Set<Id> salesIdSet = New Set<Id>();
        Set<Id> bookingIdSet = New Set<Id>();
        Set<Date> bookingDateSet = New Set<Date>();
        Set<Id> projectId = New Set<Id>();
        Set<String> bookingDateMonthSet = New Set<String>();
        Set<String> bookingDateYearSet = New Set<String>();
        List<Booking__c> updateBookingMap = New List<Booking__c> ();
        Map<String, Integer> updateTaskTargetBooking = New Map<String, Integer>();
        List<Booking__c> deletedBookingList = New List<Booking__c>();
        
        for(Booking__c thisBooking: bookingList)
        {
            System.debug('thisBooking.Project_Name__c'+thisBooking.Project_Name__c);
            System.debug('thisBooking.Sales_Manager__c'+thisBooking.Sales_Manager__c);
            System.debug('thisBooking.Booking_Date__c'+thisBooking.Booking_Date__c);
            if(thisBooking.Project_Name__c != null && thisBooking.Sales_Manager__c != null && thisBooking.Booking_Date__c != null){
                ProjectIdSet.add(thisBooking.Project_Name__c);
                if(thisBooking.Sales_Manager__c != null)
                {
                    salesIdSet.add(thisBooking.Sales_Manager__c);
                }
                if(thisBooking.Booking_Date__c != null)
                {
                    // bookingDateSet.add(thisBooking.Booking_Date__c);
                    bookingDateMonthSet.add(thisBooking.Booking_Month__c);
                    bookingDateYearSet.add(String.valueOf(thisBooking.Booking_Date__c.year()));
                }
                deletedBookingList.add(thisBooking);
            }
        }
        if(!deletedBookingList.isEmpty()){
            List<Task_Target__c> taskTargetList = [SELECT Id, Name, User__c, Month__c,Type__c,
                                                   Year__c, Number_of_Targets_Achievement__c,
                                                   X1st_Week__c, X2nd_Week__c, X3rd_Week__c,
                                                   X4th_Week__c, X5th_Week__c, Project__c,
                                                   Number_of_Connected_Call__c, No_of_Walk_ins__c, No_of_Follow_Ups__c
                                                   FROM Task_Target__c
                                                   WHERE User__c IN :salesIdSet  AND Year__c IN :bookingDateYearSet 
                                                   AND Month__c IN: bookingDateMonthSet
                                                   AND Project__c IN: ProjectIdSet AND Type__c =: 'Bookings'];
            System.debug('taskTargetList'+taskTargetList);
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
            for(Booking__c thisBooking: deletedBookingList)
            {
                String Key = thisBooking.Booking_Month__c+'-'+String.valueof(thisBooking.Booking_Date__c.year())+'-'+String.valueOf(thisBooking.Project_Name__c)+'-'+String.valueOf(thisBooking.Sales_Manager__c);
                System.debug('Key'+Key);
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
                System.debug('updateTaskTarget'+updateTaskTarget);
                update updateTaskTarget.values();
            }
        }
    }
}