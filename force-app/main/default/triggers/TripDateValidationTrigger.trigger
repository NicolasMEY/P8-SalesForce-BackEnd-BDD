trigger TripDateValidationTrigger on Trip__c (before insert, before update) {
    TripDateValidationHandler.validateDates(Trigger.new);
}