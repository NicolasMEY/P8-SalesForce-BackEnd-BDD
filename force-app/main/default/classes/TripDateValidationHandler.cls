public with sharing class TripDateValidationHandler {

    public static void validateDates(List<Trip__c> trips) {
        for (Trip__c trip : trips) {
            if(trip.Start_Date__c != null && trip.End_Date__c != null) {
                if(trip.End_Date__c <= trip.Start_Date__c) {
                    trip.End_Date__c.addError('The end date must be later than the start date.');
                }
            }
        }
    }
}