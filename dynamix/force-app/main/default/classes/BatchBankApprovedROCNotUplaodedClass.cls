global class BatchBankApprovedROCNotUplaodedClass implements DataBase.Batchable<Sobject>{
    global Database.QueryLocator start(DataBase.BatchableContext bc){
        
        Date pastThreeDays = System.Today().addDays(-3);
        Date pastSixDays = System.Today().addDays(-6);
        List<Booking__c> b = [Select Id,Name,OwnerId,Owner.Name,CreatedById,ROC_Uploaded_Date__c From Booking__c Where ROC_Uploaded_Date__c =: pastThreeDays OR ROC_Uploaded_Date__c =: pastSixDays];
        System.debug('booookings'+b);

        return Database.getQueryLocator('Select Id,Name,OwnerId,Owner.Name,CreatedById,ROC_Uploaded_Date__c From Booking__c Where ROC_Uploaded_Date__c =: pastThreeDays OR ROC_Uploaded_Date__c =: pastSixDays');
    }
    global void execute(Database.BatchableContext bc,List<Booking__c> BookingList){
        System.debug('booookings');
        EmailTemplate emailTemplate1 = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Bank_Approved_ROC_Not_Uploded_After_3_days' limit 1];
        EmailTemplate emailTemplate2 = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Bank_Approved_ROC_Not_Uploded_Even_After_6_Days' limit 1];
        UserRole CRMHeadRoleObj = [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'];
        String CRMHeadUserName = Label.CRM_Head_User;
        User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: CRMHeadRoleObj.Id AND isActive =: true Limit 1];
        System.debug('CRMHeadRoleObjUser'+CRMHeadRoleObjUser);

        Set<Id> setOfBookinIds = new Set<Id>();
        for(Booking__c bookObj : BookingList){
            setOfBookinIds.add(bookObj.Id);
        }
        System.debug('setOfBookinIds'+setOfBookinIds);
        List<ContentVersion> listOfContentVersions = new List<ContentVersion>([Select Id,SObjectType__c,Document_Type__c,BookingId__c From ContentVersion where Document_Type__c =: 'Bank Approved ROC' AND BookingId__c In : setOfBookinIds]);
        Map<Id,ContentVersion> mapBookingIdToContenVersion = new Map<Id,ContentVersion>();
        
        for(ContentVersion con : listOfContentVersions){
            mapBookingIdToContenVersion.put(con.BookingId__c,con);
        }
        System.debug('mapBookingIdToContenVersion'+mapBookingIdToContenVersion);
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Email,Name From User Where isActive =: true]);   
        OrgWideEmailAddress orgEmail = [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName = 'Divum' Limit 1];
        List<Messaging.SingleEmailMessage> emailMsgList = New List<Messaging.SingleEmailMessage>();
        
        System.debug('Before Loop');
        for(Booking__c bookObj : BookingList){
            String recordLink=URL.getOrgDomainUrl().toExternalForm() + '/' + bookObj.Id;
            System.debug('bookObj'+bookObj);

            if(bookObj.ROC_Uploaded_Date__c.addDays(3) == Date.today()){
                System.debug('bookObj.ROC_Uploaded_Date__c.addDays(3)'+bookObj.ROC_Uploaded_Date__c.addDays(3));
                List<String> addresses1 = new List<String>();
                if(mapIdToUser.size() > 0 && mapIdToUser.containsKey(bookObj.OwnerId)){
                    addresses1.add(mapIdToUser.get(bookObj.OwnerId).Email); 
                }
                if(!mapBookingIdToContenVersion.containsKey(bookObj.Id)){   
                    System.debug('In mapBookingIdToContenVersion');
                    String htmlBody1 = emailTemplate1.HtmlValue;
                    htmlBody1 = htmlBody1.replace('{!bookingName}', '<a href="'+recordLink+'">' + bookObj.Name +'</a>');
                    htmlBody1 = htmlBody1.replace('{!rmName}', mapIdToUser.get(bookObj.OwnerId).Name);
                    String plainBody1 = emailTemplate1.Body;
                    plainBody1 = plainBody1.replace('{!bookingName}', '<a href="'+recordLink+'">' + bookObj.Name +'</a>'); 
                    plainBody1 = plainBody1.replace('{!rmName}', mapIdToUser.get(bookObj.OwnerId).Name);

                    SendEmailandBellNotificationUtility.SendEmail2(emailTemplate1.Id,htmlBody1,plainBody1,addresses1,null,true,bookObj.Id,null,null,null);
                }
            }
            if(bookObj.ROC_Uploaded_Date__c.addDays(6) == Date.today()){
                List<String> addresses2 = new List<String>();
                addresses2.add(CRMHeadRoleObjUser.Email);     
                if(!mapBookingIdToContenVersion.containsKey(bookObj.Id)){
                    String htmlBody1 = emailTemplate2.HtmlValue;
                    htmlBody1 = htmlBody1.replace('{!bookingName}', '<a href="'+recordLink+'">' + bookObj.Name +'</a>');
                    htmlBody1 = htmlBody1.replace('{!rmName}', mapIdToUser.get(bookObj.OwnerId).Name);
                    htmlBody1 = htmlBody1.replace('{!crmHeadName}', CRMHeadRoleObjUser.Name);
                    String plainBody1 = emailTemplate2.Body;
                    plainBody1 = plainBody1.replace('{!bookingName}', '<a href="'+recordLink+'">' + bookObj.Name +'</a>'); 
                    plainBody1 = plainBody1.replace('{!rmName}', mapIdToUser.get(bookObj.OwnerId).Name);

                    plainBody1 = plainBody1.replace('{!crmHeadName}', CRMHeadRoleObjUser.Name);
                    SendEmailandBellNotificationUtility.SendEmail2(emailTemplate2.Id,htmlBody1,plainBody1,addresses2,null,true,bookObj.Id,null,null,null);
                }
            }
        }
    }
    global void finish(Database.BatchableContext bc){
        
    }
}