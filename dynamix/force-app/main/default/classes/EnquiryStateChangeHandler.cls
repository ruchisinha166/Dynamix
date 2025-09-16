public class EnquiryStateChangeHandler {
    Public Static Boolean PreventRecursiononEnquiryStage = False;
    public static void main(List<Task> taskList, Map<id,Task> oldMap){
        
        set<id> taskId = new set<id>();
        List<Enquiry__c> updateEnquiryList = new List<Enquiry__c>();
        
        for(Task taskRecord: taskList){
            String objectName = taskRecord.WhatId.getSObjectType().getDescribe().getName();
            if(objectName == 'Enquiry__c' && taskRecord.Call_Status__c != oldMap.get(taskRecord.id).Call_Status__c && (taskRecord.Call_Status__c == 'Connected' || taskRecord.Call_Status__c == 'Not Connected')){
                taskId.add(taskRecord.WhatId);
            }
        }
        if(!taskId.isEmpty()){
            List<Enquiry__c> enquiryList = [SELECT id,name,Stage__c 
                                            FROM Enquiry__c 
                                            WHERE id IN : taskId 
                                            AND Stage__c = 'New Enquiry'];
            if(!enquiryList.isEmpty()){
                for(Enquiry__c enquiryRecord : enquiryList){
                    {
                        enquiryRecord.Stage__c = 'Contacted';
                        updateEnquiryList.add(enquiryRecord);
                    }
                }
                if(!updateEnquiryList.isEmpty()){
                    update updateEnquiryList;
                }
            }
        }
    }
}