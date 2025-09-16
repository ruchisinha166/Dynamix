public class BrokerPaymentNotClearEscalationBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        //List<Broker_Payment__c> brokerPaymentList=[Select Id,name,Amount__c,Invoice_Date__c,Booking__r.Project_Name_Formulla__c,Booking__r.Unit_Number__c,Amount_Paid__c,Booking__r.Channel_Partner__c,Booking__r.Channel_Partner__r.name,Booking__c,Picklist_Payment_Cleared__c,CreatedDate from Broker_Payment__c where Picklist_Payment_Cleared__c = null AND CreatedDate = LAST_N_DAYS:1];
        //System.debug('Broker Payment List====>'+brokerPaymentList);
        return Database.getQueryLocator([Select Id,name,Amount__c,Invoice_Date__c,Booking__r.Project_Name_Formulla__c,Booking__r.Unit_Number__c,Amount_Paid__c,Booking__r.Channel_Partner__c,Booking__r.Channel_Partner__r.name,Booking__c,Picklist_Payment_Cleared__c,CreatedDate from Broker_Payment__c where Picklist_Payment_Cleared__c = null AND CreatedDate = LAST_N_DAYS:7]);
    }
    public void execute(Database.BatchableContext BC, List<Broker_Payment__c> listOfBrokersPayments){
        System.debug('BrokerPaymentNotClearEscalationBatch-Execute method:'+listOfBrokersPayments);
        // Set<String> accountUserId = new set<string>();
        //accountUserId.add(System.Label.Account_User_ID);       
        // String SMHeadHeadUserName = Label.S_M_Head;
        String JayUserName = Label.JayUser;
        
        // User SMHeadRoleUsers = [Select Id,Name,Email From User Where UserName =: SMHeadHeadUserName AND  UserRoleId =: [select id from UserRole where DeveloperName =: 'S_M_Head' limit 1].Id Limit 1];
        // User AccountTeamUser = [Select Id,Name,Email From User Where Id In : accountUserId Limit 1];
        User JayUser = [Select Id,Name,Email From User Where UserName =: JayUserName Limit 1];
        
        List<User> SMHeadUserList = [Select Id,Name,Email,isActive,UserRole.DeveloperName From User Where UserRole.DeveloperName =: 'S_M_Head' AND isActive=:true];
        List<User> accountUserList = [Select Id,Name,Email,isActive,UserRole.DeveloperName,Profile.Name From User Where Profile.Name =: 'Account Team' AND isActive=:true];
        
        EmailTemplate emailTempForSMHead = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Broker_Payment_Not_Cleared_S_M_Head' limit 1];
        EmailTemplate emailTempForAccTeam = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Broker_Payment_Not_Cleared_Accounts_Team' limit 1];
        EmailTemplate emailTemplate3 = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Broker_Payment_Not_Cleared_jay' limit 1];
        
        Set<Id> setOFBookingIds = new Set<Id>();
        for(Broker_Payment__c Bp : listOfBrokersPayments){
            setOFBookingIds.add(Bp.Booking__c);
        }
        Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,OwnerId,Unit_Number__c,Channel_Partner__c,Project_Name_Formulla__c From Booking__c where Id in: setOFBookingIds]);
        Set<Id> setOFCPIds = new Set<Id>();
        for(Id key : mapIdToBooking.keySet()){
            setOFCPIds.add(mapIdToBooking.get(key).Channel_Partner__c);
        }
        // List<String> addresses1 = new List<String>();
        // List<String> addresses2 = new List<String>();
        List<String> addresses3 = new List<String>();
        
        List<String> smHeadAddresses = new List<String>();
        List<String> accTeamAddresses = new List<String>();
        
        //addresses1.add(SMHeadRoleUsers.Email);
        // addresses2.add(AccountTeamUser.Email);
        addresses3.add(JayUser.Email);
        
        if(SMHeadUserList.size()>0){
            for(User userRcd1:SMHeadUserList){
                if(userRcd1.Email!=null){
                    smHeadAddresses.add(userRcd1.Email);
                }
            }
        }
        if(accountUserList.size()>0){
            for(User userRcd2:accountUserList){
                if(userRcd2.Email!=null){
                    accTeamAddresses.add(userRcd2.Email);
                }
            }
        }
        
        Map<Id,Account> mapIdToAccount = new Map<Id,Account>([Select Id,Name From Account Where Id In : setOFCPIds]);
        
        for(Broker_Payment__c Bp : listOfBrokersPayments){
            if(Bp.Booking__r.Channel_Partner__c != null ){
                if(Bp.CreatedDate.addDays(7).Day() == System.today().Day() &&
                   Bp.CreatedDate.addDays(7).Month() == System.today().Month() &&
                   Bp.CreatedDate.addDays(7).Year() == System.today().Year()
                  ){
                      if(Bp.Booking__c != null){
                          if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(Bp.Booking__c)){
                              Booking__c BookObj = mapIdToBooking.get(Bp.Booking__c);
                              String htmlBody1 = emailTempForSMHead.HtmlValue;
                              if(BookObj.Unit_Number__c != null){
                                  htmlBody1 = htmlBody1.replace('{!Unit}', BookObj.Unit_Number__c);
                              }
                              if(BookObj.Project_Name_Formulla__c != null){
                                  htmlBody1 = htmlBody1.replace('{!Project}', BookObj.Project_Name_Formulla__c);
                              }
                              if(BookObj.Name != null){
                                  htmlBody1 = htmlBody1.replace('{!Name}', BookObj.Name);
                              }
                              if(Bp.Invoice_Date__c != null){
                                  htmlBody1 = htmlBody1.replace('{!Date}', String.valueOf(Bp.Invoice_Date__c));
                              }
                              if(mapIdToAccount.size() > 0 && mapIdToAccount.containsKey(Bp.Booking__r.Channel_Partner__c)){
                                  Account accObj = mapIdToAccount.get(Bp.Booking__r.Channel_Partner__c);
                                  htmlBody1 = htmlBody1.replace('{!CP}', accObj.Name);
                              }
                              String plainBody1 = emailTempForSMHead.Body;
                              if(BookObj.Unit_Number__c != null){
                                  plainBody1 = plainBody1.replace('{!Unit}', BookObj.Unit_Number__c);
                              }
                              if(BookObj.Project_Name_Formulla__c != null){
                                  plainBody1 = plainBody1.replace('{!Project}', BookObj.Project_Name_Formulla__c);
                              }
                              if(BookObj.Name != null){
                                  plainBody1 = plainBody1.replace('{!Name}', BookObj.Name);
                              }
                              if(Bp.Invoice_Date__c != null){
                                  plainBody1 = plainBody1.replace('{!Date}', String.valueOf(Bp.Invoice_Date__c));
                              }
                              if(mapIdToAccount.size() > 0 && mapIdToAccount.containsKey(Bp.Booking__r.Channel_Partner__c)){
                                  Account accObj = mapIdToAccount.get(Bp.Booking__r.Channel_Partner__c);
                                  plainBody1 = plainBody1.replace('{!CP}', accObj.Name);
                              }
                              String Subject1 = emailTempForSMHead.Subject;
                              SendEmailandBellNotificationUtility.SendEmail3(String.ValueOf(emailTempForSMHead.Id),
                                                                             Subject1,
                                                                             htmlBody1,
                                                                             plainBody1,
                                                                             smHeadAddresses,
                                                                             null,true,
                                                                             Bp.Id,
                                                                             null,null,null);
                              String htmlBody2 = emailTempForAccTeam.HtmlValue;
                              if(BookObj.Unit_Number__c != null){
                                  htmlBody2 = htmlBody2.replace('{!Unit}', BookObj.Unit_Number__c);
                              }
                              if(BookObj.Project_Name_Formulla__c != null){
                                  htmlBody2 = htmlBody2.replace('{!Project}', BookObj.Project_Name_Formulla__c);
                              }
                              if(BookObj.Name != null){
                                  htmlBody2 = htmlBody2.replace('{!Name}', BookObj.Name);
                              }
                              if(Bp.Invoice_Date__c != null){
                                  htmlBody2 = htmlBody2.replace('{!Date}', String.valueOf(Bp.Invoice_Date__c));
                              }
                              if(mapIdToAccount.size() > 0 && mapIdToAccount.containsKey(Bp.Booking__r.Channel_Partner__c)){
                                  Account accObj = mapIdToAccount.get(Bp.Booking__r.Channel_Partner__c);
                                  htmlBody2 = htmlBody2.replace('{!CP}', accObj.Name);
                              }
                              String plainBody2 = emailTempForAccTeam.Body;
                              if(BookObj.Unit_Number__c != null){
                                  plainBody2 = plainBody2.replace('{!Unit}', BookObj.Unit_Number__c);
                              }
                              if(BookObj.Project_Name_Formulla__c != null){
                                  plainBody2 = plainBody2.replace('{!Project}', BookObj.Project_Name_Formulla__c);
                              }
                              if(BookObj.Name != null){
                                  plainBody2 = plainBody2.replace('{!Name}', BookObj.Name);
                              }
                              if(Bp.Invoice_Date__c != null){
                                  plainBody2 = plainBody2.replace('{!Date}', String.valueOf(Bp.Invoice_Date__c));
                              }
                              if(mapIdToAccount.size() > 0 && mapIdToAccount.containsKey(Bp.Booking__r.Channel_Partner__c)){
                                  Account accObj = mapIdToAccount.get(Bp.Booking__r.Channel_Partner__c);
                                  plainBody2 = plainBody2.replace('{!CP}', accObj.Name);
                              }
                              String Subject2 = emailTempForAccTeam.Subject;
                              SendEmailandBellNotificationUtility.SendEmail3(String.ValueOf(emailTempForAccTeam.Id),
                                                                             Subject2,
                                                                             htmlBody2,
                                                                             plainBody2,
                                                                             accTeamAddresses,
                                                                             null,true,
                                                                             Bp.Id,
                                                                             null,null,null);
                          }
                      }
                  }               
            }
        }   
        String tableHtmlBody= '';            
        tableHtmlBody +=  '<table border="1" style="border-collapse: collapse"><tr><th>CP Name</th><th>Apartment No.</th><th>Project</th><th>Amount</th><th>&nbsp;Submitted to the Accounts&nbsp;</th></tr>';
        System.debug('Before Table');
        for(Broker_Payment__c Bp : listOfBrokersPayments){
            System.debug('Before Table Bp.CreatedDate'+Bp.CreatedDate);
            if(Bp.Booking__r.Channel_Partner__c != null ){
                System.debug('Before Table');
                if(Bp.CreatedDate.addDays(7).Day() == System.today().Day() &&
                   Bp.CreatedDate.addDays(7).Month() == System.today().Month() &&
                   Bp.CreatedDate.addDays(7).Year() == System.today().Year()
                  ){
                      System.debug('Before Table Bp.Booking__c'+Bp.Booking__c);
                      if(Bp.Booking__c != null){
                          System.debug('Before Table Bp.Booking__c');
                          if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(Bp.Booking__c)){
                              Booking__c BookObj = mapIdToBooking.get(Bp.Booking__c);
                              System.debug('Before Table BookObj'+BookObj);
                              String CPName = '';
                              if(mapIdToAccount.size() > 0 && mapIdToAccount.containsKey(Bp.Booking__r.Channel_Partner__c)){
                                  Account accObj = mapIdToAccount.get(Bp.Booking__r.Channel_Partner__c);
                                  CPName = accObj.Name;
                              }
                              tableHtmlBody +='<tr><td>&nbsp;&nbsp;' + CPName +'&nbsp;&nbsp;</td><td>&nbsp;&nbsp;'+ Bp.Booking__r.Unit_Number__c +'&nbsp;&nbsp;</td><td>&nbsp;&nbsp;'+ Bp.Booking__r.Project_Name_Formulla__c + '&nbsp;&nbsp;</td><td>&nbsp;&nbsp;'+ Bp.Amount__c + '&nbsp;&nbsp;</td><td>&nbsp;&nbsp;'+ String.valueOf(Bp.Invoice_Date__c) + '&nbsp;&nbsp;</td></tr>';               
                          }
                      }
                  }               
            }
        }   
        tableHtmlBody += '</table></br>Thank You, </br> Dynamix';
        String htmlBody3 = emailTemplate3.HtmlValue+tableHtmlBody;
        String plainBody3 = emailTemplate3.Body+tableHtmlBody;
        String Subject3 = emailTemplate3.Subject;
        System.debug('htmlBody3'+htmlBody3);
        if(emailTemplate3!=null){           
            System.debug('SendEmail');
            SendEmailandBellNotificationUtility.SendEmail3(String.ValueOf(emailTemplate3.Id),
                                                           Subject3,
                                                           htmlBody3,
                                                           plainBody3,
                                                           addresses3,
                                                           null,true,
                                                           listOfBrokersPayments[0].Id,
                                                           null,null,null);
            
        }
        
    }
    public void finish(Database.BatchableContext BC){
    }
}