public class SnagRowSpanController{
    private ApexPages.StandardController standardController;
    
    public List<Project_Snag__c> projectSnagList  { get; set; }
    public List<Property__c> propertyList  { get; set; }
    public List<Unit_Snag_Response__c> allUnitSnagResponseList{ get; set; }
    public List<Unit_Snag_Response__c> snagListToUpdate { get; set; }
    
    Public string ProjectHeader{get;set;}
    Public string ProjectFooter{get;set;}
    Public string CustomerName{get;set;}
    Public Integer meterReading{get;set;}
    
    public List<String> areaList {get;set;}
    public Map<String, Integer> areaCountMap{get;set;}
    public Map<String, List<rowWrapper>> mapArea {get;set;} 
    public string SnagDetails{get;set;}
    public string SnagType{get;set;}
    public String Error{get;set;}
    public Boolean Task{get;set;}
    public String customerSnagFileName{get;set;}
    public Blob customerSnagFile {get;set;}
    public Blob file {get;set;}
    
    
    Public SnagRowSpanController(ApexPages.StandardController standardController) {
        customerSnagFileName = '';
        SnagType = 'Pre-OC';
        Task = false;
        string propertyId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('propertyId--'+propertyId);
        Set<ID> suggestedPropertyIDSet = New Set<ID> ();
        propertyList= [SELECT ID, NAME, Project__c,Project__r.Skip_Pre_OC__c, Snag_Status__c, Flat_Type__c, Project__r.Name, Tower__r.Name,
                       Unit_Type__c,Electric_Meter_Number__c,Electric_Meter_Installed__c,
                       Electric_Meter_Reading__c,Sub_Snag_Status__c 
                       FROM PROPERTY__C WHERE id =:propertyId];
        system.debug('propertyList--'+propertyList);
        if(propertyList[0].Electric_Meter_Reading__c != null)
        {
            meterReading = Integer.Valueof(propertyList[0].Electric_Meter_Reading__c);
        }
        else
        {
            meterReading =0;
        }
        List<Suggested_Property__c> suggestedProperty = [SELECT ID, NAME FROM Suggested_Property__c WHERE UNIT__C =:propertyId];
        for(Suggested_Property__c thisSP:suggestedProperty)
        {
            suggestedPropertyIDSet.add(thisSP.id);
        }
         system.debug('suggestedProperty--'+suggestedProperty);
        if(!suggestedProperty.isEmpty())
        {
            LIST<bOOKING__C> BOOKINGlIST = [SELECT ID, NAME,Stage__c,Primary_Applicant_Name_Formulla__c FROM bOOKING__C 
                                            where Related_Suggested_Property__c IN : suggestedPropertyIDSet
                                            AND Stage__c != 'Booking Cancelled – Refund Pending'
                                            AND Stage__c != 'Booking Cancelled – Refund Ready'
                                            AND Stage__c != 'Booking Cancelled -- Refund Done'
                                            AND Stage__c != 'Terminated'
                                           ];
               system.debug('BOOKINGlIST--'+BOOKINGlIST);

            if(!BOOKINGlIST.isEmpty())
            {
                CustomerName = BOOKINGlIST[0].Primary_Applicant_Name_Formulla__c;
                BOOKING__C booking = New BOOKING__C();
                booking.Stage__c = 'Snagging/De-snagging';
                booking.id = BOOKINGlIST[0].id;
                // update booking;
            }
        }
        system.debug('CustomerName'+CustomerName);
        system.debug('propertyList[0].Snag_Status__c'+propertyList[0].Snag_Status__c);
        if(propertyList[0].Project__r.Skip_Pre_OC__c != true && (propertyList[0].Snag_Status__c == ''|| propertyList[0].Snag_Status__c == null || propertyList[0].Snag_Status__c =='Yet to start' || 
                                                                 (propertyList[0].Snag_Status__c == 'Internal Snagging' && (propertyList[0].Sub_Snag_Status__c  =='Pre OC-Submitted with snags'	||
                                                                                                                            propertyList[0].Sub_Snag_Status__c =='Snag Initiated'))))
        {
            List<Task> taskList = [SELECT ID, whatId, Subject FROM Task WHERE whatId =: propertyId AND 
                                   Subject =:'Pre-OC FM Unit Inspection task'
                                   order By CreatedDate Desc LIMIT 1];
            if(!taskList.isEmpty())
            {system.debug('yes');
             Task = true;
            }
        }
        if(propertyList[0].Sub_Snag_Status__c == 'Post OC-Submitted with snags' ||
           propertyList[0].Sub_Snag_Status__c ==  'Pre OC-Verified' ||  (propertyList[0].Project__r.Skip_Pre_OC__c == true && propertyList[0].Sub_Snag_Status__c != 'Post OC-Verified'
                                                                         && propertyList[0].Snag_Status__c != 'Customer Snagging'
                                                                         &&  propertyList[0].Snag_Status__c !=  'Customer Unit Inspection Scheduled'))
        {
            SnagType = 'Post-OC';
            List<Task> taskList = [SELECT ID, whatId, Subject FROM Task WHERE whatId =: propertyId AND Subject =:'Post - OC FM Unit Inspection' 
                                   order By CreatedDate Desc LIMIT 1];
            if(!taskList.isEmpty())
            {
                Task = true;
            }
        }
        if(propertyList[0].Sub_Snag_Status__c == 'Post OC-Verified')
        {
            SnagType = 'Not Scheduled';
        }
        if(//propertyList[0].Snag_Status__c == 'Customer Snagging' ||
            propertyList[0].Snag_Status__c ==  'Customer Unit Inspection Scheduled')
        {
            SnagType = 'Customer';
            List<Task> taskList = [SELECT ID, whatId, Subject, Status FROM Task WHERE whatId =: propertyId 
                                   AND Subject =:'Deep Cleaning Task'
                                   order By CreatedDate Desc LIMIT 1];
            if(!taskList.isEmpty())
            {
                if(taskList[0].status == 'Completed')
                {
                    Task = true;
                }
                
            }
            
        }
        if(propertyList[0].Snag_Status__c == 'Customer Snagging')
        {
            SnagType = 'Customer with Snag';
            List<Task> taskList = [SELECT ID, whatId, Subject, Status FROM Task WHERE whatId =: propertyId 
                                   AND Subject =:'Post - OC FM Review Task' 
                                   order By CreatedDate Desc LIMIT 1];
            if(!taskList.isEmpty())
            {
                if(taskList[0].status == 'Completed')
                {
                    Task = true;
                }
                
            }
            
        }
        snagListToUpdate = new List<Unit_Snag_Response__c>();
        mapArea = new Map<String, List<rowWrapper>>();
        areaCountMap = new Map<String, Integer>();
        areaList = new List<String>();
    }
    
    //prepare data to display in Visualforce.
    public void getData()
    {
        string propertyId = ApexPages.currentPage().getParameters().get('Id');
        //string meterReading = ApexPages.currentPage().getParameters().get('meterReading');
        
        propertyList= [SELECT ID, NAME,Project__c,Flat_Type__c,Project__r.Name,Tower__r.Name,Unit_Type__c,
                       Electric_Meter_Number__c, Electric_Meter_Installed__c, Electric_Meter_Reading__c,Snag_Status__c 
                       FROM PROPERTY__C WHERE id =:propertyId];
        if(propertyList[0].Snag_Status__c == 'Yet to start' || propertyList[0].Snag_Status__c == '' 
           || propertyList[0].Snag_Status__c == null)
        {
            propertyList[0].Snag_Status__c = 'Internal Snagging';
            propertyList[0].Sub_Snag_Status__c = 'Snag Initiated';
            update propertyList[0];
        }
        
        List<Suggested_Property__c> suggestedProperty = [SELECT ID, NAME FROM Suggested_Property__c WHERE UNIT__C =:propertyId];
        Set<ID> suggestedPropertyIDSet = New Set<ID> ();
        
        if(!suggestedProperty.isEmpty())
        {
            for(Suggested_Property__c thisSP:suggestedProperty)
            {
                suggestedPropertyIDSet.add(thisSP.id);
            }
            LIST<bOOKING__C> BOOKINGlIST = [SELECT ID, NAME,Primary_Applicant_Name_Formulla__c 
                                            FROM bOOKING__C 
                                            where Related_Suggested_Property__c IN :suggestedPropertyIDSet
                                            AND Stage__c != 'Booking Cancelled – Refund Pending'
                                            AND Stage__c != 'Booking Cancelled – Refund Ready'
                                            AND Stage__c != 'Booking Cancelled -- Refund Done'
                                            AND Stage__c != 'Terminated'];
            if(!BOOKINGlIST.isEmpty())
            {
                CustomerName = BOOKINGlIST[0].Primary_Applicant_Name_Formulla__c;
                BOOKING__C booking = New BOOKING__C();
                booking.Stage__c = 'Snagging/De-snagging';
                booking.id = BOOKINGlIST[0].id;
                update booking;
            }
        }
        List<Project__c> projectList = [SELECT id, name,OTP_Disable_Till__c, Project_Header__c,Budgets__c, Project_Footer__c, Configuration__c 
                                        from Project__c WHERE id =: propertyList[0].Project__c];
        
        List<Project_Snag__c> projectSnagList = [SELECT ID, NAME,Project__c,Questions__c,Unit_Type__c,Area__c 
                                                 FROM Project_Snag__c 
                                                 WHERE Project__c =: propertyList[0].Project__c];
        system.debug('projectSnagList'+projectSnagList);
        ProjectFooter = projectList[0].Project_Footer__c;
        ProjectHeader = projectList[0].Project_Header__c;
        Map<String,Unit_Snag_Response__c> mapOfunitSnag = New Map<String,Unit_Snag_Response__c>();
        Set<Id> projectSnagIdSet = New Set<Id>();
        if(!projectSnagList.isEmpty()){
            for( Project_Snag__c thisProjectSnag : projectSnagList)
            {
                system.debug('thisProjectSnag.Unit_Type__c '+thisProjectSnag.Unit_Type__c );
                system.debug('propertyList[0].Flat_Type__c '+propertyList[0].Flat_Type__c );
                if(thisProjectSnag.Unit_Type__c != '' && thisProjectSnag.Unit_Type__c != null)
                {
                    if(thisProjectSnag.Unit_Type__c.contains(propertyList[0].Flat_Type__c))
                    {
                        projectSnagIdSet.add(thisProjectSnag.id);
                    }
                }
                
            }
            
            List<Unit_Snag_Response__c> newUnitSnagResponseList = New List<Unit_Snag_Response__c>();
            
            List<Unit_Snag_Response__c> unitSnagResponseList = [SELECT Id, Name, Property__c, Project_Snag__c ,Area__c
                                                                FROM Unit_Snag_Response__c
                                                                WHERE Project_Snag__c IN:projectSnagIdSet 
                                                                AND Property__c =: propertyList[0].id 
                                                               ];
            if(!unitSnagResponseList.isEmpty())
            {  for(Unit_Snag_Response__c thisUSR :unitSnagResponseList)
            {
                String Key = thisUSR.Project_Snag__c+'-'+thisUSR.Area__c;
                mapOfunitSnag.put(Key,thisUSR);  
                
            }}
            for( Project_Snag__c thisProjectSnag : projectSnagList)
            {
                system.debug('thisProjectSnag.Unit_Type__c '+thisProjectSnag.Unit_Type__c );
                if(thisProjectSnag.Unit_Type__c != '' && thisProjectSnag.Unit_Type__c != null)
                {
                    system.debug('propertyList[0].Flat_Type__c '+propertyList[0].Flat_Type__c );
                    if(thisProjectSnag.Unit_Type__c.contains(propertyList[0].Flat_Type__c))
                    {
                        system.debug('propertyList[0].Flat_Type__c----- '+propertyList[0].Flat_Type__c );
                        List<String> selections = thisProjectSnag.Area__c != null ? thisProjectSnag.Area__c.split(';') : null;
                        for(String area:selections)
                        {
                            String Key = thisProjectSnag.id+'-'+area;
                            if(!mapOfunitSnag.containsKey(Key))
                            {
                                Unit_Snag_Response__c newUSR =  New Unit_Snag_Response__c();
                                newUSR.Project_Snag__c = thisProjectSnag.id;
                                newUSR.Pre_OC_Start_Date__c = system.today();
                                newUSR.Property__c = propertyList[0].id;
                                newUSR.Area__c = area;
                                newUnitSnagResponseList.add(newUSR);
                            } 
                        }
                        
                    }
                }
            }
            if(!newUnitSnagResponseList.isEmpty())
            {
                insert newUnitSnagResponseList;
            }
            system.debug('newUnitSnagResponseList'+newUnitSnagResponseList);
            allUnitSnagResponseList = [SELECT Id, Name, Property__c, Project_Snag__c ,Project_Snag__r.Questions__c,
                                       Post_OC_Answers__c,Pre_OC_Answers__c,Pre_OC_End_Date__c,Area__c,Pre_OC_Remarks__c,
                                       Post_OC_Remarks__c, Customer_Inspection_Remarks__c,Customer_Inspection_Answers__c
                                       FROM Unit_Snag_Response__c
                                       WHERE Project_Snag__c IN:projectSnagIdSet 
                                       AND Property__c =: propertyList[0].id ORDER BY Area__c];
            system.debug('projectSnagIdSet'+projectSnagIdSet);
            system.debug('allUnitSnagResponseList'+allUnitSnagResponseList);
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
            
        }
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
    
    public Void  saveUnitSnagList() {
        String jsonString =  system.currentPageReference().getParameters().get('SnagDetails');
        // String meterReading =  system.currentPageReference().getParameters().get('meterReading');
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        List<String> emailList=new List<String>();
        system.debug('jsonString'+jsonString);
        string propertyId = ApexPages.currentPage().getParameters().get('Id');
        Property__c  propertyList= [SELECT ID, NAME,Project__c,Flat_Type__c,Project__r.Name,Tower__r.Name,Project__r.Project_Email__c,Electric_Meter_Reading__c,
                                    
                                    Unit_Type__c,Pre_OC_Start_Date__c,Project__r.FM_Head__r.Name,Project__r.FM_Head__r.email,Sub_Snag_Status__c 
                                    FROM PROPERTY__C 
                                    WHERE id =:propertyId];
        
       // propertyList.Electric_Meter_Reading__c = decimal.valueof(meterReading);
        Map<Id,Unit_Snag_Response__c> mapOfUnitSnagResposne = New Map<Id,Unit_Snag_Response__c>();
        List<Task> taskList = [SELECT ID, whatId, Subject FROM Task WHERE whatId =: propertyId AND Subject =:'Pre-OC FM Unit Inspection task' 
                               AND STATUS != 'Completed' order By CreatedDate Desc LIMIT 1];
        List<Unit_Snag_Response__c> allUnitSnagList = [SELECT Id, Name, Property__c, Project_Snag__c ,Project_Snag__r.Questions__c,
                                                       Post_OC_Answers__c,Pre_OC_Answers__c,Pre_OC_End_Date__c,Area__c,Pre_OC_Remarks__c
                                                       FROM Unit_Snag_Response__c
                                                       WHERE  
                                                       Property__c =: propertyId];
        system.debug('allUnitSnagList----'+allUnitSnagList);
        Map<id,Unit_Snag_Response__c> mapOfUnitSnag = New Map<id,Unit_Snag_Response__c>();
        for(Unit_Snag_Response__c usr:allUnitSnagList)
        {
            mapOfUnitSnag.put(usr.id,usr);
        }
        List<Object> snagDetails = (List<Object>) JSON.deserializeUntyped(jsonString);
        for (Object detail : snagDetails) {
            Map<String, Object> detailMap = (Map<String, Object>)detail;
            if (detailMap.containsKey('recordId')) {
                String recordId = (String)detailMap.get('recordId');
                if(mapOfUnitSnag.containsKey(recordId))
                {
                    Unit_Snag_Response__c usr= New Unit_Snag_Response__c();
                    usr.id = (String)detailMap.get('recordId');
                    if (detailMap.containsKey('CheckBox')) {
                        usr.Pre_OC_Answers__c= (boolean)detailMap.get('CheckBox');
                        System.debug('CheckBox: ' + (boolean)detailMap.get('CheckBox'));
                    }
                    if (detailMap.containsKey('remarks')) {
                        if( (String)detailMap.get('remarks') != '' && (String)detailMap.get('remarks') != null)
                        {
                            usr.Pre_OC_Remarks__c= (String)detailMap.get('remarks');
                        }
                    }
                    mapOfUnitSnagResposne.put(usr.id,usr);
                    system.debug('mapOfUnitSnagResposne'+mapOfUnitSnagResposne);
                }
            }
        }
        if(!mapOfUnitSnagResposne.isEmpty())
        {
            update mapOfUnitSnagResposne.values();
        }
        if(!taskList.isEmpty())
        {
            Task newTask = New Task();
            newTask.id = taskList[0].id;
            newTask.Status = 'Completed';
            update newTask;
        }
        generateSnagDoc(propertyId,'Pre-OC',decimal.valueof(meterReading));
    }
    @RemoteAction
    public STatic String  saveCustomerUnitSnagList(String jsonString,string propertyId, Decimal meterReadingValue,  String fileName )  {
        try{
            system.debug('jsonString'+jsonString);
            system.debug('fileName'+fileName);
            // system.debug('fileValue'+fileValue);
            String customerSnagFileName = '';
            Blob customerSnagFile ;
            
            Property__c  propertyList= [SELECT ID, NAME,Project__c,Flat_Type__c,Project__r.Name,Tower__r.Name,Project__r.Project_Email__c,
                                        Electric_Meter_Reading__c,
                                        Unit_Type__c,Pre_OC_Start_Date__c,Project__r.FM_Head__r.Name,Project__r.FM_Head__r.email,Sub_Snag_Status__c 
                                        FROM PROPERTY__C 
                                        WHERE id =:propertyId];
            propertyList.Electric_Meter_Reading__c = meterReadingValue;
            Map<Id,Unit_Snag_Response__c> mapOfUnitSnagResposne = New Map<Id,Unit_Snag_Response__c>();
            List<Unit_Snag_Response__c> allUnitSnagList = [SELECT Id, Name, Property__c, Project_Snag__c ,Project_Snag__r.Questions__c,
                                                           Post_OC_Answers__c,Pre_OC_Answers__c,Pre_OC_End_Date__c,Area__c,
                                                           Pre_OC_Remarks__c,Customer_Inspection_Start_Date__c,
                                                           Customer_Inspection_End_Date__c, Customer_Inspection_Remarks__c,Customer_Inspection_Answers__c
                                                           FROM Unit_Snag_Response__c
                                                           WHERE  
                                                           Property__c =: propertyId ];
            system.debug('allUnitSnagList----'+allUnitSnagList);
            Map<id,Unit_Snag_Response__c> mapOfUnitSnag = New Map<id,Unit_Snag_Response__c>();
            for(Unit_Snag_Response__c usr:allUnitSnagList)
            {
                mapOfUnitSnag.put(usr.id,usr);
            }
            List<Object> snagDetails = (List<Object>) JSON.deserializeUntyped(jsonString);
            for (Object detail : snagDetails) {
                Map<String, Object> detailMap = (Map<String, Object>)detail;
                if (detailMap.containsKey('recordId')) {
                    String recordId = (String)detailMap.get('recordId');
                    if(mapOfUnitSnag.containsKey(recordId))
                    {
                        Unit_Snag_Response__c usr= New Unit_Snag_Response__c();
                        usr.id = (String)detailMap.get('recordId');
                        if (detailMap.containsKey('CheckBox')) {
                            usr.Customer_Inspection_Answers__c= (boolean)detailMap.get('CheckBox');
                            System.debug('CheckBox: ' + (boolean)detailMap.get('CheckBox'));
                        }
                        if(mapOfUnitSnag.get(recordId).Customer_Inspection_Start_Date__c == null)
                        {
                            usr.Customer_Inspection_Start_Date__c = system.today();
                        }
                        if (detailMap.containsKey('remarks')) {
                            if( (String)detailMap.get('remarks') != '' && (String)detailMap.get('remarks') != null)
                            {
                                usr.Customer_Inspection_Remarks__c= (String)detailMap.get('remarks');
                            }
                        }
                        
                        mapOfUnitSnagResposne.put(usr.id,usr);
                        system.debug('mapOfUnitSnagResposne'+mapOfUnitSnagResposne);
                    }
                    
                }
                else
                {
                    if (detailMap.containsKey('FileName')) {
                        customerSnagFileName = (String)detailMap.get('FileName');
                        system.debug('customerSnagFileName'+(String)detailMap.get('FileName'));
                    }
                    if (detailMap.containsKey('FileValue')) {
                        system.debug('customerSnagFile'+(String)detailMap.get('FileValue'));
                        String  base64Image = (String)detailMap.get('FileValue');
                        List<String> parts = base64Image.split(',');
                        String base64Data = parts[1];
                        customerSnagFile = EncodingUtil.base64Decode(base64Data);
                    }
                }
            }
            Booking__c booking = [Select Id ,Name,Primary_Applicant__r.Name,
                                  OwnerId, Related_Suggested_Property__r.Unit__r.FM_User__c, 
                                  Related_Suggested_Property__c,Project_Email__c,Unit_Number__c,
                                  Primary_Applicant__r.PersonEmail,Project_Name__r.Name,Project_Name__r.GPS_location__c,
                                  Project_Name__r.Location__c,Project_Name__r.Project_Phone__c, 
                                  Related_Suggested_Property__r.Unit__c,Project_Name__r.Project_Email__c,
                                  Related_Suggested_Property__r.Unit__r.Customer_Unit_Inspection_Scheduled_Date__c
                                  From Booking__c 
                                  Where Related_Suggested_Property__r.Unit__c =: propertyId 
                                  AND Stage__c != 'Booking Cancelled – Refund Pending'
                                            AND Stage__c != 'Booking Cancelled – Refund Ready'
                                            AND Stage__c != 'Booking Cancelled -- Refund Done'
                                            AND Stage__c != 'Terminated'
                                  LIMIT 1
                                 ];
            ContentVersion contentVersion_1 = new ContentVersion(
                Title='Copy of the Signed Customer Snag List', 
                PathOnClient =customerSnagFileName,
                ContentLocation='S',
                VersionData = customerSnagFile, 
                origin = 'C',
                isMajorVersion=false,
                SObjectType__c = 'Property__c',
                Document_Type__c = 'Copy of the Signed Customer Snag List'
            );
            try{
                insert contentVersion_1;
            }
            catch(DmlException ex){
                system.debug('Error'+ex.getMessage());
            }
            if(contentVersion_1.Id != null)
            {
                ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                                   FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
                List<ContentDocumentLink> contentListlink1=new List<ContentDocumentLink>();
                ContentDocumentLink contentlink1 = new ContentDocumentLink();
                contentlink1.LinkedEntityId = propertyId;
                contentlink1.contentdocumentid = contentVersion_2.contentdocumentid;
                contentlink1.ShareType = 'V';
                //contentListlink1.add(contentlink1);
                try{
                    insert contentlink1;   
                }
                catch(DmlException ex){
                    system.debug('Error'+ex.getMessage());
                }            
            }
            
            // for save passport on booking      
            ContentVersion contentVersion_3 = new ContentVersion(
                Title='Customer Snag List', 
                PathOnClient =customerSnagFileName,
                ContentLocation='S',
                VersionData = customerSnagFile, 
                origin = 'C',
                isMajorVersion=false,
                SObjectType__c = 'Booking__c',
                Document_Type__c = 'Copy of the Signed Customer Snag List'
            );
            try{
                insert contentVersion_3;
            }
            catch(DmlException ex){
                system.debug('Error'+ex.getMessage());
            }
            if(contentVersion_3.Id != null){
                ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId 
                                                   FROM ContentVersion WHERE Id = :contentVersion_3.Id LIMIT 1];
                ContentDocumentLink contentlink2 = new ContentDocumentLink();
                contentlink2.LinkedEntityId = booking.id;
                contentlink2.contentdocumentid = contentVersion_4.contentdocumentid;
                contentlink2.ShareType = 'V';
                //contentListlink1.add(contentlink2);
                try{
                    insert contentlink2;
                }
                catch(DmlException ex){
                }
            }
            //insert contentListlink1;
            if(!mapOfUnitSnagResposne.isEmpty())
            {
                update mapOfUnitSnagResposne.values();
            }
            generateSnagDoc(propertyId,'Customer',meterReadingValue);
            
            return 'Success';
        }
        catch(Exception Ex)
        {
            system.debug('Error'+Ex.getMessage()+ex.getLineNumber());
            String error = 'Error'+Ex.getMessage();
            Return error;
        }
        
    }
    
    @future(callout = true)
    public static void generateSnagDoc(Id propertyId, String SnagType, Decimal meterReading){
        Set<Id> taskId = New  Set<Id>();
        List<String> emailList=new List<String>();
        Property__c  propertyList= [SELECT ID, NAME,Project__c,Flat_Type__c,Project__r.Name,Tower__r.Name,Project__r.Project_Email__c,Customer_Inspection_End_Date__c,
                                    Electric_Meter_Reading__c,Post_OC_Start_Date__c,Post_OC_End_Date__c,Customer_Inspection_Start_Date__c,
                                    Unit_Type__c,Pre_OC_Start_Date__c,Project__r.FM_Head__r.Name,Project__r.FM_Head__r.email,Sub_Snag_Status__c 
                                    FROM PROPERTY__C 
                                    WHERE id =:propertyId];
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Booking_Form_Notification']; 
        List<EmailMessage> insertEmailMessageList = New List<EmailMessage>();
        Blob body; 
        PageReference ref = Page.SnagListDoc;
        ref.getParameters().put('id',propertyId);
        ref.getParameters().put('SnagType',SnagType);
        ref.getParameters().put('meterReading',String.valueof(meterReading));
        if(Test.isRunningTest()){
            body = Blob.valueOf('Snag List');
        }
        else{
            body = ref.getContent();
        }
        ContentVersion conVer =new ContentVersion(); 
        conVer.ContentLocation = 'S'; 
        conVer.PathOnClient = 'SnagList.pdf'; 
        conVer.Title = 'SnagList'+'.pdf';
        conVer.VersionData = body;
        conVer.SObjectType__c = 'Property__c';
        conVer.Document_Type__c = 'SnagList';
        conVer.FirstPublishLocationId = propertyId;
        //conVer.Document_Type__c = 'Cost Sheet';
        //  conVer.ContentDocumentId=ContentVersionlist[0].ContentDocumentId;
        insert conVer;
        if(SnagType == 'Pre-OC')
        {
            
            string PMHeadEmail = System.Label.PM_Head_Email;
            List<String> toMailList  = New  List<String> ();
            OrgWideEmailAddress owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address =: propertyList.Project__r.Project_Email__c ];
            
            // SendEmailandBellNotificationUtility.SendEmail3(String emailTempId,String Subject,String htmlBody,String plainBody,toMailList,null,true,propertyId,body,'SnagList.pdf',null){
            List<Unit_Snag_Response__c> preOCUnitSnagList = [SELECT Id, Name, Property__c, Project_Snag__c ,Project_Snag__r.Questions__c,
                                                             Post_OC_Answers__c,Pre_OC_Answers__c,Pre_OC_End_Date__c,Area__c,Pre_OC_Remarks__c
                                                             FROM Unit_Snag_Response__c
                                                             WHERE  
                                                             Property__c =: propertyId AND Pre_OC_Answers__c != true];
            if(!preOCUnitSnagList.isEmpty())
            {
                if(propertyList != null)
                {
                    
                    if(propertyList.Pre_OC_Start_Date__c != null)
                    {
                       
                    }
                    else
                    {
                         propertyList.Pre_OC_Start_Date__c = system.today();
                    }
                    
                    propertyList.Snag_Status__c ='Internal Snagging';
                    propertyList.Electric_Meter_Reading__c = meterReading;
                    propertyList.Sub_Snag_Status__c = 'Pre OC-Submitted with snags' ;
                    
                    update propertyList;
                }
                
                Task newTask = New Task();
                newTask.WhatId = propertyId;
                newTask.Status = 'Open';
                newTask.Subject = 'Pre-OC FM Review Task';
                newTask.Type_Of_Call__c ='Pre OC Snag';
                newTask.ownerId = UserInfo.getUserId();
                CalcBusinessDays calc = new CalcBusinessDays();
                Snag_TAT__mdt snagTat = Snag_TAT__mdt.getInstance('Snag_TAT');
                
                Datetime  NextWorkingDays = calc.AddDays(System.now(),integer.valueof(snagTat.Pre_OC_FM_Review_Task__c));
                newTask.activitydate = date.valueof(NextWorkingDays);
                insert newTask;
                toMailList = PMHeadEmail.split(';');
                //toMailList.add(PMHeadEmail);
                EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                               from EmailTemplate 
                                               where Name = 'PM Pre OC Review Task' LIMIT 1];
                
                if(emailTemplate != null && propertyList.Project__r.FM_Head__c != null ){    
                    //emailList.add(propertyList.Project__r.FM_Head__r.email);    
                    String htmlBody = emailTemplate.HtmlValue;
                    String plainBody = emailTemplate.Body;
                    String Subject = emailTemplate.Subject;
                    Subject = Subject.replace('{!Property__c.Name}', propertyList.Name);
                    htmlBody = htmlBody.replace('{userName}', propertyList.Project__r.FM_Head__r.Name);
                    htmlBody = htmlBody.replace('{!Property__c.Name}', propertyList.Name);
                    htmlBody = htmlBody.replace('{projectName}', propertyList.Project__r.Name);
                    plainBody = plainBody.replace('{userName}', propertyList.Project__r.FM_Head__r.Name);
                    plainBody = plainBody.replace('{!Property__c.Name}', propertyList.Name);
                    plainBody = plainBody.replace('{projectName}', propertyList.Project__r.Name);
                    EmailMessage objEmailMessage = new EmailMessage();
                    objEmailMessage.status = '3'; // email was sent
                    objEmailMessage.RelatedToId = propertyList.id;
                    objEmailMessage.fromName = 'Dynamix'; // from name
                    system.debug('toMailList'+toMailList);
                    objEmailMessage.ToAddress = String.join(toMailList, ',');
                    objEmailMessage.FromAddress = owea.Address;
                    objEmailMessage.Subject = 'Email sent to PM for Review of Pre-OC Task';
                    objEmailMessage.HtmlBody = htmlBody;
                    insertEmailMessageList.add(objEmailMessage);
                    insert insertEmailMessageList;
                    Attachment attachmentEmailMessage = new Attachment( ParentId = insertEmailMessageList[0].Id,                         
                                                                       Body = body,                         
                                                                       ContentType = 'application/pdf',                         
                                                                       Name = 'SnagList.pdf');
                    insert attachmentEmailMessage;
                    Set<String> recipientIds = New Set<String> ();
                    recipientIds.add(propertyList.Project__r.FM_Head__c);
                    //SendEmailWithOrgWideAddress.SendEmail(emailTemplate.Id, htmlBody, plainBody, emailList,null,owea.id);
                    SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,Subject,htmlBody,plainBody,toMailList,null,false,propertyId,body,'SnagList.pdf',owea.id);
                    String notificationBody ='Hi,\n Snags have been identified for Unit No - '+ propertyList.Name+' in project '+ propertyList.Project__r.Name+'.\nRequest you to kindly look into it and proceed with corrections for the same.';
                    SendEmailandBellNotificationUtility.SendBellNotification(notificationType.id,Subject,notificationBody,propertyList.id,recipientIds);
                }
            }
            else
            {	propertyList.Sub_Snag_Status__c = 'Pre OC-Verified' ;
             propertyList.Pre_OC_End_Date__c = System.today();
             propertyList.Electric_Meter_Reading__c = meterReading;
             EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                            from EmailTemplate 
                                            where Name = 'FM for Succesfully Completion of Pre Oc Task' LIMIT 1];
             
             if(emailTemplate != null && propertyList.Project__r.FM_Head__c != null ){   
                 toMailList.add(propertyList.Project__r.FM_Head__r.email);
                 //emailList.add(propertyList.Project__r.FM_Head__r.email);    
                 String htmlBody = emailTemplate.HtmlValue;
                 String plainBody = emailTemplate.Body;
                 String Subject = emailTemplate.Subject;
                 plainBody = plainBody.replace('{userName}', propertyList.Project__r.FM_Head__r.Name);
                 plainBody = plainBody.replace('{unitNumber}', propertyList.Name);
                 plainBody = plainBody.replace('{projectName}', propertyList.Project__r.Name);
                 htmlBody = htmlBody.replace('{userName}', propertyList.Project__r.FM_Head__r.Name);
                 htmlBody = htmlBody.replace('{unitNumber}', propertyList.Name);
                 htmlBody = htmlBody.replace('{projectName}', propertyList.Project__r.Name);
                 
                 EmailMessage objEmailMessage = new EmailMessage();
                 objEmailMessage.status = '3'; // email was sent
                 objEmailMessage.RelatedToId = propertyList.id;
                 objEmailMessage.fromName = 'Dynamix'; // from name
                 objEmailMessage.Subject = 'Email sent to FM for succesful completion of Pre-OC Task';
                 objEmailMessage.HtmlBody = plainBody;
                 objEmailMessage.ToAddress = String.join(toMailList, ',');
                 objEmailMessage.FromAddress = owea.Address;
                 insertEmailMessageList.add(objEmailMessage);
                 //SendEmailWithOrgWideAddress.SendEmail(emailTemplate.Id, htmlBody, plainBody, emailList,null,owea.id);
                 SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,Subject,htmlBody,plainBody,toMailList,null,true,propertyId,body,'SnagList.pdf',owea.id);
                 
                 insert insertEmailMessageList;
             }
             update propertyList;
             if(!insertEmailMessageList.isEmpty())
             {
                 //insert insertEmailMessageList;
             }
            }
            
        }
        if(SnagType == 'Post-OC')
        {
            List<Task> taskList = [SELECT ID, whatId, Subject FROM Task WHERE whatId =: propertyId AND Subject =:'Post - OC FM Unit Inspection' 
                                   AND STATUS != 'Completed' order By CreatedDate Desc LIMIT 1];
            List<Unit_Snag_Response__c> postOCUnitSnagList = [SELECT Id, Name, Property__c, Project_Snag__c ,Project_Snag__r.Questions__c,
                                                              Post_OC_Answers__c,Pre_OC_Answers__c,Pre_OC_End_Date__c,Area__c,Pre_OC_Remarks__c
                                                              FROM Unit_Snag_Response__c
                                                              WHERE  
                                                              Property__c =: propertyId AND Post_OC_Answers__c != true];
          system.debug('propertyList.Post_OC_Start_Date__c'+propertyList.Post_OC_Start_Date__c);
            if(!postOCUnitSnagList.isEmpty())
            {
                propertyList.Sub_Snag_Status__c = 'Post OC-Submitted with snags' ;
                propertyList.Electric_Meter_Reading__c = meterReading;
               
                if(propertyList.Post_OC_Start_Date__c != null)
                {
                   
                }
                else
                {
                     propertyList.Post_OC_Start_Date__c = system.today();
                }
                update propertyList;
            }
            else
            {
                //  propertyList.Post_OC_End_Date__c = system.today();
                propertyList.Electric_Meter_Reading__c = meterReading;
                propertyList.Sub_Snag_Status__c = 'Post OC-Verified' ;
                propertyList.Post_OC_End_Date__c =  system.now();
                update propertyList;
                
            }
            if(!taskList.isEmpty() )
            {
                Task newTask = New Task();
                newTask.id = taskList[0].id;
                if(postOCUnitSnagList.isEmpty())
                {
                    newTask.Status = 'Completed';
                }
                else
                {
                    newTask.Status = 'Hold';
                }
                
                update newTask;
            }
        }
        if( SnagType =='Customer')
        {
            Booking__c BookList = [Select Id,Name,Owner.Email, Primary_Applicant__r.PersonEmail From Booking__c
                                   Where Related_Suggested_Property__r.Unit__c =: propertyId
                                   AND Stage__c != 'Booking Cancelled – Refund Pending'
                                   AND Stage__c != 'Booking Cancelled – Refund Ready'
                                   AND Stage__c != 'Booking Cancelled -- Refund Done'
                                   AND Stage__c != 'Terminated' LIMIT 1];
            
            
            taskId.add(propertyList.id); 
            taskId.add(BookList.id); 
            List<Task> taskList = [SELECT ID, whatId, Subject FROM Task WHERE  
                                   (Subject =:'FM Customer Unit Inspection Task'
                                    OR Subject =: 'RM Customer Unit Inspection Task') AND whatId IN:taskId
                                   AND STATUS != 'Completed' order By CreatedDate];
            System.debug('taskList'+taskList);
            List<Unit_Snag_Response__c> preOCUnitSnagList = [SELECT Id, Name, Property__c, Project_Snag__c ,Project_Snag__r.Questions__c,
                                                             Post_OC_Answers__c,Pre_OC_Answers__c,Customer_Inspection_Answers__c,
                                                             Pre_OC_End_Date__c,Area__c,Pre_OC_Remarks__c,Customer_Inspection_Start_Date__c,
                                                             Customer_Inspection_End_Date__c, Customer_Inspection_Remarks__c
                                                             FROM Unit_Snag_Response__c
                                                             WHERE  
                                                             Property__c =: propertyId AND Customer_Inspection_Answers__c != true];
            if(propertyList.Customer_Inspection_Start_Date__c != null)
            {
                
            } 
            else
            {
                propertyList.Customer_Inspection_Start_Date__c =system.now();
            }
            if(!preOCUnitSnagList.isEmpty())
            {
                propertyList.Electric_Meter_Reading__c = meterReading;
                propertyList.Snag_Status__c ='Customer Snagging';
                update propertyList;
                Task newTask = New Task();
                newTask.WhatId = propertyId;
                newTask.Status = 'Open';
                newTask.Subject = 'Post - OC FM Review Task';
                newTask.Type_Of_Call__c ='Pre OC Snag';
                newTask.ownerId = UserInfo.getUserId();
                newTask.activitydate = system.today().adddays(7);
                insert newTask;
                if(!taskList.isEmpty())
                {
                    List<Task> updateTaskList = New List<Task>();
                    for(Task thisTask:taskList)
                    {
                        thisTask.Status = 'Hold';
                        updateTaskList.add(thisTask);
                    }
                    system.debug('updateTaskList'+updateTaskList);
                    if(!updateTaskList.isEmpty())
                    {
                        update updateTaskList;
                    }
                    Set<String> recipientIds = New Set<String>();
                    String CRMHeadUserName = Label.CRM_Head_User;
                    User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'].Id AND isActive =: true Limit 1];
                    recipientIds.add(CRMHeadRoleObjUser.id);
                    EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName 
                                                   from EmailTemplate 
                                                   where Name = 'Customer unit Inspection With Snag' LIMIT 1];
                    emailList.add(CRMHeadRoleObjUser.Email);
                    emailList.add(propertyList.Project__r.FM_Head__r.Email);
                    recipientIds.add(CRMHeadRoleObjUser.id);
                    recipientIds.add(propertyList.Project__r.FM_Head__c);
                    String htmlBody = emailTemplate.HtmlValue;
                    String plainBody = emailTemplate.Body;
                    String Subject = emailTemplate.Subject;
                    Subject = Subject.replace('{!Property__c.Name}', propertyList.Name);
                    plainBody = plainBody.replace('{!Property__c.Name}', propertyList.Name);
                    plainBody = plainBody.replace('{projectName}', propertyList.Project__r.Name);
                    //  htmlBody = htmlBody.replace('{userName}', propertyList.Project__r.FM_Head__r.Name);
                    htmlBody = htmlBody.replace('{!Property__c.Name}', propertyList.Name);
                    htmlBody = htmlBody.replace('{projectName}', propertyList.Project__r.Name);
                    
                    EmailMessage objEmailMessage = new EmailMessage();
                    objEmailMessage.status = '3'; // email was sent
                    objEmailMessage.RelatedToId = propertyList.id;
                    objEmailMessage.fromName = 'Dynamix'; // from name
                    objEmailMessage.Subject = 'Email sent to CRM Head and FM Head for Customer found Snag';
                    objEmailMessage.HtmlBody = plainBody;
                    objEmailMessage.ToAddress = String.join(emailList, ',');
                    //objEmailMessage.FromAddress = owea.Address;
                    insertEmailMessageList.add(objEmailMessage);
                    SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,Subject,htmlBody,plainBody,emailList,null,false,propertyId,body,null,null);
                    SendEmailandBellNotificationUtility.SendBellNotification(notificationType.id,Subject,plainBody,propertyList.id, recipientIds);
                    
                }
            }
            else
            {
                propertyList.Electric_Meter_Reading__c = meterReading;
                propertyList.Customer_Inspection_End_Date__c = system.now();
                update propertyList;
            }
        }
    }
    @RemoteAction
    public static String postOC(String data,string propertyId, Decimal meterReadingValue) {
        try{
            System.debug('saving ' + data);
            // string propertyId = ApexPages.currentPage().getParameters().get('Id');
            Property__c  propertyList= [SELECT ID, NAME,Project__c,Flat_Type__c,Project__r.Name,Tower__r.Name,
                                        Unit_Type__c,Sub_Snag_Status__c, Snag_Status__c,Electric_Meter_Reading__c
                                        FROM PROPERTY__C 
                                        WHERE id =:propertyId];
            
            propertyList.Electric_Meter_Reading__c = meterReadingValue;
            Map<Id,Unit_Snag_Response__c> mapOfUnitSnagResposne = New Map<Id,Unit_Snag_Response__c>();
            
            List<Unit_Snag_Response__c> allUnitSnagList = [SELECT Id, Name, Property__c, Project_Snag__c ,Project_Snag__r.Questions__c,
                                                           Post_OC_Answers__c,Pre_OC_Answers__c,Pre_OC_End_Date__c,Area__c,Pre_OC_Remarks__c
                                                           FROM Unit_Snag_Response__c
                                                           WHERE  
                                                           Property__c =: propertyId];
            system.debug('allUnitSnagList----'+allUnitSnagList);
            Map<id,Unit_Snag_Response__c> mapOfUnitSnag = New Map<id,Unit_Snag_Response__c>();
            for(Unit_Snag_Response__c usr:allUnitSnagList)
            {
                mapOfUnitSnag.put(usr.id,usr);
            }
            List<Object> snagDetails = (List<Object>) JSON.deserializeUntyped(data);
            for (Object detail : snagDetails) {
                Map<String, Object> detailMap = (Map<String, Object>)detail;
                if (detailMap.containsKey('recordId')) {
                    String recordId = (String)detailMap.get('recordId');
                    if(mapOfUnitSnag.containsKey(recordId))
                    {
                        Unit_Snag_Response__c usr= New Unit_Snag_Response__c();
                        usr.id = (String)detailMap.get('recordId');
                        //propertyList.Post_OC_Start_Date__c = system.today();
                        if (detailMap.containsKey('CheckBox')) {
                            usr.Post_OC_Answers__c= (boolean)detailMap.get('CheckBox');
                            
                            System.debug('CheckBox: ' + (boolean)detailMap.get('CheckBox'));
                        }
                        if (detailMap.containsKey('remarks')) {
                            if( (String)detailMap.get('remarks') != '' && (String)detailMap.get('remarks') != null)
                            {
                                usr.Post_OC_Remarks__c= (String)detailMap.get('remarks');
                            }
                        }
                        mapOfUnitSnagResposne.put(usr.id,usr);
                        system.debug('mapOfUnitSnagResposne'+mapOfUnitSnagResposne);
                    }
                }
            }
            if(!mapOfUnitSnagResposne.isEmpty())
            {
                update mapOfUnitSnagResposne.values();
            }
            generateSnagDoc(propertyId,'Post-OC',meterReadingValue);
            return 'Success';
        }
        catch(Exception Ex)
        {
            system.debug('Error'+Ex.getMessage()+ex.getLineNumber());
            String error = 'Error'+Ex.getMessage();
            Return error;
        }
    }
}