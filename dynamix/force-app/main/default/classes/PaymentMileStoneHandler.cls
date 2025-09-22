public class PaymentMileStoneHandler {
    
    public static void onBeforeHandler(List<Payment_Milestones__c> progressList)
    {
        Set<Id> progressIdsSet = new Set<Id>();
        for(Payment_Milestones__c pm:progressList){
            
            if(String.isNotBlank(pm.Project_Progress__c)){
                progressIdsSet.add(pm.Project_Progress__c);
                
            }
        } 
        
        Map<Id,Project_Progress__c> projMap = new Map<Id,Project_Progress__c>([select Id,Progress_Status__c,Stage__c,Stage_Type__c from Project_Progress__c where Id IN:progressIdsSet and Progress_Status__c = 'Completed' ]);
        String DueDuration = System.Label.Due_Date_Duration;
        Integer intValue = integer.ValueOf(DueDuration);
        for(Payment_Milestones__c pm : progressList){
            if(!projMap.isEmpty() && projMap.containsKey(pm.Project_Progress__c)){
                pm.Milestone_Status__c = 'Active';
                pm.Due_Date__c = System.today() + intValue;
                pm.Milestone_Activation_Date__c=system.today();
                system.debug('pm.Due_Date__c=='+ pm.Due_Date__c);
            }
            if(pm.Project_Progress__c==NULL && pm.Milestone_Activation_Date__c==date.today()){
                /*pm.Milestone_Status__c = 'Active';
                pm.Due_Date__c = System.today() + intValue;
                pm.Milestone_Activation_Date__c=system.today();
                system.debug('pm.Due_Date__c second condition=='+ pm.Due_Date__c);*/
            }
        }
    }
    /*
* Description: Added By Nachiketa Khera for Payment Milestone API purposes to calculate total milestone % on booking
* Author : Nachiketa Khera
* Created Date : 10th January 2024
*/
    public static void updateMilestonePercentOnBooking(List<Payment_Milestones__c> milestoneList){
        // Get the parent object's field API name and child object's relationship API name
        String totalMilestone = 'Total_Milestone__c';
        
        // Collect the parent object IDs related to the child objects
        Set<Id> parentIds = new Set<Id>();
        for (Payment_Milestones__c child : milestoneList) {
            parentIds.add(child.Booking__c);
        }
        Decimal counter = 0;
        // Loop through the parent objects and update the total child records count
        List<Booking__c> parentsToUpdate = new List<Booking__c>();
        for (Booking__c parent : [SELECT Id, (Select Id,Name,Sequence_No__c,Milestone_age__c from Payment_Milestones__r) FROM Booking__c  WHERE Id IN :parentIds]) {
            //parent.put(totalEnquiries, parent.Enquiries__r.size());
            system.debug('parent'+parent);
            for(Payment_Milestones__c mile : parent.Payment_Milestones__r){
                if(mile.Milestone_age__c != null){
                    counter += mile.Milestone_age__c;
                }
            }
            parent.put(totalMilestone, counter);
            parentsToUpdate.add(parent);
        }
        
        // Update the parent objects with the total child records count
        if(!parentsToUpdate.isEmpty()){
            update parentsToUpdate;
        }
    }
    
    public static void updateMilestonePercentOnBookingOnDelete(List<Payment_Milestones__c> milestoneList){
        // Get the parent object's field API name and child object's relationship API name
        String totalMilestone = 'Total_Milestone__c';
        
        // Collect the parent object IDs related to the child objects
        Set<Id> parentIds = new Set<Id>();
        for (Payment_Milestones__c child : milestoneList) {
            parentIds.add(child.Booking__c);
        }
        Decimal counter = 0;
        // Loop through the parent objects and update the total child records count
        List<Booking__c> parentsToUpdate = new List<Booking__c>();
        for (Booking__c parent : [SELECT Id, (Select Id,Name,Sequence_No__c,Milestone_age__c from Payment_Milestones__r) FROM Booking__c  WHERE Id IN :parentIds]) {
            //parent.put(totalEnquiries, parent.Enquiries__r.size());
            system.debug('parent'+parent);
            for(Payment_Milestones__c mile : parent.Payment_Milestones__r){
                if(mile.Milestone_age__c != null){
                    counter += mile.Milestone_age__c;
                }
            }
            parent.put(totalMilestone, counter);
            parentsToUpdate.add(parent);
        }
        
        // Update the parent objects with the total child records count
        if(!parentsToUpdate.isEmpty()){
            update parentsToUpdate;
        }
    }
    /*Public Static void LastDemandGenerationSendSMStoCustomer(List<Payment_Milestones__c> milestoneList,Map<Id,Payment_Milestones__c> oldPaymentMilestone)
    {
        List<Payment_Milestones__c> paymentMilestoneList = New List<Payment_Milestones__c>();
        Set<Id> bookingIdSet = New Set<Id>();
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        for(Payment_Milestones__c thisPaymentMilestone:milestoneList)
        {
            System.debug('thisPaymentMilestone.Milestone_Status__c'+thisPaymentMilestone.Milestone_Status__c);
            System.debug('oldPaymentMilestone.get(thisPaymentMilestone.id).Milestone_Status__c'+oldPaymentMilestone.get(thisPaymentMilestone.id).Milestone_Status__c);
            if(thisPaymentMilestone.Milestone_Status__c  == 'Active' && 
               thisPaymentMilestone.Milestone_Status__c != oldPaymentMilestone.get(thisPaymentMilestone.id).Milestone_Status__c)
            {
                bookingIdSet.add(thisPaymentMilestone.Booking__c);
                paymentMilestoneList.add(thisPaymentMilestone);
            }
        }
        if(!bookingIdSet.isEmpty())
        {
            Map<String,Id> mapOfOwea= New Map<String,Id>();
            List<OrgWideEmailAddress> oweaList = [SELECT Id, Address, DisplayName 
                                                  FROM OrgWideEmailAddress 
                                                 ];
            if(!oweaList.isEmpty())
            {
                for(OrgWideEmailAddress owea:oweaList)
                {
                    mapOfOwea.put(owea.Address,owea.id);
                }
            }
            
            List<Booking__c> bookingList = [SELECT id, Name, 
                                            (SELECT id,Milestone_Status__c,Sequence_No__c, 
                                             Booking__r.Primary_Applicant_Name_Formulla__c,	
                                             Booking__r.Project_Name_Formulla__c,
                                             Booking__r.Project_Email__c,  Booking__c,
                                             Booking__r.Primary_Applicant__r.PersonEmail,
                                             Booking__r.Primary_Applicant__r.Email__c,
                                             Booking__r.Primary_Applicant__r.PersonMobilePhone
                                             FROM Payment_Milestones__r order By Sequence_No__c Desc Limit 1) 
                                            FROM  Booking__c WHERE ID IN: bookingIdSet];
            SMS_Template_Id__mdt smsTemplate = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='OC Receival Certificate SMS' Limit 1];
            EmailTemplate smsEmailTemp = [Select Id,Name,HtmlValue From EmailTemplate Where Name = 'OC Receival Certificate SMS' Limit 1];
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where Name =: 'OC Receival Certificate Email' LIMIT 1];
            
            Map<id,Payment_Milestones__c> mapOfLastPaymentMilestone = New Map<id,Payment_Milestones__c>();
            for(Booking__c thisBooking: bookingList)
            {
                mapOfLastPaymentMilestone.put(thisBooking.id,thisBooking.Payment_Milestones__r[0]);
            }
            if(!mapOfLastPaymentMilestone.isEmpty())
            {
                for(Payment_Milestones__c thisPaymentMilestone : paymentMilestoneList)
                {
                    if(mapOfLastPaymentMilestone.containskey(thisPaymentMilestone.Booking__c))
                    {
                        Payment_Milestones__c lastPaymentMilestone =  mapOfLastPaymentMilestone.get(thisPaymentMilestone.Booking__c);
                        if(thisPaymentMilestone.id == lastPaymentMilestone.id){
                            if(smsTemplate != null && smsEmailTemp != null)
                            {
                                String templateBody=smsEmailTemp.HtmlValue;
                                String mobileNumber=lastPaymentMilestone.Booking__r.Primary_Applicant__r.PersonMobilePhone;
                                templateBody = templateBody.replace('{customername}',lastPaymentMilestone.Booking__r.Primary_Applicant_Name_Formulla__c);
                                templateBody = templateBody.replace('{projectName}',lastPaymentMilestone.Booking__r.Project_Name_Formulla__c);                       
                                
                                templateBody=templateBody.stripHtmlTags();
                                System.debug('templateBody:'+templateBody);
                                if(!Test.isRunningTest()){
                                    SendSMSUtility.sendSMSMethod(templateBody,mobileNumber,'DYNAMX',smsTemplate.External_Template_Id__c);
                                }
                                EmailMessage objEmailMessage = new EmailMessage();
                                objEmailMessage.status = '3'; // email was sent
                                objEmailMessage.RelatedToId = lastPaymentMilestone.Booking__c;
                                objEmailMessage.fromName = 'Dynamix'; // from name
                                objEmailMessage.Subject = 'SMS sent to customer on Receival of OC';
                                objEmailMessage.HtmlBody = templateBody;
                                insertEmailMessageList.add(objEmailMessage);
                            }
                            
                            if((lastPaymentMilestone.Booking__r.Primary_Applicant__r.PersonEmail != null 
                                && lastPaymentMilestone.Booking__r.Primary_Applicant__r.PersonEmail != '')
                               ||
                               (lastPaymentMilestone.Booking__r.Primary_Applicant__r.Email__c != null 
                                && lastPaymentMilestone.Booking__r.Primary_Applicant__r.Email__c != ''))
                            {
                                try{
                                    System.debug('emailTemplate:'+emailTemplate);
                                    String htmlBody = emailTemplate.HtmlValue;
                                    String plainBody = emailTemplate.Body;
                                    String Subject = emailTemplate.Subject;
                                    Subject = Subject.replace('{projectName}',lastPaymentMilestone.Booking__r.Project_Name_Formulla__c);
                                    htmlBody = htmlBody.replace('{customername}', lastPaymentMilestone.Booking__r.Primary_Applicant_Name_Formulla__c);
                                    htmlBody = htmlBody.replace('{projectName}',lastPaymentMilestone.Booking__r.Project_Name_Formulla__c);
                                    plainBody = plainBody.replace('{customername}',lastPaymentMilestone.Booking__r.Primary_Applicant_Name_Formulla__c);
                                    plainBody = plainBody.replace('{projectName}', lastPaymentMilestone.Booking__r.Project_Name_Formulla__c);
                                    if(emailTemplate!=null){    
                                        List<String> emailList=new List<String>();  
                                        if(lastPaymentMilestone.Booking__r.Primary_Applicant__r.PersonEmail != null 
                                           && lastPaymentMilestone.Booking__r.Primary_Applicant__r.PersonEmail != '')
                                        {
                                            emailList.add(lastPaymentMilestone.Booking__r.Primary_Applicant__r.PersonEmail); 
                                        }
                                        if(lastPaymentMilestone.Booking__r.Primary_Applicant__r.Email__c != null 
                                           && lastPaymentMilestone.Booking__r.Primary_Applicant__r.Email__c != '')
                                        {
                                            emailList.add(lastPaymentMilestone.Booking__r.Primary_Applicant__r.Email__c); 
                                            
                                        }
                                        
                                        if(!Test.isRunningTest()){
                                            SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,Subject,htmlBody,plainBody,emailList,null,true,lastPaymentMilestone.Booking__c,null,null,mapOfOwea.get(lastPaymentMilestone.Booking__r.Project_Email__c));
                                            
                                        }
                                        EmailMessage objEmailMessage = new EmailMessage();
                                        objEmailMessage.status = '3'; // email was sent
                                        objEmailMessage.RelatedToId =lastPaymentMilestone.Booking__c;
                                        objEmailMessage.fromName = 'Dynamix'; // from name
                                        objEmailMessage.Subject = 'Email sent to customer on Receival of OC';
                                        objEmailMessage.HtmlBody = plainBody;
                                        insertEmailMessageList.add(objEmailMessage);
                                    }
                                }
                                catch(Exception ex)
                                {
                                    system.debug('Error----'+ex.getMessage() +' Line Number----' +ex.getLineNumber());
                                }
                            }
                        }
                        
                        
                    }
                }
                
            }
            if(!insertEmailMessageList.isEmpty())
            {
                if(!Test.isRunningTest()){
                    insert insertEmailMessageList;
                }
            }
        }
        
    }*/
}