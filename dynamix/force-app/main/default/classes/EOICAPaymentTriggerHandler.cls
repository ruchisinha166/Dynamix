public class EOICAPaymentTriggerHandler{
    
    public static void SendRejectedPaymentEmail(List<EOI_CA_Payment__c> eoiCAPaymentList,Map<id,EOI_CA_Payment__c> oldMap)
    {
        Set<Id> opportunityIdSet = New Set<Id>();
        for(EOI_CA_Payment__c thisPayment:eoiCAPaymentList)
        {          if(thisPayment.Payment_Status__c == 'Rejected' && thisPayment.Payment_Status__c !=  oldMap.get(thisPayment.id).Payment_Status__c)
        {
            opportunityIdSet.add(thisPayment.Opportunity__c);
        }
        }
        EmailTemplate emailTemplateforSM = [select Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                            from EmailTemplate 
                                            where DeveloperName = 'EOI_CA_Payment_Rejected' LIMIT 1];
        
        EmailTemplate emailTemplateforCustomer = [select Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                                  from EmailTemplate 
                                                  where DeveloperName = 'EOI_CA_Payment_Rejected_email_to_customer' LIMIT 1];
        Map<String,Id> OrgWideaddressMap = new Map<String,Id>();
        Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>();
        List<Opportunity> opportunityList= [SELECT id, Account.PersonEmail, EOI_CA_Number__c, Project__r.Name,
                                            Project__c,Sales_Manager__c,Sales_Manager__r.Email,Owner.email,
                                            Project__r.Project_Phone__c,owner.MobilePhone,owner.Phone,Project__r.Project_Email__c
                                            FROM Opportunity
                                            WHERE ID IN: opportunityIdSet];
        for(Opportunity thisOpportunity : opportunityList)
        {
            opportunityMap.put(thisOpportunity.id,thisOpportunity);
        }
        List<OrgWideEmailAddress> ListOWA = [Select Id, Address From OrgWideEmailAddress];
        for(OrgWideEmailAddress OWA:ListOWA){
            OrgWideaddressMap.put(OWA.Address,OWA.Id);
        }        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();     
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        String Link = URL.getSalesforceBaseUrl().toExternalForm()+'/';
        String externalLink;
        for(EOI_CA_Payment__c thisPayment:eoiCAPaymentList)
        {
            if(opportunityMap.containsKey(thisPayment.Opportunity__c))
            {
                Opportunity opportunity = opportunityMap.get(thisPayment.Opportunity__c);
                
                system.debug('thisPayment.Payment_Status__c  '+thisPayment.Payment_Status__c );
                system.debug('oldMap.get(thisPayment.id).Payment_Status__c  '+oldMap.get(thisPayment.id).Payment_Status__c );
                system.debug('opportunity.Account.PersonEmail  '+opportunity.Account.PersonEmail );
                
                if(thisPayment.Payment_Status__c == 'Rejected' && thisPayment.Payment_Status__c !=  oldMap.get(thisPayment.id).Payment_Status__c)
                {
                    if(emailTemplateforCustomer != null && opportunity.Account.PersonEmail != null && opportunity.Account.PersonEmail != ''){    
                        String htmlbody = emailTemplateforCustomer.HtmlValue;
                        String plainbody = emailTemplateforCustomer.Body;
                        String subject = emailTemplateforCustomer.Subject;
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        externalLink = Link+thispayment.id;
                        if(opportunity.EOI_CA_Number__c!= null && opportunity.EOI_CA_Number__c != '')
                        {
                            Subject = Subject.replace('{EOI/CA}', opportunity.EOI_CA_Number__c);
                            htmlBody = htmlBody.replace('{EOI/CA}', opportunity.EOI_CA_Number__c);
                            plainBody = plainBody.replace('{EOI/CA}', opportunity.EOI_CA_Number__c);
                            
                        }
                        htmlBody = htmlBody.replace('{amount}', String.valueof(thispayment.Amount__c));
                        if(opportunity.Project__c != null )
                        {
                            htmlBody = htmlBody.replace('{projectName}', opportunity.Project__r.Name);
                            plainBody = plainBody.replace('{projectName}', opportunity.Project__r.Name);
                            Subject = Subject.replace('{projectName}', opportunity.Project__r.Name);
                            
                        }
                        
                        if(thispayment.Primary_Applicant__c != null && thispayment.Primary_Applicant__c != '')
                        {
                            htmlBody = htmlBody.replace('{customername}', thispayment.Primary_Applicant__c);
                            plainBody = plainBody.replace('{customername}', thispayment.Primary_Applicant__c);
                            
                        }
                        if(thispayment.Reason_for_reject__c != null && thispayment.Reason_for_reject__c != '')
                        {
                            htmlBody = htmlBody.replace('{remarks}', thispayment.Reason_for_reject__c);
                            plainBody = plainBody.replace('{remarks}', thispayment.Reason_for_reject__c);
                            
                        }
                        else
                        {
                            htmlBody = htmlBody.replace('{remarks}', '');
                            plainBody = plainBody.replace('{remarks}','');
                        }
                        if(opportunity.owner.Phone != null && opportunity.owner.Phone != '')
                        {
                            plainBody = plainBody.replace('{rmNumber}', opportunity.owner.Phone);
                            htmlBody = htmlBody.replace('{rmNumber}', opportunity.owner.Phone);
                        }
                        else if(opportunity.owner.MobilePhone != null && opportunity.owner.MobilePhone != '')
                        {
                            plainBody = plainBody.replace('{rmNumber}', opportunity.owner.MobilePhone);
                            htmlBody = htmlBody.replace('{rmNumber}', opportunity.owner.MobilePhone);
                        }
                        else
                        {
                            plainBody = plainBody.replace('{rmNumber}', opportunity.Project__r.Project_Phone__c);
                            htmlBody = htmlBody.replace('{rmNumber}', opportunity.Project__r.Project_Phone__c);
                            
                        }
                        
                        plainBody = plainBody.replace('{amount}', String.valueof(thispayment.Amount__c));
                        
                        mail.setToAddresses(new List<string>{opportunity.Account.PersonEmail});
                        
                        mail.setPlainTextBody(plainbody);
                        mail.setHtmlBody(htmlbody);
                        mail.setSubject(subject);
                        mail.setOrgWideEmailAddressId(OrgWideaddressMap.get(opportunity.Project__r.Project_Email__c));
                        mail.setSaveAsActivity(false);
                        emailMessages.add(mail);
                        
                        EmailMessage objEmailMessage = new EmailMessage();
                        objEmailMessage.status = '3'; // email was sent
                        objEmailMessage.RelatedToId = thispayment.Opportunity__c;
                        objEmailMessage.fromName = 'Dynamix'; // from name
                        objEmailMessage.ToAddress = opportunity.Account.PersonEmail;
                        objEmailMessage.FromAddress = opportunity.Project__r.Project_Email__c;
                        objEmailMessage.Subject = 'Email sent to customer for rejection of Payment';
                        objEmailMessage.HtmlBody = htmlBody;
                        insertEmailMessageList.add(objEmailMessage);
                        
                    }
                    if(emailTemplateforSM != null){    
                        String htmlbody = emailTemplateforSM.HtmlValue;
                        String plainbody = emailTemplateforSM.Body;
                        String subject = emailTemplateforSM.Subject;
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        externalLink = Link+thispayment.id;
                        if(opportunity.EOI_CA_Number__c!= null && opportunity.EOI_CA_Number__c != '')
                        {
                            Subject = Subject.replace('{EOI/CA}', opportunity.EOI_CA_Number__c);
                            htmlBody = htmlBody.replace('{EOI/CA}', opportunity.EOI_CA_Number__c);
                            plainBody = plainBody.replace('{EOI/CA}', opportunity.EOI_CA_Number__c);
                            
                        }
                        htmlBody = htmlBody.replace('{amount}', String.valueof(thispayment.Amount__c));
                        if(opportunity.Project__c != null )
                        {
                            htmlBody = htmlBody.replace('{projectName}', opportunity.Project__r.Name);
                            plainBody = plainBody.replace('{projectName}', opportunity.Project__r.Name);
                            Subject = Subject.replace('{projectName}', opportunity.Project__r.Name);
                            
                        }
                        
                        if(thispayment.Primary_Applicant__c != null && thispayment.Primary_Applicant__c != '')
                        {
                            htmlBody = htmlBody.replace('{customername}', thispayment.Primary_Applicant__c);
                            plainBody = plainBody.replace('{customername}', thispayment.Primary_Applicant__c);
                            
                        }
                        if(thispayment.Reason_for_reject__c != null && thispayment.Reason_for_reject__c != '')
                        {
                            htmlBody = htmlBody.replace('{remarks}', thispayment.Reason_for_reject__c);
                            plainBody = plainBody.replace('{remarks}', thispayment.Reason_for_reject__c);
                            
                        }
                        else
                        {
                            htmlBody = htmlBody.replace('{remarks}', '');
                            plainBody = plainBody.replace('{remarks}','');
                        }
                        
                        htmlBody = htmlBody.replace('{Link}', externalLink);
                        plainBody = plainBody.replace('{amount}', String.valueof(thispayment.Amount__c));
                        plainBody = plainBody.replace('{Link}', externalLink);
                        String email;
                        if(opportunity.Sales_Manager__c != null)
                        {email =opportunity.Sales_Manager__r.email;
                            mail.setToAddresses(new List<string>{opportunity.Sales_Manager__r.email});
                        }
                        else
                        {email = opportunity.owner.email;
                            mail.setToAddresses(new List<string>{opportunity.owner.email});                            
                        }
                        
                        
                        mail.setPlainTextBody(plainbody);
                        mail.setHtmlBody(htmlbody);
                        mail.setSubject(subject);
                        mail.setOrgWideEmailAddressId(OrgWideaddressMap.get(opportunity.Project__r.Project_Email__c));
                        mail.setSaveAsActivity(false);
                        emailMessages.add(mail);
                        
                        EmailMessage objEmailMessage = new EmailMessage();
                        objEmailMessage.status = '3'; // email was sent
                        objEmailMessage.RelatedToId = thispayment.Opportunity__c;
                        objEmailMessage.fromName = 'Dynamix'; // from name
                        objEmailMessage.ToAddress = email;
                        objEmailMessage.FromAddress = Opportunity.Project__r.Project_Email__c;
                        objEmailMessage.Subject = 'Email sent to SM for rejection of Payment';
                        objEmailMessage.HtmlBody = htmlBody;
                        insertEmailMessageList.add(objEmailMessage);
                        
                    }
                }
            }
        }
        if(!insertEmailMessageList.isempty())
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