@isTest
public class ScheduleBatchCancelTripsTest {
    
    @testSetup
    static void setup() {
        List<Trip__c> trips = new List<Trip__c>();
        Date targetDate = Date.today().addDays(7);
        for (Integer i = 0; i < 10; i++) {
            trips.add(new Trip__c(
                Start_Date__c = targetDate,
                Number_Of_Participants__c = 5,
                Status__c = 'Upcoming' // valeur valide
            ));
        }
        insert trips;
    }
    
    @isTest
    static void testScheduledBatch() {
        List<Trip__c> tripsBefore = [SELECT Id, Status__c FROM Trip__c WHERE Start_Date__c = :Date.today().addDays(7)];
        
        for (Trip__c t : tripsBefore) {
            System.assertEquals('Upcoming', t.Status__c);
        }
        
        Test.startTest();
        
        // Planifier le job (test uniquement la planification)
        String cronExp = '0 0 0 1 1 ? 2099';
        ScheduleBatchCancelTrips job = new ScheduleBatchCancelTrips();
        String jobId = System.schedule('Test Scheduled Batch', cronExp, job);
        
        // Cela force le batch à s’exécuter immédiatement dans le contexte du test. Ainsi : Le batch met à jour les enregistrements directement et complètement pendant le test, on peux vérifier la modification des statuts juste après Test.stopTest().
        BatchCancelTrips batch = new BatchCancelTrips();
        Database.executeBatch(batch);
        
        Test.stopTest();
        
        List<Trip__c> tripsAfter = [SELECT Id, Status__c FROM Trip__c WHERE Start_Date__c = :Date.today().addDays(7)];
        for (Trip__c t : tripsAfter) {
            System.assertEquals('Cancelled', t.Status__c, 'Le statut devrait être Cancelled');
        }
    }
}