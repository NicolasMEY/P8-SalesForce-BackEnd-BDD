trigger OpportunityTrigger on Opportunity (after update) {
TripService.createTripsForCloseWon(Trigger.new, Trigger.oldMap);
}