public class CreateEnquiryAndAccount{
    public static EnquiryResponse createEnquiry(EnquiryRequest request){
        Id PAID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        EnquiryResponse response = new EnquiryResponse();
        set<String> projectName = new set<String>();
        Map<String,String> validateCheck = CreateEnquiryAndAccount.validateValues(request.enquiryMap, request.contactMap);
        if(validateCheck.size() <= 0){    
            if(!CreateEnquiryAndAccount.checkDuplicate(request)){
                List<Account> existAccountList = new List<Account>();  
                existAccountList = [SELECT Id, PersonMobilePhone, Email__c, Country_Code__c FROM Account 
                                    WHERE (Phone =: request.contactMap.get('PersonMobilePhone') 
                                           OR PersonMobilePhone =: request.contactMap.get('PersonMobilePhone') OR Phone =: request.contactMap.get('PersonMobilePhone') OR PersonMobilePhone =: request.contactMap.get('PersonMobilePhone')) 
                                    AND RecordTypeId =: PAID];  
                system.debug('existAccountList'+existAccountList);
                Account accountObject = new Account();           
                if(existAccountList.size() <=0){               
                    for(String contctString: request.contactMap.keySet()){
                        accountObject.put(contctString,request.contactMap.get(contctString));
                    }   
                    accountObject.RecordTypeID = PAID;
                    insert accountObject;
                } 
                else{
                    accountObject = existAccountList[0]; 
                }    
                system.debug('accountObject'+accountObject);
                List<Enquiry__c> enquiries = new List<Enquiry__c>();
                Map<string,Enquiry__c> enquiryMap = New Map<string,Enquiry__c>();
                try{
                    enquiries = [SELECT Id,Contact_Person__c,Enquiry_Source__c,Email_ID__c,
                                 Contact_Person__r.Name,Contact_Person__r.PersonMobilePhone,
                                 Contact_Person__r.Phone,Project__c,Project__r.Name, Primary_Mobile_Number__c 
                                 FROM Enquiry__c
                                 WHERE Contact_Person__c =: accountObject.id AND Project__c =:request.enquiryMap.get('ProjectId') 
                                 AND Enquiry_Source__c =: request.enquiryMap.get('Enquiry_Source__c') 
                                 AND Stage__c != 'Lost' 
                                ];
                    for(Enquiry__c enquiry:enquiries)
                    {
                        enquiryMap.put(enquiry.id,enquiry);
                    }
                }
                catch(Exception ex){
                    system.debug('Error'+ex.getMessage());
                }
                Opportunity newOpportunity = new Opportunity (); 
                List<Project_Details__mdt> projectDetailList = [SELECT id,name__c, Label FROM Project_Details__mdt];
                Map<String,String> mapOfProjectDetails = New Map<String,String>();
                for(Project_Details__mdt thisProjectDetails : projectDetailList)
                {
                    mapOfProjectDetails.put(thisProjectDetails.Label,thisProjectDetails.name__c);
                }
                if(mapOfProjectDetails.containskey(request.enquiryMap.get('ProjectId')))
                {
                    String projectNameData = mapOfProjectDetails.get(request.enquiryMap.get('ProjectId'));
                    projectName.add(projectNameData);
                }
                Map<String, Project__c> mapofProject = new Map<String, Project__c>();
                List<Project__c> projects = [SELECT Id,Name 
                                             FROM Project__c 
                                             WHERE id =:request.enquiryMap.get('ProjectId') or Name IN:projectName];
                
                for(Project__c existingproject:projects){
                    mapofProject.put(existingproject.Id,existingproject);
                    mapofProject.put(existingproject.Name,existingproject);
                }
                
                List <Opportunity> existopportunityList = new List <Opportunity>();
                existopportunityList = [SELECT id,name,Linked_Enquiry__c,OwnerId
                                        FROM  Opportunity 
                                        WHERE Project__c =: mapofProject.keySet() 
                                        AND (Channel_Partner__c =: accountObject.Id Or AccountId =: accountObject.Id)
                                        AND StageName != 'Closed Lost' AND StageName != 'Booked' 
                                        LIMIT 1];
                
                Map<string,Account> accountListMap = New Map<string,Account>();
                Id channelPartnerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
                List<Account> channelPartnerAccountList = [SELECT id, name 
                                                           FROM Account 
                                                           WHERE  id =: request.enquiryMap.get('ChannelPartnerId')
                                                           AND RecordTypeId = :channelPartnerRecordType];
                String ChannelPartnerId='';
                datetime SiteVisitScheduledDate;
                for(Account account :channelPartnerAccountList){
                    accountListMap.put(account.id,account);
                    ChannelPartnerId = account.id;
                }
                system.debug('accountListMap'+accountListMap);
                Enquiry__c enqObject = new Enquiry__c();
                Task newtask = new Task ();
                
                if(existopportunityList.size()<=0)
                { 
                    System.debug('CreateNew');
                    if(enquiries.size()>0)
                    {
                        enqObject.id = enquiries[0].id;
                    }
                    else
                    {
                        //enqObject.Lead_Score__c=20;
                    }
                    for(String enqString: request.enquiryMap.keySet()){
                        if(enqString.contains('EnquiryId') ){
                            if(enquiryMap.containskey(request.enquiryMap.get('EnquiryId'))){
                               // if(&& enqString.contains('EnquiryId') != null && enqString.contains('EnquiryId') != '')
                                enqObject.id = enquiryMap.get(request.enquiryMap.get('EnquiryId')).id;
                            }
                        }
                        if(enqString.contains('Stage__c')  && enquiries.size()==0){
                            enqObject.Stage__c='New Enquiry';
                            enqObject.Send_SMS__c = true;
                        }
                        if(enqString.contains('ProjectId')){
                            if(mapofProject.containskey(request.enquiryMap.get('ProjectId'))){
                                enqObject.Project__c =mapofProject.get(request.enquiryMap.get('ProjectId')).id;
                                Project__c project = new Project__c(id = mapofProject.get(request.enquiryMap.get('ProjectId')).id);
                                enqObject.Project__r = project;
                            }
                            else if(mapOfProjectDetails.ContainsKey(request.enquiryMap.get('ProjectId')))
                            { String projectNameData = mapOfProjectDetails.get(request.enquiryMap.get('ProjectId'));
                             system.debug('projectNameData'+projectNameData);
                             if(mapofProject.ContainsKey(projectNameData)){
                                 system.debug('projectNameData'+projectNameData);
                                 enqObject.Project__c = mapofProject.get(projectNameData).id;
                             }
                            }
                        }
                        if(enqString.contains('Project_Id__c')){
                            Project__c project = new Project__c(Project_Id__c = request.enquiryMap.get(enqString));
                            enqObject.Project__r = project;
                        }
                        if(enqString.contains('Site_Visit_Scheduled_Date__c')){
                            if(request.enquiryMap.get(enqString)!= null && request.enquiryMap.get(enqString) != '')
                            {  
                                enqObject.Stage__c='Site Visit Scheduled';
                                //   enqObject.Site_Visit_required__c='Yes';
                                SiteVisitScheduledDate=Datetime.valueof(request.enquiryMap.get('Site_Visit_Scheduled_Date__c'));
                                enqObject.Site_Visit_Scheduled_Date__c = Datetime.valueof(request.enquiryMap.get('Site_Visit_Scheduled_Date__c')); 
                                newtask.Date_and_Time_of_Site_Visit__c = Datetime.valueOf((String)request.enquiryMap.get('Site_Visit_Scheduled_Date__c')); 
                                
                            }
                        }
                        if(enqString.contains('Create_Date_and_Time__c')){
                            if(request.enquiryMap.get(enqString)!= null && request.enquiryMap.get(enqString) != '')
                            {  
                                //enqObject.Stage__c='Site Visit Scheduled';
                                //   enqObject.Site_Visit_required__c='Yes';
                                //SiteVisitScheduledDate=Datetime.valueof(request.enquiryMap.get('Create_Date_and_Time__c'));
                                enqObject.Create_Date_and_Time__c = Datetime.valueof(request.enquiryMap.get('Create_Date_and_Time__c'));  
                            }
                        }
                        /*  if(enqString.contains('ChannelPartnerId'))
{
if(accountListMap.containskey(request.enquiryMap.get('ChannelPartnerId'))){
enqObject.Channel_Partner__c =accountListMap.get(request.enquiryMap.get('ChannelPartnerId')).id;
ChannelPartnerId =accountListMap.get(request.enquiryMap.get('ChannelPartnerId')).id;
}
}*/
                        if(!enqString.contains('EnquiryId') && !enqString.contains('Project_Integration_Id__c')&& !enqString.contains('Site_Visit_Scheduled_Date__c') && !enqString.contains('ProjectId') 
                           && !enqString.contains('ChannelPartnerId') && !enqString.contains('Create_Date_and_Time__c') )
                        {
                            enqObject.put(enqString,request.enquiryMap.get(enqString));
                        }
                        
                    }   
                    List<Task> taskList = New List<Task> ();
                    Map<string,Task> updateEnquiryTaskMap = New Map<string,Task>();
                    if(existopportunityList.size() != 0)
                    {
                        taskList = [SELECT ID,Enquiry__c,WhatId,ActivityDate 
                                    FROM Task
                                    WHERE WhatId =:existopportunityList[0].id 
                                    AND Subject = 'Follow Up Site Visit Scheduled'
                                    AND status !='Completed'
                                    ORDER BY ActivityDate ];
                    }
                    if(enquiries.size() != 0)
                    {
                        taskList = [SELECT ID,Enquiry__c,WhatId,ActivityDate ,Date_and_Time_of_Site_Visit__c
                                    FROM Task
                                    WHERE WhatId =:enquiries[0].id  
                                    AND Subject !='Follow Up Site Visit Scheduled'
                                    AND status !='Completed'
                                    ORDER BY ActivityDate  ];
                    }
                    for(Task thisTask:taskList)
                    {
                        if(SiteVisitScheduledDate !=thisTask.Date_and_Time_of_Site_Visit__c)
                        {
                            thisTask.Throw_Validation__c = true;
                            thisTask.status = 'Completed';
                            updateEnquiryTaskMap.put(thisTask.ID,thisTask);
                        }
                        else if(SiteVisitScheduledDate ==thisTask.Date_and_Time_of_Site_Visit__c)
                        {
                            newtask.id=thisTask.id;
                        }
                    }
                    if(!updateEnquiryTaskMap.isEmpty())
                    {
                        update updateEnquiryTaskMap.values();
                    }
                    enqObject.Contact_Person__c = accountObject.Id;
                    enqObject.Primary_Mobile_Number_Text__c = accountObject.PersonMobilePhone;
                    enqObject.Primary_Mobile_Number__c = accountObject.PersonMobilePhone;
                     enqObject.Country_Code__c = accountObject.Country_Code__c ;
                    if(enqObject.Primary_Mobile_Number__c != null )
                    {
                        //Boolean CheckValue=  thisEnq.Primary_Mobile_Number_Text__c.isNumericSpace();
                        //if(CheckValue == True)
                        //{
                           // thisEnq.Primary_Mobile_Number__c = thisEnq.Primary_Mobile_Number_Text__c;
                            //enqObject.Primary_Mobile_Number_Text__c = enqObject.Primary_Mobile_Number__c.substring(0, 2)  + '******'+ enqObject.Primary_Mobile_Number__c.substring(10);
                            
                        //}
                    }
                     // enqObject.Primary_Mobile_Number_Text__c = accountObject.PersonMobilePhone;
                    enqObject.Email_ID__c = accountObject.Email__c;
                    system.debug('enqObject'+enqObject);
                    system.debug('ownerId'+enqObject.ownerId);
                    upsert enqObject id;           
                    response.Status = 'Success';
                    
                    response.enquiryData = enqObject;                    
                    newtask.Enquiry__c = enqObject.id;
                    newtask.OwnerId =UserInfo.getUserId();
                    
                }
                else
                {
                    newtask.OwnerId = existopportunityList[0].OwnerId;
                    newtask.WhatId= existopportunityList[0].id;
                }
                if((String)request.enquiryMap.get('Site_Visit_Scheduled_Date__c')!= null && (String)request.enquiryMap.get('Site_Visit_Scheduled_Date__c')!='')
                {    //newtask.Date_and_Time_of_Site_visit__c = datetime.valueof((String)request.enquiryMap.get('Site_Visit_Scheduled_Date__c'));
                    newtask.ActivityDate = Date.valueOf((String)request.enquiryMap.get('Site_Visit_Scheduled_Date__c')); 
                    newtask.Date_and_Time_of_Site_Visit__c = Datetime.valueOf((String)request.enquiryMap.get('Site_Visit_Scheduled_Date__c')); 
                    if(enquiries.IsEmpty())
                    {
                         newtask.whatId = enqObject.id ;
                    }
                    else
                    {
                        newtask.whatId = enquiries[0].id;
                    }
                    
                    if(mapofProject.containskey(request.enquiryMap.get('ProjectId'))){
                        //newtask.Project__c =projectIds.get(request.enquiryMap.get('ProjectId')).id;
                    }
                   
                    newtask.Status = 'Scheduled';
                    system.debug('ChannelPartnerId'+ChannelPartnerId);
                    if(accountListMap.containskey(ChannelPartnerId)){
                        //  enqObject.Channel_Partner__c =accountListMap.get(ChannelPartnerId).id;
                    }
                    
                    if(accountListMap.containskey(ChannelPartnerId)){
                        // newtask.Channel_Partner__c=accountListMap.get(ChannelPartnerId).id;
                    }
                    newtask.subject = 'Follow Up Site Visit Scheduled';
                    
                    insert newtask;
                    response.Status = 'Success';
                    response.taskData = newtask;
                }
                
                return response;}
            
            else{
                List<Account> personAccounts  = [SELECT Id, PersonMobilePhone, Name, Phone, Email__c 
                                                 FROM Account 
                                                 WHERE PersonMobilePhone =: request.contactMap.get('PersonMobilePhone') 
                                                 or Phone =: request.contactMap.get('PersonMobilePhone')];
                system.debug('personAccounts===='+personAccounts);
                //List<Project__c> projects = [select Id,Name,Project_Integration_Id__c from Project__c where Project_Integration_Id__c =:request.enquiryMap.get('Project__c')];
                List<Project__c> projects = [SELECT Id,Name 
                                             FROM Project__c 
                                             WHERE Id =:request.enquiryMap.get('ProjectId') 
                                             //Or   Project_Integration_Id__c =:request.enquiryMap.get('Project__c')
                                            ];
                system.debug('&*&*&*&*&*&*'+projects);
                system.debug('request.enquiryMap*'+request.enquiryMap.get('Enquiry_Source__c'));
                String body = '';
                Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                datetime SiteVisitScheduledDate;
                system.debug('SiteVisitScheduledDate'+SiteVisitScheduledDate);
                if(request.enquiryMap.get('Site_Visit_Scheduled_Date__c')!= ''  && request.enquiryMap.get('Site_Visit_Scheduled_Date__c')!= null)
                {
                    SiteVisitScheduledDate= datetime.valueOf(request.enquiryMap.get('Site_Visit_Scheduled_Date__c'));
                }
                
                if(personAccounts.size() > 0 && projects.size() > 0 && request.enquiryMap.get('Enquiry_Source__c')!= null  )
                {
                    List<Enquiry__c> enquiries = [SELECT Id,Contact_Person__c,Enquiry_Source__c,Contact_Person__r.Name,
                                                  Contact_Person__r.PersonMobilePhone,Contact_Person__r.Phone,Project__c,
                                                  Project__r.Name 
                                                  FROM Enquiry__c
                                                  WHERE Contact_Person__c =: personAccounts[0].Id AND Project__c =:projects[0].Id 
                                                  AND Enquiry_Source__c =: request.enquiryMap.get('Enquiry_Source__c') AND Stage__c != 'Lost' AND Stage__c != 'Site Visit Done'
                                                  AND  Site_Visit_Scheduled_Date__c =:SiteVisitScheduledDate ];
                    system.debug('enquiries.size()'+enquiries.size());
                    if(enquiries.size() > 0){
                        response.Status = 'Duplicate Enquiry with Enquiry ID '+enquiries[0].id;
                    }
                    
                }
                return response;
            }
        }
        else {
            response.Status = 'Error';
            response.errorMessage = validateCheck;
            
            return response;  
        }
    }
    public static boolean checkDuplicate(EnquiryRequest request)
    {
        List<Account> personAccounts  = [select Id, PersonMobilePhone, Name, Phone, Email__c from Account where PersonMobilePhone =: request.contactMap.get('PersonMobilePhone') 
                                         or Phone =: request.contactMap.get('PersonMobilePhone')];
        system.debug('personAccounts===='+personAccounts);
        //List<Project__c> projects = [select Id,Name,Project_Integration_Id__c from Project__c where Project_Integration_Id__c =:request.enquiryMap.get('Project__c')];
        List<Project__c> projects = [select Id,Name,Project_Id__c from Project__c where Id =:request.enquiryMap.get('ProjectId') 
                                     Or   Project_Id__c =:request.enquiryMap.get('Project__c')
                                    ];
        system.debug('&*&*&*&*&*&*'+projects);
        system.debug('request.enquiryMap*'+request.enquiryMap.get('Enquiry_Source__c'));
        String body = '';
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        datetime SiteVisitScheduledDate;
       
        if(request.enquiryMap.get('Site_Visit_Scheduled_Date__c')!= ''  && request.enquiryMap.get('Site_Visit_Scheduled_Date__c')!= null)
        {
            SiteVisitScheduledDate= datetime.valueOf(request.enquiryMap.get('Site_Visit_Scheduled_Date__c'));
        }
         system.debug('SiteVisitScheduledDate'+SiteVisitScheduledDate);
        if(personAccounts.size() > 0 && projects.size() > 0 && request.enquiryMap.get('Enquiry_Source__c')!= null  )
        {
            List<Enquiry__c> enquiries = [SELECT Id,Contact_Person__c,Enquiry_Source__c,Contact_Person__r.Name,Site_Visit_Scheduled_Date__c, 
                                          Contact_Person__r.PersonMobilePhone,Contact_Person__r.Phone,Project__c,Project__r.Name 
                                          FROM Enquiry__c
                                          WHERE Contact_Person__c =: personAccounts[0].Id AND Project__c =:projects[0].Id AND Enquiry_Source__c =: request.enquiryMap.get('Enquiry_Source__c') AND 
                                          Stage__c != 'Lost' AND Stage__c != 'Site Visit Done' 
                                          AND  Site_Visit_Scheduled_Date__c =:SiteVisitScheduledDate];
            system.debug('enquiries.size()'+enquiries);
            system.debug('enquiries.size()'+enquiries.size());
            //system.debug('Site_Visit_Scheduled_Date__c----'+enquiries[0].Site_Visit_Scheduled_Date__c);
            if(enquiries.size() > 0)
            {       
                return true;
            }
            else
            {
                return false;
            }
        }
        else{
            return false;
        }
    } 
    public static Map<String,String> validateValues(Map<String,String> enquiryMap,Map<String,String> contactMap){   
        
        Map<String,String> errorMessageList = new Map<String,String>();
        if(contactMap.get('FirstName') == null && enquiryMap.get('Enquiry_Source__c') != 'Loyalie'){
            errorMessageList.put('FirstName ','Please enter FirstName .');
        }       
        if(contactMap.get('LastName') == null ){
            errorMessageList.put('LastName ','Please enter LastName.');
        }  
        if(contactMap.get('PersonMobilePhone') == null ){
            errorMessageList.put('PersonMobilePhone ','Please enter MobilePhone.');
        }
        if(contactMap.get('Email__c') == null ){
            errorMessageList.put('Email__c ','Please enter Email Id.');
        }
        if(enquiryMap.get('Enquiry_Source__c') == null ){
            errorMessageList.put('Enquiry_Source__c ','Please enter Enquiry Source.');
        }
        if(contactMap.get('Country_Code__c') == null ){
            errorMessageList.put('Country_Code__c ','Please enter Country Code.');
        }
        if((String)enquiryMap.get('Site_Visit_Scheduled_Date__c')!= null 
           && (String)enquiryMap.get('Site_Visit_Scheduled_Date__c')!='')
        {
            if(Datetime.valueOf((String)enquiryMap.get('Site_Visit_Scheduled_Date__c')) < system.now()){
                errorMessageList.put('Site_Visit_Scheduled_Date__c ','Past dates not allowed..');
            }
        }
        if((enquiryMap.get('Enquiry_Sub_Source__c') == null) && ((enquiryMap.get('Enquiry_Source__c') == 'Print' ) || (enquiryMap.get('Enquiry_Source__c') == 'Digital' ) || (enquiryMap.get('Enquiry_Source__c') == 'Radio' ))){
            errorMessageList.put('Enquiry_Sub_Source__c ','Please enter Enquiry Sub Source.');
        }
        return errorMessageList;
    }
}