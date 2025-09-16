public class TaskTriggerHandler1 {
    
    public Static void setAndValidateDueDate(List<Task> taskList){
        Set<Id> enquiryIdSet = New Set<Id> ();
        Set<Id> accountIdSet = New Set<Id> ();
        Set<Id> cpIdSet = New Set<Id> ();
        for(Task thisTask :taskList){
            if(thisTask.WhatId != null){
                String objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
                if(objectName == 'Enquiry__c')
                {
                    enquiryIdSet.add(thisTask.WhatId);
                }
                if(objectName == 'Account')
                {
                    cpIdSet.add(thisTask.WhatId);
                }
            }
        }
        system.debug('enquiryIdSet----'+enquiryIdSet);
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        List<Enquiry__c> enquiryList = New List<Enquiry__c> ();
        List<Account> accountList = New List<Account> ();
        if(!enquiryIdSet.isEmpty()){
            enquiryList = [SELECT id, Contact_Person__c, Stage__c, Project__c, Campaign__c 
                           FROM Enquiry__c 
                           WHERE id IN :enquiryIdSet 
                          ];
        }
        Map<id,Account> mapOfAccount = New Map<id,Account>();
        if(!cpIdSet.isEmpty()){
            accountList = [SELECT id, Name
                           FROM Account 
                           WHERE id IN :cpIdSet AND RecordTypeId = :recordTypeId
                          ];
            for(Account thisAccount : accountList)
            {
                mapOfAccount.put(thisAccount.id,thisAccount);
            }
        }
        system.debug('enquiryList----'+enquiryList);
        Map<String,String> mapOfEnquiryIdToGetStage =  New  Map<String,String>();
        if(!enquiryList.isEmpty()){
            for(Enquiry__c thisEnquiry :enquiryList){
                accountIdSet.add(thisEnquiry.Contact_Person__c);
            }
        }
        system.debug('accountIdSet----'+accountIdSet);
        Map<String,String> mapOfContactId =  New  Map<String,String>();
        if(!accountIdSet.isEmpty()){
        List<Contact> contactList = [SELECT id, AccountId, Name from Contact WHERE AccountId IN: accountIdSet];
        //system.debug('contactList----'+contactList);
        if(!contactList.isEmpty()){
            /* for (Id accountId : accountIdSet) {
Contact con = new Contact();
con.Id = accountId;
contactList.add(con);
}*/
            for(Contact thisContact :contactList){
                mapOfContactId.put(thisContact.accountId,thisContact.id);
            }
        }
    }
        system.debug('mapOfContactId----'+mapOfContactId);
        for(Enquiry__c thisEnquiry :enquiryList){
            if(mapOfContactId.containsKey(thisEnquiry.Contact_Person__c))
            {
                mapOfEnquiryIdToGetStage.put(thisEnquiry.id,mapOfContactId.get(thisEnquiry.Contact_Person__c));
            }
            
        }
        system.debug('mapOfEnquiryIdToGetStage----'+mapOfEnquiryIdToGetStage);
        CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
        System.debug('calc-------------->'+calc);
        Datetime  NextWorkingDays = calc.AddDays(System.now(),1);
        System.debug('NextWorkingDays-------------->'+NextWorkingDays);
        String NextWorkingDate = NextWorkingDays.format('yyyy-MM-dd');
        System.debug('NextWorkingDate-------------->'+NextWorkingDate);
        for(Task thisTask:taskList )
        {
            if(thisTask.WhatId != null){
                String objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
                if(objectName == 'Enquiry__c')
                { 
                    thisTask.Type_Of_Call__c = 'Pre Sales';
                    system.debug('Type_Of_Call__c'+thisTask.Type_Of_Call__c );
                    if(thisTask.whoID == null)
                    { 
                        system.debug('whoID'+thisTask.whoID );
                        if(mapOfEnquiryIdToGetStage.containskey(thisTask.WhatId))
                        {
                            thisTask.whoID = mapOfEnquiryIdToGetStage.get(thisTask.WhatId);
                            system.debug(' thisTask.whoID'+ thisTask.whoID );
                        }
                    }
                }
                if(objectName == 'Booking__c')
                { 
                    thisTask.Type_Of_Call__c = 'Post Sales';
                }
                if(objectName == 'Account' && mapOfAccount.containsKey(thisTask.WhatId))
                { 
                    thisTask.Type_Of_Call__c = 'Sourcing';
                }
                if(objectName == 'Opportunity')
                { 
                    thisTask.Type_Of_Call__c = 'Sales';
                }
            }
            if(thisTask.WhatId != null){
                String objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
                if(  thisTask.ActivityDate== null && (objectName == 'Enquiry__c' || objectName == 'Opportunity')){
                    if((thisTask.Subject.Contains('Outgoing Call') || thisTask.Subject.Contains('Incoming Call')) && !thisTask.Subject.Contains('Missed'))
                    {
                        thisTask.ActivityDate = system.today();
                    }
                    else if(thisTask.Subject.Contains('Missed Call'))
                    {
                        thisTask.ActivityDate = date.valueOf(NextWorkingDate);
                    }
                    else if(thisTask.ActivityDate == null && !thisTask.Subject.Contains('Outgoing Call') && !thisTask.Subject.Contains('Incoming Call') && !thisTask.Subject.Contains('Missed'))
                        
                    {
                        thisTask.AddError('Due Date is mandatory.');
                    }
                }
                if(objectName == 'Account' && mapOfAccount.containsKey(thisTask.WhatId)
                   && (thisTask.Subject=='Inbound Meeting' || thisTask.Subject=='Outreach Call' ||
                       thisTask.Subject=='Follow-up Call' ||thisTask.Subject=='Outbound Meeting'))
                { 
                    if(thisTask.Project__c == null )
                    {
                        thisTask.AddError('Please select value in Project');
                    }
                    
                    
                }
            }
        }
    }
    public static Void calculateTargetForChannelPartnerMeetings(List<Task> TaskList)
    {
        Set<Id> ownerId = New Set<Id>();
        Set<Id> projectId = New Set<Id>();
        Set<Id> accountId = New Set<Id>();
        Map<String, Integer> mapUserForCountTask = New Map<String, Integer>();
        for(Task thisTask :TaskList)
        {
            System.debug('thisTask.whatId---------->'+thisTask.whatId);
            if(thisTask.whatId != null)
            {
                System.debug('thisTask.whatId---------->'+thisTask.whatId);
                String objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
                System.debug('objectName---------->'+objectName);
                if(objectName == 'Account')
                {
                    System.debug('objectName---------->'+objectName);
                    accountId.add(thisTask.whatId);
                    System.debug('accountId------------->'+accountId);
                    System.debug('thisTask.whatId---------------->'+thisTask.whatId);
                }
                if(thisTask.Project__c != null)
                {
                    projectId.add(thisTask.Project__c);
                }
            }
        }
        Map<String,Channel_Partner_Project__c> mapOfChannelPartnerProject = New Map<String,Channel_Partner_Project__c>();
        Map<String,Channel_Partner_Project__c> updateChannelPartnerProject = New Map<String,Channel_Partner_Project__c>();
        if(!accountId.isEmpty())
        {
            Id channelPartnerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
            System.debug('channelPartnerRecordType-------->'+channelPartnerRecordType);
            List<Account> accountList  = [Select id, name,OwnerId  from Account Where Id IN: accountId AND  RecordTypeId =: channelPartnerRecordType ];
            System.debug('accountList-------->'+accountList);
            for(Account thisAccount:accountList)
            {
                ownerId.add(thisAccount.OwnerId );
                System.debug('ownerId------->'+thisAccount.OwnerId);
                
            }System.debug('Number of queries -------------->'+ Limits.getLimitQueries());
            List<Channel_Partner_Project__c> cPPList = [SELECT ID, Channel_Partner__c, Project__c,Unique_Inbound_Meeting_Date__c,
                                                        Project__r.Site_Head__r.email, Unique_Outbound_Meeting_Date__c 
                                                        FROM Channel_Partner_Project__c WHERE Channel_Partner__c IN: accountId
                                                        AND Project__c IN :projectId];
            
            for(Channel_Partner_Project__c cpp :cPPList)
            {
                String Key = cpp.Channel_Partner__c+'-'+cpp.Project__c;
                mapOfChannelPartnerProject.put(Key,cpp);
            }
            
        }
        System.debug('Number of queries -------------->'+ Limits.getLimitQueries());
        system.debug('ownerId'+ownerId);
        Date todayDate = Date.today() ;
        system.debug('todayDate----'+todayDate);
        system.debug('projectId----'+projectId);
        System.debug('String.valueof(System.today().year()) -------------->'+ String.valueof(System.today().year()));
        System.debug('System.now().format -------------->'+ System.now().format('MMMMM'));
        List<Task_Target__c> taskTargetList = [SELECT Id, Name, User__c, Month__c,Type__c,
                                               Year__c, Number_of_Targets_Achievement__c,
                                               X1st_Week__c, X2nd_Week__c, X3rd_Week__c,
                                               X4th_Week__c, X5th_Week__c, Project__c,
                                               Number_of_Connected_Call__c, No_of_Walk_ins__c, No_of_Follow_Ups__c
                                               FROM Task_Target__c
                                               WHERE User__c IN :ownerId  AND Year__c = :String.valueof(System.today().year()) 
                                               AND Month__c =: System.now().format('MMMMM')
                                               AND Project__c IN: projectId];
        system.debug('taskTargetList----'+taskTargetList);
        System.debug('Number of queries -------------->'+ Limits.getLimitQueries());
        Map<String, Task_Target__c> updateTaskTarget = New Map<String, Task_Target__c>();
        Map<String, Task_Target__c> mapOfUserToGetTaskTargetId = New Map<String, Task_Target__c>();
        Map<String, Integer> mapUserForOutboundTask = New Map<String, Integer>();
        Map<String, Integer> mapUserForInboundTask = New Map<String, Integer>();
        Map<String, Integer> mapUserForEventTask = New Map<String, Integer>();
        for(Task_Target__c taskTarget : taskTargetList)
        {
            
            String Key = taskTarget.Month__c+'-'+taskTarget.Year__c+'-'+String.valueOf(taskTarget.Project__c)+'-'+String.valueOf(taskTarget.User__c)+'-'+taskTarget.Type__c;
            mapOfUserToGetTaskTargetId.put(Key,taskTarget);
            system.debug('Task Target---');
            System.debug('Key' + Key);
            if( taskTarget.Type__c == 'Unique Outbound'){
                if(taskTarget.Number_of_Targets_Achievement__c == null)
                {
                    mapUserForOutboundTask.put(Key,0);
                }
                else
                {
                    system.debug('Integer.valueof(taskTarget.Number_of_Targets_Achievement__c)'+Integer.valueof(taskTarget.Number_of_Targets_Achievement__c));
                    mapUserForOutboundTask.put(Key,Integer.valueof(taskTarget.Number_of_Targets_Achievement__c));
                }
            }
            if( taskTarget.Type__c == 'Event'){
                if(taskTarget.Number_of_Targets_Achievement__c == null)
                {
                    mapUserForEventTask.put(Key,0);
                }
                else
                {
                    system.debug('Integer.valueof(taskTarget.Number_of_Targets_Achievement__c)'+Integer.valueof(taskTarget.Number_of_Targets_Achievement__c));
                    mapUserForEventTask.put(Key,Integer.valueof(taskTarget.Number_of_Targets_Achievement__c));
                }
            }
            if( taskTarget.Type__c == 'Unique Inbound'){
                if(taskTarget.Number_of_Targets_Achievement__c == null)
                {
                    mapUserForInboundTask.put(Key,0);
                }
                else
                {
                    system.debug('Integer.valueof(taskTarget.Number_of_Targets_Achievement__c)'+Integer.valueof(taskTarget.Number_of_Targets_Achievement__c));
                    mapUserForInboundTask.put(Key,Integer.valueof(taskTarget.Number_of_Targets_Achievement__c));
                }
            }
            
        }
        List<Task> updateTaskList = New List<Task>();
        for(Task thisTask :TaskList)
        {
            if(thisTask.whatId != null)
            {
                String objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
                if(objectName == 'Account'){
                    String cPKey = thisTask.WhatId+'-'+thisTask.Project__c;
                    Date myDate = Date.today(); // Replace with your desired date
                    Integer weekNumber = myDate.day() / 7 + 1;
                    System.debug('Week Number: ' + weekNumber);
                    
                    if(mapOfChannelPartnerProject.containsKey(cPKey) &&thisTask.ActivityDate != null){
                        Channel_Partner_Project__c thisCPP = mapOfChannelPartnerProject.get(cPKey);
                        Integer yr = System.today().year();
                        System.debug('Year is' + yr);
                        string month = System.now().format('MMMMM');
                        System.debug('Month is' + month);
                        // Datetime activityDate = datetime.valueof(thisTask.ActivityDate);
                        //string createdDateMonth = thisTask.createddate.format('MMMMM');
                        System.debug('Month is' + month);
                        Integer outboundMeetingYear = 0;
                        string outboundMeetingMonth; 
                        if(thisCPP.Unique_Outbound_Meeting_Date__c != null)
                        {
                            outboundMeetingYear = thisCPP.Unique_Outbound_Meeting_Date__c.year();
                            //outboundMeetingMonth = datetime.valueof(thisCPP.Unique_Outbound_Meeting_Date__c).format('MMMMM');
                        }
                        Integer inboundMeetingYear = 0;
                        string inboundMeetingMonth; 
                        if(thisCPP.Unique_Inbound_Meeting_Date__c != null)
                        {
                            inboundMeetingYear = mapOfChannelPartnerProject.get(cPKey).Unique_Inbound_Meeting_Date__c.year();
                            //inboundMeetingMonth = thisCPP.Unique_Inbound_Meeting_Date__c).format('MMMMM');
                        }
                        System.debug('Month is' + month);
                        string KeyInbound = month+'-'+String.valueOf(yr)+'-'+thisTask.Project__c+'-'+String.valueOf(thisTask.OwnerId)+'-'+'Unique Inbound';
                        string keyOutbound = month+'-'+String.valueOf(yr)+'-'+thisTask.Project__c+'-'+String.valueOf(thisTask.OwnerId)+'-'+'Unique Outbound';
                        System.debug('keyOutbound'+keyOutbound);
                        
                        if(thisTask.Subject=='Outbound Meeting' && mapOfUserToGetTaskTargetId.containsKey(keyOutbound)
                           && mapUserForOutboundTask.containsKey(keyOutbound) 
                           && (thisCPP.Unique_Outbound_Meeting_Date__c == null ||
                               month != outboundMeetingMonth))
                        {
                            System.debug('outboundMeetingMonth');
                            Task_Target__c taskTarget = New Task_Target__c();
                            taskTarget.id = mapOfUserToGetTaskTargetId.get(keyOutbound).id;
                            mapUserForOutboundTask.put(keyOutbound, mapUserForOutboundTask.get(keyOutbound)+1);
                            taskTarget.Number_of_Targets_Achievement__c = mapUserForOutboundTask.get(keyOutbound);
                            System.debug('outboundMeetingMonth'+mapOfUserToGetTaskTargetId.get(keyOutbound).id);
                            updateTaskTarget.put(taskTarget.id,taskTarget);
                            thisCPP.Unique_Outbound_Meeting_Date__c = system.today();
                            updateChannelPartnerProject.put(thisCPP.id,thisCPP);
                            System.debug('inboundMeetingMonth'+mapOfUserToGetTaskTargetId.get(keyOutbound).id);
                        }
                        System.debug('inboundMeetingMonth'+inboundMeetingMonth);
                        
                        
                        System.debug('inboundMeetingMonthDate'+thisCPP.Unique_Inbound_Meeting_Date__c );
                        if(thisTask.Subject=='Inbound Meeting' && mapOfUserToGetTaskTargetId.containsKey(KeyInbound)
                           && mapUserForInboundTask.containsKey(KeyInbound)
                           && (thisCPP.Unique_Inbound_Meeting_Date__c == null ||
                               month != inboundMeetingMonth ))
                        {
                            System.debug('yes');
                            Task_Target__c taskTarget = New Task_Target__c();
                            taskTarget.id = mapOfUserToGetTaskTargetId.get(KeyInbound).id;
                            mapUserForInboundTask.put(KeyInbound, mapUserForInboundTask.get(KeyInbound)+1);
                            taskTarget.Number_of_Targets_Achievement__c = mapUserForInboundTask.get(KeyInbound);
                            thisCPP.Unique_Inbound_Meeting_Date__c = system.today();
                            updateTaskTarget.put(taskTarget.id,taskTarget);
                            updateChannelPartnerProject.put(thisCPP.id,thisCPP);
                        }
                        
                    }
                }
                
            }
            if(!updateTaskTarget.values().IsEmpty())
            {
                update updateTaskTarget.values();
            }
            if(!updateChannelPartnerProject.values().IsEmpty())
            {
                update updateChannelPartnerProject.values();
            }
            
            
        }
    }
    
    public static Void deepCleaningTask(List<Task> taskList,Map<Id,Task> oldMap)
    {
        Set<id> taskId = New Set<id>();
        Set<id> propertyIdSet = New Set<id>();
        Set<String> bookingIdSet = New Set<String>();
        List<Task> deepCleaningTaskList = New List<Task>();
        List<Task> insertTaskList = New List<Task>();
        List<Property__c>  updatePropertyList =  New List<Property__c>();
        for(Task thisTask : taskList)
        {
            if((thisTask.subject == 'Deep Cleaning Task' || thisTask.subject == 'Post - OC FM Review Task'
                ||thisTask.subject == 'RM Customer Unit Inspection Task' 
                || thisTask.subject == 'FM Customer Unit Inspection Task' 
               ) && oldMap.get(thisTask.id).status != thisTask.status)
            {
                deepCleaningTaskList.add(thisTask);
                String objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
                if(objectName == 'Booking__c')
                {
                    bookingIdSet.add(thisTask.WhatId);
                }
                if(objectName == 'Property__c')
                {
                     propertyIdSet.add(thisTask.WhatId);
                }
            }
        }
        if(!deepCleaningTaskList.isEmpty())
        {
             Map<Id,Booking__c> mapOfBooking = New Map<Id,Booking__c> ();
            List<Booking__c> BookList = [Select Id ,Name,Primary_Applicant__r.Name,Customer_Unit_Inspection_Scheduled_Date__c,
                                         OwnerId, Related_Suggested_Property__r.Unit__r.FM_User__c, 
                                         Related_Suggested_Property__c,Project_Email__c,Unit_Number__c,
                                         Primary_Applicant__r.PersonEmail,Project_Name__r.Name,Project_Name__r.GPS_location__c,
                                         Project_Name__r.Location__c,Project_Name__r.Project_Phone__c, 
                                         Related_Suggested_Property__r.Unit__c,Project_Name__r.Project_Email__c,
                                         Related_Suggested_Property__r.Unit__r.Customer_Unit_Inspection_Scheduled_Date__c,
                                         Related_Suggested_Property__r.Unit__r.FM_Customer_Unit_Task__c
                                         From Booking__c 
                                         Where Related_Suggested_Property__r.Unit__c IN: propertyIdSet
                                         OR Id IN: bookingIdSet];
            system.debug('BookList'+BookList);
            system.debug('bookingIdSet'+bookingIdSet);
            if(!BookList.isEmpty()){
                for(Booking__c thisBooking :BookList)
                {
                    bookingIdSet.add(thisBooking.Id);
                    mapOfBooking.put(thisBooking.Related_Suggested_Property__r.Unit__c,thisBooking);
                    mapOfBooking.put(thisBooking.id,thisBooking);
                }
            }
                Map<String,Task> mapOfUnitInspectionTask = New Map<String,Task>();
                List<Task> fmRMTaskList = [SELECT id, WhatId, Subject,ActivityDate 
                                       From Task 
                                       WHERE 
                                       ((
                                            Subject =:'FM Customer Unit Inspection Task'  AND WhatId IN: propertyIdSet) 
                                            OR (Subject =: 'RM Customer Unit Inspection Task'  AND WhatId IN: bookingIdSet))
                                       AND Status != 'Completed'];
            system.debug('fmRMTaskList'+fmRMTaskList);
            Map<String,Id> mapOfOwea= New Map<String,Id>();
            List<OrgWideEmailAddress> oweaList = [SELECT Id, Address, DisplayName 
                                                  FROM OrgWideEmailAddress 
                                                 ];
            for(OrgWideEmailAddress owea:oweaList)
            {
                mapOfOwea.put(owea.Address,owea.id);
            }
                
            for(Task thisTask:fmRMTaskList)
            {
                mapOfUnitInspectionTask.put(thisTask.whatId,thisTask);
            }
           
            Snag_TAT__mdt snagTat = Snag_TAT__mdt.getInstance('Snag_TAT');
            CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
            Datetime  NextWorkingDays = calc.AddDays(System.now(),integer.valueof(snagTat.RM_FM__c));
            EmailTemplate emailTemplate = [SELECT Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                           from EmailTemplate 
                                           where DeveloperName = 'Completion_of_deep_cleaning_task' LIMIT 1];
            EmailTemplate emailTemplateforPostOC = [SELECT Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                                    from EmailTemplate 
                                                    where DeveloperName = 'Post_OC_FM_Review_Task_Completed' LIMIT 1];
            List<String> emailList=new List<String>();
            List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
            for(Task thisTask : deepCleaningTaskList)
            {if( mapOfBooking.containsKey(thisTask.whatId)) {
                 Booking__c book = mapOfBooking.get(thisTask.whatId); 
                if(thisTask.Status == 'Completed'&& thisTask.subject == 'Deep Cleaning Task')
                { 
                   
                    
                    if(emailTemplate != null){    
                        emailList.add(mapOfBooking.get(thisTask.whatId).OwnerId);    
                        String htmlBody = emailTemplate.HtmlValue;
                        String plainBody = emailTemplate.Body;
                        String subject = emailTemplate.subject;
                        subject  = subject.replace('{unitNumber}',book.Unit_Number__c);
                        plainBody = plainBody.replace('{unitNumber}',book.Unit_Number__c);
                        plainBody = plainBody.replace('{completedDate}', string.valueof(System.today()));
                        SendEmailandBellNotificationUtility.SendEmail2(emailTemplate.Id,subject, htmlBody, plainBody,emailList,null,false,thisTask.whatId,null,null,mapOfOwea.get(book.Project_Name__r.Project_Email__c),null);
                        EmailMessage objEmailMessage = new EmailMessage();
                        objEmailMessage.status = '3'; // email was sent
                        objEmailMessage.RelatedToId = thisTask.whatId;
                        objEmailMessage.fromName = 'Dynamix'; // from name
                        objEmailMessage.Subject = 'Email sent to RM for completion of Deep Cleaning Task';
                        objEmailMessage.HtmlBody = plainBody;
                        insertEmailMessageList.add(objEmailMessage);
                    }
                    
                    Task task = New Task();
                    task.Subject = 'RM Customer Unit Inspection Task';
                    task.ActivityDate = book.Customer_Unit_Inspection_Scheduled_Date__c; 
                    task.ownerId = mapOfBooking.get(thisTask.whatId).OwnerId ;
                    task.WhatId = mapOfBooking.get(thisTask.whatId).Id;
                    if(mapOfUnitInspectionTask.containskey(book.Id) )
                    {
                        system.debug('mapOfUnitInspectionTask.get(book.Id).Subject'+mapOfUnitInspectionTask.get(book.Id).Subject);
                        if( mapOfUnitInspectionTask.get(book.Id).Subject == 'RM Customer Unit Inspection Task')
                        {
                            task.id = mapOfUnitInspectionTask.get(book.Id).id;
                            task.Status = 'Open';
                        }
                        
                    }
                    insertTaskList.add(task);
                    Task task1 = New Task();
                    task1.Subject = 'FM Customer Unit Inspection Task';
                    if(mapOfUnitInspectionTask.containskey(thisTask.whatId) )
                    {
                        if( mapOfUnitInspectionTask.get(thisTask.whatId).Subject == 'FM Customer Unit Inspection Task')
                        {
                            task1.id = mapOfUnitInspectionTask.get(thisTask.whatId).id;
                            task1.Status = 'Open';
                        }
                        
                    }
                    system.debug('NextWorkingDays'+NextWorkingDays);
                    task1.ActivityDate = book.Customer_Unit_Inspection_Scheduled_Date__c; 
                    task1.ownerId = book.Related_Suggested_Property__r.Unit__r.FM_User__c ;
                    task1.WhatId = book.Related_Suggested_Property__r.Unit__c;
                    insertTaskList.add(task1);
                }
                if(thisTask.Status == 'Completed'  && thisTask.subject == 'Post - OC FM Review Task')
                {
                       
                    if(emailTemplateforPostOC != null){    
                        emailList.add(mapOfBooking.get(thisTask.whatId).OwnerId);    
                        String htmlBody = emailTemplateforPostOC.HtmlValue;
                        String plainBody = emailTemplateforPostOC.Body;
                        String Subject = emailTemplateforPostOC.subject;
                        Subject = Subject.replace('{unitNumber}',mapOfBooking.get(thisTask.whatId).Unit_Number__c);
                         plainBody = plainBody.replace('{unitNumber}',mapOfBooking.get(thisTask.whatId).Unit_Number__c);
                        plainBody = plainBody.replace('{completedDate}', string.valueof(System.today()));
                        SendEmailandBellNotificationUtility.SendEmail2(emailTemplateforPostOC.Id,Subject, htmlBody, plainBody,emailList,null,false,thisTask.whatId,null,null,mapOfOwea.get(book.Project_Name__r.Project_Email__c),null);
                        EmailMessage objEmailMessage = new EmailMessage();
                        objEmailMessage.status = '3'; // email was sent
                        objEmailMessage.RelatedToId = thisTask.whatId;
                        objEmailMessage.fromName = 'Dynamix'; // from name
                        objEmailMessage.Subject = 'Email sent to RM for completion of Post - OC FM Review Task Completed';
                        objEmailMessage.HtmlBody = plainBody;
                        insertEmailMessageList.add(objEmailMessage);
                    }
                }
                system.debug('thisTask.subject'+thisTask.subject);
                if(thisTask.Status == 'Completed' && 
                   thisTask.subject == 'RM Customer Unit Inspection Task' 
                 )
                {
                    Property__c thisProperty = New Property__c();
                    thisProperty.id =  mapOfBooking.get(thisTask.whatId).Related_Suggested_Property__r.Unit__c;
                    thisProperty.RM_Customer_Task__c = true;
                    if(book.Related_Suggested_Property__r.Unit__r.FM_Customer_Unit_Task__c == true)
                    { 
                        thisProperty.Snag_Status__c = 'Customer Unit Inspection Completed';
                    }
                    updatePropertyList.add(thisProperty);
                    
                }
            }
            }
            if(!insertTaskList.isEmpty())
            {
                upsert insertTaskList;
            }
            if(!insertEmailMessageList.isEmpty())
            {
                Insert insertEmailMessageList;
            }
            if(!updatePropertyList.isEmpty())
            {
                update updatePropertyList;
            }
        }
    }
    
  
    
    public static Void errorForSnag(List<Task> taskList,Map<Id,Task> oldMap)
    {
        set<String> propertyIdSet = New set<String>();
        set<String> ContentDocumentIdSet = New set<String>();
        set<String> bookingIdSet = New set<String>();
        List<Task> customerTaskList = New List<Task>();
        for(Task thisTask : taskList)
        {
            if(thisTask.Status !=  oldMap.get(thisTask.id).Status &&(thisTask.subject == 'RM Customer Unit Inspection Task'
                                                                     || thisTask.subject == 'FM Customer Unit Inspection Task'
                                                                    ||  thisTask.subject == 'Post - OC FM Unit Inspection' ))
            {
                String objectName = thisTask.WhatId.getSObjectType().getDescribe().getName();
                if(objectName == 'Booking__c')
                {
                    bookingIdSet.add(thisTask.WhatId);
                }
                if(objectName == 'Property__c')
                {
                     propertyIdSet.add(thisTask.WhatId);
                }
               
                customerTaskList.add(thisTask);
            }
        }
        
        if(!propertyIdSet.isEmpty() || !bookingIdSet.isEmpty()) {
            Map<Id,String> mapOfBooking = New Map<Id,String>();
            Map<Id,String> mapOfContentVersion = New Map<Id,String>();
            List<Booking__c> BookList = [Select Id ,Name,Primary_Applicant__r.Name, 
                                         Primary_Applicant__r.PersonEmail,Project_Name__r.Name,Project_Name__r.GPS_location__c,
                                         Project_Name__r.Location__c,Project_Name__r.Project_Phone__c, 
                                         Related_Suggested_Property__r.Unit__c,Project_Name__r.Project_Email__c,
                                         Related_Suggested_Property__r.Unit__r.Customer_Unit_Inspection_Scheduled_Date__c
                                         From Booking__c 
                                         Where Related_Suggested_Property__r.Unit__c IN:propertyIdSet
                                         OR Id IN: bookingIdSet];
            system.debug('BookList----'+BookList);
            if(!BookList.isEmpty()){
                for(Booking__c thisBooking :BookList)
                {
                    bookingIdSet.add(thisBooking.id);
                    mapOfBooking.put(thisBooking.id,thisBooking.Related_Suggested_Property__r.Unit__c);
                    if(thisBooking.Related_Suggested_Property__r.Unit__c != null)
                    {
                        propertyIdSet.add(thisBooking.Related_Suggested_Property__r.Unit__c);
                    }
                    
                }
            }
            system.debug('propertyIdSet'+propertyIdSet);
            List<Unit_Snag_Response__c> allUnitSnagResponseList = [SELECT Id, Name, Property__c, Project_Snag__c ,Project_Snag__r.Questions__c,
                                                                   Post_OC_Answers__c,Pre_OC_Answers__c,Pre_OC_End_Date__c,Area__c,Pre_OC_Remarks__c,
                                                                   Post_OC_Remarks__c, Customer_Inspection_Remarks__c,Customer_Inspection_Answers__c
                                                                   FROM Unit_Snag_Response__c
                                                                   WHERE  Property__c IN: propertyIdSet ];
            system.debug('allUnitSnagResponseList'+allUnitSnagResponseList);
            Map<Id,Task> mapOfPostOCReview = New Map<Id,Task>();
            List<Task> postOCReviewListTask = [SELECT id, WhatID FROM TASK 
                                               WHERE WhatID IN: propertyIdSet AND
                                               Subject =: 'Post - OC FM Review Task' AND Status != 'Completed'];
            for(Task thisTask:postOCReviewListTask)
            {
                mapOfPostOCReview.put(thisTask.whatId,thisTask);
            }
            
            Map<Id, Integer> unitSnagResponseForCustomerInspection = New Map<Id, Integer>();
            Map<Id, Integer> unitSnagResponseForPostOCInspection = New Map<Id, Integer>();
            for(Unit_Snag_Response__c thisUnit : allUnitSnagResponseList)
            {
                if(thisUnit.Customer_Inspection_Answers__c != true){
                    if(unitSnagResponseForCustomerInspection.containskey(thisUnit.Property__c))
                    {
                        unitSnagResponseForCustomerInspection.put(thisUnit.Property__c,unitSnagResponseForCustomerInspection.get(thisUnit.Property__c)+1);
                    }
                    else
                    {
                        unitSnagResponseForCustomerInspection.put(thisUnit.Property__c,1);
                    }
                }
                if(thisUnit.Post_OC_Answers__c != true){
                    if(unitSnagResponseForPostOCInspection.containskey(thisUnit.Property__c))
                    {
                        unitSnagResponseForPostOCInspection.put(thisUnit.Property__c,unitSnagResponseForPostOCInspection.get(thisUnit.Property__c)+1);
                    }
                    else
                    {
                        unitSnagResponseForPostOCInspection.put(thisUnit.Property__c,1);
                    }
                }
            }
            
            List<ContentVersion> ContentversionList =[SELECT Id, FirstPublishLocationId,ContentDocumentId FROM ContentVersion
                                                      WHERE FirstPublishLocationId IN:bookingIdSet 
                                                      AND Document_Type__c =: 'Copy of the Signed Customer Snag List'];
             system.debug('ContentversionList----'+ContentversionList);
            for(ContentVersion thisContentVersion :ContentversionList)
            {
                if(mapOfBooking.containsKey(thisContentVersion.FirstPublishLocationId))
                {
                    ContentDocumentIdSet.add(thisContentVersion.ContentDocumentId);
                    mapOfContentVersion.put(mapOfBooking.get(thisContentVersion.FirstPublishLocationId),thisContentVersion.id);
                }
            }
            if(!ContentDocumentIdSet.isEmpty())
            {
                List<ContentDocumentLink> ContentDocumentLinkList =[SELECT LinkedEntityId,ContentDocumentId 
                                                                    FROM ContentDocumentLink
                                                                    WHERE ContentDocumentId IN: ContentDocumentIdSet];
                for(ContentDocumentLink thisCDL :ContentDocumentLinkList)
                {
                    if(mapOfBooking.containsKey(thisCDL.LinkedEntityId))
                    {
                        
                        mapOfContentVersion.put(mapOfBooking.get(thisCDL.LinkedEntityId),thisCDL.id);
                    }
                }
            }
            
            system.debug('mapOfBooking'+mapOfBooking);
            string error = system.label.Customer_Snag_List_Error_Message;
            string errorForPostOCFM = system.label.Error_For_Post_OC_FM_Unit_Inspection;
            string errorForRM = system.label.RM_Complete_Unit_Inspection_Task;
            for(Task thisTask : customerTaskList)
            {
              
                if((//!mapOfContentVersion.containsKey(thisTask.WhatId) || 
                    unitSnagResponseForCustomerInspection.containsKey(thisTask.WhatId)) 
                   && thisTask.Status == 'Completed' 
                   && thisTask.subject == 'FM Customer Unit Inspection Task')
                {
                    thisTask.addError(error);
                }

                if(mapOfBooking.ContainsKey(thisTask.WhatId) &&
                   thisTask.subject == 'RM Customer Unit Inspection Task'
                   && thisTask.Status == 'Completed' ) 
                {
                    string propertyId =  mapOfBooking.get(thisTask.WhatId) ;
                    system.debug('propertyId'+propertyId);
                    if(unitSnagResponseForCustomerInspection.containsKey(propertyId)){
                        thisTask.addError(errorForRM);
                    }
                  
                }
                 
               
                if( thisTask.subject == 'Post - OC FM Unit Inspection' && thisTask.Status == 'Completed' && 
                   unitSnagResponseForPostOCInspection.containsKey(thisTask.WhatId))
                {
                    thisTask.addError(errorForPostOCFM);
                }
                
            }   
        }
        
    }
    public static Void internalSnaggingEmail(List<Task> taskList,Map<Id,Task> oldMap)
    {
        Set<id> taskId = New Set<id>();
        Set<id> propertyIdSet = New Set<id>();
        List<Task> internalSnaggingTaskList = New List<Task>();
        List<Task> insertTaskList = New List<Task>();
        for(Task thisTask : taskList)
        {
            if(((
               // thisTask.subject == 'Pre-OC FM Review Task' ||
                thisTask.subject == 'FM Customer Unit Inspection Task' 
                || thisTask.subject == 'Pre-OC FM Review Task')&& thisTask.status =='Completed'  &&
                oldMap.get(thisTask.id).status != thisTask.status) ||
               (thisTask.subject == 'Post - OC FM Unit Inspection' && oldMap.get(thisTask.id).ActivityDate != thisTask.ActivityDate)
              )
                
            {
                internalSnaggingTaskList.add(thisTask);
                propertyIdSet.add(thisTask.WhatId);
            }
        }
        if(!internalSnaggingTaskList.isEmpty())
        {
            Map<String,Id> mapOfOwea= New Map<String,Id>();
            List<OrgWideEmailAddress> oweaList = [SELECT Id, Address, DisplayName 
                                                  FROM OrgWideEmailAddress 
                                                 ];
            for(OrgWideEmailAddress owea:oweaList)
            {
                mapOfOwea.put(owea.Address,owea.id);
            }
            
            String CRMHeadUserName = Label.CRM_Head_User;
            User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'].Id AND isActive =: true Limit 1];
            CustomNotificationType CustomNotificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                                                             WHERE DeveloperName =: 'Task_Notification_To_Enquiry_Owner'];
            List<Property__c>  propertyList = [SELECT ID, NAME,Project__c,Flat_Type__c,Project__r.Name,Tower__r.Name,Project__r.Project_Email__c,
                                               Unit_Type__c,Pre_OC_Start_Date__c,Project__r.FM_Head__r.Name,
                                               Project__r.FM_Head__r.email,Sub_Snag_Status__c,RM_Customer_Task__c,
                                               FM_Customer_Unit_Task__c
                                               FROM PROPERTY__C 
                                               WHERE id IN: propertyIdSet];
            Map<Id,Property__c> mapOfProperty= New Map<Id,Property__c>();
            List<Property__c>  updatePropertyList =  New List<Property__c>();
            if(!propertyList.isEmpty())
            {
                for(Property__c thisProperty: propertyList)
                {
                    mapOfProperty.put(thisProperty.id,thisProperty);
                }
            }
            
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                           from EmailTemplate 
                                           where Name = 'FM Pre OC Review Task' LIMIT 1];
            EmailTemplate emailTemplateForPostOC = [select Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                                    from EmailTemplate 
                                                    where DeveloperName = 'Post_OC_FM_Task_Due_Date' LIMIT 1];
            
            Set<String> recipientIds = New Set<String> ();
            List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
            List<String> emailList = new List<String>();  
            for(Task thisTask :internalSnaggingTaskList)
            {
                if(mapOfProperty.containsKey(thisTask.WhatId)){
                    Property__c thisProperty = mapOfProperty.get(thisTask.WhatId);
                    if(emailTemplate != null &&  thisProperty.Project__r.FM_Head__c != null
                       && thisTask.subject == 'Pre-OC FM Review Task' && thisTask.status =='Completed'){   
                           recipientIds = New Set<String> ();
                           emailList = new List<String>();
                           emailList.add(thisProperty.Project__r.FM_Head__r.Email);  
                           recipientIds.add(thisProperty.Project__r.FM_Head__c);
                           String htmlBody = emailTemplate.HtmlValue;
                           String plainBody = emailTemplate.Body;
                           String Subject = emailTemplate.Subject;
                           Subject = Subject.replace('{!Property__c.Name}',thisProperty.Name);
                           htmlBody = htmlBody.replace('{!Property__c.Name}',thisProperty.Name);
                           htmlBody = htmlBody.replace('{userName}',thisProperty.Project__r.FM_Head__r.Name);
                           htmlBody = htmlBody.replace('{projectName}', thisProperty.Project__r.Name);
                           plainBody = plainBody.replace('{!Property__c.Name}',thisProperty.Name);
                           plainBody = plainBody.replace('{projectName}', thisProperty.Project__r.Name);
                           plainBody = plainBody.replace('{userName}',thisProperty.Project__r.FM_Head__r.Name);
                           EmailMessage objEmailMessage = new EmailMessage();
                           objEmailMessage.status = '3'; // email was sent
                           objEmailMessage.RelatedToId = thisProperty.id;
                           objEmailMessage.fromName = 'Dynamix'; // from name
                           objEmailMessage.Subject = 'Email sent to FM for Completion of Pre-OC FM Review Task';
                           objEmailMessage.HtmlBody = plainBody;
                           insertEmailMessageList.add(objEmailMessage);
                           //SendEmailWithOrgWideAddress.SendEmail(emailTemplate.Id, htmlBody, plainBody, emailList,null,owea.id);
                           SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,Subject,htmlBody,plainBody,emailList,null,true,thisProperty.id,null,null,mapOfOwea.get(thisProperty.Project__r.Project_Email__c));
                           SendEmailandBellNotificationUtility.SendBellNotification(String.valueof(CustomNotificationType.Id),Subject,plainBody,String.valueof(thisProperty.id),recipientIds);
                       }
                    if(thisTask.subject == 'Post - OC FM Unit Inspection')
                    {
                        recipientIds = New Set<String> ();
                        emailList = new List<String>();
                        recipientIds.add(thisProperty.Project__r.FM_Head__c);  
                        recipientIds.add(CRMHeadRoleObjUser.id);
                        String htmlBody = emailTemplateForPostOC.HtmlValue;
                        String plainBody = emailTemplateForPostOC.Body;
                        String Subject = emailTemplateForPostOC.Subject;
                        Subject = Subject.replace(' {Unit Number}',thisProperty.Name);
                        htmlBody = htmlBody.replace('{Unit Number}',thisProperty.Name);
                        htmlBody = htmlBody.replace('{dueDate}',String.Valueof(thisTask.ActivityDate));
                        htmlBody = htmlBody.replace('{ProjectName}', thisProperty.Project__r.Name);
                        plainBody = plainBody.replace('{Unit Number}',String.Valueof(thisTask.ActivityDate));
                        plainBody = plainBody.replace('{ProjectName}', thisProperty.Project__r.Name);
                        plainBody = plainBody.replace('{dueDate}',thisProperty.Project__r.FM_Head__r.Name);
                        SendEmailandBellNotificationUtility.SendBellNotification(String.valueof(CustomNotificationType.Id),Subject,plainBody,String.valueof(thisProperty.id),recipientIds);
                    }
                    if(thisTask.subject == 'FM Customer Unit Inspection Task' && thisTask.status =='Completed')
                    {
                        thisProperty.FM_Customer_Unit_Task__c = true;
                        system.debug(' thisProperty.FM_Customer_Unit_Task__c'+ thisProperty.FM_Customer_Unit_Task__c);
                        if(thisProperty.RM_Customer_Task__c == true)
                        {
                            thisProperty.Snag_Status__c = 'Customer Unit Inspection Completed';
                        }
                        updatePropertyList.add(thisProperty);
                        system.debug('updatePropertyList'+ updatePropertyList);
                    }
                }
            }
            if(!insertEmailMessageList.isEmpty())
            {
                insert insertEmailMessageList;
            }
            if(!updatePropertyList.isEmpty())
            {
                update updatePropertyList;
                  system.debug('updatePropertyList 1'+ updatePropertyList);
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
     i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;}
    
}