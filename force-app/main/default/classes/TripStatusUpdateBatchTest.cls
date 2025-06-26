@isTest
public class TripStatusUpdateBatchTest {

    @testSetup
    static void setupData() {
        // Aujourd'hui, 25 juin 2025 (simulation)
        Date today = Date.today();

        // Voyage terminé (end date avant today)
        insert new Trip__c(
            Start_Date__c = today.addDays(-10),
            End_Date__c = today.addDays(-1),
            Status__c = ''
        );

        // Voyage en cours (start date <= today <= end date)
        insert new Trip__c(
            Start_Date__c = today.addDays(-1),
            End_Date__c = today.addDays(5),
            Status__c = ''
        );

        // Voyage à venir (start date > today)
        insert new Trip__c(
            Start_Date__c = today.addDays(2),
            End_Date__c = today.addDays(10),
            Status__c = ''
        );

        // Voyage avec statut déjà correct (In Progress)
        insert new Trip__c(
            Start_Date__c = today.addDays(2),
            End_Date__c = today.addDays(5),
            Status__c = 'Upcoming'
        );

        // Voyage Cancelled (doit être exclu)
        insert new Trip__c(
            Start_Date__c = today.addDays(-1),
            End_Date__c = today.addDays(5),
            Status__c = 'Cancelled'
        );
    }

    @isTest
    static void testBatchUpdate() {
        Test.startTest();
        TripStatusUpdateBatch batch = new TripStatusUpdateBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // On récupère les voyages créés en testSetup (hors 'Cancelled')
        List<Trip__c> trips = [SELECT Status__c, Start_Date__c, End_Date__c FROM Trip__c WHERE Status__c != 'Cancelled' ORDER BY Start_Date__c ASC];


        // Maintenant vérifier par ordre logique
        System.assertEquals('Completed', trips[0].Status__c, 'Statut attendu pour voyage terminé');
        System.assertEquals('In Progress', trips[1].Status__c, 'Statut attendu pour voyage en cours');
        System.assertEquals('Upcoming', trips[2].Status__c, 'Statut attendu pour voyage à venir');
        System.assertEquals('Upcoming', trips[3].Status__c, 'Statut attendu pour voyage déjà correct');
    }
}