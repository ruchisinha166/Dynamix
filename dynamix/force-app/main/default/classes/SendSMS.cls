public class SendSMS{

    public static void sendWelcomeEmail(id bookindIds,string emailTemplateID)
    {
        string coapplicantNames = '';
        Booking__c book= [select id, Project_Name__r.Project_Phone__c,Project_Name__r.name,Project_Name__r.Location__c,Project_Name__r.Builder_Organization__r.name,Project_Name__r.Project_Email__c from booking__c where id =: bookindIds];
        String tempId = emailTemplateID;
        system.debug('====> book   ' + book );
           List<Co_Applicant__c> coAppList = new List<Co_Applicant__c>();
           if(book.id != null)
           {
            coAppList = [select id,Account__c,Booking__c,Account__r.PersonEmail from Co_Applicant__c where Booking__c =: book.id];
           }
           
            Set<ID> Accids = new Set<ID>();
            for(Co_Applicant__c coapp :coAppList)
            {
                Accids.add(coapp.Account__c);
            }           
                
                
            List<Contact> cclist = [select id,MobilePhone,Phone,Email from Contact where AccountId IN : Accids];
            
            for(Contact cc : cclist)
            {
                List<Id> recordIds = new List<Id>();
              
              
              communicat_o.OutboundWrapper out= new communicat_o.OutboundWrapper();
              //out.message = 'test';
              //out.recordIds = null;
              out.activities=null;
              out.conversationId=null;
              out.engageMemberId= null;
              out.listMessageId= null;
              out.sendDateTime=datetime.now();
              out.templateId= tempId;
              
              if(cc.Phone != null)
              {
              out.senderAddress= cc.Phone;
              }
           
              
              
             // communicat_o.OSMS.sendSMS(new List<communicat_o.OutboundWrapper> {out});
              system.debug('Welcome sms Send');
              
           }
    }
    
    @Future (callout=true)
    public static void sendSMSfun(id bookindIds,string emailTemplateID)
    {
        string coapplicantNames = '';
        
        String tempId = emailTemplateID;
           List<Co_Applicant__c> coAppList = new List<Co_Applicant__c>();
           if(bookindIds != null)
           {
            coAppList = [select id,Account__c,Booking__c,Account__r.PersonEmail from Co_Applicant__c where Booking__c =: bookindIds];
           }
           
            Set<ID> Accids = new Set<ID>();
            for(Co_Applicant__c coapp :coAppList)
            {
                Accids.add(coapp.Account__c);
            }           
                
                
            List<Contact> cclist = [select id,MobilePhone,Phone,Email from Contact where AccountId IN : Accids];
            if(cclist.size()>0)
            {
                for(Contact cc : cclist)
                {
                   
                if(cc.MobilePhone!=null)
                {
                    communicat_o.OutboundWrapper.OutboundActivity acti = new communicat_o.OutboundWrapper.OutboundActivity();
                    acti.recipientAddress = cc.MobilePhone;
                    acti.recipientId = cc.id;
                    acti.relatedToId = bookindIds;
                    List<communicat_o.OutboundWrapper.OutboundActivity> liact = new List<communicat_o.OutboundWrapper.OutboundActivity>();
                    liact.add(acti);
                    communicat_o.OutboundWrapper out= new communicat_o.OutboundWrapper();
                    out.activities=liact;
                    out.sendDateTime=datetime.now();
                    out.templateId= emailTemplateID;
                    out.senderAddress= 'dynamix';
                    if(!Test.isRunningTest()){
                    communicat_o.OSMS.sendSMS(out);
                    }
                    system.debug('send sms');
                }
                  
               }
           }    
    }
    @Future (callout=true)
    public static void sendSMSforPayment(string bookindIds,string paymentIds,string emailTemplateID)
    {
        string coapplicantNames = '';
        
        String tempId = emailTemplateID;
           List<Co_Applicant__c> coAppList = new List<Co_Applicant__c>();
           if(bookindIds != null)
           {
            coAppList = [select id,Account__c,Booking__c,Account__r.PersonEmail from Co_Applicant__c where Booking__c =: bookindIds];
           }
           
            Set<ID> Accids = new Set<ID>();
            for(Co_Applicant__c coapp :coAppList)
            {
                Accids.add(coapp.Account__c);
            }           
                
                
            List<Contact> cclist = [select id,MobilePhone,Phone,Email from Contact where AccountId IN : Accids];
            if(cclist.size()>0)
            {
                for(Contact cc : cclist)
                {
                   
                if(cc.MobilePhone!=null)
                {
                    communicat_o.OutboundWrapper.OutboundActivity acti = new communicat_o.OutboundWrapper.OutboundActivity();
                    acti.recipientAddress = cc.MobilePhone;
                    acti.recipientId = cc.id;
                    acti.relatedToId = paymentIds;
                    List<communicat_o.OutboundWrapper.OutboundActivity> liact = new List<communicat_o.OutboundWrapper.OutboundActivity>();
                    liact.add(acti);
                    communicat_o.OutboundWrapper out= new communicat_o.OutboundWrapper();
                    out.activities=liact;
                    out.sendDateTime=datetime.now();
                    out.templateId= emailTemplateID;
                    out.senderAddress= 'dynamix';
                    if(!Test.isRunningTest()){
                    communicat_o.OSMS.sendSMS(out);
                    }
                    system.debug('send sms');
                }
                  
               }
           }    
    }
    @InvocableMethod(label='Send SMS class')
    public static void sendSMSInvocable(List<sendSMSInvocableRequest> requests )
    {
        string coapplicantNames = '';
        
        String tempId = requests[0].emailTemplateID;
        system.debug('tempId=='+tempId );
        system.debug(' requests[0].bookingID=='+ requests[0].bookingID);
        
        SendSMS.sendSMSfun(requests[0].bookingID,tempId);   
    }
    public class sendSMSInvocableRequest
    {
        @InvocableVariable(required=true)
        public ID bookingID;
    
        @InvocableVariable(required=true)
        public String emailTemplateID;
    }
}