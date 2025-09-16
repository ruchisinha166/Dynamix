public class BatchforEOIWithoutBooking implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, Name, StageName, Loss_Reason__c,Project__r.Project_Email__c,EOI_CA__c,
                                         Reason_for_lost__c, AccountId, Account.FirstName, Account.LastName,Account.PersonEmail, 
                                         Project__c,Project__r.Project_Phone__c,Project__r.Name,EOI_CA_Number__c  
                                         FROM Opportunity 
                                         WHERE ((Project__r.Launch_EOI_Period_s_End_Date__c  =: System.today()
                                                 AND EOI_CA__c ='EOI')
                                                Or(Project__r.Launch_CA_Period_s_End_Date__c =: System.today()
                                                   AND EOI_CA__c ='CA') )AND EOI_CA__c != null AND EOI_CA__c != ''
                                         AND StageName != 'Closed Lost'
                                         AND StageName != 'Closed Won']);
    }
    
    public void execute(Database.BatchableContext bc, List<Opportunity> opportunityList){
        Set<Id> opportunityIdSet = New Set<Id>();
        Set<Id> propertyIdSet = New Set<Id>();
        Map<Id,Booking__c> mapOfBooking = New Map<Id,Booking__c>();
        Map<String,Id> OrgWideaddressMap = new Map<String,Id>();
        List<Opportunity> updateOpportunityList = New List<Opportunity>();
        List<Property__c> updatePropertyList = New List<Property__c>();
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();     
        
        String Name = '';
        EmailTemplate emailTemplate = [SELECT Id,Name, Subject, HtmlValue, Body,DeveloperName FROM EmailTemplate WHERE DeveloperName = : 'ForEOIWithoutBooking' LIMIT 1];
        
        for(Opportunity thisOpportunity : opportunityList){
            opportunityIdSet.add(thisOpportunity.id);
        }
        List<OrgWideEmailAddress> ListOWA = [Select Id, Address From OrgWideEmailAddress];
        for(OrgWideEmailAddress OWA:ListOWA){
            OrgWideaddressMap.put(OWA.Address,OWA.Id);
        }
        if(!opportunityIdSet.isEmpty())
        {
            List<Booking__c> bookingList = [SELECT Id, Name, Related_Opportunity__c 
                                            FROM Booking__c 
                                            WHERE Related_Opportunity__c IN: opportunityIdSet];
            if(!bookingList.isEmpty())
            {
                for(Booking__c thisBooking : bookingList)
                {
                    mapOfBooking.put(thisBooking.Related_Opportunity__c,thisBooking);
                    
                }
            }
            for(Opportunity thisOpportunity : opportunityList)
            {
                if(thisOpportunity.Account.FirstName != '' && thisOpportunity.Account.FirstName != null
                   && thisOpportunity.Account.LastName != '' && thisOpportunity.Account.LastName != null)
                {
                    Name = thisOpportunity.Account.FirstName + ' ' +thisOpportunity.Account.LastName;
                }
                else
                {
                    Name = thisOpportunity.Account.LastName; 
                }
                if(!mapOfBooking.containsKey(thisOpportunity.id))
                {
                    if(thisOpportunity.Account.PersonEmail != null && thisOpportunity.Account.PersonEmail != '')
                    {
                        String htmlbody = emailTemplate.HtmlValue;
                        String plainbody = emailTemplate.Body;
                        String subject = emailTemplate.Subject;
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        htmlbody = htmlbody.replace('{customerName}',Name);
                        plainbody = plainbody.replace('{customerName}',Name);
                         subject = subject.replace('{EOI/CA}',thisOpportunity.EOI_CA__c);
                        subject = subject.replace('{EOI/CA}',thisOpportunity.EOI_CA__c);
                          htmlbody = htmlbody.replace('{EOI_CA_Number}',thisOpportunity.EOI_CA_Number__c);
                        plainbody = plainbody.replace('{EOI_CA_Number}',thisOpportunity.EOI_CA_Number__c);
                        htmlbody = htmlbody.replace('{projectNumber}',thisOpportunity.Project__r.Project_Phone__c);
                        plainbody = plainbody.replace('{projectNumber}',thisOpportunity.Project__r.Project_Phone__c);
                        htmlbody = htmlbody.replace('{projectName}',thisOpportunity.Project__r.Name);
                        plainbody = plainbody.replace('{projectName}',thisOpportunity.Project__r.Name);
                        subject = subject.replace('{projectName}',thisOpportunity.Project__r.Name);
                        mail.setToAddresses(new List<string>{thisOpportunity.Account.PersonEmail});
                        mail.setPlainTextBody(plainbody);
                        mail.setHtmlBody(htmlbody);
                        mail.setSubject(subject);
                        mail.setOrgWideEmailAddressId(OrgWideaddressMap.get(thisOpportunity.Project__r.Project_Email__c));
                        mail.setSaveAsActivity(false);
                        emailMessages.add(mail);
                        EmailMessage objEmailMessage = new EmailMessage();
                        objEmailMessage.status = '3'; // email was sent
                        objEmailMessage.RelatedToId = thisOpportunity.id;
                        objEmailMessage.fromName = 'Dynamix'; // from name
                        objEmailMessage.Subject = 'Email sent to customer '+ thisOpportunity.EOI_CA__c +' without Booking';
                        objEmailMessage.HtmlBody = htmlbody;
                        objEmailMessage.ToAddress = thisOpportunity.Account.PersonEmail;
                        insertEmailMessageList.add(objEmailMessage);
                        
                    }
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
    }
    
    public void finish(Database.BatchableContext bc){
        
    }
}