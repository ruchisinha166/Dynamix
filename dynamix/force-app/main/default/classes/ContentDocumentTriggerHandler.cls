public class ContentDocumentTriggerHandler {
    
    public static void validateNOC(List<ContentVersion> conVers){
        system.debug('in NOC validation trigger');
        set<Id> bookingIds = new set<Id>();
        System.debug('bookingIds--------->'+bookingIds);
        Map<Id,Booking__c> mapOfBooking = New Map<Id,Booking__c>();
        System.debug('mapOfBooking--------->'+mapOfBooking);
        for(ContentVersion conVer: conVers){
            system.debug(conver.SobjectType__c+'-----'+conver.Document_Type__c);
            if(conVer.SObjectType__c == 'Booking__c' && conVer.Document_Type__c == 'NOC'){
                bookingIds.add(conVer.BookingId__c);
                System.debug('bookingIds--------->'+bookingIds);
                system.debug('linked booking ---'+conVer.BookingId__c);
            }
        }
        
        list<Booking__c> bookings = [select id,Registration_Status__c from Booking__c 
                                     where id in :bookingIds and Registration_Status__c != 'Completed'];
        System.debug('bookings--------->'+bookings);
        //fetching related bookings with uncompleted registration               
        
        system.debug('bookings---'+bookings);
        bookingIds = new Set<Id>();
        System.debug('bookingIds--------->'+bookingIds);
        for(Booking__c booking: bookings){
            system.debug(booking);
            bookingIds.add(booking.Id); 
            mapOfBooking.put(booking.Id,booking);
            //updated bookingIds with only relevant bookings
        }
        for(ContentVersion conVer: conVers){
            if(mapOfBooking.containsKey(conVer.BookingId__c)){
                system.debug('in condition ---');
                mapOfBooking.get(conVer.BookingId__c).addError('Registration not completed');
            }
        }
    }
   
    public static void updateLoanRcdDocUploadCheckbox(List<ContentVersion> listOfContentVersion){
        if(listOfContentVersion.size()>0){
            set<String> contVerRcdIds=new Set<String>();
            
            for(ContentVersion contVer1:listOfContentVersion){
                System.debug('contVer1:'+contVer1);
                if(contVer1.BookingId__c!=null){
                    contVerRcdIds.add(contVer1.BookingId__c);
                }
            }
            System.debug('contVerRcdIds.size():'+contVerRcdIds.size());
            if(contVerRcdIds.size()>0){
                Map<Id,Bank_Loan_Details__c> bankLoanDeatilsMapList=new Map<Id,Bank_Loan_Details__c>([Select Id,Name,Loan_Closure_Letter_Uploaded__c,Bank_Returned_NOC_Uploaded__c,Bank_Returned_ROC_Uploaded__c From Bank_Loan_Details__c Where Id=:contVerRcdIds]);
                System.debug('bankLoanDeatilsMapList:'+bankLoanDeatilsMapList);
                if(bankLoanDeatilsMapList.size()>0){
                    List<Bank_Loan_Details__c> listofBankLoanForUpdate=new List<Bank_Loan_Details__c>();
                    for(ContentVersion contVer2:listOfContentVersion){  
                        if(contVer2.SObjectType__c=='Bank_Loan_Details__c'){
                            if(contVer2.Document_Type__c=='Loan Closure Letter' && bankLoanDeatilsMapList.get(contVer2.BookingId__c).Loan_Closure_Letter_Uploaded__c==false){                            
                                Bank_Loan_Details__c bankLoanRcd1=new Bank_Loan_Details__c(Id=contVer2.BookingId__c);
                                bankLoanRcd1.Loan_Closure_Letter_Uploaded__c=true;
                                listofBankLoanForUpdate.add(bankLoanRcd1);
                            } 
                            if(contVer2.Document_Type__c=='Bank Returned NOC' && bankLoanDeatilsMapList.get(contVer2.BookingId__c).Bank_Returned_NOC_Uploaded__c==false){                            
                                Bank_Loan_Details__c bankLoanRcd2=new Bank_Loan_Details__c(Id=contVer2.BookingId__c);
                                bankLoanRcd2.Bank_Returned_NOC_Uploaded__c=true;
                                listofBankLoanForUpdate.add(bankLoanRcd2);
                            } 
                            if(contVer2.Document_Type__c=='Bank Returned ROC' && bankLoanDeatilsMapList.get(contVer2.BookingId__c).Bank_Returned_ROC_Uploaded__c==false){                            
                                Bank_Loan_Details__c bankLoanRcd3=new Bank_Loan_Details__c(Id=contVer2.BookingId__c);
                                bankLoanRcd3.Bank_Returned_ROC_Uploaded__c=true;
                                listofBankLoanForUpdate.add(bankLoanRcd3);
                            }                             
                        }
                    }
                    System.debug('listofBankLoanForUpdate:'+listofBankLoanForUpdate);
                    if(listofBankLoanForUpdate.size()>0){
                        update listofBankLoanForUpdate;
                    }
                }
            }
        }
    }    
    
    public static void KYCDocumentsUploadedCheckbox(List<ContentVersion> listOfContentDocumentLink){
        if(!PreventRecursionClass.KYCFlag){
            PreventRecursionClass.KYCFlag = true;
            
            Set<Id> setOfBookingIds = new Set<Id>(); 
            for(ContentVersion ContentDocumentLinkObj : listOfContentDocumentLink){
                if(ContentDocumentLinkObj.BookingId__c != null){
                    setOfBookingIds.add(ContentDocumentLinkObj.BookingId__c);
                }
            }
            System.debug('setOfBookingIds'+setOfBookingIds);
            Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,Bank_Approved_ROC__c,Bank_Approved_NOC__c From Booking__c Where Id In : setOfBookingIds]);
            List<Booking__c> listOfBooking = new List<Booking__c>();
            System.debug('Beofre Loop');
            for(ContentVersion ContentDocumentLinkObj : listOfContentDocumentLink){
                System.debug('ContentDocumentLinkObj.Document_Type__c'+ContentDocumentLinkObj.Document_Type__c);
                if((ContentDocumentLinkObj.Document_Type__c == 'Aadhar' || ContentDocumentLinkObj.Document_Type__c == 'PAN Card') && ContentDocumentLinkObj.SObjectType__c == 'Booking__c'){
                    if(ContentDocumentLinkObj.BookingId__c != null){
                        System.debug('ContentDocumentLinkObj.BookingId__c'+ContentDocumentLinkObj.BookingId__c);
                        if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(ContentDocumentLinkObj.BookingId__c)){
                            Booking__c bookObj = mapIdToBooking.get(ContentDocumentLinkObj.BookingId__c);
                            System.debug('bookObj'+bookObj);
                            if(ContentDocumentLinkObj.Document_Type__c == 'PAN Card'){
                                bookObj.PAN__c = true;
                            }
                            if(ContentDocumentLinkObj.Document_Type__c == 'Aadhar'){
                                bookObj.Aadhar__c = true;
                            }
                            listOfBooking.add(bookObj);
                        }
                    }
                }
            }
            if(!listOfBooking.isEmpty()){
                update listOfBooking;
            }
        }
    }
    
    public static void sendEmailToRMAndCRMHeadBankNOCUploaded(List<ContentVersion> listOfContentVersion){
        
        if(!PreventRecursionClass.flag11){
            PreventRecursionClass.flag11 = true;
            
            Set<Id> setOfBookingIds = new Set<Id>(); 
            for(ContentVersion ContentDocumentLinkObj : listOfContentVersion){
                if(ContentDocumentLinkObj.BookingId__c != null){
                    system.debug('10BookingId__c'+ContentDocumentLinkObj.BookingId__c);
                    setOfBookingIds.add(ContentDocumentLinkObj.BookingId__c);
                }
            }
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Bank_NOC_Document_Uploaded' limit 1];
            String CRMHeadUserName = Label.CRM_Head_User;
            User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: [select id from UserRole where DeveloperName =: 'CRM_Head' limit 1].Id AND isActive =: true Limit 1];
            List<String> addresses = new List<String>();
            addresses.add(CRMHeadRoleObjUser.Email);     
            System.debug('Before Loop'+addresses);
            Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,OwnerId From Booking__c Where Id In : setOfBookingIds]);
            System.debug('mapIdToBooking'+mapIdToBooking);
            
            for(ContentVersion ContentVersionObj : listOfContentVersion){
                System.debug('In ContentVersionObj ;;;'+ContentVersionObj.BookingId__c);
                if(ContentVersionObj.BookingId__c != null){
                    if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(ContentVersionObj.BookingId__c)){
                        System.debug('In bookObj');
                        if(ContentVersionObj.Document_Type__c == 'Bank Approved NOC' && ContentVersionObj.SObjectType__c == 'Booking__c'){
                            
                            Booking__c bookObj = mapIdToBooking.get(ContentVersionObj.BookingId__c);
                            String htmlBody = emailTemplate.HtmlValue;
                            addresses.add(bookObj.OwnerId);
                            String htmlBody1 = emailTemplate.HtmlValue;
                            String plainBody1 = emailTemplate.Body;
                            SendEmailandBellNotificationUtility.SendEmail2(emailTemplate.Id,null,htmlBody1,plainBody1,addresses,null,true,bookObj.Id,null,null,null,null);
                            
                        }
                    }
                }
            }
        }
    }
    
    public static void ChangeSDRTaskStatusAsChallanRecieved(List<ContentVersion> listOfContentDocumentLink){
        System.debug('In ChangeSDRTaskStatusAsChallanRecieved Method');
        if(!PreventRecursionClass.flag4){
            PreventRecursionClass.flag4 = true;
            Set<id> setOfContentDocumentIds = new Set<id>();
            for(contentversion cv : listOfContentDocumentLink) {
                setOfContentDocumentIds.add(cv.contentdocumentid);
            }
            ContentDocument conDocObj = [Select Id,ParentId From ContentDocument Where Id In : setOfContentDocumentIds limit 1];
            System.debug('conDocObj'+conDocObj);
            contentdocumentlink  CDLList = [select id,LinkedEntityId,linkedentity.type ,contentdocumentid   from contentdocumentlink where contentdocumentid  in :setOfContentDocumentIds limit 1];
            System.debug('CDLList'+CDLList);
            System.debug('CDLList'+CDLList.LinkedEntityId);
            Set<Id> setOfBookingIds = new Set<Id>(); 
            for(ContentVersion ContentDocumentLinkObj : listOfContentDocumentLink){
                if(ContentDocumentLinkObj.BookingId__c != null){
                    setOfBookingIds.add(ContentDocumentLinkObj.BookingId__c);
                }
            }
            System.debug('setOfBookingIds'+setOfBookingIds);
            Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,OwnerId From Booking__c Where Id In : setOfBookingIds]);
            System.debug('mapIdToBooking'+mapIdToBooking);
            List<Task> listOfSDRTasks = new List<Task>([Select Id,Status,whatId,Subject From Task Where Subject =: 'SDR Letter for the Booking' AND WhatId In : setOfBookingIds]);
            System.debug('listOfSDRTasks'+listOfSDRTasks);
            Map<Id,Task> mapBookingIdToSDRTask = new Map<Id,Task>();
            for(Task taskObj : listOfSDRTasks){
                mapBookingIdToSDRTask.put(taskObj.whatId,taskObj);
            }
            List<Booking__c> listOfBooking = new List<Booking__c>();
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'SDR_Payment_received' limit 1];
            String CRMHeadUserName = Label.CRM_Head_User;
            String userRole = [select id from UserRole where DeveloperName = 'CRM_Head' limit 1].Id;
            User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =:userRole AND isActive =: true Limit 1];
            List<String> addresses = new List<String>();
            addresses.add(CRMHeadRoleObjUser.Email);     
            
            System.debug('mapBookingIdToSDRTask'+mapBookingIdToSDRTask);
            List<Task> listOfSDRTasksToUpdate = new List<Task>();
            for(ContentVersion ContentDocumentLinkObj : listOfContentDocumentLink){
                System.debug('In ContentDocumentLinkObj'+ContentDocumentLinkObj.Document_Type__c);
                if(ContentDocumentLinkObj.Document_Type__c == 'SDR Challan Copy' && ContentDocumentLinkObj.SObjectType__c == 'Booking__c'){
                    System.debug('ContentDocumentLinkObj.BookingId__c'+ContentDocumentLinkObj.BookingId__c);
                    if(ContentDocumentLinkObj.BookingId__c != null){
                        if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(ContentDocumentLinkObj.BookingId__c)){
                            System.debug('In bookObj');
                            Booking__c bookObj = mapIdToBooking.get(ContentDocumentLinkObj.BookingId__c);
                            bookObj.SDR_Completed_Date__c = System.today();
                            listOfBooking.add(bookObj);
                            if(mapBookingIdToSDRTask.size() > 0 && mapBookingIdToSDRTask.containsKey(bookObj.Id)){
                                System.debug('In SDRTask');
                                Task SDRTask = mapBookingIdToSDRTask.get(bookObj.Id);
                                SDRTask.Status = 'Challan Received';
                                listOfSDRTasksToUpdate.add(SDRTask);
                                
                                String htmlBody = emailTemplate.HtmlValue;
                                addresses.add(bookObj.OwnerId);
                                SendEmailandBellNotificationUtility.SendEmail(
                                    String.valueOf(emailTemplate.Id),
                                    htmlBody,
                                    '',
                                    addresses,
                                    null
                                );
                            }
                        }
                    }
                }
            }
            if(!listOfBooking.isEmpty()){
                update listOfBooking;
            }
            if(!listOfSDRTasksToUpdate.isEmpty()){
                update listOfSDRTasksToUpdate;
            }
        }
    }
    public static void UpdateBookingBankApprovedCheckbox(List<ContentVersion> listOfContentDocumentLink){
        if(!PreventRecursionClass.flag51){
            PreventRecursionClass.flag51 = true;
            Set<Id> setOfBookingIds = new Set<Id>(); 
            for(ContentVersion ContentDocumentLinkObj : listOfContentDocumentLink){
                if(ContentDocumentLinkObj.BookingId__c != null){
                    setOfBookingIds.add(ContentDocumentLinkObj.BookingId__c);
                }
            }
            System.debug('setOfBookingIds'+setOfBookingIds);
            Map<Id,Booking__c> mapIdToBooking = new Map<Id,Booking__c>([Select Id,Name,Bank_Approved_ROC__c,Bank_Approved_NOC__c From Booking__c Where Id In : setOfBookingIds]);
            List<Booking__c> listOfBooking = new List<Booking__c>();
            System.debug('Beofre Loop');
            for(ContentVersion ContentDocumentLinkObj : listOfContentDocumentLink){
                System.debug('ContentDocumentLinkObj.Document_Type__c'+ContentDocumentLinkObj.Document_Type__c);
                if((ContentDocumentLinkObj.Document_Type__c == 'Bank Approved ROC' || ContentDocumentLinkObj.Document_Type__c == 'Bank Approved NOC') && ContentDocumentLinkObj.SObjectType__c == 'Booking__c'){
                    if(ContentDocumentLinkObj.BookingId__c != null){
                        System.debug('ContentDocumentLinkObj.BookingId__c'+ContentDocumentLinkObj.BookingId__c);
                        if(mapIdToBooking.size() > 0 && mapIdToBooking.containsKey(ContentDocumentLinkObj.BookingId__c)){
                            Booking__c bookObj = mapIdToBooking.get(ContentDocumentLinkObj.BookingId__c);
                            System.debug('bookObj'+bookObj);
                            if(ContentDocumentLinkObj.Document_Type__c == 'Bank Approved NOC'){
                                bookObj.Bank_Approved_NOC__c = true;
                            }
                            if(ContentDocumentLinkObj.Document_Type__c == 'Bank Approved ROC'){
                                bookObj.Bank_Approved_ROC__c = true;
                            }
                            listOfBooking.add(bookObj);
                        }
                    }
                } 
            }
            if(!listOfBooking.isEmpty()){
                System.debug('listOfBooking update');
                update listOfBooking;
            }
        }
    }
    
}