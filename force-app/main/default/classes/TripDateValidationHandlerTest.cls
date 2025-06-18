@isTest
private class TripDateValidationHandlerTest {

    @TestSetup
    static void setupData() {
    
        // Trip valide mais qui deviendra invalide pour tester update plus bas)
        Trip__c invalidTrip = new Trip__c(
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(2)
        );
        insert invalidTrip;
    }
    
    @isTest
    static void testInsertValidTrip() {
        // Vérifie qu'un Trip valide s'insère sans problème
        Trip__c trip = new Trip__c(
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(1)
        );
        insert trip;
        System.assertNotEquals(null, trip.Id, 'The valid Trip should have been inserted');
    }

    @IsTest
    static void testInsertInvalidTrip() {
        // Tente d'insérer un Trip avec des dates incohérentes
        Trip__c trip = new Trip__c(
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(-1) // incohérence de date
        );
        try {
            insert trip;
            System.assert(false, 'Invalid insertion: an exception should have been thrown');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('The end date must be later than the start date.'),
                'Expected error message missing');
        }
    }

    @IsTest
    static void testUpdateToInvalidDates() {
        // Récupère le Trip invalide inséré dans @TestSetup ==> on va voir si ma logique empêche une mise à jour invalide.
        Trip__c tripToUpdate = [SELECT Id, Start_Date__c, End_Date__c FROM Trip__c LIMIT 1];
        tripToUpdate.End_Date__c = tripToUpdate.Start_Date__c.addDays(-1);

        try { // on s'assure que l'update invalide soulève une exception (DML exception)
            update tripToUpdate;
            System.assert(false, 'Invalid update: an exception should have been thrown');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('The end date must be later than the start date.'),
                'Expected error message missing during updateEnd date must be later');
        }
    }
}