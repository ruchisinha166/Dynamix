public class LookupController {
    
    @AuraEnabled(cacheable=true)
    public static List<List<SObject>> find(String searchTerm, String filters){
        
        Integer limitNum = 10;
        System.debug('LookupController searchTerm:'+searchTerm);
        System.debug('LookupController filters:'+filters);
        String query = 'FIND \'' + searchTerm + '*\' RETURNING ' + filters + ' LIMIT ' + limitNum;
        
        List<List <SObject>> searchList = search.query(query);
        List<List <SObject>> searchListForReturn = new List<List <SObject>>();
        List<SObject> recordList = new List<SObject>();
        System.debug(searchList);
        if(searchList.size()>0 && filters=='Account (Name,RecordTypeId)'){
            Id PersonAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            for(List<SObject> rcd:searchList){
                System.debug('rcd:'+rcd); 
                for(Sobject sObjRcd:rcd){
                    System.debug('rcd RecordTypeId:'+ sObjRcd.get('RecordTypeId')); 
                    String recordTypeId=String.valueOf( sObjRcd.get('RecordTypeId'));
                    if(recordTypeId==PersonAccId){
                        recordList.add(sObjRcd);
                    }
                }
            }
            if(recordList.size()>0){
                searchListForReturn.add(recordList);
            }
            System.debug('searchListForReturn:'+searchListForReturn);
            return searchListForReturn;
        }
        else{
            return searchList;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static SObject lookUpById(String recordId, String objName, String fields) {
        
        Integer limitNum = 20;
        
        String finalQuery = 'SELECT ' + fields + ' FROM ' + objName;
        
        finalQuery += ' WHERE Id =  \'' + recordId + '\'';
        
        System.debug('Final Query::::' + finalQuery);
        
        List<SObject> lookUpList = database.query(finalQuery);
        
        return lookUpList[0];  
    }
    /*
@AuraEnabled(cacheable=true)
public static List<SObject> lookupLastViewedRecords(String objName){

if(objName == 'All'){
return ;
}
}*/
}