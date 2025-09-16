global class ScheduleBatchforEOICAOpportunity implements Schedulable {
    global void execute(SchedulableContext ctx){
      BatchforEOICAOpportunity batch = new BatchforEOICAOpportunity();
      Database.executebatch(batch, 200);
    }
}