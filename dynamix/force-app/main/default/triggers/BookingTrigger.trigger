trigger BookingTrigger on Booking__c (before Insert,after Update,after insert,before update,after delete) {
    Boolean checkCondition = Boolean.valueOf(System.Label.Booking_Trigger);
     if(Trigger.isAfter && Trigger.isInsert){
        BookingNumberOnCampaign.getBookingsOnCampaign(Trigger.New);
         if(checkCondition){
             BookingTaskTargetCount.bookingTaskTarget(Trigger.New);
         }
        
         MarkCarParkAvailable.AvailableParkin(Trigger.new);
            // SurveyBookingLink.sendbookinglink(Trigger.newMap);
    }
    if(Trigger.isAfter && Trigger.isDelete){
        BookingNumberOnCampaign.getBookingsOnCampaignDelete(Trigger.Old);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        if(!PreventRecursionClass.bookingFormSubmit){
            BookingTriggerHandler.validateRefundFields(Trigger.New);
            BookingTriggerHandler.GetBookingLastStage(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.UpdateBookingStatusAsRefund(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.BookingCancellationUpdateApprover1(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.BookingCancellationUpdateApprover(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.BookingCancellationUpdateStage(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.SDRLetterSharedDateToday(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.UpdateClodeDraftAgreementDate(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.whenWelcomeEmailCheckBoxTrueSDRPopulateInitiatedDate(Trigger.New,Trigger.OldMap);
            //AssignCarParkonProperty.carPark(Trigger.New,trigger.OldMap);
          BookingTriggerHandler.carPark(Trigger.New,Trigger.OldMap);

        }
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        if(!PreventRecursionClass.bookingFormSubmit){
            PreventRecursionClass.bookingFormSubmit=true;
            BookingTriggerHandler.kycDetailsProvidedNotificationToRM(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.sendEmailToRMANDCRMHeadIfFirstDisbursementValuesChanges(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.createBankLoanDetailsRecord(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.BookingCancellationUpdateProjectAddOnCharges(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.SubmitBookingForCancellation(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.BookingCancellationUpdateOpportunityStage(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.BookingCancellationNotification(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.updateBookingAfterRegistraion(Trigger.New,Trigger.OldMap);
            if(checkCondition){
                BookingTriggerHandler.createSDRLetterTask(Trigger.New,Trigger.OldMap);
            }
            BookingTriggerHandler.closeDraftTaskAndSendNotificationAndEmail(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.changeSDRLetterTaskStatusAsSent(Trigger.New,Trigger.OldMap);
            BookingTriggerHandler.generateAllotmentLetter(Trigger.New,Trigger.OldMap);
            
        }
    }
    
    //list<Booking__c> bookingListBooked =new list<Booking__c>();
    List<Co_Applicant__c> coAppList = new List<Co_Applicant__c>();
    List<ID> bookingId =new List<ID>();
    list<Booking__c> bookinglist =new list<Booking__c>();
    List<Booking__c> listOfNOC =new List<Booking__c>();
    List<Booking__c> brokerChangeList =new List<Booking__c>();
    if(trigger.isafter && trigger.isupdate)
    {
        for(Integer i=0; i<trigger.new.size(); i++)
        {
            system.debug('trigger.new[i].Stage__c '+trigger.new[i].Stage__c );
             system.debug('trigger.old[i].Stage__c '+trigger.old[i].Stage__c );
            if(trigger.new[i].Stage__c != trigger.old[i].Stage__c )
            {
                if(trigger.new[i].Stage__c == 'Booked'  )
                {
                    bookinglist.add(trigger.new[i]);
                    List<Co_Applicant__c> coAppList = new List<Co_Applicant__c>();
                    coAppList = [select id,name,Account__r.name,Account__r.Aadhar_No__pc,Account__r.PersonEmail,Account__r.Aadhar_Uploaded__pc,Account__r.PAN_No__pc,Account__r.PAN_Card_Uploaded__pc,PAN_Number__c,Role__c,Email__c,Booking__c from Co_Applicant__c where Role__c!='Primary' and Booking__c =:trigger.new[i].id];
                    String Error='';
                    for(Co_Applicant__c c: coAppList)
                    {
                        if((c.Account__r.PersonEmail==null || c.Account__r.PersonEmail=='') || (c.Account__r.PAN_No__pc==null || c.Account__r.PAN_No__pc=='') ||(c.Account__r.PAN_Card_Uploaded__pc==false))
                        {
                            if(Error=='')
                            {
                                Error= Error + 'KYC and Email details are missing for Co-Applicant Name ' +c.Account__r.name;  
                            }
                            else
                            {
                                Error= Error +','+c.Account__r.name;
                            }
                            system.debug(' Error== '+ Error);
                        }
                    }    
                    if(Error!='')
                    {
                        Error= Error +'.';
                        trigger.new[i].addError(Error);    
                    }
                } 
                
            }
            
            
            if(trigger.new[i].Registration_Status__c != trigger.old[i].Registration_Status__c)
            {
                if(trigger.new[i].Registration_Status__c == 'Completed'){
                    listOfNOC.add(trigger.new[i]);   
                }
            }
            
        }
        if(listOfNOC.size() > 0)
        {
            string jsonString= JSON.serialize(listOfNOC);
            BookingTriggerHandler.generateNOCLetter(jsonString);
        }
        BookingTaskTargetCount.bookingCancellationTaskTarget(Trigger.New,trigger.OldMap);
    }
    if(trigger.isbefore && trigger.isupdate)
    {
        for(Integer i=0; i<trigger.new.size(); i++)
        {
            if(trigger.new[i].Channel_Partner__c!= trigger.old[i].Channel_Partner__c && trigger.new[i].Channel_Partner__c!=null)
            {
                brokerChangeList.add(trigger.new[i]); 
            }
        }
        system.debug('brokerChangeList=='+brokerChangeList);
        if(brokerChangeList.size() > 0)
        {
            BookingTriggerHandler.updateBrokerDetails(brokerChangeList);
        }
    } 
    
    
}