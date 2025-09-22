trigger ProjectTrigger on Project__c (After insert,after Update) {
     if(Trigger.isafter && Trigger.isInsert){
        ProjectTriggerHandler.generateCIFFormLink(Trigger.new);
     }
    if(Trigger.isafter && Trigger.isUpdate){
        if(SendnotificationForOCReceival.SendnotificationForOCReceivalFlag)
        {
            SendnotificationForOCReceival.SendnotificationForOCReceivalFlag =false;
            SendnotificationForOCReceival.sendEmail(Trigger.new,Trigger.oldMap);
        }
      
    }
}