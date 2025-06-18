public with sharing class TripService {

    public static void createTripsForCloseWon(List<Opportunity> opps, Map<Id, Opportunity> oldOppMap) {
        // opps = Trigger.new / list   oldOppMap = oldMap / Map
        List<Trip__c> tripsToCreate = new List<Trip__c>();

            for( Opportunity opp : opps) {
                Opportunity oldOpp = oldOppMap.get(opp.Id);
                if (opp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won') {

                    Trip__c newTrip = new Trip__c(); // Nouvelle instance de Trip__c
                    newTrip.Account__c = opp.AccountId;
                    newTrip.Opportunity__c = opp.Id;
                    newTrip.Status__c = 'In Progress';
                    newTrip.Destination__c = opp.Destination__c;
                    newTrip.Start_Date__c = opp.Start_Date__c;
                    newTrip.End_Date__c = opp.End_Date__c;
                    newTrip.Number_of_Participants__c = opp.Number_of_Participants__c;
                    newTrip.Total_Cost__c = opp.Amount;

                    tripsToCreate.add(newTrip);
                }
            }
            if(!tripsToCreate.isEmpty()) {
                insert tripsToCreate;
            }
    }
}
