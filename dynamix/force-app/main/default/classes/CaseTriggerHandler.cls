public class CaseTriggerHandler {
    public static void sendEmailForComplaintType(List<Case> listOfCase,Map<Id,Case> oldMapCase){  
        //CRM Head User
        String crmHeadUserName = Label.CRM_Head_User;
        System.debug('crmHeadUserName:'+crmHeadUserName);
        //Mr. Animesh User
        String mrAnimeshUserName = Label.Animesh_Das;
        System.debug('mrAnimeshUserName:'+mrAnimeshUserName);
        
        //get users
        List<User> userList=[Select Id,Name,Email,UserName,UserRole.DeveloperName,Profile.Name,IsActive From User Where IsActive=true AND (UserName=:crmHeadUserName OR UserName=:mrAnimeshUserName OR UserRole.DeveloperName=:'S_M_Head' OR  (UserRole.DeveloperName=:'Support_Executive' AND Profile.Name=:'Support Executive')) ];
        
        User crmHeadUser;
        User mrAnimeshUser;
        List<String> ccEmailList=new List<String>();         
        Set<String> smHeadMailList=new Set<String>();
        Set<String> suppExecutiveMailList=new Set<String>();
        
        if(userList.size()>0){
            for(User userRcd:userList){
                if(userRcd.UserName==crmHeadUserName){
                    crmHeadUser=userRcd;
                }
                if(userRcd.UserName==mrAnimeshUserName){
                    mrAnimeshUser=userRcd;
                }
                if(userRcd.Email!=null && userRcd.UserRole.DeveloperName=='S_M_Head'){
                    smHeadMailList.add(userRcd.Email);
                }
                if(userRcd.Email!=null && userRcd.UserRole.DeveloperName=='Support_Executive' && userRcd.Profile.Name=='Support Executive'){
                    suppExecutiveMailList.add(userRcd.Email);
                }
            }
        }
        System.debug('crmHeadUser:'+crmHeadUser);        
        System.debug('mrAnimeshUser:'+mrAnimeshUser);  
        System.debug('smHeadMailList:'+smHeadMailList);
        System.debug('listOfCase:'+listOfCase);   
        System.debug('suppExecutiveMailList:'+suppExecutiveMailList);
        
        if(suppExecutiveMailList!=null){
            ccEmailList.addAll(suppExecutiveMailList);
        }
        System.debug('ccEmailList after added support Executive:'+ccEmailList);
        
        //get active users list
        Map<Id,User> usersMapList=new Map<Id,User>([Select Id,Name,Email,IsActive From User Where IsActive=true]);
        List<Case> caseListForUpdate=new List<Case>();
        for(Case caseRcd:listOfCase){
            String newCaseRcdOwnerId=caseRcd.OwnerId;
            String oldCaseOwnerId=oldMapCase.get(caseRcd.Id).OwnerId;
            System.debug('newCaseRcdOwnerId:'+newCaseRcdOwnerId);
            System.debug('oldCaseOwnerId:'+oldCaseOwnerId);
            if(newCaseRcdOwnerId !=oldCaseOwnerId){
                System.debug('newCaseRcdOwnerId1:'+newCaseRcdOwnerId.substring(0,3));
                System.debug('oldCaseOwnerId1:'+oldCaseOwnerId.substring(0,3));
                //005 means user
                //00G menas queue
                //case owner changed from queue to user
                if(newCaseRcdOwnerId.substring(0,3) == '005'&& oldCaseOwnerId.substring(0,3) == '00G' ){
                    System.debug('Case owner Change from Queue to User');
                    System.debug('Case Type:'+caseRcd.Type);
                    if(caseRcd.Status!='Assigned'){
                        Case caseRcd1  = new Case(Id = caseRcd.Id);
                        caseRcd1.Status='Assigned';
                        caseListForUpdate.add(caseRcd1);
                    }
                    String caseOwnerName=usersMapList.get(caseRcd.OwnerId).Name;
                    //for Channel Partner Complaint Type 
                    if(caseRcd.Type=='Channel Partner Complaint'){                        
                        //for send Email to CRM Head User
                        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Channel_Partner_Complaint_Case_Email' LIMIT 1];
                        System.debug('emailTemplate:'+emailTemplate);
                        String recordLink=URL.getOrgDomainUrl().toExternalForm() + '/' + caseRcd.Id;
                        
                        String htmlBody = emailTemplate.HtmlValue;
                        htmlBody = htmlBody.replace('{!CaseNumber}', '<a href="'+recordLink+'">' + caseRcd.CaseNumber +'</a>');
                        htmlBody = htmlBody.replace('{!CRMHeadUserName}', crmHeadUser.Name);
                        htmlBody = htmlBody.replace('{!newCaseOwner}', caseOwnerName);
                        String plainBody = emailTemplate.Body;
                        plainBody = plainBody.replace('{!CaseNumber}', '<a href="'+recordLink+'">' + caseRcd.CaseNumber +'</a>'); 
                        plainBody = plainBody.replace('{!CRMHeadUserName}', crmHeadUser.Name);
                        plainBody = plainBody.replace('{!newCaseOwner}', caseOwnerName);
                        
                        //for add mr animesh as cc
                        if(mrAnimeshUser!=null){
                            ccEmailList.add(mrAnimeshUser.Email); 
                        }     
                        System.debug('ccEmailList after added Mr animesh:'+ccEmailList);
                        if(emailTemplate!=null){    
                            List<String> toEmailList=new List<String>();                             
                            //for add S & M head role users as cc
                            if(smHeadMailList!=null){
                                toEmailList.addAll(smHeadMailList); 
                            }               
                            SendEmailandBellNotificationUtility.SendEmail2(emailTemplate.Id,null,htmlBody,plainBody,toEmailList,ccEmailList,true,caseRcd.Id,null,null,null,null);
                        }                        
                    }     
                    //for Customer Complaint Type 
                    else if(caseRcd.Type=='Customer Complaint'){                        
                        //for send Email to CRM Head User
                        EmailTemplate emailTemplate1 = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Customer_Complaint_Case_Email' LIMIT 1];
                        System.debug('emailTemplate1:'+emailTemplate1);
                        String recordLink=URL.getOrgDomainUrl().toExternalForm() + '/' + caseRcd.Id;
                        String htmlBody1 = emailTemplate1.HtmlValue;
                        htmlBody1 = htmlBody1.replace('{!CaseNumber}', '<a href="'+recordLink+'">' + caseRcd.CaseNumber +'</a>');
                        htmlBody1 = htmlBody1.replace('{!CRMHeadUserName}', crmHeadUser.Name);
                        htmlBody1 = htmlBody1.replace('{!newCaseOwner}', caseOwnerName);
                        String plainBody1 = emailTemplate1.Body;
                        plainBody1 = plainBody1.replace('{!CaseNumber}', '<a href="'+recordLink+'">' + caseRcd.CaseNumber +'</a>'); 
                        plainBody1 = plainBody1.replace('{!CRMHeadUserName}', crmHeadUser.Name);
                        plainBody1 = plainBody1.replace('{!newCaseOwner}', caseOwnerName);
                        
                        //for add S & M head role users as cc
                        if(smHeadMailList!=null){
                            ccEmailList.addAll(smHeadMailList); 
                        }   
                        System.debug('ccEmailList after added Site Head users Emails:'+ccEmailList);
                        if(emailTemplate1!=null){    
                            List<String> toEmailList1=new List<String>();                             
                            toEmailList1.add(crmHeadUser.Email);              
                            SendEmailandBellNotificationUtility.SendEmail2(emailTemplate1.Id,null,htmlBody1,plainBody1,toEmailList1,ccEmailList,true,caseRcd.Id,null,null,null,null);
                        }                        
                    }                 
                }
            }
        }
        if(caseListForUpdate.size()>0){
            update caseListForUpdate;
        }
    }
}