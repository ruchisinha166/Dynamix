Public without Sharing class SnagListDocVfpController {
    private ApexPages.StandardController standardController;
    public List<Project_Snag__c> projectSnagList  { get; set; }
    public List<Unit_Snag_Response__c> allUnitSnagResponseList{ get; set; }
    public List<Property__c> propertyList  { get; set; }
    Public string ProjectHeader{get;set;}
    Public string ProjectFooter{get;set;}
    public List<String> areaList {get;set;}
    public Map<String, Integer> areaCountMap{get;set;}
    public Map<String, List<rowWrapper>> mapArea {get;set;} 
    public string SnagDetails{get;set;}
    public string SnagType{get;set;}
    public String Error{get;set;}
    public Boolean Task{get;set;}
    Public string CustomerName{get;set;}
    
    Public SnagListDocVfpController(ApexPages.StandardController standardController) {
        mapArea = new Map<String, List<rowWrapper>>();
        areaCountMap = new Map<String, Integer>();
        areaList = new List<String>();
        SnagType = 'Pre-OC';
        Task = false;
        string propertyId = ApexPages.currentPage().getParameters().get('Id');
        SnagType = ApexPages.currentPage().getParameters().get('SnagType');
        propertyList= [SELECT ID, NAME, Project__c, Snag_Status__c, Flat_Type__c, Project__r.Name, Tower__r.Name,
                       Unit_Type__c,Electric_Meter_Number__c,Electric_Meter_Installed__c,
                       Electric_Meter_Reading__c,Sub_Snag_Status__c 
                       FROM PROPERTY__C WHERE id =:propertyId];
        List<Suggested_Property__c> suggestedProperty = [SELECT ID, NAME FROM Suggested_Property__c WHERE UNIT__C =:propertyId];
        if(!suggestedProperty.isEmpty())
        {
            LIST<bOOKING__C> BOOKINGlIST = [SELECT ID, NAME,Primary_Applicant_Name_Formulla__c FROM bOOKING__C where Related_Suggested_Property__c =: suggestedProperty[0].id];
            if(!BOOKINGlIST.isEmpty())
            {
                CustomerName = BOOKINGlIST[0].Primary_Applicant_Name_Formulla__c;
            }
        }
        system.debug('propertyList[0].Snag_Status__c'+propertyList[0].Snag_Status__c);
        if(propertyList[0].Snag_Status__c == ''|| propertyList[0].Snag_Status__c == null || propertyList[0].Snag_Status__c =='Yet to start' || 
           (propertyList[0].Snag_Status__c == 'Internal Snagging' && (propertyList[0].Sub_Snag_Status__c  =='Pre OC-Submitted with snags'	||
                                                                      propertyList[0].Sub_Snag_Status__c =='Snag Initiated'
                                                                      || propertyList[0].Sub_Snag_Status__c ==  'Pre OC-Verified')))
        {
            //SnagType = 'Pre-OC';
        }
        if(propertyList[0].Sub_Snag_Status__c == 'Post OC-Submitted with snags' ||
           propertyList[0].Sub_Snag_Status__c ==  'Post OC-Verified')
        {
           // SnagType = 'Post-OC';
            List<Task> taskList = [SELECT ID, whatId, Subject FROM Task WHERE whatId =: propertyId AND Subject =:'Post - OC FM Unit Inspection Tasks' 
                                   order By CreatedDate Desc LIMIT 1];
            if(!taskList.isEmpty())
            {
                Task = true;
            }
        }
        if(propertyList[0].Snag_Status__c == 'Customer Snagging' ||
           propertyList[0].Snag_Status__c ==  'Customer Unit Inspection Scheduled'
          )
        {
            //SnagType = 'Customer';
            List<Task> taskList = [SELECT ID, whatId, Subject FROM Task WHERE whatId =: propertyId 
                                   AND Subject =:'Deep Cleaning Task' 
                                   AND STATUS = 'Completed'  order By CreatedDate Desc LIMIT 1];
            if(!taskList.isEmpty())
            {
                Task = true;
            }
        }
        allUnitSnagResponseList = [SELECT Id, Name, Property__c, Project_Snag__c ,Project_Snag__r.Questions__c,
                                   Post_OC_Answers__c,Pre_OC_Answers__c,Pre_OC_End_Date__c,Area__c,Pre_OC_Remarks__c,
                                   Post_OC_Remarks__c, Customer_Inspection_Remarks__c,Customer_Inspection_Answers__c
                                   FROM Unit_Snag_Response__c
                                   WHERE Property__c =: propertyList[0].id ORDER BY Area__c];
        
        if(!allUnitSnagResponseList.isEmpty())
        {
            for(Unit_Snag_Response__c usr:allUnitSnagResponseList)
            {
                List<rowWrapper> rowWrapperList = new List<rowWrapper>();
                if(mapArea.containsKey(usr.Area__c))
                {
                    rowWrapperList = mapArea.get(usr.Area__c);
                    rowWrapperList.add(new rowWrapper(usr));
                    mapArea.put(usr.Area__c, rowWrapperList);
                    areaCountMap.put(usr.Area__c, rowWrapperList.size());
                }
                else
                {
                    rowWrapperList.add(new rowWrapper(usr));
                    mapArea.put(usr.Area__c, rowWrapperList);
                    areaCountMap.put(usr.Area__c, rowWrapperList.size());
                }
            }
            
            areaList = new List<String>(mapArea.keySet()); 
        }
        
        
        //snagListToUpdate = new List<Unit_Snag_Response__c>();
        
    }
    
    
    
    public Class rowWrapper {
        
        public rowWrapper(Unit_Snag_Response__c unitSnagResponse)
        {
            this.question = unitSnagResponse.Project_Snag__r.Questions__c;
            this.preOcCheckBox = unitSnagResponse.Pre_OC_Answers__c;
            this.remarks = unitSnagResponse.Pre_OC_Remarks__c;
            this.postOcCheckBox = unitSnagResponse.Post_OC_Answers__c;
            this.postOcremarks = unitSnagResponse.Post_OC_Remarks__c;
            this.area = unitSnagResponse.Area__c;
            this.recordId = unitSnagResponse.Id;
            this.customerRemarks = unitSnagResponse.Customer_Inspection_Remarks__c ;
            this.customerCheckBox = unitSnagResponse.Customer_Inspection_Answers__c;
        }
        
        public String question {get;set;}
        public Boolean preOcCheckBox {get;set;}
        public Boolean postOcCheckBox {get;set;}
        public String remarks {get;set;}
        public String postOcremarks {get;set;}
        public String area {get;set;}
        public Boolean customerCheckBox {get;set;}
        public String customerRemarks {get;set;}
        public String recordId {get;set;}
    }
}