global class ScheduleBatchforEOIWithoutBooking implements Schedulable {
    
    global void execute(SchedulableContext ctx){
      BatchforEOIWithoutBooking batch = new BatchforEOIWithoutBooking();
      Database.executebatch(batch, 200);
    }
}