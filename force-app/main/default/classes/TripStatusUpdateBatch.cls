public with sharing class TripStatusUpdateBatch implements Database.Batchable<SObject> {
    
            public Database.QueryLocator start(Database.BatchableContext bc) {
                Date today = Date.today();
        
                // requête dynamique sous forme de String
                String query = 'SELECT Id, Status__c, Start_Date__c, End_Date__c ' +
                               'FROM Trip__c ' +
                               'WHERE Status__c NOT IN (\'Cancelled\', \'Completed\')' +
                               'WITH SECURITY_ENFORCED';
        
                return Database.getQueryLocator(query);
            }
        
            public void execute(Database.BatchableContext bc, List<Trip__c> trips) {
                Date today = Date.today();
                List<Trip__c> toUpdate = new List<Trip__c>();
        
                for (Trip__c trip : trips) {
                    String newStatus;
        
                    if (trip.End_Date__c != null && today > trip.End_Date__c ) {
                        newStatus = 'Completed';
                    } else if (trip.Start_Date__c != null && today >= trip.Start_Date__c && today <= trip.End_Date__c && trip.Status__c != 'In Progress') {
                        newStatus = 'In Progress';
                    } else if (trip.Start_Date__c != null && today < trip.Start_Date__c && trip.Status__c != 'Upcoming') {
                        newStatus = 'Upcoming';
                    }
        
                    // Only update if status is different
                    if (newStatus != null && trip.Status__c != newStatus) {
                        System.debug('➡️ Mise à jour : ' + trip.Status__c + ' → ' + newStatus);

                        trip.Status__c = newStatus;
                        toUpdate.add(trip);
                    }
                    else {
                        System.debug('Aucune mise à jour pour : (statut déjà correct)');
                    }
                }
        
                if (!toUpdate.isEmpty()) {
                    update toUpdate;
                }
            }
        
            public void finish(Database.BatchableContext bc) {
                // ......
            }
}