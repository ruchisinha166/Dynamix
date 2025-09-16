public class BookingNumberOnCampaign {
    public static void getBookingsOnCampaign(List<Booking__c> bookList){
        Set<Id> oppId = new Set<Id>();
        Set<Id> enqId = new Set<Id>();
        Set<Id> campId = new Set<Id>();
        Map<Id,decimal> agreementValueCountMap = New Map<Id,decimal>();
        Map<Id,decimal> agreementValueCountFinalMap = New Map<Id,decimal>();
        for(Booking__c book:bookList){
            if(book.Related_Opportunity__c != null){
                oppId.add(book.Related_Opportunity__c);
                agreementValueCountMap.put(book.Related_Opportunity__c,book.Agreement_Value__c);
            }
        }
        if(oppId != null){
            for(Opportunity opp:[Select Id,Linked_Enquiry__c from Opportunity where Id=:oppId]){
                if(opp.Linked_Enquiry__c != null){
                    enqId.add(opp.Linked_Enquiry__c);
                    if(agreementValueCountMap.containsKey(opp.Linked_Enquiry__c))
                    {
                        agreementValueCountFinalMap.put(opp.Linked_Enquiry__c,agreementValueCountMap.get(opp.Linked_Enquiry__c));
                    }
                }
            }
        }
        if(enqId != null){
            for(Enquiry__c enq:[Select Id,Campaign__c from Enquiry__c where Id=:enqId]){
                if(enq.Campaign__c != null){
                    campId.add(enq.Campaign__c);
                    if(agreementValueCountFinalMap.containsKey(enq.id))
                    {
                        agreementValueCountFinalMap.put(enq.Campaign__c,agreementValueCountFinalMap.get(enq.id));
                    }
                }
            }
        }
        //Decimal count = 0;
        if(campId != null){
            List<Campaign> campUpdateList = new List<Campaign>();
            for(Campaign camp:[Select Id,Number_of_Bookings__c from Campaign where Id=:campId]){
                if(agreementValueCountFinalMap.containsKey(camp.id))
                {
                    if(camp.Sum_of_Agreement_Value__c != null)
                    {
                       camp.Sum_of_Agreement_Value__c += integer.valueof(agreementValueCountFinalMap.get(camp.id)); 
                    }
                    else
                    {
                         camp.Sum_of_Agreement_Value__c = integer.valueof(agreementValueCountFinalMap.get(camp.id));
                    }
                }
                camp.Number_of_Bookings__c += 1;
                campUpdateList.add(camp);
            }
            update campUpdateList;
        }        
    }
    public static void getBookingsOnCampaignDelete(List<Booking__c> bookList){
        Set<Id> oppId = new Set<Id>();
        Set<Id> enqId = new Set<Id>();
        Set<Id> campId = new Set<Id>();
        Map<Id,decimal> agreementValueCountMap = New Map<Id,decimal>();
        Map<Id,decimal> agreementValueCountFinalMap = New Map<Id,decimal>();

        for(Booking__c book:bookList){
            if(book.Related_Opportunity__c != null){
                oppId.add(book.Related_Opportunity__c);
                agreementValueCountMap.put(book.Related_Opportunity__c,book.Agreement_Value__c);

            }
        }
        if(oppId != null){
            for(Opportunity opp:[Select Id,Linked_Enquiry__c from Opportunity where Id=:oppId]){
                if(opp.Linked_Enquiry__c != null){
                    enqId.add(opp.Linked_Enquiry__c);
                    if(agreementValueCountMap.containsKey(opp.Linked_Enquiry__c))
                    {
                        agreementValueCountFinalMap.put(opp.Linked_Enquiry__c,agreementValueCountMap.get(opp.Linked_Enquiry__c));
                    }
                }
            }
        }
        if(enqId != null){
            for(Enquiry__c enq:[Select Id,Campaign__c from Enquiry__c where Id=:enqId]){
                if(enq.Campaign__c != null){
                    campId.add(enq.Campaign__c);
                    if(agreementValueCountFinalMap.containsKey(enq.id))
                    {
                        agreementValueCountFinalMap.put(enq.Campaign__c,agreementValueCountFinalMap.get(enq.id));
                    }
                }
            }
        }
        //Decimal count = 0;
        if(campId != null){
            List<Campaign> campUpdateList = new List<Campaign>();
            for(Campaign camp:[Select Id,Number_of_Bookings__c from Campaign where Id=:campId]){
                camp.Number_of_Bookings__c -= 1;
                campUpdateList.add(camp);
                if(agreementValueCountFinalMap.containsKey(camp.id))
                {
                    if(camp.Sum_of_Agreement_Value__c != null)
                    {
                       camp.Sum_of_Agreement_Value__c -= integer.valueof(agreementValueCountFinalMap.get(camp.id)); 
                    }
                   
                }
            }
            update campUpdateList;
        }        
    }
}