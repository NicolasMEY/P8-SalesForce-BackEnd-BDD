@isTest
public class TripStatusUpdateSchedulerTest {

    @testSetup
    static void setupData() {
        Date today = Date.today();

        // Voyage terminé
        insert new Trip__c(
            Start_Date__c = today.addDays(-10),
            End_Date__c = today.addDays(-1),
            Status__c = ''
        );

        // Voyage en cours
        insert new Trip__c(
            Start_Date__c = today.addDays(-1),
            End_Date__c = today.addDays(5),
            Status__c = ''
        );

        // Voyage à venir
        insert new Trip__c(
            Start_Date__c = today.addDays(2),
            End_Date__c = today.addDays(10),
            Status__c = ''
        );

        // Voyage déjà à jour
        insert new Trip__c(
            Start_Date__c = today.addDays(2),
            End_Date__c = today.addDays(5),
            Status__c = 'Upcoming'
        );

        // Voyage annulé (exclu)
        insert new Trip__c(
            Start_Date__c = today.addDays(-1),
            End_Date__c = today.addDays(5),
            Status__c = 'Cancelled'
        );
    }

    @isTest
    static void testScheduledBatchExecutesCorrectly() {
        // Simulation de la planification et exécution immédiate du job
        Test.startTest();
        TripStatusUpdateScheduler scheduler = new TripStatusUpdateScheduler();
        scheduler.execute(null);  // Simule l'appel du scheduler
        Test.stopTest();

        // Vérifie que les statuts ont bien été mis à jour
        List<Trip__c> trips = [
            SELECT Start_Date__c, End_Date__c, Status__c
            FROM Trip__c
            WHERE Status__c != 'Cancelled'
            ORDER BY Start_Date__c ASC
        ];

        System.assertEquals('Completed', trips[0].Status__c, 'Voyage terminé incorrect');
        System.assertEquals('In Progress', trips[1].Status__c, 'Voyage en cours incorrect');
        System.assertEquals('Upcoming', trips[2].Status__c, 'Voyage à venir incorrect');
        System.assertEquals('Upcoming', trips[3].Status__c, 'Voyage déjà à jour incorrect');
    }
}