public class picklistController {

    @AuraEnabled
    public static list<String> getValues(String values){
        System.debug('values'+values);
        String picklist = '--None--;'+values;
        system.debug('picklist'+picklist);
        list<String> strValues = New list<String>();
        strValues = picklist.split(';');
        system.debug('strValues'+strValues);
        return strValues;
    }
}