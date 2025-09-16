public class PaymentTriggerHandler {
    public static void updateReceiptNumber(List<Payment__c> payList){
        if(!payList.isEmpty()){
            List<Payment__c> paymentToUpdateList = new List<Payment__c>();
            ReceiptNumber__c ct = ReceiptNumber__c.getOrgDefaults();
            for(Payment__c pay:payList){
                if(pay.Receipt_No__c == null){
                    Payment__c payToUpdate = new Payment__c();
                    payToUpdate.Id = pay.Id;
                    payToUpdate.Receipt_No__c = String.valueOf(ct.LastReceiptNumber__c.setscale(0));
                    ct.LastReceiptNumber__c += 1;
                    update ct;
                    paymentToUpdateList.add(payToUpdate);
                }
            }
            if(!paymentToUpdateList.isEmpty()){
                update paymentToUpdateList;
            }
        }
    }
}