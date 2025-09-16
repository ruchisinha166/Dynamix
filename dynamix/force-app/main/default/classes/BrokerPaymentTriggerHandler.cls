public class BrokerPaymentTriggerHandler {
    
    public static void sendEmailToSiteHeadAndSMHead(List<Broker_Payment__c> listOfBrokPayments){
        
        Set<Id> setOfBookingIds = new Set<Id>();
        for(Broker_Payment__c brokObj : listOfBrokPayments){
            setOfBookingIds.add(brokObj.Booking__c);
        }
        Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Project_Name__r.Last_Invoice_Number__c,Project_Name__r.Builder_Organization__r.Builder_Organisation_Initials__c,Project_Name__r.Project_Initials__c,Name,Channel_Partner__c,Unit_Number__c,Project_Name__r.Site_Head__c,Project_Name_Formulla__c From Booking__c Where Id In : setOfBookingIds]);
        Set<Id> setOfCPIds = new Set<Id>();
        for(String key : mapIdToBooking.keySet()){
            setOfCPIds.add(mapIdToBooking.get(key).Channel_Partner__c);
        }
        Map<Id,Account> mapIdToAccount = new Map<Id,Account>([Select Id,Owner.Email,Company_Name__pc,Email__c,Name From Account Where Id In : setOfCPIds]);
        Map<Id,User> usersMap=new Map<Id,User> ([Select Id,Name,Email,IsActive From User Where IsActive=:true]);
        
        //String SMHeadHeadUserName = Label.S_M_Head;
        // String SiteHeadUserName = Label.Site_Head_User_Name;
        List<String> addresses = new List<String>();
        
        //   List<User> SMHeadRoleUser = [Select Id,Name,Email From User Where ((UserName =: SMHeadHeadUserName AND UserRoleId =: [select id from UserRole where DeveloperName =: 'S_M_Head' limit 1].Id) OR (UserName =: SiteHeadUserName AND  UserRoleId =: [select id from UserRole where DeveloperName =: 'Site_Head' limit 1].Id)) Limit 2];
        // List<User> SMHeadRoleUser = [Select Id,Name,Email From User Where (UserName =: SMHeadHeadUserName AND UserRoleId =: [select id from UserRole where DeveloperName =: 'S_M_Head' limit 1].Id)  Limit 1];
        List<User> SMHeadUserList = [Select Id,Name,Email,isActive,UserRole.DeveloperName From User Where UserRole.DeveloperName =: 'S_M_Head' AND isActive=:true];
        
        if(SMHeadUserList.size()>0){
            for(User obj : SMHeadUserList){
                if(obj.Email!=null){
                    addresses.add(obj.Email);     
                }
            }
        }
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Invoice_Payment_Cleared' limit 1];
        
        for(Broker_Payment__c brokObj : listOfBrokPayments){
            if(brokObj.Picklist_Payment_Cleared__c == 'F&F'){
                if(brokObj.Booking__c != null){
                    if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(brokObj.Booking__c)){
                        Booking__c BookObj = mapIdToBooking.get(brokObj.Booking__c);
                        String htmlBody = emailTemplate.HtmlValue;
                        if(BookObj.Unit_Number__c != null){
                            htmlBody = htmlBody.replace('{!Unit}', BookObj.Unit_Number__c);
                        }
                        if(BookObj.Project_Name_Formulla__c != null){
                            htmlBody = htmlBody.replace('{!Project}', BookObj.Project_Name_Formulla__c);
                        }
                        if(BookObj.Name != null){
                            htmlBody = htmlBody.replace('{!Name}', BookObj.Name);
                        }
                        if(brokObj.Amount__c != null){
                            htmlBody = htmlBody.replace('{Payment}', String.valueOf(brokObj.Amount__c));
                        }
                        if(mapIdToAccount.size() > 0 && mapIdToAccount.containsKey(brokObj.Booking__r.Channel_Partner__c)){
                            Account accObj = mapIdToAccount.get(brokObj.Booking__r.Channel_Partner__c);
                            addresses.add(accObj.Owner.Email);      
                            if(accObj.Email__c!=null){
                                addresses.add(accObj.Email__c); 
                            }
                            htmlBody = htmlBody.replace('{!Company}', accObj.Company_Name__pc);
                            htmlBody = htmlBody.replace('{!CP}', accObj.Name);
                        }
                        
                        if(BookObj.Project_Name__r.Builder_Organization__r.Builder_Organisation_Initials__c != null && BookObj.Project_Name__r.Last_Invoice_Number__c != null && BookObj.Project_Name__r.Project_Initials__c != null){
                            String InvoiceNo = BookObj.Project_Name__r.Builder_Organization__r.Builder_Organisation_Initials__c+'/'+BookObj.Project_Name__r.Project_Initials__c+ '/' + Date.Today().Year() +'/'+ String.valueOf(BookObj.Project_Name__r.Last_Invoice_Number__c).leftPad(5, '0');
                            if(InvoiceNo != null){
                                htmlBody = htmlBody.replace('{!InvoiceNum}', InvoiceNo);
                            }
                        }
                        String plainBody = emailTemplate.Body;
                        if(BookObj.Project_Name__r.Builder_Organization__r.Builder_Organisation_Initials__c != null && BookObj.Project_Name__r.Last_Invoice_Number__c != null && BookObj.Project_Name__r.Project_Initials__c != null){
                            String InvoiceNo = BookObj.Project_Name__r.Builder_Organization__r.Builder_Organisation_Initials__c+'/'+BookObj.Project_Name__r.Project_Initials__c+ '/' + Date.Today().Year() +'/'+ String.valueOf(BookObj.Project_Name__r.Last_Invoice_Number__c).leftPad(5, '0');
                            if(InvoiceNo != null){
                                plainBody = plainBody.replace('{!InvoiceNum}', InvoiceNo);
                            }
                        }
                        if(brokObj.Amount__c != null){
                            plainBody = plainBody.replace('{Payment}', String.valueOf(brokObj.Amount__c));
                        }
                        if(BookObj.Unit_Number__c != null){
                            plainBody = plainBody.replace('{!Unit}', BookObj.Unit_Number__c);
                        }
                        if(BookObj.Project_Name_Formulla__c != null){
                            plainBody = plainBody.replace('{!Project}', BookObj.Project_Name_Formulla__c);
                        }
                        if(BookObj.Name != null){
                            plainBody = plainBody.replace('{!Name}', BookObj.Name);
                        }
                        if(mapIdToAccount.size() > 0 && mapIdToAccount.containsKey(brokObj.Channel_Partner__c)){
                            Account accObj = mapIdToAccount.get(brokObj.Channel_Partner__c);
                            plainBody = plainBody.replace('{!Company}', accObj.Company_Name__pc);
                            plainBody = plainBody.replace('{!CP}', accObj.Name);
                        }
                        if(BookObj.Project_Name__r.Site_Head__c!=null){
                            String siteHeadEmail=usersMap.get(BookObj.Project_Name__r.Site_Head__c).Email;
                            System.debug('siteHeadEmail:'+siteHeadEmail);
                            if(!addresses.contains(siteHeadEmail)){
                                addresses.add(siteHeadEmail);
                            }
                        }
                        String Subject = emailTemplate.Subject;
                        SendEmailandBellNotificationUtility.SendEmail3(String.ValueOf(emailTemplate.Id),
                                                                       Subject,
                                                                       htmlBody,
                                                                       plainBody,
                                                                       addresses,
                                                                       null,true,
                                                                       brokObj.Id,
                                                                       null,null,null);
                    }
                }
            }
        }
    }
    
    public static void sendEmailToSiteHeadAndSMHead(List<Broker_Payment__c> listOfBrokPayments,Map<Id,Broker_Payment__c> oldMapBrok){
        
        Set<Id> setOfBookingIds = new Set<Id>();
        for(Broker_Payment__c brokObj : listOfBrokPayments){
            setOfBookingIds.add(brokObj.Booking__c);
        }
        Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Project_Name__r.Last_Invoice_Number__c,Project_Name__r.Builder_Organization__r.Builder_Organisation_Initials__c,Project_Name__r.Project_Initials__c,Name,Channel_Partner__c,Unit_Number__c,Project_Name__r.Site_Head__c,Project_Name_Formulla__c From Booking__c Where Id In : setOfBookingIds]);
        Set<Id> setOfCPIds = new Set<Id>();
        for(String key : mapIdToBooking.keySet()){
            setOfCPIds.add(mapIdToBooking.get(key).Channel_Partner__c);
        }
        Map<Id,Account> mapIdToAccount = new Map<Id,Account>([Select Id,Owner.Email,Name,Email__c,Company_Name__pc From Account Where Id In : setOfCPIds]);
        Map<Id,User> usersMap=new Map<Id,User> ([Select Id,Name,Email,IsActive From User Where IsActive=:true]);
        // String SMHeadHeadUserName = Label.S_M_Head;
        //   String SiteHeadUserName = Label.Site_Head_User_Name;
        List<String> addresses = new List<String>();
        
        //  List<User> SMHeadRoleUser = [Select Id,Name,Email From User Where ((UserName =: SMHeadHeadUserName AND UserRoleId =: [select id from UserRole where DeveloperName =: 'S_M_Head' limit 1].Id) OR (UserName =: SiteHeadUserName AND  UserRoleId =: [select id from UserRole where DeveloperName =: 'Site_Head' limit 1].Id)) Limit 2];
        // List<User> SMHeadRoleUser = [Select Id,Name,Email From User Where (UserName =: SMHeadHeadUserName AND UserRoleId =: [select id from UserRole where DeveloperName =: 'S_M_Head' limit 1].Id)  Limit 1];
        List<User> SMHeadUserList1 = [Select Id,Name,Email,isActive,UserRole.DeveloperName From User Where UserRole.DeveloperName =: 'S_M_Head' AND isActive=:true];
        
        if(SMHeadUserList1.size()>0){
            for(User obj : SMHeadUserList1){
                if(obj.Email!=null){
                    addresses.add(obj.Email);     
                }
            }
        }
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Invoice_Payment_Cleared' limit 1];
        
        for(Broker_Payment__c brokObj : listOfBrokPayments){
            if(brokObj.Picklist_Payment_Cleared__c == 'F&F' && brokObj.Picklist_Payment_Cleared__c != oldMapBrok.get(brokObj.Id).Picklist_Payment_Cleared__c){
                if(brokObj.Booking__c != null){
                    if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(brokObj.Booking__c)){
                        Booking__c BookObj = mapIdToBooking.get(brokObj.Booking__c);
                        String htmlBody = emailTemplate.HtmlValue;
                        
                        if(BookObj.Unit_Number__c != null){
                            htmlBody = htmlBody.replace('{!Unit}', BookObj.Unit_Number__c);
                        }
                        if(BookObj.Project_Name_Formulla__c != null){
                            htmlBody = htmlBody.replace('{!Project}', BookObj.Project_Name_Formulla__c);
                        }
                        if(BookObj.Name != null){
                            htmlBody = htmlBody.replace('{!Name}', BookObj.Name);
                        }
                        if(brokObj.Amount__c != null){
                            htmlBody = htmlBody.replace('{Payment}', String.valueOf(brokObj.Amount__c));
                        }
                        if(mapIdToAccount.size() > 0 && mapIdToAccount.containsKey(brokObj.Channel_Partner__c)){
                            Account accObj = mapIdToAccount.get(brokObj.Channel_Partner__c);
                            addresses.add(accObj.Owner.Email); 
                            if(accObj.Email__c!=null){
                                System.debug('CP Account Email:'+accObj.Email__c);
                                addresses.add(accObj.Email__c); 
                            }
                            if(accObj.Company_Name__pc != null){
                                htmlBody = htmlBody.replace('{!Company}', accObj.Company_Name__pc);
                            }
                            htmlBody = htmlBody.replace('{!CP}', accObj.Name);
                        }
                        if(BookObj.Project_Name__r.Builder_Organization__r.Builder_Organisation_Initials__c != null && BookObj.Project_Name__r.Last_Invoice_Number__c != null && BookObj.Project_Name__r.Project_Initials__c != null){
                            String InvoiceNo = BookObj.Project_Name__r.Builder_Organization__r.Builder_Organisation_Initials__c+'/'+BookObj.Project_Name__r.Project_Initials__c+ '/' + Date.Today().Year() +'/'+ String.valueOf(BookObj.Project_Name__r.Last_Invoice_Number__c).leftPad(5, '0');
                            if(InvoiceNo != null){
                                htmlBody = htmlBody.replace('{!InvoiceNum}', InvoiceNo);
                            }
                        }
                        String plainBody = emailTemplate.Body;
                        if(BookObj.Project_Name__r.Builder_Organization__r.Builder_Organisation_Initials__c != null && BookObj.Project_Name__r.Last_Invoice_Number__c != null && BookObj.Project_Name__r.Project_Initials__c != null){
                            String InvoiceNo = BookObj.Project_Name__r.Builder_Organization__r.Builder_Organisation_Initials__c+'/'+BookObj.Project_Name__r.Project_Initials__c+ '/' + Date.Today().Year() +'/'+ String.valueOf(BookObj.Project_Name__r.Last_Invoice_Number__c).leftPad(5, '0');
                            if(InvoiceNo != null){
                                plainBody = plainBody.replace('{!InvoiceNum}', InvoiceNo);
                            }
                        }
                        if(BookObj.Unit_Number__c != null){
                            plainBody = plainBody.replace('{!Unit}', BookObj.Unit_Number__c);
                        }
                        if(brokObj.Amount__c != null){
                            plainBody = plainBody.replace('{Payment}', String.valueOf(brokObj.Amount__c));
                        }
                        if(BookObj.Project_Name_Formulla__c != null){
                            plainBody = plainBody.replace('{!Project}', BookObj.Project_Name_Formulla__c);
                        }
                        if(BookObj.Name != null){
                            plainBody = plainBody.replace('{!Name}', BookObj.Name);
                        }
                        if(mapIdToAccount.size() > 0 && mapIdToAccount.containsKey(brokObj.Channel_Partner__c)){
                            Account accObj = mapIdToAccount.get(brokObj.Channel_Partner__c);
                            if(accObj.Company_Name__pc != null){
                                plainBody = plainBody.replace('{!Company}', accObj.Company_Name__pc);
                            }
                            plainBody = plainBody.replace('{!CP}', accObj.Name);
                        }
                        if(BookObj.Project_Name__r.Site_Head__c!=null){
                            String siteHeadEmail=usersMap.get(BookObj.Project_Name__r.Site_Head__c).Email;
                            System.debug('siteHeadEmail:'+siteHeadEmail);
                            if(!addresses.contains(siteHeadEmail)){
                                addresses.add(siteHeadEmail);
                            }
                        }
                        String Subject = emailTemplate.Subject;
                        System.debug('htmlBody:=>'+htmlBody);
                        System.debug('plainBody:=>'+plainBody);
                        System.debug('addresses:=>'+addresses);
                        SendEmailandBellNotificationUtility.SendEmail3(String.ValueOf(emailTemplate.Id),
                                                                       Subject,
                                                                       htmlBody,
                                                                       plainBody,
                                                                       addresses,
                                                                       null,true,
                                                                       brokObj.Id,
                                                                       null,null,null);
                    }
                }
            }
        }
    }
}