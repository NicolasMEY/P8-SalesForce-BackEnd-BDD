@isTest
private class TripServiceTest {

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

    @isTest
    static void testTripCreationWhenOpportunityClosedWon() {
        Opportunity opp = [SELECT Id, StageName FROM Opportunity LIMIT 1];

        Test.startTest();

        opp.StageName = 'Closed Won';
        update opp;

        Test.stopTest();

        Trip__c createdTrip = [SELECT Id, Opportunity__c, Account__c, Status__c FROM Trip__c WHERE Opportunity__c = :opp.Id LIMIT 1];

        System.assertNotEquals(null, createdTrip, 'Trip should be created.');
        System.assertEquals('In Progress', createdTrip.Status__c, 'Trips status should be in Progress.');
        System.assertEquals(opp.Id, createdTrip.Opportunity__c, 'Trip should be linked to the Opportunity.');
    }

    @isTest
    static void testNoTripCreatedIfNotClosedWon() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Opportunity opp = new Opportunity(
            Name = 'Open Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(5),
            AccountId = acc.Id,
            Amount = 500
        );
        insert opp;

        Test.startTest();

        opp.StageName = 'Qualification';
        update opp;

        Test.stopTest();

        List<Trip__c> trips = [SELECT Id FROM Trip__c WHERE Opportunity__c = :opp.Id];
        System.assertEquals(0, trips.size(), 'No trip should be created if Opportunity is not Closed Won.');
    }
}