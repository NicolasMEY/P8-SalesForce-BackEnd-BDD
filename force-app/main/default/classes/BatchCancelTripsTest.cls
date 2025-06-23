@IsTest
public class BatchCancelTripsTest {

    // Création des données communes pour tous les tests
    @testSetup
    static void setupTestData() {
        List<Trip__c> trips = new List<Trip__c>();
        
        Date today = Date.today();
        Date targetDate = today.addDays(7);

        // Créer 10 voyages avec moins de 10 participants => qui seront annulés
        for (Integer i = 0; i < 10; i++) {
            trips.add(new Trip__c(
                Start_Date__c = targetDate,
                Number_Of_Participants__c = 5,
                Status__c = 'Upcoming'
            ));
        }

        // Créer 5 voyages qui ne doivent PAS être annulés (participants >= 10)
        for (Integer i = 0; i < 5; i++) {
            trips.add(new Trip__c(
                Start_Date__c = targetDate,
                Number_Of_Participants__c = 15,
                Status__c = 'Upcoming'
            ));
        }

        insert trips;
    }

    // On exécute le Batch et vérifie le résultat
    @IsTest
    static void testBatchCancelTrips() {

        Test.startTest();
        BatchCancelTrips batch = new BatchCancelTrips();
        // Scope = nombre total => 15 enregistrements → 1 seul lot → 1 seul appel execute. Donc pas de découpage multiple. Pas d’erreur « No more than one executeBatch can be called »
        Database.executeBatch(batch, 15);
        Test.stopTest();

        // Vérifier que les voyages avec <10 participants sont bien annulés
        for (Trip__c trip : [
            SELECT Number_Of_Participants__c, Status__c 
            FROM Trip__c 
            WHERE Number_Of_Participants__c < 10
        ]) {
            System.assertEquals('Cancelled', trip.Status__c, 'Trip with low participants should be cancelled');
        }

        // Vérifier que les autres voyages n'ont pas été annulés
        for (Trip__c trip : [
            SELECT Number_Of_Participants__c, Status__c 
            FROM Trip__c 
            WHERE Number_Of_Participants__c >= 10
        ]) {
            System.assertEquals('Upcoming', trip.Status__c, 'Trip with enough participants should remain unchanged');
        }
    }
}