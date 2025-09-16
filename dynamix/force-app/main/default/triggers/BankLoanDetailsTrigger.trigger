trigger BankLoanDetailsTrigger on Bank_Loan_Details__c (before insert,before update,after insert,after update) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        BankLoanDetailsTriggerHandler.UpdateLoanDate1(Trigger.New);
        BankLoanDetailsTriggerHandler.handleLoanStatus(Trigger.New);
        
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        BankLoanDetailsTriggerHandler.UpdateLoanDate(Trigger.New,Trigger.OldMap);
        BankLoanDetailsTriggerHandler.SanctionedValidation(Trigger.New,Trigger.OldMap);
        BankLoanDetailsTriggerHandler.updateLoanClosure(Trigger.new);
        BankLoanDetailsTriggerHandler.updateLoanStatus(Trigger.New,Trigger.OldMap);
        BankLoanDetailsTriggerHandler.handleLoanStatusUpdate(Trigger.New, Trigger.OldMap);
    }
    
    
    /*  if(Trigger.isBefore && Trigger.isDelete){
BankLoanDetailsTriggerHandler.handleLoanStatusDelete(Trigger.Old);
}*/
}