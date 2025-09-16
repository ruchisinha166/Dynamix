public class SendEmailWithTDStoCustomer {
    public static void SendEmail(List<ContentVersion> listOfContentVersion){
        String AttachmentName;
        Blob Data;
        String filetype;
        String BookID;
        String PrimaryApplicant;
        String Email;
        String Name;
        String BookingNumber;
        String FileName;
        String bookingID;
        
        Set<Id> bookingIDs = new Set<Id>();
        Set<Id> PaymentIDs = new Set<Id>();
        Set<Id> contentDocumentIDSet = new Set<Id>();
        if(!listOfContentVersion.isEmpty()){
            system.debug('listofContentVersion----'+listOfContentVersion);
            for(ContentVersion CV:listOfContentVersion){
                system.debug('DocTypeAndDOBjectType---'+CV.SObjectType__c+CV.Document_Type__c);
                if(CV.SObjectType__c=='Booking__c' && CV.Document_Type__c == 'Payment Receipt'){
                    system.debug('BookngIDCV----'+Cv.BookingId__c);
                    system.debug('FirstPublishLocationId----'+CV.FirstPublishLocationId);
                    
                    if(CV.BookingId__c!=null){
                        bookingIDs.add(CV.BookingId__c);
                        system.debug('bookingIDs----'+bookingIDs);
                        String fileExt = cv.Title.substringAfterLast('.');
                        FileName = cv.Title.removeEnd('.'+fileExt).Trim();
                        
                        system.debug('FileName----'+FileName);
                        
                    }
                    if(!bookingIDs.isEmpty()){
                        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Send_TDS_Receipt_to_Customer' LIMIT 1];
                        List<Booking__c> bookingList = [Select Id,Name,OwnerId,Owner.Name, Owner.Email,Owner.Phone,Primary_Applicant__c From Booking__c Where Id In : bookingIDs];
                        system.debug('bookingList----'+bookingList);
                        for(Booking__c book:bookingList){
                            PrimaryApplicant = book.Primary_Applicant__c;
                            BookingNumber = book.Name;
                            bookingID = book.Id;
                        }
                        
                        List<Account> AccList = [Select Id,Name,PersonEmail From Account Where Id=:PrimaryApplicant ];
                        system.debug(AccList);
                        if(!AccList.isEmpty()){
                            for(Account Acc:AccList){
                                Email=Acc.PersonEmail;
                                Name=Acc.Name;
                            }
                            
                        }
               
                        List<Payment__c> PayList = [Select ID,Name,Receipt_No__c From Payment__c Where Booking__c IN : bookingIDs And Payment_Status__c='Approved' And Payment_Category__c='TDS'];
                        system.debug('PayList----'+PayList);
                        if(!PayList.isEmpty()){
                            for(Payment__c pay:PayList){
                                system.debug('Receipt_No__c----'+pay.Receipt_No__c);
                                if(FileName==pay.Receipt_No__c){
                                    for(ContentVersion CVTDS:listOfContentVersion){
                                        Data = CVTDS.VersionData;
                                        AttachmentName = CVTDS.Title;
                                        filetype = CVTDS.FileType; 
                                    }
                                    String Subject = emailTemplate.Subject;
                                    String htmlbody = emailTemplate.HtmlValue;
                                    htmlbody = htmlbody.replace('{!Name}',Name);
                                    htmlbody = htmlbody.replace('{!Booking}',BookingNumber);
                                    String plainBody = emailTemplate.Body;
                                    plainbody = plainbody.replace('{!Name}',Name);
                                    plainbody = plainbody.replace('{!Booking}',BookingNumber);
                                    
                                    List<String> emailList=new List<String>();
                                    emailList.add(Email);
                                    system.debug('emilID>>'+emailList);
                                    SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,Subject,htmlbody,plainbody,emailList,null,true,bookingID,Data,AttachmentName,null);
                                }
                            }
                        }
                        
            }
        }
        
    }
}
    }
    }