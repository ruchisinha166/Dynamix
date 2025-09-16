public class AccountTriggerHandler {
    public static Boolean isExecutingUpdateRegistration = false;
    public static void updateBookingDraftTaskStatus(list<account> accList){
        Set<Id> accountIDSet = New Set<Id>();
        Id personAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        for(Account accountObj : accList){
            accountIDSet.add(accountObj.id);
        }
        // List<Opportunity> listOfOpportunities = new List<Opportunity>([Select Id,Name,AccountId From Opportunity]);
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,AccountId 
                                                 FROM Opportunity 
                                                 WHERE AccountId IN:accountIDSet];
        Map<Id,Opportunity> mapAccIdToOpportunity = new Map<Id,Opportunity>();
        Set<Id> opportunityIDSet = New Set<Id>();
        if(!listOfOpportunities.isEmpty())
        {
            for(Opportunity oppObj : listOfOpportunities){
                mapAccIdToOpportunity.put(oppObj.AccountId,oppObj);
                opportunityIDSet.add(oppObj.id);
            }
        }
        
        System.debug('Number of queries -------------->'+ Limits.getLimitQueries());
        List<Task> listOfAgreeTasks = new List<Task>([SELECT Id,whatId,Status 
                                                      FROM Task 
                                                      WHERE Subject =: 'Generate Draft Agreement']);
        System.debug('Number of queries -------------->'+ Limits.getLimitQueries());
        Map<Id,Task> mapBookIdToAgreeTask = new Map<Id,Task>();
        for(Task taskObj : listOfAgreeTasks){
            mapBookIdToAgreeTask.put(taskObj.whatId,taskObj);
        }   
        Map<Id,Booking__c> mapOppIdToBooking = new Map<Id,Booking__c>();
        if(!opportunityIDSet.isEmpty())
        {
            List<Booking__c> listOfBookings = new List<Booking__c>([SELECT Id,Name,Related_Opportunity__c 
                                                                    FROM Booking__c 
                                                                    WHERE ID IN:opportunityIDSet ]);
            for(Booking__c bookObj : listOfBookings){
                mapOppIdToBooking.put(bookObj.Related_Opportunity__c,bookObj);
            }      
        }
        
        List<Task> listOfAgreeTasksToUpdate = new List<Task>();
        for(account accObj : accList){
            if(accObj.RecordTypeId == personAccRecTypeId){
                if(mapAccIdToOpportunity.size() > 0 && mapAccIdToOpportunity.containsKey(accObj.Id)){
                    Opportunity oppObj = mapAccIdToOpportunity.get(accObj.Id);
                    if(mapOppIdToBooking.size() > 0 && mapOppIdToBooking.containsKey(oppObj.Id)){
                        Booking__c bookObj = mapOppIdToBooking.get(oppObj.Id);
                        if(mapBookIdToAgreeTask.size() > 0 && mapBookIdToAgreeTask.containsKey(bookObj.Id)){
                            Task taskObj = mapBookIdToAgreeTask.get(bookObj.Id);
                            taskObj.Status = 'Re-initiated';
                            listOfAgreeTasksToUpdate.add(taskObj);
                        }
                    }
                }
            }
        }
        System.debug('Number of queries -------------->'+ Limits.getLimitQueries());
        if(!listOfAgreeTasksToUpdate.isEmpty()){
            update listOfAgreeTasksToUpdate;
        }
    }
    
    public static void insertContacts(list<account> accList)
    {
        List<contact> conList = new List<contact>();
        Id ChannelPartnerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        for(account acc : accList)
        {
            if(acc.RecordTypeId == ChannelPartnerId)
            {
                contact con = new contact();
                if(acc.CP_Name__c!='' && acc.CP_Name__c!=null)
                {
                    if(acc.CP_Name__c.contains(' '))
                    {
                        con.FirstName = acc.CP_Name__c.Substring(0,acc.CP_Name__c.indexOf(' '));
                        con.LastName = acc.CP_Name__c.Substring(acc.CP_Name__c.indexOf(' '),acc.CP_Name__c.length());
                    }else{
                        con.LastName = acc.CP_Name__c;
                    }
                }
                else
                {
                    if(acc.name!='' && acc.name!=null)
                    {
                        if(acc.name.contains(' '))
                        {
                            con.FirstName = acc.name.Substring(0,acc.name.indexOf(' '));
                            con.LastName = acc.name.Substring(acc.name.indexOf(' '),acc.name.length());
                        }else{
                            con.LastName = acc.name;
                        }
                    } 
                }     
                con.MobilePhone = acc.CP_Number__c;
                con.AccountId = acc.Id;
                conlist.add(con);
            }
        }
        if(conlist.size() > 0)
        {
            insert conlist;
        }
    }
    
    public Static void duplicateAccountAndAddMandatory(List<Account> accountList)
    {
        Set<String> phoneNumberSet = New Set<String>();
        Id personAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Id channelPartnerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        
        for(Account thisAccount :accountList)
        {
            if(thisAccount.RecordTypeId == personAccRecTypeId )
            {
                if(thisAccount.PersonMobilePhone == null)
                {
                    thisAccount.PersonMobilePhone.addError('Please add PersonMobilePhone.');
                }
                if(thisAccount.FirstName == null)
                {
                    thisAccount.FirstName.addError('Please add FirstName.');
                }
                if(thisAccount.PersonMobilePhone != null)
                {
                    phoneNumberSet.add(thisAccount.PersonMobilePhone);
                }
            }
            if(thisAccount.RecordTypeId == channelPartnerAccRecTypeId && thisAccount.CP_Name__c != null && thisAccount.CP_Name__c!= '')
            {
                Pattern pattern = Pattern.compile('^[a-zA-Z -]*$');
                Matcher matcher = pattern.matcher(thisAccount.CP_Name__c);
                if(matcher.matches() == false)
                {
                    thisAccount.addError('Name can only conatins alphabets and space');   
                }
            }
        }
        if(!phoneNumberSet.isEmpty())
        {
            List<Account> allAccountList = [SELECT Id, PersonMobilePhone
                                            FROM Account 
                                            WHERE Id != :accountList 
                                            AND RecordTypeId =: personAccRecTypeId
                                            AND PersonMobilePhone IN :phoneNumberSet];
            Map<String,Account> accountMap = new Map<String,Account>();
            for(Account thisaccount :allAccountList)
            {
                accountMap.put(thisaccount.PersonMobilePhone,thisaccount);
            }
            for(Account thisAccount :accountList)
            {
                if(accountMap.containsKey(thisAccount.PersonMobilePhone))
                {
                    thisAccount.addError('Duplicate Account - Already exist with the same PersonMobilePhone');   
                }
            }
        }
    }
    
    public static void stagevalidation (List<Account> accountlist){
        For(Account accountRecord: accountlist){
            If((accountRecord.CP_Name__c == NUll || accountRecord.CP_Name__c == '' || 
                accountRecord.CP_Firm_Name__c == NUll ||  accountRecord.CP_Firm_Name__c == '' ||
                accountRecord.Firm_Type__c == Null || accountRecord.Firm_Type__c == '' ||  
                accountRecord.Phone ==Null || accountRecord.Phone == ''  || 
                accountRecord.RERA_Number__c ==NUll || accountRecord.RERA_Number__c == ''||
                accountRecord.Email__c ==NUll || accountRecord.Email__c == '' ||
                accountRecord.Rera_Certificate_Upload__c == false ||
                accountRecord.Rera_Expiry_Date__c == null
               ) && accountRecord.CP_Empanelment_Stages__c == 'Registered'){
                   accountRecord.addError('Please add value in mandatory field for Registration');
               }
        }
    }
    
    public static void updateRegistration(List<Account> accountList){
        if (!isExecutingUpdateRegistration) {
            isExecutingUpdateRegistration = true;
            Set<id> accountId  = New Set<id> ();
            List<Account> recordsToUpdateList = New List<Account>();
            Set<Id> recordsToUpdate = new Set<Id>();
            for (Account account : accountList) {
                
                System.debug('account--' + account);
                if (account.CP_Name__c != null && 
                    account.RERA_Number__c != null && 
                    account.Name != null &&
                    account.Email__c != null &&
                    account.Phone != null &&
                    account.Rera_Expiry_Date__c != null &&
                    account.Rera_Certificate_Upload__c == true) 
                {
                    account.CP_Empanelment_Stages__c = 'Registered';
                    recordsToUpdateList.add(account);
                    System.debug('recordsToUpdateList---->'+recordsToUpdateList);
                }                    
            }
        }
    }   
}