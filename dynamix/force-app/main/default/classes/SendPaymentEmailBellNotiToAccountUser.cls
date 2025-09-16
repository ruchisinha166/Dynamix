public class SendPaymentEmailBellNotiToAccountUser {
    @InvocableMethod(label='Send Payment Email and Bell Notification to Account User')
    public static void execute(List<Request> Requests){
        Payment__c paymentRcd = [select Id, Name,Amount__c,Booking__c,Booking__r.Name FROM Payment__c WHERE Id=: Requests[0].paymentRecodId];
        System.debug('paymentRcd:'+paymentRcd);
        
        // Get the Id for our custom notification type
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Notification_For_New_Payment']; 
        String notificationTitle='New Payment Approval Request';
        String notificationBody='New Payment ' + paymentRcd.Name +' of Amount '+ paymentRcd.Amount__c+ ' is added for Booking ' + paymentRcd.Booking__r.Name + '. Please verify details and approve it.';
        String targetId=paymentRcd.Id;
        
        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Email_to_Account_User_For_New_Payment' LIMIT 1];
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
            
            String paymentRcdLink='';
            String paymentRcdName='';
            if(paymentRcd.Name!=null){
                paymentRcdLink = URL.getOrgDomainUrl().toExternalForm() + '/' + paymentRcd.Id;
                paymentRcdName = '<a href="'+paymentRcdLink+'">'+paymentRcd.Name+'</a>';
            }
            String bookLink='';
            String bookName='';
            if(paymentRcd.Booking__r.Name!=null){
                bookLink = URL.getOrgDomainUrl().toExternalForm() + '/' + paymentRcd.Booking__c;
                bookName = '<a href="'+bookLink+'">'+paymentRcd.Booking__r.Name+'</a>';
            }
            if(paymentRcdName != null){
                htmlBody = htmlBody.replace('{!paymentNo}', paymentRcdName);
                plainBody = plainBody.replace('{!paymentNo}', paymentRcdName);
            }
            if(paymentRcd.Amount__c != null){
                htmlBody = htmlBody.replace('{!amount}', String.valueOf(paymentRcd.Amount__c));
                plainBody = plainBody.replace('{!amount}', String.valueOf(paymentRcd.Amount__c)); 
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
        @InvocableVariable(label='Payment Record Id' required=true)
        public Id paymentRecodId;
    }    
}