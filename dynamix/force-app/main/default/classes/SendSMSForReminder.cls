Public class SendSMSForReminder{
    
    public static void SendSMSReminder(map<id,id> mapBM,String EmailTemplateName){
        		
            try{
                List<booking__c> bookinglist = new list<booking__c>();
                List<Co_Applicant__c> coAppList = new List<Co_Applicant__c>();
                bookinglist =[select id,Primary_Applicant__r.personcontactid from booking__c where id IN:mapBM.keyset()];
                system.debug('bookinglist sms=='+bookinglist);
                coAppList = [select id,Account__c,Booking__c,Account__r.PersonEmail from Co_Applicant__c where Booking__c =: mapBM.keyset()];  
                
                Set<ID> Accids = new Set<ID>();
                for(Co_Applicant__c coapp :coAppList)
                {
                    Accids.add(coapp.Account__c);
                } 
                List<Contact> cclist1 = [select id,MobilePhone,Phone,Email from Contact where AccountId IN : Accids];
                List<account> cclist = [select id,PersonMobilePhone,Phone,PersonEmail from account where id IN : Accids];
                List<communicat_o.OutboundWrapper.OutboundActivity> liact = new List<communicat_o.OutboundWrapper.OutboundActivity>();
                                    
                for(id pmId: mapBM.values())
                {
                    for(account cc : cclist)
                    {
                        if(cc.PersonMobilePhone!=null)
                        {
                            communicat_o.OutboundWrapper.OutboundActivity acti = new communicat_o.OutboundWrapper.OutboundActivity();
                            acti.recipientAddress = cc.PersonMobilePhone;
                             system.debug('cc.MobilePhone=='+cc.PersonMobilePhone);
                            acti.recipientId =cc.id;
                            system.debug('cc.id=='+cc.id);
                            acti.relatedToId = pmId;
                            system.debug('pmId=='+pmId);
                            liact.add(acti);  
                        } 
                    }    
                } 
                communicat_o.OutboundWrapper out= new communicat_o.OutboundWrapper();
                out.activities=liact;
                system.debug(' out.activities '+ liact);
                out.sendDateTime=datetime.now();
                out.templateId= EmailTemplateName;
                system.debug('emailTemplate.id=='+EmailTemplateName);
                out.senderAddress= 'dynamix';
                communicat_o.OSMS.sendSMS(out);
                system.debug('send sms');   
                 
            }Catch(Exception e)
            {
                system.debug('==> SendsmsReminder Class '  + e.getMessage()+e.getLineNumber());
            }
        }
    	public static void sendWhatsappRem(map<id,Payment_Milestones__c> mapBM,String EmailTemplateName){
            try{
                List<booking__c> bookinglist = new list<booking__c>();
                List<Co_Applicant__c> coAppList = new List<Co_Applicant__c>();
                bookinglist =[select id,Primary_Applicant__r.personcontactid from booking__c where id IN:mapBM.keyset()];
                system.debug('bookinglist sms=='+bookinglist);
                coAppList = [select id,Account__r.name,Account__c,Booking__c,Account__r.PersonEmail,Account__r.PersonMobilePhone from Co_Applicant__c where Booking__c =: mapBM.keyset()];
                system.debug('coAppList '+coAppList);
                
                //=============
                Map<Id,List<Co_Applicant__c>> mapOfBookAndAccount = new Map<Id,List<Co_Applicant__c>>();
            
                //============
                
                Set<ID> Accids = new Set<ID>();
                for(Co_Applicant__c coapp :coAppList)
                {
                    Accids.add(coapp.Account__c);
                    if(!mapOfBookAndAccount.keyset().contains(coapp.Booking__c)){
                        mapOfBookAndAccount.put(coapp.Booking__c,new list<Co_Applicant__c>());
                    }
                    mapOfBookAndAccount.get(coapp.Booking__c).add(coapp);
                } 
                system.debug('mapOfBookAndAccount '+ mapOfBookAndAccount);
                List<Contact> cclist1 = [select id,MobilePhone,Phone,Email from Contact where AccountId IN : Accids];
                List<account> cclist = [select id,PersonMobilePhone,Phone,PersonEmail from account where id IN : Accids];
                List<communicat_o.OutboundWrapper.OutboundActivity> liact = new List<communicat_o.OutboundWrapper.OutboundActivity>();
                                    
                for(Payment_Milestones__c pmId: mapBM.values())
                {
                    for(List<Co_Applicant__c> cpList : mapOfBookAndAccount.values()){
                        
                        system.debug('cpList '+cpList);
                        for(Co_Applicant__c ca: cpList)
                        {
                            if(pmId.Booking__c == ca.booking__c)
                            {
                                system.debug('Account__r.name '+ ca.Account__r.name);
                                communicat_o.OutboundWrapper.OutboundActivity acti = new communicat_o.OutboundWrapper.OutboundActivity();
                                acti.recipientAddress = ca.Account__r.PersonMobilePhone;
                               //  system.debug('cc.MobilePhone=='+cc.PersonMobilePhone);
                                acti.recipientId =ca.Account__c;
                              //  system.debug('cc.id=='+cc.id);
                                acti.relatedToId = pmId.id;
                                system.debug('pmId=='+pmId);
                                liact.add(acti);  
                            } 
                        }
                  }
                } 
                communicat_o.OutboundWrapper out= new communicat_o.OutboundWrapper();
                out.activities=liact;
                system.debug(' out.activities '+ liact);
                out.sendDateTime=datetime.now();
                out.templateId= EmailTemplateName;
                system.debug('emailTemplate.id=='+EmailTemplateName);
                out.senderAddress= 'Dynamix_919152915208';
                communicat_o.OSMS.sendSMS(out);
                system.debug('send sms');   
                 
            }Catch(Exception e)
            {
                system.debug('==> SendsmsReminder Class '  + e.getMessage()+e.getLineNumber());
            }
                
        }
}