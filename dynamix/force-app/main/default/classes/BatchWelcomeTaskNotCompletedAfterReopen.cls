global class BatchWelcomeTaskNotCompletedAfterReopen implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(DataBase.BatchableContext bc){
        Date pastOneDays = System.Today().addDays(-1);
        return Database.getQueryLocator('Select Id,Name,OwnerId,Project_Name_Formulla__c,Unit_Number__c,Reinitiated_Date__c From Booking__c Where ReOpen_Date__c =: pastOneDays');
    }
    global void execute(Database.BatchableContext bc,List<Booking__c> BookingList){
        
        Set<Id> setOfBookingIds = new Set<Id>(); 
        for(Booking__c bookObj : BookingList){
            setOfBookingIds.add(bookObj.Id);
        }
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Please_Complete_Welcome_Task' limit 1];
        
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User]);
        List<String> ccList = new List<String>();
        List<Task> listOfWelcomeTask = new List<Task>([Select Id,Status,Subject,WhatId From Task Where Subject =: 'Welcome Call' AND whatId In : setOfBookingIds]);
        Map<Id,Task> mapBookingIdToSDRLetterTask = new Map<Id,Task>();
        for(Task taskObj : listOfWelcomeTask){
            mapBookingIdToSDRLetterTask.put(taskObj.WhatId,taskObj);
        }        
        for(Booking__c bookObj : BookingList){
            if(mapBookingIdToSDRLetterTask.size() > 0 && mapBookingIdToSDRLetterTask.containsKey(bookObj.Id)){
                Task welcomeTask = mapBookingIdToSDRLetterTask.get(bookObj.Id);
                if(welcomeTask.Status != 'Completed'){
                    ccList.clear();
                    ccList.add(mapIdToUser.get(bookObj.OwnerId).Email);
                    String htmlBody = emailTemplate.HtmlValue;
                    String plainBody = emailTemplate.Body;
                    htmlBody = htmlBody.replace('{!RM}', mapIdToUser.get(bookObj.OwnerId).Name);
                    htmlBody = htmlBody.replace('{!Unit}', bookObj.Unit_Number__c);
                    htmlBody = htmlBody.replace('{!Name}', bookObj.Name);
                    htmlBody = htmlBody.replace('{!Project}', bookObj.Project_Name_Formulla__c);
                    
                    SendEmailandBellNotificationUtility.SendEmail2(String.ValueOf(emailTemplate.Id),
                                                                   
                                                                   htmlBody,
                                                                   plainBody,
                                                                   ccList,
                                                                   null,true,bookObj.Id
                                                                   ,null,null,null);
                    
                }
            }
        }
    } 
    global void finish(Database.BatchableContext bc){
        
    }
}