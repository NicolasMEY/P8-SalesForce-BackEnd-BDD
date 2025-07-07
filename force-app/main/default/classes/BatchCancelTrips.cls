public with sharing class BatchCancelTrips implements Database.Batchable<SObject> {
    
    
    public Database.QueryLocator start (Database.BatchableContext bc) {
        Date today = Date.today();
        Date targetDate = today.addDays(7);

        return Database.getQueryLocator([
            SELECT Id, Number_Of_Participants__c, Status__c
            FROM Trip__c
            WHERE Start_Date__c = :targetDate
            AND Status__c != null
            AND Number_Of_Participants__c < 10
            WITH SECURITY_ENFORCED
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Trip__c> trips) {
        for (Trip__c trip : trips) {
            trip.Status__c = 'Cancelled';
        }
        // update trips;
        
        // Update partiel avec gestion d’erreur
        Database.SaveResult[] results = Database.update(trips, false);
        for (Database.SaveResult res : results) {
            if (!res.isSuccess()) {
                System.debug('Erreur lors de la mise à jour Trip__c : ' + res.getErrors()[0].getMessage());
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
        // je le laisse vide pour l'instant <==
    }
}