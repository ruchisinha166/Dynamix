public class BookingRefundEmailToRM {
    //This class is Used in Flow named: Send Booking Email To Customer
    @InvocableMethod
    public static void getBookingId(List<request> reqList){
        if(reqList != null){
            for(request req :reqList){
                BookingRefundEmailToRM.sendRefundEmail(req.bookingIds,req.fromAddress);
            }
        }
    }
    public static void sendRefundEmail(String bookingIds,String fromAddress){
        List<EmailTemplate> emailTemp = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate 
                                         where DeveloperName =: 'Booking_Refund_Email' limit 1];
        Booking__c book = [Select Id,OwnerId,Owner.Email,Sales_Manager__c,Sales_Manager__r.Email,CRM_Head__c,CRM_Head__r.Email from Booking__c where Id=:bookingIds];
        List<String> receiverEmails = new List<String>();
        List<String> ccEmails = new List<String>();
        if(book!=null){
            if(book.OwnerId!=null){
                receiverEmails.add(book.Owner.Email);
            }
            if(book.Sales_Manager__c!=null){
                receiverEmails.add(book.Sales_Manager__r.Email);
            }
            if(book.CRM_Head__c!=null){
                ccEmails.add(book.CRM_Head__r.Email);
            }
        }
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(emailTemp[0].Id, null, book.Id);
        mail.setToAddresses(receiverEmails);
        mail.setCCAddresses(ccEmails);
        mail.setOrgWideEmailAddressId(fromAddress);
        mail.setSaveAsActivity(true);
        mails.add(mail);
        if(!mails.isEmpty()){
            system.debug('Mail Message:- '+mails);
            Messaging.sendEmail(mails);
        }
    }
    public class request{
        @InvocableVariable (required=true)
        public string bookingIds;
        @InvocableVariable (required=true)
        public string fromAddress;
    }
}