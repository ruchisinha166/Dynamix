//This Batch Class Will Execute for All the Booking records for which Allotment Letter is not sent to customer till 24 hours of generated 
//This Batch class will send Email & Bell notification to booking owner : Batch Size Default(200)
//Email & notification send functionality is called From Finish Method BatchClass(AllotmentLettrRemiEmailSenderBatch) With batch Size 10 for Send Email & Notification
global class EmailReminderForSendAllotmentLetter implements DataBase.Batchable<Sobject>,DataBase.Stateful{   
    Map<String,List<Booking__c>> listOfBooking=new Map<String,List<Booking__c>>();
    global List<Booking__c> start(DataBase.BatchableContext bc){
        List<Booking__c> bookingList=new List<Booking__c>();
        TimeZone tz = UserInfo.getTimeZone();
        DateTime dt = Datetime.now();
        
        Integer offset=tz.getOffset(dt)/1000;
        Datetime currentDateTime=dt.addSeconds(offset);
        System.debug('currentDateTime:'+currentDateTime);
        
        DateTime currentDateTime1= currentDateTime.addMinutes(-10);
        System.debug('currentDateTime1:'+currentDateTime1);
        
        //get Business Hour Id
        Id businessHourId = [SELECT Id FROM BusinessHours WHERE IsDefault = true].Id;
        Integer hours = 24;
        
        //get booking data for which allotment letter is generated but still not sent to customer
        List<Booking__c> bookingData=[Select Id,Name,CreatedDate,Allotment_Letter_Generation_Date__c,OwnerId,Owner.Name,Owner.Email,Allotment_Letter_Sent__c,Project_Name__r.Name,Project_Name__c From Booking__c Where Allotment_Letter_Generation_Date__c!=null AND Allotment_Letter_Sent__c=false];
        System.debug('bookingData:'+bookingData);
        for(Booking__c bookingRcd:bookingData){
            // add 24 hour for get date & Time according to business hours
            Datetime allotLettGenDateTime = BusinessHours.add(businessHourId,bookingRcd.Allotment_Letter_Generation_Date__c, hours * 60 * 60 * 1000L);
            System.debug('allotLettGenDateTime:'+allotLettGenDateTime);
            
            Integer offset1=tz.getOffset(allotLettGenDateTime)/1000;
            Datetime allotLettGenDateTime1=(allotLettGenDateTime).addSeconds(offset1);
            System.debug('allotLettGenDateTime1:'+allotLettGenDateTime1);
            
            if(allotLettGenDateTime1>currentDateTime1 && allotLettGenDateTime1<=currentDateTime){
                bookingList.add(bookingRcd);
            }
        }
        System.debug('bookingList:'+bookingList);
        return bookingList;
    }
    global void execute(Database.BatchableContext bc,List<Booking__c> bookingList1){
        System.debug('Execute method bookingList1:'+bookingList1);
        for(Booking__c bookingRcd1:bookingList1)
        {
            if(!listOfBooking.containsKey(bookingRcd1.Owner.Email))
            {
                listOfBooking.put(bookingRcd1.Owner.Email, new List<Booking__c>());
            }
            listOfBooking.get(bookingRcd1.Owner.Email).add(bookingRcd1);
        }
        System.debug('listOfBooking-execute:'+listOfBooking); 
        
    } 
    global void finish(Database.BatchableContext bc){
        //Call Email sender Batch class with Batch Size-10
        Database.executeBatch(new AllotmentLettrRemiEmailSenderBatch(listOfBooking),10); 
    }
}