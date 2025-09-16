public class NoDueClearanceEmail {
    @InvocableMethod
    public static void getBookingId(List<request> reqList){
        if(reqList != null){
            for(request req :reqList){
                NoDueClearanceEmail.sendNoDueEmailToRM(req.bookingIds);
            }
        }
    }
    public static void sendNoDueEmailToRM(String bookingId){
        List<EmailTemplate> emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName =: 'No_Due_Clearance_Email' limit 1];
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='No_Due_Clearance_Notification'];
        Booking__c book = [Select Id,Owner.Email,OwnerId,Owner.Name,Unit_Number__c,Project_Name_Formulla__c,Primary_Applicant_Name_Formulla__c from Booking__c where Id=:bookingId];
        if(emailTemplate != null && book != null){
            List<String> toMailList = new List<String>{book.Owner.Email};
            String CRMHeadUserName = Label.CRM_Head_User;
            User CRMSiteHeadRoleUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND isActive = true Limit 1];
            List<String> ccMailList = new List<String>{CRMSiteHeadRoleUser.Email};
            String htmlBody = emailTemplate[0].HtmlValue;       
            String subject = emailTemplate[0].Subject;
            String plainBody = emailTemplate[0].Body;
            if(book.Primary_Applicant_Name_Formulla__c != null){
                subject = subject.replace('{!Booking__c.Primary_Applicant_Name_Formulla__c}',book.Primary_Applicant_Name_Formulla__c);
            }
            if(book.Unit_Number__c != null){
                subject = subject.replace('{!Booking__c.Unit_Number__c}',book.Unit_Number__c);
                htmlBody = htmlBody.replace('{!Booking__c.Unit_Number__c}',book.Unit_Number__c);
                plainBody = plainBody.replace('{!Booking__c.Unit_Number__c}',book.Unit_Number__c);
            }
            if(book.Project_Name_Formulla__c != null){
                subject = subject.replace('{!Booking__c.Project_Name_Formulla__c}',book.Project_Name_Formulla__c);
                htmlBody = htmlBody.replace('{!Booking__c.Project_Name_Formulla__c}',book.Project_Name_Formulla__c);
                plainBody = plainBody.replace('{!Booking__c.Project_Name_Formulla__c}',book.Project_Name_Formulla__c);
            }
            if(book.Owner.Name != null){
                htmlBody = htmlBody.replace('{!Booking__c.OwnerFullName}',book.Owner.Name);
                plainBody = plainBody.replace('{!Booking__c.OwnerFullName}',book.Owner.Name);
            }
            SendEmailandBellNotificationUtility.SendEmail2(emailTemplate[0].Id,subject,htmlBody,null,toMailList,ccMailList,true,book.Id,null,null,null,null);
            if(notificationType!=null){
                SendEmailandBellNotificationUtility.SendBellNotification(notificationType.Id, subject, plainBody, book.Id, new Set<String>{book.OwnerId});
            }
        }
    }
    public class request{
        @InvocableVariable (required=true)
        public string bookingIds;
    }
}