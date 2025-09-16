public class SDRAgentNullTriggerHandler {
    public static void handleSDRAgentTrigger(List<Booking__c> newRecords) {
        System.debug('Trigger  is running');
        for (Booking__c record : newRecords) {
            System.debug('Inside for loop');
            if(record.Welcome_Email_Checker__c==True && record.SDR_Agent__c == null){
                System.debug('Email Checker If');
                List<SDR_Agent__c> existingSDRAgents = [SELECT Id FROM SDR_Agent__c];
                system.debug('SDR Agents List>>'+existingSDRAgents);
                if(existingSDRAgents.isEmpty()){
                    record.SDR_Agent__c.addError('Please contact the admin to create the SDR Agent');
                }
            }
            
        }     
    }
    
    public static void sendSDRLetter(List<ContentVersion> listOfContentVersion){
        String ProjectName;
        String Unit;
        String PrimaryApplicant;
        String OwnerID;
        String bookingID;
        String RMPhone;
        String RMName;
        String RMEmail;
        String AttachmentName;
        Blob Data;
        String filetype;
        String Email;
        
        
        //Primary Applicant Details
        String PrimAppName;
        String PrimAppPAN;
        String PrimAppPassport;
        String PrimAppOCI;
        Boolean PrimAppNRICheck;
        String BillingStreet;
        String BillingCity;
        String BillingState;
        String BillingCountry;
        String BillingPostalCode;
        String Address;
        
        
        //CoApplicant Details
        String CoAppName;
        String CoAppPAN;
        String CoAppPassport;
        String CoAppOCI;
        Boolean CoAppNRICheck;
        String CoAppBillingStreet;
        String CoAppBillingCity;
        String CoAppBillingState;
        String CoAppBillingCountry;
        String CoAppBillingPostalCode;
        String CoAppAddress;
        String htmlcombinedDetails = '';
        String plaincombinedDetails = '';

        
        
        if(!listOfContentVersion.isEmpty()){
            Set<Id> bookingIDs = new Set<Id>();
            Set<Id> CoAppAccIDs = new Set<Id>();
            Set<Id> contentDocumentIDSet = new Set<Id>();
            for(ContentVersion CV:listOfContentVersion){
                if(CV.SObjectType__c=='Booking__c' && CV.Document_Type__c == 'SDR Letter'){
                    if(Cv.BookingId__c!=null){
                        bookingIDs.add(CV.BookingId__c);
                    }
                    if(CV.SObjectType__c=='Booking__c' && CV.Document_Type__c=='SDR Letter'){
                        Data = CV.VersionData;
                        AttachmentName = CV.Title;
                        filetype = CV.FileType;
                    }
            if(!bookingIDs.isEmpty()){
                List<Booking__c> booking = [Select Id,Name,OwnerId,Owner.Name,Unit_Number__c, Owner.Email,Owner.Phone,Primary_Applicant__c,Project_Name__r.Name From Booking__c Where Id In : bookingIDs];
                if(!booking.isEmpty()){
                    for(Booking__c book:booking){
                        ProjectName = book.Project_Name__r.Name;
                        Unit = book.Unit_Number__c;
                        PrimaryApplicant = book.Primary_Applicant__c;
                        OwnerID = book.OwnerId;
                        bookingID = book.ID;
                    }
                    
                    List<User> userList = [SELECT Id, Name, Email,Phone FROM User WHERE Id=:OwnerID];
                    for(User usr:userList){
                    
                    RMName = usr.Name;
                    RMEmail = usr.Email;
                    RMPhone = usr.Phone;
                }
                }
            }
            //Get Primary Applicant Details
            List<Account> AccList = [Select Id,Name,PersonEmail,PAN_No__pc,PersonMailingStreet, PersonMailingCity, PersonMailingState, PersonMailingPostalCode, PersonMailingCountry,Passport__c,OCI_PIO_Card__c,NRI__c From Account Where Id=:PrimaryApplicant ];
            if(!AccList.isEmpty()){
                for(Account Acc:AccList){
                    Email=Acc.PersonEmail;
                    PrimAppName = 'Name of the Applicant 1: Mr./Ms./Mrs. '+Acc.Name;
                    if(Acc.PAN_No__pc!=null){
                        PrimAppPAN  = 'Pan Card Number of the Applicant 1: '+Acc.PAN_No__pc;
                    }
                    
                    
                    if(Acc.PersonMailingStreet!=null){
                        BillingStreet = Acc.PersonMailingStreet+',';
                    }
                    if(Acc.PersonMailingCity!=null){
                        BillingCity = Acc.PersonMailingCity + ',';
                    }
                    if(Acc.PersonMailingState!=null){
                        BillingState = Acc.PersonMailingState + ',';
                    }
                    if(Acc.PersonMailingPostalCode!=null){
                        BillingPostalCode = Acc.PersonMailingPostalCode + ',';
                    }
                    if(Acc.PersonMailingCountry!=null){
                        BillingCountry = Acc.PersonMailingCountry + ',';
                    }
                    Address = BillingStreet + BillingCity + BillingState + BillingPostalCode + BillingCountry;
                    
                    if(Acc.NRI__c==True){
                        PrimAppPassport = 'Passport of the Applicant 1: '+Acc.Passport__c;
                        PrimAppOCI = 'OCI/PIO Card of the Applicant 1: '+Acc.OCI_PIO_Card__c;
                        PrimAppNRICheck = Acc.NRI__c;
                    }
                }
            }
            
            
            
            //Get Co-Applicants
            List<Co_Applicant__c> coAppList = [Select Id,Applicant_Name__c,Account__r.Id,PAN_Number__c,Role__c,Account__r.NRI__c,Account__r.Passport__c,Account__r.OCI_PIO_Card__c From Co_Applicant__c where Booking__c=:bookingID AND Role__c=:'Co-Applicant' ];
            if(!coAppList.isEmpty()){
                for(Co_Applicant__c coApp:coAppList){
                    CoAppAccIDs.add(coApp.Account__r.Id);
                }
            }
     
            List<Account> CoAppAccountList = [Select Id,Name,PersonEmail,PersonMailingStreet, PersonMailingCity, PersonMailingState, PersonMailingPostalCode, PersonMailingCountry,PAN_No__pc,Passport__c,OCI_PIO_Card__c,NRI__c From Account Where Id IN : CoAppAccIDs ];
            if(!CoAppAccountList.isEmpty()){
                Integer AppNo = 2;
                for(Account coAppAcc:CoAppAccountList){
                   
                   	CoAppName ='Name of the Applicant '+AppNo+' : Mr./Ms./Mrs.'+  coAppAcc.Name;
                    if(coAppAcc.PAN_No__pc!=null){
                        CoAppPAN  = 'Pan Card Number of the Applicant '+AppNo+' : '+coAppAcc.PAN_No__pc;
                    }
                    else{
                        CoAppPAN = 'Pan Card Number of the Applicant '+AppNo+' : NA';
                    }
                    if(coAppAcc.PersonMailingStreet!=null){
                        coAppBillingStreet = coAppAcc.PersonMailingStreet+',';
                    }
                    if(coAppAcc.PersonMailingCity!=null){
                        coAppBillingCity = coAppAcc.PersonMailingCity + ',';
                    }
                    if(coAppAcc.PersonMailingState!=null){
                        coAppBillingState = coAppAcc.PersonMailingState + ',';
                    }
                    if(coAppAcc.PersonMailingPostalCode!=null){
                        coAppBillingPostalCode = coAppAcc.PersonMailingPostalCode + ',';
                    }
                    if(coAppAcc.PersonMailingCountry!=null){
                        CoAppBillingCountry = coAppAcc.PersonMailingCountry + ',';
                    }
                    CoAppAddress ='Address of Applicant '+AppNo+' : '+ CoAppBillingStreet + CoAppBillingCity + CoAppBillingState + CoAppBillingPostalCode + CoAppBillingCountry;
                    if(CoAppAcc.NRI__c==True){
                        CoAppPAssport = 'Passport of Applicant '+AppNo+' : '+coAppAcc.Passport__c;
                        CoAppOCI = 'OCI/PIO Card of the Applicant '+AppNo+' : '+coAppAcc.OCI_PIO_Card__c;
                    }
                    else{
                        CoAppPAssport = 'Passport of Applicant '+AppNo+' : NA';
                        CoAppOCI = 'OCI/PIO Card of the Applicant '+AppNo+' : NA';
                    }
                    AppNo+=1;
                    plaincombinedDetails +=  CoAppName+ '\n\n';
                    plaincombinedDetails +=  CoAppPAN+ '\n\n';
                    plaincombinedDetails +=  CoAppPAssport+ '\n\n';
                    plaincombinedDetails +=  CoAppOCI+ '\n\n';
                    plaincombinedDetails +=  CoAppAddress+ '\n\n';
                    htmlcombinedDetails += CoAppName +'<br><br>';
                    htmlcombinedDetails += CoAppPAN +'<br><br>';
                    htmlcombinedDetails += CoAppPAssport + '<br><br>';
                    htmlcombinedDetails += CoAppOCI + '<br><br>';
                    htmlcombinedDetails += CoAppAddress +'<br><br>';
                
                }
                
                EmailTemplate EmailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Send_SDR_Letter_to_Customer' LIMIT 1];
                String Subject = 'Stamp Duty Letter for '+Unit+' | '+ProjectName;
                String htmlbody = EmailTemplate.HtmlValue;
                String plainBody = EmailTemplate.Body;
                //Details of Primary Applicant
                if(!AccList.isEmpty()){
                    htmlbody = htmlbody.replace('{!Name of the 1st Applicant}',PrimAppName);
                    plainbody = plainbody.replace('{!Name of the 1st Applicant}',PrimAppName);
                }
                
                if(PrimAppPAN!=null && PrimAppNRICheck!=True){
                    htmlbody = htmlbody.replace('{!Name of the 1st Applicant}',PrimAppName);
                    plainbody = plainbody.replace('{!Name of the 1st Applicant}',PrimAppName);
                    plainbody = plainbody.replace('{!Pan Card Number of the 1st Applicant}',PrimAppPAN);
                    htmlbody = htmlbody.replace('{!Pan Card Number of the 1st Applicant}',PrimAppPAN);
                    htmlbody = htmlbody.replace('{!PAssport}','Passport of Applicant 1: NA');
                    plainbody = plainbody.replace('{!PAssport}','Passport of Applicant 1: NA');
                    htmlbody = htmlbody.replace('{!OCICard}','OCI/PIO Card of the Applicant 1: NA');
                    plainbody = plainbody.replace('{!OCICard}','OCI/PIO Card of the Applicant 1: NA');
                }
                else if (PrimAppPAN==null && PrimAppNRICheck!=False){
                    htmlbody = htmlbody.replace('{!Pan Card Number of the 1st Applicant}','Pan Card Number of the Applicant 1: NA');
                    plainbody = plainbody.replace('{!Pan Card Number of the 1st Applicant}','Pan Card Number of the Applicant 1: NA');
                    htmlbody = htmlbody.replace('{!PAssport}','Passport of Applicant 1: NA');
                    plainbody = plainbody.replace('{!PAssport}','Passport of Applicant 1: NA');
                    htmlbody = htmlbody.replace('{!OCICard}','OCI/PIO Card of the Applicant 1: NA');
                    plainbody = plainbody.replace('{!OCICard}','OCI/PIO Card of the Applicant 1: NA');
                }
                else if(PrimAppNRICheck==True && PrimAppPAN!=null){
                    htmlbody = htmlbody.replace('{!Pan Card Number of the 1st Applicant}',PrimAppPAN);
                    plainbody = plainbody.replace('{!Pan Card Number of the 1st Applicant}',PrimAppPAN);
                    htmlbody = htmlbody.replace('{!PAssport}',PrimAppPassport);
                    htmlbody = htmlbody.replace('{!OCICard}',PrimAppOCI);
                    plainbody = plainbody.replace('{!PAssport}',PrimAppPassport);
                    plainbody = plainbody.replace('{!OCICard}',PrimAppOCI);
                }
                else if(PrimAppNRICheck==True && PrimAppPAN==null){
                    htmlbody = htmlbody.replace('{!Pan Card Number of the 1st Applicant}','Pan Card Number of the Applicant 1: NA');
                    plainbody = plainbody.replace('{!Pan Card Number of the 1st Applicant}','Pan Card Number of the Applicant 1: NA');
                    htmlbody = htmlbody.replace('{!PAssport}',PrimAppPassport);
                    htmlbody = htmlbody.replace('{!OCICard}',PrimAppOCI);
                    plainbody = plainbody.replace('{!PAssport}',PrimAppPassport);
                    plainbody = plainbody.replace('{!OCICard}',PrimAppOCI);
                }
                
                if(Address!=null){
                    htmlbody = htmlbody.replace('{!Address}',Address);
                    plainbody = plainbody.replace('{!Address}',Address);                
                }
                else{
                    htmlbody = htmlbody.replace('{!Address}','');
                    plainbody = plainbody.replace('{!Address}','');
                }
                
                //Details of Co Applicants
                htmlbody = htmlbody.replace('{!RMName}',RMName);
                htmlbody = htmlbody.replace('{!RMEmail}',RMEmail);
                
                plainBody = plainBody.replace('{!RMName}',RMName);
                plainBody = plainBody.replace('{!RMEmail}',RMEmail);
                
                if(RMPhone!=null){
                    htmlbody = htmlbody.replace('{!RMPhone}',RMPhone);
                    plainbody = plainbody.replace('{!RMPhone}',RMPhone);
                }
                else{
                    htmlbody = htmlbody.replace('{!RMPhone}','');
                    plainbody = plainbody.replace('{!RMPhone}','');
                }
                
                htmlbody = htmlbody.replace('{!CoApplicantDetails}',htmlcombinedDetails);
                plainbody = plainbody.replace('{!CoApplicantDetails}',plaincombinedDetails);
                
                List<String> emailList=new List<String>();
                emailList.add(Email);
                system.debug('emilID>>'+emailList);
                SendEmailandBellNotificationUtility.SendEmail3(EmailTemplate.Id,Subject,htmlbody,plainbody,emailList,null,true,bookingID,Data,AttachmentName,null);
                
            }
            else{
                EmailTemplate PrimEmailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Send_SDR_Letter_only_for_Primary_Applicant' LIMIT 1];
                String Subject = 'Stamp Duty Letter for '+Unit+' | '+ProjectName;
                
                String htmlbody = PrimEmailTemplate.HtmlValue;
                htmlbody = htmlbody.replace('{!RMName}',RMName);
                htmlbody = htmlbody.replace('{!RMEmail}',RMEmail);
                
                String plainBody = PrimEmailTemplate.Body;
                plainBody = plainBody.replace('{!RMName}',RMName);
                plainBody = plainBody.replace('{!RMEmail}',RMEmail);
                
                if(RMPhone!=null){
                    htmlbody = htmlbody.replace('{!RMPhone}',RMPhone);
                    plainbody = plainbody.replace('{!RMPhone}',RMPhone);
                }
                else{
                    htmlbody = htmlbody.replace('{!RMPhone}','');
                    plainbody = plainbody.replace('{!RMPhone}','');
                }
                if(!AccList.isEmpty()){
                    htmlbody = htmlbody.replace('{!Name of the 1st Applicant}',PrimAppName);
                    plainbody = plainbody.replace('{!Name of the 1st Applicant}',PrimAppName);
                }
                
                if(PrimAppPAN!=null && PrimAppNRICheck!=True){
                    htmlbody = htmlbody.replace('{!Name of the 1st Applicant}',PrimAppName);
                    plainbody = plainbody.replace('{!Name of the 1st Applicant}',PrimAppName);
                    plainbody = plainbody.replace('{!Pan Card Number of the 1st Applicant}',PrimAppPAN);
                    htmlbody = htmlbody.replace('{!Pan Card Number of the 1st Applicant}',PrimAppPAN);
                    htmlbody = htmlbody.replace('{!PAssport}','Passport of Applicant 1: NA');
                    plainbody = plainbody.replace('{!PAssport}','Passport of Applicant 1: NA');
                    htmlbody = htmlbody.replace('{!OCICard}','OCI/PIO Card of the Applicant 1: NA');
                    plainbody = plainbody.replace('{!OCICard}','OCI/PIO Card of the Applicant 1: NA');
                }
                else if (PrimAppPAN==null && PrimAppNRICheck!=False){
                    htmlbody = htmlbody.replace('{!Pan Card Number of the 1st Applicant}','Pan Card Number of the Applicant 1: NA');
                    plainbody = plainbody.replace('{!Pan Card Number of the 1st Applicant}','Pan Card Number of the Applicant 1: NA');
                    htmlbody = htmlbody.replace('{!PAssport}','Passport of Applicant 1: NA');
                    plainbody = plainbody.replace('{!PAssport}','Passport of Applicant 1: NA');
                    htmlbody = htmlbody.replace('{!OCICard}','OCI/PIO Card of the Applicant 1: NA');
                    plainbody = plainbody.replace('{!OCICard}','OCI/PIO Card of the Applicant 1: NA');
                }
                else if(PrimAppNRICheck==True && PrimAppPAN!=null){
                    htmlbody = htmlbody.replace('{!Pan Card Number of the 1st Applicant}',PrimAppPAN);
                    plainbody = plainbody.replace('{!Pan Card Number of the 1st Applicant}',PrimAppPAN);
                    htmlbody = htmlbody.replace('{!PAssport}',PrimAppPassport);
                    htmlbody = htmlbody.replace('{!OCICard}',PrimAppOCI);
                    plainbody = plainbody.replace('{!PAssport}',PrimAppPassport);
                    plainbody = plainbody.replace('{!OCICard}',PrimAppOCI);
                }
                else if(PrimAppNRICheck==True && PrimAppPAN==null){
                    htmlbody = htmlbody.replace('{!Pan Card Number of the 1st Applicant}','Pan Card Number of the Applicant 1: NA');
                    plainbody = plainbody.replace('{!Pan Card Number of the 1st Applicant}','Pan Card Number of the Applicant 1: NA');
                    htmlbody = htmlbody.replace('{!PAssport}',PrimAppPassport);
                    htmlbody = htmlbody.replace('{!OCICard}',PrimAppOCI);
                    plainbody = plainbody.replace('{!PAssport}',PrimAppPassport);
                    plainbody = plainbody.replace('{!OCICard}',PrimAppOCI);
                }
                
                if(Address!=null){
                    htmlbody = htmlbody.replace('{!Address}',Address);
                    plainbody = plainbody.replace('{!Address}',Address);                
                }
                else{
                    htmlbody = htmlbody.replace('{!Address}','');
                    plainbody = plainbody.replace('{!Address}','');
                }
                
                List<String> emailList=new List<String>();
                emailList.add(Email);
                system.debug('emilID>>'+emailList);
                SendEmailandBellNotificationUtility.SendEmail3(PrimEmailTemplate.Id,Subject,htmlbody,plainbody,emailList,null,true,bookingID,Data,AttachmentName,null);
                
            }
            }
            }
            
        }
        }
            
    }