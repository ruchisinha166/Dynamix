public class SentSMSToCustomerForNewEnquiry {
    Public Static Boolean PreventRecursionOnSentSMSInCaseOfMissedCall = false;
    public static void SentSMSToCustomerForNewEnquiryMethod(List<Enquiry__C> enquiryList)
    {
        System.debug('Number of Queries used in SentSMSToCustomerForNewEnquiryMethod: ' + Limits.getQueries());
        Set<String> projectIdSet = New Set<String> ();
        Map<String,Project__c> mapOfProject = New Map<String,Project__c> ();
        for(Enquiry__C enquiryRecord : enquiryList){
            if( enquiryRecord.Primary_Mobile_Number__c != null && enquiryRecord.ProjectName__c != null && enquiryRecord.Send_SMS__c == true)
            {
                projectIdSet.add(enquiryRecord.Project__c);
            }
        }
        System.debug('Number of Queries used in SentSMSToCustomerForNewEnquiryMethod: ' + Limits.getQueries());
        List<Project__c> projectList = [SELECT id, name, Project_Link__c FROM Project__c WHERE ID IN: projectIdSet];
        for(Project__c projectRecord: projectList)
        {
            mapOfProject.put(projectRecord.id,projectRecord);
        }
        // For sending SMS 
        List<EmailMessage> insertEmailMessageList = new List<EmailMessage>(); 
        EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'Send New Lead SMS To Customer' LIMIT 1];
        for(Enquiry__C enquiryRecord : enquiryList){
            if(smsEmailTemp!=null && enquiryRecord.Primary_Mobile_Number__c != null && enquiryRecord.ProjectName__c != null && enquiryRecord.Send_SMS__c == true){
                if(mapOfProject.containsKey(enquiryRecord.Project__c)){
                    Project__c project = mapOfProject.get(enquiryRecord.Project__c);
                    String templateBody=smsEmailTemp.HtmlValue;
                    templateBody = templateBody.stripHtmlTags();
                    String mobileNumber = enquiryRecord.Primary_Mobile_Number__c;
                    templateBody = templateBody.replace('{{Enquiry__c.ProjectName__c}}',enquiryRecord.ProjectName__c);
                    templateBody = templateBody.replace('{{Enquiry__C.ProjectURL}}',project.Project_Link__c);
                    if(!test.isrunningtest())
                        SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
                    EmailMessage objEmailMessage = new EmailMessage();
                    objEmailMessage.status = '3'; // email was sent
                    objEmailMessage.RelatedToId = enquiryRecord.id;
                    objEmailMessage.fromName = 'Dynamix'; // from name
                    objEmailMessage.Subject = 'SMS sent to customer for enquiry Creation';
                    objEmailMessage.HtmlBody = templateBody;
                    insertEmailMessageList.add(objEmailMessage);
                }
            }
            
        }
        if(!insertEmailMessageList.isEmpty())
        {
            insert insertEmailMessageList;
        }
    }
    
    public static void SentSMSToCustomerForNewEnquiryAssignwithProjectMethod(List<Enquiry__C> enquiryList, Map<id,Enquiry__C> oldEnquiryMap)
    { 
        try
        {
            Set<String> projectIdSet = New Set<String> ();
            Map<String,Project__c> mapOfProject = New Map<String,Project__c> ();
            for(Enquiry__C enquiryRecord : enquiryList){
                if( enquiryRecord.Primary_Mobile_Number__c != null && enquiryRecord.ProjectName__c != null && enquiryRecord.Send_SMS__c == true)
                {
                    projectIdSet.add(enquiryRecord.Project__c);
                }
            }
            System.debug('Number of Queries used in SentSMSToCustomerForNewEnquiryMethod: ' + Limits.getQueries());
            List<Project__c> projectList = [SELECT id, name, Project_Link__c FROM Project__c WHERE ID IN: projectIdSet];
            for(Project__c projectRecord: projectList)
            {
                mapOfProject.put(projectRecord.id,projectRecord);
            }
            List<Enquiry__C> updateEnquiryList = New  List<Enquiry__C>();
            // For sending SMS 
            List<EmailMessage> insertEmailMessageList = new List<EmailMessage>();
            EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'Send New Lead SMS To Customer' LIMIT 1];
            for(Enquiry__C enquiryRecord : enquiryList){
                if(smsEmailTemp!=null && enquiryRecord.Primary_Mobile_Number__c != null && enquiryRecord.ProjectName__c != null && oldEnquiryMap.get(enquiryRecord.id).Project__c != enquiryRecord.Project__c && enquiryRecord.Send_SMS__c == true && mapOfProject.containsKey(enquiryRecord.Project__c)){
                    String templateBody=smsEmailTemp.HtmlValue;
                    templateBody=templateBody.stripHtmlTags();
                    String mobileNumber=enquiryRecord.Primary_Mobile_Number__c;
                    if(!test.isrunningtest())
                        templateBody = templateBody.replace('{{Enquiry__c.ProjectName__c}}',enquiryRecord.ProjectName__c);
                    templateBody = templateBody.replace('{{Enquiry__C.ProjectURL}}', mapOfProject.get(enquiryRecord.Project__c).Project_Link__c );
                    if(!test.isRunningTest())
                    {
                        SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
                    }
                    EmailMessage objEmailMessage = new EmailMessage();
                    objEmailMessage.status = '3'; // email was sent
                    objEmailMessage.RelatedToId = enquiryRecord.id;
                    objEmailMessage.fromName = 'Dynamix'; // from name
                    objEmailMessage.Subject = 'SMS sent to customer for enquiry Creation';
                    objEmailMessage.HtmlBody = templateBody;
                    insertEmailMessageList.add(objEmailMessage);
                }
                
            }
            if(!insertEmailMessageList.isEmpty())
            {
                insert insertEmailMessageList;
            }
            
        }
        catch(exception ex)
        {
            system.debug('Error'+ ex.getMessage());
        }
    }
    
    public static void SentSMSInCaseOfMissedCall(List<Task> taskList)
    {
        List<Enquiry__c> updateEnquiryList = New List <Enquiry__c>();
        set<String> enquiryId = New  set<String>();
        for(Task thisTask : taskList){
            if(thisTask.WhatId != null){
                String objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
                if(objectName == 'Enquiry__c')
                {
                    enquiryId.add(thisTask.WhatId);
                }
            }
        }
        System.debug('Number of Queries used in SentSMSToCustomerForNewEnquiryMethod: ' + Limits.getQueries());
        system.debug('enquiryId--'+enquiryId);
        List<Enquiry__c> enquiryList  = New List<Enquiry__c>();
        if(!enquiryId.isEmpty())
        {
            enquiryList  = [SELECT id, Contact_Person__c, Stage__c, Primary_Mobile_Number__c,Sent_SMS_for_Incoming_Call__c,
                            Site_Visit_Scheduled_Date__c, Project_Name__c,Project__r.Project_Phone__c,
                            Project__r.Project_Link__c
                            FROM Enquiry__c 
                            WHERE id IN :enquiryId 
                            //   AND Stage__c = 'Site Visit Scheduled'
                           ];
            
            System.debug('Number of Queries used in SentSMSToCustomerForNewEnquiryMethod: ' + Limits.getQueries());        
            system.debug('enquiryList--'+enquiryList);
            system.debug('After query');
            
            Map<Id,Enquiry__c> mapOfEnquiryIdToGetStage =  New  Map<Id,Enquiry__c>();
            if(!enquiryList.isEmpty()){
                for(Enquiry__c thisEnquiry :enquiryList){
                    mapOfEnquiryIdToGetStage.put(thisEnquiry.id,thisEnquiry);
                }
            }
            List<EmailMessage> insertEmailMessageList = new List<EmailMessage>();
            // For sending SMS 
            SMS_Template_Id__mdt smsTemplateForConnectedCalls = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='SMS For Connected Call' Limit 1];
            EmailTemplate smsEmailTempForConnectedCalls = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS For Connected Call' LIMIT 1];
            SMS_Template_Id__mdt smsTemplateForClientMissedTheCall = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='SMS Sent Customer Missed the Call' Limit 1];
            EmailTemplate smsEmailTemp = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS For a Missed Call form an Existing Enquiry' LIMIT 1];
            EmailTemplate smsEmailTempForClientMissedTheCall = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS Sent Customer Missed the Call' LIMIT 1];
            //EmailTemplate smsEmailTempForConnectedCall = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS For Connected Call' LIMIT 1];
            
            for(Task thisTask : taskList){
                if(thisTask.WhatId != null && thisTask.Subject.contains('Incoming Call'))
                {
                    String objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
                    
                    if(objectName == 'Enquiry__c' &&  mapOfEnquiryIdToGetStage.containsKey(thisTask.WhatId))
                    {
                        Enquiry__c enquiryRecord =  mapOfEnquiryIdToGetStage.get(thisTask.WhatId); 
                        
                        if(smsTemplateForConnectedCalls !=null && smsEmailTempForConnectedCalls !=null && enquiryRecord.Primary_Mobile_Number__c != null && enquiryRecord.Sent_SMS_for_Incoming_Call__c != True){
                            try{
                                String templateBody=smsEmailTempForConnectedCalls.HtmlValue;
                                templateBody=templateBody.stripHtmlTags();
                                templateBody = templateBody.replace('{{enquiryRecord.ProjectName__c}}', enquiryRecord.ProjectName__c);
                                templateBody = templateBody.replace('{{Enquiry__C.ProjectURL}}',enquiryRecord.Project__r.Project_Link__c);
                                String mobileNumber=enquiryRecord.Primary_Mobile_Number__c;
                                if(!test.isrunningtest()){
                                    //SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
                                    SendSMSUtility.sendSMSMethod(templateBody,mobileNumber,'DYNAMX',smsTemplateForConnectedCalls.External_Template_Id__c);
                                    
                                }
                                EmailMessage objEmailMessage = new EmailMessage();
                                objEmailMessage.status = '3'; // email was sent
                                objEmailMessage.RelatedToId = enquiryRecord.id;
                                objEmailMessage.fromName = 'Dynamix'; // from name
                                objEmailMessage.Subject = 'SMS sent to customer when call connected';
                                objEmailMessage.HtmlBody = templateBody;
                                insertEmailMessageList.add(objEmailMessage);
                                enquiryRecord.Sent_SMS_for_Incoming_Call__c = True;
                                updateEnquiryList.add(enquiryRecord);
                            }
                            catch(Exception ex)
                            {
                                system.debug('Error'+ex.getMessage());
                            }
                        }
                    }
                }
                
                //EmailTemplate smsEmailTempForClientMissedTheCall = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS Sent Customer Missed the Call' LIMIT 1];
                system.debug('Subject'+thisTask.Subject);
                system.debug('Exotel_CTI__Call_Direction__c'+thisTask.Exotel_CTI__Call_Direction__c);
                system.debug('Exotel_CTI__Leg2_Status__c----'+thisTask.Exotel_CTI__Leg2_Status__c);
                if(thisTask.WhatId != null && thisTask.Subject.contains('Outgoing Call') && thisTask.Exotel_CTI__Call_Direction__c =='Outbound' && (thisTask.Exotel_CTI__Leg2_Status__c =='canceled' || thisTask.Exotel_CTI__Call_Duration__c=='00:00:00'))
                {
                    system.debug('thisTask.Subject'+thisTask.Subject);
                    system.debug('thisTask.Exotel_CTI__Call_Direction__c'+thisTask.Exotel_CTI__Call_Direction__c);
                    String objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
                    if(objectName == 'Enquiry__c' &&  mapOfEnquiryIdToGetStage.containsKey(thisTask.WhatId))
                    {
                        system.debug('hello');
                        Enquiry__c enquiryRecord =  mapOfEnquiryIdToGetStage.get(thisTask.WhatId);
                        //EmailTemplate smsEmailTempForConnectedCall = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name = 'SMS For Connected Call' LIMIT 1];
                        try{if(smsEmailTempForConnectedCalls !=null && smsTemplateForClientMissedTheCall != null && enquiryRecord.Primary_Mobile_Number__c != null){
                            String templateBody=smsEmailTempForClientMissedTheCall.HtmlValue;
                            templateBody=templateBody.stripHtmlTags();
                            templateBody = templateBody.replace('{{enquiryRecord.ProjectName__c}}', enquiryRecord.ProjectName__c);
                            templateBody = templateBody.replace('{{enquiry.Telecaller}}',enquiryRecord.Project__r.Project_Phone__c);
                            String mobileNumber=enquiryRecord.Primary_Mobile_Number__c;
                            if(!test.isrunningtest())
                                // SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
                                SendSMSUtility.sendSMSMethod(templateBody,'9728185517','DYNAMX',smsTemplateForClientMissedTheCall.External_Template_Id__c);
                            
                            EmailMessage objEmailMessage = new EmailMessage();
                            objEmailMessage.status = '3'; // email was sent
                            objEmailMessage.RelatedToId = enquiryRecord.id;
                            objEmailMessage.fromName = 'Dynamix'; // from name
                            objEmailMessage.Subject = 'SMS sent to customer when customer missed the call';
                            objEmailMessage.HtmlBody = templateBody;
                            insertEmailMessageList.add(objEmailMessage);
                        }
                           }
                        catch(Exception ex)
                        {
                            system.debug('Error'+ex.getMessage());
                        }
                    }
                }
            }
            if(!insertEmailMessageList.isEmpty())
            {
                insert insertEmailMessageList;
            }
            if(!updateEnquiryList.isEmpty())
            {
                update updateEnquiryList;
            }
        }
    }
}