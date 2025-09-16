//Batch size 8
public class BatchKYCNotVerifiedClass implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('Select Id,Name,Project_Name_Formulla__c,Unit_Number__c,OwnerId From Booking__c Where KYC_Verified__c = false AND Related_Opportunity__r.KYC_Completed__c = true');
    }
    public void execute(Database.BatchableContext BC, List<Booking__c> listOfBooking){
        EmailTemplate emailTemplate1 = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'KYC_Not_Verified_RM' limit 1];
        EmailTemplate emailTemplate2 = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'KYC_Not_Verified_CRM' limit 1];
        
        String CRMHeadUserName = Label.CRM_Head_User;
        User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: [select id from UserRole where DeveloperName =: 'CRM_Head' limit 1].Id AND isActive =: true Limit 1];
        List<String> addresses1 = new List<String>();
        List<String> addresses2 = new List<String>();
        addresses2.add(CRMHeadRoleObjUser.Email);     
        
        Set<Id> setOfBookingOwnerIds = new Set<Id>();
        for(Booking__c bookObj : listOfBooking){
            setOfBookingOwnerIds.add(bookObj.OwnerId);
        }
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Email,Name From User Where isActive =: true AND Id IN : setOfBookingOwnerIds]);
        for(Booking__c bookObj : listOfBooking){
            
            addresses1.add(mapIdToUser.get(bookObj.OwnerId).Email);
            String htmlBody1 = emailTemplate1.HtmlValue;
            if(mapIdToUser.get(bookObj.OwnerId).Name != null){
                htmlBody1 = htmlBody1.replace('{!RM}', String.valueOf(mapIdToUser.get(bookObj.OwnerId).Name));
            }
            if(bookObj.Unit_Number__c != null){
                htmlBody1 = htmlBody1.replace('{!Unit}', String.valueOf(bookObj.Unit_Number__c));
            }
            if(bookObj.Project_Name_Formulla__c != null){
                htmlBody1 = htmlBody1.replace('{!Project}', String.valueOf(bookObj.Project_Name_Formulla__c));
            }
           
            String plainBody1 = emailTemplate1.Body;
            if(mapIdToUser.get(bookObj.OwnerId).Name != null){
                plainBody1 = plainBody1.replace('{!RM}', String.valueOf(mapIdToUser.get(bookObj.OwnerId).Name));
            }
            if(bookObj.Unit_Number__c != null){
                plainBody1 = plainBody1.replace('{!Unit}', String.valueOf(bookObj.Unit_Number__c));
            }
            if(bookObj.Project_Name_Formulla__c != null){
                plainBody1 = plainBody1.replace('{!Project}', String.valueOf(bookObj.Project_Name_Formulla__c));
            }
            String Subject1 = emailTemplate1.Subject;
            SendEmailandBellNotificationUtility.SendEmail3(emailTemplate1.Id,
                                                           Subject1,
                                                           htmlBody1,
                                                           plainBody1,
                                                           addresses1,
                                                           null,true,
                                                           bookObj.Id,
                                                           null,null,null);
        
            
            String htmlBody2 = emailTemplate2.HtmlValue;
            if(mapIdToUser.get(bookObj.OwnerId).Name != null){
                htmlBody2 = htmlBody2.replace('{!RM}', String.valueOf(mapIdToUser.get(bookObj.OwnerId).Name));
            }
            if(bookObj.Unit_Number__c != null){
                htmlBody2 = htmlBody2.replace('{!Unit}', String.valueOf(bookObj.Unit_Number__c));
            }
            if(bookObj.Project_Name_Formulla__c != null){
                htmlBody2 = htmlBody2.replace('{!Project}', String.valueOf(bookObj.Project_Name_Formulla__c));
            }
           
            String plainBody2 = emailTemplate2.Body;
            if(mapIdToUser.get(bookObj.OwnerId).Name != null){
                plainBody2 = plainBody2.replace('{!RM}', String.valueOf(mapIdToUser.get(bookObj.OwnerId).Name));
            }
            if(bookObj.Unit_Number__c != null){
                plainBody2 = plainBody2.replace('{!Unit}', String.valueOf(bookObj.Unit_Number__c));
            }
            if(bookObj.Project_Name_Formulla__c != null){
                plainBody2 = plainBody2.replace('{!Project}', String.valueOf(bookObj.Project_Name_Formulla__c));
            }
            String Subject2 = emailTemplate2.Subject;
            SendEmailandBellNotificationUtility.SendEmail3(emailTemplate2.Id,
                                                           Subject2,
                                                           htmlBody2,
                                                           plainBody2,
                                                           addresses2,
                                                           null,true,
                                                           bookObj.Id,
                                                           null,null,null);
        }
        
    }
    public void finish(Database.BatchableContext BC){
    }
}