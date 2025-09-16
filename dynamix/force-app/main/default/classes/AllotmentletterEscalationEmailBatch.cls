//This Batch Class Will Execute for All the Booking records for which Allotment Letter is not sent to customer till 48 hours of allotment letter generated 
//This Batch class will send Email to CRM Head : Batch Size Default(200)
//Email send functionality to CRM Head is called From Finish Method 
global class AllotmentletterEscalationEmailBatch implements DataBase.Batchable<Sobject>,DataBase.Stateful{   
    List<Booking__c> listOfBooking=new List<Booking__c>();
    global List<Booking__c> start(DataBase.BatchableContext bc){
        List<Booking__c> bookingList=new List<Booking__c>();
        TimeZone tz = UserInfo.getTimeZone();
        DateTime dt = Datetime.now();
        
        Integer offset=tz.getOffset(dt)/1000;
        Datetime currentDateTime=dt.addSeconds(offset);
        System.debug('currentDateTime:'+currentDateTime);
        
        DateTime currentDateTime1= currentDateTime.addMinutes(-10);
        System.debug('currentDateTime1:'+currentDateTime1);
         
        //get Business Hour Id
        Id businessHourId = [SELECT Id FROM BusinessHours WHERE IsDefault = true].Id;
        Integer hours = 48;
        
        //get booking data for which allotment letter is generated but still not sent to customer
        List<Booking__c> bookingData=[Select Id,Name,CreatedDate,Allotment_Letter_Generation_Date__c,OwnerId,Owner.Name,Owner.Email,Allotment_Letter_Sent__c,Project_Name__r.Name,Project_Name__c From Booking__c Where Allotment_Letter_Generation_Date__c!=null AND Allotment_Letter_Sent__c=false];
        System.debug('bookingData:'+bookingData);
        for(Booking__c bookingRcd:bookingData){
            // add 48 hour for get date & Time according to business hours
            Datetime allotLettGenDateTime = BusinessHours.add(businessHourId,bookingRcd.Allotment_Letter_Generation_Date__c, hours * 60 * 60 * 1000L);
            System.debug('allotLettGenDateTime:'+allotLettGenDateTime);
            
            Integer offset1=tz.getOffset(allotLettGenDateTime)/1000;
            Datetime allotLettGenDateTime1=(allotLettGenDateTime).addSeconds(offset1);
            System.debug('allotLettGenDateTime1:'+allotLettGenDateTime1);
            
            if(allotLettGenDateTime1>currentDateTime1 && allotLettGenDateTime1<=currentDateTime){
                bookingList.add(bookingRcd);
            }
        }
        System.debug('bookingList:'+bookingList);
        return bookingList;
    }
    global void execute(Database.BatchableContext bc,List<Booking__c> bookingList1){
        System.debug('Execute method bookingList1:'+bookingList1);
        for(Booking__c bookingRcd1:bookingList1)
        {
            listOfBooking.add(bookingRcd1);
        }
        System.debug('listOfBooking-execute:'+listOfBooking);        
    } 
    global void finish(Database.BatchableContext bc){
        System.debug('listOfBooking-finish:'+listOfBooking); 
        //For send Email to CRM Head User
        if(listOfBooking.size()>0){
            String crmHeadUserName = Label.CRM_Head_User;
            System.debug('crmHeadUserName:'+crmHeadUserName);
            User crmHeadUser=[Select Id,Name,Email,UserName From User Where UserName=:crmHeadUserName Limit 1];
            System.debug('crmHeadUser:'+crmHeadUser);
            
            String tableHtmlBody= '';   
            String targetRcdId='';
            tableHtmlBody +=  '<table border="1" style="border-collapse: collapse"><tr><th>Booking Name</th><th>Created Date</th><th>Allotment Letter Generated Date</th><th>Booking Owner</th><th>Project</th></tr>';
            
            for(Booking__c bookingRcd:listOfBooking)
            {
                String dueDate = bookingRcd.Allotment_Letter_Generation_Date__c.format();
                String bookingName =bookingRcd.Name;
                String projectName='';
                String projectLink='';
                if(bookingRcd.Project_Name__c!=null){
                    projectLink=URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Project_Name__c;
                    projectName=bookingRcd.Project_Name__r.Name;
                }
                String bookingOwner =bookingRcd.Owner.Name;
                String dt=bookingRcd.CreatedDate.format('dd/MM/yyyy');      
                targetRcdId=bookingRcd.Id;
                String recordLink=URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Id;
                tableHtmlBody +='<tr><td>'+'<a href="'+recordLink+'">' + bookingName +'</a></td><td>'+ dt +'</td><td>'+ dueDate + '</td><td>'+ bookingOwner + '</td><td>'+'<a href="'+projectLink+'">' + projectName +'</a></td></tr>';           
            }
            tableHtmlBody += '</table></br>Thank You, </br> Dynamix';
            System.debug('tableHtmlBody:'+tableHtmlBody);
            
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Allotment_Letter_Escalation_Email' LIMIT 1];
            System.debug('emailTemplate:'+emailTemplate);
            String htmlBody = emailTemplate.HtmlValue+tableHtmlBody;
            htmlBody = htmlBody.replace('{!CRMHeadName}', crmHeadUser.Name);
            htmlBody = htmlBody.replace('{!days}',String.valueOf(3));
            String plainBody = emailTemplate.Body+tableHtmlBody;
            plainBody = plainBody.replace('{!CRMHeadName}', crmHeadUser.Name);
            plainBody = plainBody.replace('{!days}',String.valueOf(3));
            if(emailTemplate!=null){           
                List<String> emailList=new List<String>();           
                emailList.add(crmHeadUser.Email); 
                // SendEmailandBellNotificationUtility.SendEmail(emailTemplate.Id,htmlBody,plainBody,emailList,null);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(emailList);
                mail.setSubject(emailTemplate.Subject);
                mail.setHtmlBody(htmlBody);
                mail.setPlainTextBody(plainBody);
                mail.setSaveAsActivity(true);
                if(targetRcdId!=''){
                    mail.setWhatId(targetRcdId);
                }
                try{
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    System.debug('Mail Sent:'+mail);
                }
                catch (Exception e) {
                    System.debug('Problem sending Email: '+ e.getMessage());
                }
            }        
        }
    }
}