//This Class will Run 10 AM Every Morning And will Send Email To RM If SDR Letter Sent Date is Past 7 Days And 
//TO CRM Head If SDR Letter Sent Date is Past 15 Days
global class BatchToSendEmailChallanRecievedClass implements DataBase.Batchable<Sobject>{
    
    global Database.QueryLocator start(DataBase.BatchableContext bc){
        Date pastSevenDays = System.Today().addDays(-7);
        Date pastFifteenDays = System.Today().addDays(-15);
        return Database.getQueryLocator('Select Id,Name,Project_Name_Formulla__c,Unit_Number__c,OwnerId,Stage__c,Owner.Name,SDR_Letter_Sent_Date__c From Booking__c Where SDR_Letter_Sent_Date__c =: pastSevenDays OR SDR_Letter_Sent_Date__c =: pastFifteenDays');
    }
    global void execute(Database.BatchableContext bc,List<Booking__c> BookingList){
        
        System.debug('In Execute Method');
        Set<Id> setOfBookingIds = new Set<Id>(); 
        for(Booking__c bookObj : BookingList){
            setOfBookingIds.add(bookObj.Id);
        }
        System.debug('setOfBookingIds'+setOfBookingIds);
        List<Task> listOfSDRLetterTask = new List<Task>([Select Id,Status,Subject,WhatId,OwnerId,ActivityDate From Task Where Subject =: 'SDR Letter for the Booking' AND Status != 'Completed' AND whatId In : setOfBookingIds]);
        System.debug('listOfSDRLetterTask'+listOfSDRLetterTask);
        
        Map<Id,Task> mapBookingIdToSDRLetterTask = new Map<Id,Task>();
        for(Task taskObj : listOfSDRLetterTask){
            mapBookingIdToSDRLetterTask.put(taskObj.WhatId,taskObj);
        }
        System.debug('mapBookingIdToSDRLetterTask'+mapBookingIdToSDRLetterTask);
        
        String CRMHeadUserName = Label.CRM_Head_User;
        UserRole CRMHeadRoleObj = [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'];
        User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: CRMHeadRoleObj.Id AND isActive =: true Limit 1];
        System.debug('CRMHeadRoleObjUser'+CRMHeadRoleObjUser);
        
        EmailTemplate emailTemplate7 = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'SDR_Letter_Task_is_Pending_Form_Last_7_Days' limit 1];
        EmailTemplate emailTemplate15 = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'SDR_Letter_Task_is_Pending_Form_Last_15_Days' limit 1];
        System.debug('emailTemplate7'+emailTemplate7);
        System.debug('emailTemplate15'+emailTemplate15);
        
        List<String> addresses15 = new List<String>();
        addresses15.add(CRMHeadRoleObjUser.Email);   
        System.debug('addresses15'+addresses15);
        
        Date pastSevenDays = System.Today().addDays(-7);
        Date pastFifteenDays = System.Today().addDays(-15);
        System.debug('pastSevenDays'+pastSevenDays);
        System.debug('pastFifteenDays');
        
        Set<Id> SetOfRMIds = new Set<Id>();
        for(Booking__c bookObj : BookingList){
            SetOfRMIds.add(bookObj.OwnerId);
        }
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User Where Id In : SetOfRMIds]);
        
        for(Booking__c bookObj : BookingList){
            System.debug('In bookObj');
            if(bookObj.SDR_Letter_Sent_Date__c != null){
                System.debug('bookObj.SDR_Letter_Sent_Date__c');
                if(mapBookingIdToSDRLetterTask.size() > 0 && mapBookingIdToSDRLetterTask.containsKey(bookObj.Id)){
                    Task SDRTask = mapBookingIdToSDRLetterTask.get(bookObj.Id);
                    System.debug('SDRTask'+SDRTask);
                    if(SDRTask.Status != 'Completed'){
                        System.debug('In SDRTask.Status');
                        if(bookObj.SDR_Letter_Sent_Date__c == pastSevenDays){
                            
                            String htmlBody = emailTemplate7.HtmlValue;
                            htmlBody = htmlBody.replace('{!RM}', mapIdToUser.get(bookObj.OwnerId).Name);
                            htmlBody = htmlBody.replace('{!Name}', bookObj.Name);
                            if(bookObj.Unit_Number__c != null){
                                 htmlBody = htmlBody.replace('{!Unit}', bookObj.Unit_Number__c);
                            }
                            if(bookObj.Project_Name_Formulla__c != null){
                                htmlBody = htmlBody.replace('{!Project}', bookObj.Project_Name_Formulla__c);
                            }
                            List<String> addresses7 = new List<String>();
                            addresses7.add(bookObj.OwnerId);
                            System.debug('Send Email');
                            SendEmailandBellNotificationUtility.SendEmail(
                                String.valueOf(emailTemplate7.Id),
                                htmlBody,
                                '',
                                addresses7,
                                null
                            );
                        }
                        if(bookObj.SDR_Letter_Sent_Date__c == pastFifteenDays){
                            String htmlBody = emailTemplate15.HtmlValue;
                            htmlBody = htmlBody.replace('{!RM}', CRMHeadRoleObjUser.Name);
                            htmlBody = htmlBody.replace('{!Name}', bookObj.Name);
                             if(bookObj.Unit_Number__c != null){
                                 htmlBody = htmlBody.replace('{!Unit}', bookObj.Unit_Number__c);
                            }
                            if(bookObj.Project_Name_Formulla__c != null){
                                htmlBody = htmlBody.replace('{!Project}', bookObj.Project_Name_Formulla__c);
                            }                   
                            SendEmailandBellNotificationUtility.SendEmail(
                                String.valueOf(emailTemplate15.Id),
                                htmlBody,
                                '',
                                addresses15,
                                null
                            );
                        }
                    }
                }
            }
        }
    } 
    global void finish(Database.BatchableContext bc){
        
    }
}