//This Batch Class Will Execute for All the Cases records for which Case type is Customer Complaint & Case Status is still not Resolved after 15 days 
//This Batch class will send Email to users with Director role & cc to users with Support executive profile & role : Batch Size Default(200)
//Email send functionality to Director & Support Executive is called From Finish Method 
global class CustomerComplaintCase2ndEscalation implements DataBase.Batchable<Sobject>,DataBase.Stateful{
    List<Case> caseListForEscalationEmail = new List<Case>();
    global List<Case> start(DataBase.BatchableContext bc){ 
        List<Case> caseList = new List<Case>();      
        caseList=[Select Id,CaseNumber,Status,Type,CreatedDate,Owner.Name,Booking__c,Booking__r.Name,Project__c,Project__r.Name,Complaint_category__c From Case Where Status!='Resolved' AND Type=:'Customer Complaint'];
        System.debug('caseList:'+ caseList);
        return caseList;
    }
    global void execute(Database.BatchableContext bc,List<Case> caseList1){
        Date dateBefore15Days=(system.today()-15);
        //Date dateBefore15Days=(system.today()); //for only testing purpose
        System.debug('dateBefore15Days:'+dateBefore15Days);
        For(Case caseRcd:caseList1){
            Date caseCreatedDate=caseRcd.CreatedDate.date();
            System.debug('caseCreatedDate:'+caseCreatedDate);
            if(dateBefore15Days==caseCreatedDate){
                caseListForEscalationEmail.add(caseRcd);
            }
        }
        System.debug('caseListForEscalationEmail Execute:'+caseListForEscalationEmail);
    } 
    global void finish(Database.BatchableContext bc){        
        if(caseListForEscalationEmail.size()>0){    
            List<Case> caseListForUpdate=new List<Case>();

            List<String> ccEmailList=new List<String>(); 
            Set<String> suppExecutiveMailList=new Set<String>();
            Set<String> directorMailList=new Set<String>();
            //CRM Head User
            String crmHeadUserName = Label.CRM_Head_User;
            System.debug('crmHeadUserName:'+crmHeadUserName);
            
            //for get users with Support Executive Role & Profile, Director role user
            List<User> userList=[Select Id,Name,UserName,UserRole.DeveloperName,Email,Profile.Name,IsActive From User Where IsActive=true AND (UserName=:crmHeadUserName OR UserRole.DeveloperName=:'Director' OR (UserRole.DeveloperName=:'Support_Executive' AND Profile.Name=:'Support Executive'))];
            
            User crmHeadUser;
            if(userList.size()>0){
                for(User userRcd:userList){
                    if(userRcd.Email!=null && userRcd.UserRole.DeveloperName=='Support_Executive' && userRcd.Profile.Name=='Support Executive'){
                        suppExecutiveMailList.add(userRcd.Email);
                    }
                    if(userRcd.Email!=null && userRcd.UserRole.DeveloperName=='Director'){
                        directorMailList.add(userRcd.Email);
                    }  
                    if(userRcd.UserName==crmHeadUserName){
                        crmHeadUser=userRcd;
                    }
                }
            }                                                                                                                                                                            //for get users with Support Executive Role & Profile
            System.debug('suppExecutiveMailList:'+suppExecutiveMailList);
            System.debug('directorMailList:'+directorMailList);
            if(suppExecutiveMailList!=null){
                ccEmailList.addAll(suppExecutiveMailList);
            }
            System.debug('ccEmailList after added support Executive:'+ccEmailList);
            
            String tableHtmlBody= '';            
            tableHtmlBody +=  '<table border="1" style="border-collapse: collapse"><tr><th>Case Number</th><th>Created Date</th><th>Status</th><th>Complaint Category</th><th>Booking</th><th>Project</th><th>Case Owner</th></tr>';
            
            for(Case caseRcd:caseListForEscalationEmail)
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
                String projectName='';
                String projectLink='';
                if(caseRcd.Project__c!=null){
                    projectLink=URL.getOrgDomainUrl().toExternalForm() + '/' + caseRcd.Project__c;
                    projectName=caseRcd.Project__r.Name;
                }
                String createdDt=caseRcd.CreatedDate.format('dd/MM/yyyy');  
                String recordLink=URL.getOrgDomainUrl().toExternalForm() + '/' + caseRcd.Id;
                tableHtmlBody +='<tr><td><a href="'+recordLink+'">' + caseNumber +'</a></td><td>'+ createdDt +'</td><td>'+ caseStatus + '</td><td>'+ complaintCategory + '</td><td><a href="'+bookingLink+'">' + bookingName +'</a></td><td><a href="'+projectLink+'">' + projectName +'</a></td><td>'+ caseOwner + '</td></tr>';            
                if(caseRcd.Status!='Escalated'){
                    caseListForUpdate.add(caseRcd);
                }          
            }
            tableHtmlBody += '</table></br>Thank You, </br> Dynamix';
            System.debug('tableHtmlBody:'+tableHtmlBody);
            
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'X2nd_Escalation_For_Customer_Complaint_Case' LIMIT 1];
            System.debug('emailTemplate:'+emailTemplate);
            String htmlBody = emailTemplate.HtmlValue+tableHtmlBody;
            htmlBody = htmlBody.replace('{!CRMHeadUserName}', crmHeadUser.Name);
            String plainBody = emailTemplate.Body+tableHtmlBody;
            plainBody = plainBody.replace('{!CRMHeadUserName}', crmHeadUser.Name);
            if(emailTemplate!=null){           
                List<String> toEmailList=new List<String>();   
                //add Director users email
                toEmailList.addAll(directorMailList);                  
                SendEmailandBellNotificationUtility.SendEmail2(emailTemplate.Id,htmlBody,plainBody,toEmailList,ccEmailList,false,null,null,null,null);
            }       
              
            //for update Case status
            if(caseListForUpdate.size()>0){
                for(Case caseRcd1:caseListForUpdate){
                    caseRcd1.Status='Escalated';
                }
                update caseListForUpdate;
            }
        }
    }
}