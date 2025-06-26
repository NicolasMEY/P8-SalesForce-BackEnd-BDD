public class TripStatusUpdateScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        TripStatusUpdateBatch batch = new TripStatusUpdateBatch();
        Database.executeBatch(batch);
    }
}

// String cron = '0 0 2 * * ?';
// System.schedule('Daily Trip Status Update', cron, new TripStatusUpdateScheduler());