global class BrokerPaymentClearSchedule implements Schedulable{

    global void execute(SchedulableContext sc)
	{
     	BrokerPaymentNotClearBatch brp = new BrokerPaymentNotClearBatch();
       	database.executeBatch(brp, 100);
     }
}