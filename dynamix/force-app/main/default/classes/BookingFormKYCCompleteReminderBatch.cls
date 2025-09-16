//This Batch Class Will Execute for All the opportunity records for which Booking Form is submitted by customer but KYC is still not complete after 24 hours
//This Batch class will send Email to SM  : Batch Size Default(200)
//Email send functionality to SM is called From Finish Method 
global class BookingFormKYCCompleteReminderBatch implements DataBase.Batchable<Sobject>,Database.AllowsCallouts,DataBase.Stateful{   
    Map<String,List<Booking__c>> userMapWithBooking=new Map<String,List<Booking__c>>();   
    Map <Id,Opportunity> opportunityMap=new Map<Id,Opportunity>();
    EmailTemplate smsEmailTemp;
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
        
        //deduct 10 minutes
        DateTime dateTimeBefore24hours2= dateTimeBefore24hours1.addMinutes(-10);
        System.debug('dateTimeBefore24hours2:'+dateTimeBefore24hours2);
        
        List<Opportunity> opportunityList=[Select Id,Name,Booking_Form_Submitted_by_Customer_Date__c,Is_Booking_Form_Submitted_by_Customer__c,Owner.Email,KYC_Completed__c From Opportunity
                                           Where Is_Booking_Form_Submitted_by_Customer__c=true AND Booking_Form_Submitted_by_Customer_Date__c != null AND KYC_Completed__c=false];
        System.debug('opportunityList:'+ opportunityList);
        for(Opportunity oppRcd:opportunityList){            
            Integer offset1=tz.getOffset(oppRcd.Booking_Form_Submitted_by_Customer_Date__c)/1000;
            Datetime bookingFormSubmitDate=(oppRcd.Booking_Form_Submitted_by_Customer_Date__c).addSeconds(offset1);
            System.debug('bookingFormSubmitDate:'+bookingFormSubmitDate);
            if(bookingFormSubmitDate>=dateTimeBefore24hours2 && bookingFormSubmitDate<=dateTimeBefore24hours1){
                opportunityMap.put(oppRcd.Id,oppRcd);
            }
        }
        System.debug('opportunityMap:'+ opportunityMap);
        
        bookingList=[Select Id,Name,Project_Name_Formulla__c,Unit_Number__c,Related_Opportunity__c,CreatedDate,Owner.Name,Primary_Applicant__c,Primary_Applicant_Name_Formulla__c,Primary_Applicant__r.PersonMobilePhone From Booking__c Where Related_Opportunity__c=:opportunityMap.keySet()];
        System.debug('bookingList:'+ bookingList);
        
        //For Send Text Message
        smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Booking KYC Reminder' Limit 1];
        System.debug('smsEmailTemp:'+smsEmailTemp);
        //For Send WhatsApp Message
        regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp Booking KYC Reminder' Limit 1];
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
        //for Send Message to Customer
        for(Booking__c bookingVar:bookingList){ 
            //for Send SMS
            if(bookingVar.Primary_Applicant__r.PersonMobilePhone!=null && smsEmailTemp!=null ){              
                if(bookingVar.Primary_Applicant__r.PersonMobilePhone!=null){
                    String templateBody=smsEmailTemp.HtmlValue;
                    String mobileNumber=bookingVar.Primary_Applicant__r.PersonMobilePhone;
                    templateBody = templateBody.replace('{{{Booking__c.Primary_Applicant_Name_Formulla__c}}}',bookingVar.Primary_Applicant_Name_Formulla__c);   
                    templateBody = templateBody.replace('{{{Booking__c.Project_Name__c}}}',bookingVar.Project_Name_Formulla__c); 
                    templateBody = templateBody.replace('{{{Booking__c.Name}}}',bookingVar.Name);                     
                    templateBody=templateBody.stripHtmlTags();
                    System.debug('templateBody:'+templateBody);
                    SendPaymentReminderMessage.sendTextMessage(templateBody,mobileNumber,'DYNAMX');
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
                tableHtmlBody +=  '<table border="1" style="border-collapse: collapse"><tr><th>Booking Name</th><th>Created Date</th><th>BookingForm Submit Date</th><th>Apartment No.</th><th>Project Name</th><th>Booking Owner</th></tr>';
                
                for(Booking__c bookingRcd:userMapWithBooking.get(userRcd))
                {
                    if(bookingRcdIdsSet.contains(bookingRcd.Id)){
                    }
                    else{
                        bookingRcdIdsSet.add(bookingRcd.Id);
                        Opportunity oppRcd=opportunityMap.get(bookingRcd.Related_Opportunity__c);
                        String dueDate = oppRcd.Booking_Form_Submitted_by_Customer_Date__c.format();
                        String bookingName =bookingRcd.Name;
                        String bookingOwner =bookingRcd.Owner.Name;
                        String dt=bookingRcd.CreatedDate.format('dd/MM/yyyy');                
                        tableHtmlBody +='<tr><td>' + bookingName +'</td><td>'+ dt +'</td><td>'+ dueDate + '</td><td>'+ bookingRcd.Unit_Number__c + '</td><td>'+ bookingRcd.Project_Name_Formulla__c + '</td><td>'+ bookingOwner + '</td></tr>';           
                    }
                }
                tableHtmlBody += '</table></br>Thank You, </br> Dynamix';
                System.debug('tableHtmlBody:'+tableHtmlBody);
                
                EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Booking_Form_Reminder_For_KYC_Complete' LIMIT 1];
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
    }
}