global class SchedulePreOCFMUnitInspectionTask implements Schedulable {
   global void execute(SchedulableContext sc) {
      PreOCFMUnitInspectionTask batch = new PreOCFMUnitInspectionTask(); 
      database.executebatch(batch,100);
      
   }
}