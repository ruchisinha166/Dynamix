trigger CheckStatusforInvoicePDF on Payment_Milestones__c (after insert,after update) {
    list<id> PaymentMilestonesId=new list<id>();
    for(Payment_Milestones__c pm : trigger.New)
    {
        if(Trigger.isInsert)
        {
            if(pm.Milestone_Status__c.equals('Active') && Trigger.isInsert /*&& pm.Project_Progress__c==null*/)
            {
                PaymentMilestonesId.add(pm.id);
            }
        }
        if(Trigger.isUpdate)
        {    
            Payment_Milestones__c oldpm = Trigger.oldMap.get(pm.Id);
            System.debug('oldpm.Milestone_Status__c:'+oldpm.Milestone_Status__c);
            //if((!oldpm.Milestone_Status__c.equals('Active') && pm.Milestone_Status__c.equals('Active')))
            if(oldpm.Milestone_Status__c!='Active' && pm.Milestone_Status__c=='Active')
            {
                PaymentMilestonesId.add(pm.id);
            }
            System.debug('PaymentMilestonesId:'+PaymentMilestonesId);
        }        
    }
    if(PaymentMilestonesId.size()>0)
    {
        if(Trigger.isInsert){
         //GenerateInvoicePDF.generateInvoicelist(PaymentMilestonesId,true);
        }
        if(Trigger.isUpdate){
             //GenerateInvoicePDF.generateInvoicelist(PaymentMilestonesId,false);
        }
        // GenerateInvoicePDF.sendSMS(PaymentMilestonesId);
        // system.debug('PaymentMilestonesId=='+PaymentMilestonesId);
    }
}