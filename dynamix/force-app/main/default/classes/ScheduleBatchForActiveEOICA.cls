global class ScheduleBatchForActiveEOICA implements Schedulable {
    global void execute(SchedulableContext ctx){
      BatchForActiveEOICA batch = new BatchForActiveEOICA();
      Database.executebatch(batch, 200);
    }
}