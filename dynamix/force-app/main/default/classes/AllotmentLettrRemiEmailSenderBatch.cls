//This Batch Class Is Used For Send Email & Bell Notification to Booking Owner With Batch Size-10 (This Class is called from Finish method of EmailReminderForSendAllotmentLetter)
global class AllotmentLettrRemiEmailSenderBatch implements Database.Batchable<Sobject>,Database.Stateful{
    Map<String,List<Booking__c>> listOfBooking=new Map<String,List<Booking__c>>();
    public AllotmentLettrRemiEmailSenderBatch(Map<String,List<Booking__c>> listOfBooking){
        this.listOfBooking = listOfBooking;
        System.debug('listOfBooking-Constructor:'+listOfBooking);
    }
    global List<User> start(DataBase.BatchableContext bc){ 
        return [Select Id,UserName,Email,Name from User where Email in :listOfBooking.keySet()];
    }
    global void execute(Database.BatchableContext bc,List<User>userList){
        System.debug('userList-execute:'+userList);
        List<Messaging.SingleEmailMessage> emailListForSend = new List<Messaging.SingleEmailMessage>();
        for(User userRcd:userList){
            String userName=userRcd.Name;
            String tableHtmlBody= '';  
            String targetRcdId='';
            tableHtmlBody +=  '<table border="1" style="border-collapse: collapse"><tr><th>Booking Name</th><th>Created Date</th><th>Allotment Letter Generated Date</th><th>Project</th></tr>';
            
            for(Booking__c bookingRcd:listOfBooking.get(userRcd.Email))
            {
                String dueDate = bookingRcd.Allotment_Letter_Generation_Date__c.format();
                String bookingName =bookingRcd.Name;
                String projectName='';
                String projectLink='';
                if(bookingRcd.Project_Name__c!=null){
                    projectLink=URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Project_Name__c;
                    projectName=bookingRcd.Project_Name__r.Name;
                }
                String dt=bookingRcd.CreatedDate.format('dd/MM/yyyy');   
                targetRcdId=bookingRcd.Id;
                String recordLink=URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Id;
                tableHtmlBody +='<tr><td>'+'<a href="'+recordLink+'">' + bookingName +'</a></td><td>'+ dt +'</td><td>'+ dueDate + '</td><td>'+'<a href="'+projectLink+'">' + projectName +'</a></td></tr>';                            
            }
            tableHtmlBody += '</table></br>Thank You, </br> Dynamix';
            System.debug('tableHtmlBody:'+tableHtmlBody);
            
            //for send Email to Booking Owner
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Reminder_for_Send_Allotment_Letter' LIMIT 1];
            System.debug('emailTemplate:'+emailTemplate);
            String htmlBody = emailTemplate.HtmlValue + tableHtmlBody;
            htmlBody = htmlBody.replace('{!Booking__c.Owner.Name}', userName);
            String plainBody = emailTemplate.Body + tableHtmlBody;
            plainBody = plainBody.replace('{!Booking__c.Owner.Name}', userName);
            if(emailTemplate!=null){      
                List<String> emailList=new List<String>();           
                emailList.add(userRcd.Email); 
                //SendEmailandBellNotificationUtility.SendEmail(emailTemplate.Id,htmlBody,plainBody,emailList,null);                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(emailList);
                mail.setSubject(emailTemplate.Subject);
                mail.setHtmlBody(htmlBody);
                mail.setPlainTextBody(plainBody);
                mail.setSaveAsActivity(true);
                if(targetRcdId!=''){
                    mail.setWhatId(targetRcdId);
                }
                emailListForSend.add(mail);    
            }           
        }        
        System.debug('emailListForSend:'+emailListForSend);
        if(emailListForSend.size()>0){
            Messaging.sendEmail(emailListForSend);
        }
    }
    global void finish(Database.BatchableContext bc){
    }
}