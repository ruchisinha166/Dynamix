public class PropertyTriggerHandler {
    public static Boolean propertyflag = false;
    public static void validate(List<Property__c> listOfProperty,Map<Id,Property__c> oldMap){
        Id currentuserId = UserInfo.getUserId();
        if(currentuserId != null){
            User currentUser = [Select Id,UserRoleId,ProfileId From USer Where Id =: currentuserId];
            if(currentUser.UserRoleId != null){
                System.debug('currentUser'+currentUser);
                String RoleName = [Select Id,Name,DeveloperName From UserRole Where Id =: currentUser.UserRoleId].DeveloperName;
                System.debug('RoleName'+RoleName);
                for(Property__c propertyObj : listOfProperty){
                    if(propertyObj.Index__c != oldMap.get(propertyObj.Id).Index__c && RoleName != 'SFDC_Admin'){
                        propertyObj.Index__c.addError('Index Value Can Be Edited By SFDC Admin Only.');
                    }
                }
            }
        }
    }
    public static void customerSnagMethod(List<Property__c> propertyList, Map<id,Property__c> OldMapodProperty)
    {
        Set<Id> propertyIdSet = New Set<Id>();
        Set<Id> bookingIdSet = New Set<Id>();
        List<Property__c> updatePropertyList = New List<Property__c> ();
        for(Property__c thisProperty :propertyList)
        {
            if(thisProperty.Customer_Unit_Inspection_Scheduled_Date__c != null 
               && thisProperty.Customer_Unit_Inspection_Scheduled_Date__c != OldMapodProperty.get(thisProperty.id).Customer_Unit_Inspection_Scheduled_Date__c)
            {           
                propertyIdSet.add(thisProperty.id);
            }
        }
        if(!propertyIdSet.isEmpty())
        {
              Map<String,Id> mapOfOwea= New Map<String,Id>();
             List<OrgWideEmailAddress> oweaList = [SELECT Id, Address, DisplayName 
                                               FROM OrgWideEmailAddress 
                                               ];
            for(OrgWideEmailAddress owea:oweaList)
            {
                mapOfOwea.put(owea.Address,owea.id);
            }

            
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                           from EmailTemplate 
                                           where Name = 'Expected customer unit inspection date' LIMIT 1];
            List<Booking__c> BookList = [Select Id ,Name,Primary_Applicant__r.Name, 
                                         Primary_Applicant__r.PersonEmail,Project_Name__r.Name,Project_Name__r.GPS_location__c,
                                         Project_Name__r.Location__c,Project_Name__r.Project_Phone__c, 
                                         Related_Suggested_Property__r.Unit__c,Project_Name__r.Project_Email__c,
                                         Related_Suggested_Property__r.Unit__r.Customer_Unit_Inspection_Scheduled_Date__c
                                         From Booking__c 
                                         Where Related_Suggested_Property__r.Unit__c IN:propertyIdSet];
            Map<id,Booking__c> mapOfBooking = New Map<id,Booking__c>();
            if(!BookList.isEmpty()){
                for(Booking__c book:BookList){
                    mapOfBooking.put(book.Related_Suggested_Property__r.Unit__c,book);
                    bookingIdSet.add(book.id);
                }
                Map<String,Task> mapOfTask = New Map<String,Task>();
                Map<String,Task> mapOfUnitInspectionTask = New Map<String,Task>();
                List<Task> insertUpdatetaskList  = New List<Task> ();
                List<Task> taskList = [SELECT id, WhatId, Subject,ActivityDate 
                                       From Task 
                                       WHERE 
                                       (((Subject =:'Deep Cleaning Task' OR
                                            Subject =:'FM Customer Unit Inspection Task' ) AND WhatId IN: propertyIdSet) 
                                            OR (Subject =: 'RM Customer Unit Inspection Task'  AND WhatId IN: bookingIdSet))
                                       AND Status != 'Completed'];
                
                for(Task thisTask:taskList)
                {
                    if(thisTask.Subject == 'Deep Cleaning Task')
                    {
                        mapOfTask.put(thisTask.whatId,thisTask);
                    }
                    else 
                    {
                        mapOfUnitInspectionTask.put(thisTask.whatId,thisTask);
                    }
                    
                }
                CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
                List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
                List<String> emailList = new List<String>();                
                for(Property__c thisProperty :propertyList)
                {    Property__c property = New Property__c();
                 property.id = thisProperty.id;
                 Booking__c book = mapOfBooking.get(thisProperty.id); 
                 if((thisProperty.Customer_Unit_Inspection_Scheduled_Date__c != null 
                     && OldMapodProperty.get(thisProperty.id).Customer_Unit_Inspection_Scheduled_Date__c == null)
                    ||(!mapOfTask.containsKey(thisProperty.Id))
                   )
                 {
                     String siteVisitTime = thisProperty.Customer_Unit_Inspection_Scheduled_Date__c.format('HH:mm:ss a'); 
                     Task task  = New Task();
                     task.Subject = 'Deep Cleaning Task';
                     task.ActivityDate = Date.valueof(thisProperty.Customer_Unit_Inspection_Scheduled_Date__c.addDays(-2));
                     task.WhatId = thisProperty.id;
                     task.ownerId = thisProperty.FM_User__c; 
                     property.Snag_Status__c = 'Customer Unit Inspection Scheduled';
                     updatePropertyList.add(property);
                     
                     if(emailTemplate != null && mapOfBooking.containsKey(task.WhatId) ){   
                         emailList = new List<String>();
                         emailList.add(book.Primary_Applicant__r.PersonEmail);    
                         String htmlBody = emailTemplate.HtmlValue;
                         String plainBody = emailTemplate.Body;
                         String Subject = emailTemplate.Subject;
                         Subject = Subject.replace('{!unitNumber}',thisProperty.Name);
                         htmlBody = htmlBody.replace('{!date}',String.valueof(thisProperty.Customer_Unit_Inspection_Scheduled_Date__c));
                         htmlBody = htmlBody.replace('{!time}', siteVisitTime);
                          htmlBody = htmlBody.replace('{!customerName}', book.Primary_Applicant__r.Name);
                         htmlBody = htmlBody.replace('{!projectName}', book.Project_Name__r.Name);
                         htmlBody = htmlBody.replace('{!Location}', book.Project_Name__r.GPS_location__c);
                         htmlBody = htmlBody.replace('{!phoneNumber}',book.Project_Name__r.Project_Phone__c);
                         plainBody = plainBody.replace('{!date}',String.valueof(thisProperty.Customer_Unit_Inspection_Scheduled_Date__c));
                         plainBody = plainBody.replace('{!time}', siteVisitTime);
                         plainBody = plainBody.replace('{!projectName}', book.Project_Name__r.Name);
                         plainBody = plainBody.replace('{!Location}', book.Project_Name__r.GPS_location__c);
                         plainBody = plainBody.replace('{!phoneNumber}', book.Project_Name__r.Project_Phone__c);
                         
                         EmailMessage objEmailMessage = new EmailMessage();
                         objEmailMessage.status = '3'; // email was sent
                         objEmailMessage.RelatedToId = thisProperty.id;
                         objEmailMessage.fromName = 'Dynamix'; // from name
                         objEmailMessage.Subject = 'Email sent to PM for Review of Pre-OC Task';
                         objEmailMessage.HtmlBody = plainBody;
                         insertEmailMessageList.add(objEmailMessage);
                         //SendEmailWithOrgWideAddress.SendEmail(emailTemplate.Id, htmlBody, plainBody, emailList,null,owea.id);
                         SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,Subject,htmlBody,plainBody,emailList,null,true,thisProperty.id,null,null,mapOfOwea.get(book.Project_Name__r.Project_Email__c));
                     }
                     /*if(mapOfUnitInspectionTask.containsKey(thisProperty.id))
                     { Task task =New Task();
                      task.id = mapOfUnitInspectionTask.get(thisProperty.id).id;
                      task.ActivityDate = Date.valueof(thisProperty.Customer_Unit_Inspection_Scheduled_Date__c);
                      insertUpdatetaskList.add(updateTask);
                     }*/
                     insertUpdatetaskList.add(task);
                 }
                 else if(thisProperty.Customer_Unit_Inspection_Scheduled_Date__c != null 
                         && OldMapodProperty.get(thisProperty.id).Customer_Unit_Inspection_Scheduled_Date__c != null 
                         && thisProperty.Customer_Unit_Inspection_Scheduled_Date__c != 
                         OldMapodProperty.get(thisProperty.id).Customer_Unit_Inspection_Scheduled_Date__c
                         && mapOfTask.containsKey(thisProperty.id))
                 {
                     system.debug('mapOfTask.get(thisProperty.id).activityDate'+mapOfTask.get(thisProperty.id).activityDate);
                     if( (mapOfTask.get(thisProperty.id).activityDate > Date.valueof(thisProperty.Customer_Unit_Inspection_Scheduled_Date__c)
                        || 
                        mapOfTask.get(thisProperty.id).activityDate < Date.valueof(thisProperty.Customer_Unit_Inspection_Scheduled_Date__c))
                      //  && mapOfTask.get(thisProperty.id).activityDate  != system.today() 
                        && mapOfTask.get(thisProperty.id).activityDate > system.today() )
                     {
                         
                         Task task  = New Task();
                         task.id = mapOfTask.get(thisProperty.id).id;
                         Datetime  previousWorkingDays = calc.SubtractDays(thisProperty.Customer_Unit_Inspection_Scheduled_Date__c,2);
                         task.ActivityDate = Date.valueof(previousWorkingDays);
                         task.ownerId = thisProperty.FM_User__c;
                         property.Snag_Status__c = 'Customer Unit Inspection Scheduled';
                         updatePropertyList.add(property);
                         insertUpdatetaskList.add(task);
                     }
                     
                 }
                 
                }
                
                
                if(!insertUpdatetaskList.isEmpty())
                {
                    upsert insertUpdatetaskList;
                }
                if(!updatePropertyList.isEmpty())
                {
                    update updatePropertyList;
                }
            }
        }
        
    }
    
    public static void handoverCompletionPercentage(List<Property__c> propertyList)
    {
        Set<Id> projectIdSet = New Set<Id>();
        for(Property__c thisProperty : propertyList)
        {
            projectIdSet.add(thisProperty.Project__c);
        }
        Map<Id,Integer> mapOfProject = New Map<Id,Integer>();
        Map<Id,Integer> mapOfHandoverCompleted = New Map<Id,Integer>();
        Map<Id,Project__c> mapforUpdateProject = New Map<Id,Project__c>();
        if(!projectIdSet.isEmpty()){
            List<Property__c> propertyCountList = [SELECT id, name,Snag_Status__c,Project__c
                                                   FROM Property__c 
                                                   WHERE Project__c IN:projectIdSet];
            system.debug('propertyCountList'+propertyCountList.size());
            for(Property__c thisProperty : propertyCountList)
            {
                if(mapOfProject.containsKey(thisProperty.Project__c))
                {
                    mapOfProject.put(thisProperty.Project__c,mapOfProject.get(thisProperty.Project__c)+1);
                }
                else
                {
                    mapOfProject.put(thisProperty.Project__c,1);
                }
                
                if(thisProperty.Snag_Status__c == 'Handover completed')
                {
                    if(mapOfHandoverCompleted.containsKey(thisProperty.Project__c))
                    {
                        mapOfHandoverCompleted.put(thisProperty.Project__c,mapOfHandoverCompleted.get(thisProperty.Project__c)+1);
                    }
                    else
                    {
                        mapOfHandoverCompleted.put(thisProperty.Project__c,1);
                    }
                }
            }
            for(Property__c thisProperty : propertyList)
            {
                Project__c thisProject = New Project__c();
                if(mapOfProject.containsKey(thisProperty.Project__c))
                {
                    thisProject.Total_Property_Count__c = mapOfProject.get(thisProperty.Project__c);
                }
                if(mapOfHandoverCompleted.containsKey(thisProperty.Project__c))
                {
                    thisProject.Handover_Completed_Percentage__c = mapOfHandoverCompleted.get(thisProperty.Project__c);
                }
                thisProject.id = thisProperty.Project__c;
                mapforUpdateProject.put(thisProject.id,thisProject);
            }
            if(!mapforUpdateProject.isEmpty())
            {
                update mapforUpdateProject.values();
            }
        }
    }
}