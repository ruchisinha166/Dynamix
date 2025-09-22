public class DeactivateExpiredLaddersBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, End_Date__c, Active__c ' +
            'FROM Brokerage_Ladder__c ' +
            'WHERE Active__c = TRUE ' +
            'AND End_Date__c < TODAY'
        );
    }

    public void execute(Database.BatchableContext bc, List<Brokerage_Ladder__c> scope) {
        for (Brokerage_Ladder__c ladder : scope) {
            ladder.Active__c = false;
        }
        if (!scope.isEmpty()) {
            update scope;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch completed. Expired ladders deactivated.');
    }
}