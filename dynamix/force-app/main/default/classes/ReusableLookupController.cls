public with sharing class ReusableLookupController {
    @AuraEnabled
    public static List<ResultWrapper> fetchRecords(SearchWrapper inputWrapper) {
        try {
            if(inputWrapper != null){
                system.debug('type'+inputWrapper.type);
                String fieldsToQuery = 'SELECT Id, ';
                fieldsToQuery = fieldsToQuery + 'Name, PersonMobilePhone, Phone, RERA_Number__c';
                String query;
                String filterCriteria;
                if(inputWrapper.type == 'Channel Partner'){
                    Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
                    query = fieldsToQuery + ' FROM Account WHERE RecordTypeId = '+ '\'' +recordTypeId  + '\'';
                    
                    if(inputWrapper.searchString.trim().isNumericSpace() == true)
                    {
                        inputWrapper.fieldApiName = 'Name';
                        inputWrapper.otherFieldApiName = 'Phone';
                        filterCriteria =  'Phone ' + ' LIKE ' + '\'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\' LIMIT 10';
                    }
                    else {//if(inputWrapper.searchString.trim().isAlpha() == true){
                        inputWrapper.fieldApiName = 'Name';
                        inputWrapper.otherFieldApiName = 'RERA_Number__c';
                        filterCriteria = '( Name ' + ' LIKE ' + '\'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\' OR '+ 'RERA_Number__c ' + ' LIKE ' + '\'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\') LIMIT 10';
                    }
                    /*else if(inputWrapper.searchString.trim().isAlphanumeric() == true)
                    { inputWrapper.fieldApiName = 'RERA_Number__c';
                     filterCriteria = 'RERA_Number__c ' + ' LIKE ' + '\'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\' LIMIT 10';
                     
                    }*/
                }
                else if(inputWrapper.type == 'Person Account')
                {
                    Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                    query = fieldsToQuery + ' FROM Account WHERE RecordTypeId = '+ '\'' +recordTypeId  + '\'';
                    
                    if(inputWrapper.searchString.trim().isNumericSpace() == true)
                    {
                        inputWrapper.fieldApiName = 'PersonMobilePhone';
                        filterCriteria =  'PersonMobilePhone ' + ' LIKE ' + '\'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\' LIMIT 10';
                    }
                    else {//if(inputWrapper.searchString.trim().isAlpha() == true){
                        inputWrapper.fieldApiName = 'Name';
                        filterCriteria = 'Name ' + ' LIKE ' + '\'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\' LIMIT 10';
                    }
                   /* else if(inputWrapper.searchString.trim().isAlphanumeric() == true)
                    { inputWrapper.fieldApiName = 'RERA_Number__c';
                     filterCriteria = 'RERA_Number__c ' + ' LIKE ' + '\'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\' LIMIT 10';
                     
                    }*/
                }
                if(String.isNotBlank(inputWrapper.selectedRecordId)) {
                    query += ' AND Id = \''+ inputWrapper.selectedRecordId + '\'';
                }else if(String.isNotBlank(inputWrapper.parentFieldApiName) && String.isNotBlank(inputWrapper.parentRecordId)){
                    query += ' AND '+ inputWrapper.parentFieldApiName+ ' = \''+ inputWrapper.parentRecordId + '\'';
                    query += ' AND ' + filterCriteria;
                } 
                else {
                    query += ' AND '+ filterCriteria;
                }
                /* Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
query += ' AND  RecordTypeId ='+recordTypeId ;*/
               // List<Account> AccountContactRelation =[Select id,PersonMobilePhone, firstName, LastName from Account]; //Where PersonMobilePhone  like :input1 ];
                system.debug('query'+query);
                List<ResultWrapper> returnWrapperList = new List<ResultWrapper>();
                for(SObject s : Database.query(query)) {
                    ResultWrapper wrap = new ResultWrapper();
                   
                        wrap.mainField = (String)s.get(inputWrapper.fieldApiName);
                        wrap.subField = (String)s.get(inputWrapper.otherFieldApiName);
                        wrap.id = (String)s.get('id');
                        returnWrapperList.add(wrap);
                }
                
                return returnWrapperList;
            }
            else
            {
                return null;
            }
            
        } catch (Exception err) {
            throw new AuraHandledException(err.getMessage());
        }
    }
    
    public class ResultWrapper{
        @AuraEnabled public String mainField{get;set;}
        @AuraEnabled public String subField{get;set;}
        @AuraEnabled public String id{get;set;}
    }
    
    public class SearchWrapper {
        @AuraEnabled public String objectApiName{get;set;}
        @AuraEnabled public String fieldApiName{get;set;}
        @AuraEnabled public String otherFieldApiName{get;set;}
        @AuraEnabled public String searchString{get;set;}
        @AuraEnabled public String type{get;set;}
        @AuraEnabled public String selectedRecordId{get;set;}
        @AuraEnabled public String parentRecordId{get;set;}
        @AuraEnabled public String parentFieldApiName{get;set;}
    }
}