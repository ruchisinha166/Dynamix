public class LeadTriggerHandler {
    
    public static void convertLeadtoEnquiry(List<Lead> leadList){
        system.debug('leadList---'+leadList);
        set<String> Leadphone = new set<String>();
        set<String> projectName = new set<String>();
        set<String> campaignName = new set<String>();
        set<String> leadId = new set<String>();
        List<Account> insertAccountList = new List<Account>();
        List<Project_Details__mdt> projectDetailList = [SELECT id,name__c, Label FROM Project_Details__mdt];
        Map<String,String> mapOfProjectDetails = New Map<String,String>();
        for(Project_Details__mdt thisProjectDetails : projectDetailList)
        {
            mapOfProjectDetails.put(thisProjectDetails.Label,thisProjectDetails.name__c);
        }
        for(Lead Leadrecord: leadList){
            leadId.add(Leadrecord.id);
            if(Leadrecord.Phone != null){
                String mobilePhone = '';
                if(Leadrecord.Phone.length() >= 10)
                {
                    mobilePhone  = '%'+Leadrecord.Phone.right(10);
                }
                else
                {
                    mobilePhone  = Leadrecord.Phone;
                }
                Leadphone.add(mobilePhone);
            }
              /*  String mobilePhone = '%'+Leadrecord.Phone;
                Leadphone.add(mobilePhone);
            }
            else{
                String mobilePhone = '%'+Leadrecord.MobilePhone;
                Leadphone.add(mobilePhone);
            }*/
            if(Leadrecord.Project_Name__c != null){
                if(mapOfProjectDetails.ContainsKey(Leadrecord.Project_Name__c))
                { String projectNameData = mapOfProjectDetails.get(Leadrecord.Project_Name__c);
                 projectName.add(projectNameData);
                }
            }
            if(Leadrecord.Campaign__c !=null){
                campaignName.add(Leadrecord.Campaign__c);
            }
        }
        system.debug('Leadphone'+Leadphone);
        system.debug('campaignName'+campaignName);
        system.debug('leadId'+leadId);
        List<Account> accountList = new List<Account>();
        List<Campaign> campaignList = [SELECT id, Name, Campaign_Id__c
                                       FROM Campaign 
                                       WHERE Id IN: campaignName];
        system.debug('campaignList'+campaignList);
        List<CampaignMember> campaignMemberList = [SELECT id, LeadId, CampaignId
                                                   FROM CampaignMember 
                                                   WHERE LeadId IN: leadId ];
        system.debug('campaignMemberList'+campaignMemberList);
        Map<string,Account> mapofAccount = new Map<string,Account> ();
        Map<string,Campaign> mapofCampaign = new Map<string,Campaign> ();
        Map<string,CampaignMember> mapofCampaignMember = new Map<string,CampaignMember> ();
        accountList = [Select id,name,PersonMobilePhone from Account where PersonMobilePhone Like :Leadphone AND PersonMobilePhone != null];
        system.debug('accountList'+accountList);
        if(!accountList.isEmpty()){
            for(Account accountRecord: accountList){
               // mapofAccount.put(accountRecord.PersonMobilePhone.right(10),accountRecord);
                 if(accountRecord.PersonMobilePhone.length() >= 10)
                {
                    mapofAccount.put(accountRecord.PersonMobilePhone.right(10), accountRecord);
                }
                else
                {
                    mapofAccount.put(accountRecord.PersonMobilePhone, accountRecord);
                }
            }
        }
        System.debug('mapofAccount'+mapofAccount);
        if(!campaignList.isEmpty()){
            for(Campaign campaignRecord: campaignList){
                mapofCampaign.put(campaignRecord.Campaign_Id__c,campaignRecord);
                //mapofCampaignMember.put(campaignMemberRecord.CampaignId,campaignMemberRecord);
            }
        }
        if(!campaignMemberList.isEmpty()){
            for(CampaignMember campaignMemberRecord: campaignMemberList){
                mapofCampaignMember.put(campaignMemberRecord.LeadId,campaignMemberRecord);
                //mapofCampaignMember.put(campaignMemberRecord.CampaignId,campaignMemberRecord);
            }
        }
        for(Lead Leadrecord: leadList){
            String mobilePhone = '';
            if(Leadrecord.Phone.length() >= 10)
            {
                mobilePhone  = Leadrecord.Phone.right(10);
            }
            else
            {
                mobilePhone  = Leadrecord.Phone;
            }
            System.debug('mobilePhone'+mobilePhone);
            if(!mapofAccount.ContainsKey(mobilePhone)){
                 System.debug('mobilePhone-1 '+mobilePhone);
                Account acc = new Account();
                acc.FirstName = Leadrecord.FirstName;
                acc.LastName = Leadrecord.LastName;
                if( Leadrecord.Phone != null){
                    acc.PersonMobilePhone = Leadrecord.Phone;
                }
                else if(Leadrecord.MobilePhone != null && Leadrecord.MobilePhone !='' ){
                    acc.PersonMobilePhone = Leadrecord.MobilePhone;
                }
                if(Leadrecord.Country_Code1__c != '' && Leadrecord.Country_Code1__c != null)
                {
                    acc.Country_Code__c = Leadrecord.Country_Code1__c;
                }
                else
                {
                    acc.Country_Code__c = Leadrecord.Country_Code__c;
                }
                insertAccountList.add(acc);
            }
        }
        If(!insertAccountList.IsEmpty()){
            Insert insertAccountList;
        }
        
        List<Project__c> projectList = new List<Project__c>();
        Map<String,Project__c> mapofProject = new Map<String,Project__c>(); 
        projectList = [Select id,name from Project__c where name In:projectName];
        If(!projectList.IsEmpty()){
            For(Project__c projectRecord : projectList){
                mapofProject.put(projectRecord.Name , projectRecord);
            }
        }
        List<Account> allAccountList = new List<Account>();
        List<Enquiry__c> insertEnquiryList = new List<Enquiry__c>(); 
        
        Map<string,Account> allmapofAccount = new Map<string,Account> ();
        allAccountList = [Select id,name,PersonMobilePhone from Account where PersonMobilePhone Like :Leadphone];
        System.debug('allAccountList'+allAccountList);
        if(!allAccountList.isEmpty()){
            for(Account accountRecord: allAccountList){
                if(accountRecord.PersonMobilePhone.length() >= 10)
                {
                    allmapofAccount.put(accountRecord.PersonMobilePhone.right(10), accountRecord);
                }
                else
                {
                    allmapofAccount.put(accountRecord.PersonMobilePhone, accountRecord);
                }
               // allmapofAccount.put(accountRecord.PersonMobilePhone,accountRecord);
            }
             System.debug('allmapofAccount'+allmapofAccount);
            for(Lead Leadrecord: leadList){
                if(Leadrecord.Phone != null && Leadrecord.Phone !=''){
                    String mobilePhone = '';
                    if(Leadrecord.Phone.length() >= 10)
                    {
                        mobilePhone  = Leadrecord.Phone.right(10);
                    }
                    else
                    {
                        mobilePhone  = Leadrecord.Phone;
                    }
                    system.debug('mobilePhone ----'+mobilePhone);

                    if(allmapofAccount.ContainsKey(mobilePhone)){
                        Enquiry__c enquiry = new Enquiry__c();
                        enquiry.Contact_Person__c = allmapofAccount.get(mobilePhone).id;
                        if(Leadrecord.Country_Code1__c != '' && Leadrecord.Country_Code1__c != null)
                        {
                            enquiry.Country_Code__c = Leadrecord.Country_Code1__c;
                        }else
                        {
                            enquiry.Country_Code__c = Leadrecord.Country_Code__c;
                        }
                        
                        enquiry.Create_Date_and_Time__c = Leadrecord.Date_and_Time_of_Created_Date__c;
                        enquiry.Enquiry_Source__c = Leadrecord.LeadSource__c;
                        enquiry.Enquiry_Sub_Source__c = Leadrecord.Lead_Sub__c;
                        enquiry.UTM_Campaign__c = Leadrecord.UTM_Campaign__c;
                        enquiry.UTM_Medium__c = Leadrecord.UTM_Medium__c;
                        enquiry.UTM_Parameters__c = Leadrecord.UTM_Parameters__c;
                        enquiry.UTM_Source__c = Leadrecord.UTM_Source__c;
                        enquiry.UTM_Content__c = Leadrecord.UTM_Content__c;
                        enquiry.UTM_Term__c = Leadrecord.UTM_Term__c;
                        enquiry.Send_SMS__c	= true;
                        enquiry.Email_ID__c = Leadrecord.Email	;
                        if(Leadrecord.Phone != null){
                            enquiry.Primary_Mobile_Number__c = Leadrecord.Phone;
                            enquiry.Primary_Mobile_Number_Text__c = Leadrecord.Phone;//Leadrecord.Country_code__c.substring(0, 2)  + '******'+ Leadrecord.Phone.substring(6);
                            system.debug('enquiry.Primary_Mobile_Number_Text__c ----'+enquiry.Primary_Mobile_Number_Text__c );
                        }
                        if(Leadrecord.MobilePhone != null){
                            enquiry.Primary_Mobile_Number_Text__c  = Leadrecord.MobilePhone;
                            enquiry.Primary_Mobile_Number__c = Leadrecord.MobilePhone;
                            system.debug('enquiry.Primary_Mobile_Number_Text__c ----'+enquiry.Primary_Mobile_Number_Text__c );
                            //enquiry.Primary_Mobile_Number_Text__c = Leadrecord.Country_code__c.substring(0, 2)  + '******'+ Leadrecord.MobilePhone.substring(6);
                        }
                        system.debug('projectNameData'+Leadrecord.Project_Name__c);
                        if(mapOfProjectDetails.ContainsKey(Leadrecord.Project_Name__c))
                        { String projectNameData = mapOfProjectDetails.get(Leadrecord.Project_Name__c);
                         system.debug('projectNameData'+projectNameData);
                         if(mapofProject.ContainsKey(projectNameData)){
                             system.debug('projectNameData'+projectNameData);
                             enquiry.Project__c = mapofProject.get(projectNameData).id;
                         }
                        }
                        system.debug('Leadrecord.Campaign__c----'+Leadrecord.Campaign__c);
                        if(Leadrecord.Campaign__c != '' && Leadrecord.Campaign__c != null){
                            if(Leadrecord.Campaign__c.length() ==18)
                            {
                                if(mapofCampaign.ContainsKey(Leadrecord.Campaign__c)){
                                    system.debug('Campaign----'+mapofCampaign.get(Leadrecord.Campaign__c).Id);
                                    enquiry.Campaign__c = mapofCampaign.get(Leadrecord.Campaign__c).Id;
                                }
                                else if(mapofCampaignMember.ContainsKey(Leadrecord.id))
                                {
                                    enquiry.Campaign__c = mapofCampaignMember.get(Leadrecord.id).CampaignId;
                                }
                            }
                            else
                            {
                                id campaignId = Leadrecord.Campaign__c;
                                if(mapofCampaign.ContainsKey(campaignId)){
                                    system.debug('Campaign----'+mapofCampaign.get(campaignId).Id);
                                    enquiry.Campaign__c = mapofCampaign.get(campaignId).Id;
                                }
                                else if(mapofCampaignMember.ContainsKey(Leadrecord.id))
                                {
                                    enquiry.Campaign__c = mapofCampaignMember.get(Leadrecord.id).CampaignId;
                                }
                                
                            }
                        }
                        
                        if( Leadrecord.Date_and_Time_of_Created_Date__c != null)
                        {
                            enquiry.Create_Date_and_Time__c	 = Leadrecord.Date_and_Time_of_Created_Date__c	;
                            
                        }
                        else
                        {
                            enquiry.Create_Date_and_Time__c = system.now();
                        }
                        system.debug('Project_Name__c ----'+enquiry.Project_Name__c );
                        enquiry.Project_Name__c = Leadrecord.Project_Name__c;
                        enquiry.Stage__c = 'New Enquiry';
                        insertEnquiryList.add(enquiry);
                    }
                }
            }
            If(!insertEnquiryList.IsEmpty()){
                insert insertEnquiryList;
            }
            
            
        }
    }
}