public class BookingOfferTriggerHandler {
    
    public static void sendEmailToSMHead(List<Booking_Offer__c> listOfBookingOffers){
        
        Set<Id> setOfProjectIds = new Set<Id>();
        for(Booking_Offer__c bookOffer : listOfBookingOffers){
            if(bookOffer.Project__c != null){
                setOfProjectIds.add(bookOffer.Project__c);
            }
        }
        Map<Id,Project__c> mapIdToProject = new Map<Id,Project__c>([Select Id,name From Project__c Where Id In : setOfProjectIds]);
        List<EmailTemplate> emailTemplateList = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName =: 'Project_Offer_Submitted' OR DeveloperName =: 'Project_Offer_Approved' OR DeveloperName =: 'Project_Offer_Rejected' limit 3];
        Map<String,EmailTemplate> mapNameToTemplate = new Map<String,EmailTemplate>();
        for(emailTemplate temp : emailTemplateList){
            mapNameToTemplate.put(temp.DeveloperName,temp);
        }
        //   String SMHeadUserName = Label.S_M_Head;
        
        // String SiteHeadUserName = Label.Site_Head_User_Name;
        /*  List<User> SMHeadRoleObjUser = [Select Id,Name,Email,UserRole.developerName From User Where ((UserName =: SMHeadUserName AND UserRoleId =: [select id,Name,DeveloperName from UserRole where DeveloperName =: 'S_M_Head'].Id) 
OR (UserName =: SiteHeadUserName AND UserRoleId =: [select id,Name,DeveloperName from UserRole where DeveloperName =: 'Site_Head'].Id))
AND isActive =: true Limit 2];*/
        
        List<User> SMHeadRoleObjUserList = [Select Id,Name,Email,UserRole.DeveloperName From User Where UserRole.DeveloperName =: 'S_M_Head' AND isActive =: true];
        System.debug('SMHeadRoleObjUserList'+SMHeadRoleObjUserList.size());
        List<User> SiteHeadRoleObjUser = [Select Id,Name,Email,UserRole.developerName,UserRole.Name From User Where UserRole.Name like '%Site Head%' AND isActive =: true];
        System.debug('SiteHeadRoleObjUser'+SiteHeadRoleObjUser);
        Map<String,User> mapRoleToUser = new Map<String,User>();
        List<String> smHeadAddresses = new List<String>();
        
        if(SMHeadRoleObjUserList.size()>0){
            for(User userObj : SMHeadRoleObjUserList){
                //mapRoleToUser.put(userObj.UserRole.developerName,userObj);
                if(userObj.Email!=null){
                    smHeadAddresses.add(userObj.Email);
                }
            }
        }
        for(User userObj2 : SiteHeadRoleObjUser){
            mapRoleToUser.put(userObj2.UserRole.developerName,userObj2);
        }
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Booking_Form_Notification']; 
        
        for(Booking_Offer__c bookOfferObj : listOfBookingOffers){
            if(bookOfferObj.Approval_Status__c == 'Submitted'){
                EmailTemplate temp =  mapNameToTemplate.get('Project_Offer_Submitted');
                System.debug('temp'+temp);
                System.debug('temp.HtmlValue'+temp.HtmlValue);
                System.debug('mapNameToTemplate.getProject_Offer_Submitte'+mapNameToTemplate.containsKey('Project_Offer_Submitted'));
                String htmlBody = temp.HtmlValue;
                htmlBody = htmlBody.replace('{!Project}', mapIdToProject.get(bookOfferObj.Project__c).Name);
                //htmlBody = htmlBody.replace('{!User}', mapRoleToUser.get('S_M_Head').Name);
                String plainBody = temp.Body;
                plainBody = plainBody.replace('{!Project}', mapIdToProject.get(bookOfferObj.Project__c).Name);
                //plainBody = plainBody.replace('{!User}', mapRoleToUser.get('S_M_Head').Name);
                String Subject = temp.Subject;
                
                SendEmailandBellNotificationUtility.SendEmail3(String.ValueOf(temp.Id),
                                                               Subject,
                                                               htmlBody,
                                                               plainBody,
                                                               smHeadAddresses,
                                                               null,true,
                                                               bookOfferObj.Id,
                                                               null,null,null);
                
            }else if(bookOfferObj.Approval_Status__c == 'Approved'){
                String projectWiseSiteHeadRole='Site_Head_'+mapIdToProject.get(bookOfferObj.Project__c).Name;
                if(projectWiseSiteHeadRole=='Site_Head_Avanya Tower A'||projectWiseSiteHeadRole=='Site_Head_Avanya Tower B'||projectWiseSiteHeadRole=='Site_Head_Avanya Tower C'){
                    projectWiseSiteHeadRole='Site_Head_Avanya';
                }
                System.debug('projectWiseSiteHeadRole:'+projectWiseSiteHeadRole);
                
                if(mapRoleToUser.size() > 0 && mapRoleToUser.containsKey(projectWiseSiteHeadRole)){
                    String notificationTitle = 'Project Offer Approved';
                    
                    String notificationBody = 'Dear '+mapRoleToUser.get(projectWiseSiteHeadRole).Name+',\n'+ 
                        'The Booking Offer for Launch created for '+mapIdToProject.get(bookOfferObj.Project__c).Name +' has been approved by S&M Head';
                    String targetId=bookOfferObj.Id;
                    Set<String> recipientIds= new Set<String> ();
                    recipientIds.add(mapRoleToUser.get(projectWiseSiteHeadRole).Id);
                    if(recipientIds.size()>0){
                        SendEmailandBellNotificationUtility.SendBellNotification(notificationType.Id, 
                                                                                 notificationTitle, 
                                                                                 notificationBody, 
                                                                                 targetId,
                                                                                 recipientIds);
                    }
                }
            }else if(bookOfferObj.Approval_Status__c == 'Rejected'){
                EmailTemplate temp =  mapNameToTemplate.get('Project_Offer_Rejected');
                String htmlBody = temp.HtmlValue;
                htmlBody = htmlBody.replace('{!Project}', mapIdToProject.get(bookOfferObj.Project__c).Name);
                // htmlBody = htmlBody.replace('{!User}', 'S&M Head');
                String plainBody = temp.Body;
                plainBody = plainBody.replace('{!Project}', mapIdToProject.get(bookOfferObj.Project__c).Name);
                // plainBody = plainBody.replace('{!User}', 'S&M Head');
                String Subject = temp.Subject;
                // List<String> addresses = new List<String>();
                // addresses.add(mapRoleToUser.get('S_M_Head').Email);
                SendEmailandBellNotificationUtility.SendEmail3(String.ValueOf(temp.Id),
                                                               Subject,
                                                               htmlBody,
                                                               plainBody,
                                                               smHeadAddresses,
                                                               null,true,
                                                               bookOfferObj.Id,
                                                               null,null,null);
            }
        }
    }
    
    public static void sendEmailToSMHead2(List<Booking_Offer__c> listOfBookingOffers,Map<Id,Booking_Offer__c> oldMap){
        
        Set<Id> setOfProjectIds = new Set<Id>();
        for(Booking_Offer__c bookOffer : listOfBookingOffers){
            if(bookOffer.Project__c != null){
                setOfProjectIds.add(bookOffer.Project__c);
            }
        }
        Map<Id,Project__c> mapIdToProject = new Map<Id,Project__c>([Select Id,name From Project__c Where Id In : setOfProjectIds]);
        List<EmailTemplate> emailTemplateList = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Project_Offer_Submitted' OR DeveloperName = 'Project_Offer_Approved' OR DeveloperName = 'Project_Offer_Rejected' limit 3];
        Map<String,EmailTemplate> mapNameToTemplate = new Map<String,EmailTemplate>();
        for(emailTemplate temp : emailTemplateList){
            mapNameToTemplate.put(temp.DeveloperName,temp);
        }
        // String SMHeadUserName = Label.S_M_Head;
        // String SiteHeadUserName = Label.Site_Head_User_Name;
        /*  List<User> SMHeadRoleObjUser = [Select Id,Name,Email,UserRole.developerName From User Where ((UserName =: SMHeadUserName AND UserRoleId =: [select id,Name,DeveloperName from UserRole where DeveloperName =: 'S_M_Head'].Id) 
OR (UserName =: SiteHeadUserName AND UserRoleId =: [select id,Name,DeveloperName from UserRole where DeveloperName =: 'Site_Head'].Id))
AND isActive =: true Limit 2];*/
        // List<User> SMHeadRoleObjUser = [Select Id,Name,Email,UserRole.developerName From User Where ((UserName =: SMHeadUserName AND UserRoleId =: [select id,Name,DeveloperName from UserRole where DeveloperName =: 'S_M_Head'].Id))AND isActive =: true Limit 2];
        //  System.debug('SMHeadRoleObjUser'+SMHeadRoleObjUser.size());
        List<User> SMHeadRoleObjUserList1 = [Select Id,Name,Email,UserRole.DeveloperName From User Where UserRole.DeveloperName =: 'S_M_Head' AND isActive =: true];
        System.debug('SMHeadRoleObjUserList1:'+SMHeadRoleObjUserList1.size());
        List<User> SiteHeadRoleObjUser = [Select Id,Name,Email,UserRole.developerName,UserRole.Name From User Where UserRole.Name like '%Site Head%' AND isActive =: true];
        System.debug('SiteHeadRoleObjUser:'+SiteHeadRoleObjUser);
        Map<String,User> mapRoleToUser = new Map<String,User>();
        List<String> smHeadAddresses1 = new List<String>();
        if(SMHeadRoleObjUserList1.size()>0){
            for(User userObj : SMHeadRoleObjUserList1){
                //mapRoleToUser.put(userObj.UserRole.developerName,userObj);
                if(userObj.Email!=null){
                    smHeadAddresses1.add(userObj.Email);
                }
            }
        }
        for(User userObj2 : SiteHeadRoleObjUser){
            mapRoleToUser.put(userObj2.UserRole.developerName,userObj2);
        }
        System.debug('mapRoleToUser:'+mapRoleToUser);
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Booking_Form_Notification']; 
        
        for(Booking_Offer__c bookOfferObj : listOfBookingOffers){
            if(bookOfferObj.Approval_Status__c == 'Submitted' && bookOfferObj.Approval_Status__c != oldMap.get(bookOfferObj.Id).Approval_Status__c){
                System.debug('temp'+mapNameToTemplate.get('Project_Offer_Submitted'));
                EmailTemplate temp =  mapNameToTemplate.get('Project_Offer_Submitted');
                
                String htmlBody = temp.HtmlValue;
                htmlBody = htmlBody.replace('{!Project}', mapIdToProject.get(bookOfferObj.Project__c).Name);
                // htmlBody = htmlBody.replace('{!User}', 'S&M Head');
                String plainBody = temp.Body;
                plainBody = plainBody.replace('{!Project}', mapIdToProject.get(bookOfferObj.Project__c).Name);
                // plainBody = plainBody.replace('{!User}', 'S&M Head');
                String Subject = temp.Subject;
                //List<String> addresses = new List<String>();
                // addresses.add(mapRoleToUser.get('S_M_Head').Email);
                SendEmailandBellNotificationUtility.SendEmail3(String.ValueOf(temp.Id),
                                                               Subject,
                                                               htmlBody,
                                                               plainBody,
                                                               smHeadAddresses1,
                                                               null,true,
                                                               bookOfferObj.Id,
                                                               null,null,null);
                
            }
            else if(bookOfferObj.Approval_Status__c == 'Approved' && bookOfferObj.Approval_Status__c != oldMap.get(bookOfferObj.Id).Approval_Status__c){
                
                String notificationTitle = 'Project Offer Approved';
                String projectWiseSiteHeadRole='Site_Head_'+mapIdToProject.get(bookOfferObj.Project__c).Name;
                if(projectWiseSiteHeadRole=='Site_Head_Avanya Tower A'||projectWiseSiteHeadRole=='Site_Head_Avanya Tower B'||projectWiseSiteHeadRole=='Site_Head_Avanya Tower C'){
                    projectWiseSiteHeadRole='Site_Head_Avanya';
                }
                System.debug('projectWiseSiteHeadRole:'+projectWiseSiteHeadRole);
                if(mapRoleToUser.get(projectWiseSiteHeadRole)!=null){
                    String notificationBody = 'Dear '+mapRoleToUser.get(projectWiseSiteHeadRole).Name+',\n'+ 
                        'The Booking Offer for Launch created for '+mapIdToProject.get(bookOfferObj.Project__c).Name +' has been approved by S&M Head';
                    System.debug('notificationBody:'+notificationBody);
                    String targetId=bookOfferObj.Id;
                    Set<String> recipientIds= new Set<String> ();
                    recipientIds.add(mapRoleToUser.get(projectWiseSiteHeadRole).Id);
                    if(recipientIds.size()>0){
                        SendEmailandBellNotificationUtility.SendBellNotification(notificationType.Id, 
                                                                                 notificationTitle, 
                                                                                 notificationBody, 
                                                                                 targetId,
                                                                                 recipientIds);
                    }
                }
                
            }else if(bookOfferObj.Approval_Status__c == 'Rejected' && bookOfferObj.Approval_Status__c != oldMap.get(bookOfferObj.Id).Approval_Status__c){
                EmailTemplate temp =  mapNameToTemplate.get('Project_Offer_Rejected');
                String htmlBody = temp.HtmlValue;
                htmlBody = htmlBody.replace('{!Project}', mapIdToProject.get(bookOfferObj.Project__c).Name);
                // htmlBody = htmlBody.replace('{!User}', 'S&M Head');
                String plainBody = temp.Body;
                plainBody = plainBody.replace('{!Project}', mapIdToProject.get(bookOfferObj.Project__c).Name);
                //  plainBody = plainBody.replace('{!User}', 'S&M Head');
                String Subject = temp.Subject;
                // List<String> addresses = new List<String>();
                // addresses.add(mapRoleToUser.get('S_M_Head').Email);
                SendEmailandBellNotificationUtility.SendEmail3(String.ValueOf(temp.Id),
                                                               Subject,
                                                               htmlBody,
                                                               plainBody,
                                                               smHeadAddresses1,
                                                               null,true,
                                                               bookOfferObj.Id,
                                                               null,null,null);
            }
        }
    }
}