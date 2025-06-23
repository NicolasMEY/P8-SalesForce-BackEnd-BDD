trigger TripDateValidationTrigger on Trip__c (before insert, before update) {
    TripDateValidationHandler.validateDates(Trigger.new);
}

// Ce trigger est remplacé par une Validation rule dans Opportunity et dans Trip__c
// ==> il sera donc placé en inactif