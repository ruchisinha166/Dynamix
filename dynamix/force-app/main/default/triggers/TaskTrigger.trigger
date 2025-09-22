trigger TaskTrigger on Task (after insert,after update,before update, before insert) {
    Boolean checkCondition = Boolean.valueOF(System.Label.Task_Trigger);
    if(checkCondition){
        if(Trigger.isAfter && Trigger.isInsert){
            TaskTriggerHandler.sendEmailToRMCRMWhenWelcomeCallTaskCreated(Trigger.New);
            if(!SentSMSToCustomerForNewEnquiry.PreventRecursionOnSentSMSInCaseOfMissedCall)
            {
                SentSMSToCustomerForNewEnquiry.PreventRecursionOnSentSMSInCaseOfMissedCall = true;
                SentSMSToCustomerForNewEnquiry.SentSMSInCaseOfMissedCall(Trigger.New);
            }
        
            TaskTriggerHandler1.calculateTargetForChannelPartnerMeetings(Trigger.New);
            if(!TaskTriggerHandlerForEnquiry.preventRecursionOnTask)
            { 
                TaskTriggerHandlerForEnquiry.preventRecursionOnTask = true;
                TaskTriggerHandlerForEnquiry.missedFollowUptask(Trigger.New);
                TaskTriggerHandler.updateLastCallDetails(Trigger.New);
            }
        }
        if(Trigger.isAfter && Trigger.isUpdate){
            if(!PreventRecursionClass.bookingFormSubmit){
                TaskTriggerHandler.updateReinitiatedDate(Trigger.New,Trigger.oldMap);
                TaskTriggerHandler.sendEmailToRMCRMSharedSDRLetter(Trigger.New,Trigger.oldMap);
                TaskTriggerHandler.sendEmailWhenWelcomeCallRejected(Trigger.New,Trigger.oldMap);
                TaskTriggerHandler.sendEmailWHenDraftAgreementComplete(Trigger.New,Trigger.oldMap);
                TaskTriggerHandler.whenAgreeTaskStatusSharedUpdateBookingAgreeDate(Trigger.New,Trigger.oldMap);
                TaskTriggerHandler.updateStatusAndSendEmailToRM(Trigger.New,Trigger.oldMap);
                TaskTriggerHandler.WelcomeStatusClosedSendEmailToCustomer(Trigger.New,Trigger.oldMap);
                TaskTriggerHandler.whenWelcomeTaskClosedCreateAgreementTask(Trigger.New,Trigger.oldMap);
                TaskTriggerHandler1.deepCleaningTask(Trigger.New,Trigger.oldMap);
                TaskTriggerHandler1.internalSnaggingEmail(Trigger.New,Trigger.oldMap);
                

            }
            if(!TaskTriggerHandler.updateCallLogs)
                { 
                    TaskTriggerHandler.updateCallLogs = true;
                    TaskTriggerHandler.updateLastCallDetails(Trigger.New);
                }
            if(!TaskTriggerHandler.PreventRecursionenquiryStageChange)
            {
                TaskTriggerHandler.PreventRecursionenquiryStageChange = true;
                TaskTriggerHandler.enquiryStageChange(trigger.new,trigger.oldMap);
            }
            if(!EnquiryStateChangeHandler.PreventRecursiononEnquiryStage)
            {
                EnquiryStateChangeHandler.PreventRecursiononEnquiryStage = true;
                EnquiryStateChangeHandler.main(trigger.new,trigger.oldMap);
            }

            if(!TaskTriggerHandlerForEnquiry.preventRecursionOnTask)
            { 
                TaskTriggerHandlerForEnquiry.preventRecursionOnTask = true;
                TaskTriggerHandler.updateLastCallDetails(Trigger.New);
            }
        }
        if(Trigger.isBefore && Trigger.isUpdate){
            TaskTriggerHandler1.setAndValidateDueDate(trigger.new);
            TaskTriggerHandler.validationOnCompletionTask(Trigger.New);
            TaskTriggerHandler.calculateTargetForConnectedCalls(trigger.new);
        if(!TaskTriggerHandler.PreventRecursionOnThrowValidation)
            {
                TaskTriggerHandler.PreventRecursionOnThrowValidation =true;
                TaskTriggerHandler.ThrowValidationOnCompletionTask(Trigger.New,trigger.oldMap);
            }
            TaskTriggerHandler1.errorForSnag(Trigger.New,trigger.oldMap);
            
        }
        if(Trigger.isBefore && Trigger.isInsert){
            TaskTriggerHandler1.setAndValidateDueDate(trigger.new);
            TaskTriggerHandler.assignEnquiryonTask(trigger.new);
            TaskTriggerHandler.calculateTargetForConnectedCalls(trigger.new);
            TaskTriggerHandler.ThrowValidationOnCompletionTask(Trigger.New,trigger.oldMap);
        // TaskTriggerHandler1.errorForSnag(Trigger.New,trigger.oldMap);
        }
    }
}