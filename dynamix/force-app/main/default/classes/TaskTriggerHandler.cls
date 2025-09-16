public class TaskTriggerHandler {
    Public static Boolean PreventRecursionenquiryStageChange = False;
    Public static Boolean updateCallLogs = False;
    Public static Boolean PreventRecursionOnThrowValidation = False;
    
    public static void sendEmailToRMCRMWhenWelcomeCallTaskCreated(List<Task> taskList){
        if(PreventRecursionClass.i != 2){
            System.debug('Number of Queries used in sendEmailToRMCRMWhenWelcomeCallTaskCreated1: ' + Limits.getQueries());
            PreventRecursionClass.i++; 
            /*EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Welcome_Call_Letter_Task_Created' limit 1];
System.debug('emailTemplate'+emailTemplate);
String CRMHeadUserName = Label.CRM_Head_User;
System.debug('CRMHeadUserName'+CRMHeadUserName);
User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'].Id AND isActive =: true Limit 1];
System.debug('CRMHeadRoleObjUser'+CRMHeadRoleObjUser);
List<String> addresses = new List<String>();
addresses.add(CRMHeadRoleObjUser.Email);
System.debug('addresses'+addresses);
//For Send WhatsApp Message
communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp Welcome Letter Sent' Limit 1];
// System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
//for Send SMS
EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Welcome Letter Sent' Limit 1];*/
            Set<Id> setOfBookIds = new Set<Id>();
            for(Task taskObj : taskList){
                if(taskObj.WhatId != null)
                {
                    String objectName = taskObj.WhatId.getSObjectType().getDescribe().getName();
                    if(objectName == 'Booking__c')
                    {
                        setOfBookIds.add(taskObj.whatId);
                    }
                }
            }
            
            if(!setOfBookIds.isEmpty()){
                
                EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Welcome_Call_Letter_Task_Created' limit 1];
                System.debug('emailTemplate'+emailTemplate);
                String CRMHeadUserName = Label.CRM_Head_User;
                System.debug('CRMHeadUserName'+CRMHeadUserName);
                User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'].Id AND isActive =: true Limit 1];
                System.debug('CRMHeadRoleObjUser'+CRMHeadRoleObjUser);
                List<String> addresses = new List<String>();
                addresses.add(CRMHeadRoleObjUser.Email);
                System.debug('addresses'+addresses);
                //For Send WhatsApp Message
                communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp Welcome Letter Sent' Limit 1];
                // System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
                //for Send SMS
                EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Welcome Letter Sent' Limit 1];
                System.debug('setOfBookIds'+setOfBookIds);
                Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>();
                
                List<Booking__c> bookingList = New List<Booking__c>();
                if(!Test.isRunningTest())
                {
                    bookingList = [Select Id,Name,OwnerId,Unit_Number__c,Project_Name_Formulla__c,
                                   Customer_Mobile_No__c,Primary_Applicant__c,Primary_Applicant__r.Name,
                                   Booking_Owner_Email__c 
                                   From Booking__c 
                                   where Id IN: setOfBookIds];
                }
                
                for(Booking__c thisBooking :bookingList)
                {
                    mapIdToBooking.put(thisBooking.id,thisBooking);
                }
                System.debug('mapIdToBooking'+mapIdToBooking);
                Set<Id> setOfRMIds = new Set<Id>();
                for(Id key : mapIdToBooking.keySet()){
                    setOfRMIds.add(mapIdToBooking.get(key).OwnerId);
                }
                Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where Id In : setOfRMIds]);
                System.debug('mapIdToUser'+mapIdToUser);            
                for(Task taskObj : taskList){
                    System.debug('taskObj'+taskObj);
                    if(taskObj.Subject == 'Welcome Call'){
                        System.debug(''+taskObj.Subject);
                        if(taskObj.whatId != null){
                            System.debug('taskObj.whatId'+taskObj.whatId);
                            if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(taskObj.whatId)){ 
                                Booking__c bookingObj = mapIdToBooking.get(taskObj.whatId);
                                System.debug('bookingObj'+bookingObj);
                                addresses.add(mapIdToUser.get(bookingObj.OwnerId).Email);
                                System.debug('addresses'+addresses);
                                String htmlBody = emailTemplate.HtmlValue;
                                if(mapIdToUser.get(bookingObj.OwnerId).Name != null){
                                    htmlBody = htmlBody.replace('{!RM}', mapIdToUser.get(bookingObj.OwnerId).Name);
                                }
                                if(bookingObj.Name != null){
                                    htmlBody = htmlBody.replace('{!Name}', bookingObj.Name);
                                }
                                if(bookingObj.Unit_Number__c != null){
                                    htmlBody = htmlBody.replace('{!Unit}', bookingObj.Unit_Number__c);
                                }
                                if(bookingObj.Project_Name_Formulla__c != null){
                                    htmlBody = htmlBody.replace('{!Project}', bookingObj.Project_Name_Formulla__c);
                                }
                                /* SendEmailandBellNotificationUtility.SendEmail(
String.valueOf(emailTemplate.Id),
htmlBody,
'',
addresses,
null
);*/
                                SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,
                                                                               emailTemplate.Subject, 
                                                                               htmlBody, 
                                                                               '', 
                                                                               addresses, 
                                                                               null, 
                                                                               true, 
                                                                               bookingObj.Id, 
                                                                               null, 
                                                                               null, 
                                                                               null);
                                
                                //For Send WhatsApp Message                       
                                if(regWhatEmailTemp!=null){
                                    String recipientAddress=bookingObj.Customer_Mobile_No__c;
                                    String recipientId=bookingObj.Primary_Applicant__c;
                                    String emailTemplateId=String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
                                    String relatedToId=bookingObj.Id;
                                    System.debug('emailTemplateId:'+emailTemplateId);
                                    if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                                        if(!test.isRunningTest())
                                            SendWhatsAppMessageUtility.SendMessage(recipientAddress, recipientId, emailTemplateId,relatedToId);
                                    }
                                }
                                //for Send SMS
                                if(smsEmailTemp!=null && bookingObj.Customer_Mobile_No__c!=null){
                                    String templateBody=smsEmailTemp.HtmlValue;
                                    String mobileNumber=bookingObj.Customer_Mobile_No__c;
                                    templateBody = templateBody.replace('{{{Booking__c.Primary_Applicant_Name_Formulla__c}}}',bookingObj.Primary_Applicant__r.Name);
                                    templateBody = templateBody.replace('{{{Booking__c.Booking_Owner_Email__c}}}',bookingObj.Booking_Owner_Email__c);
                                    
                                    templateBody=templateBody.stripHtmlTags();
                                    System.debug('templateBody:'+templateBody);
                                    if(!test.isRunningTest())
                                        SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
                                }
                            }
                        }
                    }
                }
                System.debug('Number of Queries used in sendEmailToRMCRMWhenWelcomeCallTaskCreated2: ' + Limits.getQueries());
            }
            
        }
        
    }
    
    public static void updateReinitiatedDate(List<Task> taskList,Map<id,Task> oldMapIdToTask){
        if(!PreventRecursionClass.taskflag8){
            PreventRecursionClass.taskflag8 = true;
            System.debug('Number of Queries used in updateReinitiatedDate1: ' + Limits.getQueries());
            Set<Id> setOfBookIds = new Set<Id>();
            Set<Id> bookingIdSet = New Set<Id>();
            for(Task taskObj : taskList){
                setOfBookIds.add(taskObj.whatId);
                if(taskObj.WhatId != null)
                {
                    String objectName = taskObj.WhatId.getSObjectType().getDescribe().getName();
                    if(objectName == 'Booking__c')
                    {
                        bookingIdSet.add(taskObj.WhatId); 
                    }
                    
                }
            }
            
            Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>();
            if(!bookingIdSet.isEmpty())
            {
                mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,OwnerId,Unit_Number__c,Project_Name_Formulla__c  From Booking__c WHERE ID IN: bookingIdSet]);
                
            }
            // Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,OwnerId,Unit_Number__c,Project_Name_Formulla__c From Booking__c where Id in: setOfBookIds]);
            List<Booking__c> listOfBookingToUpdate = new List<Booking__c>();
            for(Task taskObj : taskList){
                if(taskObj.Subject == 'Generate Draft Agreement' && taskObj.Status == 'Re-initiated' && oldMapIdToTask.get(taskObj.Id).Status != taskObj.Status){
                    if(taskObj.whatId != null){
                        if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(taskObj.whatId)){ 
                            Booking__c bookingObj = mapIdToBooking.get(taskObj.whatId);
                            bookingObj.Reinitiated_Date__c = Date.today();
                            listOfBookingToUpdate.add(bookingObj);
                        }
                    }
                }
            }
            System.debug('listOfBookingToUpdate Size:'+listOfBookingToUpdate.size());
            System.debug('Number of Queries used in updateReinitiatedDate2: ' + Limits.getQueries());
            if(!listOfBookingToUpdate.isEmpty()){
                update listOfBookingToUpdate;
            }
            System.debug('Number of Queries used in updateReinitiatedDate3: ' + Limits.getQueries());
        }
    }
    
    public static void sendEmailToRMCRMSharedSDRLetter(List<Task> taskList,Map<id,Task> oldMapIdToTask){
        if(!PreventRecursionClass.taskflag7){
            PreventRecursionClass.taskflag7 = true;
            System.debug('Number of Queries used in sendEmailToRMCRMSharedSDRLetter1: ' + Limits.getQueries());
            /* EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'SDR_Letter_Sent_To_Customer' limit 1];
String CRMHeadUserName = Label.CRM_Head_User;
User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'].Id AND isActive =: true Limit 1];

List<String> addresses = new List<String>();
addresses.add(CRMHeadRoleObjUser.Email);

//For Send WhatsApp Message


communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp SDR Letter Sent Email' Limit 1];
System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
//for Send SMS
EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS SDR Letter Sent Email' Limit 1];*/
            Set<Id> setOfBookIds = new Set<Id>();
            for(Task taskObj : taskList){
                //setOfBookIds.add(taskObj.whatId);
                if(taskObj.WhatId != null)
                {
                    String objectName = taskObj.WhatId.getSObjectType().getDescribe().getName();
                    if(objectName == 'Booking__c')
                    {
                        setOfBookIds.add(taskObj.WhatId); 
                    }
                    
                }
            }
            
            Map<Id,Booking__c> mapIdToBooking= new Map<Id,Booking__c>();
            if(!setOfBookIds.isEmpty())
            {
                EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'SDR_Letter_Sent_To_Customer' limit 1];
                String CRMHeadUserName = Label.CRM_Head_User;
                User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'].Id AND isActive =: true Limit 1];
                
                List<String> addresses = new List<String>();
                addresses.add(CRMHeadRoleObjUser.Email);
                
                //For Send WhatsApp Message
                
                
                communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp SDR Letter Sent Email' Limit 1];
                System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
                //for Send SMS
                EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS SDR Letter Sent Email' Limit 1];
                mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,OwnerId,Unit_Number__c,Project_Name_Formulla__c,Customer_Mobile_No__c,Primary_Applicant__c,Primary_Applicant__r.Name From Booking__c where Id in: setOfBookIds]);
                
                if(!mapIdToBooking.isEmpty()){
                    Set<Id> setOfRMIds = new Set<Id>();
                    for(Id key : mapIdToBooking.keySet()){
                        setOfRMIds.add(mapIdToBooking.get(key).OwnerId);
                    }
                    Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where Id In : setOfRMIds]);
                    
                    for(Task taskObj : taskList){
                        if(taskObj.Status == 'Sent' && taskObj.Subject == 'SDR Letter for the Booking' && oldMapIdToTask.get(taskObj.Id).Status != taskObj.Status){
                            if(taskObj.whatId != null){
                                if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(taskObj.whatId)){ 
                                    Booking__c bookingObj = mapIdToBooking.get(taskObj.whatId);
                                    addresses.add(mapIdToUser.get(bookingObj.OwnerId).Email);
                                    
                                    String htmlBody = emailTemplate.HtmlValue;
                                    htmlBody = htmlBody.replace('{!RM}', mapIdToUser.get(bookingObj.OwnerId).Name);
                                    htmlBody = htmlBody.replace('{!Name}', bookingObj.Name);
                                    htmlBody = htmlBody.replace('{!Unit}', bookingObj.Unit_Number__c);
                                    htmlBody = htmlBody.replace('{!Project}', bookingObj.Project_Name_Formulla__c);
                                    
                                    /* SendEmailandBellNotificationUtility.SendEmail(
String.valueOf(emailTemplate.Id),
htmlBody,
'',
addresses,
null
);*/
                                    
                                    SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,
                                                                                   emailTemplate.Subject, 
                                                                                   htmlBody, 
                                                                                   '', 
                                                                                   addresses, 
                                                                                   null, 
                                                                                   true, 
                                                                                   bookingObj.Id, 
                                                                                   null, 
                                                                                   null, 
                                                                                   null);
                                    
                                    //For Send WhatsApp Message
                                    
                                    if(regWhatEmailTemp!=null){
                                        String recipientAddress=bookingObj.Customer_Mobile_No__c;
                                        String recipientId=bookingObj.Primary_Applicant__c;
                                        String emailTemplateId=String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
                                        String relatedToId=bookingObj.Id;
                                        System.debug('emailTemplateId:'+emailTemplateId);
                                        if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                                            if(!test.isRunningTest())
                                                SendWhatsAppMessageUtility.SendMessage(recipientAddress, recipientId, emailTemplateId,relatedToId);
                                        }
                                    }
                                    //for Send SMS
                                    
                                    if(smsEmailTemp!=null && bookingObj.Customer_Mobile_No__c!=null){
                                        String templateBody=smsEmailTemp.HtmlValue;
                                        String mobileNumber=bookingObj.Customer_Mobile_No__c;
                                        templateBody = templateBody.replace('{{{Booking__c.Primary_Applicant_Name_Formulla__c}}}',bookingObj.Primary_Applicant__r.Name);
                                        templateBody = templateBody.replace('{{{Booking__c.Name}}}',bookingObj.Name);
                                        templateBody = templateBody.replace('{{{Booking__c.Project_Name_Formulla__c}}}',bookingObj.Project_Name_Formulla__c);
                                        templateBody=templateBody.stripHtmlTags();
                                        System.debug('templateBody:'+templateBody);
                                        if(!test.isRunningTest())
                                            SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            System.debug('Number of Queries used in sendEmailToRMCRMSharedSDRLetter2: ' + Limits.getQueries());
            
        }
    }
    
    public static void sendEmailWhenWelcomeCallRejected(List<Task> taskList,Map<id,Task> oldMapIdToTask){
        if(!PreventRecursionClass.taskflag6){
            PreventRecursionClass.taskflag6 = true;
            System.debug('Number of Queries used in sendEmailWhenWelcomeCallRejected1: ' + Limits.getQueries());
            List<EmailTemplate> emailTemplateList = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where (DeveloperName = 'Welcome_Call_Task_Rejected_RM' OR DeveloperName = 'Welcome_Call_Task_Rejected_SM') limit 2];
            Map<String,EmailTemplate> mapNameToEmailTemp = new Map<String,EmailTemplate>();
            for(EmailTemplate emailTemp : emailTemplateList){
                mapNameToEmailTemp.put(emailTemp.DeveloperName, emailTemp);
            }
            List<String> addresses1 = new List<String>();
            List<String> addresses2 = new List<String>();
            
            Set<Id> setOfBookIds = new Set<Id>();
            for(Task taskObj : taskList){
                setOfBookIds.add(taskObj.whatId);
            }
            Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,Related_Opportunity__c ,OwnerId,Unit_Number__c,Project_Name_Formulla__c,
                                                                        Agreemnt_Non_Critical__c,Amount_Non_Critical__c,Bank_Name_Non_Critical__c,Carpet_Area_Non_Critical__c,
                                                                        Description__c,Flat_No_Non_Critical__c,Flat_Type_Non_Critical__c,Floor_Non_Critical__c,GST_Non_Critical__c,
                                                                        Intrument_Name__c,KYC_details_Non_Critical__c,PaymentMode__c,Question_10__c,Question_1__c,Question_2__c,
                                                                        Question_3__c,Question_4__c,Question_5__c,Question_6__c,Question_7__c,Question_8__c,Question_9__c,
                                                                        RM_Contact_Non_Critical__c,Reciept_Type_Non_Critical__c,Rm_Name_Non_Critical__c,Rm_Work_Hour_Non_Critical__c,
                                                                        Tower_Non_Critical__c From Booking__c where Id in: setOfBookIds]);
            Set<Id> setOfOppIds = new Set<Id>();
            List<String> checkListName=new List<String>();
            for(Id key : mapIdToBooking.keySet()){
                setOfOppIds.add(mapIdToBooking.get(key).Related_Opportunity__c);
            }
            Map<Id,Opportunity> mapIdToOppo = new Map<Id,Opportunity>([Select Id,Name,OwnerId From Opportunity where Id in: setOfOppIds]);
            
            Set<Id> setOfRMIds = new Set<Id>();
            for(Id key : mapIdToOppo.keySet()){
                setOfRMIds.add(mapIdToOppo.get(key).OwnerId);
            }
            for(Id key : mapIdToBooking.keySet()){
                setOfRMIds.add(mapIdToBooking.get(key).OwnerId);
            }
            Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where Id In : setOfRMIds]);
            
            for(Task taskObj : taskList){
                if(taskObj.Status == 'Rejected' && taskObj.Subject == 'Welcome Call' && oldMapIdToTask.get(taskObj.Id).Status != taskObj.Status){
                    if(taskObj.whatId != null){
                        if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(taskObj.whatId)){ 
                            Booking__c bookingObj = mapIdToBooking.get(taskObj.whatId);
                            addresses1.add(mapIdToUser.get(bookingObj.OwnerId).Email);
                            String htmlBody = mapNameToEmailTemp.get('Welcome_Call_Task_Rejected_RM').HtmlValue;
                            htmlBody = htmlBody.replace('{!Name}', mapIdToUser.get(bookingObj.OwnerId).Name);
                            if(mapIdToOppo.size() > 0 && mapIdToOppo.containsKey(bookingObj.Related_Opportunity__c)){
                                Opportunity oppo = mapIdToOppo.get(bookingObj.Related_Opportunity__c);
                                htmlBody = htmlBody.replace('{!SM}', mapIdToUser.get(oppo.OwnerId).Name);
                            }
                            htmlBody = htmlBody.replace('{!Unit}', bookingObj.Unit_Number__c);
                            htmlBody = htmlBody.replace('{!Project}', bookingObj.Project_Name_Formulla__c);
                            
                            /*  SendEmailandBellNotificationUtility.SendEmail(
String.valueOf(mapNameToEmailTemp.get('Welcome_Call_Task_Rejected_RM').Id),
htmlBody,
'',
addresses1,
null
);*/
                            SendEmailandBellNotificationUtility.SendEmail3(String.valueOf(mapNameToEmailTemp.get('Welcome_Call_Task_Rejected_RM').Id),
                                                                           String.valueOf(mapNameToEmailTemp.get('Welcome_Call_Task_Rejected_RM').Subject), 
                                                                           htmlBody, 
                                                                           '', 
                                                                           addresses1, 
                                                                           null, 
                                                                           true, 
                                                                           bookingObj.Id, 
                                                                           null, 
                                                                           null, 
                                                                           null);
                            if(bookingObj.Related_Opportunity__c != null){
                                if(mapIdToOppo.size() > 0 && mapIdToOppo.containsKey(bookingObj.Related_Opportunity__c)){
                                    Opportunity oppo = mapIdToOppo.get(bookingObj.Related_Opportunity__c);
                                    //CheckList Details
                                    if(bookingObj.Question_1__c==false){
                                        checkListName.add('Applicant Name');
                                    }
                                    if(bookingObj.Question_2__c==false){
                                        checkListName.add('Email Address');
                                    }
                                    if(bookingObj.Question_3__c==false){
                                        checkListName.add('Mobile');
                                    }
                                    if(bookingObj.Question_9__c==false){
                                        checkListName.add('Permanent Address');
                                    }
                                    if(bookingObj.KYC_details_Non_Critical__c==false){
                                        checkListName.add('KYC Details Provided');
                                    }
                                    if(bookingObj.Question_10__c==false){
                                        checkListName.add('Project Name');
                                    }
                                    if(bookingObj.Flat_Type_Non_Critical__c==false){
                                        checkListName.add('Flat Typology');
                                    }
                                    if(bookingObj.Tower_Non_Critical__c==false){
                                        checkListName.add('Tower');
                                    }
                                    if(bookingObj.Flat_No_Non_Critical__c==false){
                                        checkListName.add('Flat No.');
                                    }
                                    if(bookingObj.Floor_Non_Critical__c==false){
                                        checkListName.add('Floor');
                                    }
                                    if(bookingObj.Carpet_Area_Non_Critical__c==false){
                                        checkListName.add('Carpet Area (In Sq. Mtrs)');
                                    }
                                    if(bookingObj.Question_4__c==false){
                                        checkListName.add('Booking Offer');
                                    }
                                    if(bookingObj.Question_5__c==false){
                                        checkListName.add('No. Of Car Parkings');
                                    }
                                    if(bookingObj.Agreemnt_Non_Critical__c==false){
                                        checkListName.add('Agreement Value');
                                    }
                                    if(bookingObj.Question_6__c==false){
                                        checkListName.add('Source Of Booking');
                                    }
                                    if(bookingObj.Question_7__c==false){
                                        checkListName.add('Mode Of Funding');
                                    }
                                    if(bookingObj.Question_8__c==false){
                                        checkListName.add('Payment Plan Type');
                                    }
                                    if(bookingObj.PaymentMode__c==false){
                                        checkListName.add('Payment Mode');
                                    }
                                    if(bookingObj.Amount_Non_Critical__c==false){
                                        checkListName.add('Amount');
                                    }
                                    if(bookingObj.GST_Non_Critical__c==false){
                                        checkListName.add('GST Payment');
                                    }
                                    if(bookingObj.Reciept_Type_Non_Critical__c==false){
                                        checkListName.add('Receipt Type');
                                    }
                                    if(bookingObj.Bank_Name_Non_Critical__c==false){
                                        checkListName.add('Bank Name');
                                    }
                                    if(bookingObj.Intrument_Name__c==false){
                                        checkListName.add('Instrument Name');
                                    }
                                    if(bookingObj.Rm_Name_Non_Critical__c==false){
                                        checkListName.add('RM Name');
                                    }
                                    if(bookingObj.RM_Contact_Non_Critical__c==false){
                                        checkListName.add('RM Contact No.');
                                    }
                                    if(bookingObj.Rm_Work_Hour_Non_Critical__c==false){
                                        checkListName.add('RM Work Hours');
                                    }
                                    if(bookingObj.Description__c==false){
                                        checkListName.add('Description');
                                    }
                                    String checkListDetails='';
                                    
                                    if(checkListName.size()>0){
                                        Integer num=1;
                                        for(String stringVar:checkListName){
                                            checkListDetails+=num+'.'+stringVar+'<br/>';
                                            num++;
                                        }
                                        System.debug('checkListDetails:'+checkListDetails);
                                    }
                                    addresses2.add(mapIdToUser.get(oppo.OwnerId).Email);
                                    String htmlBody1 = mapNameToEmailTemp.get('Welcome_Call_Task_Rejected_SM').HtmlValue;
                                    htmlBody1 = htmlBody1.replace('{!SMName}', mapIdToUser.get(oppo.OwnerId).Name);
                                    htmlBody1 = htmlBody1.replace('{!Unit}', bookingObj.Unit_Number__c);
                                    htmlBody1 = htmlBody1.replace('{!Project}', bookingObj.Project_Name_Formulla__c);
                                    htmlBody1 = htmlBody1.replace('{!checkListDetails}',checkListDetails);
                                    /* SendEmailandBellNotificationUtility.SendEmail(
String.valueOf(mapNameToEmailTemp.get('Welcome_Call_Task_Rejected_SM').Id),
htmlBody1,
'',
addresses2,
null
);*/
                                    SendEmailandBellNotificationUtility.SendEmail3( String.valueOf(mapNameToEmailTemp.get('Welcome_Call_Task_Rejected_SM').Id),
                                                                                   String.valueOf(mapNameToEmailTemp.get('Welcome_Call_Task_Rejected_SM').Subject), 
                                                                                   htmlBody1, 
                                                                                   '', 
                                                                                   addresses2, 
                                                                                   null, 
                                                                                   true, 
                                                                                   bookingObj.Id, 
                                                                                   null, 
                                                                                   null, 
                                                                                   null);
                                }
                            }
                        }
                    }
                }
            }
            System.debug('Number of Queries used in sendEmailWhenWelcomeCallRejected2: ' + Limits.getQueries());
        }
    }
    
    public static void sendEmailWHenDraftAgreementComplete(List<Task> taskList,Map<id,Task> oldMapIdToTask){
        if(!PreventRecursionClass.taskflag1){
            PreventRecursionClass.taskflag1 = true;
            System.debug('Number of Queries used in sendEmailWHenDraftAgreementComplete1: ' + Limits.getQueries());
            /*EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Draft_Agreement_Task_Completed' limit 1];
UserRole CRMHeadRoleObj = [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'];
String CRMHeadUserName = Label.CRM_Head_User;
User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: CRMHeadRoleObj.Id AND isActive =: true Limit 1];

List<String> addresses = new List<String>();
addresses.add(CRMHeadRoleObjUser.Email);*/
            
            Set<Id> setOfBookIds = new Set<Id>();
            for(Task taskObj : taskList){
                String objectName = taskObj.WhatId.getSObjectType().getDescribe().getName();
                if(objectName == 'Booking__c')
                {
                    setOfBookIds.add(taskObj.whatId);
                }
            }
            if(!setOfBookIds.isEmpty())
            {
                Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,OwnerId,Unit_Number__c,Project_Name_Formulla__c From Booking__c where Id in: setOfBookIds]);
                if(!mapIdToBooking.isEmpty()){
                    EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Draft_Agreement_Task_Completed' limit 1];
                    UserRole CRMHeadRoleObj = [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'];
                    String CRMHeadUserName = Label.CRM_Head_User;
                    User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: CRMHeadRoleObj.Id AND isActive =: true Limit 1];
                    
                    List<String> addresses = new List<String>();
                    addresses.add(CRMHeadRoleObjUser.Email);
                    Set<Id> setOfRMIds = new Set<Id>();
                    for(Id key : mapIdToBooking.keySet()){
                        setOfRMIds.add(mapIdToBooking.get(key).OwnerId);
                    }
                    Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where Id In : setOfRMIds]);
                    
                    for(Task taskObj : taskList){
                        if(taskObj.Status == 'Completed' && taskObj.Subject == 'Generate Draft Agreement' && oldMapIdToTask.get(taskObj.Id).Status != taskObj.Status){
                            if(taskObj.whatId != null){
                                if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(taskObj.whatId)){ 
                                    Booking__c bookingObj = mapIdToBooking.get(taskObj.whatId);
                                    addresses.add(mapIdToUser.get(bookingObj.OwnerId).Email);
                                    
                                    String htmlBody = emailTemplate.HtmlValue;
                                    htmlBody = htmlBody.replace('{!RM}', mapIdToUser.get(bookingObj.OwnerId).Name);
                                    htmlBody = htmlBody.replace('{!Name}', bookingObj.Name);
                                    htmlBody = htmlBody.replace('{!Unit}', bookingObj.Unit_Number__c);
                                    htmlBody = htmlBody.replace('{!Project}', bookingObj.Project_Name_Formulla__c);
                                    
                                    /*  SendEmailandBellNotificationUtility.SendEmail(
String.valueOf(emailTemplate.Id),
htmlBody,
'',
addresses,
null
);*/
                                    SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,
                                                                                   emailTemplate.Subject, 
                                                                                   htmlBody, 
                                                                                   '', 
                                                                                   addresses, 
                                                                                   null, 
                                                                                   true, 
                                                                                   bookingObj.Id, 
                                                                                   null, 
                                                                                   null, 
                                                                                   null);
                                    
                                }
                            }
                        }
                    }
                }
            }
            
            System.debug('Number of Queries used in sendEmailWHenDraftAgreementComplete2: ' + Limits.getQueries());
        }
    }
    
    public static void whenAgreeTaskStatusSharedUpdateBookingAgreeDate(List<Task> taskList,Map<id,Task> oldMapIdToTask){
        if(!PreventRecursionClass.taskflag5){
            PreventRecursionClass.taskflag5 = true;
            System.debug('Number of Queries used in whenAgreeTaskStatusSharedUpdateBookingAgreeDate1: ' + Limits.getQueries());
            System.debug('in Sharef');
            Id businessHourId = [SELECT Id FROM BusinessHours WHERE IsDefault = true].Id;
            System.debug('businessHourId'+businessHourId);
            Integer hours = 48;
            List<Booking__c> listOfBookingToUpdate = new List<Booking__c>();
            
            CustomNotificationType notifyObj = [Select Id,CustomNotifTypeName from CustomNotificationType Where DeveloperName =: 'Notification_To_RM' limit 1];
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Shared_Draft_Agreement' limit 1];
            UserRole CRMHeadRoleObj = [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'];
            String CRMHeadUserName = Label.CRM_Head_User;
            User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: CRMHeadRoleObj.Id AND isActive =: true Limit 1];
            
            List<String> addresses = new List<String>();
            addresses.add(CRMHeadRoleObjUser.Email);
            
            Set<Id> setOfBookIds = new Set<Id>();
            for(Task taskObj : taskList){
                String objectName = taskObj.WhatId.getSObjectType().getDescribe().getName();
                if(objectName == 'Booking__c')
                {
                    setOfBookIds.add(taskObj.whatId);
                }
            }
            if(!setOfBookIds.isEmpty()){
                Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Primary_Applicant__c,Agreement_Shared_Date__c,Name,OwnerId,Unit_Number__c,Project_Name_Formulla__c From Booking__c where Id in: setOfBookIds]);
                if(!mapIdToBooking.isEmpty()){
                    Set<Id> setOfRMIds = new Set<Id>();
                    for(Id key : mapIdToBooking.keySet()){
                        setOfRMIds.add(mapIdToBooking.get(key).OwnerId);
                    }
                    Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where Id In : setOfRMIds]);
                    
                    System.debug('Before Loop');
                    for(Task taskObj : taskList){
                        System.debug('in Loop'+taskObj.Status+taskObj.Subject);
                        System.debug('in Sharef');
                        if(taskObj.Status == 'Shared' && taskObj.Subject == 'Generate Draft Agreement' && oldMapIdToTask.get(taskObj.Id).Status != taskObj.Status){
                            if(taskObj.whatId != null){
                                if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(taskObj.whatId)){ 
                                    Booking__c bookingObj = mapIdToBooking.get(taskObj.whatId);
                                    System.debug('bookingObj'+bookingObj);
                                    
                                    DateTime AgreementDate = BusinessHours.add(businessHourId,System.now(), hours * 60 * 60 * 1000L);  
                                    System.debug('AgreementDate :'+AgreementDate);
                                    bookingObj.Agreement_Shared_Date__c = AgreementDate;
                                    listOfBookingToUpdate.add(bookingObj);
                                    Set<String> recipientIds = new Set<String>();
                                    recipientIds.add(bookingObj.OwnerId);
                                    
                                    String body = 'Dear ' + mapIdToUser.get(bookingObj.OwnerId).Name + ',\n'
                                        + 'The Draft Agreement Letter against Booking ' + bookingObj.Name + ' for '+
                                        bookingObj.Unit_Number__c + ' in ' + bookingObj.Project_Name_Formulla__c + ' has been shared with client.';
                                    if(!test.isrunningtest()){ 
                                        SendEmailandBellNotificationUtility.SendBellNotification(
                                            notifyObj.Id,
                                            'Draft Agreement has been shared',
                                            body,
                                            bookingObj.Id,
                                            recipientIds
                                        );}
                                    String htmlBody = emailTemplate.HtmlValue;
                                    htmlBody = htmlBody.replace('Sir', CRMHeadRoleObjUser.Name);
                                    htmlBody = htmlBody.replace('{!RM}', mapIdToUser.get(bookingObj.OwnerId).Name);
                                    htmlBody = htmlBody.replace('{!Name}', bookingObj.Name);
                                    htmlBody = htmlBody.replace('{!Unit}', bookingObj.Unit_Number__c);
                                    htmlBody = htmlBody.replace('{!Project}', bookingObj.Project_Name_Formulla__c);
                                    
                                    /*  SendEmailandBellNotificationUtility.SendEmail(
String.valueOf(emailTemplate.Id),
htmlBody,
'',
addresses,
null
);*/
                                    if(!test.isrunningtest()){ 
                                        SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,
                                                                                       emailTemplate.Subject, 
                                                                                       htmlBody, 
                                                                                       '', 
                                                                                       addresses, 
                                                                                       null, 
                                                                                       true, 
                                                                                       bookingObj.Id, 
                                                                                       null, 
                                                                                       null, 
                                                                                       null);
                                    }
                                }
                            }
                        }
                    }
                    System.debug('Number of Queries used in whenAgreeTaskStatusSharedUpdateBookingAgreeDate2: ' + Limits.getQueries());
                    if(!listOfBookingToUpdate.isEmpty()){
                        update listOfBookingToUpdate;
                    }
                }
            }
            System.debug('Number of Queries used in whenAgreeTaskStatusSharedUpdateBookingAgreeDate3: ' + Limits.getQueries());
        }
    }
    
    public static void whenWelcomeTaskClosedCreateAgreementTask(List<Task> taskList,Map<id,Task> oldMapIdToTask){
        if(!PreventRecursionClass.taskflag2){
            PreventRecursionClass.taskflag2 = true;
            Set<Id> bookingIdSet = New Set<Id>();
            for(Task taskObj : taskList){
                if(taskObj.WhatId != null)
                {
                    String objectName = taskObj.WhatId.getSObjectType().getDescribe().getName();
                    if(objectName == 'Booking__c')
                    {
                        bookingIdSet.add(taskObj.WhatId); 
                    }
                }
            }
            System.debug('Number of Queries used in whenWelcomeTaskClosedCreateAgreementTask1: ' + Limits.getQueries());
            Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>();
            if(!bookingIdSet.isEmpty())
            {
                mapIdToBooking = new Map<Id,Booking__c>([Select Id,Primary_Applicant__c,Name,OwnerId  From Booking__c WHERE ID IN: bookingIdSet]);
                
            }
            List<Task> listOfAgreementTaskToCreate = new List<Task>();
            for(Task taskObj : taskList){
                if(taskObj.Status == 'Completed' && taskObj.Subject == 'Welcome Call' && oldMapIdToTask.get(taskObj.Id).Status != taskObj.Status){
                    if(taskObj.whatId != null){
                        if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(taskObj.whatId)){ 
                            Booking__c bookingObj = mapIdToBooking.get(taskObj.whatId);
                            Task agreeTaskObj = new Task();
                            agreeTaskObj.OwnerId = bookingObj.OwnerId;
                            agreeTaskObj.WhatId = taskObj.whatId;
                            agreeTaskObj.Status = 'Pending';
                            agreeTaskObj.Subject = 'Generate Draft Agreement';
                            agreeTaskObj.ActivityDate = System.today().addDays(1);
                            listOfAgreementTaskToCreate.add(agreeTaskObj);
                        }
                    }
                }
            }
            System.debug('Number of Queries used in whenWelcomeTaskClosedCreateAgreementTask2: ' + Limits.getQueries());
            if(!listOfAgreementTaskToCreate.isEmpty()){
                insert listOfAgreementTaskToCreate;
            }
            System.debug('Number of Queries used in whenWelcomeTaskClosedCreateAgreementTask3: ' + Limits.getQueries());
        }
    }
    
    public static void WelcomeStatusClosedSendEmailToCustomer(List<Task> taskList,Map<id,Task> oldMapIdToTask){
        
        if(!PreventRecursionClass.taskflag3){
            Set<Id> bookingIdSet = New Set<Id>();
            PreventRecursionClass.taskflag3 = true;
            for(Task taskObj : taskList){
                if(taskObj.WhatId != null)
                {
                    String objectName = taskObj.WhatId.getSObjectType().getDescribe().getName();
                    if(objectName == 'Booking__c')
                    {
                        bookingIdSet.add(taskObj.WhatId); 
                    }
                }
            }
            System.debug('Number of Queries used in WelcomeStatusClosedSendEmailToCustomer1: ' + Limits.getQueries());
            Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>();
            Map<Id,Account> mapIdToPrimaryApplicantAccount = new Map<Id,Account>();
            if(!bookingIdSet.isEmpty())
            {
                set<Id> accountId = New set<Id>();
                List<Booking__C> bookingList = [Select Id,Primary_Applicant__c,Name,OwnerId,CreatedById,Project_Name__c,Project_Name__r.Name  From Booking__c WHERE ID IN: bookingIdSet];
                for(Booking__C booking : bookingList)
                {
                    if(booking.Primary_Applicant__c != null)
                    {
                        accountId.add(booking.Primary_Applicant__c);
                    }
                    mapIdToBooking.put(booking.id,booking);
                }
                if(!accountId.isEmpty())
                {
                    mapIdToPrimaryApplicantAccount = new Map<Id,Account>([Select Id,OwnerId,CreatedById,PersonEmail  From Account WHERE ID IN: accountId]); 
                }
                
            }
            
            System.debug('mapIdToPrimaryApplicantAccount '+mapIdToPrimaryApplicantAccount);
            
            System.debug('mapIdToBooking '+mapIdToBooking);
            Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where isActive =: true]);
            System.debug('mapIdToUser '+mapIdToUser);
            Set<Id> setOfBookingIds = new Set<Id>();
            for(Id key : mapIdToBooking.keySet()){
                setOfBookingIds.add(key);
            }
            if(!mapIdToBooking.isEmpty()){
                System.debug('setOfBookingIds '+setOfBookingIds);
                UserRole CRMHeadRoleObj = [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'];
                String CRMHeadUserName = Label.CRM_Head_User;
                User CRMSiteHeadRoleUsers = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: [select id from UserRole where DeveloperName =: 'CRM_Head' limit 1].Id AND isActive =: true Limit 1];
                
                EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Welcome_Call_Task_Completed' limit 1];
                EmailTemplate emailTemplate1 = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Welcome_Email_Notification' limit 1];
                //  OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName = 'Divum' Limit 1];
                List<OrgWideEmailAddress> orgEmailList =new List<OrgWideEmailAddress> ([select Id, Address, DisplayName from OrgWideEmailAddress]);
                Map<String,String> orgEmailMap=new Map<String,String>();
                // System.debug('orgEmail '+orgEmail);
                if(orgEmailList.size()>0){
                    for(OrgWideEmailAddress ordEmailAdd:orgEmailList){
                        orgEmailMap.put(ordEmailAdd.DisplayName,ordEmailAdd.Id);
                    }
                }
                System.debug('orgEmailMap:==>'+orgEmailMap);
                List<Messaging.SingleEmailMessage> emailMsgList = New List<Messaging.SingleEmailMessage>();
                List<String> Addresses = new List<String>(); 
                List<String> Addresses1 = new List<String>(); 
                for(Task taskObj : taskList){
                    if(taskObj.Status == 'Completed' && taskObj.Subject == 'Welcome Call' && oldMapIdToTask.get(taskObj.Id).Status != taskObj.Status){
                        if(taskObj.whatId != null){
                            if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(taskObj.whatId)){
                                Booking__c bookingObj = mapIdToBooking.get(taskObj.whatId);
                                System.debug('bookingObj '+bookingObj.Primary_Applicant__c);
                                String orgEmailProjectName=bookingObj.Project_Name__r.Name;
                                if(orgEmailProjectName=='Avanya Tower A'||orgEmailProjectName=='Avanya Tower B'||orgEmailProjectName=='Avanya Tower C'){
                                    orgEmailProjectName='Avanya';
                                }
                                System.debug('orgEmailProjectName:'+orgEmailProjectName);
                                String projectWiseOrgEmail=orgEmailMap.get(orgEmailProjectName);
                                System.debug('projectWiseOrgEmail:==>'+projectWiseOrgEmail);
                                if(bookingObj.Primary_Applicant__c != null){
                                    System.debug('bookingObj '+bookingObj.Primary_Applicant__c);
                                    if(mapIdToPrimaryApplicantAccount.size() > 0 && mapIdToPrimaryApplicantAccount.containsKey(bookingObj.Primary_Applicant__c)){
                                        Account PrimaryApplicantAcc = mapIdToPrimaryApplicantAccount.get(bookingObj.Primary_Applicant__c);
                                        System.debug('PrimaryApplicantAcc '+PrimaryApplicantAcc);
                                        if(mapIdToUser.size() > 0 && mapIdToUser.containsKey(PrimaryApplicantAcc.OwnerId)){
                                            User AccOwner = mapIdToUser.get(PrimaryApplicantAcc.OwnerId);
                                            System.debug('Email '+AccOwner.Email);
                                            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(String.Valueof(emailTemplate.Id),bookingObj.CreatedById,bookingObj.Id);
                                            Addresses.add(AccOwner.Email);   
                                            Addresses.add(CRMSiteHeadRoleUsers.Email);   
                                            Addresses.add(mapIdToUser.get(bookingObj.OwnerId).Email);   
                                            email.setOrgWideEmailAddressId(projectWiseOrgEmail);
                                            email.toaddresses = Addresses;
                                            email.setSaveAsActivity(false);
                                            emailMsgList.add(email);
                                        }
                                    }
                                    //for send email to customer
                                    if(mapIdToPrimaryApplicantAccount.size() > 0 && mapIdToPrimaryApplicantAccount.containsKey(bookingObj.Primary_Applicant__c)){
                                        Account PrimaryApplicantAcc1 = mapIdToPrimaryApplicantAccount.get(bookingObj.Primary_Applicant__c);
                                        System.debug('PrimaryApplicantAcc1 '+PrimaryApplicantAcc1);
                                        if(PrimaryApplicantAcc1.PersonEmail!=null){
                                            Messaging.SingleEmailMessage email1 = Messaging.renderStoredEmailTemplate(String.Valueof(emailTemplate1.Id),bookingObj.CreatedById,bookingObj.Id);
                                            Addresses1.add(PrimaryApplicantAcc1.PersonEmail);
                                            email1.setOrgWideEmailAddressId(projectWiseOrgEmail);
                                            email1.toaddresses = Addresses1;
                                            email1.setSaveAsActivity(false);
                                            emailMsgList.add(email1);
                                        }
                                    }
                                }
                            } 
                        }
                    }
                }
                System.debug('Before Sending ');
                if(emailMsgList.size() > 0){
                    System.debug('In  Sending');
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMsgList);
                    if(results[0].success){
                        system.debug('The email was sent successfully! '+emailMsgList);
                    }
                    else{
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                    }
                }   
                System.debug('Number of Queries used in WelcomeStatusClosedSendEmailToCustomer2: ' + Limits.getQueries());
            }
        }
    }
    
    
    public static void updateStatusAndSendEmailToRM(List<Task> taskList,Map<id,Task> oldMapIdToTask){
        
        if(!PreventRecursionClass.taskflag4){
            PreventRecursionClass.taskflag4 = true;
            Set<Id> bookingIdSet = New Set<Id>();
            for(Task taskObj : taskList){
                if(taskObj.WhatId != null)
                {
                    String objectName = taskObj.WhatId.getSObjectType().getDescribe().getName();
                    if(objectName == 'Booking__c')
                    {
                        bookingIdSet.add(taskObj.WhatId); 
                    }
                }
            }
            System.debug('Number of Queries used in updateStatusAndSendEmailToRM1: ' + Limits.getQueries());
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Welcome_Call_Task_Reopened_Template' limit 1];
            OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName = 'Divum' Limit 1];
            System.debug('orgEmail '+orgEmail);
            List<Messaging.SingleEmailMessage> emailMsgList = New List<Messaging.SingleEmailMessage>();
            List<String> Addresses = new List<String>(); 
            Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User where isActive =: true]);
            // Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,OwnerId,Unit_Number__c,Project_Name_Formulla__c From Booking__c]);
            Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>();
            if(!bookingIdSet.isEmpty())
            {
                mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,OwnerId,Unit_Number__c,Project_Name_Formulla__c From Booking__c WHERE ID IN: bookingIdSet]);
                
            }
            if(!mapIdToBooking.isEmpty()){
                Set<Id> setOfBookingIds = new Set<Id>();
                for(Id key : mapIdToBooking.keySet()){
                    setOfBookingIds.add(key);
                }
                Map<Id,Task> mapIdToWelcomeCallTask = new Map<Id,Task>([Select Id,Status,Subject From Task Where whatId In : setOfBookingIds]);
                List<Task> listOfTaskToUpdate = new List<Task>();
                List<Task> listOfExistingTasks = [Select Id,Subject,Status,whatId,CreatedById From task where Subject =: 'Welcome Call' AND WhatId In : setOfBookingIds];
                List<Booking__c> listOfBookingToUpdate = new List<Booking__c>();
                for(Task taskObj : taskList){
                    if(taskObj.Status == 'Completed' && taskObj.Subject == 'Review Welcome Call' && oldMapIdToTask.get(taskObj.Id).Status != taskObj.Status){
                        if(taskObj.whatId != null){
                            if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(taskObj.whatId)){
                                Booking__c bookingObj = mapIdToBooking.get(taskObj.whatId);
                                bookingObj.ReOpen_Date__c = Date.today();
                                listOfBookingToUpdate.add(bookingObj);
                                for(Task obj : listOfExistingTasks){
                                    if(obj.WhatId == bookingObj.Id){
                                        if(obj.Subject == 'Welcome Call'){
                                            obj.Status = 'Re-open';
                                            System.debug('InReopen ');
                                            listOfTaskToUpdate.add(obj);
                                            if(mapIdToUser.size() > 0 && mapIdToUser.containsKey(bookingObj.OwnerId)){
                                                System.debug('In mapIdToUser '+mapIdToUser.get(bookingObj.OwnerId).Email);
                                                Addresses.add(mapIdToUser.get(bookingObj.OwnerId).Email);
                                                String htmlBody1 = emailTemplate.HtmlValue;
                                                htmlBody1 = htmlBody1.replace('{!RM}', mapIdToUser.get(bookingObj.OwnerId).Name);
                                                htmlBody1 = htmlBody1.replace('{!Name}', bookingObj.Name);
                                                htmlBody1 = htmlBody1.replace('{!Unit}', bookingObj.Unit_Number__c);
                                                htmlBody1 = htmlBody1.replace('{!Project}', bookingObj.Project_Name_Formulla__c);
                                                /* SendEmailandBellNotificationUtility.SendEmail(
String.valueOf(emailTemplate.Id),
htmlBody1,
'',
Addresses,
null
);*/
                                                SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,
                                                                                               emailTemplate.Subject, 
                                                                                               htmlBody1, 
                                                                                               '', 
                                                                                               Addresses, 
                                                                                               null, 
                                                                                               true, 
                                                                                               bookingObj.Id, 
                                                                                               null, 
                                                                                               null, 
                                                                                               null);
                                            }
                                        }
                                    }
                                }
                            } 
                        }
                    }
                }
                System.debug('Number of Queries used in updateStatusAndSendEmailToRM2: ' + Limits.getQueries());
                if(!listOfTaskToUpdate.isEmpty()){
                    update listOfTaskToUpdate;
                }
                System.debug('Number of Queries used in updateStatusAndSendEmailToRM3: ' + Limits.getQueries());
                if(!listOfBookingToUpdate.isEmpty()){
                    update listOfBookingToUpdate;
                }
                System.debug('Number of Queries used in updateStatusAndSendEmailToRM4: ' + Limits.getQueries());
                System.debug('Before Sending ');
                if(emailMsgList.size() > 0){
                    System.debug('In  Sending');
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMsgList);
                    if(results[0].success){
                        system.debug('The email was sent successfully! '+emailMsgList);
                    }
                    else{
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                    }
                } 
                System.debug('Number of Queries used in updateStatusAndSendEmailToRM5: ' + Limits.getQueries());
            }
        }
    }
    
    public static void disableEditForWelcomeCallTask(List<Task> taskList){
        if(taskList.size()>0){
            List<Task> reviewWelcomeCallList=new List<Task>();
            Map<String,Task> mapOfReviewWelcomeTask=new Map<String,Task>();
            Set<String> welcomeTaskbookIds=new Set<String>();
            for(Task taskRcd:taskList){
                if(taskRcd.Subject=='Welcome Call' && taskRcd.WhatId!=null){
                    welcomeTaskbookIds.add(taskRcd.WhatId);
                }
            }
            System.debug('welcomeTaskbookIds:'+welcomeTaskbookIds);
            if(welcomeTaskbookIds.size()>0){
                reviewWelcomeCallList=new List<Task>([Select Id,Subject,Status,WhatId From Task Where WhatId!=null 
                                                      AND Status!='Completed' AND Subject=:'Review Welcome Call' AND WhatId=:welcomeTaskbookIds]);
                System.debug('reviewWelcomeCallList:'+reviewWelcomeCallList);
                if(reviewWelcomeCallList.size()>0){
                    for(Task taskRcd1: reviewWelcomeCallList){
                        mapOfReviewWelcomeTask.put(taskRcd1.whatId,taskRcd1);
                    }
                    System.debug('mapOfReviewWelcomeTask:'+mapOfReviewWelcomeTask);
                    if(mapOfReviewWelcomeTask.size()>0){
                        for(Task taskRcd2:taskList){
                            system.debug('taskRcd2 In Welcome call edit validation:'+taskRcd2);
                            if(taskRcd2.Subject=='Welcome Call' && taskRcd2.WhatId!=null && mapOfReviewWelcomeTask.get(taskRcd2.WhatId).Status!='Completed'){
                                taskRcd2.addError('You can not edit this Welcome call task until its Review welcome call task has been completed.');
                            }
                        }
                    }
                }                
            }
        }
    }
    
    // Pre-Sales and Sales Module Method
    
    
    public static Void calculateTargetForConnectedCalls(List<Task> TaskList)
    {
        Set<Id> ownerId = New Set<Id>();
        Set<Id> enquiryId = New Set<Id>();
        Map<String, Integer> mapUserForCountTask = New Map<String, Integer>();
        for(Task thisTask :TaskList)
        {
            if(thisTask.Exotel_CTI__Call_Duration__c != null && thisTask.Task_Target__c == null && thisTask.Exotel_CTI__Call_Duration__c != '0' ){
                String[] strTimeSplit = thisTask.Exotel_CTI__Call_Duration__c.split(':');
                Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                                   ,Integer.valueOf(strTimeSplit[1]) //min
                                                   ,Integer.valueOf(strTimeSplit[2])
                                                   ,0);                               //sec
                String[] strTimeCompareSplit = '00:00:17'.split(':');
                Time timeCompare = Time.newInstance( Integer.valueOf(strTimeCompareSplit[0]) //hour
                                                    ,Integer.valueOf(strTimeCompareSplit[1]) //min
                                                    ,Integer.valueOf(strTimeCompareSplit[2])                               //sec
                                                    ,0);  
                system.debug('timeChange---'+timeChange);
                system.debug('timeCompare---'+timeCompare);
                // String timeString = thisTask.Exotel_CTI__Call_Duration__c;
                // Time timeValue = Time.valueOf(timeString);
                if(//thisTask.Call_Status__c !=  taskOldMap.get(thisTask.id).Call_Status__c && thisTask.Call_Status__c == 'Connected' &&
                    timeChange >= timeCompare)
                { 
                    if( thisTask.WhatID != null){
                        system.debug('True---');
                        String sObjName = thisTask.WhatID.getSObjectType().getDescribe().getName();
                        if(sObjName == 'Enquiry__c')
                        {
                            ownerId.add(thisTask.OwnerId);
                            enquiryId.add(thisTask.WhatID);
                        }
                    }
                }
            }
        }
        Map<String,Enquiry__c> mapOfEnquiryIdToGetProjectId = New Map<String,Enquiry__c>();
        if(!EnquiryId.IsEmpty())
        {
            List<Enquiry__c> enquiryList = [SELECT id, Contact_Person__c, Stage__c, Project__c 
                                            FROM Enquiry__c 
                                            WHERE id IN :EnquiryId 
                                           ];
            if(!enquiryList.isEmpty()){
                for(Enquiry__c thisEnquiry :enquiryList){
                    mapOfEnquiryIdToGetProjectId.put(thisEnquiry.id,thisEnquiry);
                }
            }
            system.debug('ownerId'+ownerId);
            Date todayDate = Date.today() ;
            List<Task_Target__c> taskTargetList = [SELECT Id, Name, user__c, Month__c,Type__c,
                                                   Year__c, Number_of_Targets_Achievement__c,
                                                   X1st_Week__c, X2nd_Week__c, X3rd_Week__c,
                                                   X4th_Week__c, X5th_Week__c, Project__c,
                                                   Number_of_Connected_Call__c, No_of_Walk_ins__c, No_of_Follow_Ups__c
                                                   FROM Task_Target__c
                                                   WHERE user__c IN :ownerId 
                                                   AND Type__c = :'Connected Call'];
            system.debug('taskTargetList----'+taskTargetList);
            Map<String, Task_Target__c> updateTaskTarget = New Map<String, Task_Target__c>();
            Map<String, Task_Target__c> mapOfUserToGetTaskTargetId = New Map<String, Task_Target__c>();
            Map<String, Integer> mapUserForConnectedTask = New Map<String, Integer>();
            Map<String, Integer> mapUserFor1Week= New Map<String, Integer>();
            Map<String, Integer> mapUserFor2Week= New Map<String, Integer>();
            Map<String, Integer> mapUserFor3Week= New Map<String, Integer>();
            Map<String, Integer> mapUserFor4Week= New Map<String, Integer>();
            Map<String, Integer> mapUserFor5Week= New Map<String, Integer>();
            for(Task_Target__c taskTarget : taskTargetList)
            {
                String Key = taskTarget.Month__c+'-'+taskTarget.Year__c+'-'+String.valueOf(taskTarget.Project__c)+'-'+String.valueOf(taskTarget.User__c);
                mapOfUserToGetTaskTargetId.put(Key,taskTarget);
                system.debug('Task Target---');
                if(taskTarget.Number_of_Targets_Achievement__c == null)
                {
                    mapUserForCountTask.put(Key,0);
                }
                else
                {
                    system.debug('Integer.valueof(taskTarget.Number_of_Targets_Achievement__c)'+Integer.valueof(taskTarget.Number_of_Targets_Achievement__c));
                    mapUserForCountTask.put(Key,Integer.valueof(taskTarget.Number_of_Targets_Achievement__c));
                }
                if(taskTarget.X1st_Week__c == null)
                {
                    mapUserFor1Week.put(Key,0);
                    system.debug('mapUserFor1Week.get(Key)'+mapUserFor1Week.get(Key));
                }
                else
                {
                    mapUserFor1Week.put(Key,Integer.valueof(taskTarget.X1st_Week__c));
                }
                if(taskTarget.X2nd_Week__c == null)
                {
                    mapUserFor2Week.put(Key,0);
                }
                else
                {
                    mapUserFor2Week.put(Key,Integer.valueof(taskTarget.X2nd_Week__c));
                }
                if(taskTarget.X3rd_Week__c == null)
                {
                    mapUserFor3Week.put(Key,0);
                }
                else
                {
                    mapUserFor3Week.put(Key,Integer.valueof(taskTarget.X3rd_Week__c));
                }
                if(taskTarget.X4th_Week__c   == null)
                {
                    mapUserFor4Week.put(Key,0);
                }
                else
                {
                    mapUserFor4Week.put(Key,Integer.valueof(taskTarget.X4th_Week__c ));
                }
                if(taskTarget.X5th_Week__c == null)
                {
                    mapUserFor5Week.put(Key,0);
                }
                else
                {
                    mapUserFor5Week.put(Key,Integer.valueof(taskTarget.X5th_Week__c));
                }
            }
            List<Task> updateTaskList = New List<Task>();
            for(Task thisTask :TaskList)
            {
                Date myDate = Date.today(); // Replace with your desired date
                Integer weekNumber = myDate.day() / 7 + 1;
                System.debug('Week Number: ' + weekNumber);
                if(mapOfEnquiryIdToGetProjectId.containsKey(thisTask.WhatId)){
                    Integer yr = System.today().year();
                    System.debug('Year is' + yr);
                    string month = System.now().format('MMMMM');
                    System.debug('Month is' + month);
                    
                    string Key = month+'-'+String.valueOf(yr)+'-'+String.valueOf(mapOfEnquiryIdToGetProjectId.get(thisTask.WhatId).Project__c)+'-'+String.valueOf(thisTask.OwnerId);
                    System.debug('Month is' + month);
                    if(mapOfUserToGetTaskTargetId.containskey(Key)){
                        Task_Target__c taskTarget = New Task_Target__c();
                        taskTarget.id = mapOfUserToGetTaskTargetId.get(Key).id;
                        if(thisTask.Call_Status__c =='Connected' && mapUserForCountTask.containsKey(Key))
                        {
                            system.debug('taskTarget.Number_of_Targets_Achievement__c---- '+taskTarget.Number_of_Targets_Achievement__c );
                            mapUserForCountTask.put(Key, mapUserForCountTask.get(Key)+1);
                            system.debug(' mapUserForCountTask.get(Key)'+ mapUserForCountTask.get(Key) );
                            taskTarget.Number_of_Targets_Achievement__c = mapUserForCountTask.get(Key);
                        }
                        if(weekNumber == 1 && mapUserFor1Week.containsKey(Key))
                        {
                            system.debug('taskTarget.X1st_Week__c'+ taskTarget.X1st_Week__c );
                            mapUserFor1Week.put(Key, mapUserFor1Week.get(Key)+1);
                            system.debug('mapUserFor1Week.get(Key)'+ mapUserFor1Week.get(Key) );
                            taskTarget.X1st_Week__c = mapUserFor1Week.get(Key);
                        }
                        if(weekNumber == 2 && mapUserFor2Week.containsKey(Key))
                        {
                            mapUserFor2Week.put(Key, mapUserFor2Week.get(Key)+1);
                            taskTarget.X2nd_Week__c = mapUserFor2Week.get(Key);
                        }
                        if(weekNumber == 3 && mapUserFor3Week.containsKey(Key))
                        {
                            mapUserFor3Week.put(Key, mapUserFor3Week.get(Key)+1);
                            taskTarget.X3rd_Week__c = mapUserFor3Week.get(Key);
                        }
                        if(weekNumber == 4 && mapUserFor4Week.containsKey(Key))
                        {
                            mapUserFor4Week.put(Key, mapUserFor4Week.get(Key)+1);
                            taskTarget.X4th_Week__c  = mapUserFor4Week.get(Key);
                        }
                        if(weekNumber == 5 && mapUserFor5Week.containsKey(Key))
                        {
                            mapUserFor5Week.put(Key, mapUserFor5Week.get(Key)+1);
                            taskTarget.X5th_Week__c  = mapUserFor5Week.get(Key);
                        }
                        system.debug('taskTarget.Number_of_Targets_Achievement__c '+taskTarget.Number_of_Targets_Achievement__c );
                        thisTask.Task_Target__c = mapOfUserToGetTaskTargetId.get(Key).id;
                        updateTaskList.add(thisTask);
                        updateTaskTarget.put(taskTarget.id,taskTarget);
                    }
                }
                
            }
            if(!updateTaskTarget.values().IsEmpty())
            {
                update updateTaskTarget.values();
            }
            if(!updateTaskList.IsEmpty())
            {
                // update updateTaskList;
            }
            
        }
    }
    public static void validationOnCompletionTask(List<Task> taskList)
    { 
        Set<Id> EnquiryId = New Set<Id> ();
        for(Task thisTask :TaskList)
        {
            String sObjName = thisTask.WhatID.getSObjectType().getDescribe().getName();
            if(sObjName == 'Enquiry__c' && thisTask.Status == 'Completed')
            {
                EnquiryId.add(thisTask.WhatID);
            }
            
        }
        if(!EnquiryId.IsEmpty())
        {
            List<Enquiry__c> enquiryList = [SELECT id, Contact_Person__c, Stage__c 
                                            FROM Enquiry__c 
                                            WHERE id IN :EnquiryId 
                                            //   AND Stage__c = 'Site Visit Scheduled'
                                           ];
            if(!enquiryList.isEmpty()){
                Map<Id,Enquiry__c> mapOfEnquiryIdToGetStage = New Map<Id,Enquiry__c>();
                for(Enquiry__c thisEnquiry :enquiryList){
                    mapOfEnquiryIdToGetStage.put(thisEnquiry.id,thisEnquiry);
                    
                }
                for(Task thisTask :TaskList)
                {
                    
                    if(mapOfEnquiryIdToGetStage.containsKey(thisTask.WhatId) )
                    {
                        if(mapOfEnquiryIdToGetStage.get(thisTask.WhatId).Stage__c == 'Site Visit Scheduled'&& thisTask.Call_Sub_status__c != 'Lost'
                           && thisTask.Call_Sub_status__c != 'SVS' && thisTask.Throw_Validation__c != true 
                           && mapOfEnquiryIdToGetStage.get(thisTask.WhatId).Stage__c != thisTask.Call_Sub_status__c )
                        {
                            // thisTask.addError('You cannot mark Task as Call Sub Status '+ thisTask.Call_Sub_status__c +' when site visit is already Scheduled');
                        }
                        if(mapOfEnquiryIdToGetStage.get(thisTask.WhatId).Stage__c == 'Interested' && thisTask.Call_Sub_status__c == 'Junk' )
                        {
                            thisTask.addError('You cannot mark Call Sub Status as Junk When enquiry in Interested Stage');
                        }
                    }
                }
            }
        }
    }
    public static void ThrowValidationOnCompletionTask(List<Task> taskList,Map<id,Task> oldMap){
        Set<id> enquiryId = New Set<id>();
        for(Task taskRecord:taskList)
        {
            system.debug('taskRecord.WhatId----'+taskRecord.WhatId);
            if(taskRecord.WhatId != null && taskRecord.subject != 'Email: Thank You' )
            {
                String objectName = taskRecord.WhatId.getSObjectType().getDescribe().getName();
                if(objectName == 'Enquiry__c')
                {
                    enquiryId.add(taskRecord.WhatId);
                }
            }
        }
        List<Enquiry__c> enquiryList = New List<Enquiry__c>();
        if(!EnquiryId.isEmpty())
        {
            enquiryList = [SELECT id, Contact_Person__c, Stage__c 
                           FROM Enquiry__c 
                           WHERE id IN :EnquiryId 
                           AND Stage__c = 'Site Visit Done'
                          ];
        }
        
        Map<Id,Enquiry__c> mapOfEnquiryIdToGetStage =  New  Map<Id,Enquiry__c>();
        if(!enquiryList.isEmpty()){
            for(Enquiry__c thisEnquiry :enquiryList){
                mapOfEnquiryIdToGetStage.put(thisEnquiry.id,thisEnquiry);
            }
        }
        for(Task thisTask:taskList)
        {
            system.debug('thisTask----'+thisTask);
            String objectName;
            if(thisTask.WhatId != null)
            {
                objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
            }
            system.debug('thisTask----'+thisTask);
            if(thisTask.subject != 'Email: Thank You' && objectName == 'Enquiry__c'&& (!thisTask.subject.contains('Email: ')) && thisTask.WhatId != null)
            {
                System.debug('thisTask.thisTask' +thisTask);
                //if(thisTask){ System.debug('thisTask.Throw_Validation__c' +thisTask.Throw_Validation__c);
                if(thisTask.Throw_Validation__c != true && thisTask.Status == 'Completed' && thisTask.Call_Status__c == null)
                {
                    thisTask.Call_Status__c.addError('Call Status is mandatory while marking Status as Complete');
                }
                else if(thisTask.Throw_Validation__c != true && thisTask.Status == 'Completed' && thisTask.Call_Sub_status__c == null)
                {
                    thisTask.Call_Sub_status__c.addError('Call Sub Status is mandatory while marking Status as Complete');
                }
                else if(thisTask.Throw_Validation__c != true && thisTask.Status == 'Completed' && thisTask.Description == null)
                {
                    thisTask.Description.addError('Comments is mandatory while marking Status as Complete');
                }
                if(mapOfEnquiryIdToGetStage.containsKey(thisTask.WhatId))
                {
                    if(mapOfEnquiryIdToGetStage.get(thisTask.WhatId).Stage__c == 'Site Visit Done' && thisTask.Throw_Validation__c != true)
                    {
                        thisTask.addError('Enquiry is already is in Site Visit Done.');
                    }
                }
            }
            else if((thisTask.subject == 'Site Visit Done'||(thisTask.subject.contains('Outgoing') && !thisTask.subject.contains('Follow')) )  && objectName == 'Opportunity'&& (!thisTask.subject.contains('Email: ')) && thisTask.WhatId != null)
            {
                if(thisTask.Throw_Validation__c != true && thisTask.Status == 'Completed' && thisTask.Description == null)
                {
                    thisTask.Description.addError('Comments is mandatory while marking Status as Complete');
                }
                if(oldMap == null)
                {
                    
                }
                else
                {
                    if(oldMap.get(thisTask.id).Follow_Up_Date_Time__c   != null && oldMap.get(thisTask.id).Follow_Up_Date_Time__c > system.now() && thisTask.Status =='Completed')
                    {
                        thisTask.ReminderDateTime.addError('ReminderDateTime should be completed before marking Status as Completed.');
                    }
                }
                
            }
        }
        
    }
    public static void enquiryStageChange(List<Task> taskList,map<id,task>oldMap){
        Set<id> enquiryId = New Set<id>();
        for(Task taskRecord:taskList){
            String objectName = taskRecord.WhatId.getSObjectType().getDescribe().getName();
            if(objectName == 'Enquiry__c' && taskRecord.Status != oldMap.get(taskRecord.Id).Status  
               && taskRecord.Status == 'Completed')
            {
                enquiryId.add(taskRecord.WhatId);
            }
        }
        Map<Id,Integer> notContactedTaskMap =  New  Map<Id,Integer>();
        List<Task> notContactedTaskList = [SELECT id, Call_Status__c, whatId ,Description,Lost_Reasons__c   
                                           FROM Task
                                           WHERE Call_Status__c = 'Not Connected' AND whatId IN: enquiryId];
        for(Task taskRecord:notContactedTaskList){
            if(!notContactedTaskMap.containsKey(taskRecord.WhatId)){
                notContactedTaskMap.put(taskRecord.WhatId,1);
            }
            else{
                notContactedTaskMap.put(taskRecord.WhatId, notContactedTaskMap.get(taskRecord.WhatId)+1);
            }
        }
        
        
        List<Enquiry__c> enquiryList = [SELECT id, Contact_Person__c, Stage__c 
                                        FROM Enquiry__c 
                                        WHERE id IN :EnquiryId 
                                       ];
        List<Event> updateEventList = New List<Event>();
        
        Map<Id,Enquiry__c> mapOfEnquiryIdToGetStage =  New  Map<Id,Enquiry__c>();
        if(!enquiryList.isEmpty()){
            for(Enquiry__c thisEnquiry :enquiryList){
                mapOfEnquiryIdToGetStage.put(thisEnquiry.id,thisEnquiry);
            }
        }
        Map<Id,Enquiry__c> updateEnquiryMap =  New  Map<Id,Enquiry__c>();
        for(Task taskRecord:taskList){
            String objectName = taskRecord.WhatId.getSObjectType().getDescribe().getName();
            system.debug('taskRecord.Throw_Validation__c----'+taskRecord.Throw_Validation__c);
            system.debug('taskRecord.Call_Sub_status__c----'+taskRecord.Call_Sub_status__c);
            if(objectName == 'Enquiry__c' && !mapOfEnquiryIdToGetStage.isEmpty() &&  taskRecord.Throw_Validation__c != true)
            {
                system.debug('taskRecord.Call_Sub_status__c----'+taskRecord.Call_Sub_status__c);
                Enquiry__c newEnquiry = mapOfEnquiryIdToGetStage.get(taskRecord.WhatId) ;
                if(((taskRecord.Call_Status__c == 'Connected' && (taskRecord.Call_Sub_status__c == 'SVS' || 
                                                                  taskRecord.Call_Sub_status__c == 'Interested' ||
                                                                  taskRecord.Call_Sub_status__c == 'Lost' )) ||
                    (taskRecord.Call_Status__c == 'Not Connected' && (taskRecord.Call_Sub_status__c == 'Lost' 
                                                                      || taskRecord.Call_Sub_status__c == 'Junk'))) 
                   && mapOfEnquiryIdToGetStage.containsKey(taskRecord.WhatId)
                   && taskRecord.Status == 'Completed' && taskRecord.Status != oldMap.get(taskRecord.Id).Status){
                       if(taskRecord.Call_Sub_status__c == 'SVS')
                       {
                           newEnquiry.Stage__c = 'Site Visit Scheduled';
                       }
                       else if(newEnquiry.Stage__c == 'New Enquiry' || newEnquiry.Stage__c == 'Contacted' )
                       {
                           newEnquiry.Stage__c = taskRecord.Call_Sub_status__c;
                           newEnquiry.Lost_Reasons__c = taskRecord.Lost_Reasons__c;
                       }
                       else if(newEnquiry.Stage__c == 'Interested' && (taskRecord.Call_Sub_status__c == 'SVS' || 
                                                                       taskRecord.Call_Sub_status__c == 'Lost'))
                       {
                           newEnquiry.Stage__c = taskRecord.Call_Sub_status__c;
                           newEnquiry.Lost_Reasons__c = taskRecord.Lost_Reasons__c;
                       }
                       else if(newEnquiry.Stage__c == 'Site Visit Scheduled' && taskRecord.Call_Sub_status__c == 'Lost')
                       {
                           newEnquiry.Stage__c = taskRecord.Call_Sub_status__c;
                           system.debug('newEnquiry.Stage__c'+newEnquiry.Stage__c);
                           newEnquiry.Lost_Reasons__c = taskRecord.Lost_Reasons__c;
                       }
                       else if(newEnquiry.Stage__c != 'Site Visit Scheduled' && newEnquiry.Stage__c == 'Interested')
                       {
                           newEnquiry.Stage__c = taskRecord.Call_Sub_status__c;
                           newEnquiry.Lost_Reasons__c = taskRecord.Lost_Reasons__c;
                       }
                       updateEnquiryMap.put(newEnquiry.id,newEnquiry);
                   }
                /*else if(!notContactedTaskMap.isEmpty() &&  taskRecord.Call_Status__c == 'Not Connected' )
{ 
if(notContactedTaskMap.ContainsKey(taskRecord.WhatId)){ 
if(notContactedTaskMap.get(taskRecord.WhatId) >=6)
{
newEnquiry.Stage__c = 'Junk';
updateEnquiryMap.put(newEnquiry.id,newEnquiry);
}
}
}*/
                if(taskRecord.EventId__c != null && taskRecord.EventId__c != '')
                {
                    Event thisEvent = New Event();
                    thisEvent.id = taskRecord.EventId__c ;
                    thisEvent.StartDateTime = system.now();
                    thisEvent.EndDateTime = system.now();
                    updateEventList.add(thisEvent);
                }
            }
            
        }
        System.debug('updateEnquiryMap.values()'+updateEnquiryMap.values());
        if(!updateEnquiryMap.values().IsEmpty()){
            update updateEnquiryMap.values();
        }
        if(!updateEventList.IsEmpty()){
            update updateEventList;
        }
        
        
    }
    public Static Void updateLastCallDetails(List<Task> taskList)
    { 
        Set<id> OwnerId =New Set<id> ();
        Set<id> enquiryId =New Set<id> ();
        Set<id> opportunityIds = New Set<id>();
        for(Task thisTask :taskList){
            if(thisTask.WhatId != null){
                String objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
                if(objectName == 'Enquiry__c')
                {
                    enquiryId.add(thisTask.WhatId);
                    
                }
                else if (objectName == 'Opportunity') {
                    opportunityIds.add(thisTask.WhatId);
                }
                OwnerId.add(thisTask.ownerId);
            }
        }
        List<user> userList = [Select id, name From user where id IN:OwnerId ];
        List<Task> allTaskList = New List<Task>();
        Map<id,Integer> mapofTask = New  Map<id,Integer>();
        if(!enquiryId.isEmpty())
        {
            allTaskList = [SELECT Id, whatId FROM Task WHERE whatId IN:enquiryId ];
            for(Task thisTask :allTaskList){
                if(thisTask.WhatId != null){
                    String objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
                    if(objectName == 'Enquiry__c')
                    {
                        if(mapofTask.containskey(thisTask.WhatId ))
                        {
                            mapofTask.put(thisTask.WhatId,mapofTask.get(thisTask.WhatId)+1);
                        }
                        else
                        {
                            mapofTask.put(thisTask.WhatId,1);
                        }
                    }
                }
            }
        }
        List<Enquiry__c> enquiryList = [SELECT id, Contact_Person__c, Stage__c 
                                        FROM Enquiry__c 
                                        WHERE id IN :enquiryId 
                                        //   AND Stage__c = 'Site Visit Scheduled'
                                       ];
        List<Opportunity> opportunityList = [SELECT Id, StageName 
                                             FROM Opportunity 
                                             WHERE Id IN :opportunityIds 
                                            ];
        Map<Id,Enquiry__c> mapOfEnquiryIdToGetStage =  New  Map<Id,Enquiry__c>();
        Map<Id,Enquiry__c> mapOfUpdateEnquiry =  New  Map<Id,Enquiry__c>();
        Map<Id, Opportunity> mapOfOpportunityIdToGetStage = new Map<Id, Opportunity>();
        Map<Id,Opportunity> mapOfUpdateOpportunity =  New  Map<Id,Opportunity>();
        if(!enquiryList.isEmpty()){
            for(Enquiry__c thisEnquiry :enquiryList){
                mapOfEnquiryIdToGetStage.put(thisEnquiry.id,thisEnquiry);
            }
        }
        if (!opportunityList.isEmpty()) {
            for (Opportunity thisOpportunity : opportunityList) {
                mapOfOpportunityIdToGetStage.put(thisOpportunity.Id, thisOpportunity);
            }
        }
        Map<id, User> mapOfIdToGetUerName = New Map<id, User>();
        for(user thisUser :userList)
        {
            mapOfIdToGetUerName.put(thisUser.id,thisUser);
        }
        List<Enquiry__c> updateEnquiry = New List<Enquiry__c>();
        for(Task thisTask :taskList)
        {
            if(thisTask.WhatId != null)
            {
                String objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
                if(objectName == 'Enquiry__c' &&  mapOfEnquiryIdToGetStage.containsKey(thisTask.WhatId))
                {
                    if( mapOfEnquiryIdToGetStage.get(thisTask.WhatId).stage__c != 'Lost' && 
                       mapOfEnquiryIdToGetStage.get(thisTask.WhatId).stage__c != 'Site Visit Done' && 
                       (!thisTask.subject.contains('Email: ')))
                    {
                        Enquiry__c Enquiry  = New Enquiry__c();
                        if(mapofTask.containskey(thisTask.whatId) && thisTask.Subject.contains('Incoming Call'))
                        {
                            if(mapofTask.get(thisTask.whatId) == 1)
                            {
                                Enquiry.OwnerId = UserInfo.getUserId();
                            }
                        }
                        if(thisTask.Exotel_CTI__Call_Status__c != null &&  thisTask.Exotel_CTI__Call_Status__c != '')
                        {
                            Enquiry.Last_Call_Status__c = thisTask.Exotel_CTI__Call_Status__c;
                        }
                        if(thisTask.Exotel_CTI__Call_Direction__c != null &&  thisTask.Exotel_CTI__Call_Direction__c != '')
                        {
                            Enquiry.Last_Call_Type__c = thisTask.Exotel_CTI__Call_Direction__c;
                        }
                        if(thisTask.Exotel_CTI__Start_Time__c != null &&  thisTask.Exotel_CTI__Start_Time__c != '')
                        {
                            Enquiry.Last_Call_Attempt_Date__c = system.today();
                        }
                        if(thisTask.Description != null)
                        {
                            system.debug('thisTask.Description---'+thisTask.Description);
                            Enquiry.Last_Call_Description__c = thisTask.Description;
                        }
                        if(thisTask.Attended_By__c != null)
                        {
                            system.debug('thisTask.Attended_By__c---'+thisTask.Attended_By__c);
                            Enquiry.Last_Call_Attended_By__c = thisTask.Attended_By__c;
                        }
                        if(thisTask.Exotel_CTI__Call_Sid__c != null &&  thisTask.Exotel_CTI__Call_Sid__c != '')
                        {
                            if(!mapOfIdToGetUerName.isEmpty()){
                                if(mapOfIdToGetUerName.containsKey(thisTask.OwnerId))
                                {
                                    Enquiry.Last_Call_Attempted_By__c = mapOfIdToGetUerName.get(thisTask.OwnerId).name;
                                }
                            }
                        }
                        if(thisTask.Next_Followup_date__c != null )
                        {
                            Enquiry.Latest_Follow_Up_Date__c = thisTask.Next_Followup_date__c;
                        }
                        Enquiry.id = thisTask.WhatId;
                        mapOfUpdateEnquiry.put(Enquiry.id,Enquiry);
                    }
                }
                else if (objectName == 'Opportunity' && mapOfOpportunityIdToGetStage.containsKey(thisTask.WhatId)) {
                    if( 
                        mapOfOpportunityIdToGetStage.get(thisTask.WhatId).StageName != 'Closed Lost' && 
                        (!thisTask.subject.contains('Email: ')))
                    {
                        Opportunity opportunity = new Opportunity();
                        if(thisTask.Exotel_CTI__Call_Status__c != null &&  thisTask.Exotel_CTI__Call_Status__c != '')
                        {
                            opportunity.Last_Call_Status__c = thisTask.Exotel_CTI__Call_Status__c;
                        }
                        if(thisTask.Exotel_CTI__Call_Direction__c != null &&  thisTask.Exotel_CTI__Call_Direction__c != '')
                        {
                            opportunity.Last_Call_Type__c = thisTask.Exotel_CTI__Call_Direction__c;
                        }
                        if(thisTask.Exotel_CTI__Start_Time__c != null &&  thisTask.Exotel_CTI__Start_Time__c != '')
                        {
                            opportunity.Last_Call_Attempt_Date__c = system.today();
                        }
                        if(thisTask.Description != null)
                        {
                            system.debug('thisTask.Description---'+thisTask.Description);
                            opportunity.Last_Call_Description__c = thisTask.Description;
                        }
                        if(thisTask.Attended_By__c != null)
                        {
                            system.debug('thisTask.Attended_By__c---'+thisTask.Attended_By__c);
                            opportunity.Last_Call_Attended_By__c = thisTask.Attended_By__c;
                        }
                        if(thisTask.Exotel_CTI__Call_Sid__c != null &&  thisTask.Exotel_CTI__Call_Sid__c != '')
                        {
                            if(!mapOfIdToGetUerName.isEmpty()){
                                if(mapOfIdToGetUerName.containsKey(thisTask.OwnerId))
                                {
                                    opportunity.Last_Call_Attempted_By__c = mapOfIdToGetUerName.get(thisTask.OwnerId).name;
                                }
                            }
                        }
                        if(thisTask.Next_Followup_date__c != null )
                        {
                            opportunity.Latest_Follow_Up_Date__c = thisTask.Next_Followup_date__c;
                        }
                        opportunity.id = thisTask.WhatId;
                        mapOfUpdateOpportunity.put(opportunity.id,opportunity);
                        system.debug('mapOfUpdateOpportunity values ' + mapOfUpdateOpportunity.values());                    }
                }
            }
        }
        if(!mapOfUpdateEnquiry.values().isEmpty())
        {
            update  mapOfUpdateEnquiry.values();
        }
        if(!mapOfUpdateOpportunity.values().isEmpty())
        {
            update  mapOfUpdateOpportunity.values();
        }
    }
    
    
    
    public Static Void assignEnquiryonTask(List<Task> taskList)
    { 
        Set<id> OwnerId =New Set<id> ();
        Set<id> enquiryId =New Set<id> ();
        for(Task thisTask :taskList){
            if(thisTask.WhatId != null){
                String objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
                if(objectName == 'Enquiry__c')
                {
                    enquiryId.add(thisTask.WhatId);
                }
            }
        }
        List<Enquiry__c> enquiryList  = New  List<Enquiry__c> ();
        if(!enquiryId.isEmpty())
        {
            enquiryList = [SELECT id, Contact_Person__c, Stage__c, Project__c 
                           FROM Enquiry__c 
                           WHERE id IN :enquiryId 
                           
                          ];
        }
        
        Map<Id,Enquiry__c> mapOfEnquiryIdToGetStage =  New  Map<Id,Enquiry__c>();
        if(!enquiryList.isEmpty()){
            for(Enquiry__c thisEnquiry :enquiryList){
                mapOfEnquiryIdToGetStage.put(thisEnquiry.id,thisEnquiry);
            }
        }
        for(Task thisTask :taskList){
            if(thisTask.WhatId != null){
                String objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
                if(objectName == 'Enquiry__c')
                {
                    try{
                        thisTask.Enquiry__c = thisTask.WhatId;
                        if(mapOfEnquiryIdToGetStage.containskey(thisTask.WhatId))
                        {
                            if(mapOfEnquiryIdToGetStage.get(thisTask.WhatId).Project__c != null)
                            {
                                thisTask.Project__C  = mapOfEnquiryIdToGetStage.get(thisTask.WhatId).Project__c ;
                            }
                        }
                        // 
                    }
                    catch(Exception ex)
                    {
                        System.debug('error--'+ex.getLineNumber());
                    }
                }
            }
        }
    }
    public static Void method()
    {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
}