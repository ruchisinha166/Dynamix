public class OpportunityTriggerHandler {
    Public Static Boolean channelPartnerFlag = false;
    Public Static Boolean updateChannelPartnerFlag = false;
    Public Static Void countOpportunityAndAddOnTaskTarget(List<Opportunity> OpportunityList)
    {
        Set<Id> ownerId = New Set<Id>();
        for(Opportunity thisOpportunity :OpportunityList)
        {
            if(thisOpportunity.Date_of_Site_Visit__c != null)
            { 
                ownerId.add(thisOpportunity.OwnerId);
            }
        }
        system.debug('ownerId----'+ownerId);
        if(!ownerId.isEmpty()){
            List<Task_Target__c> taskTargetList = [SELECT Id, Name, user__c, Month__c,Type__c,
                                                   Year__c, Number_of_Targets_Achievement__c,Project__c,
                                                   Number_of_Connected_Call__c, No_of_Walk_ins__c, No_of_Follow_Ups__c
                                                   FROM Task_Target__c
                                                   WHERE user__c IN :ownerId 
                                                   AND Type__c = :'Unique-Revisits'];
            
            system.debug('taskTargetList----'+taskTargetList);
            if(!taskTargetList.isEmpty()){
                system.debug('taskTargetList----'+taskTargetList);
                
                Map<String, Task_Target__c> updateOpportunityTarget = New Map<String, Task_Target__c>();
                Map<String, Task_Target__c> mapOfUserToGetOpportunityTargetId = New Map<String, Task_Target__c>();
                Map<String, Integer> mapUserForCountOpportunity = New Map<String, Integer>();
                List<Opportunity> updateOpportunityList = New List<Opportunity>();
                for(Task_Target__c taskTarget : taskTargetList)
                {
                    string Key = taskTarget.Month__c+'-'+taskTarget.Year__c+'-'+String.valueOf(taskTarget.Project__c)+'-'+String.valueOf(taskTarget.User__c);
                    system.debug('Key----'+Key);
                    mapOfUserToGetOpportunityTargetId.put(Key,taskTarget);
                    if(taskTarget.Number_of_Targets_Achievement__c == null)
                    {
                        mapUserForCountOpportunity.put(Key,0);
                    }
                    else
                    {
                        mapUserForCountOpportunity.put(Key,Integer.valueof(taskTarget.Number_of_Targets_Achievement__c));
                    }
                    system.debug('mapUserForCountOpportunity----'+mapUserForCountOpportunity);
                }
                
                for(Opportunity thisOpportunity :OpportunityList)
                {
                    if(thisOpportunity.Date_of_Site_Visit__c != null){
                        Integer yr = thisOpportunity.Date_of_Site_Visit__c.year();
                        System.debug('Year is' + yr);
                        Datetime dateTimeValue = Datetime.newInstance(thisOpportunity.Date_of_Site_Visit__c.year(), thisOpportunity.Date_of_Site_Visit__c.month(), thisOpportunity.Date_of_Site_Visit__c.day());
                        String month = dateTimeValue.format('MMMM');
                        
                        //string month = Datetime.valueof(thisOpportunity.Date_of_Site_Visit__c).format('MMMM');
                        System.debug('Month is' + month);
                        string Key = month+'-'+String.valueOf(yr)+'-'+String.valueOf(thisOpportunity.Project__c)+'-'+String.valueOf(thisOpportunity.OwnerId);
                        system.debug('Key----'+Key);
                        if(mapUserForCountOpportunity.containsKey(Key) && thisOpportunity.Task_Target__c == null)
                        {
                            Opportunity updateOpportunity = New Opportunity();
                            mapUserForCountOpportunity.put(Key, mapUserForCountOpportunity.get(Key)+1);
                            system.debug('mapUserForCountOpportunity----'+mapUserForCountOpportunity);
                            Task_Target__c taskTarget = New Task_Target__c();
                            taskTarget.id = mapOfUserToGetOpportunityTargetId.get(Key).id;
                            taskTarget.Number_of_Targets_Achievement__c = mapUserForCountOpportunity.get(Key);
                            updateOpportunityTarget.put(taskTarget.id,taskTarget);
                            system.debug('mapOfUserToGetOpportunityTargetId----'+mapOfUserToGetOpportunityTargetId.get(Key).id);
                            updateOpportunity.Task_Target__c = mapOfUserToGetOpportunityTargetId.get(Key).id;
                            updateOpportunity.id = thisOpportunity.id;
                            updateOpportunityList.add(updateOpportunity);
                        }
                    }
                }
                
                if(!updateOpportunityTarget.values().IsEmpty())
                {
                    update updateOpportunityTarget.values();
                }
                if(!updateOpportunityList.IsEmpty())
                {
                    update updateOpportunityList;
                }
            }
        }
    }
    public static void makeCommentMandatory(List<Opportunity> opportunityList, Map<Id, Opportunity> oldOpportunityMap) {
        Map<Id,Opportunity> opportunityIdMap = new Map<Id ,Opportunity>();
        system.debug('hii im here');
        for (Opportunity opp : opportunityList) {
            if ((opp.Approval_Status__c == 'Approved' || opp.Approval_Status__c == 'Rejected') && 
                opp.Approval_Status__c != oldOpportunityMap.get(opp.Id).Approval_Status__c) {
                    opportunityIdMap.put(opp.Id,opp);
                }
        }
        
        if (!opportunityIdMap.keyset().isEmpty()) {
            Map<Id,ProcessInstance> piList = new Map<Id,ProcessInstance>([
                SELECT Id, TargetObjectId
                FROM ProcessInstance
                WHERE TargetObjectId IN :opportunityIdMap.keySet() 
                order by CreatedDate 
                DESC LIMIT 1
            ]);
            
            Map<Id,ProcessInstanceStep> processInstanceStepMap = new Map<Id,ProcessInstanceStep>([
                SELECT ID, StepStatus,ProcessInstanceId,comments
                FROM ProcessInstanceStep
                WHERE ProcessInstanceId =: piList.keySet()
                AND (StepStatus =: 'Approved' OR StepStatus =: 'Rejected')
            ]);
            system.debug('processInstanceStepMap--'+processInstanceStepMap);
            for(Id process:processInstanceStepMap.keySet()){
                if(processInstanceStepMap.get(process).comments == Null){
                    opportunityIdMap.get(piList.get(processInstanceStepMap.get(process).ProcessInstanceId).TargetObjectId).addError('Please Add Comments');
                }
            }
        }
    }
    Public Static Void populatePhoneOnOpportunity(List<Opportunity> OpportunityList)
    {
        set<String> accountId = New Set<String>();
        for (Opportunity opp : opportunityList) {
            if((opp.Phone__c == null || opp.Phone__c == '') && opp.AccountId != null)
            {
                accountId.add(opp.AccountId);
            }
        }
        List<Account> accountList = [SELECT id FROM Account WHERE ID IN: accountId];
        
    }
    
    public static void populateCloseDate(List<Opportunity> OpportunityList)
    {
        for(Opportunity Opportunity : opportunityList){
            if(Opportunity.closeDate == null)
            {system.debug('hello');
             Opportunity.closeDate =system.today().addMonths(12);
            }
        }
    }
    
    Public static void updateChannelPartner(List<Opportunity> opportunityList ,Map<Id, Opportunity> oldOpportunityMap ){
        
        //list to update check walk In
        Set<Id> OppProjectIds = new Set<Id>();
        Set<Id> oppChannelPartnerIds = new Set<Id>();
        for (Opportunity opp : opportunityList) {
            if(opp.Channel_Partner__c != null && opp.Project__c !=null)
            {
                oppChannelPartnerIds.add(opp.Channel_Partner__c);
                OppProjectIds.add(opp.Project__c);
            }
            
        }
        
        
        if(!oppChannelPartnerIds.isEmpty() && !OppProjectIds.isEmpty())
        {
            updateChannelPartnerProjectWalkIN(oppChannelPartnerIds , OppProjectIds );
        }
        
        
        if(oldOpportunityMap != null){
            set<id> oldmapProjectIds  = new set<id>();
            set<id> oldmapChannelPartnerIds = new set<id>();
            Map<Id, List<Opportunity>> channelPartnerProjectToOpportunityMap = new Map<Id, List<Opportunity>>();
            Map<String, Id> cppMap = new Map<String, Id>();
            for(opportunity opp : opportunityList){
                if(oldOpportunityMap.get(opp.id).channel_partner__c != null && oldOpportunityMap.get(opp.id).project__c != null && (oldOpportunityMap.get(opp.id).channel_partner__c != opp.Channel_Partner__c || oldOpportunityMap.get(opp.id).project__c != opp.project__c)){
                    oldmapProjectIds.add(oldOpportunityMap.get(opp.id).project__c);
                    oldmapChannelPartnerIds.add(oldOpportunityMap.get(opp.id).channel_partner__c);
                }
            }
            if(oldmapChannelPartnerIds != null  && oldmapProjectIds != null )
                updateChannelPartnerProjectWalkIN(oldmapChannelPartnerIds , oldmapProjectIds );
        }
        
    }
    
    public static void updateChannelPartnerProjectWalkIN( set<id> oppChannelPartnerIds ,set<id> OppProjectIds ){
        
        if(oppChannelPartnerIds != null  && OppProjectIds != null ){
            list<opportunity> opportunityList2 = [Select id, project__c , channel_partner__c From opportunity Where Channel_Partner__c IN :oppChannelPartnerIds AND Project__c IN :OppProjectIds ];
            List<Channel_Partner_Project__c> channelPartnerProjectList = [SELECT Id, Channel_Partner__c, Project__c, Walk_IN_s__c FROM Channel_Partner_Project__c WHERE Channel_Partner__c IN :oppChannelPartnerIds AND Project__c IN :OppProjectIds];
            Map<Id, List<Opportunity>> channelPartnerProjectToOpportunityMap = new Map<Id, List<Opportunity>>();
            Map<String, Id> cppMap = new Map<String, Id>();
            if(!channelPartnerProjectList.isEmpty())
                for (Channel_Partner_Project__c cpp :channelPartnerProjectList) {
                    String key = cpp.Channel_Partner__c + '-' + cpp.Project__c;
                    cppMap.put(key, cpp.Id);
                }
            
            if(!cppMap.values().isEmpty())
                for (Id cppId : cppMap.values()) {
                    channelPartnerProjectToOpportunityMap.put(cppId, new List<Opportunity>());
                }
            if(!opportunityList2.isEmpty())
                for (Opportunity opp : opportunityList2 ) {
                    String key = opp.Channel_Partner__c + '-' + opp.Project__c;
                    if (cppMap.containsKey(key)) {
                        Id cppId = cppMap.get(key);
                        channelPartnerProjectToOpportunityMap.get(cppId).add(opp);
                    }
                }
            
            for (Channel_Partner_Project__c cpp : channelPartnerProjectList) {
                //  system.debug('this is the value 1 '+channelPartnerProjectToOpportunityMap.get(cpp.id).size());
                if(channelPartnerProjectToOpportunityMap.containsKey(cpp.id) && channelPartnerProjectToOpportunityMap.get(cpp.id) != null )
                    cpp.Walk_IN_s__c = channelPartnerProjectToOpportunityMap.get(cpp.id).size();
            }
            
            if(!channelPartnerProjectList.isEmpty())
                update channelPartnerProjectList;
        }
    }
    public static void changeCheckWalkInTrue(Map<Id, Opportunity> newOpportunityMap){
        list<Opportunity> oppList = [select id ,Check_Walk_In__c from Opportunity Where id IN: newOpportunityMap.keyset()];
        if(!oppList.isEmpty())
            for(Opportunity opp : oppList){
                opp.Check_Walk_In__c = True;
            }
        
        if(!oppList.isEmpty())
            update oppList;
    }
    
    Public static Void channelPartnerProject(List<opportunity> opportunityList)
    {
        set<Id> projectIdSet = New set<Id>();
        Set<Id> channelPartnerIdSet  = New set<Id>();
        List<Channel_Partner_Project__c> insertCPPList = New List<Channel_Partner_Project__c>();
        for(opportunity thisOpportunity: opportunityList)
        {
            if(thisOpportunity.Channel_Partner__c != null)
            {
                channelPartnerIdSet.add(thisOpportunity.Channel_Partner__c);
            }
            if(thisOpportunity.project__c != null )
            {
                projectIdSet.add(thisOpportunity.project__c);
            }
            
        }
        List<Channel_Partner_Project__c> cPPList = [SELECT ID, Channel_Partner__c, Project__c,Project__r.Site_Head__r.email 
                                                    FROM Channel_Partner_Project__c 
                                                    WHERE Channel_Partner__c IN: channelPartnerIdSet AND Project__c IN: projectIdSet];
        Map<String,Channel_Partner_Project__c> cppMap  = New Map<String,Channel_Partner_Project__c>();
        for(Channel_Partner_Project__c Cpp:cPPList)
        {
            String Key = Cpp.Channel_Partner__c+'-'+Cpp.Project__c;
            cppMap.put(Key,Cpp);
        }
        for(opportunity thisOpportunity: opportunityList)
        {
            if(thisOpportunity.project__c != null  && thisOpportunity.Channel_Partner__c != null)
            {
                String Key = thisOpportunity.Channel_Partner__c+'-'+thisOpportunity.Project__c;
                if(!cppMap.containsKey(Key))
                {
                    Channel_Partner_Project__c ChannelPartner = New Channel_Partner_Project__c();
                    ChannelPartner.Channel_Partner__c =  thisOpportunity.Channel_Partner__c;
                    ChannelPartner.Project__c = thisOpportunity.Project__c;
                    insertCPPList.add(ChannelPartner);
                }
            }
            
        }
        if(!insertCPPList.isEmpty())
        {
            insert insertCPPList;
        }
    }
    Public static void eoiCaOpportunity(List<Opportunity> opportunityList)
    {
        for(Opportunity thisOpportunity:opportunityList)
        { System.debug('thisOpportunity.EOI_CA__c '+thisOpportunity.EOI_CA__c );
            if(thisOpportunity.EOI_CA__c == 'EOI' || thisOpportunity.EOI_CA__c == 'CA')
            {
                if(thisOpportunity.Transfer_Opportunity__c != true)
                {
                    thisOpportunity.EOI_CA_stage__c ='';
                    thisOpportunity.EOI_CA_Number__c ='';
                    thisOpportunity.EOI_CA_Form_Submission_OTP__c ='';
                    thisOpportunity.EOI_CA_Form_Submission_Date_and_Time__c	 = null;
                    thisOpportunity.EOI_CA_Form_Sent_Date_Time__c = null;
                    thisOpportunity.EOI_CA__c = '';
                    
                }
                thisOpportunity.EOI_CA_Customer_Code__c = ''; 
                thisOpportunity.Date_of_Site_Visit__c = system.today();
                thisOpportunity.Last_Site_Visit_Date_CIF__c = system.today();
                thisOpportunity.OTP_Submission_Date__c = null;
                thisOpportunity.OTP_Submitted__c = '';
                thisOpportunity.Date_and_Time_of_OTP_Submission__c = null;
                thisOpportunity.No_of_Total_Visits__c= 1;
                thisOpportunity.Digital_Booking_Form_Verified_by_SM_Date__c = null;
                thisOpportunity.Booking_Form_Submitted_by_Customer_Date__c = null;
                thisOpportunity.Booking_Form_Shared_to_Customer_Date__c	= null;
                thisOpportunity.Is_Booking_Form_Submitted_by_Customer__c = false;
                thisOpportunity.Digital_Booking_Form_Verified_by_SM__c = false;
                thisOpportunity.KYC_Completed__c = false;  
                thisOpportunity.StageName = 'Site Visit Done';
            }
            
        }
    }
    Public static void updateEoiCaOpportunityRefundStatus(List<Opportunity> opportunityList)
    {
        for(Opportunity thisOpportunity:opportunityList)
            if(thisOpportunity.EOI_CA__c == 'EOI' || thisOpportunity.EOI_CA__c == 'CA'){ 
                if(thisOpportunity.EOI_CA_stage__c =='Terminated' || thisOpportunity.EOI_CA_stage__c =='Cancelled')
                {
                    thisOpportunity.EOI_Refund_Payment_Status__c = 'Initiated';
                }
                if(thisOpportunity.Refund_Instrument_Number__c != null && thisOpportunity.Refund_Instrument_Number__c != ''
                   && thisOpportunity.Refund_Amount1__c != null && thisOpportunity.Refund_Bank__c != null &&
                   thisOpportunity.Refund_Bank__c != '')
                {
                    thisOpportunity.EOI_Refund_Payment_Status__c = 'Processed';
                    if(thisOpportunity.Refund_Handover_Date__c != null && thisOpportunity.Refund_Date__c != null)
                    {
                        thisOpportunity.EOI_Refund_Payment_Status__c = 'Disbursed';
                    }
                }
            }
    }
}