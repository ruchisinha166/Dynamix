trigger EnquiryTrigger on Enquiry__c (before insert, before update,after insert, after update, after delete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            EnquiryTriggerHandler.main2(trigger.new);
            if(Trigger.isUpdate){
                EnquiryTriggerHandler.throwValidation(trigger.new, trigger.oldMap);
          
            }       
        }
        if(Trigger.isInsert)
        {
            EnquiryTriggerHandler.main(trigger.new);
            EnquiryTriggerHandler.markEnquiryAsDuplicate(Trigger.New);
            EnquiryTriggerHandler.createAccount(Trigger.New);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            EnquiryTriggerHandler.UpdateTotalChildRecords(Trigger.new);
            
        }
        if(Trigger.isInsert)
        {
          SentSMSToCustomerForNewEnquiry.SentSMSToCustomerForNewEnquiryMethod(Trigger.New);
        }
        if(Trigger.isUpdate)
        {
            SentSMSToCustomerForNewEnquiry.SentSMSToCustomerForNewEnquiryAssignwithProjectMethod(Trigger.New, Trigger.oldMap);
            EnquiryTriggerHandler.countEnquiryAndAddOnEnquiryTarget(Trigger.New);
        }
        if(Trigger.isDelete){
            EnquiryTriggerHandler.UpdateTotalChildRecordsOnDelete(Trigger.old);
        }
    }
}