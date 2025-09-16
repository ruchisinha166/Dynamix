public class BatchForPaymentMilestoneCorrection implements Database.Batchable<sObject>{
    
    
    Set<Id> milestoneIds = new Set<Id>();
    public BatchForPaymentMilestoneCorrection(){
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        if(test.isRunningTest()){
            return Database.getQueryLocator([select id,name,GST__c,Agreement_Value__c from booking__c Where GST__c!=0]); 
        }
        else{
            String Projectid = system.Label.ProjectID;
            return Database.getQueryLocator([select id,name,GST__c,Agreement_Value__c from booking__c where (Project_Name__c =: Projectid AND GST__c!=0)]);
        }
        
    }
    
    public void execute(Database.BatchableContext BC, List<booking__c> scope)
    {
        set<Id> bkids = new set<Id>();
        
        /* for(booking__c bk : scope)
{
bkids.add(bk.id);
}
List<booking__c> booklist = [select id,name,GST__c,Agreement_Value__c from booking__c where id IN ];*/
        system.debug('===> sc ' + scope);
        map<id,list<Payment_Milestones__c>> bookingPymMList = new map<id,list<Payment_Milestones__c>>();
        
        list<Payment_Milestones__c> paymList = [select id,name,Booking__c,Milestone_Amount1__c,Milestone_age__c from Payment_Milestones__c where booking__c in : scope and name !=: 'Possession/Handover(Other) Charge'];
        list<Payment_Milestones__c> toUpdateList = new list<Payment_Milestones__c>();
        for(Payment_Milestones__c paym : paymList){
            if(!bookingPymMList.keyset().contains(paym.Booking__c)){
                bookingPymMList.put(paym.Booking__c, new list<Payment_Milestones__c>());
            }
            bookingPymMList.get(paym.Booking__c).add(paym);
        }
        for(booking__c bk : scope){  
            if(bookingPymMList.get(bk.id)!=null){
                for(Payment_Milestones__c pay : bookingPymMList.get(bk.id)){
                    if(pay.Booking__c == bk.id){
                        //  pay.Milestone_Amount1__c = (bk.Agreement_Value__c * pay.Milestone_age__c)/100;
                        pay.GST_Amount1__c = (bk.GST__c * pay.Milestone_age__c)/100;
                        toUpdateList.add(pay);
                    }
                }  
            }
            system.debug(toUpdateList.size());
            system.debug(toUpdateList);
            update toUpdateList;
        }        
    }
    
    public void finish(Database.BatchableContext BC){
        System.debug('Payment Milestone records are updated Sucessfully');
    }
}