public class BrokerPaymentNotClearBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id,name,Amount__c,Amount_Paid__c,Booking__r.Channel_Partner__c,Booking__r.Channel_Partner__r.name,Booking__c,Picklist_Payment_Cleared__c,CreatedDate from Broker_Payment__c where Picklist_Payment_Cleared__c = null AND CreatedDate = LAST_N_DAYS:3]);
    }
    public void execute(Database.BatchableContext BC, List<Broker_Payment__c> ListOfBrokers){
        System.debug('ListOfBrokers'+ListOfBrokers);
        Set<String> accountUserId = new set<string>();
        accountUserId.add(System.Label.Account_User_ID);       
        String SiteHeadUserName = Label.Site_Head_User_Name;
        User SiteHeadRoleUsers = [Select Id,Name,Email From User Where UserName =: SiteHeadUserName AND  UserRoleId =: [select id from UserRole where DeveloperName =: 'Site_Head' limit 1].Id Limit 1];
        User AccountTeamUser = [Select Id,Name,Email From User Where Id In : accountUserId Limit 1];
        System.debug('SiteHeadRoleUsers'+SiteHeadRoleUsers);
        System.debug('AccountTeamUser'+AccountTeamUser);
        EmailTemplate emailTemplate1 = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Invoice_approved_but_payment_not_cleared' limit 1];
        EmailTemplate emailTemplate2 = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Invoice_approved_but_payment_not_cleared_escalation' limit 1];
        Set<Id> setOFBookingIds = new Set<Id>();
        for(Broker_Payment__c Bp : ListOfBrokers){
            setOFBookingIds.add(Bp.Booking__c);
        }
        Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,OwnerId,Unit_Number__c,Channel_Partner__c,Project_Name_Formulla__c From Booking__c where Id in: setOFBookingIds]);
        System.debug('mapIdToBooking'+mapIdToBooking);
        Set<Id> setOFCPIds = new Set<Id>();
        for(Id key : mapIdToBooking.keySet()){
            setOFCPIds.add(mapIdToBooking.get(key).Channel_Partner__c);
        }
        List<String> addresses1 = new List<String>();
        List<String> addresses2 = new List<String>();
        addresses1.add(AccountTeamUser.Email);
        System.debug('addresses1'+addresses1);
        addresses2.add(SiteHeadRoleUsers.Email);
        System.debug('addresses2'+addresses2);
        Map<Id,Account> mapIdToAccount = new Map<Id,Account>([Select Id,Name From Account Where Id In : setOFCPIds]);
        System.debug('mapIdToAccount'+mapIdToAccount);
        for(Broker_Payment__c Bp : ListOfBrokers){
            System.debug('Bp'+Bp);
            if(Bp.Booking__r.Channel_Partner__c != null ){
                System.debug('Bp.Booking__r.Channel_Partner__c'+Bp.Booking__r.Channel_Partner__c);
                if(Bp.CreatedDate.Day() == System.today().addDays(-3).Day() &&
                   Bp.CreatedDate.Month() == System.today().addDays(-3).Month() &&
                   Bp.CreatedDate.Year() == System.today().addDays(-3).Year()
                  ){
                      System.debug('Bp.CreatedDate'+Bp.CreatedDate);
                      if(Bp.Booking__c != null){
                          System.debug('Bp.Booking__c'+Bp.Booking__c);
                          if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(Bp.Booking__c)){
                              Booking__c BookObj = mapIdToBooking.get(Bp.Booking__c);
                              System.debug('BookObj'+BookObj);
                              String htmlBody1 = emailTemplate1.HtmlValue;
                              if(BookObj.Unit_Number__c != null){
                                  htmlBody1 = htmlBody1.replace('{!Unit}', BookObj.Unit_Number__c);
                              }
                              if(BookObj.Project_Name_Formulla__c != null){
                                  htmlBody1 = htmlBody1.replace('{!Project}', BookObj.Project_Name_Formulla__c);
                              }
                              if(BookObj.Name != null){
                                  htmlBody1 = htmlBody1.replace('{!Name}', BookObj.Name);
                              }
                              if(mapIdToAccount.size() > 0 && mapIdToAccount.containsKey(Bp.Booking__r.Channel_Partner__c)){
                                  Account accObj = mapIdToAccount.get(Bp.Booking__r.Channel_Partner__c);
                                  htmlBody1 = htmlBody1.replace('{!CP}', accObj.Name);
                              }
                              String plainBody1 = emailTemplate1.Body;
                              if(BookObj.Unit_Number__c != null){
                                  plainBody1 = plainBody1.replace('{!Unit}', BookObj.Unit_Number__c);
                              }
                              if(BookObj.Project_Name_Formulla__c != null){
                                  plainBody1 = plainBody1.replace('{!Project}', BookObj.Project_Name_Formulla__c);
                              }
                              if(BookObj.Name != null){
                                  plainBody1 = plainBody1.replace('{!Name}', BookObj.Name);
                              }
                              if(mapIdToAccount.size() > 0 && mapIdToAccount.containsKey(Bp.Booking__r.Channel_Partner__c)){
                                  Account accObj = mapIdToAccount.get(Bp.Booking__r.Channel_Partner__c);
                                  plainBody1 = plainBody1.replace('{!CP}', accObj.Name);
                              }
                              String Subject1 = emailTemplate1.Subject;
                              SendEmailandBellNotificationUtility.SendEmail3(String.ValueOf(emailTemplate1.Id),
                                                                             Subject1,
                                                                             htmlBody1,
                                                                             plainBody1,
                                                                             addresses1,
                                                                             null,true,
                                                                             Bp.Id,
                                                                             null,null,null);
                              String htmlBody2 = emailTemplate2.HtmlValue;
                              if(SiteHeadRoleUsers != null){
                                  htmlBody2 = htmlBody2.replace('{!Site}', SiteHeadRoleUsers.Name);
                              }
                              if(BookObj.Unit_Number__c != null){
                                  htmlBody2 = htmlBody2.replace('{!Unit}', BookObj.Unit_Number__c);
                              }
                              if(BookObj.Project_Name_Formulla__c != null){
                                  htmlBody2 = htmlBody2.replace('{!Project}', BookObj.Project_Name_Formulla__c);
                              }
                              if(BookObj.Name != null){
                                  htmlBody2 = htmlBody2.replace('{!Name}', BookObj.Name);
                              }
                              if(mapIdToAccount.size() > 0 && mapIdToAccount.containsKey(Bp.Booking__r.Channel_Partner__c)){
                                  Account accObj = mapIdToAccount.get(Bp.Booking__r.Channel_Partner__c);
                                  htmlBody2 = htmlBody2.replace('{!CP}', accObj.Name);
                              }
                              String plainBody2 = emailTemplate2.Body;
                              if(SiteHeadRoleUsers != null){
                                  plainBody2 = plainBody2.replace('{!Site}', SiteHeadRoleUsers.Name);
                              }
                              if(BookObj.Unit_Number__c != null){
                                  plainBody2 = plainBody2.replace('{!Unit}', BookObj.Unit_Number__c);
                              }
                              if(BookObj.Project_Name_Formulla__c != null){
                                  plainBody2 = plainBody2.replace('{!Project}', BookObj.Project_Name_Formulla__c);
                              }
                              if(BookObj.Name != null){
                                  plainBody2 = plainBody2.replace('{!Name}', BookObj.Name);
                              }
                              if(mapIdToAccount.size() > 0 && mapIdToAccount.containsKey(Bp.Booking__r.Channel_Partner__c)){
                                  Account accObj = mapIdToAccount.get(Bp.Booking__r.Channel_Partner__c);
                                  plainBody2 = plainBody2.replace('{!CP}', accObj.Name);
                              }
                              String Subject2 = emailTemplate2.Subject;
                              SendEmailandBellNotificationUtility.SendEmail3(String.ValueOf(emailTemplate2.Id),
                                                                             Subject2,
                                                                             htmlBody2,
                                                                             plainBody2,
                                                                             addresses2,
                                                                             null,true,
                                                                             Bp.Id,
                                                                             null,null,null);
                          }
                      }
                  }               
            }
        }   
    }
    public void finish(Database.BatchableContext BC){
    }
}