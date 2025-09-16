public class SendBookingFormEmailToSM {
    @InvocableMethod(label='Booking Form Email to SM')
    public static void execute(List<Request> Requests){
        //for send Booking Form Link Email to SM
        Booking__c bookingRcd = [select Id, Name,Related_Opportunity__c,Related_Opportunity__r.Owner.Name,Related_Opportunity__r.Owner.Email FROM Booking__c WHERE Id=: Requests[0].bookingRecodId];
        
        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Booking_Form_Link_Email_SM' LIMIT 1];
        System.debug('emailTemplate:'+emailTemplate);
        
        String bookingFormLink = Label.Booking_Form_Link;
        bookingFormLink+='?Id='+bookingRcd.Id;
        System.debug('bookingFormLink:'+bookingFormLink);
       
        String htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!Booking__c.Name}', bookingRcd.Name);
        htmlBody = htmlBody.replace('{!SM}', bookingRcd.Related_Opportunity__r.Owner.Name);
        htmlBody = htmlBody.replace('{!bookingFormLink}', bookingFormLink);
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!Booking__c.Name}', bookingRcd.Name); 
        plainBody = plainBody.replace('{!SM}', bookingRcd.Related_Opportunity__r.Owner.Name);
        plainBody = plainBody.replace('{!bookingFormLink}', bookingFormLink);
        
        if(emailTemplate!=null){                
            List<String> emailList=new List<String>();           
            emailList.add(bookingRcd.Related_Opportunity__r.Owner.Email);            
            SendEmailandBellNotificationUtility.SendEmail(emailTemplate.Id,htmlBody,plainBody,emailList,null);           
        }
        
        //for send Booking Generated Email to SM
        
        EmailTemplate emailTemplate1 = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Booking_Form_Generated_Email' LIMIT 1];
        System.debug('emailTemplate1:'+emailTemplate1);
        
        String htmlBody1 = emailTemplate1.HtmlValue;
        htmlBody1 = htmlBody1.replace('{!Booking__c.Name}', bookingRcd.Name);
        htmlBody1 = htmlBody1.replace('{!SM}', bookingRcd.Related_Opportunity__r.Owner.Name);
        
        String plainBody1 = emailTemplate1.Body;
        plainBody1 = plainBody1.replace('{!Booking__c.Name}', bookingRcd.Name); 
        plainBody1 = plainBody1.replace('{!SM}', bookingRcd.Related_Opportunity__r.Owner.Name);
        
        if(emailTemplate1!=null){                
            List<String> emailList1=new List<String>();           
            emailList1.add(bookingRcd.Related_Opportunity__r.Owner.Email);            
            SendEmailandBellNotificationUtility.SendEmail(emailTemplate1.Id,htmlBody1,plainBody1,emailList1,null);           
        }
    }
    public class Request {
        @InvocableVariable(label='Booking Record Id' required=true)
        public Id bookingRecodId;
        @InvocableVariable(label='SM Id' required=true)
        public Id smId;
    }
}