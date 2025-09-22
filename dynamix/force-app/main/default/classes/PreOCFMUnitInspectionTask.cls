public class PreOCFMUnitInspectionTask implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select Id, Subject, ActivityDate,WhatId From Task  Where Status!=\'Completed\' AND Subject = \'Pre-OC FM Review Task\'';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC,List<task> scope){
        Set<Id> OneDayPropId = new Set<Id>();
        Set<Id> ThreeDaysPropId = new Set<Id>();
        Set<Id> SevenDaysPropId = new Set<Id>();
        Date OneDay = Date.Today().addDays(-1);
        Date ThreeDays = Date.Today().addDays(-3);
        Date SevenDays = Date.Today().addDays(-7);

        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemplate = [Select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Task_Reminder'];
        String Subject = emailTemplate.Subject;
        String htmlbody = emailTemplate.HtmlValue;
        String plainBody = emailTemplate.Body;


        UserRole SMUserRole = [Select ID,Name From UserRole where Name='S&M Head'];
        List<String> SMEmail = New List<String> ();
        Set<String> SMIds = New Set<String> ();
        List<User> SMUser = [Select Id,Name,Email From User Where UserRoleId=:SMuserRole.Id AND IsActive=True];
        for(User usr:SMUser){
            SMEmail.add(usr.Email);
            SMIds.add(usr.Id);
        }

        UserRole PromUserRole = [Select ID,Name From UserRole where Name='Promoter'];
        List<String> PromEmail= New List<String> ();
         Set<String> promotorIds = New Set<String> ();
        List<User> PromUser = [Select Id,Name,Email From User Where UserRoleId=:PromuserRole.Id AND IsActive=True];
        for(User usr:PromUser){
            PromEmail.add(usr.Email);
            promotorIds.add(usr.id);
        }

        for(Task tsk:scope){
            
            if(tsk.ActivityDate==OneDay){
                OneDayPropId.add(tsk.WhatId);
            }
            if(tsk.ActivityDate==ThreeDays){
                ThreeDaysPropId.add(tsk.WhatId);
            }
            if(tsk.ActivityDate==SevenDays){
                SevenDaysPropId.add(tsk.WhatId);
            }
            
        }
        //List<Booking__c> BookList = [Select Id,Name,Owner.Email, Primary_Applicant__r.PersonEmail From Booking__c Where Related_Suggested_Property__r.Unit__c IN : PropId];
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Booking_Form_Notification']; 
            Set<String> recipientIds = New Set<String> ();
        if(!OneDayPropId.isEmpty()){
         
            List<Property__c> oneDayProp = [Select Id, Name,FM_User__r.Name,FM_User__r.Email,Project__r.FM_Head__c,
                                            Project__r.FM_Head__r.Name,Project__r.FM_Head__r.Email,
                                            Project__r.Project_Head__r.Email,Project__r.Project_Head__c,
                                            Project__r.Project_Head__r.Name
                                            From Property__c Where Id IN :OneDayPropId];
            for(Property__c prop:oneDayProp){
                String ToEmail = prop.Project__r.Project_Head__r.Email;
                recipientIds = New Set<String> ();
                recipientIds.add(prop.Project__r.Project_Head__c);
                htmlbody = htmlbody.replace('{!Name}',prop.Project__r.Project_Head__r.Name);
                plainBody = plainBody.replace('{!Name}',prop.Project__r.Project_Head__r.Name);
                htmlbody = htmlbody.replace('{!TaskName}','Pre-OC FM Review Task');
                plainBody = plainBody.replace('{!TaskName}','Pre-OC FM Review Task');
                htmlbody = htmlbody.replace('{!ObjectName}',prop.Name);
                plainBody = plainBody.replace('{!ObjectName}',prop.Name);
                htmlbody = htmlbody.replace('{!DayCount}','1');
                plainBody = plainBody.replace('{!DayCount}','1');
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[]{ToEmail});
                email.setSubject(Subject);
                email.setPlainTextBody(plainBody);
                email.setTemplateId(emailTemplate.Id);
                emailList.add(email);
                String notificationBody ='Hi '+ prop.Project__r.Project_Head__r.Name+',\n Pre - OC FM Unit Inspection Task is assigned to '+prop.FM_User__r.Name+' for '+prop.Name +' is overdue since 1. \nPlease take the necessary action to complete the task.';
                SendEmailandBellNotificationUtility.SendBellNotification(notificationType.id,Subject,notificationBody,prop.id,recipientIds);
            }
            Messaging.sendEmail(emailList);
        }

        else if(!ThreeDaysPropId.isEmpty()){
            List<Property__c> ThreeDaysProp = [Select Id, Name,FM_User__r.Name,FM_User__r.Email From Property__c Where Id IN :ThreeDaysPropId];
            for(Property__c prop:ThreeDaysProp){
                htmlbody = htmlbody.replace('{!Name}','');
                plainBody = plainBody.replace('{!Name}','');
                htmlbody = htmlbody.replace('{!TaskName}','Pre-OC FM Review Task');
                plainBody = plainBody.replace('{!TaskName}','Pre-OC FM Review Task');
                htmlbody = htmlbody.replace('{!ObjectName}',prop.Name);
                plainBody = plainBody.replace('{!ObjectName}',prop.Name);
                htmlbody = htmlbody.replace('{!DayCount}','3');
                plainBody = plainBody.replace('{!DayCount}','3');
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(SMEmail);
                email.setSubject(Subject);
                email.setPlainTextBody(plainBody);
                email.setTemplateId(emailTemplate.Id);
                emailList.add(email);
                String notificationBody ='Hi,\n Pre-OC FM Review Task is assigned to '+prop.FM_User__r.Name+' for '+prop.Name +' is overdue since 3. \nPlease take the necessary action to complete the task.';
                SendEmailandBellNotificationUtility.SendBellNotification(notificationType.id,Subject,notificationBody,prop.id,SMIds);
                
            }
            Messaging.sendEmail(emailList);
        }

        else if(!SevenDaysPropId.isEmpty() && !PromEmail.isEmpty()){
            List<Property__c> SevenDaysProp = [Select Id, Name,FM_User__r.Name,FM_User__r.Email From Property__c Where Id IN :SevenDaysPropId];
            for(Property__c prop:SevenDaysProp){
                htmlbody = htmlbody.replace('{!Name}','');
                plainBody = plainBody.replace('{!Name}','');
                htmlbody = htmlbody.replace('{!TaskName}','Pre-OC FM Review Task');
                plainBody = plainBody.replace('{!TaskName}','Pre-OC FM Review Task');
                htmlbody = htmlbody.replace('{!ObjectName}',prop.Name);
                plainBody = plainBody.replace('{!ObjectName}',prop.Name);
                htmlbody = htmlbody.replace('{!DayCount}','7');
                plainBody = plainBody.replace('{!DayCount}','7');
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(PromEmail);
                email.setSubject(Subject);
                email.setPlainTextBody(plainBody);
                email.setTemplateId(emailTemplate.Id);
                emailList.add(email);
                String notificationBody ='Hi,\n Pre-OC FM Review Task is assigned to '+prop.FM_User__r.Name+' for '+prop.Name +' is overdue since 7. \nPlease take the necessary action to complete the task.';
                SendEmailandBellNotificationUtility.SendBellNotification(notificationType.id,Subject,notificationBody,prop.id,promotorIds);
      
            }
            Messaging.sendEmail(emailList);
        }
    }

    public void finish(Database.BatchableContext BC){

           
    }
}