public with sharing class SalesManagerLookUp {
        @AuraEnabled
        public static List<ResultWrapper> fetchRecords(SearchWrapper inputWrapper) {
            try {
                List<UserRole> userRoleList = New List<UserRole>(); 
                if(inputWrapper.role == 'Sales Manager')
                {
                   userRoleList = [SELECT ID, Name FROM UserRole WHERE Name like '%Sales Manager%' OR Name like '%Site Head%'];
                }
                else
                {
					userRoleList = [SELECT ID, Name FROM UserRole WHERE Name like '%Sales Manager%'];                    
                }
                Set<Id> roleSet = New Set<Id>();
                Map<Id,UserRole> userRoleMap = New Map<Id,UserRole>();
                if(!userRoleList.isEmpty())
                {
                    for(UserRole thisRole :userRoleList)
                    {
                        userRoleMap.put(thisRole.id,thisRole);
                       // roleSet.add(thisRole.id);
                    }
                    
                }
                if(inputWrapper != null){
                    String fieldsToQuery = 'SELECT Id, isActive, UserRoleId,';
                    if(string.isNotBlank(inputWrapper.fieldApiName)){
                        fieldsToQuery = fieldsToQuery + inputWrapper.fieldApiName;
                    }
                    if(string.isNotBlank(inputWrapper.otherFieldApiName)){
                        fieldsToQuery = fieldsToQuery + ', ' + inputWrapper.otherFieldApiName;
                    }
                    String query = fieldsToQuery + ' FROM '+ inputWrapper.objectApiName+' WHERE  isActive = true';
                    String filterCriteria = inputWrapper.fieldApiName + ' LIKE ' + '\'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\' LIMIT 10';
                    if(String.isNotBlank(inputWrapper.selectedRecordId)) {
                        query += ' AND Id = \''+ inputWrapper.selectedRecordId + '\'';
                    }else if(String.isNotBlank(inputWrapper.parentFieldApiName) && String.isNotBlank(inputWrapper.parentRecordId)){
                        query += ' AND '+ inputWrapper.parentFieldApiName+ ' = \''+ inputWrapper.parentRecordId + '\'';
                        query += ' AND ' + filterCriteria;
                    } 
                    else {
                        query += ' AND '+ filterCriteria;
                    }
                    //query += ' AND isActive = true';
                    system.debug('query----'+query);
                    List<ResultWrapper> returnWrapperList = new List<ResultWrapper>();
                    for(SObject s : Database.query(query)) {
                        ResultWrapper wrap = new ResultWrapper();
                        if(userRoleMap.containskey((String)s.get('UserRoleId')))
                        {
                            wrap.mainField = (String)s.get(inputWrapper.fieldApiName);
                            wrap.subField = (String)s.get(inputWrapper.otherFieldApiName);
                            //  wrap.subField = '';//(String)s.get(inputWrapper.otherFieldApiName);
                            wrap.id = (String)s.get('id');
                            returnWrapperList.add(wrap);
                        }
                    }
                    return returnWrapperList;
                }
                return null;
            } catch (Exception err) {
                system.debug('Line Number '+err.getMessage()+' -'+err.getLineNumber());
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
            @AuraEnabled public String selectedRecordId{get;set;}
            @AuraEnabled public String parentRecordId{get;set;}
            @AuraEnabled public String parentFieldApiName{get;set;}
            @AuraEnabled public String role{get;set;}
        }
    }