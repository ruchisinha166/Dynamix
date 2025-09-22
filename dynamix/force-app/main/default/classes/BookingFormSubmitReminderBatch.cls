//This Batch Class Will Execute for All the opportunity records for which Booking Form is not sent to customer till 24 hours of booking Form Shared 
//This Batch class will send Email to SM & Customer : Batch Size Default(200)
//Email send functionality to SM & Customer is called From Finish Method 
global class BookingFormSubmitReminderBatch implements DataBase.Batchable<Sobject>,Database.AllowsCallouts,DataBase.Stateful{   
    Map<String,List<Booking__c>> userMapWithBooking=new Map<String,List<Booking__c>>();   
    Map<String,List<Booking__c>> userMapWithBooking1=new Map<String,List<Booking__c>>();   
    Map <Id,Opportunity> opportunityMap=new Map<Id,Opportunity>();
    EmailTemplate smsEmailTemp;
    SMS_Template_Id__mdt smsTemplate;
    communicat_o__Registered_Template__mdt regWhatEmailTemp;
    global List<Booking__c> start(DataBase.BatchableContext bc){   
        List<Booking__c> bookingList = new List<Booking__c>();
        TimeZone tz = UserInfo.getTimeZone();
        DateTime dt = Datetime.now();        
        //get Business Hour Id
        Id businessHourId = [SELECT Id FROM BusinessHours WHERE IsDefault = true].Id;
        Integer hours = -24;       
        // deduct 24 hour for get date & Time according to business hours
        Datetime dateTimeBefore24hours = BusinessHours.add(businessHourId,dt, hours * 60 * 60 * 1000L);       
        System.debug('dateBefore24hours:'+dateTimeBefore24hours);
        
        Integer offset= (tz.getOffset(dateTimeBefore24hours)/1000);
        Datetime dateTimeBefore24hours1=dateTimeBefore24hours.addSeconds(offset);
        System.debug('dateTimeBefore24hours1:'+dateTimeBefore24hours1);
        
        Date dateBefore24hours = dateTimeBefore24hours1.date();
        System.debug('dateBefore24hours:'+dateBefore24hours);
        if(test.isRunningTest())
        {
            dateBefore24hours = system.today().AddDays(1);
        }
        
        opportunityMap=new Map<Id,Opportunity>([Select Id,Name,Booking_Form_Shared_to_Customer_Date__c,Is_Booking_Form_Submitted_by_Customer__c,Owner.Email From Opportunity
                                                Where Is_Booking_Form_Submitted_by_Customer__c=false AND Booking_Form_Shared_to_Customer_Date__c=:dateBefore24hours]);
        System.debug('opportunityMap:'+ opportunityMap);
        
        bookingList=[Select Id,Name,Project_Name_Formulla__c,Unit_Number__c,Related_Opportunity__c,CreatedDate,Primary_Applicant__c,Primary_Applicant_Name_Formulla__c,Primary_Applicant__r.PersonEmail,Primary_Applicant__r.PersonMobilePhone,Owner.Name From Booking__c Where Related_Opportunity__c=:opportunityMap.keySet()];
        System.debug('bookingList:'+ bookingList);
        //For Send Text Message
        smsTemplate = [Select Id, SMS_Template__c, External_Template_Id__c From SMS_Template_Id__mdt Where MasterLabel='SMS Booking Form Reminder' Limit 1];

        smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Booking Form Reminder' Limit 1];
        System.debug('smsEmailTemp:'+smsEmailTemp);
        //For Send WhatsApp Message
        regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp Booking Form Reminder' Limit 1];
        System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
        
        return bookingList;
    }
    global void execute(Database.BatchableContext bc,List<Booking__c> bookingList){
        System.debug('bookingList execute:'+ bookingList);
        //for add records for SM
        for(Booking__c bookingVar:bookingList){
            if(bookingVar.Related_Opportunity__c!=null){
                Opportunity oppRcd=opportunityMap.get(bookingVar.Related_Opportunity__c);
                System.debug('oppRcd loop:'+oppRcd);
                String oppOwnerEmail=oppRcd.Owner.Email;
                if(!userMapWithBooking.containsKey(oppOwnerEmail))
                {
                    userMapWithBooking.put(oppOwnerEmail, new List<Booking__c>());
                }
                userMapWithBooking.get(oppOwnerEmail).add(bookingVar);
            }
            
        }
        //for add records for Customer
        for(Booking__c bookingVar:bookingList){
            if(bookingVar.Primary_Applicant__r.PersonEmail!=null){                
                String customerEmail=bookingVar.Primary_Applicant__r.PersonEmail;
                if(!userMapWithBooking1.containsKey(customerEmail))
                {
                    userMapWithBooking1.put(customerEmail, new List<Booking__c>());
                }
                userMapWithBooking1.get(customerEmail).add(bookingVar);
            } 
            //for Send SMS
            if(bookingVar.Primary_Applicant__r.PersonMobilePhone!=null && smsEmailTemp!=null && smsTemplate!=null  ){              
                if(bookingVar.Primary_Applicant__r.PersonMobilePhone!=null){
                    String templateBody=smsEmailTemp.HtmlValue;
                    String mobileNumber=bookingVar.Primary_Applicant__r.PersonMobilePhone;
                    templateBody = templateBody.replace('{{{Booking__c.Primary_Applicant_Name_Formulla__c}}}',bookingVar.Primary_Applicant_Name_Formulla__c);   

                    templateBody = templateBody.replace('{{{Booking__c.Project_Name__c}}}',bookingVar.Project_Name_Formulla__c); 
                    templateBody = templateBody.replace('{{{Booking__c.Name}}}',bookingVar.Name);                     
                    templateBody=templateBody.stripHtmlTags();
                    System.debug('templateBody:'+templateBody);
                    //SendPaymentReminderMessage.sendTextMessage(templateBody,mobileNumber,'DYNAMX');
                     if(!test.isRunningTest())
                        {
                            SendSMSUtility.sendSMSMethod(templateBody,mobileNumber,'DYNAMX',smsTemplate.External_Template_Id__c);
                        }
                }                
            } 
            //for Send WhatsApp Message
            if(bookingVar.Primary_Applicant__r.PersonMobilePhone!=null && regWhatEmailTemp!=null ){             
                if(bookingVar.Primary_Applicant__r.PersonMobilePhone!=null){
                    String recipientAddress=bookingVar.Primary_Applicant__r.PersonMobilePhone;
                    String recipientId=bookingVar.Primary_Applicant__c;
                    String emailTemplateId=String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
                    String relatedToId=bookingVar.Id;
                    System.debug('emailTemplateId:'+emailTemplateId);
                    if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                        SendPaymentReminderMessage.SendWhatsAppMessage(recipientAddress, recipientId, emailTemplateId,relatedToId);
                    }
                }
            }
        }
    } 
    global void finish(Database.BatchableContext bc){
        system.debug('userMapWithBooking:'+userMapWithBooking);
        if(userMapWithBooking.size()>0){
            for(String userRcd:userMapWithBooking.keySet()){
                Set<String> bookingRcdIdsSet=new Set<String>();
                String tableHtmlBody= '';            
                tableHtmlBody +=  '<table border="1" style="border-collapse: collapse"><tr><th>Booking Name</th><th>Created Date</th><th>BookingForm Shared Date</th><th>Apartment No.</th><th>Project Name</th><th>Booking Owner</th></tr>';
                
                for(Booking__c bookingRcd:userMapWithBooking.get(userRcd))
                {
                    if(bookingRcdIdsSet.contains(bookingRcd.Id)){
                    }
                    else{
                        bookingRcdIdsSet.add(bookingRcd.Id);
                        Opportunity oppRcd=opportunityMap.get(bookingRcd.Related_Opportunity__c);
                        String dueDate = oppRcd.Booking_Form_Shared_to_Customer_Date__c.format();
                        String bookingName =bookingRcd.Name;
                        String bookingOwner =bookingRcd.Owner.Name;
                        String dt=bookingRcd.CreatedDate.format('dd/MM/yyyy');                
                        tableHtmlBody +='<tr><td>' + bookingName +'</td><td>'+ dt +'</td><td>'+ dueDate + '</td><td>'+ bookingRcd.Unit_Number__c + '</td><td>'+ bookingRcd.Project_Name_Formulla__c + '</td><td>'+ bookingOwner + '</td></tr>';           
                    }
                }
                tableHtmlBody += '</table></br>Thank You, </br> Dynamix';
                System.debug('tableHtmlBody:'+tableHtmlBody);
                
                EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Booking_Form_Reminder_For_Submit_Email' LIMIT 1];
                System.debug('emailTemplate:'+emailTemplate);
                String htmlBody = emailTemplate.HtmlValue+tableHtmlBody;
                String plainBody = emailTemplate.Body+tableHtmlBody;
                if(emailTemplate!=null){           
                    List<String> emailList=new List<String>();           
                    emailList.add(userRcd); 
                    SendEmailandBellNotificationUtility.SendEmail(emailTemplate.Id,htmlBody,plainBody,emailList,null);
                }
            }
        }
        
        if(userMapWithBooking1.size()>0){
            for(String userRcd:userMapWithBooking1.keySet()){
                Set<String> bookingRcdIdsSet=new Set<String>();
                String tableHtmlBody= '';            
                tableHtmlBody +=  '<table border="1" style="border-collapse: collapse"><tr><th>Booking Name</th><th>Created Date</th><th>BookingForm Shared Date</th><th>Apartment No.</th><th>Project Name</th><th>Booking Owner</th></tr>';
                
                for(Booking__c bookingRcd:userMapWithBooking1.get(userRcd))
                {
                    if(bookingRcdIdsSet.contains(bookingRcd.Id)){
                    }
                    else{
                        bookingRcdIdsSet.add(bookingRcd.Id);
                        Opportunity oppRcd=opportunityMap.get(bookingRcd.Related_Opportunity__c);
                        String dueDate = oppRcd.Booking_Form_Shared_to_Customer_Date__c.format();
                        String bookingName =bookingRcd.Name;
                        String bookingOwner =bookingRcd.Owner.Name;
                        String dt=bookingRcd.CreatedDate.format('dd/MM/yyyy');                
                        tableHtmlBody +='<tr><td>' + bookingName +'</td><td>'+ dt +'</td><td>'+ dueDate + '</td><td>'+ bookingRcd.Unit_Number__c + '</td><td>'+ bookingRcd.Project_Name_Formulla__c + '</td><td>'+ bookingOwner + '</td></tr>';           
                    }
                }
                tableHtmlBody += '</table></br>Thank You, </br> Dynamix';
                System.debug('tableHtmlBody:'+tableHtmlBody);
                
                EmailTemplate emailTemplate1 = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Booking_Form_Reminder_To_Customer' LIMIT 1];
                System.debug('emailTemplate:'+emailTemplate1);
                
                String htmlBody = emailTemplate1.HtmlValue+tableHtmlBody;      
                String plainBody = emailTemplate1.Body+tableHtmlBody;
                
                if(emailTemplate1!=null){           
                    List<String> emailList=new List<String>();           
                    emailList.add(userRcd); 
                    SendEmailandBellNotificationUtility.SendEmail(emailTemplate1.Id,htmlBody,plainBody,emailList,null);
                }
            }
        }
    }
}