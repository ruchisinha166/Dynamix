@RestResource(urlMapping='/enquiryAndTask/*')

global without sharing class EnquiryAndTaskPushedAPIAfterWorkingHours {
    global class EnquiryWrapper {
        public List<EnquiryInput> enquiry;
    }
    Global Class EnquiryOutput
    {
        List<Map<String, String> > ErrorMessage;
    }
    Global Class EnquiryInput
    {
        public String name;
        public String phoneNumber;
        public String CampaignId;
        public String CallSubject;
        public String callSID;
        public String CallStatus;
       // public String legStatus1;
        public String callFrom;
        public String virtualNumber;
        public String callRecordingURL;
        public String callDirection;
        public String callDuration;
        public String endTime;
        public String legStatus2;
        public String callTo;
    }
    
    @HttpPost
    Global static EnquiryOutput createEnquiryandTaskMethod()
    {
        EnquiryOutput enquiryOutput = new EnquiryOutput();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<Map<String, String> > errorMessageList = New List<Map<String, String> >();
         Map<String, String> ErrorMessage = New  Map<String, String> ();
        Blob body = req.requestBody;
        String requestString = body.toString();
        Set<Id> projectIdSet = New Set<Id>();
        Set<String> SourceSet = New Set<String>();
        Set<Id> campaignIdSet = New Set<Id>();
        Set<Id> accountIdSet = New Set<Id>();
         Set<Id> newEnquiryIdSet = New Set<Id>();
        Set<String> phoneNumberSet = New Set<String>();
        List<Account> insertAccountList = New List<Account>();
        List<Task> insertTaskList = New List<Task>();
        Map<String,Campaign> CampaignMap = New Map<String,Campaign>(); 
        Map<String,Account> allAccountMap = New Map<String,Account>(); 
        Map<String,Account> accountOfMap = New Map<String,Account>();
        Map<String,Enquiry__c> enqDuplicateMap = new Map<String,Enquiry__c>();
        try {
            List<Enquiry__c> EnquiriesToUpsert = new List<Enquiry__c>();
            List<Account> accountList = new List<Account>();
            EnquiryWrapper apiEnquiryData = (EnquiryWrapper)System.JSON.deserialize(requestString, EnquiryWrapper.class);
            For(EnquiryInput EnquiryInputs : apiEnquiryData.enquiry)
            {
                if(EnquiryInputs.CampaignId != '' && EnquiryInputs.CampaignId !=  null)
                {
                    campaignIdSet.add(EnquiryInputs.CampaignId);
                }
                if(EnquiryInputs.phoneNumber != '' && EnquiryInputs.phoneNumber !=  null)
                {
                    if(EnquiryInputs.phoneNumber.length() >= 10)
                    {
                        String phoneNumber = '%'+EnquiryInputs.phoneNumber.right(10);
                        phoneNumberSet.add(phoneNumber);
                    }
                    else
                    {
                        phoneNumberSet.add(EnquiryInputs.phoneNumber);
                    }
                    
                }
            }
            
            if(!campaignIdSet.isEmpty())
            {
                List<Campaign> CampaignList = [SELECT id, Project__c, Source__c, Sub_Source__c,Virtual_Phone_Number__c 
                                               FROM Campaign 
                                               WHERE id IN:campaignIdSet];
                
                for(Campaign thisCampaign :CampaignList)
                {
                    CampaignMap.put(thisCampaign.id, thisCampaign);
                    SourceSet.add(thisCampaign.Source__c);
                    projectIdSet.add(thisCampaign.Project__c);
                }
            }
            if(!phoneNumberSet.isEmpty())
            {
                
                accountList = [SELECT id,name,PersonMobilePhone 
                               FROM Account 
                               WHERE PersonMobilePhone Like :phoneNumberSet 
                               AND PersonMobilePhone != null];
                
                
                if(!accountList.isEmpty())
                {
                    for(Account thisAccount: accountList)
                    {
                        accountOfMap.put(thisAccount.PersonMobilePhone.right(10),thisAccount);
                        accountIdSet.add(thisAccount.Id);
                    }
                }
                
            }
            For(EnquiryInput EnquiryInputs : apiEnquiryData.enquiry)
            {
                if(EnquiryInputs.phoneNumber != '' && EnquiryInputs.phoneNumber !=  null)
                {
                    String phoneNumber  = EnquiryInputs.phoneNumber.right(10);
                    if(!accountOfMap.ContainsKey(phoneNumber))
                    {
                        Account account = New Account();
                        account.FirstName = 'Unnamed';
                        account.LastName = 'Lead';
                        system.debug('EnquiryInputs.phoneNumber'+EnquiryInputs.phoneNumber);
                        account.PersonMobilePhone = EnquiryInputs.phoneNumber;
                        insertAccountList.add(account);
                        
                    }
                }
            }
            Database.SaveResult[] srList = Database.insert(insertAccountList, false);
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        ErrorMessage = New  Map<String, String> ();
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                        ErrorMessage.put('Status',String.valueof(err.getStatusCode()));
                        ErrorMessage.put('Message','Error- '+err.getMessage()+ ' Account fields that affected this error: ' + err.getFields());
                        errorMessageList.add(ErrorMessage);
                    }
                }
            }
            List<Account> allAccountList = [SELECT id, PersonMobilePhone FROM Account 
                                            WHERE PersonMobilePhone Like :phoneNumberSet 
                                            AND PersonMobilePhone != null];
            system.debug('allAccountList--------------->'+allAccountList);
            
            for(Account thisAccount :allAccountList)
            {
                allAccountMap.put(thisAccount.PersonMobilePhone.right(10), thisAccount);
            }
            system.debug('allAccountMap--------------> '+allAccountMap);
            system.debug('accountList---------------->'+accountList);
            List<Enquiry__c> allEnqList = [SELECT Id, Project__c, Primary_Mobile_Number__c, Campaign__c,
                                           Enquiry_Source__c, Stage__c,Contact_Person__c 
                                           FROM Enquiry__c WHERE Stage__c != 'Lost' AND  Stage__c != 'Junk'
                                           AND (Contact_Person__c IN :accountIdSet 
                                                OR Primary_Mobile_Number__c Like :phoneNumberSet)
                                          ];
            
            if(!allEnqList.isEmpty())
            {
                for(Enquiry__c thisEnq:allEnqList)
                {
                    if(!String.isblank(thisEnq.Primary_Mobile_Number__c) && !String.isBlank(thisEnq.Project__c)
                       && !String.isBlank(thisEnq.Enquiry_Source__c)) {
                           String Key = thisEnq.Primary_Mobile_Number__c.right(10)+thisEnq.Enquiry_Source__c+String.valueof(thisEnq.Project__c);
                           enqDuplicateMap.put(Key,thisEnq);
                       }   
                    if(!String.isBlank(thisEnq.Project__c) && thisEnq.Contact_Person__c != null
                       && !String.isBlank(thisEnq.Enquiry_Source__c)) {
                           String Key = String.valueof(thisEnq.Contact_Person__c)+thisEnq.Enquiry_Source__c+String.valueof(thisEnq.Project__c);
                           enqDuplicateMap.put(Key,thisEnq);
                       }  
                }
            }
            For(EnquiryInput EnquiryInputs : apiEnquiryData.enquiry)
            {
                if(allAccountMap.containskey(EnquiryInputs.phoneNumber.right(10)))
                {
                    
                    if(CampaignMap.containskey(EnquiryInputs.CampaignId))
                    {
                        
                        String CampaignId = CampaignMap.get(EnquiryInputs.CampaignId).id;
                        String Key1 = EnquiryInputs.phoneNumber.right(10)+ CampaignMap.get(EnquiryInputs.CampaignId).Source__c+String.valueof(CampaignMap.get(EnquiryInputs.CampaignId).project__C);
                        String Key2 = String.valueof(allAccountMap.get(EnquiryInputs.phoneNumber.right(10)).id)+ CampaignMap.get(EnquiryInputs.CampaignId).Source__c+String.valueof(CampaignMap.get(EnquiryInputs.CampaignId).project__C);
                        String Key3 = String.valueof(allAccountMap.get(EnquiryInputs.phoneNumber.right(10)).id)+String.valueof(CampaignId);
                        if(!enqDuplicateMap.containsKey(Key1) && !enqDuplicateMap.containsKey(Key2) && !enqDuplicateMap.containsKey(Key3)){
                            Enquiry__c enqObject = new Enquiry__c();
                            enqObject.Campaign__c = CampaignMap.get(EnquiryInputs.CampaignId).id;
                            enqObject.Project__c = CampaignMap.get(EnquiryInputs.CampaignId).project__C;
                            enqObject.Enquiry_Source__c = CampaignMap.get(EnquiryInputs.CampaignId).Source__c;
                            
                            if(CampaignMap.get(EnquiryInputs.CampaignId).Sub_Source__c != null)
                            {
                                enqObject.Enquiry_Sub_Source__c = CampaignMap.get(EnquiryInputs.CampaignId).Sub_Source__c;
                            }
                            enqObject.Primary_Mobile_Number__c = EnquiryInputs.phoneNumber;
                            enqObject.Contact_Person__c = allAccountMap.get(EnquiryInputs.phoneNumber.right(10)).id; 
                            EnquiriesToUpsert.add(enqObject);
                        } 
                        
                    }
                }
                
            }
            Database.SaveResult[] srEnquiryList = Database.insert(EnquiriesToUpsert, false);
            System.debug('Successfully inserted Enquiry srEnquiryList: ' + srEnquiryList);
            // Iterate through each returned result
            for (Database.SaveResult sr : srEnquiryList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted Enquiry ID: ' + sr.getId());
                    newEnquiryIdSet.add( sr.getId());
                       System.debug('Successfully inserted Enquiry ID: ' + sr);
                }
                else {
                    // Operation failed, so get all errors             
                    ErrorMessage = New  Map<String, String> ();   
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Enquiry fields that affected this error: ' + err.getFields());
                        ErrorMessage.put('Status',String.valueof(err.getStatusCode()));
                        ErrorMessage.put('Message','Error- '+err.getMessage()+ ' Enquiry fields that affected this error: ' + err.getFields());
                        errorMessageList.add(ErrorMessage);
                    }
                }
            }
            List<Enquiry__c> allEnqyuiriesList = [SELECT Id, Project__c, Primary_Mobile_Number__c, Campaign__c,
                                                  Enquiry_Source__c, Stage__c,Contact_Person__c 
                                                  FROM Enquiry__c WHERE ID IN: newEnquiryIdSet
                                                  ];
            if(!allEnqyuiriesList.isEmpty())
            {
                for(Enquiry__c thisEnq:allEnqyuiriesList)
                {
                    if(!String.isblank(thisEnq.Primary_Mobile_Number__c) && !String.isBlank(thisEnq.Project__c)
                       && !String.isBlank(thisEnq.Enquiry_Source__c)) {
                           String Key = thisEnq.Primary_Mobile_Number__c.right(10)+thisEnq.Enquiry_Source__c+String.valueof(thisEnq.Project__c);
                           enqDuplicateMap.put(Key,thisEnq);
                       }   
                    if(!String.isBlank(thisEnq.Project__c) && thisEnq.Contact_Person__c != null
                       && !String.isBlank(thisEnq.Enquiry_Source__c)) {
                           String Key = String.valueof(thisEnq.Contact_Person__c)+thisEnq.Enquiry_Source__c+String.valueof(thisEnq.Project__c);
                           enqDuplicateMap.put(Key,thisEnq);
                       }  
                }
            }
                
                For(EnquiryInput EnquiryInputs : apiEnquiryData.enquiry)
                {
                    if(allAccountMap.containskey(EnquiryInputs.phoneNumber.right(10)))
                    {
                        
                        if(CampaignMap.containskey(EnquiryInputs.CampaignId))
                        { 
                            Task task = New Task();
                            String CampaignId = CampaignMap.get(EnquiryInputs.CampaignId).id;
                            String Key1 = EnquiryInputs.phoneNumber.right(10)+ CampaignMap.get(EnquiryInputs.CampaignId).Source__c+String.valueof(CampaignMap.get(EnquiryInputs.CampaignId).project__C);
                            String Key2 = String.valueof(allAccountMap.get(EnquiryInputs.phoneNumber.right(10)).id)+ CampaignMap.get(EnquiryInputs.CampaignId).Source__c+String.valueof(CampaignMap.get(EnquiryInputs.CampaignId).project__C);
                            String Key3 = String.valueof(allAccountMap.get(EnquiryInputs.phoneNumber.right(10)).id)+String.valueof(CampaignId);
                            if(enqDuplicateMap.containsKey(Key1)) {
                                task.WhatId = enqDuplicateMap.get(Key1).id;
                            }
                            if(enqDuplicateMap.containsKey(Key2)) {
                                task.WhatId = enqDuplicateMap.get(Key2).id;
                            }
                            if(enqDuplicateMap.containsKey(Key3)) {
                                task.WhatId = enqDuplicateMap.get(Key3).id;
                            }
                            task.Exotel_CTI__Call_Sid__c =EnquiryInputs.callSID;
                            task.Subject = EnquiryInputs.CallSubject;
                      //      task.Exotel_CTI__Leg1_Status__c	 =EnquiryInputs.legStatus1;
                            task.Exotel_CTI__Leg2_Status__c = EnquiryInputs.legStatus2;
                            task.Exotel_CTI__Virtual_Number__c = EnquiryInputs.virtualNumber;
                            task.Exotel_CTI__To__c	 =EnquiryInputs.callTo;
                            task.Exotel_CTI__From__c = EnquiryInputs.callFrom;
                            task.Exotel_CTI__End_Time__c	 =EnquiryInputs.endTime;
                            task.Exotel_CTI__Call_Duration__c = EnquiryInputs.callDuration;
                            task.Exotel_CTI__Call_Direction__c = EnquiryInputs.callDirection;
                            task.Exotel_CTI__Recording_URL__c	 =EnquiryInputs.callRecordingURL;
                            task.Exotel_CTI__Call_Status__c = EnquiryInputs.CallStatus;
                            
                            task.ActivityDate = system.today();
                            insertTaskList.add(task);
                            
                        }
                    }
                }
                Database.SaveResult[] srTaskList = Database.insert(insertTaskList, false);
                // Iterate through each returned result
                for (Database.SaveResult sr : srTaskList) {
                    if (sr.isSuccess()) {
                        ErrorMessage = New  Map<String, String> ();
                         ErrorMessage.put('Status','200');
                        ErrorMessage.put('Message','Success');
                        errorMessageList.add(ErrorMessage);
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully inserted Task ID: ' + sr.getId());
                       
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            ErrorMessage = New  Map<String, String> ();
                            ErrorMessage.put('Status',String.valueof(err.getStatusCode()));
                            ErrorMessage.put('Message','Error- '+err.getMessage()+ ' Task fields that affected this error: ' + err.getFields());
                            errorMessageList.add(ErrorMessage);
                            System.debug('Task fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            
            
        }
        
        catch(Exception ex)
        {
            ErrorMessage = New  Map<String, String> ();
            ErrorMessage.put('Status','400');
            ErrorMessage.put('Message','Error- '+ex.getMessage()+ 'Line Number ' + ex.getLineNumber());
            errorMessageList.add(ErrorMessage);
            System.debug('ERROR'+ ex.getMessage()+' -Line Number --'+ex.getLineNumber());
        }
        System.debug('errorMessageList'+errorMessageList);
        enquiryOutput.ErrorMessage = errorMessageList;
        return enquiryOutput;
    }
}