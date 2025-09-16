public class GenerateDemandForSelectedMilestone {
    @InvocableMethod(label='Generate Demand Letter')
    public static void execute(List<Request> Requests){
        String jsonString=String.valueOf(Requests[0].milestoneRecords);
        List<String> lstString = jsonString.split(',');
        System.debug('lstString:'+lstString);
        System.debug('lstString size:'+lstString.size());
        
        Set<String> milestoneIds= new Set<String>();
        if(lstString.size()>0){
            for(String mId: lstString){
                System.debug('mId:'+mId);
                String mIdReturnString = mId.substringBetween('"', '"');
                System.debug('mIdReturnString'+mIdReturnString);
                milestoneIds.add(mIdReturnString);
            }
        }
        System.debug('milestoneIds==>'+milestoneIds);
        
        List<Payment_Milestones__c> paymentMiestoneList = [select Id,Due_Date__c,Milestone_Status__c from Payment_Milestones__c where Id IN: milestoneIds]; 
        System.debug('Selected PaymentMiestoneList===>'+paymentMiestoneList);
        
        List<Payment_Milestones__c> paymentMilestoneForUpdate=new List<Payment_Milestones__c>();
        if(paymentMiestoneList.size()>0){
            String dueDateDuration = System.Label.Due_Date_Duration;
            Integer intDueDateValue = integer.ValueOf(dueDateDuration);
            for(Payment_Milestones__c payMilstoneRcd: paymentMiestoneList){
                Payment_Milestones__c pmUpdateRcd=new Payment_Milestones__c();
                pmUpdateRcd.Id= payMilstoneRcd.Id;
                pmUpdateRcd.Milestone_Status__c = 'Active';
                pmUpdateRcd.Due_Date__c = System.today() + intDueDateValue;
                pmUpdateRcd.Milestone_Activation_Date__c=system.today();
                paymentMilestoneForUpdate.add(pmUpdateRcd);
            }
            System.debug('paymentMilestoneForUpdate ==>'+paymentMilestoneForUpdate);
            update paymentMilestoneForUpdate;
        }
    }
    public class Request {
        @InvocableVariable(label='Selected Milestone Records' required=true)
        public String[] milestoneRecords;
    }
}