//This Batch Class Will Execute for All the Cases records for which Case type is Channel Parner & Case Status is still not Resolved after 6 days 
//This Batch class will send Email to users with S & M Head role & Mr. Animesh & cc to users with Support executive profile & role : Batch Size Default(200)
//Email send functionality to S & M Head, Mr. Animesh & Support Executive is called From Finish Method 
global class ChannelPartnerComplaintCaseEscalation implements DataBase.Batchable<Sobject>,DataBase.Stateful{
    List<Case> caseListForEscalationEmail = new List<Case>();
    global List<Case> start(DataBase.BatchableContext bc){ 
        List<Case> caseList = new List<Case>();      
        caseList=[Select Id,CaseNumber,Status,Type,CreatedDate,Owner.Name,Booking__c,Booking__r.Name,Complaint_category__c From Case Where Status!='Resolved' AND Type=:'Channel Partner Complaint'];
        System.debug('caseList:'+ caseList);
        return caseList;
    }
    global void execute(Database.BatchableContext bc,List<Case> caseList1){
        Date dateBefore6Days=(system.today()-6);
        //Date dateBefore6Days=(system.today()); //for only testing purpose
        System.debug('dateBefore6Days:'+dateBefore6Days);
        For(Case caseRcd:caseList1){
            Date caseCreatedDate=caseRcd.CreatedDate.date();
            System.debug('caseCreatedDate:'+caseCreatedDate);
            if(dateBefore6Days==caseCreatedDate){
                caseListForEscalationEmail.add(caseRcd);
            }
        }
        System.debug('caseListForEscalationEmail Execute:'+caseListForEscalationEmail);
    } 
    global void finish(Database.BatchableContext bc){        
        if(caseListForEscalationEmail.size()>0){ 
            List<Case> caseListForUpdate=new List<Case>();    

            //Mr. Animesh User
            String mrAnimeshUserName = Label.Animesh_Das;
            System.debug('mrAnimeshUserName:'+mrAnimeshUserName);
            
            List<String> ccEmailList=new List<String>(); 
            Set<String> suppExecutiveMailList=new Set<String>();
            Set<String> smHeadMailList=new Set<String>();
            User mrAnimeshUser;
            
            //for get users with Support Executive Role & Profile, S & M Head role & Mr.Animesh user
            List<User> userList=[Select Id,Name,UserName,UserRole.DeveloperName,Email,Profile.Name,IsActive From User Where IsActive=true AND (UserName=:mrAnimeshUserName OR UserRole.DeveloperName=:'S_M_Head' OR (UserRole.DeveloperName=:'Support_Executive' AND Profile.Name=:'Support Executive'))];
            
            if(userList.size()>0){
                for(User userRcd:userList){
                    if(userRcd.Email!=null && userRcd.UserRole.DeveloperName=='Support_Executive' && userRcd.Profile.Name=='Support Executive'){
                        suppExecutiveMailList.add(userRcd.Email);
                    }
                    if(userRcd.Email!=null && userRcd.UserRole.DeveloperName=='S_M_Head'){
                        smHeadMailList.add(userRcd.Email);
                    }
                    if(userRcd.UserName==mrAnimeshUserName){
                        mrAnimeshUser=userRcd;
                    }
                }
            }
            System.debug('suppExecutiveMailList:'+suppExecutiveMailList);
            System.debug('smHeadMailList:'+smHeadMailList);
            System.debug('mrAnimeshUser:'+mrAnimeshUser);      
            
            if(suppExecutiveMailList!=null){
                ccEmailList.addAll(suppExecutiveMailList);
            }
            System.debug('ccEmailList after added support Executive:'+ccEmailList);
            
            String tableHtmlBody= '';            
            tableHtmlBody +=  '<table border="1" style="border-collapse: collapse"><tr><th>Case Number</th><th>Created Date</th><th>Status</th><th>Complaint Category</th><th>Booking</th><th>Case Owner</th></tr>';
            
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
                String createdDt=caseRcd.CreatedDate.format('dd/MM/yyyy');  
                String recordLink=URL.getOrgDomainUrl().toExternalForm() + '/' + caseRcd.Id;
                tableHtmlBody +='<tr><td><a href="'+recordLink+'">' + caseNumber +'</a></td><td>'+ createdDt +'</td><td>'+ caseStatus + '</td><td>'+ complaintCategory + '</td><td><a href="'+bookingLink+'">' + bookingName +'</a></td><td>'+ caseOwner + '</td></tr>';        
                if(caseRcd.Status!='Escalated'){
                    caseListForUpdate.add(caseRcd);
                }              
            }
            tableHtmlBody += '</table></br>Thank You, </br> Dynamix';
            System.debug('tableHtmlBody:'+tableHtmlBody);
            
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Escalation_For_Channel_Partner_Complaint_Case' LIMIT 1];
            System.debug('emailTemplate:'+emailTemplate);
            String htmlBody = emailTemplate.HtmlValue+tableHtmlBody;
            String plainBody = emailTemplate.Body+tableHtmlBody;
            if(emailTemplate!=null){           
                List<String> toEmailList=new List<String>();   
                //add S & M Head users email
                toEmailList.addAll(smHeadMailList); 
                //add Mr. Animesh Email
                if(mrAnimeshUser!=null){
                    toEmailList.add(mrAnimeshUser.Email); 
                } 
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