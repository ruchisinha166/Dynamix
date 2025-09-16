public class SendWhatsappMsg {
    @InvocableMethod(label='Send WhatsappMsg class')
    public static void sendSms(List<sendSMSInvocableRequest> requests){
        
         String EmailTemplateID = requests[0].emailTemplateID;
         String bookingID = requests[0].bookingID;
         String OtherID = requests[0].recipientId;
        
         sendwhsms(EmailTemplateID,bookingID,OtherID);
        }
    
    @future(callout=true)
    public static void sendwhsms(string EmailTemplateID ,string bookingID ,string OtherID)
    {
        try{
                system.debug('EmailTemplateID '+EmailTemplateID+ ' bookingID '+bookingID+ ' OtherID '+ OtherID);
                List<booking__c> bookinglist = new list<booking__c>();
                List<Co_Applicant__c> coAppList = new List<Co_Applicant__c>();
                bookinglist =[select id,Primary_Applicant__r.personcontactid from booking__c where id=:bookingID];
                system.debug('bookinglist sms=='+bookinglist);
                coAppList = [select id,Account__c,Booking__c,Account__r.PersonEmail from Co_Applicant__c where Booking__c =:bookingID];  
                
                Set<ID> Accids = new Set<ID>();
                for(Co_Applicant__c coapp :coAppList)
                {
                    Accids.add(coapp.Account__c);
                } 
                system.debug('Accids '+Accids);
                List<Contact> cclist1 = [select id,MobilePhone,Phone,Email from Contact where AccountId IN : Accids];
        		List<account> cclist = [select id,PersonMobilePhone,Phone,PersonEmail from account where id IN : Accids];
                system.debug('cclist '+ cclist.size());
            	List<communicat_o.OutboundWrapper.OutboundActivity> liact = new List<communicat_o.OutboundWrapper.OutboundActivity>();
                  for(account cc : cclist)
                    {
                         if(cc.PersonMobilePhone!=null)
                         {
                            communicat_o.OutboundWrapper.OutboundActivity acti = new communicat_o.OutboundWrapper.OutboundActivity();
                            acti.recipientAddress = cc.PersonMobilePhone;
                            acti.recipientId = cc.Id;
                            acti.relatedToId = bookingID;
                            liact.add(acti);
                            
                        }
                 	}
            				communicat_o.OutboundWrapper out= new communicat_o.OutboundWrapper();
                            out.activities=liact;
                            out.sendDateTime=datetime.now();
                            out.templateId= EmailTemplateID;
                            out.senderAddress= 'Dynamix_919152915208';
            				if(!Test.isRunningTest()){
                            communicat_o.OSMS.sendSMS(out);
                            }
                            system.debug('Whatsapp send');
             }        
            Catch(Exception e)
            {
                system.debug('==> e'  + e.getMessage()+e.getLineNumber());
            }
    }
     @future(callout=true)
    public static void sendwhsmsForPayment(string EmailTemplateID ,string bookingID ,string OtherID)
    {
                system.debug('EmailTemplateID '+EmailTemplateID+ ' bookingID '+bookingID+ ' OtherID '+ OtherID);
                List<Payment__c > paymnetList = [select id,Booking__r.Primary_Applicant__c from payment__c where id =: OtherID];
                List<account> accList = [select id,PersonMobilePhone from account where id=: paymnetList[0].Booking__r.Primary_Applicant__c];
        
                         if(accList[0].PersonMobilePhone <> null)
                         {
                            communicat_o.OutboundWrapper.OutboundActivity acti = new communicat_o.OutboundWrapper.OutboundActivity();
                            acti.recipientAddress = accList[0].PersonMobilePhone;
                            acti.recipientId = accList[0].id;
                            acti.relatedToId = OtherID;
                            List<communicat_o.OutboundWrapper.OutboundActivity> liact = new List<communicat_o.OutboundWrapper.OutboundActivity>();
                            liact.add(acti);
                            communicat_o.OutboundWrapper out= new communicat_o.OutboundWrapper();
                            out.activities=liact;
                            out.sendDateTime=datetime.now();
                            out.templateId= EmailTemplateID;
                            out.senderAddress= 'Dynamix_919152915208';
                             if(!Test.isRunningTest()){
                                  communicat_o.OSMS.sendSMS(out);
                             }
                           
                            system.debug('Whatsapp send');
                        } 
    }
    public class sendSMSInvocableRequest
    {
        @InvocableVariable(required=true)
        public ID bookingID;
    
        @InvocableVariable(required=true)
        public String emailTemplateID;
        
        @InvocableVariable(required=true)
        public String recipientId;
    }

}