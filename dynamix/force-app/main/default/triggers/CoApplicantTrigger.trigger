trigger CoApplicantTrigger on Co_Applicant__c (before insert) 
{    Integer count = 0;
     for(Co_Applicant__c co : Trigger.New)
     {
         count = [Select count() from Co_Applicant__c where Booking__c =: co.Booking__c AND Account__c =: co.Account__c];
         if(count > 0)
             co.addError('One account can only be added once as co-aaplicant on a booking.');
     }
    
}