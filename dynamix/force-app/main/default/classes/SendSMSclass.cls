Public class SendSMSclass{
    public static void SendSMS(string bookingID,string OtherID,String EmailTemplateID){
            try{
                
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
                List<Contact> cclist1 = [select id,MobilePhone,Phone,Email from Contact where AccountId IN : Accids];
                List<account> cclist = [select id,PersonMobilePhone,Phone,PersonEmail from account where id IN : Accids];
            
                  for(account cc : cclist)
                    {
                         if(cc.PersonMobilePhone!=null)
                         {
                            communicat_o.OutboundWrapper.OutboundActivity acti = new communicat_o.OutboundWrapper.OutboundActivity();
                            acti.recipientAddress = cc.PersonMobilePhone;
                            acti.recipientId = cc.id;
                            acti.relatedToId = OtherID;
                            List<communicat_o.OutboundWrapper.OutboundActivity> liact = new List<communicat_o.OutboundWrapper.OutboundActivity>();
                            liact.add(acti);
                            communicat_o.OutboundWrapper out= new communicat_o.OutboundWrapper();
                            out.activities=liact;
                            out.sendDateTime=datetime.now();
                            out.templateId= emailTemplateID;
                            out.senderAddress= 'dynamix';
                            communicat_o.OSMS.sendSMS(out);
                            system.debug('send sms');
                        }
                  
                  
              }    
                      
                
            }Catch(Exception e)
            {
                system.debug('==> e'  + e.getMessage()+e.getLineNumber());
            }
                
        }
        public static void SendSMSForDemandLatter(list<id> bookingID,String EmailTemplateID){
            try{
                
                //EmailTemplate emailTemplate = [Select Id,name,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where id=:EmailTemplateName];
                
                List<booking__c> bookinglist = new list<booking__c>();
                List<Co_Applicant__c> coAppList = new List<Co_Applicant__c>();
                bookinglist =[select id,Primary_Applicant__r.personcontactid from booking__c where id IN:bookingID];
                system.debug('bookinglist sms=='+bookinglist);
                coAppList = [select id,Account__c,Booking__c,Account__r.PersonEmail from Co_Applicant__c where Booking__c IN:bookingID];  
                
                Set<ID> Accids = new Set<ID>();
                for(Co_Applicant__c coapp :coAppList)
                {
                    Accids.add(coapp.Account__c);
                } 
                List<Contact> cclist1 = [select id,MobilePhone,Phone,Email from Contact where AccountId IN : Accids];
                List<account> cclist = [select id,PersonMobilePhone,Phone,PersonEmail from account where id IN : Accids];
                for(id bid : bookingID)
                {
                  for(account cc : cclist)
                    {
                        communicat_o.OutboundWrapper.OutboundActivity acti = new communicat_o.OutboundWrapper.OutboundActivity();
                        acti.recipientAddress = cc.PersonMobilePhone;
                         system.debug('cc.phone=='+cc.PersonMobilePhone);
                        acti.recipientId =cc.id;
                        system.debug('cc.id=='+cc.id);
                        acti.relatedToId = bid;
                        system.debug('bookingID=='+bid );
                        List<communicat_o.OutboundWrapper.OutboundActivity> liact = new List<communicat_o.OutboundWrapper.OutboundActivity>();
                        liact.add(acti);
                        communicat_o.OutboundWrapper out= new communicat_o.OutboundWrapper();
                        out.activities=liact;
                        out.sendDateTime=datetime.now();
                        out.templateId= EmailTemplateID;
                        system.debug('emailTemplate.id=='+EmailTemplateID);
                        out.senderAddress= 'dynamix';
                        communicat_o.OSMS.sendSMS(out);
                        system.debug('send sms');   
                    }    
                      
             }
            }Catch(Exception e)
            {
                system.debug('==> e'  + e.getMessage()+e.getLineNumber());
            }
                
        }
}