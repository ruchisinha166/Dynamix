public with sharing class checkRecordIsInApproval{
    
    @InvocableMethod(label='check Record Is In Approval')
    public static list<boolean> execute( List<Requests> requestLst){
        //Approval.isLocked(requestLst[0].bookingId);
        return new List<boolean>{Approval.isLocked(requestLst[0].bookingId)};
    }
     public class Requests {
        
        @InvocableVariable(label='Booking Id' required=true)
        public String bookingId;
      
    }
}