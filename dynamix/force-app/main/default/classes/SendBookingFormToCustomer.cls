public class SendBookingFormToCustomer {
    @InvocableMethod(label='Send BookingForm To Customer')
    public static void execute(List<Request> Requests){
        String AttachmentName;
        Blob Data;
        String filetype;
        String AttcacmentNameAnnexure;
        Blob DataAnnexure;
        String fileTypeAnnexure;
        //for send Booking Form Link Email to SM
        Booking__c bookingRcd = [select Id, Name,Related_Suggested_Property__r.Unit__c,Primary_Applicant__c,Project_Phone__c,Related_Opportunity__c,Unit_Number__c,Project_Name_Formulla__c,Related_Opportunity__r.Owner.Name,Related_Opportunity__r.Owner.Id,Project_Name__c,Primary_Applicant__r.PersonMobilePhone,Primary_Applicant_Name_Formulla__c,Record_Link__c FROM Booking__c WHERE Id=: Requests[0].bookingRecodId];
        System.debug('bookingRcd:'+bookingRcd);
        // Get the Id for our custom notification type
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Booking_Form_Notification']; 
        
        if(bookingRcd.Project_Name__c!=null){
            Project__c projectRecod=[Select Id,Name,Site_Head__c,Site_Head__r.Id From Project__c Where Id=:bookingRcd.Project_Name__c];
            //For Send Bell Notification to Site Head
            if(notificationType!=null && projectRecod.Site_Head__r.Id!=null){
                String notificationTitle1='Booking Form Mail Sent';
                String notificationBody1='Booking Form has been sent to Customer for Booking: '+ bookingRcd.Name;
                String targetId1=bookingRcd.Id;
                Set <String> recipientIds1= new Set <String> ();
                if(projectRecod.Site_Head__r.Id!=null){
                    recipientIds1.add(projectRecod.Site_Head__r.Id);
                }
                SendEmailandBellNotificationUtility.SendBellNotification(notificationType.Id, notificationTitle1, notificationBody1, targetId1, recipientIds1);
            }            
        }
        //For Send Bell Notification to SM (Opportunity Owner)
        if(notificationType!=null && bookingRcd.Related_Opportunity__r.Owner.Id!=null){
            String notificationTitle='The Application Form Generated';
            // String notificationBody='Booking Form has been sent to Customer for Booking: '+ bookingRcd.Name;
            
            String notificationBody='Dear '+ bookingRcd.Related_Opportunity__r.Owner.Name+',\n'+ 
                'The Application Form for '+bookingRcd.Unit_Number__c+' in '+bookingRcd.Project_Name_Formulla__c+' has been generated to share with customer.\n'+
                'Kindly fill the necessary details and share the same with the customer at the earliest.';
            
            String targetId=bookingRcd.Id;
            Set <String> recipientIds= new Set <String> ();
            if(bookingRcd.Related_Opportunity__r.Owner.Id!=null){
                recipientIds.add(bookingRcd.Related_Opportunity__r.Owner.Id);
            }
            SendEmailandBellNotificationUtility.SendBellNotification(notificationType.Id, notificationTitle, notificationBody, targetId, recipientIds);
        }
        
        //for send Email to Customer
        // Terms and Conditions Attchment
        List<id> ContentDocumentidsTC = new List<id>();

         for(contentDocumentLink CDLink : [SELECT LinkedEntityid, ContentDocumentid FROM contentDocumentLink WHERE LinkedEntityid=:bookingRcd.Project_Name__c ])
        {
            ContentDocumentidsTC.add(CDLink.ContentDocumentid);  
        }
        if (ContentDocumentidsTC != null && !ContentDocumentidsTC.isEmpty()) {
            List<ContentVersion> cvList = [SELECT title, PathOnClient, FileType, versiondata, Document_Type__c,SObjectType__c
                                           FROM contentversion 
                                           WHERE ContentDocumentId IN :ContentDocumentidsTC 
                                           AND Document_Type__c ='Terms & Conditions' AND
                                           SObjectType__c ='Project__c'
                                           order by CreatedDate desc limit 1];
            if (cvList != null && !cvList.isEmpty()){
                for (ContentVersion cv : cvList){
                    Data = cv.VersionData;
                    AttachmentName = cv.Title;
                    filetype = cv.FileType;
                    
                }
            }
            
            
        } else {
            System.debug('List has no rows');
        }
        
        //Annexures Attchment
        //
        List<id> ContentDocumentidsAnnexure = new List<id>();
        for(contentDocumentLink CDLink : [SELECT LinkedEntityid, ContentDocumentid FROM contentDocumentLink WHERE LinkedEntityid=:bookingRcd.Related_Suggested_Property__r.Unit__c])
        {
            ContentDocumentidsAnnexure.add(CDLink.ContentDocumentid);  
        }
        
        if (ContentDocumentidsAnnexure != null && !ContentDocumentidsAnnexure.isEmpty()){
            List<ContentVersion> cvList1 = [SELECT title, PathOnClient, FileType, versiondata, Document_Type__c,SObjectType__c
                                            FROM contentversion 
                                            WHERE ContentDocumentId IN :ContentDocumentidsAnnexure 
                                            AND Document_Type__c= 'Annexures'
                                            AND SObjectType__c= 'Property__c'
                                            order by CreatedDate desc limit 1];
            if (cvList1 != null && !cvList1.isEmpty()){
                for (ContentVersion cv1 : cvList1){
                    DataAnnexure = cv1.VersionData;
                    AttcacmentNameAnnexure = cv1.Title;
                    fileTypeAnnexure = cv1.FileType;
                }
            }
            
        }
        //ContentVersion cv = [SELECT title,PathOnClient, FileType,
                                                //versiondata 
                                          //FROM contentversion 
                                          //WHERE ContentDocumentId IN :ContentDocumentids  
                                           //];
        
        
        if(bookingRcd.Primary_Applicant__c!=null){
            Account customerRecord=[Select Id,Name,PersonEmail From Account Where Id=:bookingRcd.Primary_Applicant__c];
            System.debug('customerRecord:'+customerRecord);
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Booking_Form_Link_Email' LIMIT 1];
            System.debug('emailTemplate:'+emailTemplate);
            
            String bookingFormLink = Label.Booking_Form_Link;
            bookingFormLink+='?Id='+bookingRcd.Id+'&submitted=customer';
            String Link = '<a href="'+bookingFormLink+'">'+bookingFormLink+'</a>';
            System.debug('Link:'+Link);
            
            
            String projectLink='';
            String projectName='';
            if(bookingRcd.Project_Name__c!=null){
                projectLink = URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Project_Name__c;
                projectName = '<a href="'+projectLink+'">'+bookingRcd.Project_Name_Formulla__c+'</a>';
            }
            String bookLink='';
            String bookName='';
            if(bookingRcd.Name!=null){
                bookLink = URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Id;
                bookName = '<a href="'+bookLink+'">'+bookingRcd.Name+'</a>';
            }
            
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Name}',bookName);
            if(customerRecord.Name != null){
                htmlBody = htmlBody.replace('{!SM}', customerRecord.Name);
            }
            if(Link != null){
                htmlBody = htmlBody.replace('{!Link}', Link);
            }
            if(bookingRcd.Project_Name_Formulla__c != null){
                htmlBody = htmlBody.replace('{!Project}', projectName);
            }
            if(bookingRcd.Unit_Number__c != null){
                htmlBody = htmlBody.replace('{!Unit}', bookingRcd.Unit_Number__c);
            }

            String plainBody = emailTemplate.Body;
            
            plainBody = plainBody.replace('{!Name}',bookName); 
            if(customerRecord.Name != null){
                plainBody = plainBody.replace('{!SM}', customerRecord.Name);
            }
            if(Link != null){
                plainBody = plainBody.replace('{!Link}', Link);
            }
            if(bookingRcd.Project_Name_Formulla__c != null){
                plainBody = plainBody.replace('{!Project}', projectName);
            }
            if(bookingRcd.Unit_Number__c != null){
                plainBody = plainBody.replace('{!Unit}', bookingRcd.Unit_Number__c);
            }
            if(emailTemplate!=null && customerRecord.PersonEmail!=null){                
                List<String> emailList=new List<String>();           
                emailList.add(customerRecord.PersonEmail);            
                SendEmailandBellNotificationUtility.SendEmail4(emailTemplate.Id,htmlBody,plainBody,emailList,null,true,bookingRcd.Id,Data,AttachmentName,null,filetype,fileTypeAnnexure,AttcacmentNameAnnexure,DataAnnexure);           
            }
        }
        
        //For Send WhatsApp Message
        communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp Booking Form Link Sent' Limit 1];
        System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
        if(regWhatEmailTemp!=null){
            String recipientAddress=bookingRcd.Primary_Applicant__r.PersonMobilePhone;
            String recipientId=bookingRcd.Primary_Applicant__c;
            String emailTemplateId=String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
            String relatedToId=bookingRcd.Id;
            System.debug('emailTemplateId:'+emailTemplateId);
            if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                SendWhatsAppMessageUtility.SendMessage(recipientAddress, recipientId, emailTemplateId,relatedToId);
            }
        }
        //for Send SMS
        EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Booking Form Link Sent' Limit 1];
        if(smsEmailTemp!=null && bookingRcd.Primary_Applicant__r.PersonMobilePhone!=null){
            String templateBody=smsEmailTemp.HtmlValue;
            String mobileNumber=bookingRcd.Primary_Applicant__r.PersonMobilePhone;
            templateBody = templateBody.replace('{{{Booking__c.Primary_Applicant_Name_Formulla__c}}}',bookingRcd.Primary_Applicant_Name_Formulla__c);
            templateBody = templateBody.replace('{{{Booking__c.Name}}}',bookingRcd.Name);
            templateBody = templateBody.replace('{{{Booking__c.Record_Link__c}}}',' ');
            templateBody=templateBody.stripHtmlTags();
            System.debug('templateBody:'+templateBody);
            if(!test.isRunningTest())
            {
                SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
            }
          
        }
    }
    public class Request {
        @InvocableVariable(label='Booking Record Id' required=true)
        public Id bookingRecodId;
    }
}