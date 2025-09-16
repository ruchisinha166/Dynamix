global class scheduledInterestCalculation implements Schedulable {
   global void execute(SchedulableContext sc) {
      InterestCalculationBatch batch = new InterestCalculationBatch(); 
      database.executebatch(batch);
   }
}