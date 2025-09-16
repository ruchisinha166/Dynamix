/*
* Author : Shakti Rana
* Created Date :19 July 2023
* Description : Response Api for SAP integration.
*/

//@RestResource(urlMapping='/response/*')
public without sharing class ResponseAPIClass {
    //@HttpPost
    public static Void getResponse(HttpResponse req){
        Map<String, Object> responseBody = new Map<String, Object>();
        String responseBody1 = req.getBody();
        try{
            System.debug('responseBody1---'+responseBody1);
        	Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(responseBody1);
            List<Object> sapResponseArray = (List<Object>)requestBody.get('item');
            System.debug('responseBody1 sapResponseArray---'+sapResponseArray);
        	Set<String> success_recordIds=new Set<String>();
        	Set<String> failed_recordIds=new Set<String>();
            Map<String,responseWrapper> SFId_SapCodesMap=new Map<String,responseWrapper>();
            List<responseWrapper> for_sapGstList=new List<responseWrapper>();
            for (Object obj : sapResponseArray) {
    			Map<String, Object> item = (Map<String, Object>)obj;
    			String Status = (String)item.get('STATUS');
                System.debug('555555555.'+Status);
                if(Status=='Success'){
                    responseWrapper RW=new responseWrapper();
                    RW.SFDCID=SFValidId.repairCasing((String)item.get('SFDC_ID'));
                    RW.SapCode=(String)item.get('MATERIAL_NO');
                    RW.Pri_Customer=(String)item.get('CUSTOMER');
                    RW.VBELN=(string)item.get('VBELN');
                    RW.CUSTOMER=(String)item.get('CUSTOMER');
                    RW.LIFNR=(String)item.get('LIFNR');
                    success_recordIds.add(((String)item.get('SFDC_ID')));
                    SFId_SapCodesMap.put((String)item.get('SFDC_ID'),RW);
                    
            	}
            	else{
                	failed_recordIds.add(((String)item.get('SFDC_ID')));
            	}
        	}
           /* List<Data_Sync__c> dataSyncRecordsToUpdate=new List<Data_Sync__c>();
            if(success_recordIds.size()>0){
            	for(Data_Sync__c rec:[ select id,RecordId__c, Status__c from Data_Sync__c where RecordId__c IN :success_recordIds ]){
                	Data_Sync__c temp=new Data_Sync__c();
                	temp.id=rec.id;
                	temp.Status__c='Success';
                    temp.Response_Body__c=JSON.serialize(requestBody);
                	dataSyncRecordsToUpdate.add(temp);
            }
        }
        if(failed_recordIds.size()>0){
            for(Data_Sync__c rec:[ select id, Status__c from Data_Sync__c where RecordId__c IN :failed_recordIds]){
                Data_Sync__c temp=new Data_Sync__c();
                temp.id=rec.id;
                temp.Status__c='Error';
                temp.Response_Body__c=JSON.serialize(requestBody);
                dataSyncRecordsToUpdate.add(temp);
            	}
       		 }
            Map<String,Data_Sync__c> updateDataSyncMap=new Map<String,Data_Sync__c>();
            if(dataSyncRecordsToUpdate.size()>0){
                for(Data_Sync__c dd :dataSyncRecordsToUpdate ){
                  //  updateDataSyncMap.put(dd.id,dd);
                }
                
            }*/
            //List<Booking__c> bookListToUpdate = new List<Booking__c>();
            system.debug('SFId_SapCodesMap--> '+SFId_SapCodesMap);
            List<SObject> SAPCodeToUpdateList=new List<SObject>();
            if(!SFId_SapCodesMap.isEmpty()){
                for(String SF_Id: SFId_SapCodesMap.keySet()){
                    Id record_Id=(Id)SF_Id;
                    if(record_Id!=null){
                        Schema.SObjectType objectType = record_Id.getSObjectType();
                    	String objectName = objectType.getDescribe().getName();
                        responseWrapper RW=SFId_SapCodesMap.get(SF_Id);
                    	if(objectName=='Pricing_Plan_Components__c'){
                        	Pricing_Plan_Components__c dd=new Pricing_Plan_Components__c();
                        	dd.id=record_Id;
                        	dd.Sap_Code__c='Success';//RW.SapCode;
                        	SAPCodeToUpdateList.add(dd);
                    	}
                        else if(objectName=='Property__c'){
                            Property__c prop = new Property__c();
                            prop.Id = record_Id;
                            prop.SAP_Code__c = RW.SapCode;
                            SAPCodeToUpdateList.add(prop);
                        }
                        else if(objectName=='Co_Applicant__c'){
                            Co_Applicant__c prop = new Co_Applicant__c();
                            prop.Id = record_Id;
                            prop.SAP_Code__c = RW.Pri_Customer;
                            SAPCodeToUpdateList.add(prop);
                        }
                        else if(objectName=='Booking__c'){
                            Set<Id> deletedMilestoneIds = new Set<Id>();
                            Booking__c buk = new Booking__c();
                            buk.id = record_Id;
                            Booking__c bookToUpdate = [Select Id,SAP_Code__c from Booking__c where Id=:record_Id];
                            if(RW.VBELN != null || RW.VBELN !=''){
                                if(bookToUpdate.SAP_Code__c == null){
                                    buk.SO_Created_Date__c = system.today();
                                    buk.SAP_Code__c = RW.VBELN;
                                }
                            }
                            if(RW.CUSTOMER != null || RW.CUSTOMER !=''){
                                deletedMilestoneIds.add(buk.Unexposed_Milestone_Ids_on_Delete__c);
                                buk.Unexposed_Milestone_Ids__c = '';
                                buk.Unexposed_Milestone_Ids_on_Update__c = '';
                            }
                            if(!deletedMilestoneIds.isEmpty()){
                                List<Payment_Milestones__c> deletedMilestone = [Select Id from Payment_Milestones__c where IsDeleted=true AND Id IN:deletedMilestoneIds ALL ROWS];
                                if(!deletedMilestone.isEmpty()){
                                    Database.emptyRecycleBin(deletedMilestone);
                                }
                            }
                            SAPCodeToUpdateList.add(buk);
                        }
                        else if(objectName=='Account'){
                            Account acc=[Select Id,Partner_Id__c from Account where Id=:record_Id];
                            if(acc.Partner_Id__c==null){
                                Account acc1 = new Account();
                                acc1.Id = record_Id;
                                acc1.Partner_Id__c = RW.LIFNR;
                                SAPCodeToUpdateList.add(acc1);
                            }
                        }
                        else if(objectName=='Opportunity'){
                            Opportunity opp=[Select Id,EOI_CA_Customer_Code__c from Opportunity where Id=:record_Id];
                            if(opp.EOI_CA_Customer_Code__c==null){
                                Opportunity oppToUpdate = new Opportunity();
                                oppToUpdate.Id = opp.Id;
                                oppToUpdate.EOI_CA_Customer_Code__c = RW.CUSTOMER;
                                SAPCodeToUpdateList.add(oppToUpdate);
                            }
                        }
                        /*else if(objectName=='Payment_Milestones__c'){
                            Set<Id> bookingId = new Set<Id>();
                            Payment_Milestones__c milestone =[Select Id,Booking__c from Payment_Milestones__c where ID =:record_Id];
                            bookingId.add(milestone.Booking__c);
                            Set<Id> deletedMilestoneIds = new Set<Id>();
                            for(Booking__c book:[Select Id,Unexposed_Milestone_Ids__c,Unexposed_Milestone_Ids_on_Update__c,
                                                 Unexposed_Milestone_Ids_on_Delete__c from Booking__c where Id IN:bookingId]){
                                                     deletedMilestoneIds.add(book.Unexposed_Milestone_Ids_on_Delete__c);
                                                     book.Unexposed_Milestone_Ids__c = '';
                                                     book.Unexposed_Milestone_Ids_on_Update__c = '';
                                                     //book.Unexposed_Milestone_Ids_on_Delete__c = '';
                                                     bookListToUpdate.add(book);
                                                 }
                            if(!deletedMilestoneIds.isEmpty()){
                                List<Payment_Milestones__c> deletedMilestone = [Select Id from Payment_Milestones__c where IsDeleted=true AND Id IN:deletedMilestoneIds ALL ROWS];
                                if(!deletedMilestone.isEmpty()){
                                    Database.emptyRecycleBin(deletedMilestone);
                                }
                            }
                        }*/
                        
                    }
                    
                }
            }
            if(SAPCodeToUpdateList.size()>0){
                System.debug('SAPCodeToUpdateList*****'+SAPCodeToUpdateList);
                update SAPCodeToUpdateList;
            }
            /*if(bookListToUpdate.size()>0){
                system.debug('bookListToUpdate--> '+bookListToUpdate);
                update bookListToUpdate;
            }*/
            System.debug('success_recordIds'+success_recordIds);
            System.debug('failed_recordIds'+failed_recordIds);
        	//responseBody.put('message', 'true');
        	//res.statusCode = 200;
        	//res.responseBody = Blob.valueOf(JSON.serialize(responseBody));
        }Catch(Exception e){
            System.debug('Exception e'+e);
            System.debug('Exception:Number>> ' + e.getLineNumber());
            //responseBody.put('message', 'false');
        	//res.statusCode = 400;
        	//res.responseBody = Blob.valueOf(JSON.serialize(responseBody));
            
        }
        
    }
    public class responseWrapper {
        public String SFDCID;
        public String SapCode;
        public String Pri_Customer;
        public String VBELN;
        public String CUSTOMER;
        public String LIFNR;
    }
    

}