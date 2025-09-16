public with sharing class GetCustomPermission {
    
    @InvocableMethod(label='Get Custom Permission')
    public static List<Boolean> execute( List<Requests> requestLst){
        
        return new List<Boolean>{FeatureManagement.checkPermission(requestLst[0].permissionName)};
    }

    public class Requests {
        @InvocableVariable(label='Permission Name' required=true)
        public String permissionName;
    }
}