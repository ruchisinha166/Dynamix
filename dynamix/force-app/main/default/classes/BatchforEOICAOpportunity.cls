public class BatchforEOICAOpportunity implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, Name,Launch_CA_Period_s_Start_Date__c,Launch_CA_Period_s_End_Date__c,Minimum_amount_for_CA__c,Project_Email__c,
                                         Launch_EOI_Period_s_Start_Date__c,Launch_EOI_Period_s_End_Date__c,Minimum_amount_for_EOI__c
                                         FROM Project__c WHERE Launch_EOI_Period_s_End_Date__c  =: System.today() OR Launch_CA_Period_s_End_Date__c =: System.today()]);
    }
    
    public void execute(Database.BatchableContext bc, List<Project__c> projectList)
    {
        Map<String,Id> OrgWideaddressMap = new Map<String,Id>();
        UserRole SMUserRole = [Select ID,Name From UserRole where Name='S&M Head'];
        List<String> SMEmail = New List<String> ();
        Set<String> SMIds = New Set<String> ();
        List<User> SMUser = [Select Id,Name,Email From User Where UserRoleId=:SMuserRole.Id AND IsActive=True];
        for(User usr:SMUser){
            SMEmail.add(usr.Email);
            SMIds.add(usr.Id);
        }
        CustomNotificationType notificationType =  [SELECT Id, DeveloperName 
                                                    FROM CustomNotificationType 
                                                    WHERE DeveloperName='New_Opportunity'];
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();     
        
        String Name = '';
        EmailTemplate emailTemplate = [SELECT Id,Name, Subject, HtmlValue, Body,DeveloperName FROM EmailTemplate WHERE DeveloperName = : 'EOI_CA_Extend_Notification' LIMIT 1];
        
        
        List<OrgWideEmailAddress> ListOWA = [Select Id, Address From OrgWideEmailAddress];
        for(OrgWideEmailAddress OWA:ListOWA){
            OrgWideaddressMap.put(OWA.Address,OWA.Id);
        }
        for(Project__c thisProject: projectList){
            String Subject = emailTemplate.Subject;
            String htmlbody = emailTemplate.HtmlValue;
            String plainbody = emailTemplate.Body;
            String EOICA;
            String Link = URL.getSalesforceBaseUrl().toExternalForm()+'/'+thisProject.id;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(thisProject.Launch_EOI_Period_s_End_Date__c == system.today())
            {
                EOICA = 'EOI';
                Subject = Subject.replace('{EOI/CA}','EOI');
                Subject = Subject.replace('{projectName}',thisProject.Name);
                htmlbody = htmlbody.replace('{EOI_CA}','EOI');
                plainbody = plainbody.replace('{EOI_CA}','EOI');
                htmlbody = htmlbody.replace('{projectName}',thisProject.Name);
                plainbody = plainbody.replace('{projectName}',thisProject.Name);
                htmlbody = htmlbody.replace('{startDate}',string.valueof(thisProject.Launch_EOI_Period_s_Start_Date__c));
                plainbody = plainbody.replace('{startDate}',string.valueof(thisProject.Launch_EOI_Period_s_Start_Date__c));
                htmlbody = htmlbody.replace('{amount}',string.valueof(thisProject.Minimum_amount_for_EOI__c));
                plainbody = plainbody.replace('{amount}',string.valueof(thisProject.Minimum_amount_for_EOI__c));
                htmlbody = htmlbody.replace('{endDate}',string.valueof(thisProject.Launch_EOI_Period_s_End_Date__c));
                plainbody = plainbody.replace('{endDate}',string.valueof(thisProject.Launch_EOI_Period_s_End_Date__c));
            }
            if(thisProject.Launch_CA_Period_s_End_Date__c == system.today())
            {
                EOICA = 'CA';
                Subject = Subject.replace('{EOI/CA}','CA');
                Subject = Subject.replace('{projectName}',thisProject.Name);
                htmlbody = htmlbody.replace('{EOI_CA}','CA');
                plainbody = plainbody.replace('{EOI_CA}','CA');
                htmlbody = htmlbody.replace('{projectName}',thisProject.Name);
                plainbody = plainbody.replace('{projectName}',thisProject.Name);
                htmlbody = htmlbody.replace('{startDate}',string.valueof(thisProject.Launch_CA_Period_s_Start_Date__c));
                plainbody = plainbody.replace('{startDate}',string.valueof(thisProject.Launch_CA_Period_s_Start_Date__c));
                htmlbody = htmlbody.replace('{amount}',string.valueof(thisProject.Minimum_amount_for_CA__c));
                plainbody = plainbody.replace('{amount}',string.valueof(thisProject.Minimum_amount_for_CA__c));
                htmlbody = htmlbody.replace('{endDate}',string.valueof(thisProject.Launch_CA_Period_s_End_Date__c));
                plainbody = plainbody.replace('{endDate}',string.valueof(thisProject.Launch_CA_Period_s_End_Date__c));
            }
            htmlbody = htmlbody.replace('{Link}',Link);
            plainbody = plainbody.replace('{Link}',Link);
            
            mail.setToAddresses(SMEmail);
            mail.setPlainTextBody(plainbody);
            mail.setHtmlBody(htmlbody);
            mail.setSubject(Subject);
            mail.setOrgWideEmailAddressId(OrgWideaddressMap.get(thisProject.Project_Email__c));
            mail.setSaveAsActivity(false);
            emailMessages.add(mail);
            EmailMessage objEmailMessage = new EmailMessage();
            objEmailMessage.status = '3'; // email was sent
            objEmailMessage.RelatedToId = thisProject.id;
            objEmailMessage.fromName = 'Dynamix'; // from name
            objEmailMessage.FromAddress = thisProject.Project_Email__c;
            //objEmailMessage.ToAddress = string.valueOf(SMEmail);
            objEmailMessage.Subject = Subject;
            objEmailMessage.HtmlBody = htmlbody;
            //objEmailMessage.ToAddress = thisOpportunity.Account.PersonEmail;
            insertEmailMessageList.add(objEmailMessage);
            
            
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
           notification.setTitle(thisProject.Name +' EOI/CA expired by today');
            notification.setBody('Hi,' +
    '\nRefer below details for ' + thisProject.Name + ':-' +
    '\nLaunch Period Start Date: ' + String.valueOf(thisProject.Launch_CA_Period_s_Start_Date__c) +
    '\nLaunch Period End Date: ' + String.valueOf(thisProject.Launch_CA_Period_s_End_Date__c) +
    '\nMinimum Amount: ' + String.valueOf(thisProject.Minimum_amount_for_EOI__c) +
    '\n\nTake necessary action on an extension or closure confirmation of Launch Period End Date.');
           //notification.setBody('Hi,\n' +' Refer below details for '+thisProject.Name+' :-\n');
            // Set the notification type and target
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(thisProject.id);
            // Actually send the notification
            try {
                notification.send(SMIds);
            }
            catch (Exception e) {
                System.debug('Problem sending notification: ' + e.getMessage());
            }
        }
        
        
        
        if(!insertEmailMessageList.isEmpty())
        {
            insert insertEmailMessageList;   
        }
        
        
        if(!emailMessages.isempty())
        {
            try{
                List<Messaging.SendEmailResult> sendResults = Messaging.sendEmail(emailMessages);
            }
            Catch(Exception Ex)
            {
                system.debug('Error '+Ex.getMessage());
            }
        }
        
    }
    
    public void finish(Database.BatchableContext bc)
    {
    }
}