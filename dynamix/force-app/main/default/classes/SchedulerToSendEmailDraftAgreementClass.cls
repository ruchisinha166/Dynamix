public class SchedulerToSendEmailDraftAgreementClass implements Schedulable{
    
    public Static void execute(SchedulableContext sc){
        
        String CRMHead = system.Label.CRM_Head_User;
        List<Task> listOfAgreementsTasksNotCompletedThreeDays = [Select Id,WhatId,Status,CreatedById,Subject,CreatedDate,ActivityDate,OwnerId From Task Where Subject =: 'Generate Draft Agreement' AND Status != 'Completed' AND CreatedDate = LAST_N_DAYS:3 ];
        List<Task> listOfAgreementsTasksNotCompletedFiveDays = [Select Id,WhatId,Status,Subject,CreatedDate,ActivityDate,OwnerId From Task Where Subject =: 'Generate Draft Agreement' AND Status != 'Completed' AND CreatedDate = LAST_N_DAYS:5 ];
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User Where IsActive =: True]);
        OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName = 'Divum' Limit 1];
        Map<Id,booking__c> mapIdToBooking = new Map<Id,booking__c>([Select Id,Name,OwnerId From booking__c]);
        
        TimeZone tz = UserInfo.getTimeZone();
        DateTime dt = Datetime.now(); 
        System.debug('tz'+tz);
        Integer offset=tz.getOffset(dt)/1000;
        System.debug('offset'+offset);
        Datetime currentDateTime=dt.addSeconds(offset);
        System.debug('currentDateTime'+currentDateTime);
        DateTime currentDateTime1= currentDateTime.addMinutes(-10);
        System.debug('currentDateTime1'+currentDateTime1);
        Id businessHourId = [SELECT Id FROM BusinessHours WHERE IsDefault = true].Id;
        System.debug('businessHourId'+businessHourId);        
        Integer hours = -72;
        
        if(listOfAgreementsTasksNotCompletedThreeDays.size() > 0){
            String CRMHeadUserName = Label.CRM_Head_User;
            UserRole CRMHeadRoleObj = [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'];
            User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserRoleId =: CRMHeadRoleObj.Id AND isActive =: true AND UserName =: CRMHeadUserName Limit 1];
            List<Messaging.SingleEmailMessage> emailMsgList = New List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            List<Messaging.SingleEmailMessage> emailMsgList1 = New List<Messaging.SingleEmailMessage>();
            email.setSubject('Draft Agreement Task is Due From Last 3 Days');
            email.setTargetObjectId(CRMHeadRoleObjUser.Id);  
            List<String> Addresses = new List<String>(); 
            List<String> Addresses1 = new List<String>(); 
            Date pastThreeDate = System.today().addDays(-1);
            String userName = CRMHeadRoleObjUser.Name;
            String htmlBody= '';
            
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Draft_Agreement_Task_EscalationRM' LIMIT 1];
            EmailTemplate emailTemplate1 = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Draft_Agreement_Task_Escalation_CRM' LIMIT 1];
            
            
            htmlBody = '<table border="1" style="border-collapse: collapse" width="100%"><tr><th width="13%"> Subject </th><th width="15%"> Status </th><th width="15%"> Due Date </th><th width="12%"> Owner </th><th width="20%"> Record Link </th></tr>';
            
            Boolean Flag = false;
            for(Task taskObj : listOfAgreementsTasksNotCompletedThreeDays){
                
                Datetime CreatedDate = BusinessHours.add(businessHourId,taskObj.CreatedDate, hours * 60 * 60 * 1000L);    
                System.debug('CreatedDate : '+CreatedDate);
                
                Integer offset1=tz.getOffset(CreatedDate)/1000;
                System.debug('offset1'+offset1);
                
                Datetime CreatedDate1=(CreatedDate).addSeconds(offset1);     
                System.debug('CreatedDate1'+CreatedDate1);
                
                Datetime TodayDate = BusinessHours.add(businessHourId,System.today(), hours * 60 * 60 * 1000L);    
                System.debug('TodayDate : '+TodayDate);
                
                Integer offset2=tz.getOffset(TodayDate)/1000;
                System.debug('offset2'+offset2);
                
                Datetime TodayDate1=(TodayDate).addSeconds(offset2);     
                System.debug('TodayDate1'+TodayDate1);
                
                System.debug('CreatedDate1.addDays(3).day()'+CreatedDate1.addDays(3).day());
                System.debug('CreatedDate1.addDays(3).month()'+CreatedDate1.addDays(3).month());
                System.debug('CreatedDate1.addDays(3).year()'+CreatedDate1.addDays(3).year());
                
                if(CreatedDate1.day() == TodayDate1.day() &&
                   CreatedDate1.month() == TodayDate1.month() &&
                   CreatedDate1.year() == TodayDate1.year() 
                  ){
                      String ownerName = '';
                      String subject = String.valueOf(taskObj.Subject);
                      String status = String.valueOf(taskObj.status);
                      String dueDate = String.valueOf(taskObj.ActivityDate);
                      if(mapIdToUser.size() > 0 && mapIdToUser.containsKey(taskObj.OwnerId)){
                          User taskOwner = mapIdToUser.get(taskObj.OwnerId);
                          ownerName = taskOwner.Name;
                      }
                      String recordLink = URL.getOrgDomainUrl().toExternalForm() + '/' + taskObj.Id;
                      htmlBody +='<tr><td>' + subject +'</td><td>'+ status + '</td><td>'+ dueDate +'</td><td>'+ ownerName + '</td><td>'+'<a href="'+recordLink+'">Click here.</a></td></tr>';
                      Flag = true;
                      
                      if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(taskObj.WhatId)){
                          Booking__c bookObj = mapIdToBooking.get(taskObj.WhatId);
                          if(mapIdToUser.size() > 0 && mapIdToUser.containsKey(bookObj.OwnerId)){
                              Messaging.SingleEmailMessage email1 = Messaging.renderStoredEmailTemplate(String.Valueof(emailTemplate.Id),taskObj.CreatedById,taskObj.Id);
                              String Subject1 = emailTemplate.Subject;
                              String NewSubject = bookObj.Name + ' ' + Subject1;
                              email1.setSubject(NewSubject);
                              Addresses1.add(mapIdToUser.get(bookObj.OwnerId).Email);  
                              email1.setOrgWideEmailAddressId(orgEmail.Id);
                              email1.toaddresses = Addresses;
                              email1.setSaveAsActivity(false);
                              emailMsgList1.add(email1);
                          }
                      }
                  }                      
            }
            
            htmlBody += '</table><br>';
            htmlBody +='</br>'+
                +'</br>'+
                +'Thank you,</br>'+
                +'Dynamix'
                +'</html>';
            
            String body = emailTemplate.HtmlValue;
            body = body.replace('Sir',userName);
            body += htmlBody;
            Addresses.add(CRMHeadRoleObjUser.Email);  
            email.setHtmlBody(body);
            email.setOrgWideEmailAddressId(orgEmail.Id);
            email.toaddresses = Addresses;
            email.setSaveAsActivity(false);
            emailMsgList.add(email);
            
            System.debug('Before Sending ');
            if(emailMsgList1.size() > 0){
                System.debug('In  Sending');
                Messaging.SendEmailResult[] results1 = Messaging.sendEmail(emailMsgList1);
                if(results1[0].success){
                    system.debug('The email was sent successfully! '+emailMsgList1);
                }
                else{
                    System.debug('The email failed to send: ' + results1[0].errors[0].message);
                }
            }   
            if(Flag){
                if(emailMsgList.size() > 0){
                    System.debug('In  Sending');
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMsgList);
                    if(results[0].success){
                        system.debug('The email was sent successfully! '+emailMsgList);
                    }
                    else{
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                    }
                }   
            }
        }
        
        
        
        if(listOfAgreementsTasksNotCompletedFiveDays.size() > 0){
            
            String CRMHeadUserName = Label.CRM_Head_User;
            UserRole CRMHeadRoleObj = [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'];
            User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserRoleId =: CRMHeadRoleObj.Id AND isActive =: true AND UserName =: CRMHeadUserName Limit 1];
            List<Messaging.SingleEmailMessage> emailMsgList = New List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Draft Agreement Task is Due From Last 3 Days');
            email.setTargetObjectId(CRMHeadRoleObjUser.Id); 
            
            List<String> Addresses = new List<String>(); 
            
            String userName = CRMHeadRoleObjUser.Name;
            String htmlBody= '';
                        
            htmlBody = '<table border="1" style="border-collapse: collapse" width="100%"><tr><th width="13%"> Subject </th><th width="15%"> Status </th><th width="15%"> Due Date </th><th width="12%"> Owner </th><th width="20%"> Record Link </th></tr>';
            Date pastFiveDate = System.today().addDays(-5); 
            Boolean Flag = false;
            for(Task taskObj : listOfAgreementsTasksNotCompletedThreeDays){
                hours = -120;
                Datetime CreatedDate = BusinessHours.add(businessHourId,taskObj.CreatedDate, hours * 60 * 60 * 1000L);    
                System.debug('CreatedDate'+CreatedDate);
                
                Datetime TodayDate = BusinessHours.add(businessHourId,System.today(), hours * 60 * 60 * 1000L);    
                System.debug('TodayDate : '+TodayDate);
              
                if(CreatedDate.day() == TodayDate.day() &&
                   CreatedDate.month() == TodayDate.month() &&
                   CreatedDate.year() == TodayDate.year() 
                  ){
                      String ownerName = '';
                      String subject = String.valueOf(taskObj.Subject);
                      String status = String.valueOf(taskObj.status);
                      String dueDate = String.valueOf(taskObj.ActivityDate);
                      if(mapIdToUser.size() > 0 && mapIdToUser.containsKey(taskObj.OwnerId)){
                          User taskOwner = mapIdToUser.get(taskObj.OwnerId);
                          ownerName = taskOwner.Name;
                      }
                      String recordLink = URL.getOrgDomainUrl().toExternalForm() + '/' + taskObj.Id;
                      htmlBody +='<tr><td>' + subject +'</td><td>'+ status + '</td><td>'+ dueDate +'</td><td>'+ ownerName + '</td><td>'+'<a href="'+recordLink+'">Click here.</a></td></tr>';
                      Flag = true;
                  }
            }
            htmlBody += '</table><br>';
            htmlBody +='</br>'+
                +'</br>'+
                +'Thank you,</br>'+
                +'Dynamix'
                +'</html>';
            
            Addresses.add(CRMHeadRoleObjUser.Email);  
            email.setHtmlBody(htmlBody);
            email.setOrgWideEmailAddressId(orgEmail.Id);
            email.toaddresses = Addresses;
            email.setSaveAsActivity(false);
            emailMsgList.add(email);
            
            System.debug('Before Sending ');
            if(Flag){
                if(emailMsgList.size() > 0){
                    System.debug('In  Sending');
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMsgList);
                    if(results[0].success){
                        system.debug('The email was sent successfully! '+emailMsgList);
                    }
                    else{
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                    }
                }    
            }
        }
    }
}