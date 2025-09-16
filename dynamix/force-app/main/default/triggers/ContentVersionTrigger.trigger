trigger ContentVersionTrigger on ContentVersion (After update,after insert,before update,before insert) {
    Boolean checkCondition = Boolean.valueOf(System.Label.ContentVersionTrigger);
    if(checkCondition){
        if(Trigger.isBefore && (Trigger.isUpdate)){
            ContentDocumentTriggerHandler.validateNOC(Trigger.new);
        }
        
        if(Trigger.isUpdate && Trigger.isAfter){
            ContentDocumentTriggerHandler.KYCDocumentsUploadedCheckbox(Trigger.New);
            ContentVersionTriggerHandler.updateCancellationDeedDate(Trigger.new);
            ContentDocumentTriggerHandler.sendEmailToRMAndCRMHeadBankNOCUploaded(Trigger.New);
            //ContentDocumentTriggerHandler.ChangeSDRTaskStatusAsChallanRecieved(Trigger.New);
            ContentDocumentTriggerHandler.UpdateBookingBankApprovedCheckbox(Trigger.New);
            ContentDocumentTriggerHandler.updateLoanRcdDocUploadCheckbox(Trigger.New);
            ContentDocumentTriggerHandler.ChangeSDRTaskStatusAsChallanRecieved(Trigger.New);
            SDRAgentNullTriggerHandler.sendSDRLetter(Trigger.New);
            SendEmailWithTDStoCustomer.SendEmail(Trigger.new);
            if(!ContentVersionTriggerHandler.projectIntimationofCompletionFlag){
                ContentVersionTriggerHandler.projectIntimationofCompletionFlag = true;
                ContentVersionTriggerHandler.projectIntimationofCompletionofUnitCheckCheckbox(Trigger.New);
            }
            if(!ContentVersionTriggerHandler.reraCertificateFlag){
                ContentVersionTriggerHandler.reraCertificateFlag = true;
                ContentVersionTriggerHandler.ReraCertificateDocumentsUploadedCheckbox(Trigger.New);
            }
        }
    }
}