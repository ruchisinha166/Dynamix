public class PropertyTriggerHandler {
    public static void validate(List<Property__c> listOfProperty,Map<Id,Property__c> oldMap){
        Id currentuserId = UserInfo.getUserId();
        if(currentuserId != null){
            User currentUser = [Select Id,UserRoleId,ProfileId From USer Where Id =: currentuserId];
            if(currentUser.UserRoleId != null){
                System.debug('currentUser'+currentUser);
                String RoleName = [Select Id,Name,DeveloperName From UserRole Where Id =: currentUser.UserRoleId].DeveloperName;
                System.debug('RoleName'+RoleName);
                for(Property__c propertyObj : listOfProperty){
                    if(propertyObj.Index__c != oldMap.get(propertyObj.Id).Index__c && RoleName != 'SFDC_Admin'){
                        propertyObj.Index__c.addError('Index Value Can Be Edited By SFDC Admin Only.');
                    }
                }
            }
        }
    }
}