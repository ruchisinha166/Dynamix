public with sharing class createOpportunityAndAccount {
    
    public static opportunityResponse createOpportunity(opportunityRequest request)
    {
        opportunityResponse res = new opportunityResponse();
        Account accountObj = new account();
        Account accountObjCp = new account();
        String anarockId;
        Opportunity opportunityObj = new Opportunity();
        Map<String,string> ErorrMsg = new map<string,string>();
        Id PAID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Id ChannelPartnerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        Map<String,string> validateData = createOpportunityAndAccount.valdateMethod(request);
        List<account> isexistingAccount = createOpportunityAndAccount.checkDuplicateAccount(request);
        List<contact> isduplicateCp = createOpportunityAndAccount.checkDuplicateCp(request);
        List<opportunity> isDuplicateOpp =createOpportunityAndAccount.checkDuplicateOpp(request);
        Set<String> opportunityFields = Schema.SObjectType.opportunity.fields.getMap().keySet();
        Set<String> accountFields = Schema.SObjectType.Account.fields.getMap().keySet();
            
        try{
        if(validateData.size() <= 0)
        {
            if(request.opportunityMap.get('Source__c') <> 'Channel Partner')
            {
                if(isexistingAccount.size() == 0)
                {
                    if(request.accountMap.keySet() <> null)
                    {
                        for(String accString: request.accountMap.keySet())
                        {
                            if(accountFields.contains(string.valueof(accString).toLowercase()))
                            {
                                if(request.accountMap.get(accString) <> null && request.accountMap.get(accString) <> '')
                                {
                                   if(string.valueof(Schema.SObjectType.Account.fields.getMap().get(accString).getDescribe().getType()) == 'Date')
                                    {
                                        accountObj.put(accString,date.parse(request.accountMap.get(accString)));
                                    }
                                    else if(string.valueof(Schema.SObjectType.Account.fields.getMap().get(accString).getDescribe().getType()) == 'DOUBLE' || string.valueof(Schema.SObjectType.Account.fields.getMap().get(accString).getDescribe().getType()) == 'CURRENCY')
                                    {
                                        accountObj.put(accString,decimal.valueOf(request.accountMap.get(accString)));
                                    }
                                    else if(string.valueof(Schema.SObjectType.Account.fields.getMap().get(accString).getDescribe().getType()) == 'BOOLEAN')
                                    {
                                        accountObj.put(accString,Boolean.valueOf(request.accountMap.get(accString)));
                                    }
                                    else
                                    {
                                        accountObj.put(accString,request.accountMap.get(accString));
                                    }
                                }
                            }  
                        }
                        accountObj.RecordTypeID = PAID;
                        insert accountObj;
                    }
                }
            }
            else if(request.opportunityMap.get('Source__c') == 'Channel Partner')
            {
                if(isexistingAccount.size() == 0)
                {
                    if(request.accountMap.keySet() <> null)
                    {
                        for(String accString: request.accountMap.keySet())
                        {
                            if(accountFields.contains(string.valueof(accString).toLowercase()) && (accString <> 'CP_Number__c' && accString <> 'CP_Name__c' && accString <> 'RERA_Number__c'))
                            {
                                if(request.accountMap.get(accString) <> null && request.accountMap.get(accString) <> '')
                                {
                                   if(string.valueof(Schema.SObjectType.Account.fields.getMap().get(accString).getDescribe().getType()) == 'Date')
                                    {
                                        accountObj.put(accString,date.parse(request.accountMap.get(accString)));
                                    }
                                    else if(string.valueof(Schema.SObjectType.Account.fields.getMap().get(accString).getDescribe().getType()) == 'DOUBLE' || string.valueof(Schema.SObjectType.Account.fields.getMap().get(accString).getDescribe().getType()) == 'CURRENCY')
                                    {
                                        accountObj.put(accString,decimal.valueOf(request.accountMap.get(accString)));
                                    }
                                    else if(string.valueof(Schema.SObjectType.Account.fields.getMap().get(accString).getDescribe().getType()) == 'BOOLEAN')
                                    {
                                        accountObj.put(accString,Boolean.valueOf(request.accountMap.get(accString)));
                                    }
                                    else
                                    {
                                        accountObj.put(accString,request.accountMap.get(accString));
                                    }
                                }
                            }  
                        }
                        accountObj.RecordTypeID = PAID;
                        insert accountObj;
                    }
                }
                
             	if(isduplicateCp.size() == 0)
                {
                    if(request.accountMap.keySet() <> null)
                    {
                        for(String accString: request.accountMap.keySet())
                        {
                            if(accountFields.contains(string.valueof(accString).toLowercase()) && (accString == 'name' || accString == 'CP_Number__c' || accString == 'CP_Name__c' || accString == 'RERA_Number__c') )
                            {
                               if(string.valueof(Schema.SObjectType.Account.fields.getMap().get(accString).getDescribe().getType()) == 'Date')
                                {
                                    accountObjCp.put(accString,date.parse(request.accountMap.get(accString)));
                                }
                                else if(string.valueof(Schema.SObjectType.Account.fields.getMap().get(accString).getDescribe().getType()) == 'DOUBLE' || string.valueof(Schema.SObjectType.Account.fields.getMap().get(accString).getDescribe().getType()) == 'CURRENCY')
                                {
                                    accountObjCp.put(accString,decimal.valueOf(request.accountMap.get(accString)));
                                }
                                else if(accString == 'CP_Name__c')
                                {
                                    accountObjCp.put('Name',request.accountMap.get(accString));
                                }
                                else
                                {
                                    accountObjCp.put(accString,request.accountMap.get(accString));
                                }
                            }
                        }
                        accountObjCp.RecordTypeID = ChannelPartnerId;
                        insert accountObjCp;
                    }
                }
            }
            
            if(request.opportunityMap.keySet() <> null)
            { 
                for(String oppString: request.opportunityMap.keySet())
                {
                   if(opportunityFields.contains(string.valueof(oppString).toLowercase()))
                   {
                       if(string.valueof(Schema.SObjectType.Opportunity.fields.getMap().get(oppString).getDescribe().getType()) == 'Date')
                            {
                               if(oppString == 'CloseDate' && request.opportunityMap.get(oppString) == '')
                                  {
                                       opportunityObj.put(oppString,Date.today());
                                  }
                                else
                                {
                                    if(request.opportunityMap.get(oppString) <> '' && request.opportunityMap.get(oppString) <> null)
                                    {
                                       opportunityObj.put(oppString,date.parse(request.opportunityMap.get(oppString)));   
                                    }
                                } 
                            }
                            else if(string.valueof(Schema.SObjectType.Opportunity.fields.getMap().get(oppString).getDescribe().getType()) == 'DOUBLE' || string.valueof(Schema.SObjectType.Opportunity.fields.getMap().get(oppString).getDescribe().getType()) == 'CURRENCY')
                            {
                                if(request.opportunityMap.get(oppString) <> null && request.opportunityMap.get(oppString) <> '' && request.opportunityMap.get(oppString) <> 'null')
                                {
                                   opportunityObj.put(oppString,decimal.valueOf(request.opportunityMap.get(oppString))); 
                                }
                            }
                           else if(string.valueof(Schema.SObjectType.Opportunity.fields.getMap().get(oppString).getDescribe().getType()) == 'BOOLEAN' )
                            {
                                opportunityObj.put(oppString,Boolean.valueOf(request.opportunityMap.get(oppString)));
                            }
                            else if(string.valueof(Schema.SObjectType.Opportunity.fields.getMap().get(oppString).getDescribe().getType()) == 'MULTIPICKLIST')
                            {
                                if(request.opportunityMap.get(oppString) <> '' && request.opportunityMap.get(oppString) <> null && request.opportunityMap.get(oppString) <> 'null' && request.opportunityMap.get(oppString) <> 'undefined')
                                {
                                  	string values = request.opportunityMap.get(oppString).replaceAll(',',';');
                                	opportunityObj.put(oppString,values);   
                                }
                            }
                       		else if(string.valueof(Schema.SObjectType.Opportunity.fields.getMap().get(oppString).getDescribe().getType()) == 'PICKLIST')
                            {
                            
                                if(oppString == 'StageName')
                                    {
                                        opportunityObj.put('StageName','Site Visit');
                                    }
                                    else
                                    {
                                        if(request.opportunityMap.get(oppString) <> null && request.opportunityMap.get(oppString) <> '' && request.opportunityMap.get(oppString) <> 'undefined')
                                        {
                                          opportunityObj.put(oppString,request.opportunityMap.get(oppString));  
                                        }
                                    }
                            }
                         	else 
                            {
                                if(oppString <> 'Project__c' && oppString <> 'OwnerId' && oppString <> 'CloseDate')
                                {
                                    opportunityObj.put(oppString,request.opportunityMap.get(oppString));
                                }
                            }
                   }
                }
                if(request.opportunityMap.keySet().contains('Project__c') || request.opportunityMap.keySet().contains('Project_id'))
                {
                    if(request.opportunityMap.get('Project_id') <> null)
                    {
                      anarockId = request.opportunityMap.get('Project_id');  
                    }
                    if(request.opportunityMap.get('Project__c') <> null)
                    {
                      anarockId = request.opportunityMap.get('Project__c');  
                    }
                     
                    Project__c project = new Project__c(Project_Id__c= anarockId);
                    opportunityObj.Project__r = project;                     
                }
                if(request.opportunityMap.keySet().contains('OwnerId'))
                {
                   List<user> userId = [select id from user where Email =: request.opportunityMap.get('OwnerId')];
                   if(userId.size() <> 0)
                   {
                       opportunityObj.OwnerId = userId[0].id; 
                   }
                   else
                   {
                       opportunityObj.OwnerId = [select Site_Head__c from Project__c where Project_Id__c =: anarockId].Site_Head__c;
                   }
                   
                }
                if(request.opportunityMap.get('Source__c') <> 'Channel Partner')
                {
                    if(isexistingAccount.size() == 0 )
                    {
                        opportunityObj.AccountId = accountObj.Id;
                    }
                    else
                    {
                        opportunityObj.AccountId = isexistingAccount[0].Id;
                    }
                }
                else if(request.opportunityMap.get('Source__c') == 'Channel Partner')
                {
                     if(isduplicateCp.size() == 0 )
                     {
                         if(isexistingAccount.size() == 0 )
                         {
                            opportunityObj.AccountId = accountObj.Id;
                            opportunityObj.Channel_Partner__c = accountObjCp.Id;
                         }
                         else
                         {
                           	opportunityObj.AccountId = isexistingAccount[0].Id;
                            opportunityObj.Channel_Partner__c = accountObjCp.Id;
                         }
                        	
                    }
                    else
                    {
                        if(isexistingAccount.size() == 0 )
                        {
                            opportunityObj.AccountId = accountObj.Id;
                            opportunityObj.Channel_Partner__c = isduplicateCp[0].accountid;
                        }
                        else
                        {
                            opportunityObj.AccountId = isexistingAccount[0].Id;
                            opportunityObj.Channel_Partner__c = isduplicateCp[0].accountid;
                        }
                        	
                    } 
                }
                if(isDuplicateOpp.size() == 0){
                    insert opportunityObj;
                    res.Status = 'Insert Successfully';
            		res.opportunityData = opportunityObj;
                }
                else{
                    opportunityObj.put('id',isDuplicateOpp[0].id);
                    update opportunityObj;
                    res.Status = 'Update Successfully';
            		res.opportunityData = opportunityObj;
                } 
            }
        } 
        else {
             res.Status = 'error';
            res.errorMessage = validateData;
            Log.error(String.valueOf(res.errorMessage));
        }//validateData Condtion End
        
        return res;
        }
            catch(Exception ex){
                system.debug('e-------'+ex.getMessage()+' getStackTrace '+ex.getStackTraceString());
                Log.error(ex.getMessage() + '\n' + ex.getStackTraceString());
            }
        return res;
    }
    
    public static List<account> checkDuplicateAccount(opportunityRequest request)
    {
        
        List<account> acc = [select id,name, PersonMobilePhone, PersonEmail from account where (PersonMobilePhone =: request.accountMap.get('PersonMobilePhone') and PersonEmail =: request.accountMap.get('PersonEmail') and (PersonMobilePhone <> null or PersonMobilePhone <> '') and (PersonEmail <> null or PersonEmail <> ''))];
       	return acc; 
    }
    
     public static List<contact> checkDuplicateCp(opportunityRequest request)
    {
        Id ChannelPartnerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        List<Account> acc = [select id,CP_Number__c from account where (CP_Number__c =: request.accountMap.get('CP_Number__c') AND RecordTypeId =: ChannelPartnerId)];
        List<contact> con = [select id,accountid from contact where (MobilePhone = : request.accountMap.get('CP_Number__c') AND Account.RecordTypeId =: ChannelPartnerId )];
       	return con; 
    }
    public static List<opportunity> checkDuplicateOpp(opportunityRequest request)
    {
         List<opportunity> Checkduplicateopp = new List<opportunity>();
         if(request.opportunityMap.get('Project_id') <> '' &&  request.accountMap.get('PersonMobilePhone') <> ''){
             Checkduplicateopp = [select id,name,CreatedDate from opportunity where Account.PersonMobilePhone =: request.accountMap.get('PersonMobilePhone')
                                  AND Project__r.Project_Id__c =: request.opportunityMap.get('Project_id') AND StageName <> 'Closed Lost' 
                                  AND StageName <> 'Closed Won' AND CreatedDate >=: system.Today().addDays(-45) order by LastModifiedDate desc];
         }
        
        return Checkduplicateopp;
    }
    public static Map<String,String> valdateMethod(opportunityRequest request)
    {
        Set<String> opportunityFields = Schema.SObjectType.opportunity.fields.getMap().keySet();
        Set<String> accountFields = Schema.SObjectType.Account.fields.getMap().keySet();
        
        Map<String,String> errorMessageList = new Map<String,String>();
        
       
        if(request.accountMap.get('LastName') == '')
        {
            errorMessageList.put('LastName','Please Enter Last Name');
        }
        if(request.accountMap.get('PersonMobilePhone') == '')
        {
            errorMessageList.put('PersonMobilePhone','Please Enter Mobile Number');
        }
        if(request.opportunityMap.get('Name') == '')
        {
            errorMessageList.put('Name','Please Enter Name of Opportunity');
        }
        if(request.opportunityMap.get('Project__c') <> '' || request.opportunityMap.get('Project_id') <> '')
        {
            List<Project__c> ProjectId = [select id,name from project__c where ((Project_Id__c =: request.opportunityMap.get('Project__c') AND Project_Id__c <> '') OR  (Project_Id__c =: request.opportunityMap.get('Project_id') AND Project_Id__c <> ''))];
              if(ProjectId.size() == 0)
              {
                errorMessageList.put('ProjectId', 'Invalid project id');
              }
        }
      	for(String oppString: request.opportunityMap.keySet())
        {
           if(opportunityFields.contains(string.valueof(oppString).toLowercase()))
           {
               
            if(request.opportunityMap.get('Name') == '')
             {
                 errorMessageList.put('Name','Please enter the value of opportunity Name.');
             }
             if(request.opportunityMap.get('Project__c') == '' || request.opportunityMap.get('Project_id') == '')
             {
                 errorMessageList.put('Project Id','Please enter project Id.');
             }
             
             if(request.opportunityMap.get('OwnerId') == '')
             {
                 errorMessageList.put('Owner Id','Please enter email address(OwnerId).');
             }
             
           }
        }
        return errorMessageList;
    }
    
}