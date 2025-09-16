//This Batch Class Will Execute for All the opportunity records for which Booking Form is submitted by customer but KYC is still not complete after 48 hours
//This Batch class will send Email to Site Head  : Batch Size Default(200)
//Email send functionality to Site Head is called From Finish Method 
global class BookingFormKYCCompleteEscalationBatch implements DataBase.Batchable<Sobject>,DataBase.Stateful{   
    Map<String,List<Booking__c>> userMapWithBooking=new Map<String,List<Booking__c>>();   
    Map <Id,Opportunity> opportunityMap=new Map<Id,Opportunity>();
    Map <Id,Project__c> projectMap=new Map<Id,Project__c>();
    global List<Booking__c> start(DataBase.BatchableContext bc){   
        List<Booking__c> bookingList = new List<Booking__c>();
        TimeZone tz = UserInfo.getTimeZone();
        DateTime dt = Datetime.now();        
        //get Business Hour Id
        Id businessHourId = [SELECT Id FROM BusinessHours WHERE IsDefault = true].Id;
        Integer hours = -48;       
        // deduct 48 hour for get date & Time according to business hours
        Datetime dateTimeBefore48hours = BusinessHours.add(businessHourId,dt, hours * 60 * 60 * 1000L);       
        System.debug('dateTimeBefore48hours:'+dateTimeBefore48hours);
        
        Integer offset= (tz.getOffset(dateTimeBefore48hours)/1000);
        Datetime dateTimeBefore48hours1=dateTimeBefore48hours.addSeconds(offset);
        System.debug('dateTimeBefore48hours1:'+dateTimeBefore48hours1);
        
        //deduct 10 minutes
        DateTime dateTimeBefore48hours2= dateTimeBefore48hours1.addMinutes(-10);
        System.debug('dateTimeBefore48hours2:'+dateTimeBefore48hours2);
        
        List<Opportunity> opportunityList=[Select Id,Name,Booking_Form_Submitted_by_Customer_Date__c,Is_Booking_Form_Submitted_by_Customer__c,Owner.Email,KYC_Completed__c From Opportunity
                                           Where Is_Booking_Form_Submitted_by_Customer__c=true AND Booking_Form_Submitted_by_Customer_Date__c != null AND KYC_Completed__c=false];
        System.debug('opportunityList:'+ opportunityList);
        
         for(Opportunity oppRcd:opportunityList){            
            Integer offset1=tz.getOffset(oppRcd.Booking_Form_Submitted_by_Customer_Date__c)/1000;
            Datetime bookingFormSubmitDate=(oppRcd.Booking_Form_Submitted_by_Customer_Date__c).addSeconds(offset1);
            System.debug('bookingFormSubmitDate:'+bookingFormSubmitDate);
            if(bookingFormSubmitDate>=dateTimeBefore48hours2 && bookingFormSubmitDate<=dateTimeBefore48hours1){
                opportunityMap.put(oppRcd.Id,oppRcd);
            }
        }
        System.debug('opportunityMap:'+ opportunityMap);
        
        bookingList=[Select Id,Name,Project_Name_Formulla__c,Unit_Number__c,Related_Opportunity__c,CreatedDate,Project_Name__c,Owner.Name From Booking__c Where Related_Opportunity__c=:opportunityMap.keySet()];
        System.debug('bookingList:'+ bookingList);
        return bookingList;
    }
    global void execute(Database.BatchableContext bc,List<Booking__c> bookingList1){
        System.debug('bookingList1 execute:'+ bookingList1);
        Set<String> projectIdsSet=new Set<String>();
        for(Booking__c bookingVar1:bookingList1){
            if(bookingVar1.Project_Name__c!=null){
                projectIdsSet.add(bookingVar1.Project_Name__c);
            }
        }
        projectMap=new Map<Id,Project__c>([Select Id,Name,Site_Head__c,Site_Head__r.Email,Site_Head__r.Name From Project__c Where Id=: projectIdsSet]);
        //for add records for Site Head
        for(Booking__c bookingVar:bookingList1){
            if(bookingVar.Project_Name__c!=null){
                Project__c projectRcd=projectMap.get(bookingVar.Project_Name__c);
                System.debug('projectRcd:'+projectRcd);
                String siteHeadEmail=projectRcd.Site_Head__r.Email;
                if(!userMapWithBooking.containsKey(siteHeadEmail))
                {
                    userMapWithBooking.put(siteHeadEmail, new List<Booking__c>());
                }
                userMapWithBooking.get(siteHeadEmail).add(bookingVar);
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
                        tableHtmlBody +='<tr><td>' + bookingName +'</td><td>'+ dt +'</td><td>'+ dueDate +'</td><td>'+ bookingRcd.Unit_Number__c + '</td><td>'+ bookingRcd.Project_Name_Formulla__c + '</td><td>'+ bookingOwner + '</td></tr>';           
                    }
                }
                tableHtmlBody += '</table></br>Thank You, </br> Dynamix';
                System.debug('tableHtmlBody:'+tableHtmlBody);
                
                EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Booking_Form_Escalation_For_KYC_Complete' LIMIT 1];
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