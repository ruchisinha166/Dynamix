public class BookingOffrBellNotificationToApprover {
    @InvocableMethod(label='Booking Offer Bell Notification to Approver')
    public static void execute(List<Request> Requests){
        //for send Bell Notification to Site Head of Booking offer Project
        Booking_Offer__c bookingOffRcd = [select Id, Name,Owner.Name FROM Booking_Offer__c WHERE Id=: Requests[0].bookingOfferId];
        // Get the Id for our custom notification type
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Booking_Offer_Notification']; 
        if(notificationType!=null && bookingOffRcd!=null){
            String notificationTitle='Booking Offer Approval Request';
            String notificationBody='Offer Name: '+ bookingOffRcd.Name +' Owner: '+ bookingOffRcd.Owner.Name;            
            String targetId=bookingOffRcd.Id;
            Set <String> recipientIds= new Set <String> ();
            List<User> userList=[Select Id,Name,UserRole.Name From User Where UserRole.Name=:'S&M Head'];
             System.debug('userList:'+userList);
            if(userList.size()>0){
                for(User userRcd:userList){
                    recipientIds.add(userRcd.Id);
                }
            }
            System.debug('recipientIds:'+recipientIds);
            SendEmailandBellNotificationUtility.SendBellNotification(notificationType.Id, notificationTitle, notificationBody, targetId, recipientIds);
        }
    }
    public class Request {
        @InvocableVariable(label='Booking Offer Id' required=true)
        public Id bookingOfferId;
    }
}