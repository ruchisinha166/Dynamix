public class SendEmailToCRMHeadOppOwnerSiteHeadClass {
    
    @InvocableMethod(label='Send Email On Document Upload')
    public static void sendEmail(List<String> recordId) {
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName =: 'Refund_Handover_is_completed' limit 1];
        
        String CRMHeadUserName = Label.CRM_Head_User;
        String SiteHeadUserName = Label.Site_Head_User_Name;
        
        List<User> CRMSiteHeadRoleUsers = [Select Id,Name,Email From User Where  
                                           ((UserName =: CRMHeadUserName AND UserRoleId =: [select id from UserRole where DeveloperName =: 'CRM_Head' limit 1].Id) OR
                                            (UserName =: SiteHeadUserName AND  UserRoleId =: [select id from UserRole where DeveloperName =: 'Site_Head' limit 1].Id )) AND
                                           isActive =: true Limit 2];
        
        List<String> recipientId = new List<String>();
        for(User userObj : CRMSiteHeadRoleUsers){
            recipientId.add(userObj.Email);
        }
        
        List<Booking__c> listOfBooking = [Select Id,Name,Related_Opportunity__c,OwnerId From Booking__c Where Id =: recordId[0]];
        Set<Id> setOfBookingOWnerIds = new Set<Id>();
        for(Booking__c bookObj : listOfBooking){
            setOfBookingOWnerIds.add(bookObj.OwnerId);
        }
        
        Set<Id> setOfBookingOppIds = new Set<Id>();
        for(Booking__c bookObj : listOfBooking){
            if(bookObj.Related_Opportunity__c != null){
                setOfBookingOppIds.add(bookObj.Related_Opportunity__c);
            }
        }
        
        Map<Id,Opportunity> mapIdToOppo = new Map<Id,Opportunity>([Select Id,OwnerId From Opportunity Where Id In : setOfBookingOppIds]);
        
        Set<Id> setOfOppoOwnerIds = new Set<Id>();
        for(Booking__c bookObj : listOfBooking){
            if(bookObj.Related_Opportunity__c != null){
                setOfOppoOwnerIds.add(mapIdToOppo.get(bookObj.Related_Opportunity__c).OwnerId);
            }
        }
        
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Email From User Where isActive =: true AND( Id IN : setOfBookingOWnerIds OR Id IN : setOfOppoOwnerIds )]);
        
        for(Booking__c bookObj : listOfBooking){
     
            recipientId.add(mapIdToUser.get(bookObj.OwnerId).Email);                    
            if(mapIdToOppo.size() > 0 && mapIdToOppo.containsKey(bookObj.Related_Opportunity__c)){
                recipientId.add(mapIdToUser.get(mapIdToOppo.get(bookObj.Related_Opportunity__c).OwnerId).Email);
            }
            String htmlBody = emailTemplate.HtmlValue;
            String plainBody = emailTemplate.Body;
            String Subject = bookObj.Name + ' ' + emailTemplate.Subject;
            
            SendEmailandBellNotificationUtility.SendEmail3(String.ValueOf(emailTemplate.Id),Subject,htmlBody,plainBody,recipientId,null,true,bookObj.Id,null,null,null);
        }
    }
}