public class ChannelPartnerHandler {
    public Static Void sendSmsToCustomerForNewCP(List<Account> accountList){
        Id channelPartnerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        set<id> accountId = New set<id> ();
        Map<Id,List<String>> cPPMap = New Map<Id,List<String>>();
        List<String> emailList=new List<String>();
        Map<Id,user> userMap = New Map<Id,user>();
        set<id> userId = New set<id> ();
        List<String> emailCCList=new List<String>();
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        system.debug('insertEmailMessageList---------->'+insertEmailMessageList);
        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Rera_Number_Update_Notification' LIMIT 1];
        
        system.debug('emailTemplate---------->'+emailTemplate);
        OrgWideEmailAddress owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Default'];
        if(!accountList.isEmpty()){
            for(Account acc:accountList){
                if(acc.recordTypeId == channelPartnerRecordType)
                    system.debug('acc.recordTypeId---------->'+acc.recordTypeId);
                {
                    accountId.add(acc.id);
                    system.debug('accountId---------->'+accountId);
                    userId.add(acc.ownerId);
                    system.debug('userId---------->'+userId);
                }
            }
            
            if(!userId.isEmpty())
            {
                List<User> userList = [SELECT ID, Email, NAME FROM USER WHERE ID IN:userId];
                system.debug('userList---------->'+userList);
                for(User thisUser :userList)
                {
                    userMap.put(thisUser.id,thisUser);
                    system.debug('userMap---------->'+userMap);
                }
            }
            List<Channel_Partner_Project__c> cPPList = [SELECT ID, Channel_Partner__c, Project__c,Project__r.Site_Head__r.email FROM Channel_Partner_Project__c WHERE Channel_Partner__c IN:accountId];
            system.debug('cPPList---------->'+cPPList);
            for(Channel_Partner_Project__c thisCPP :cPPList)
            {
                if(cPPMap.containskey(thisCPP.id))
                {
                    List<string> emailMap = New List<string>();
                    emailMap = cPPMap.get(thisCPP.id);
                    system.debug('emailMap---------->'+emailMap);
                    emailMap.add(thisCPP.Project__r.Site_Head__r.email);
                    system.debug('emailMap---------->'+emailMap);
                    cPPMap.put(thisCPP.id,emailMap);
                    system.debug('cPPMap---------->'+cPPMap);
                }
                else
                {
                    List<string> emailMap = New List<string>();
                    emailMap.add(thisCPP.Project__r.Site_Head__r.email);
                    cPPMap.put(thisCPP.id,emailMap);
                }
            }
            //OrgWideEmailAddress owea = new OrgWideEmailAddress();
            communicat_o__Registered_Template__mdt regWhatEmailTempWithoutReraNumber = [Select Id,QualifiedApiName,communicat_o__External_Template_Id__c From communicat_o__Registered_Template__mdt Where QualifiedApiName=: 'Channel_Partner_Without_Rera_Number' Limit 1];
            
            EmailTemplate emailTemplateforSMS = [select Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                                 from EmailTemplate 
                                                 where Name = 'SMS for New CP Registration' LIMIT 1];
            SMS_Template_Id__mdt smsTemplateId = [SELECT id, Salesforce_Template_Id__c, 
                                                  External_Template_Id__c, SMS_Template__c
                                                      FROM SMS_Template_Id__mdt 
                                                     WHERE Salesforce_Template_Id__c=: emailTemplateforSMS.id];
            system.debug('emailTemplateforSMS---------->'+emailTemplateforSMS);
            EmailTemplate emailTemplateforWhatsapp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'New_CP_Registration_Through_Website' LIMIT 1];
            system.debug('emailTemplateforWhatsapp---------->'+emailTemplateforWhatsapp);
            communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,communicat_o__External_Template_Id__c From communicat_o__Registered_Template__mdt Where QualifiedApiName=: 'New_CP_Registration_Through_Website' Limit 1];
            system.debug('regWhatEmailTemp---------->'+regWhatEmailTemp);
            
            for(Account acc:accountList){
                if(acc.recordTypeId == channelPartnerRecordType)
                    
                {//SMS
                    List<string> arguments = New List<string>{acc.CP_Unique_Number1__c,'923678789'};
                    String recipientAddress = acc.Phone;
                    String recipientId = acc.id;
                    String relatedToId = acc.id;
                    String htmlBody = emailTemplateforSMS.Body;
                    system.debug('emailTemplateforSMS.HtmlValue'+emailTemplateforSMS.HtmlValue);
                    String plainBodyforSMS = smsTemplateId.SMS_Template__c;
                    plainBodyforSMS = plainBodyforSMS.stripHtmlTags();
                    //plainBodyforSMS = plainBodyforSMS.replace('{{cpUniqueId}}',acc.CP_Unique_Number1__c);
                    if (acc != null && acc.CP_Unique_Number1__c != null) {
                        plainBodyforSMS = plainBodyforSMS.replace('{{cpUniqueId}}', acc.CP_Unique_Number1__c);
                    } else {
                        System.debug('CP unique number is null');
                    }
                    
                    plainBodyforSMS = plainBodyforSMS.replace('{{contactNumber}}', '923678789');
                    if(!Test.isRunningTest()){
                        SendSMSUtility.sendSMSMethod(plainBodyforSMS,acc.Phone,'DYNAMX',smsTemplateId.External_Template_Id__c);
                    }
                    
                    if(recipientAddress!=null && recipientId!=null){
                        EmailMessage objEmailMessage = new EmailMessage();
                        objEmailMessage.status = '3'; // email was sent
                        objEmailMessage.RelatedToId = acc.id;
                        objEmailMessage.fromName = 'Dynamix'; // from name
                        objEmailMessage.Subject = 'SMS sent to CP for Registration';
                        objEmailMessage.HtmlBody = plainBodyforSMS;
                        insertEmailMessageList.add(objEmailMessage);
                    }
                    
                    //WHATSAPP
                    String emailTemplateId = String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
                    System.debug('emailTemplateId:'+emailTemplateId);
                    String htmlBodyforWhatsapp = emailTemplateforWhatsapp.HtmlValue;
                    String plainBodyforWhatsapp = emailTemplateforWhatsapp.Body;
                    //plainBodyforWhatsapp = plainBodyforWhatsapp.replace('{cpUniqueId}',acc.CP_Unique_Number1__c);
                    if (acc != null && acc.CP_Unique_Number1__c != null) {
                        plainBodyforWhatsapp = plainBodyforWhatsapp.replace('{cpUniqueId}', acc.CP_Unique_Number1__c);
                    } else {
                        System.debug('CP unique number is null');
                    }
                    if(!Test.isRunningTest()){
                        plainBodyforWhatsapp = plainBodyforWhatsapp.replace('{contactNumber}', '923678789');
                    }
                    if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                        if(!Test.isRunningTest()){ 
                            SendWhatsAppMessageUtility.SendWhatsappMessage(recipientAddress, recipientId,emailTemplateId, relatedToId ,regWhatEmailTemp.communicat_o__External_Template_Id__c ,arguments);
                            
                        }
                        EmailMessage objEmailMessage = new EmailMessage();
                        objEmailMessage.status = '3'; // email was sent
                        objEmailMessage.RelatedToId = acc.id;
                        objEmailMessage.fromName = 'Dynamix'; // from name
                        objEmailMessage.Subject = 'Whatsapp sent to CP for Registration';
                        objEmailMessage.HtmlBody = plainBodyforWhatsapp;
                        insertEmailMessageList.add(objEmailMessage);
                    }
                    if(emailTemplateforWhatsapp != null && acc.Email__c != null && acc.Email__c != ''){    
                        emailList.add(acc.Email__c);    
                        
                        EmailMessage objEmailMessage = new EmailMessage();
                        objEmailMessage.status = '3'; // email was sent
                        objEmailMessage.RelatedToId = acc.id;
                        objEmailMessage.fromName = 'Dynamix'; // from name
                        objEmailMessage.Subject = 'Email sent to CP for Registration';
                        objEmailMessage.HtmlBody = plainBodyforWhatsapp;
                        insertEmailMessageList.add(objEmailMessage);
                        SendEmailWithOrgWideAddress.SendEmail(emailTemplateforWhatsapp.Id, htmlBodyforWhatsapp, plainBodyforWhatsapp, emailList,null,owea.id);
                        
                    }
                    if(acc.RERA_Number__c == ''|| acc.RERA_Number__c ==null)
                        //Email Without Rera Number
                    {
                        if(cPPMap.containskey(acc.id))
                        {
                            emailCCList = cPPMap.get(acc.id);
                        }
                        emailCCList.add(userMap.get(acc.OwnerId).Email); 
                        //emailhtmlTemplate = emailhtmlTemplate.replace('{{CustomerName}}', thisAccount.Name);
                        String emailhtmlTemplate;
                        if(emailTemplate.HtmlValue != null && emailTemplate.HtmlValue !='')
                        { try
                        {
                            emailhtmlTemplate = emailTemplate.HtmlValue;
                            emailhtmlTemplate = emailhtmlTemplate.replace('{{CustomerName}}', acc.Name);
                        }
                         catch(Exception ex)
                         {
                             system.debug('Error');
                         }
                        }
                        
                        String emailPlainTemplate = emailTemplate.Body;
                        emailPlainTemplate = emailPlainTemplate.replace('{{CustomerName}}', acc.Name);
                        
                        if(emailTemplate != null && acc.Email__c != '')
                        {
                            SendEmailandBellNotificationUtility.SendEmail(emailTemplate.Id,emailhtmlTemplate,emailPlainTemplate,emailList,emailCCList);
                            EmailMessage objEmailMessage = new EmailMessage();
                            objEmailMessage.status = '3'; // email was sent
                            objEmailMessage.RelatedToId = acc.id;
                            objEmailMessage.fromName = 'Dynamix'; // from name
                            objEmailMessage.Subject = 'Email sent to CP for Rera Number Updation';
                            objEmailMessage.HtmlBody = emailPlainTemplate;
                            insertEmailMessageList.add(objEmailMessage);
                        }
                        //Whatsapp Without Rera Number
                        List<string> argumentsWithoutReraNumber = New List<string>{acc.Name};
                            // String recipientAddress = acc.Phone;
                            String emailTemplateWithoutReraNumberId = String.valueOf(regWhatEmailTempWithoutReraNumber.Id).substring(0, 15);
                        if(regWhatEmailTempWithoutReraNumber != null && recipientAddress != '')
                        {
                            if(!Test.isRunningTest()){
                                SendWhatsAppMessageUtility.SendWhatsappMessage(recipientAddress, null ,emailTemplateWithoutReraNumberId, acc.id ,regWhatEmailTempWithoutReraNumber.communicat_o__External_Template_Id__c ,argumentsWithoutReraNumber);
                            }
                            EmailMessage objEmailMessage = new EmailMessage();
                            objEmailMessage.status = '3'; // email was sent
                            objEmailMessage.RelatedToId = acc.id;
                            objEmailMessage.fromName = 'Dynamix'; // from name
                            objEmailMessage.Subject = 'Whatsapp sent to CP for Rera Number Updation';
                            objEmailMessage.HtmlBody = emailPlainTemplate;
                            insertEmailMessageList.add(objEmailMessage);
                        }
                    }
                    
                    
                    
                }
                
            }
            if(!insertEmailMessageList.isEmpty())
            {
                insertAuditTrail(insertEmailMessageList); 
            }
        }
    }
    public static void insertAuditTrail(List<EmailMessage> insertEmailMessageList)
    {
        if(!insertEmailMessageList.isEmpty())
        {
            insert insertEmailMessageList;
        }
    }
}