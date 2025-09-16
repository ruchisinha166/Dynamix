public class EnquiryTriggerHandler {
    /*
*Mahima Added
* Added Enquiry_Source__c
*/ 
    public static void main(List<Enquiry__c> enqList){
        Set<Id> accountId = New Set<Id>();
        Set<string> phoneNumber = New Set<string>();
        Set<string> enquirySource = New Set<string>();
        Set<Id> campaignId = New Set<Id>();
        for(Enquiry__c thisEnq:enqList){
            system.debug('thisEnq.Primary_Mobile_Number_Text__c----'+thisEnq.Primary_Mobile_Number_Text__c);
            if(thisEnq.Primary_Mobile_Number_Text__c != null && thisEnq.Enquiry_Source__c != null )
            {
                integer phoneDigit = thisEnq.Primary_Mobile_Number_Text__c.length();
                system.debug('phoneDigit'+phoneDigit);
                if(phoneDigit >10){
                    Pattern pattern = Pattern.compile('^\\+[0-9]+$');
                    Matcher matcher = pattern.matcher(thisEnq.Primary_Mobile_Number_Text__c);
                    Boolean CheckValue=  thisEnq.Primary_Mobile_Number_Text__c.isNumericSpace();
                    if(CheckValue == True)
                    {
                        
                        thisEnq.Primary_Mobile_Number__c = thisEnq.Primary_Mobile_Number_Text__c;
                        //       thisEnq.Primary_Mobile_Number_Text__c = thisEnq.Primary_Mobile_Number_Text__c.substring(0, 2)  + '******'+ thisEnq.Primary_Mobile_Number_Text__c.substring(6);
                        try{
                            if(phoneDigit == 10){
                                System.debug('thisEnq.Primary_Mobile_Number_Text__c------------->'+thisEnq.Primary_Mobile_Number_Text__c);
                                thisEnq.Primary_Mobile_Number_Text__c = thisEnq.Country_code__c.substring(0, 2)  + '******'+ thisEnq.Primary_Mobile_Number_Text__c.substring(6);
                                
                            }
                            else if(phoneDigit > 10)
                            {
                                thisEnq.Primary_Mobile_Number_Text__c = thisEnq.Primary_Mobile_Number_Text__c.substring(0, 2)  + '******'+ thisEnq.Primary_Mobile_Number_Text__c.substring(9);
                                
                            }
                            
                        }
                        catch(Exception ex)
                        {
                            system.debug('Error---'+ex.getmessage());
                        }
                    }
                    else if(matcher.matches() == true)
                    {
                        try{
                            System.debug('thisEnq.Primary_Mobile_Number_Text__c------------------>'+thisEnq.Primary_Mobile_Number_Text__c);
                            thisEnq.Primary_Mobile_Number_Text__c = thisEnq.Primary_Mobile_Number_Text__c.substring(0, 2)  + '******'+ thisEnq.Primary_Mobile_Number_Text__c.substring(9);
                        }
                        catch(Exception ex)
                        {
                            system.debug('Error---'+ex.getmessage());
                        }
                        
                    }
                    else
                    {
                        
                        thisEnq.addError('Primary Mobile Number only contains digits.');
                        
                    }
                }
                else
                {
                    
                    // thisEnq.addError('Primary Mobile Number should be of 10-digits.');
                }
            }
            
            system.debug('thisEnq.Primary_Mobile_Number__c----'+thisEnq.Primary_Mobile_Number__c );
            accountId.add(thisEnq.Contact_Person__c);
            phoneNumber.add(thisEnq.Primary_Mobile_Number__c);
            enquirySource.add(thisEnq.Enquiry_Source__c);
        }
        
        List<Enquiry__c> allEnqList = [SELECT Id, Project__c, Primary_Mobile_Number__c, Campaign__c,
                                       Enquiry_Source__c, Stage__c,Contact_Person__c 
                                       FROM Enquiry__c WHERE Id != :enqList AND Stage__c != 'Lost'
                                       AND (Contact_Person__c IN :accountId 
                                            OR Primary_Mobile_Number__c IN :phoneNumber)];
        system.debug('allEnqList'+allEnqList);
        Map<String,Enquiry__c> enqMap = new Map<String,Enquiry__c>();
        Map<String,Enquiry__c> enqDuplicateMap = new Map<String,Enquiry__c>();
        
        for(Enquiry__c thisEnq:allEnqList){
            if(!String.isblank(thisEnq.Primary_Mobile_Number__c) && !String.isBlank(thisEnq.Project__c)
               && !String.isBlank(thisEnq.Enquiry_Source__c)) {
                   string Key = thisEnq.Primary_Mobile_Number__c+'-'+thisEnq.Project__c+'-'+thisEnq.Enquiry_Source__c+'-'+String.valueOf(thisEnq.Campaign__c);
                   system.debug('Key 1'+Key);
                   enqMap.put(Key,thisEnq);
                   enqDuplicateMap.put(thisEnq.Primary_Mobile_Number__c,thisEnq);
               }   
            if(!String.isBlank(thisEnq.Project__c) && thisEnq.Contact_Person__c != null
               && !String.isBlank(thisEnq.Enquiry_Source__c)) {
                   string Key = String.valueOf(thisEnq.Contact_Person__c)+'-'+thisEnq.Project__c+'-'+thisEnq.Enquiry_Source__c+'-'+String.valueOf(thisEnq.Campaign__c);
                   system.debug('Key 2'+Key);
                   enqMap.put(Key,thisEnq);
                   enqDuplicateMap.put(thisEnq.Contact_Person__c,thisEnq);
               }   
        }
        if(!enqMap.keyset().isEmpty()){
            for(Enquiry__c enq:enqList){
                String secondKey = String.valueOf(enq.Contact_Person__c)+'-'+enq.Project__c+'-'+enq.Enquiry_Source__c+'-'+String.valueOf(enq.Campaign__c);
                string firstKey= enq.Primary_Mobile_Number__c+'-'+enq.Project__c+'-'+enq.Enquiry_Source__c+'-'+String.valueOf(enq.Campaign__c);
                system.debug('secondKey'+secondKey);
                system.debug('firstKey'+firstKey);
            }    
        }
        if(!enqDuplicateMap.keyset().isEmpty()){
            for(Enquiry__c enq:enqList){
                if(enqDuplicateMap.containsKey(enq.Contact_Person__c)){
                    // enq.Stage__c ='Duplicate';
                }
                if(enqDuplicateMap.containsKey(enq.Primary_Mobile_Number__c)){
                    //   enq.Stage__c ='Duplicate';
                }
            }
        }
        
    }
    public static void main2(List<Enquiry__c> enqList){
        for(Enquiry__c enq:enqList){
            if(enq.Enquiry_Qualification_Tags__c == 'Qualified' && (
                (enq.Budget__c == 'N/A' || string.isBlank(enq.Budget__c))&&
                enq.Location__c == null &&
                // (enq.Location__c == 'N/A' || string.isBlank(enq.Location__c))&&
                (enq.Configuration__c == 'N/A' || string.isBlank(enq.Configuration__c))&&
                (enq.Construction_Status__c == 'N/A' || string.isBlank(enq.Construction_Status__c)))){
                    enq.addError('Before marking this Enquiry as Qualified, You need to refer to the Qualification Details Section and populate the fields mentioned in it.');
                }
        }
    }
    
    
    public static void main(){
        
        List<Task> taskList = new List<Task>();
        
    }
    
    // Added by Nachiketa Khera - 31/05/2023
    public static void UpdateTotalChildRecords(List<Enquiry__c> enqList) {
        // Get the parent object's field API name and child object's relationship API name
        String totalEnquiries = 'Total_Enquiries__c';
        String totalQualifiedEnquiries = 'Total_Qualified_Enquiries__c';
        String totalWalkIns = 'Total_Walk_ins__c';
        
        // Collect the parent object IDs related to the child objects
        Set<Id> parentIds = new Set<Id>();
        for (Enquiry__c child : enqList) {
            if(child.Campaign__c != null)
            {
                parentIds.add(child.Campaign__c);   
            }
            
        }
        Integer counter = 0;
        Integer counter1 = 0;
        if(!parentIds.isEmpty()){
            // Loop through the parent objects and update the total child records count
            List<Campaign> parentsToUpdate = new List<Campaign>();
            List<Enquiry__c> enquiryList = [SELECT Id, Enquiry_Qualification_Tags__c, Stage__c, Campaign__c  
                                            FROM Enquiry__c 
                                            WHERE Campaign__c IN: parentIds];
            Map<Id,campaign> updateCampaignMap = new Map<Id,campaign>();
            Map<Id,Integer> updateQualifiedEnquiryMap = new Map<Id,Integer>();
            Map<Id,Integer> updateSiteEnquiryMap = new Map<Id,Integer>();
            Map<Id,Integer> updateTotalEnquiryMap = new Map<Id,Integer>();
            
            for(Enquiry__c thisEnquiry:enquiryList )
            {
                if(thisEnquiry.Stage__c =='Qualified')
                {
                    if(updateQualifiedEnquiryMap.containsKey(thisEnquiry.Campaign__c))
                    {
                        updateQualifiedEnquiryMap.put(thisEnquiry.Campaign__c,updateQualifiedEnquiryMap.get(thisEnquiry.Campaign__c)+1);   
                    }
                    else
                    {
                        updateQualifiedEnquiryMap.put(thisEnquiry.Campaign__c,1);
                    }
                }
                if(thisEnquiry.Stage__c =='Site Visit Done')
                {
                    if(updateSiteEnquiryMap.containsKey(thisEnquiry.Campaign__c))
                    {
                        updateSiteEnquiryMap.put(thisEnquiry.Campaign__c,updateSiteEnquiryMap.get(thisEnquiry.Campaign__c)+1);   
                    }
                    else
                    {
                        updateSiteEnquiryMap.put(thisEnquiry.Campaign__c,1);
                    }
                }
                if(updateTotalEnquiryMap.containsKey(thisEnquiry.Campaign__c))
                {
                    updateTotalEnquiryMap.put(thisEnquiry.Campaign__c,updateTotalEnquiryMap.get(thisEnquiry.Campaign__c)+1);   
                }
                else
                {
                    updateTotalEnquiryMap.put(thisEnquiry.Campaign__c,1);
                }
            }
            List<Campaign> campaignList =[SELECT Id,Total_Enquiries__c,Total_Walk_ins__c,Total_Qualified_Enquiries__c FROM Campaign  WHERE Id IN :parentIds];
            for(Campaign campaign:campaignList)
            {
                if(updateTotalEnquiryMap.containsKey(campaign.id))
                {
                    campaign.Total_Enquiries__c = updateTotalEnquiryMap.get(campaign.id);
                }
                else
                {
                    campaign.Total_Enquiries__c = 0;
                }
                if(updateSiteEnquiryMap.containsKey(campaign.id))
                {
                    campaign.Total_Walk_ins__c = updateSiteEnquiryMap.get(campaign.id);  
                    
                    
                }
                else
                {
                    campaign.Total_Walk_ins__c = 0;
                }
                if(updateQualifiedEnquiryMap.containsKey(campaign.id))
                {
                    campaign.Total_Qualified_Enquiries__c = updateQualifiedEnquiryMap.get(campaign.id);  
                    
                    
                }
                else
                {
                    campaign.Total_Qualified_Enquiries__c = 0;
                }
                updateCampaignMap.put(campaign.id,campaign);
                
            }
            if(!updateCampaignMap.isEmpty())
            {
                update updateCampaignMap.values();
            }
            
            
            /* for (Campaign parent : [SELECT Id, (SELECT Id,Enquiry_Qualification_Tags__c,Stage__c FROM Enquiries__r) FROM Campaign  WHERE Id IN :parentIds]) {
parent.put(totalEnquiries, parent.Enquiries__r.size());
system.debug('parent.Enquiries__r.size --> '+parent.Enquiries__r.size());
system.debug('parent'+parent);
for(Enquiry__c enq : parent.Enquiries__r){
if(enq.Enquiry_Qualification_Tags__c == 'Qualified'){
counter += 1;
}
else if(enq.Stage__c == 'Site Visit Done'){
counter1 += 1;
}
}
parent.put(totalQualifiedEnquiries, counter);
parent.put(totalWalkIns, counter1);
parentsToUpdate.add(parent);
}

// Update the parent objects with the total child records count
if(!updateCampaignMap.isEmpty())
{
update updateCampaignMap.values();
}*/
        }
        
    }
    public static void UpdateTotalChildRecordsOnDelete(List<Enquiry__c> enqList){
        String totalEnquiries = 'Total_Enquiries__c';
        String totalQualifiedEnquiries = 'Total_Qualified_Enquiries__c';
        String totalWalkIns = 'Total_Walk_ins__c';
        List<Enquiry__c> enquiList = [Select Id,Campaign__c from Enquiry__c where Id IN: enqList];
        
        // Collect the parent object IDs related to the child objects
        Set<Id> parentIds = new Set<Id>();
        for (Enquiry__c child : enquiList) {
            parentIds.add(child.Campaign__c);
        }
        Integer counter = 0;
        Integer counter1 = 0;
        // Loop through the parent objects and update the total child records count
        List<Campaign> parentsToUpdate = new List<Campaign>();
        for (Campaign parent : [SELECT Id, (SELECT Id,Enquiry_Qualification_Tags__c,Stage__c FROM Enquiries__r) FROM Campaign  WHERE Id IN :parentIds]) {
            parent.put(totalEnquiries, parent.Enquiries__r.size());
            system.debug('parent.Enquiries__r.size --> '+parent.Enquiries__r.size());
            system.debug('parent'+parent);
            for(Enquiry__c enq : parent.Enquiries__r){
                if(enq.Enquiry_Qualification_Tags__c == 'Qualified'){
                    counter += 1;
                }
                else if(enq.Stage__c == 'Site Visit Done'){
                    counter1 += 1;
                }
            }
            parent.put(totalQualifiedEnquiries, counter);
            parent.put(totalWalkIns, counter1);
            parentsToUpdate.add(parent);
        }
        
        // Update the parent objects with the total child records count
        if(!parentsToUpdate.isEmpty())
        {
            update parentsToUpdate;
        }
    }
    
    //Added By Aanchal
    Public Static Void markEnquiryAsDuplicate(List<Enquiry__c> enquiryList)
    {
        Set<Id> accountId = New Set<Id>();
        Set<string> phoneNumber = New Set<string>();
        Set<string> projectId = New Set<string>();
        Map<String,Enquiry__c> enqDuplicateMap = new Map<String,Enquiry__c>();
        Map<Id,Enquiry__c> updateEnquiryMap = new Map<Id,Enquiry__c>();
        
        for(Enquiry__c thisEnq:enquiryList){
            accountId.add(thisEnq.Contact_Person__c);
            phoneNumber.add(thisEnq.Primary_Mobile_Number__c);
            projectId.add(thisEnq.Project__c);
        }
        List<Enquiry__c> allEnqList = [SELECT Id, Project__c, Primary_Mobile_Number__c, Campaign__c,
                                       Enquiry_Source__c, Stage__c,Contact_Person__c 
                                       FROM Enquiry__c WHERE Id != :enquiryList AND Stage__c != 'Lost'
                                       AND Stage__c != 'Site Visit Done'
                                       AND (Contact_Person__c IN :accountId 
                                            OR Primary_Mobile_Number__c IN :phoneNumber)
                                       AND Project__c IN: projectId ];
        
        if(!allEnqList.isEmpty()){
            for(Enquiry__c thisEnq:allEnqList){
                if(!String.isblank(thisEnq.Primary_Mobile_Number__c) && !String.isBlank(thisEnq.Project__c)
                   && !String.isBlank(thisEnq.Enquiry_Source__c)) {
                       String Key = thisEnq.Primary_Mobile_Number__c+String.valueof(thisEnq.Project__c);
                       enqDuplicateMap.put(Key,thisEnq);
                   }   
                if(!String.isBlank(thisEnq.Project__c) && thisEnq.Contact_Person__c != null
                   && !String.isBlank(thisEnq.Enquiry_Source__c)) {
                       String Key = String.valueof(thisEnq.Contact_Person__c)+String.valueof(thisEnq.Project__c);
                       
                       enqDuplicateMap.put(Key,thisEnq);
                   }   
            }
        }
        if(!enqDuplicateMap.keyset().isEmpty()){
            for(Enquiry__c thisEnq:enquiryList){
                String Key1 = thisEnq.Primary_Mobile_Number__c+String.valueof(thisEnq.Project__c);
                if(enqDuplicateMap.containsKey(Key1)){
                    thisEnq.Stage__c = 'Lost';
                    thisEnq.Lost_Reasons__c = 'Duplicate Lead';
                }
                String Key2 = String.valueof(thisEnq.Contact_Person__c)+String.valueof(thisEnq.Project__c);
                if(enqDuplicateMap.containsKey(Key2)){
                    thisEnq.Stage__c ='Lost';
                    thisEnq.Lost_Reasons__c = 'Duplicate Lead';
                }
                updateEnquiryMap.put(thisEnq.id,thisEnq);
            }
        }
        if(!updateEnquiryMap.values().isEmpty())
        {
            //   update updateEnquiryMap.values();
        }
    }
    //Added By Aanchal
    Public Static Void countEnquiryAndAddOnEnquiryTarget(List<Enquiry__c> enquiryList)
    {
        Set<Id> ownerId = New Set<Id>();
        List<Enquiry__c> enquiList = [Select Id,Stage__c, Site_Visit_Done_Date__c,OwnerId,Task_Target__c,Project__c from Enquiry__c Where Id IN: enquiryList];
        
        for(Enquiry__c thisEnquiry :enquiList)
        {
            if(thisEnquiry.Stage__c == 'Site Visit Done' && thisEnquiry.Site_Visit_Done_Date__c != null)
            { 
                ownerId.add(thisEnquiry.OwnerId);
            }
        }
        system.debug('ownerId----'+ownerId);
        if(!ownerId.isEmpty()){
            List<Task_Target__c> taskTargetList = [SELECT Id, Name, user__c, Month__c,Type__c,
                                                   Year__c, Number_of_Targets_Achievement__c,Project__c,
                                                   Number_of_Connected_Call__c, No_of_Walk_ins__c, No_of_Follow_Ups__c
                                                   FROM Task_Target__c
                                                   WHERE user__c IN :ownerId 
                                                   AND Type__c = :'Walk-In'];
            
            system.debug('taskTargetList----'+taskTargetList);
            if(!taskTargetList.isEmpty()){
                system.debug('taskTargetList----'+taskTargetList);
                
                Map<String, Task_Target__c> updateEnquiryTarget = New Map<String, Task_Target__c>();
                Map<String, Task_Target__c> mapOfUserToGetEnquiryTargetId = New Map<String, Task_Target__c>();
                Map<String, Integer> mapUserForCountEnquiry = New Map<String, Integer>();
                List<Enquiry__c> updateEnquiryList = New List<Enquiry__c>();
                for(Task_Target__c taskTarget : taskTargetList)
                {
                    string Key = taskTarget.Month__c+'-'+taskTarget.Year__c+'-'+String.valueOf(taskTarget.Project__c)+'-'+String.valueOf(taskTarget.User__c);
                    system.debug('Key----'+Key);
                    mapOfUserToGetEnquiryTargetId.put(Key,taskTarget);
                    if(taskTarget.Number_of_Targets_Achievement__c == null)
                    {
                        mapUserForCountEnquiry.put(Key,0);
                    }
                    else
                    {
                        mapUserForCountEnquiry.put(Key,Integer.valueof(taskTarget.Number_of_Targets_Achievement__c));
                    }
                    system.debug('mapUserForCountEnquiry----'+mapUserForCountEnquiry);
                }
                
                for(Enquiry__c thisEnquiry :enquiList)
                {
                    if(thisEnquiry.Stage__c == 'Site Visit Done' && thisEnquiry.Site_Visit_Done_Date__c != null){
                        Integer yr = thisEnquiry.Site_Visit_Done_Date__c.year();
                        System.debug('Year is' + yr);
                        string month = thisEnquiry.Site_Visit_Done_Date__c.format('MMMM');
                        System.debug('Month is' + month);
                        string Key = month+'-'+String.valueOf(yr)+'-'+String.valueOf(thisEnquiry.Project__c)+'-'+String.valueOf(thisEnquiry.OwnerId);
                        system.debug('Key----'+Key);
                        if(mapUserForCountEnquiry.containsKey(Key) && thisEnquiry.Task_Target__c == null)
                        {
                            Enquiry__c updateEnquiry = New Enquiry__c();
                            mapUserForCountEnquiry.put(Key, mapUserForCountEnquiry.get(Key)+1);
                            system.debug('mapUserForCountEnquiry----'+mapUserForCountEnquiry);
                            Task_Target__c taskTarget = New Task_Target__c();
                            taskTarget.id = mapOfUserToGetEnquiryTargetId.get(Key).id;
                            taskTarget.Number_of_Targets_Achievement__c = mapUserForCountEnquiry.get(Key);
                            updateEnquiryTarget.put(taskTarget.id,taskTarget);
                            system.debug('mapOfUserToGetEnquiryTargetId----'+mapOfUserToGetEnquiryTargetId.get(Key).id);
                            updateEnquiry.Task_Target__c = mapOfUserToGetEnquiryTargetId.get(Key).id;
                            updateEnquiry.id = thisEnquiry.id;
                            updateEnquiryList.add(updateEnquiry);
                        }
                    }
                }
                
                if(!updateEnquiryTarget.values().IsEmpty())
                {
                    update updateEnquiryTarget.values();
                }
                if(!updateEnquiryList.IsEmpty())
                {
                    update updateEnquiryList;
                }
            }
        }
    }
    
    public static void throwValidation(List<Enquiry__c> enquiryList, Map<Id, Enquiry__c> oldMapofEnquiry)
    {
        for(Enquiry__c thisEnquiry: enquiryList){
            //  if(oldMapofEnquiry.get(thisEnquiry.id).Stage__c != thisEnquiry.Stage__c ){
            System.debug('thisEnquiry.Stage__c ---'+thisEnquiry.Stage__c );
            System.debug('oldMapofEnquiry.get(thisEnquiry.id).Stage__c'+oldMapofEnquiry.get(thisEnquiry.id).Stage__c);
            System.debug('oldMapofEnquiry.get(thisEnquiry.id).Duplicate_Lead__c'+oldMapofEnquiry.get(thisEnquiry.id).Duplicate_Lead__c);
            System.debug('thisEnquiry.Duplicate_Lead__c'+thisEnquiry.Duplicate_Lead__c);
            if(oldMapofEnquiry.get(thisEnquiry.id).Stage__c == 'Interested' && thisEnquiry.Stage__c != 'Site Visit Scheduled'
               &&  thisEnquiry.Stage__c != 'Lost'  && thisEnquiry.Stage__c != 'Site Visit Done'
               && oldMapofEnquiry.get(thisEnquiry.id).Stage__c != thisEnquiry.Stage__c) 
            {
                //  thisEnquiry.Stage__c= oldMapofEnquiry.get(thisEnquiry.id).Stage__c;
                thisEnquiry.addError('Enquiry Stage either can move to Site Visit Scheduled or Lost.');
            }
            if(oldMapofEnquiry.get(thisEnquiry.id).Stage__c == 'Site Visit Scheduled' && oldMapofEnquiry.get(thisEnquiry.id).Stage__c != thisEnquiry.Stage__c && thisEnquiry.Stage__c != 'Site Visit Done' &&  thisEnquiry.Stage__c != 'Lost') 
            {
                //  thisEnquiry.Stage__c= oldMapofEnquiry.get(thisEnquiry.id).Stage__c;
                thisEnquiry.addError('Enquiry Stage either can move to Site Visit Done or Lost.');
            }
            if(oldMapofEnquiry.get(thisEnquiry.id).Stage__c == 'Lost' && thisEnquiry.Stage__c != 'New' && thisEnquiry.Duplicate_Lead_Approval_Status__c != 'Approved'
               //oldMapofEnquiry.get(thisEnquiry.id).Duplicate_Lead__c == true 
               && thisEnquiry.Duplicate_Lead__c == false)
                // && oldMapofEnquiry.get(thisEnquiry.id).Duplicate_Lead__c != thisEnquiry.Duplicate_Lead__c)
            {
                // thisEnquiry.addError('You cannot update once Enquiry get Lost.');
            }
            //}
        }
    }
    public static void createAccount(List<Enquiry__c> enquiryList)
    {
        
        // List<Enquiry__c> enquList = [Select Id,Contact_Person__c,Enquiry_Source__c,Stage__c,Primary_Mobile_Number__c,Campaign__c from Enquiry__c where Id IN: enquiryList];
        system.debug('hello');
        set<String> accountIdSet = New set<String>();
        set<String> projectIdSet = New set<String>();
        set<String> SourceSet = New set<String>();
        set<String> phoneNumberSet = New set<String>();
        set<String> virtualPhoneNumber = New set<String>();
        List<Enquiry__c> exotelCallEnquiryList = New  List<Enquiry__c>();
        
        for(Enquiry__c thisEnquiry :enquiryList)
        { 
            system.debug('thisEnquiry.Enquiry_Source__c '+thisEnquiry.Enquiry_Source__c );
            system.debug('thisEnquiry.Primary_Mobile_Number__c '+thisEnquiry.Primary_Mobile_Number__c );
            if(thisEnquiry.Exotel_Call__c  == true)
            {
                if(thisEnquiry.Primary_Mobile_Number__c.length() > = 10)
                {
                    String phoneNumber = '%'+thisEnquiry.Primary_Mobile_Number__c.right(10);
                    phoneNumberSet.add(phoneNumber); 
                }
                else
                {
                     phoneNumberSet.add(thisEnquiry.Primary_Mobile_Number__c); 
                }
                    
                  
                if(thisEnquiry.Campaign__c != null)
                {
                    virtualPhoneNumber.add(thisEnquiry.Campaign__c );   
                }
                system.debug('virtualPhoneNumber'+virtualPhoneNumber);
                exotelCallEnquiryList.add(thisEnquiry);
            }
            else{
                system.debug('thisEnquiry'+thisEnquiry);
                system.debug('thisEnquiry.Primary_Mobile_Number__c'+thisEnquiry.Primary_Mobile_Number__c);
                
                
            }
            
        }
        
        if(!phoneNumberSet.isEmpty()){
            List<Campaign> CampaignList = [SELECT id, Project__c, Source__c, Sub_Source__c,Virtual_Phone_Number__c 
                                           FROM Campaign 
                                           WHERE id IN:virtualPhoneNumber];
            system.debug('CampaignList'+CampaignList);
            Map<String,Campaign> CampaignMap = New Map<String,Campaign>(); 
            for(Campaign thisCampaign :CampaignList)
            {
                CampaignMap.put(thisCampaign.id, thisCampaign);
                SourceSet.add(thisCampaign.Source__c);
                projectIdSet.add(thisCampaign.Project__c);
            }
            system.debug('phoneNumberSet'+phoneNumberSet);
            system.debug('projectIdSet'+projectIdSet);
            List<Account> accountList = [SELECT id, PersonMobilePhone FROM Account WHERE PersonMobilePhone Like :phoneNumberSet
                                        AND PersonMobilePhone != null AND PersonMobilePhone != '' order By CreatedDate ASC];
            system.debug('accountList------------->'+accountList);
            Map<String,Account> accountMap = New Map<String,Account>(); 
            for(Account thisAccount :accountList)
            {
                if(thisAccount.PersonMobilePhone.length() >= 10)
                {
                    accountMap.put(thisAccount.PersonMobilePhone.right(10), thisAccount);
                }
                else
                {
                    accountMap.put(thisAccount.PersonMobilePhone, thisAccount);
                }
                
                accountIdSet.add(thisAccount.id);
            }
            Map<String,Enquiry__c> enqDuplicateMap = new Map<String,Enquiry__c>();
             Map<String,Enquiry__c> enqWithoutProjectMap = new Map<String,Enquiry__c>();
            
            List<Enquiry__c> allEnqList = [SELECT Id, Project__c, Primary_Mobile_Number__c, Campaign__c,
                                           Enquiry_Source__c, Stage__c,Contact_Person__c 
                                           FROM Enquiry__c WHERE Stage__c != 'Lost' AND  Stage__c != 'Site Visit Done'
                                           AND (Contact_Person__c IN :accountIdSet 
                                                OR Primary_Mobile_Number__c Like :phoneNumberSet )
                                          // AND Project__c IN: projectIdSet
                                          ];
            system.debug('allEnqList'+allEnqList);
            if(!allEnqList.isEmpty()){
                for(Enquiry__c thisEnq:allEnqList){
                    String phoneNumber = '';
                    if(thisEnq.Primary_Mobile_Number__c != null && thisEnq.Primary_Mobile_Number__c != '')
                    {
                        if(thisEnq.Primary_Mobile_Number__c.length() >= 10)
                        {
                             phoneNumber = thisEnq.Primary_Mobile_Number__c.right(10);
                           
                        }
                        else
                        {
                             phoneNumber = thisEnq.Primary_Mobile_Number__c; 
                        }
                        
                    }
                    
                    if(!String.isblank(phoneNumber) && !String.isBlank(thisEnq.Project__c)
                       && !String.isBlank(thisEnq.Enquiry_Source__c)) {
                           String Key = phoneNumber+thisEnq.Enquiry_Source__c+String.valueof(thisEnq.Project__c);
                           enqDuplicateMap.put(Key,thisEnq);
                       }   
                    if(!String.isBlank(thisEnq.Project__c) && thisEnq.Contact_Person__c != null
                       && !String.isBlank(thisEnq.Enquiry_Source__c)) {
                           String Key = String.valueof(thisEnq.Contact_Person__c)+thisEnq.Enquiry_Source__c+String.valueof(thisEnq.Project__c);
                           
                           enqDuplicateMap.put(Key,thisEnq);
                       }  
                    
                    enqWithoutProjectMap.put(phoneNumber,thisEnq);
                    if(thisEnq.Campaign__c != null )
                    {
                        String Key = String.valueof(thisEnq.Contact_Person__c)+String.valueof(thisEnq.Campaign__c);
                        enqDuplicateMap.put(Key,thisEnq);
                    }
                }
                
            }
            system.debug('enqDuplicateMap'+enqDuplicateMap);
            List<Account> insertAccountList = New List<Account>();
            for(Enquiry__c thisEnquiry :exotelCallEnquiryList)
            {
                //if(!accountMap.isEmpty()){
                    String phoneNumber = '';
                    if(thisEnquiry.Primary_Mobile_Number__c != null && thisEnquiry.Primary_Mobile_Number__c != '')
                    {
                        if(thisEnquiry.Primary_Mobile_Number__c.length() >= 10)
                        {
                             phoneNumber = thisEnquiry.Primary_Mobile_Number__c.right(10);
                           
                        }
                        else
                        {
                             phoneNumber = thisEnquiry.Primary_Mobile_Number__c; 
                        }
                        
                    }
                if(!accountMap.containskey(phoneNumber))
                {
                    Account account = New Account();
                    account.FirstName = 'Unnamed';
                    account.LastName = 'Lead';
                    system.debug('thisEnquiry.Primary_Mobile_Number__c'+thisEnquiry.Primary_Mobile_Number__c);
                    account.PersonMobilePhone = thisEnquiry.Primary_Mobile_Number__c;
                    insertAccountList.add(account);
                    
                }
                //   }
            }
            if(!insertAccountList.isEmpty())
            {
                insert insertAccountList;
            }
            String Key1;
            String Key2;
            List<Account> allAccountList = [SELECT id, PersonMobilePhone FROM Account WHERE PersonMobilePhone Like :phoneNumberSet ];
            system.debug('allAccountList--------------->'+allAccountList);
            Map<String,Account> allAccountMap = New Map<String,Account>(); 
            for(Account thisAccount :allAccountList)
            {
                
                if(thisAccount.PersonMobilePhone.length() >= 10)
                {
                    allAccountMap.put(thisAccount.PersonMobilePhone.right(10), thisAccount);
                }
                else
                {
                    allAccountMap.put(thisAccount.PersonMobilePhone, thisAccount);
                }
               // allAccountMap.put(thisAccount.PersonMobilePhone, thisAccount);
                system.debug('allAccountMap-------------->'+allAccountMap);
            }
            system.debug('allAccountList'+allAccountList);
            for(Enquiry__c thisEnquiry :exotelCallEnquiryList)
            { 
                String phoneNumber = '';
                if(thisEnquiry.Primary_Mobile_Number__c != null && thisEnquiry.Primary_Mobile_Number__c != '')
                {
                    if(thisEnquiry.Primary_Mobile_Number__c.length() >= 10)
                    {
                        phoneNumber = thisEnquiry.Primary_Mobile_Number__c.right(10);
                        
                    }
                    else
                    {
                        phoneNumber = thisEnquiry.Primary_Mobile_Number__c; 
                    }
                }
                Key2='';
                Key1='';
                
                if(allAccountMap.containskey(phoneNumber))
                {
                    
                    if(CampaignMap.containskey(thisEnquiry.Campaign__c))
                    {
                        thisEnquiry.Campaign_ID__c = CampaignMap.get(thisEnquiry.Campaign__c).id;
                        system.debug('thisEnquiry.Campaign_ID__c------->'+thisEnquiry.Campaign_ID__c);
                        thisEnquiry.Project__c = CampaignMap.get(thisEnquiry.Campaign__c).project__C;
                        system.debug('thisEnquiry.Project__c----------->'+thisEnquiry.Project__c);
                        thisEnquiry.Enquiry_Source__c = CampaignMap.get(thisEnquiry.Campaign__c).Source__c;
                        system.debug('thisEnquiry.Enquiry_Source__c--------->'+thisEnquiry.Enquiry_Source__c);
                        thisEnquiry.Enquiry_Sub_Source__c = CampaignMap.get(thisEnquiry.Campaign__c).Sub_Source__c;
                        system.debug('thisEnquiry.Enquiry_Sub_Source__c-------> '+thisEnquiry.Enquiry_Sub_Source__c );
                        Key1 = phoneNumber+ CampaignMap.get(thisEnquiry.Campaign__c).Source__c+String.valueof(CampaignMap.get(thisEnquiry.Campaign__c).project__C);
                        system.debug('Key1------>'+Key1);
                        Key2 = String.valueof(allAccountMap.get(phoneNumber).id)+ CampaignMap.get(thisEnquiry.Campaign__c).Source__c+String.valueof(CampaignMap.get(thisEnquiry.Campaign__c).project__C);
                        system.debug('Key2----->'+Key2);
                        if(CampaignMap.get(thisEnquiry.Campaign__c).Sub_Source__c != null)
                        {
                            thisEnquiry.Enquiry_Sub_Source__c = CampaignMap.get(thisEnquiry.Campaign__c).Sub_Source__c;
                        }
                        String Key3 = String.valueof(allAccountMap.get(phoneNumber).id)+String.valueof(thisEnquiry.Campaign__c);
                        if(enqDuplicateMap.containsKey(Key3)){
                            system.debug('Key3:---- '+  Key3 );
                            thisEnquiry.addError('Enquiry already exist with this campaign with enquiry Id:'+enqDuplicateMap.get(Key3).id);
                        } 
                    }
                    if(thisEnquiry.Campaign__c == null && thisEnquiry.Campaign__c == '' && thisEnquiry.Project__c == '' &&
                      thisEnquiry.Project__c == null)
                    {
                        if(enqWithoutProjectMap.containsKey(phoneNumber))
                        {
                            thisEnquiry.addError('Enquiry already exist with this campaign with enquiry Id:'+enqWithoutProjectMap.get(phoneNumber).id);
                            
                        }
                    }
                   
                    
                    try{
                        thisEnquiry.Primary_Mobile_Number_Text__c = thisEnquiry.Country_code__c.substring(0, 2)  + '******'+ thisEnquiry.Primary_Mobile_Number__c.substring(6);
                        
                    }
                    catch(Exception ex)
                    {
                        try{
                            thisEnquiry.Primary_Mobile_Number_Text__c = thisEnquiry.Country_code__c.substring(0, 2)  + '******'+ thisEnquiry.Primary_Mobile_Number__c.substring(6);
                            
                        }
                        catch(Exception exs)
                        {
                            system.debug('Error---'+exs.getmessage());
                        }
                    }
                    // thisEnquiry.Primary_Mobile_Number__c = 
                    if(thisEnquiry.Enquiry_Source__c == null || thisEnquiry.Enquiry_Source__c == '')
                    {
                        thisEnquiry.Enquiry_Source__c = 'Exotel Call';
                    }
                    system.debug('Key1'+Key1);
                    if(enqDuplicateMap.containsKey(Key1)){
                        thisEnquiry.Stage__c = 'Lost';
                        system.debug(' Key1 '+  thisEnquiry.Stage__c );
                        
                        thisEnquiry.Lost_Reasons__c = 'Duplicate Lead';
                    }
                    system.debug('Key2'+Key2);
                    if(enqDuplicateMap.containsKey(Key2)){
                        thisEnquiry.Stage__c ='Lost';
                        system.debug(' Key2 '+  thisEnquiry.Stage__c );
                        
                        thisEnquiry.Lost_Reasons__c = 'Duplicate Lead';
                    }
                    system.debug('  thisEnquiry.Stage__c '+  thisEnquiry.Stage__c );
                    // thisEnquiry.Exotel_Call__c =true; 
                    thisEnquiry.Contact_Person__c = allAccountMap.get(phoneNumber).id;                
                }
            }
            
        }
    }
    
}