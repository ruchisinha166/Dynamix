trigger PaymentTrigger on Payment__c (after insert,after update) {
    if(Trigger.isAfter && Trigger.isInsert){
        PaymentTriggerHandler.updateReceiptNumber(Trigger.new);
    }
    for(Payment__c pay : Trigger.new)
    {
        //system.debug('===> pay ' + pay);
        //system.debug('===> pay.Credit_Note_Reason__c ' + pay.Credit_Note_Reason__c.containsIgnoreCase('Interest')); 
        //system.debug('===> pay.Payment_Status__c ' + pay.Payment_Status__c); 
        if(Trigger.isInsert){
            
            if(pay.Credit_Note_Reason__c!='' && pay.Credit_Note_Reason__c!=null){
                if(pay.Credit_Note_Reason__c.containsIgnoreCase('Interest')){
                    GeneratePaymentReceiptForWaiveOff.GeneratePaymentReceipt(pay.Booking__c,pay.id);
                }
                
            }
        }
        if(Trigger.isInsert){
            Boolean checkCondition = Boolean.valueOf(System.Label.Payment_Trigger);
            if(checkCondition){
                if(pay.Payment_Status__c == 'Approved' )
                {
                    GeneratePaymentReceiptForWaiveOff.GeneratePaymentReceipt(pay.Booking__c,pay.id);
                }
            }
        }
        if(Trigger.isUpdate){
            Boolean checkCondition = Boolean.valueOf(System.Label.Payment_Trigger);
            if(checkCondition){
                Payment__c oldPay = Trigger.oldMap.get(pay.Id);
                if(pay.Payment_Status__c != oldPay.Payment_Status__c && pay.Payment_Status__c == 'Approved'){
                    GeneratePaymentReceiptForWaiveOff.GeneratePaymentReceipt(pay.Booking__c,pay.id);
                }
            }
        }
    }
}