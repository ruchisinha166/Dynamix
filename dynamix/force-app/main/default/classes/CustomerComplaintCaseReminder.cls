//This Batch Class Will Execute for All the Cases records for which Case type is Customer Complaint & Case Status is still not Resolved after 3 days 
//This Batch class will send Email to users with Support Executive role & profile & CRM Head user : Batch Size Default(200)
//Email send functionality to CRM Head & Support Executive is called From Finish Method 
global class CustomerComplaintCaseReminder implements DataBase.Batchable<Sobject>,DataBase.Stateful{
    List<Case> caseListForReminderEmail = new List<Case>();
    global List<Case> start(DataBase.BatchableContext bc){ 
        List<Case> caseList = new List<Case>();      
        caseList=[Select Id,CaseNumber,Status,Type,CreatedDate,Owner.Name,Booking__c,Booking__r.Name,Complaint_category__c From Case Where Status!='Resolved' AND Type=:'Customer Complaint'];
        System.debug('caseList:'+ caseList);
        return caseList;
    }
    global void execute(Database.BatchableContext bc,List<Case> caseList1){
        Date dateBefore3Days=(system.today()-3);
        //Date dateBefore3Days=(system.today()); //for only testing purpose
        System.debug('dateBefore3Days:'+dateBefore3Days);
        For(Case caseRcd:caseList1){
            Date caseCreatedDate=caseRcd.CreatedDate.date();
            System.debug('caseCreatedDate:'+caseCreatedDate);
            if(dateBefore3Days==caseCreatedDate){
                caseListForReminderEmail.add(caseRcd);
            }
        }
    } 
    global void finish(Database.BatchableContext bc){        
        if(caseListForReminderEmail.size()>0){   
            //CRM Head User
            String crmHeadUserName = Label.CRM_Head_User;
            System.debug('crmHeadUserName:'+crmHeadUserName);
            
            Set<String> suppExecutiveMailList=new Set<String>();
            User crmHeadUser;
            
            //for get users with Support Executive Role & Profile & CRM Head user
            List<User> userList=[Select Id,Name,UserName,UserRole.DeveloperName,Email,Profile.Name,IsActive From User Where IsActive=true AND (UserName=:crmHeadUserName  OR (UserRole.DeveloperName=:'Support_Executive' AND Profile.Name=:'Support Executive'))];
            
            if(userList.size()>0){
                for(User userRcd:userList){
                    if(userRcd.Email!=null && userRcd.UserRole.DeveloperName=='Support_Executive' && userRcd.Profile.Name=='Support Executive'){
                        suppExecutiveMailList.add(userRcd.Email);
                    }                   
                    if(userRcd.UserName==crmHeadUserName){
                        crmHeadUser=userRcd;
                    }
                }
            }
            System.debug('suppExecutiveMailList:'+suppExecutiveMailList);
            System.debug('crmHeadUser:'+crmHeadUser);
            
            String tableHtmlBody= '';            
            tableHtmlBody +=  '<table border="1" style="border-collapse: collapse"><tr><th>Case Number</th><th>Created Date</th><th>Status</th><th>Complaint Category</th><th>Booking</th><th>Case Owner</th></tr>';
            
            for(Case caseRcd:caseListForReminderEmail)
            {      
                String caseNumber =caseRcd.CaseNumber;
                String caseOwner =caseRcd.Owner.Name;
                String caseStatus =caseRcd.Status;
                String complaintCategory='';
                if(caseRcd.Complaint_category__c!=null){
                    complaintCategory=caseRcd.Complaint_category__c;
                }
                String bookingName='';
                String bookingLink='';
                if(caseRcd.Booking__c!=null){
                    bookingLink=URL.getOrgDomainUrl().toExternalForm() + '/' + caseRcd.Booking__c;
                    bookingName=caseRcd.Booking__r.Name;
                }
                String createdDt=caseRcd.CreatedDate.format('dd/MM/yyyy');  
                String recordLink=URL.getOrgDomainUrl().toExternalForm() + '/' + caseRcd.Id;
                tableHtmlBody +='<tr><td><a href="'+recordLink+'">' + caseNumber +'</a></td><td>'+ createdDt +'</td><td>'+ caseStatus + '</td><td>'+ complaintCategory + '</td><td><a href="'+bookingLink+'">' + bookingName +'</a></td><td>'+ caseOwner + '</td></tr>';                      
            }
            tableHtmlBody += '</table></br>Thank You, </br> Dynamix';
            System.debug('tableHtmlBody:'+tableHtmlBody);
            
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Reminder_For_Customer_Complaint_Case' LIMIT 1];
            System.debug('emailTemplate:'+emailTemplate);
            String htmlBody = emailTemplate.HtmlValue+tableHtmlBody;
            String plainBody = emailTemplate.Body+tableHtmlBody;
            if(emailTemplate!=null){           
                List<String> toEmailList=new List<String>();   
                //add support executive users email
                toEmailList.addAll(suppExecutiveMailList); 
                //add CRM Head email
                if(crmHeadUser!=null){
                    toEmailList.add(crmHeadUser.Email); 
                } 
                SendEmailandBellNotificationUtility.SendEmail2(emailTemplate.Id,htmlBody,plainBody,toEmailList,null,false,null,null,null,null);
            }       
        }
    }
}