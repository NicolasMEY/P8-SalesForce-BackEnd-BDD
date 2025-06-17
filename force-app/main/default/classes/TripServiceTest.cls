@isTest
private class TripServiceTest {


        //Méthode pour créer les données communes, pour toute la classe de test
    @TestSetup
    static void setupData(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            AccountId = acc.Id,
            Amount = 1000,
            Destination__c = 'Casablanca',
            Start_Date__c = Date.today().addDays(30),
            End_Date__c = Date.today().addDays(35),
            Number_of_Participants__c = 5
        );
        insert opp;
    }

    // Méthode qui teste que le trip est bien crée quand l'opportunité passe en Closed Won
    static void testTripCreationWhenOpportunityClosedWon() {
        Opportunity opp = [SELECT Id, StageName FROM Opportunity LIMIT 1];
        //On simule une maj pour passer à Closed Won
        opp.StageName = 'Closed Won';
        update opp;
        // Onvérifie qu'un trip a bien été crée et lié à l'opportunité et au compte
        Trip__c createdTrip = [SELECT Id, Opportunity__c, Account__c, Status__c FROM trip__c WHERE Opportunity__c = :opp.Id LIMIT 1];

        System.assertNotEquals(null, createdTrip, 'Trip should be created.');
        System.assertEquals('In Progress', createdTrip.Status__c, 'Trips status should be in Progress.');
        System.assertEquals(opp.Id, createdTrip.Opportunity__c, 'Trip should be linked to the Opportunity.');
    }


    // Méthode de test pour vérifier qu'aucun Trip n'est créé si l'opportunité n'est pas Closed Won
    @isTest
    static void testNoTripCreatedIfNotClosedWon() {
        // Crée une nouvelle opportunité qui reste à un stade ouvert
        Opportunity opp = new Opportunity(
            Name = 'Open Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(5),
            AccountId = [SELECT Id FROM Account LIMIT 1].Id,
            Amount = 500
        );
        insert opp;

        // Met à jour sans la passer à Closed Won
        opp.StageName = 'Qualification';
        update opp;

        // Vérifie qu'aucun Trip n'a été créé pour cette opportunité
        List<Trip__c> trips = [SELECT Id FROM Trip__c WHERE Opportunity__c = :opp.Id];
        System.assertEquals(0, trips.size(), 'No trip should be created if Opportunity is not Closed Won.');
    }
}