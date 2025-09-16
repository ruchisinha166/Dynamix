public class GenerateAFSDocuments {
    
    @InvocableMethod(label='Generate Agreement of Sale Documents')
    public static List<String> execute(List<Request> Requests){
        ContentVersion conVer;
        String VFPageName;
        list<ContentDocumentLink> contentDocList = new list<ContentDocumentLink>();
        list<ContentVersion> ContentVersionList =new  list<ContentVersion>();
        String contentId='';
        list<Id> ContentDocId = new list<Id>();
        list<ContentDocumentLink> conDocList = new list<ContentDocumentLink>();
        booking__c bookingobj = [select id, Property_Name__c,Project_Name__r.name,Related_Opportunity__r.Project_No_of_Days__c,Tower_Name__r.Name,Tower_Name__c,Project_Name__c from Booking__c where id=: Requests[0].bookingId];
        
        if(bookingobj != null){
            
            //AFS For Parkwood 
            if(bookingobj.Project_Name__r.Name == System.Label.Parkwoods_project_name){
                
                String pageName = 'ParkwoodsBuildingD5';
                
                if(bookingobj.Related_Opportunity__r.Project_No_of_Days__c == '180 Days'){
                    
                    String vfpage = pageName+bookingobj.Related_Opportunity__r.Project_No_of_Days__c;
                    VFPageName = vfpage.deleteWhitespace();
                    System.debug('Page Name 180 Days--: '+vfpage);
                    system.debug('Remove Spaces-->'+vfpage.deleteWhitespace());
                    
                }else if(bookingobj.Related_Opportunity__r.Project_No_of_Days__c == '30 Days'){
                    
                    String vfpage = pageName+bookingobj.Related_Opportunity__r.Project_No_of_Days__c;
                    VFPageName = vfpage.deleteWhitespace();
                    
                    system.debug('Remove Spaces-->'+vfpage.deleteWhitespace());
                    System.debug('Page Name for 30 Days--: '+vfpage);
                }
                
                
            }
            // For Divum
            else if(bookingobj.Project_Name__r.Name == System.Label.Divum_Project_Name){
                
                String pageName = 'Divum';
                pageName += '180Days';
                
                VFPageName =  pageName.deleteWhitespace();               
                
                
            }
            
            // For Avanya
            /* else if(bookingobj.Project_Name__r.Name == System.Label.Avanya_Project_Name){

String pageName = 'Avanya';

if(bookingobj.Tower_Name__r.Name == 'Tower A'){

String vfpage = pageName+bookingobj.Tower_Name__r.Name;
VFPageName = vfpage.deleteWhitespace();

}
else if(bookingobj.Tower_Name__r.Name == 'Tower B'){

String vfpage = pageName+bookingobj.Tower_Name__r.Name;
VFPageName = vfpage.deleteWhitespace();

}


}*/
            
            else if(bookingobj.Project_Name__r.Name == 'Avanya Tower A' || bookingobj.Project_Name__r.Name =='Avanya Tower C'){                
                String pageName = 'AvanyaTowerA';
                VFPageName=pageName;
            }
            else if(bookingobj.Tower_Name__r.Name ==  'Avanya Tower B'){
                String pageName = 'AvanyaTowerB';    
                VFPageName=pageName;
            }                            
        }
        String url = '/apex/'+VFPageName+'?id='+Requests[0].bookingId;
        PageReference ref = new PageReference(url);
        Blob body;
        
        if(Test.isRunningTest()) { 
            body = blob.valueOf('Unit.Test');
        } else { 
            body = ref.getContent();
        }
        
        
        contentDocList =[select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:Requests[0].bookingId];
        
        if(contentDocList.size()>0)
        {
            for(ContentDocumentLink cd :contentDocList)
            {   
                ContentDocId.add(cd.ContentDocumentId);
            }
            ContentVersionlist =[SELECT ContentDocumentId,VersionData,isMajorVersion,PathOnClient,CreatedDate FROM ContentVersion where PathOnClient ='Agreement of Sale.pdf' and ContentDocumentId IN :ContentDocId];
        }
        
        if(ContentVersionlist.size()>0)
        {
            conVer =new ContentVersion(); 
            conVer.ContentLocation = 'S'; 
            conVer.PathOnClient = 'Agreement of Sale' + '.pdf'; 
            conVer.Title = 'Agreement of Sale'+' - '+bookingobj.Property_Name__c +'.pdf';
            conVer.VersionData = body;
            conVer.SObjectType__c = 'Booking__c';
            conVer.Document_Type__c = 'Agreement Sale';
            conVer.ContentDocumentId=ContentDocId[0];
            // system.debug('test'+conVer);
            insert conVer;
            system.debug('test'+conVer);
            contentId = conVer.ContentDocumentId;
            
        }
        else
        {
            conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; 
            conVer.PathOnClient = 'Agreement of Sale' + '.pdf'; 
            conVer.Title = 'Agreement of Sale'+' - '+bookingobj.Property_Name__c +'.pdf';
            conVer.VersionData = body;
            conVer.SObjectType__c = 'Booking__c';
            conVer.Document_Type__c = 'Agreement Sale';
            conVer.isMajorVersion=false;
            Insert conVer;
            list<ContentVersion> conVerList= [SELECT ContentDocumentId,CreatedDate FROM ContentVersion WHERE Id =:conVer.Id ];
            If(conVerList.size()>0)
            {
                for(ContentVersion con :conVerList)
                {
                    ContentDocumentLink conDocLink = New ContentDocumentLink();
                    conDocLink.LinkedEntityId = Requests[0].bookingId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                    conDocLink.ContentDocumentId = con.ContentDocumentId;  //ContentDocumentId Id from ContentVersion
                    conDocLink.shareType = 'V';
                    conDocList.add(conDocLink);
                }
            }    
            insert conDocList;
            contentId = conVerList[0].ContentDocumentId;
            system.debug('bookingobj.id=='+bookingobj.id);
            system.debug('System.Label.SMSaggrement=='+System.Label.SMSaggrement);
            SendSMS.sendSMSfun(bookingobj.id,System.Label.SMSaggrement);
            SendWhatsappMsg.sendwhsms(System.Label.Whatsapp_Agreement,bookingobj.Id,'');
        }
        
        return new List<String>{contentId};
            }
    
    public class Request {
        @InvocableVariable(label='Booking Id' required=true)
        public id bookingId;
    }
    
}