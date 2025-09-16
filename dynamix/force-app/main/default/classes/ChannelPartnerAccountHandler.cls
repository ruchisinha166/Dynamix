public class ChannelPartnerAccountHandler {
    public static void handleAfterInsert(Map<Id, Account> newAccounts) {
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        String emailTemplateName = 'Channel_Partner_Email';
        System.debug('emailTemplateName---------->'+emailTemplateName);
        
        
        Map<Id, Id> accountToProjectMap = new Map<Id, Id>();
        for (Account acc : newAccounts.values()) {
             RecordType channelPartnerRecordType = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Channel_Partner' LIMIT 1];
            if (acc.RecordTypeId == channelPartnerRecordType.Id ) {
                System.debug('acc.RecordType.Name---------->'+acc.RecordType.Name);
                accountToProjectMap.put(acc.Id, acc.Project__c);
                System.debug('accountToProjectMap---------->'+accountToProjectMap);
            }
        }
        
        Map<Id, User> projectSiteHeads = new Map<Id, User>();
        System.debug('projectSiteHeads---------->'+projectSiteHeads);
        for (Id projectId : accountToProjectMap.values()) {
            List<User> users = [SELECT Id, Email
                                FROM User
                                WHERE Id IN (SELECT Site_Head__c
                                             FROM Project__c
                                             WHERE Id = :projectId)];
            System.debug('users---------->'+users);
            
            if (!users.isEmpty()) {
                projectSiteHeads.put(projectId, users[0]);
                System.debug('projectSiteHeads---------->'+projectSiteHeads);
            }
        }
        
        List<EmailTemplate> templates = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :emailTemplateName LIMIT 1];
        System.debug('templates---------->'+templates);
        for (Account acc : newAccounts.values()) {
            RecordType channelPartnerRecordType = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Channel_Partner' LIMIT 1];
            if (acc.RecordTypeId == channelPartnerRecordType.Id && accountToProjectMap.containsKey(acc.Id) && projectSiteHeads.containsKey(accountToProjectMap.get(acc.Id))) {
                User projectSiteHead = projectSiteHeads.get(accountToProjectMap.get(acc.Id));
                System.debug('projectSiteHead---------->'+projectSiteHead);
                // Create and send email messages
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setSubject('New Channel Partner Account Created');
                email.setToAddresses(new List<String>{projectSiteHead.Email});
                System.debug('email---------->'+email);
                // Specify the Visualforce email template ID
                
                if (!templates.isEmpty()) {
                    email.setTemplateId(templates[0].Id);
                    System.debug('email---------->'+email);
                }
                
                // Set the target object (in this case, the Account)
                email.setTargetObjectId(acc.Id);
                emailMessages.add(email);
                System.debug('emailMessages---------->'+emailMessages);
            }
        }
        
    }
}