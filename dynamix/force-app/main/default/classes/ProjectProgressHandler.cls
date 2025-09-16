public class ProjectProgressHandler {
    public static void projectMethod(List<Project_Progress__c> progressList)
    {
        List<Project_Progress__c> projectProgressList = new List<Project_Progress__c>();
        List<Payment_Milestones__c> paymentList = new List<Payment_Milestones__c>();
        List<Payment_Milestones__c> payList = new List<Payment_Milestones__c>();
        Set<Id> setIds = new Set<Id>();
        system.debug('progressList==='+progressList);
        for(Project_Progress__c projectProgress : progressList)
        {
            if(projectProgress.Id != null){
                setIds.add(projectProgress.Id);
            }
        }
        system.debug('setIds==='+setIds);
        List<Project_Progress__c> projList = [select Id,Progress_Status__c,Stage__c,Stage_Type__c from Project_Progress__c where Id IN:setIds and Progress_Status__c = 'Completed'];
        system.debug('projList ===> ' + projList );
        Set<Id> projIds = new Set<Id>();
        if(projList != null){
            for(Project_Progress__c prg: projList)
            {   
                projIds.add(prg.Id);
                system.debug('IN FOR');
                system.debug('prg==='+prg);    
            }
        }
        List<Payment_Milestones__c> paymentObjectList = [select Id,Due_Date__c,Booking__c,Milestone_Status__c,Booking__r.Stage__c,Project_Progress__c,Project_Progress__r.Invoice_Date__c from Payment_Milestones__c where Project_Progress__c  IN:projIds]; 
        
        Set<id> bookIds=new Set<id>();
        for(Payment_Milestones__c pm  : paymentObjectList)
        {
            bookIds.add(pm.Booking__c);
        }
        Map<Id,Booking__c > BookingMap=New Map<Id,Booking__c >([select id,Stage__c,Registration_Status__c from Booking__c where id in : bookIds]);
        system.debug('projList ==='+ paymentObjectList );
        String DueDuration = System.Label.Due_Date_Duration;
        Integer intValue = integer.ValueOf(DueDuration);
        if(paymentObjectList.size() > 0 ){
            for(Payment_Milestones__c planLst :paymentObjectList)
            {   
                if(BookingMap.get(planLst.Booking__c).Stage__c != 'Closed')
                {
                    if(planLst.Id != null){
                        planLst.Milestone_Status__c = 'Active';
                        planLst.Due_Date__c = System.today() + intValue;
                        planLst.Milestone_Activation_Date__c=system.today();
                        payList.add(planLst);
                    }
                }
            }
            update payList;
        }
    }
}