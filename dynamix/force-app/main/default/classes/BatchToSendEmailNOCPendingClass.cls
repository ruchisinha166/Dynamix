global class BatchToSendEmailNOCPendingClass implements DataBase.Batchable<Sobject>{
    
    global Database.QueryLocator start(DataBase.BatchableContext bc){
        Date pastThreeDays = System.Today().addDays(-3);
        List<Booking__c> a = [Select Id,Name,OwnerId,NOC_Uploaded_Date__c From Booking__c Where NOC_Uploaded_Date__c =: pastThreeDays];
        System.debug('a'+a);
        return Database.getQueryLocator('Select Id,Name,OwnerId,NOC_Uploaded_Date__c From Booking__c Where NOC_Uploaded_Date__c =: pastThreeDays');
    }
    global void execute(Database.BatchableContext bc,List<Booking__c> BookingList){
        
        UserRole CRMHeadRoleObj = [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'];
        String CRMHeadUserName = Label.CRM_Head_User;
        User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: CRMHeadRoleObj.Id AND isActive =: true Limit 1];
        System.debug('CRMHeadRoleObjUser'+CRMHeadRoleObjUser);
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName =: 'NOC_Not_Uploaded_Email_Template' limit 1];
        System.debug('emailTemplate'+emailTemplate);
        Set<Id> setOfBookingOWnerIds = new Set<Id>();
        for(Booking__c bookObj : BookingList)
            setOfBookingOWnerIds.add(bookObj.OwnerId);
        System.debug('setOfBookingOWnerIds'+setOfBookingOWnerIds);
        Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Email From User Where isActive =: true AND Id IN : setOfBookingOWnerIds]);
        System.debug('mapIdToUser'+mapIdToUser);
        List<String> addresses = new List<String>();
        addresses.add(CRMHeadRoleObjUser.Email);
        Set<Id> setOfBookingIds = new Set<Id>();
        for(Booking__c bookObj : BookingList)
            if(bookObj.Id != null)
            setOfBookingIds.add(bookObj.Id);
        System.debug('setOfBookingIds'+setOfBookingIds);
        List<ContentVersion> listOfContentVersions = new List<ContentVersion>([Select Id,SObjectType__c,Document_Type__c,BookingId__c From ContentVersion where Document_Type__c =: 'Bank Approved NOC' AND BookingId__c In : setOfBookingIds]);
        Map<Id,ContentVersion> mapBookingIdToContenVersion = new Map<Id,ContentVersion>();
        
        for(ContentVersion con : listOfContentVersions){
            mapBookingIdToContenVersion.put(con.BookingId__c,con);
        }
        System.debug('mapBookingIdToContenVersion'+mapBookingIdToContenVersion);
        for(Booking__c bookObj : BookingList){
            System.debug('bookObj'+bookObj);
            String recordLink=URL.getOrgDomainUrl().toExternalForm() + '/' + bookObj.Id;
            System.debug('bookObj.NOC_Uploaded_Date__c'+bookObj.NOC_Uploaded_Date__c);
            if((bookObj.NOC_Uploaded_Date__c).addDays(3) == Date.today()){
                System.debug('bookObj.NOC_Uploaded_Date__c'+bookObj.NOC_Uploaded_Date__c);
                addresses.add(mapIdToUser.get(bookObj.OwnerId).Email);
                if(!mapBookingIdToContenVersion.containsKey(bookObj.Id)){
                    System.debug('In mapBookingIdToContenVersion'+mapBookingIdToContenVersion);
                    String htmlBody = emailTemplate.htmlValue;
                    htmlBody = htmlBody.replace('{!bookingName}', '<a href="'+recordLink+'">' + bookObj.Name +'</a>');
                    htmlBody = htmlBody.replace('{!crmHeadName}', CRMHeadRoleObjUser.Name);
                    String plainBody = emailTemplate.Body;
                    plainBody = plainBody.replace('{!bookingName}', '<a href="'+recordLink+'">' + bookObj.Name +'</a>'); 
                    plainBody = plainBody.replace('{!crmHeadName}', CRMHeadRoleObjUser.Name);
                    String Subject = emailTemplate.Subject;
                    Subject = bookObj.Name + ' ' + Subject;
                    SendEmailandBellNotificationUtility.SendEmail2(emailTemplate.Id,htmlBody,plainBody,addresses,null,true,bookObj.Id,null,null,null);
                }
            }
        }
    } 
    global void finish(Database.BatchableContext bc){
        
    }
}