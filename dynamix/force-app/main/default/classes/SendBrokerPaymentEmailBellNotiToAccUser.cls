public class SendBrokerPaymentEmailBellNotiToAccUser {
    @InvocableMethod(label='Send Broker Payment Email and Bell Notification to Account User')
    public static void execute(List<Request> Requests){
        Broker_Payment__c brokerPaymentRcd = [select Id, Name,Amount__c,Booking__c,Booking__r.Name FROM Broker_Payment__c WHERE Id=: Requests[0].brokerPaymentRecodId];
        System.debug('brokerPaymentRcd:'+brokerPaymentRcd);
        
        // Get the Id for our custom notification type
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Notification_For_New_Broker_Payment']; 
        String notificationTitle='New Broker Payment Approval Request';
        String notificationBody='New Broker Payment ' + brokerPaymentRcd.Name +' of Amount '+ brokerPaymentRcd.Amount__c+ ' is added for Booking ' + brokerPaymentRcd.Booking__r.Name + '. Please verify details and approve it.';
        String targetId=brokerPaymentRcd.Id;
        
        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Email_to_Account_User_For_New_Broker_Payment' LIMIT 1];
        System.debug('emailTemplate:'+emailTemplate);
        
        User accountUserRcd=[Select Id,Name,Profile.Name,Email From User Where Profile.Name=:'Account Team' Limit 1];
        
        Set <String> recipientIds= new Set <String> ();
        
        //For Send Bell Notification to Account User
        if(accountUserRcd.Id!=null){
            recipientIds.add(accountUserRcd.Id);
        }                    
        if(recipientIds.size()>0){
            SendEmailandBellNotificationUtility.SendBellNotification(notificationType.Id, notificationTitle, notificationBody, targetId, recipientIds);
        }
        
        //for send email to Account User
        if(emailTemplate!=null && accountUserRcd!=null){
            String htmlBody = emailTemplate.HtmlValue;
            String plainBody = emailTemplate.Body;
            
            htmlBody = htmlBody.replace('{!accountUser}', accountUserRcd.Name);
            plainBody = plainBody.replace('{!accountUserRcd}', accountUserRcd.Name); 
            
            String brokerPaymentRcdLink='';
            String brokerPaymentRcdName='';
            if(brokerPaymentRcd.Name!=null){
                brokerPaymentRcdLink = URL.getOrgDomainUrl().toExternalForm() + '/' + brokerPaymentRcd.Id;
                brokerPaymentRcdName = '<a href="'+brokerPaymentRcdLink+'">'+brokerPaymentRcd.Name+'</a>';
            }
            String bookLink='';
            String bookName='';
            if(brokerPaymentRcd.Booking__r.Name!=null){
                bookLink = URL.getOrgDomainUrl().toExternalForm() + '/' + brokerPaymentRcd.Booking__c;
                bookName = '<a href="'+bookLink+'">'+brokerPaymentRcd.Booking__r.Name+'</a>';
            }
            if(brokerPaymentRcdName != null){
                htmlBody = htmlBody.replace('{!brokerPaymentNo}', brokerPaymentRcdName);
                plainBody = plainBody.replace('{!brokerPaymentNo}', brokerPaymentRcdName);
            }
            if(brokerPaymentRcd.Amount__c != null){
                htmlBody = htmlBody.replace('{!amount}', String.valueOf(brokerPaymentRcd.Amount__c));
                plainBody = plainBody.replace('{!amount}', String.valueOf(brokerPaymentRcd.Amount__c)); 
            }
            if(bookName != null){
                htmlBody = htmlBody.replace('{!bookingName}', bookName);
                plainBody = plainBody.replace('{!bookingName}', bookName);
            }
            
            if(emailTemplate!=null && accountUserRcd.Email!=null){                
                List<String> emailList=new List<String>();           
                emailList.add(accountUserRcd.Email);            
                SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,
                                                               emailTemplate.Subject,
                                                               htmlBody,
                                                               plainBody,
                                                               emailList,
                                                               null,false,
                                                               null,
                                                               null,null,null);
            }
        }
    }
    public class Request {
        @InvocableVariable(label='Broker Payment Record Id' required=true)
        public Id brokerPaymentRecodId;
    }    
}