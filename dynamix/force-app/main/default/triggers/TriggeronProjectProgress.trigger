trigger TriggeronProjectProgress on Project_Progress__c (after insert,after update) 
{
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
    {
       // ProjectProgressHandler.projectMethod(Trigger.New);
    }
}