global class BatchToSendNotificationToCRMHeadClass implements DataBase.Batchable<Sobject>{
    
    global Database.QueryLocator start(DataBase.BatchableContext bc){
        Date pastThreeDays = System.Today().addDays(-3);
        /*List<Booking__c> a = [Select Id,Name,Project_Name_Formulla__c,Unit_Number__c,OwnerId,SDR_Letter_Sent_Date__c From Booking__c Where SDR_Letter_Sent_Date__c =: pastThreeDays];
System.debug('a'+a);
return Database.getQueryLocator('Select Id,Name,OwnerId,Project_Name_Formulla__c,Unit_Number__c,SDR_Letter_Sent_Date__c From Booking__c Where SDR_Letter_Sent_Date__c =: pastThreeDays');
*/
        //New Logic as decided in meeting
        List<Booking__c> a = [Select Id,Name,Project_Name_Formulla__c,Unit_Number__c,OwnerId,SDR_Inititated_Date__c,Shared_SDR_Letter__c From Booking__c Where SDR_Inititated_Date__c =: pastThreeDays AND Shared_SDR_Letter__c=false];
        System.debug('a'+a);
        return Database.getQueryLocator('Select Id,Name,OwnerId,Project_Name_Formulla__c,Unit_Number__c,SDR_Inititated_Date__c From Booking__c Where SDR_Inititated_Date__c =: pastThreeDays AND Shared_SDR_Letter__c=false');
    }
    global void execute(Database.BatchableContext bc,List<Booking__c> BookingList){
        System.debug('In EXecute');
        CustomNotificationType notifyObj = [Select Id,CustomNotifTypeName from CustomNotificationType Where DeveloperName =: 'Notification_To_RM' limit 1];
        UserRole CRMHeadRoleObj = [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'];
        String CRMHeadUserName = Label.CRM_Head_User;
        User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: CRMHeadRoleObj.Id AND isActive =: true Limit 1];
        System.debug('CRMHeadRoleObjUser'+CRMHeadRoleObjUser);
        
        Set<Id> setOfBookingIds = new Set<Id>(); 
        for(Booking__c bookObj : BookingList){
            setOfBookingIds.add(bookObj.Id);
        }
        List<Task> listOfSDRLetterTask = new List<Task>([Select Id,Status,Subject,WhatId From Task Where Subject =: 'SDR Letter for the Booking' AND whatId In : setOfBookingIds]);
        System.debug('listOfSDRLetterTask'+listOfSDRLetterTask);
        Map<Id,Task> mapBookingIdToSDRLetterTask = new Map<Id,Task>();
        for(Task taskObj : listOfSDRLetterTask){
            mapBookingIdToSDRLetterTask.put(taskObj.WhatId,taskObj);
        }
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'SDR_Letter_Pending' limit 1];
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User]);
        List<String> addresses = new List<String>();
        addresses.add(CRMHeadRoleObjUser.Email);
        System.debug('Before bookObj');
        for(Booking__c bookObj : BookingList){
            System.debug('In bookObj'+bookObj);
            if(bookObj.SDR_Inititated_Date__c != null){
                System.debug('bookObj.SDR_Inititated_Date__c'+bookObj.SDR_Inititated_Date__c);
                if(mapBookingIdToSDRLetterTask.size() > 0 && mapBookingIdToSDRLetterTask.containsKey(bookObj.Id)){
                    Task SDRTask = mapBookingIdToSDRLetterTask.get(bookObj.Id);
                    System.debug('SDRTask'+SDRTask);
                    if(SDRTask.Status != 'Sent'){
                        Set<String> recipientIds = new Set<String>();
                        recipientIds.add(CRMHeadRoleObjUser.Id);
                        System.debug('SDRTask.Status'+SDRTask.Status);
                        String body = 'Dear '+ CRMHeadRoleObjUser.Name + ',\n'+
                            'SDR letter for the Booking '+ bookObj.Name + ' for ' + bookObj.Unit_Number__c +
                            ' in ' + bookObj.Project_Name_Formulla__c + ' has been not shared to the customer for payment.';
                        
                        SendEmailandBellNotificationUtility.SendBellNotification(
                            notifyObj.Id,
                            'SDR Letter Task is Pending From Last 3 Days.',
                            body,
                            bookObj.Id,
                            recipientIds
                        );
                        
                        String htmlBody = emailTemplate.HtmlValue;
                        htmlBody = htmlBody.replace('{!RM}', mapIdToUser.get(bookObj.OwnerId).Name);
                        htmlBody = htmlBody.replace('{!Unit}', bookObj.Unit_Number__c);
                        htmlBody = htmlBody.replace('{!Project}', bookObj.Project_Name_Formulla__c);
                        
                        SendEmailandBellNotificationUtility.SendEmail(
                            String.valueOf(emailTemplate.Id),
                            htmlBody,
                            '',
                            addresses,
                            null
                        );
                    }
                }
            }
        }
    } 
    global void finish(Database.BatchableContext bc){
        
    }
}