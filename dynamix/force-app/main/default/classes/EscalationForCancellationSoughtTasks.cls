//This Batch Class Will Execute for All the Tasks records of Cancellation Sought taks for which task due date is before 8 days & task Status is still not Closed 
//This Batch class will send Email to users with Site Head role & CRM Head user : Batch Size Default(200)
//Email send functionality to CRM Head & Site Head is called From Finish Method 
global class EscalationForCancellationSoughtTasks implements DataBase.Batchable<Sobject>,DataBase.Stateful{
    List<Task> taskListForEscalationEmail = new List<Task>();
    Map<Id,Booking__c> bookingMapList=new Map<Id,Booking__c>();
    
    global List<Task> start(DataBase.BatchableContext bc){    
        List<Task> taskList=[Select Id,ActivityDate,CreatedDate,whatId,IsClosed,Subject,Description,Owner.Name From Task Where ActivityDate!=null AND whatId!=null AND IsClosed=false AND Subject like '%Cancellation Sought%'];
        System.debug('taskList:'+ taskList);
        Set<String> taskWhatIdsSet=new Set<String>();
        for(Task taskRcd:taskList){
            if(taskRcd.whatId!=null){
                taskWhatIdsSet.add(taskRcd.whatId);
            }
        }
        bookingMapList=new Map<Id,Booking__c>([Select Id,Name From Booking__c Where Id=:taskWhatIdsSet]);
        System.debug('bookingMapList:'+ bookingMapList);
        return taskList;
    }
    global void execute(Database.BatchableContext bc,List<Task> taskList1){
        Date dateBefore8Days=(system.today()-8);
        //Date dateBefore8Days=(system.today()); //for only testing purpose
        System.debug('dateBefore8Days:'+dateBefore8Days);
        For(Task taskRcd1:taskList1){         
            Date taskCreatedDate=taskRcd1.CreatedDate.date();
            System.debug('taskCreatedDate:'+taskCreatedDate);
            if(dateBefore8Days==taskCreatedDate){
                taskListForEscalationEmail.add(taskRcd1);
            }
        }
    } 
    global void finish(Database.BatchableContext bc){        
        if(taskListForEscalationEmail.size()>0){   
            //CRM Head User
            String crmHeadUserName = Label.CRM_Head_User;
            System.debug('crmHeadUserName:'+crmHeadUserName);
            
            Set<String> siteHeadMailList=new Set<String>();
            User crmHeadUser;
            
            //for get users with Support Executive Role & Profile & CRM Head user
            List<User> userList=[Select Id,Name,UserName,UserRole.DeveloperName,Email,IsActive From User Where IsActive=true AND (UserName=:crmHeadUserName  OR (UserRole.DeveloperName=:'Site_Head'))];
            
            if(userList.size()>0){
                for(User userRcd:userList){
                    if(userRcd.Email!=null && userRcd.UserRole.DeveloperName=='Site_Head'){
                        siteHeadMailList.add(userRcd.Email);
                    }                   
                    if(userRcd.UserName==crmHeadUserName){
                        crmHeadUser=userRcd;
                    }
                }
            }
            System.debug('siteHeadMailList:'+siteHeadMailList);
            System.debug('crmHeadUser:'+crmHeadUser);
            
            String tableHtmlBody= '';            
            tableHtmlBody +=  '<table border="1" style="border-collapse: collapse"><tr><th>Booking</th><th>Task Subject</th><th>Task Due Date</th><th>Task Owner</th><th>Task Link</th></tr>';
            
            for(Task taskRcd2:taskListForEscalationEmail)
            {      
                String bookingName =bookingMapList.get(taskRcd2.WhatId).Name;
                String taskSubject =taskRcd2.Subject;
                String taskOwner =taskRcd2.Owner.Name;
                String taskDueDate=Date.valueOf(taskRcd2.ActivityDate).format();  
                String taskLink=URL.getOrgDomainUrl().toExternalForm() + '/' + taskRcd2.Id;
                String bookingLink=URL.getOrgDomainUrl().toExternalForm() + '/' + bookingMapList.get(taskRcd2.WhatId).Id;
                tableHtmlBody +='<tr><td><a href="'+bookingLink+'">' + bookingName +'</a></td><td>'+ taskSubject +'</td><td>'+ taskDueDate + '</td><td>'+ taskOwner + '</td><td><a href="'+taskLink+'">' + 'Open Task' +'</a></td></tr>';                      
            }
            tableHtmlBody += '</table></br>Thank You, </br> Dynamix';
            System.debug('tableHtmlBody:'+tableHtmlBody);
            
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Escalation_For_Cancellation_Sought_Tasks' LIMIT 1];
            System.debug('emailTemplate:'+emailTemplate);
            String htmlBody = emailTemplate.HtmlValue+tableHtmlBody;
            String plainBody = emailTemplate.Body+tableHtmlBody;
            if(emailTemplate!=null){           
                List<String> toEmailList=new List<String>();   
                //add site Head users email
                toEmailList.addAll(siteHeadMailList); 
                //add CRM Head email
                if(crmHeadUser!=null){
                    toEmailList.add(crmHeadUser.Email); 
                } 
                SendEmailandBellNotificationUtility.SendEmail2(emailTemplate.Id,htmlBody,plainBody,toEmailList,null,false,null,null,null,null);
            }       
        }
    }
}