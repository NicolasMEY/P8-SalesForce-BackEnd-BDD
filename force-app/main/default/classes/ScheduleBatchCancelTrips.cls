public with sharing class ScheduleBatchCancelTrips implements Schedulable {
    public void execute(SchedulableContext sc) {
        BatchCancelTrips batch = new BatchCancelTrips();
        Database.executeBatch(batch);
    }
}

// Pour planifier, à mettre dans la console
// ScheduleBatchCancelTrips job = new ScheduleBatchCancelTrips();
// String cronExp = '0 0 0 * * ?'; // Tous les jours à minuit
// ? ==> on n'utilise pas ce champs, quelque soit le jout de la semaine : Day_of_week
// System.schedule('Daily Cancel Trips', cronExp, job);