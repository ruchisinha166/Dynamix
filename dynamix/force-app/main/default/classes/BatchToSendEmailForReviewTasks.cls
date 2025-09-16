global class BatchToSendEmailForReviewTasks implements DataBase.Batchable<Sobject>,DataBase.Stateful{   
    
    List<Task> listOftasks=new List<Task>();
    
    global List<Task> start(DataBase.BatchableContext bc){
        List<Task> taskList=new List<Task>();
        System.debug('in Batch ');
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
        Integer hours = 24;
        List<Task> taskData = [Select Id,OwnerId,Owner.Name,Owner.Email,CreatedDate,Activitydate From Task Where Activitydate !=null AND Subject =: 'Review Welcome Call' AND Status != 'Completed'];
        System.debug('taskData'+taskData);
        
        for(Task taskObj:taskData){
            System.debug('In taskData'+taskObj.CreatedDate);
           
            Datetime Activitydate = BusinessHours.add(businessHourId,taskObj.CreatedDate, hours * 60 * 60 * 1000L);    
            System.debug('Activitydate'+Activitydate);
           
            Integer offset1=tz.getOffset(Activitydate)/1000;
            System.debug('offset1'+offset1);
          
            Datetime Activitydate1=(Activitydate).addSeconds(offset1);     
            System.debug('Activitydate1'+Activitydate1);
           
            if(Activitydate1>currentDateTime1 && Activitydate1<=currentDateTime){
                System.debug('in Add Method');
                taskList.add(taskObj);
            }
        }
        System.debug('Return taskList'+taskList);
        return taskList;
    }
    global void execute(Database.BatchableContext bc,List<Task> taskList1){

        for(Task taskObj1:taskList1) {
            listOftasks.add(taskObj1);
        }
    } 
    global void finish(Database.BatchableContext bc){
    
        if(listOftasks.size()>0){
            String CRMHeadUserName = Label.CRM_Head_User;
            UserRole siteHeadRoleObj = [select id,Name,DeveloperName from UserRole where DeveloperName =: 'Site_Head'];
            UserRole CRMHeadRoleObj = [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'];
            String siteHeadUserName = Label.Site_Head_User_Name;
            User siteHeadRoleObjUser = [Select Id,Name,Email From User Where UserRoleId =: siteHeadRoleObj.Id AND UserName =: siteHeadUserName AND isActive =: true Limit 1];
            User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: CRMHeadRoleObj.Id AND isActive =: true Limit 1];
            
            String tableHtmlBody= '';            
            tableHtmlBody +=  '<table border="1" style="border-collapse: collapse"><tr><th>Task Name</th><th>Created Date</th><th>Activity Date</th><th>Task Owner</th></tr>';
            Boolean flag = false;
            for(Task taskObj : listOftasks) {
                
                String dueDate = taskObj.ActivityDate.format();
                String taskName = taskObj.Id;
                String TaskOwner = taskObj.Owner.Name;
                DateTime dt = taskObj.CreatedDate;                
                tableHtmlBody +='<tr><td>' + taskName +'</td><td>'+ dt +'</td><td>'+ dueDate + '</td><td>'+ TaskOwner + '</td></tr>';           
                if(taskObj.CreatedDate == System.today().addDays(-3)){
                    flag = true;
                }
            }
            
            tableHtmlBody += '</table></br>Thank You, </br> Dynamix';
            
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Welcome_Call_Task_Pending' LIMIT 1];
            EmailTemplate emailTemplate1 = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Review_Welcome_Call_Not_Completed' LIMIT 1];
            
            List<String> emailList = new List<String>();           
            emailList.add(siteHeadRoleObjUser.Email); 
            if(flag){
                flag = false;
                emailList.add(CRMHeadRoleObjUser.Email); 
                String htmlBody = emailTemplate1.HtmlValue;
                String plainBody = emailTemplate1.Body+tableHtmlBody;
                htmlBody += tableHtmlBody;
                htmlBody = htmlBody.replace('{!Site}', siteHeadRoleObjUser.Name);

                SendEmailandBellNotificationUtility.SendEmail(emailTemplate1.Id,htmlBody,plainBody,emailList,null);
            }
            else{
                List<String> emailList1 = new List<String>();           
                emailList1.add(siteHeadRoleObjUser.Email); 
                String htmlBody = emailTemplate.HtmlValue;
                String plainBody = emailTemplate.Body+tableHtmlBody;
                htmlBody += tableHtmlBody;
                htmlBody = htmlBody.replace('{!Site}', siteHeadRoleObjUser.Name);

                SendEmailandBellNotificationUtility.SendEmail(emailTemplate.Id,htmlBody,plainBody,emailList1,null);
            }
        }
    }
}