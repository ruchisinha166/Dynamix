global class ScheduleBatchforCancellationOfEOICA implements Schedulable {
    
    global void execute(SchedulableContext ctx){
      BatchforCancellationOfEOICA batch = new BatchforCancellationOfEOICA();
      Database.executebatch(batch, 200);
    }
}