public class SendDemandLetterrToCustomer {
    @InvocableMethod(label='Send Demand Letter To Customer')
    public static void execute(List<Request> Requests){
        //for get Booking record details
        Booking__c bookingRcd = [select Id, Name,Primary_Applicant__c,Unit_Number__c,Project_Name_Formulla__c,Project_Name__c,
                                 Primary_Applicant__r.PersonMobilePhone,Owner.Id,Primary_Applicant_Name_Formulla__c,Project_Name__r.Project_Email__c
                                 FROM Booking__c WHERE Id=: Requests[0].bookingRecodId];
        List<OrgWideEmailAddress> fromEmailAddress = [SELECT Id, Address FROM OrgWideEmailAddress where Address=:bookingRcd.Project_Name__r.Project_Email__c limit 1];
        System.debug('bookingRcd:'+bookingRcd);
        System.debug('Content Version Id:'+Requests[0].contentVersionId);
        // System.debug('Content Version List:'+Requests[0].contentVersionList);
        ContentVersion contentVersionRcd = [SELECT Id,Title,VersionData, FileExtension FROM ContentVersion WHERE Id = :Requests[0].contentVersionId];
        // Get the Id for our custom notification type
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Demand_Send_Notification_To_RM']; 
        
        Demand__c dmnd = [Select Id,Sap_Code__c from Demand__c where Id =: Requests[0].demandId];
        //for send Email to Customer
        if(bookingRcd.Primary_Applicant__c!=null){
            Account customerRecord=[Select Id,Name,PersonEmail From Account Where Id=:bookingRcd.Primary_Applicant__c];
            System.debug('customerRecord:'+customerRecord);
            EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Send_Demand_Letter_to_Customer' LIMIT 1];
            System.debug('emailTemplate:'+emailTemplate);
            
            String projectLink='';
            String projectName='';
            if(bookingRcd.Project_Name__c!=null){
                projectLink = URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Project_Name__c;
                //projectName = '<a href="'+projectLink+'">'+bookingRcd.Project_Name_Formulla__c+'</a>';
                projectName = bookingRcd.Project_Name_Formulla__c;
            }
            String bookLink='';
            String bookName='';
            if(bookingRcd.Name!=null){
                bookLink = URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Id;
                bookName = '<a href="'+bookLink+'">'+bookingRcd.Name+'</a>';
            }
            
            String htmlBody = emailTemplate.HtmlValue;       
            String subject1 = 'Demand Letter - ';
            if(customerRecord.Name != null){
                htmlBody = htmlBody.replace('{!Customer}', customerRecord.Name);
            }
            //htmlBody = htmlBody.replace('{!BookingName}',bookName);
            if(bookingRcd.Project_Name_Formulla__c != null){
                htmlBody = htmlBody.replace('{!Project}', projectName);
                subject1 = subject1+projectName+' ';
            }
            if(bookingRcd.Unit_Number__c != null){
                htmlBody = htmlBody.replace('{!Unit}', bookingRcd.Unit_Number__c);
                subject1 = subject1+bookingRcd.Unit_Number__c;
            }
            
            String plainBody = emailTemplate.Body;
            if(customerRecord.Name != null){
                plainBody = plainBody.replace('{!Customer}', customerRecord.Name);
            }
            
            //plainBody = plainBody.replace('{!BookingName}',bookName); 
            
            if(bookingRcd.Project_Name_Formulla__c != null){
                plainBody = plainBody.replace('{!Project}', projectName);
            }
            if(bookingRcd.Unit_Number__c != null){
                plainBody = plainBody.replace('{!Unit}', bookingRcd.Unit_Number__c);
            }
            String fromMail = '';
            if(emailTemplate!=null && customerRecord.PersonEmail!=null){                
                List<String> toEmailList=new List<String>();           
                toEmailList.add(customerRecord.PersonEmail);
                if(!fromEmailAddress.isEmpty()){
                    fromMail = fromEmailAddress[0].Id;
                }
                SendEmailandBellNotificationUtility.SendEmail2(emailTemplate.Id,subject1,htmlBody,plainBody,toEmailList,null,true,dmnd.Id,contentVersionRcd.VersionData,contentVersionRcd.Title,fromMail,contentVersionRcd.Id);
            }
            
            //For Send WhatsApp Message
            communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp Demand Letter Sent' Limit 1];
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
            EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Demand Letter' Limit 1];
            if(smsEmailTemp!=null && bookingRcd.Primary_Applicant__r.PersonMobilePhone!=null){
                String templateBody=smsEmailTemp.HtmlValue;
                String mobileNumber=bookingRcd.Primary_Applicant__r.PersonMobilePhone;
                templateBody = templateBody.replace('{{{Booking__c.Primary_Applicant_Name_Formulla__c}}}',bookingRcd.Primary_Applicant_Name_Formulla__c);
                templateBody = templateBody.replace('{{{Booking__c.Name}}}',bookingRcd.Name);
                templateBody=templateBody.stripHtmlTags();
                System.debug('templateBody:'+templateBody);
                SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
            }
        }
        
        //for send Bell Notification to RM (Booking Owner)
        if(notificationType!=null && bookingRcd.Owner.Id!=null){
            String notificationTitle='Demand Letter Shared To Customer';
            String notificationBody='Demand Letter: '+ contentVersionRcd.Title + ' has been shared to Customer '+'for Booking: '+ bookingRcd.Name;
            String targetId=bookingRcd.Id;
            Set <String> recipientIds= new Set <String> ();
            if(bookingRcd.Owner.Id!=null){
                recipientIds.add(bookingRcd.Owner.Id);
            }
            System.debug('recipientIds:'+recipientIds);
            SendEmailandBellNotificationUtility.SendBellNotification(notificationType.Id, notificationTitle, notificationBody, targetId, recipientIds);
        }            
        
    }
    public class Request {
        @InvocableVariable(label='Booking Record Id' required=true)
        public Id bookingRecodId;
        
        @InvocableVariable(label='ContentVersion Id' required=true)
        public Id contentVersionId;
        
        @InvocableVariable(label='Demand Id' required=true)
        public Id demandId;
        
        //   @InvocableVariable(label='ContentVersion List' required=true)
        //  public List<ContentVersion> contentVersionList;
    }
}