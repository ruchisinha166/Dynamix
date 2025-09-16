public class BookingCancellationInitiatedEmail {
    @InvocableMethod(label='Send Email on Booking Cancellation Initiated')
    public static void execute(List<Request> Requests){
        //for get Booking record details
        Booking__c bookingRcd = [select Id,Name,Project_Name__c,Related_Opportunity__r.OwnerId,Project_Name__r.Site_Head__c from Booking__c where Id=: Requests[0].bookingId];
        
        String oppOwnerId=bookingRcd.Related_Opportunity__r.OwnerId;
        String siteHeadId=bookingRcd.Project_Name__r.Site_Head__c;
        //CRM Head User
        String crmHeadUserName = Label.CRM_Head_User;
        System.debug('crmHeadUserName:'+crmHeadUserName);
        //for get users with Opp Owner & Site Head & CRM Head user
        List<User> userList=[Select Id,Name,UserName,Email,IsActive From User Where IsActive=true AND (UserName=:crmHeadUserName  OR Id=:oppOwnerId OR Id=:siteHeadId)];
        
        System.debug('userList:'+userList);
        List<String> toEmailList=new List<String>();
        if(userList.size()>0){
            for(User userRcd:userList){
                if(userRcd.Email!=null){
                    toEmailList.add(userRcd.Email);
                }
            }
        }
        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Booking_Cancellation_Initiated_Email' LIMIT 1];
        System.debug('emailTemplate:'+emailTemplate);
        String htmlBody = emailTemplate.HtmlValue;
        String recordLink=URL.getOrgDomainUrl().toExternalForm() + '/' + bookingRcd.Id;
        htmlBody = htmlBody.replace('{!Booking__c.Name}','<a href="'+recordLink+'">' + bookingRcd.Name +'</a>');
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!Booking__c.Name}', '<a href="'+recordLink+'">' + bookingRcd.Name +'</a>'); 
        if(emailTemplate!=null){                
            SendEmailandBellNotificationUtility.SendEmail2(emailTemplate.Id,emailTemplate.Subject,htmlBody,plainBody,toEmailList,null,true,null,null,null,null,null);          
        }
    }
    public class Request {
        @InvocableVariable(label='Booking Id' required=true)
        public id bookingId;
    }
}