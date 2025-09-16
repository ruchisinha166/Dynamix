global class BatchPrimarySecondaryInfoNotUpdated implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(DataBase.BatchableContext bc){
        Date pastOneDays = System.Today().addDays(-1);
        return Database.getQueryLocator('Select Id,Name,OwnerId,Project_Name_Formulla__c,Unit_Number__c,Reinitiated_Date__c From Booking__c Where Primary_Secondary_info_Updated__c = false AND Reinitiated_Date__c =: pastOneDays');
    }
    global void execute(Database.BatchableContext bc,List<Booking__c> BookingList){
        System.debug('BookingList'+BookingList.size());
        String CRMHeadUserName = Label.CRM_Head_User;
        User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'].Id AND isActive =: true Limit 1];
        
        Set<Id> setOfBookingIds = new Set<Id>(); 
        for(Booking__c bookObj : BookingList){
            setOfBookingIds.add(bookObj.Id);
        }
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Primary_Secondary_info_Updated' limit 1];
        EmailTemplate emailTemplate1 = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Primary_Seconday_info_not_updated1' limit 1];
        
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User]);
        List<String> addresses = new List<String>();
        List<String> ccList = new List<String>();
        addresses.add(CRMHeadRoleObjUser.Email);
        System.debug('Before bookObj');
        for(Booking__c bookObj : BookingList){
       
            ccList.clear();
            ccList.add(mapIdToUser.get(bookObj.OwnerId).Email);
            String htmlBody = emailTemplate.HtmlValue;
            String plainBody = emailTemplate.Body;
            htmlBody = htmlBody.replace('{!RM}', mapIdToUser.get(bookObj.OwnerId).Name);
            htmlBody = htmlBody.replace('{!Unit}', bookObj.Unit_Number__c);
            htmlBody = htmlBody.replace('{!Name}', bookObj.Name);
            htmlBody = htmlBody.replace('{!Project}', bookObj.Project_Name_Formulla__c);
            
            String htmlBody1 = emailTemplate1.HtmlValue;
            String plainBody1 = emailTemplate1.Body;
            htmlBody1 = htmlBody1.replace('{!RM}', mapIdToUser.get(bookObj.OwnerId).Name);
            htmlBody1 = htmlBody1.replace('{!Unit}', bookObj.Unit_Number__c);
            htmlBody1 = htmlBody1.replace('{!Name}', bookObj.Name);
            htmlBody1 = htmlBody1.replace('{!Project}', bookObj.Project_Name_Formulla__c);
            
            SendEmailandBellNotificationUtility.SendEmail2(String.ValueOf(emailTemplate.Id),
                                                          
                                                           htmlBody,
                                                           plainBody,
                                                           ccList,
                                                           null,true,bookObj.Id
                                                           ,null,null,null);
            
            SendEmailandBellNotificationUtility.SendEmail2(String.ValueOf(emailTemplate1.Id),
                                                          
                                                           htmlBody1,
                                                           plainBody1,
                                                           addresses,
                                                           null,true,bookObj.Id
                                                           ,null,null,null);
            
        }
    } 
    global void finish(Database.BatchableContext bc){
        
    }
}