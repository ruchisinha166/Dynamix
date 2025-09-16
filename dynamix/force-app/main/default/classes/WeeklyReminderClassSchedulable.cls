global class WeeklyReminderClassSchedulable implements Schedulable {
    
	global void execute(SchedulableContext ctx) 
   {
		database.executeBatch(new BatchPaymentReminderForBooking(),200);
   }   
}