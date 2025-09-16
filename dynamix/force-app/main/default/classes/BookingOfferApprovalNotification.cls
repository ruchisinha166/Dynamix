public class BookingOfferApprovalNotification {
    @InvocableMethod(label='Booking Offer Approval Notification')
    public static void execute(List<Request> Requests){
        //for send Bell Notification to Site Head of Booking offer Project
        Booking_Offer__c bookingOffRcd = [select Id, Name,Approval_Status__c FROM Booking_Offer__c WHERE Id=: Requests[0].bookingOfferId];
        // Get the Id for our custom notification type
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Booking_Offer_Notification']; 
        if(notificationType!=null && bookingOffRcd!=null){
            String notificationTitle='Booking Offer Approval';
            String notificationBody='';
            if(bookingOffRcd.Approval_Status__c=='Approved'){
                notificationBody='Booking Offer is Approved for record: '+ bookingOffRcd.Name;
            }
            else if(bookingOffRcd.Approval_Status__c=='Rejected'){
                notificationBody='Booking Offer is Rejected for record: '+ bookingOffRcd.Name;
            }  
            String targetId=bookingOffRcd.Id;
            Set <String> recipientIds= new Set <String> ();
            if(Requests[0].siteHeadId!=null){
                recipientIds.add(Requests[0].siteHeadId);
            }
            SendEmailandBellNotificationUtility.SendBellNotification(notificationType.Id, notificationTitle, notificationBody, targetId, recipientIds);
        }
    }
    public class Request {
        @InvocableVariable(label='Booking Offer Id' required=true)
        public Id bookingOfferId;
        @InvocableVariable(label='SiteHead Id' required=true)
        public Id siteHeadId;
    }
}