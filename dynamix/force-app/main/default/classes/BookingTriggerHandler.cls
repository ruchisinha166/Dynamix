public class BookingTriggerHandler {
    
    public static void kycDetailsProvidedNotificationToRM(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        if(!PreventRecursionClass.bookflag15){
            PreventRecursionClass.bookflag15 = true; 
            CustomNotificationType notifyObj = [Select Id,CustomNotifTypeName from CustomNotificationType Where DeveloperName =: 'Booking_Cancellation' limit 1];
            Set<String> recipientIds = new Set<String>();
            for(Booking__c bookObj : listOfBooking){
                if(bookObj.PAN__c && bookObj.Aadhar__c && (bookObj.PAN__c != oldMapBooking.get(bookObj.Id).PAN__c || bookObj.Aadhar__c != oldMapBooking.get(bookObj.Id).Aadhar__c)){
                    String Body = 'Dear '+bookObj.RM_Name_Formulla__c+',\n'+ 
                        'The KYC documents for Booking '+bookObj.Name+' for '+bookObj.Unit_Number__c+' for the Project '+bookObj.Project_Name_Formulla__c+' has been submitted.\n'+
                        'Kindly verify all the documents to proceed.';
                    recipientIds.add(bookObj.OwnerId);
                    SendEmailandBellNotificationUtility.SendBellNotification(
                        notifyObj.Id,
                        'KYC Documents Uploaded',
                        Body,
                        bookObj.Id,
                        recipientIds
                    );
                }
            }
        }
    }
    
    
    public static void GetBookingLastStage(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        for(Booking__c bookObj : listOfBooking){
            if(!bookObj.Cancellation_Checkbox__c && bookObj.Cancellation_Requested_Status__c == 'Retained' && bookObj.Cancellation_Requested_Status__c != oldMapBooking.get(bookObj.Id).Cancellation_Requested_Status__c){
                bookObj.Cancellation_Checkbox__c = true;
                bookObj.Last_Booking_stage__c = bookObj.Stage__c;
            }else if(bookObj.Cancellation_Checkbox__c && bookObj.Cancellation_Requested_Status__c == 'Retained' && bookObj.Cancellation_Requested_Status__c != oldMapBooking.get(bookObj.Id).Cancellation_Requested_Status__c){
                bookObj.Cancellation_Checkbox__c = true;
                bookObj.Stage__c = bookObj.Last_Booking_stage__c;
            }
        }
    }
    
    public static void UpdateBookingStatusAsRefund(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        for(Booking__c bookObj : listOfBooking){
            if( (bookObj.Refund_Instrument_Number__c != oldMapBooking.get(bookObj.Id).Refund_Instrument_Number__c )||
               (String.valueOf(bookObj.Refund_Date__c) != String.valueOf(oldMapBooking.get(bookObj.Id).Refund_Date__c) )||
               (bookObj.Refund_Bank__c != oldMapBooking.get(bookObj.Id).Refund_Bank__c )||
               (bookObj.Refund_Amount1__c != oldMapBooking.get(bookObj.Id).Refund_Amount1__c )){
                   
                   if(bookObj.Refund_Instrument_Number__c != null && String.valueOf(bookObj.Refund_Date__c) != null && bookObj.Refund_Bank__c != null &&  bookObj.Refund_Amount1__c != null){
                       bookObj.Stage__c = 'Booking Cancelled – Refund Ready';
                   }
               }
            else if(bookObj.Refund_Handover_Date__c != oldMapBooking.get(bookObj.Id).Refund_Handover_Date__c && bookObj.Refund_Handover_Date__c != null){
                bookObj.Stage__c = 'Booking Cancelled -- Refund Done';
            }
        }
    }
    public static void validateRefundFields(List<Booking__c> listOfBooking){        
        for(Booking__c bookObj : listOfBooking){            
            if( bookObj.Refund_Instrument_Number__c == null && String.valueOf(bookObj.Refund_Date__c) != null && bookObj.Refund_Bank__c == null && String.valueOf(bookObj.Refund_Amount1__c) != null){
                bookObj.addError('Please Add Values in Refund Instrument Number,Refund Bank Fields.');
            }
            if( bookObj.Refund_Instrument_Number__c != null && String.valueOf(bookObj.Refund_Date__c) == null && bookObj.Refund_Bank__c == null && String.valueOf(bookObj.Refund_Amount1__c) == null){
                bookObj.addError('Please Add Values in Refund Date,Refund Bank,Refund Amount Fields Simultaneously.');
            }
            if( bookObj.Refund_Instrument_Number__c == null && String.valueOf(bookObj.Refund_Date__c) != null && bookObj.Refund_Bank__c == null && String.valueOf(bookObj.Refund_Amount1__c) == null){
                bookObj.addError('Please Add Values in Refund Instrument Number,Refund Bank,Refund Amount Fields Simultaneously.');
            }
            if( bookObj.Refund_Instrument_Number__c == null && String.valueOf(bookObj.Refund_Date__c) == null && bookObj.Refund_Bank__c != null && String.valueOf(bookObj.Refund_Amount1__c) == null){
                bookObj.addError('Please Add Values in Refund Instrument Number,Refund Date,Refund Amount Fields Simultaneously.');
            }
            if( bookObj.Refund_Instrument_Number__c == null && String.valueOf(bookObj.Refund_Date__c) == null && bookObj.Refund_Bank__c == null && String.valueOf(bookObj.Refund_Amount1__c) != null){
                bookObj.addError('Please Add Values in Refund Instrument Number,Refund Date,Refund Bank Fields Simultaneously.');
            }
            if( bookObj.Refund_Instrument_Number__c != null && String.valueOf(bookObj.Refund_Date__c) != null && bookObj.Refund_Bank__c != null && String.valueOf(bookObj.Refund_Amount1__c) == null){
                bookObj.addError('Please Add Values in Refund Amount Fields Simultaneously.');
            }
            if( bookObj.Refund_Instrument_Number__c != null && String.valueOf(bookObj.Refund_Date__c) == null && bookObj.Refund_Bank__c != null && String.valueOf(bookObj.Refund_Amount1__c) == null){
                bookObj.addError('Please Add Values in Refund Amount,Refund Date Fields Simultaneously.');
            }
            if( bookObj.Refund_Instrument_Number__c != null && String.valueOf(bookObj.Refund_Date__c) != null && bookObj.Refund_Bank__c == null && String.valueOf(bookObj.Refund_Amount1__c) == null){
                bookObj.addError('Please Add Values in Refund Amount,Refund Bank Fields Simultaneously.');
            }
            if( bookObj.Refund_Instrument_Number__c == null && String.valueOf(bookObj.Refund_Date__c) != null && bookObj.Refund_Bank__c != null && String.valueOf(bookObj.Refund_Amount1__c) == null){
                bookObj.addError('Please Add Values in Refund Instrument Number,Refund Amount Fields Simultaneously.');
            }
            if( bookObj.Refund_Instrument_Number__c == null && String.valueOf(bookObj.Refund_Date__c) == null && bookObj.Refund_Bank__c != null && String.valueOf(bookObj.Refund_Amount1__c) != null){
                bookObj.addError('Please Add Values in Refund Instrument Number,Refund Date Fields Simultaneously.');
            }
            if( bookObj.Refund_Instrument_Number__c != null && String.valueOf(bookObj.Refund_Date__c) == null && bookObj.Refund_Bank__c == null && String.valueOf(bookObj.Refund_Amount1__c) != null){
                bookObj.addError('Please Add Values in Refund Date,Refund Bank Fields Simultaneously.');
            }
            if( bookObj.Refund_Instrument_Number__c != null && String.valueOf(bookObj.Refund_Date__c) == null && bookObj.Refund_Bank__c != null && String.valueOf(bookObj.Refund_Amount1__c) != null){
                bookObj.addError('Please Add Values in Refund Date Field.');
            }
            if( bookObj.Refund_Instrument_Number__c == null && String.valueOf(bookObj.Refund_Date__c) != null && bookObj.Refund_Bank__c == null && String.valueOf(bookObj.Refund_Amount1__c) != null){
                bookObj.addError('Please Add Values in Refund Instrument Number,Refund Bank Fields Simultaneously.');
            }
            if( bookObj.Refund_Instrument_Number__c != null && String.valueOf(bookObj.Refund_Date__c) == null && bookObj.Refund_Bank__c == null && String.valueOf(bookObj.Refund_Amount1__c) == null){
                bookObj.addError('Please Add Values in Refund Amount,Refund Date,Refund Bank Fields Simultaneously.');
            }
            if( bookObj.Refund_Instrument_Number__c == null && String.valueOf(bookObj.Refund_Date__c) == null && bookObj.Refund_Bank__c != null && String.valueOf(bookObj.Refund_Amount1__c) == null){
                bookObj.addError('Please Add Values in Refund Instrument Number,Refund Amount,Refund Date Fields Simultaneously.');
            }
            if( bookObj.Refund_Instrument_Number__c == null && String.valueOf(bookObj.Refund_Date__c) != null && bookObj.Refund_Bank__c == null && String.valueOf(bookObj.Refund_Amount1__c) == null){
                bookObj.addError('Please Add Values in Refund Instrument Number,Refund Amount,Refund Bank Fields Simultaneously.');
            }
            if( bookObj.Refund_Instrument_Number__c == null && String.valueOf(bookObj.Refund_Date__c) == null && bookObj.Refund_Bank__c == null && String.valueOf(bookObj.Refund_Amount1__c) != null){
                bookObj.addError('Please Add Values in Refund Instrument Number,Refund Date,Refund Bank Fields Simultaneously.');
            }
            if( bookObj.Refund_Instrument_Number__c == null && String.valueOf(bookObj.Refund_Date__c) != null && bookObj.Refund_Bank__c != null && String.valueOf(bookObj.Refund_Amount1__c) != null){
                bookObj.addError('Please Add Values in Refund Instrument Number Field.');
            }
            if( bookObj.Refund_Instrument_Number__c != null && String.valueOf(bookObj.Refund_Date__c) == null && bookObj.Refund_Bank__c != null && String.valueOf(bookObj.Refund_Amount1__c) != null){
                bookObj.addError('Please Add Values in Refund Date Field.');
            }
            if( bookObj.Refund_Instrument_Number__c != null && String.valueOf(bookObj.Refund_Date__c) != null && bookObj.Refund_Bank__c == null && String.valueOf(bookObj.Refund_Amount1__c) != null){
                bookObj.addError('Please Add Values in Refund Bank Field.');
            }
        }
    }
    
    
    public static void BookingCancellationUpdateProjectAddOnCharges(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        if(!PreventRecursionClass.bookflag16){
            PreventRecursionClass.bookflag16 = true; 
            Set<Id> setOfBookingIds = new Set<Id>();
            for(Booking__c bookObj : listOfBooking){
                if(bookObj.Id != null){
                    setOfBookingIds.add(bookObj.Id);
                }
            }
            Set<Id> setOfOpportuIds = new Set<Id>();
            for(Booking__c bookObj : listOfBooking){
                if(bookObj.Related_Opportunity__c != null){
                    setOfOpportuIds.add(bookObj.Related_Opportunity__c);
                }
            }
            Map<Id,Opportunity> mapIdToOpportunity = new Map<Id,Opportunity>([Select Id,Name From Opportunity Where Id In : setOfOpportuIds]);
            List<Add_On__c> listOfAddOns = new List<Add_On__c>([Select Id,Project_Add_On_Charges__c,Opportunity__c From Add_On__c Where Opportunity__c In : setOfOpportuIds]);
            Set<Id> setOfProjectAddOnIds = new Set<Id>();
            
            for(Add_On__c AddOn : listOfAddOns){
                if(AddOn.Project_Add_On_Charges__c != null){
                    setOfProjectAddOnIds.add(AddOn.Project_Add_On_Charges__c);
                }
            }
            Id carParkingRecordType = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
            List<Project_Add_On_Charges__c> listOfProjectAddOnCharges = new List<Project_Add_On_Charges__c>([Select Id,Available_Units__c,Allotted_Units__c,(Select Id,Opportunity__c From Add_On__r) From Project_Add_On_Charges__c Where RecordTypeId =: carParkingRecordType AND Id In : setOfProjectAddOnIds]);
            Map<Id,Project_Add_On_Charges__c> mapOppoIdToProjectAddOnCharge = new Map<Id,Project_Add_On_Charges__c>();
            for(Project_Add_On_Charges__c projAddOnChargeObj : listOfProjectAddOnCharges){
                if(projAddOnChargeObj.Add_On__r.size() > 0){
                    mapOppoIdToProjectAddOnCharge.put(projAddOnChargeObj.Add_On__r[0].Opportunity__c, projAddOnChargeObj);   
                }
            }
            List<Project_Add_On_Charges__c> listOfProjectAddonToUpdate = new List<Project_Add_On_Charges__c>();
            
            for(Booking__c bookObj : listOfBooking){
                if(bookObj.Cancellation_Approval_Status__c == 'Approved' && bookObj.Cancellation_Approval_Status__c != oldMapBooking.get(bookObj.Id).Cancellation_Approval_Status__c){
                    if(bookObj.Related_Opportunity__c != null){
                        if(mapOppoIdToProjectAddOnCharge.size() > 0 && mapOppoIdToProjectAddOnCharge.containsKey(bookObj.Related_Opportunity__c)){
                            Project_Add_On_Charges__c projAddOnObj = mapOppoIdToProjectAddOnCharge.get(bookObj.Related_Opportunity__c);
                            if(projAddOnObj.Allotted_Units__c != null){
                                projAddOnObj.Allotted_Units__c = projAddOnObj.Allotted_Units__c - 1;
                            }
                            if(projAddOnObj.Available_Units__c != null){
                                projAddOnObj.Available_Units__c = projAddOnObj.Available_Units__c + 1;
                            }
                            
                            listOfProjectAddonToUpdate.add(projAddOnObj);
                        }
                    }
                }
            }
            if(!listOfProjectAddonToUpdate.isEmpty()){
                update listOfProjectAddonToUpdate;
            }
        }
    }
    
    public static void BookingCancellationUpdateApprover1(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        if(!PreventRecursionClass.bookflag12){
            PreventRecursionClass.bookflag12 = true;
            for(Booking__c bookObj : listOfBooking){
                if((bookObj.Cancellation_Approval_Status__c == 'Approved' || bookObj.Cancellation_Approval_Status__c == 'Rejected' )&&( bookObj.Cancellation_Approval_Status__c != oldMapBooking.get(bookObj.Id).Cancellation_Approval_Status__c)){
                    for (ProcessInstance pi : [SELECT TargetObjectId,(SELECT Id, StepStatus, Comments FROM Steps where StepStatus =: 'Approved' OR StepStatus =: 'Rejected' ORDER BY CreatedDate DESC  LIMIT 1 ) FROM ProcessInstance WHERE TargetObjectId =: bookObj.Id])  {
                        if (pi.Steps[0].Comments == null){
                            bookObj.addError('Please provide a reason for your approval / rejection!');
                        }
                    }                 
                }
            }
        }
    }
    
    public static void BookingCancellationUpdateApprover(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        if(!PreventRecursionClass.bookflag13){
            PreventRecursionClass.bookflag13 = true; 
            String CRMHeadUserName = Label.CRM_Head_User;
            User CRMSiteHeadRoleUsers = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: [select id from UserRole where DeveloperName =: 'CRM_Head' limit 1].Id AND isActive =: true Limit 1];
            
            for(Booking__c bookObj : listOfBooking){
                if(bookObj.Booking_Cancellation__c && !oldMapBooking.get(bookObj.Id).Booking_Cancellation__c){
                    bookObj.CRM_Head__c = CRMSiteHeadRoleUsers.Id;
                }
            }
        }
    }
    public static void BookingCancellationUpdateStage(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        if(!PreventRecursionClass.bookflag14){
            PreventRecursionClass.bookflag14 = true; 
            for(Booking__c bookObj : listOfBooking){
                if(bookObj.Cancellation_Approval_Status__c == 'Approved' && bookObj.Cancellation_Approval_Status__c != oldMapBooking.get(bookObj.Id).Cancellation_Approval_Status__c && bookObj.Cancellation_Requested_Status__c == 'Unit Transfer'){
                    
                    bookObj.Stage__c = 'Booking Cancelled -- Refund Done';
                    
                }
                else if(bookObj.Cancellation_Approval_Status__c == 'Approved' && bookObj.Cancellation_Approval_Status__c != oldMapBooking.get(bookObj.Id).Cancellation_Approval_Status__c && bookObj.Cancellation_Requested_Status__c != 'Unit Transfer'){
                    bookObj.Stage__c = 'Booking Cancelled – Refund Pending';
                }
            }
        }
    }
    public static void BookingCancellationUpdateOpportunityStage(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        Set<Id> setOfBookingOppIds = new Set<Id>();
        Set<Id> setOfBookingprojectIds = new Set<Id>();
        Set<Id> setOfSuggestedPropertyIds = new Set<Id>();
        List<Suggested_Property__c> listOfSuggestedProperty = New List<Suggested_Property__c>();
        List<Suggested_Property__c> insertSuggestedProperty = New List<Suggested_Property__c>();
        for(Booking__c bookObj : listOfBooking){
            if(bookObj.Related_Opportunity__c != null && 
               bookObj.Cancellation_Approval_Status__c == 'Approved' 
               && bookObj.Cancellation_Approval_Status__c != oldMapBooking.get(bookObj.Id).Cancellation_Approval_Status__c){
                   setOfBookingOppIds.add(bookObj.Related_Opportunity__c);
                   setOfBookingprojectIds.add(bookObj.Project_Name__c);
               }
        }
        Map<Id,Opportunity> mapIdToOppo = new Map<Id,Opportunity>();
        Map<Id,ID> mapIdofNewOpportunity = new Map<Id,Id>();
        List<Opportunity> newOpportunityList =New  List<Opportunity> ();
         Map<Id,Id> projectMap = New Map<Id,Id>();
        if(!setOfBookingOppIds.isEmpty())
        {
            List<Opportunity> opportunityList = [SELECT Id, AccountId, CloseDate, Budget_Confirmed__c,Name,
                                                 Discovery_Completed__c, ROI_Analysis_Completed__c, Accompanied_By__c, 
                                                 Account_Mobile_Number__c, Browse_Internet_Mainly_For__c, Budget__c,
                                                 Channel_Partner__c, Current_Occupied_Property_Type__c, 
                                                 Current_Residence_Pincode__c, Current_Residence_Type__c,
                                                 Decision_Maker_Visited__c, Desired_Locality_For_Buying__c, 
                                                 Enter_Building_or_Locality_Name__c, Enquiry_Source_3__c, 
                                                 Expected_Downpayment_Amount__c, Expected_Timeline_to_Buy__c, 
                                                 Facing__c, Interested_Property_Type__c, 
                                                 Interested_in_Commercial_Properties__c, Miscellaneous_Unit_Configurations__c,
                                                 Mode_Of_Transport_To_Visit_The_Site__c, Nature_of_Purchase__c, Parking__c, 
                                                 Orientation__c, OwnerId__c, Possession_In__c, Preferred_Floor__c,
                                                 Preferred_Size_of_Unit_in_sq_ft__c, Project_Recommended_By_Agent__c, 
                                                 Project__c, Projects_Already_Visited__c, Property_Type__c, Rating__c,
                                                 Reason_For_Preferring_Current_Residence__c, Reason_for_lost__c, Referred_By__c,
                                                 Source__c, Source_of_Finance__c, Sourcing_Manager__c, Sub_Source__c, Unit_Type__c, 
                                                 Vastu_Preferences__c, DB_Competitor__c, Walk_in_Source__c, When_did_you_move_in_the_city__c, 
                                                 Project_No_of_Days__c, Vehicle_Owned__c, Allotment_Premium__c, Amount_in_Words__c, Apartment_Number__c, 
                                                 Carpet_Area_in_sq_ft__c, Carpet_Area_in_sq_mts__c, EOI_Amount__c, EOI_Booking__c, EOI_Date__c, 
                                                 Residential_Level__c, Sub_Source_Specification__c, Affinity_to_inventory__c, Budget1__c, Construction_Status__c,
                                                 Construction_Status_sm__c, Configuration_sm__c, Email_Id__c, Enquiry_Sub_Source__c,
                                                 Enquiry_Source__c, Industry__c, Interested_Configuration__c, Linked_Enquiry__c, Location_Picklist__c,
                                                 Nature_of_Use__c, Nature_of_Use_sm__c, Phone__c, Oppportunity_Category_SM__c, Project_Carpet_Area__c,
                                                 Referral_By_Customer__c, Referral_Mobile_Number__c, Referral_Name__c, Referral_Type__c, Revisit_Datetime__c, 
                                                 Sales_Manager__c, Secondary_Sales_Manager__c, Source_of_Funding__c, Source_of_Funding_sm__c, CP_Firm_Name__c,
                                                 Opportunity_Qualification_Tag__c, Affinity_to_inventory_checkbox__c, Accompanied_By_checkbox__c, Location__c, 
                                                 Construction_Status_checkbox__c, Alternate_Phone__c, Anniversary__c, Annual_Family_Income__c, Birthday__c, 
                                                 Budget_Picklist__c, Company_Name__c, Designation__c, Current_Apartment_Type__c, Current_Occupancy_Configuration__c, 
                                                 Ethnicity__c, Existing_Property_to_Sell__c, First_Home_or_Upgrading__c, Gender__c, IsNew__c, Is_Broker_Present_at_Site__c, 
                                                 Home_Loan_Sanction_Needed__c, Location_is_Accepted__c, Marital_Status__c, NRI__c, Nature_of_Purchase1__c, Number_of__c, 
                                                 Occupation__c, Preferred_Possession_Timeline__c, Preferred_View__c, Spouse_Work_Location__c, Status__c, Work_Location__c,
                                                 EOI_CA_Approval_Stages__c, EOI_CA_End_Date__c, EOI_CA_Form_Sent_Date_Time__c, EOI_CA_Form_Submission_Date_and_Time__c, 
                                                 EOI_CA_Form_Submission_OTP__c, EOI_CA__c, EOI_CA_stage__c, EOI_CA_Payment_Received__c, EOI_CA_Approved_Payment__c, 
                                                 Payment_Received_from_Customer__c, EOI_AutoNumber__c, CA_Auto_Number__c, Floor_Preference__c, EOI_CA_Number__c, 
                                                 Refund_Amount1__c, Refund_Bank__c, Refund_Date__c, Refund_Handover_Date__c, Refund_Instrument_Number__c, Refund_Reason__c, 
                                                 EOI_Refund_Payment_Status__c, EOI_CA_Customer_Code__c,ownerId
                                                 FROM Opportunity where Id IN : setOfBookingOppIds];
            List<Project__c> projectList = [SELECT Id, Site_Head__c FROM Project__c 
                                            WHERE Id IN :setOfBookingprojectIds];
           
            if(!projectList.isEmpty()){
                for(Project__c thisProject:projectList)
                {
                    if(thisProject.Site_Head__c !=  null)
                    {
                        projectMap.put(thisProject.id,thisProject.Site_Head__c);
                    }
                    
                }
            }
            if(!opportunityList.isEmpty())
            {
                for(Opportunity thisOpportunity : opportunityList)
                {
                    mapIdToOppo.put(thisOpportunity.id,thisOpportunity);
                }                
            }
            
            //mapIdToOppo = new Map<Id,Opportunity>([Select Id,OwnerId From Opportunity where Id IN : setOfBookingOppIds]);
            
        }
        CustomNotificationType notifyObj = [Select Id,CustomNotifTypeName from CustomNotificationType Where DeveloperName =: 'Booking_Cancellation' limit 1];
        List<Booking__c> bookToUpdate = new List<Booking__c>();
        List<Opportunity> listOfOppo = new List<Opportunity>(); 
        Set<String> recipientIds = New  Set<String>();
        for(Booking__c bookObj : listOfBooking){
            if(bookObj.Cancellation_Approval_Status__c == 'Approved' && bookObj.Cancellation_Approval_Status__c != oldMapBooking.get(bookObj.Id).Cancellation_Approval_Status__c){
                if(mapIdToOppo.size() > 0 && mapIdToOppo.containsKey(bookObj.Related_Opportunity__c)){
                    Opportunity oppObj = mapIdToOppo.get(bookObj.Related_Opportunity__c);
                    oppObj.StageName = 'Closed Lost';
                    oppObj.Reason_for_lost__c = bookObj.Cancellation_Reasons__c;
                    listOfOppo.add(oppObj);
                    if(bookObj.Cancellation_Requested_Status__c == 'Unit Transfer')
                    {
                        recipientIds = New Set<String>();
                        setOfSuggestedPropertyIds.add(bookObj.Related_Suggested_Property__c);
                        Opportunity clonedOpportunity = oppObj.clone(false, true, false, false);
                        clonedOpportunity.StageName = 'Site Visit Done';
                        clonedOpportunity.Transfer_Opportunity__c = true;
                        clonedOpportunity.Reason_for_lost__c ='';
                        clonedOpportunity.EOI_CA_Customer_Code__c = '';
                        clonedOpportunity.Transfer_Opportunity_Lookup__c = oppObj.id;
                        clonedOpportunity.OwnerId = bookObj.OwnerId;
                        newOpportunityList.add(clonedOpportunity);
                        if(bookObj.Sourcing_Manager__c != null)
                        {
                            recipientIds.add(bookObj.Sourcing_Manager__c);
                        }
                        if(bookObj.OwnerId != null){
                            recipientIds.add(bookObj.OwnerId);
                        }
                        if(oppObj.ownerId != null)
                        {
                            recipientIds.add(oppObj.ownerId);
                        }
                        if(projectMap.containsKey(bookObj.Project_Name__c))
                        {
                             recipientIds.add(projectMap.get(bookObj.Project_Name__c));
                        }
                        SendEmailandBellNotificationUtility.SendBellNotification(
                            notifyObj.Id,
                            'Booking - '+  bookObj.Name+' Unit Transfer Approved',
                            'Booking Unit Transfer has been approved.\n Customer Name:- '+bookObj.Primary_Applicant_Name_Formulla__c + '\n Unit Number:- '+ bookObj.Unit_Number__c+'\nReason:- Unit Transfer\n Sub Reason:- Unit Transfer',
                            bookObj.Id,
                            recipientIds
                    );
                    }
                    else
                    {
                        setOfBookingOppIds.remove(bookObj.Related_Opportunity__c);
                    }
                    
                }
            }
        }
        if(!listOfOppo.isEmpty()){
            update listOfOppo;
        }
        if(!newOpportunityList.isEmpty()){
            insert newOpportunityList;
        }
        if(!setOfSuggestedPropertyIds.isEmpty())
        {
            listOfSuggestedProperty = [SELECT Name, Id, Unit__c, Opportunity__c, Discount__c
                                       FROM Suggested_Property__c 
                                       WHERE Id IN: setOfSuggestedPropertyIds];
        }
        if(!listOfSuggestedProperty.isEmpty() && !newOpportunityList.isEmpty())
        {
            
            List<EOI_CA_Payment__c> eoiCaPayment =[SELECT Opportunity__c, Amount__c, Bank_Name1__c, Bank_Name__c, Bank_value_date__c, 
                                                   Branch_Name__c, Cheque_Transaction_Number__c, Cheque__c, Credit_Note_Reason__c,
                                                   Date__c, GST__c, IFSC_Code__c, Paid_By__c, Payment_Category__c, Payment_Date__c,
                                                   Payment_Description__c, Payment_Mode__c, Payment_Status__c, Payment_Type__c,
                                                   Receipt_No__c, Ref_No__c, Reference_No__c, Refund_Type__c, Related_Suggested_Property__c,
                                                   Remaining_TDS_Amount__c, SAP_Approved_Rejected_Date__c, Sap_code__c, Status__c, TDS__c,
                                                   Today_Date__c, Cheque_Status__c, Reason_for_reject__c, Receipt_No_Hidden__c, 
                                                   Primary_Applicant__c, EOI_CA_Payment__c, Id, Name 
                                                   FROM EOI_CA_Payment__c
                                                   WHERE Opportunity__c IN: setOfBookingOppIds];
            for(Opportunity thisOpportunity : newOpportunityList)
            {
                mapIdofNewOpportunity.put(thisOpportunity.Transfer_Opportunity_Lookup__c,thisOpportunity.id);
            }
            Map<id,Property__c> updateProperty = New Map<id,Property__c>();
            for(Suggested_Property__c thisSP :listOfSuggestedProperty)
            {
                if(mapIdofNewOpportunity.containskey(thisSP.Opportunity__c))
                {
                    Suggested_Property__c clonedSP = thisSP.clone(false, true, false, false);
                    clonedSP.Opportunity__c = mapIdofNewOpportunity.get(thisSP.Opportunity__c);
                    clonedSP.Status__c = 'Short Listed';
                    clonedSP.Payment_Plan__c = null;
                    clonedSP.Payment_Plan_Detail__c = '';
                    clonedSP.Cost_Sheet_Link__c = '';
                    clonedSP.Cost_Sheet_Provided__c = false;
                    clonedSP.Discount__c = thisSP.Discount__c;
                    insertSuggestedProperty.add(clonedSP);  
                    if(thisSP.Unit__c != null)
                    {
                        Property__c property = New  Property__c();
                        property.Property_Status__c = 'Available'; 
                        property.id = thisSP.Unit__c;
                        updateProperty.put(property.id,property);
                    }
                }
            }
            if(!eoiCaPayment.isEmpty()){
                List<EOI_CA_Payment__c> insertPayment = New List<EOI_CA_Payment__c>();
                for(EOI_CA_Payment__c thisPayment :eoiCaPayment)
                {
                    if(mapIdofNewOpportunity.containskey(thisPayment.Opportunity__c))
                    {
                        EOI_CA_Payment__c clonedPayment = thisPayment.clone(false, true, false, false);
                        clonedPayment.Opportunity__c = mapIdofNewOpportunity.get(thisPayment.Opportunity__c);
                        insertPayment.add(clonedPayment);  
                    }
                }
                if(!insertPayment.isEmpty()){
                    insert insertPayment;
                }
            }
            if(!insertSuggestedProperty.isEmpty()){
                insert insertSuggestedProperty;
            }
            if(!updateProperty.isEmpty()){
                update updateProperty.values();
            }
        }
    }
    public static void SubmitBookingForCancellation(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        if(!PreventRecursionClass.bookflag17){
            PreventRecursionClass.bookflag17 = true; 
            String CRMHeadUserName = Label.CRM_Head_User;
            User CRMSiteHeadRoleUsers = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: [select id from UserRole where DeveloperName =: 'CRM_Head' limit 1].Id AND isActive =: true Limit 1];
            
            for(Booking__c bookObj : listOfBooking){
                if(bookObj.Booking_Cancellation__c && !oldMapBooking.get(bookObj.Id).Booking_Cancellation__c){
                    
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting Request for Booking Cancellation.');
                    req1.setObjectId(bookObj.id);
                    req1.setSubmitterId(bookObj.OwnerId); 
                    req1.setProcessDefinitionNameOrId('Booking_Cancellation_Approval');
                    req1.setSkipEntryCriteria(true);
                    Approval.ProcessResult result = Approval.process(req1);
                }
            }
        }
    }
    public static void BookingCancellationNotification(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        if(!PreventRecursionClass.bookflag10){
            PreventRecursionClass.bookflag10 = true;
            
            CustomNotificationType notifyObj = [Select Id,CustomNotifTypeName from CustomNotificationType Where DeveloperName =: 'Booking_Cancellation' limit 1];
            List<EmailTemplate> emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName =: 'Booking_Cancellation_Approved_RM' OR DeveloperName =: 'Booking_Cancellation_RejectedRM' limit 2];
            
            Map<String,EmailTemplate> mapNameToTemplte = new Map<String,EmailTemplate>();
            for(EmailTemplate template : emailTemplate){
                mapNameToTemplte.put(template.DeveloperName, template);
            }
            
            Set<String> siteHeadUsersIds=new Set<String>();
            for(Booking__c bookObj1 : listOfBooking){
                siteHeadUsersIds.add(bookObj1.Related_Suggested_Property__r.Site_Head__c);
            }
            
            String CRMHeadUserName = Label.CRM_Head_User;
            // String SiteHeadUserName = Label.Site_Head_User_Name;
            
            List<User> CRMSiteHeadRoleUsers = [Select Id,Name,Email From User Where  
                                               ((UserName =: CRMHeadUserName AND UserRoleId =: [select id from UserRole where DeveloperName =: 'CRM_Head' limit 1].Id) OR
                                                (Id =: siteHeadUsersIds)) AND
                                               isActive =: true Limit 2];
            
            Set<String> recipientId = new Set<String>();
            for(User userObj : CRMSiteHeadRoleUsers){
                recipientId.add(userObj.Id);
            }
            
            Set<Id> setOfBookingOWnerIds = new Set<Id>();
            for(Booking__c bookObj : listOfBooking){
                setOfBookingOWnerIds.add(bookObj.OwnerId);
            }
            
            Map<Id,Opportunity> mapIdToOppo = new Map<Id,Opportunity>([Select Id,OwnerId From Opportunity]);
            
            Set<Id> setOfOppoOwnerIds = new Set<Id>();
            for(Booking__c bookObj : listOfBooking){
                if(bookObj.Related_Opportunity__c != null){
                    setOfOppoOwnerIds.add(mapIdToOppo.get(bookObj.Related_Opportunity__c).OwnerId);
                }
            }
            
            Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Email From User Where isActive =: true AND( Id IN : setOfBookingOWnerIds OR Id IN : setOfOppoOwnerIds )]);
            
            List<String> addresses1 = new List<String>();
            List<String> addresses2 = new List<String>();
            
            for(User userObj : CRMSiteHeadRoleUsers){
                addresses2.add(userObj.Email);
            }
            
            for(Booking__c bookObj : listOfBooking){
                
                if(bookObj.Cancellation_Approval_Status__c == 'Rejected' && bookObj.Cancellation_Approval_Status__c != oldMapBooking.get(bookObj.Id).Cancellation_Approval_Status__c){
                    
                    Set<String> recipientIds = new Set<String>();
                    recipientIds.add(bookObj.OwnerId);
                    
                    SendEmailandBellNotificationUtility.SendBellNotification(
                        notifyObj.Id,
                        'Booking Cancellation Rejected',
                        'Booking Cancellation Approval Rejected. Modify Cancellation Checklist.',
                        bookObj.Id,
                        recipientIds
                    );
                    EmailTemplate temp1 =  mapNameToTemplte.get('Booking_Cancellation_RejectedRM');
                    String htmlBody = temp1.HtmlValue;
                    String plainBody = temp1.Body;
                    String Subject = temp1.Subject;
                    Subject = bookObj.Name + ' ' + Subject;
                    addresses1.add(mapIdToUser.get(bookObj.OwnerId).Email);
                    
                    SendEmailandBellNotificationUtility.SendEmail3(String.ValueOf(temp1.Id),Subject,htmlBody,plainBody,addresses1,null,true,bookObj.Id,null,null,null);
                    
                } 
                if(bookObj.Cancellation_Approval_Status__c == 'Approved' && bookObj.Cancellation_Approval_Status__c != oldMapBooking.get(bookObj.Id).Cancellation_Approval_Status__c){
                    
                    recipientId.add(bookObj.OwnerId);
                    if(mapIdToOppo.size() > 0 && mapIdToOppo.containsKey(bookObj.Related_Opportunity__c)){
                        recipientId.add(mapIdToOppo.get(bookObj.Related_Opportunity__c).OwnerId);
                    }
                    SendEmailandBellNotificationUtility.SendBellNotification(
                        notifyObj.Id,
                        'Booking Cancellation Approved',
                        'Booking Cancellation Approval Approved.',
                        bookObj.Id,
                        recipientId
                    );
                    
                    EmailTemplate temp1 =  mapNameToTemplte.get('Booking_Cancellation_Approved_RM');
                    
                    String htmlBody = temp1.HtmlValue;
                    String plainBody = temp1.Body;
                    String Subject = temp1.Subject;
                    Subject = bookObj.Name + ' ' + Subject;
                    
                    addresses2.add(mapIdToUser.get(bookObj.OwnerId).Email);
                    Opportunity opp = mapIdToOppo.get(bookObj.Related_Opportunity__c);
                    addresses2.add(mapIdToUser.get(opp.OwnerId).Email);
                    
                    SendEmailandBellNotificationUtility.SendEmail3(String.ValueOf(temp1.Id),Subject,htmlBody,plainBody,addresses2,null,true,bookObj.Id,null,null,null);
                }
            }
        }
    }
    
    //Send Email To RM AND CRM Head If First Disbursement Values Changes
    public static void sendEmailToRMANDCRMHeadIfFirstDisbursementValuesChanges(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        System.debug('In sendEmailToRMANDCRMHeadIfFirstDisbursementValuesChanges');
        if(!PreventRecursionClass.bookflag7){
            PreventRecursionClass.bookflag7 = true;
            
            Set<Id> setOfBookingOwnerIds = new Set<Id>();
            for(Booking__c bookObj : listOfBooking){
                setOfBookingOwnerIds.add(bookObj.OwnerId);
            }
            
            System.debug('In PreventRecursionClass.bookflag7');
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'First_Disbursement_Values_Updated' limit 1];
            System.debug('In emailTemplate'+emailTemplate);
            String CRMHeadUserName = Label.CRM_Head_User;
            System.debug('In CRMHeadUserName'+CRMHeadUserName);
            User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: [select id from UserRole where DeveloperName =: 'CRM_Head' limit 1].Id AND isActive =: true Limit 1];
            List<String> addresses = new List<String>();
            addresses.add(CRMHeadRoleObjUser.Email);     
            System.debug('In addresses'+CRMHeadRoleObjUser.Email);
            
            Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Email From User Where isActive =: true AND Id IN : setOfBookingOwnerIds]);
            for(Booking__c bookObj : listOfBooking){
                System.debug('In bookObj'+bookObj);
                if(bookObj.Amount_of_First_Disbursement__c != oldMapBooking.get(bookObj.Id).Amount_of_First_Disbursement__c ||
                   bookObj.Date_of_First_Disbursement__c != oldMapBooking.get(bookObj.Id).Date_of_First_Disbursement__c){
                       
                       addresses.add(mapIdToUser.get(bookObj.OwnerId).Email);
                       System.debug('In bookObj.Owner.Email'+bookObj.Owner.Email);
                       String htmlBody1 = emailTemplate.HtmlValue;
                       
                       if(bookObj.Amount_of_First_Disbursement__c != null){
                           htmlBody1 = htmlBody1.replace('AM', String.valueOf(bookObj.Amount_of_First_Disbursement__c));
                       }
                       else{
                           htmlBody1 = htmlBody1.replace('AM', '0');
                       }
                       if(bookObj.Date_of_First_Disbursement__c != null){
                           htmlBody1 = htmlBody1.replace('DA', String.valueOf(bookObj.Date_of_First_Disbursement__c));
                       }
                       else{
                           htmlBody1 = htmlBody1.replace('DA', 'null');
                       }
                       htmlBody1 = htmlBody1.replace('BK',bookObj.Name );
                       String plainBody1 = emailTemplate.Body;
                       
                       if(bookObj.Amount_of_First_Disbursement__c != null){
                           plainBody1 = plainBody1.replace('AM', String.valueOf(bookObj.Amount_of_First_Disbursement__c));
                       }
                       else{
                           plainBody1 = plainBody1.replace('AM', '0');
                       }
                       if(bookObj.Date_of_First_Disbursement__c != null){
                           plainBody1 = plainBody1.replace('DA', String.valueOf(bookObj.Date_of_First_Disbursement__c)); 
                       }
                       else{
                           plainBody1 = plainBody1.replace('DA', 'null'); 
                       }
                       plainBody1 = plainBody1.replace('BK',bookObj.Name );
                       String Subject = bookObj.Name + ' ' + emailTemplate.Subject;
                       System.debug('In Subject'+Subject);
                       SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,Subject,htmlBody1,plainBody1,addresses,null,true,bookObj.Id,null,null,null);
                   }
            }
        }
    }
    
    
    public static void createBankLoanDetailsRecord(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        if(!PreventRecursionClass.bookflag6){
            PreventRecursionClass.bookflag6 = true;    
            List<Bank_Loan_Details__c> listOfLoans = new List<Bank_Loan_Details__c>(); 
            for(Booking__c bookObj : listOfBooking){
                if(bookObj.Source_of_Finance__c == 'Loan from Bank' && oldMapBooking.get(bookObj.Id).Source_of_Finance__c != 'Loan from Bank'){
                    Bank_Loan_Details__c bankLoanObj = new Bank_Loan_Details__c();
                    bankLoanObj.Booking__c = bookObj.Id;
                    listOfLoans.add(bankLoanObj);
                }
            }
            if(!listOfLoans.isEmpty()){
                insert listOfLoans;
            }
        }
    }
    
    public static void UpdateClodeDraftAgreementDate(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        if(!PreventRecursionClass.flag3){
            PreventRecursionClass.flag3 = true;
            for(Booking__c bookObj : listOfBooking){
                if(bookObj.Primary_Secondary_info_Updated__c && !oldMapBooking.get(bookObj.Id).Primary_Secondary_info_Updated__c){
                    bookObj.Close_Draft_Agreement_Task__c = System.now();
                }
            }
        }
    }
    public static void SDRLetterSharedDateToday(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        if(!PreventRecursionClass.bookflag1){
            PreventRecursionClass.bookflag1 = true;
            for(Booking__c bookObj : listOfBooking){
                if(bookObj.Shared_SDR_Letter__c && !oldMapBooking.get(bookObj.Id).Shared_SDR_Letter__c){
                    bookObj.SDR_Letter_Sent_Date__c = System.today();
                }
            }
        }
    }
    public static void whenWelcomeEmailCheckBoxTrueSDRPopulateInitiatedDate(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        PreventRecursionClass.WelcomeEmailCheckerMethodCnt++;
        if(!PreventRecursionClass.bookflag2){
            if(PreventRecursionClass.WelcomeEmailCheckerMethodCnt==2){
                PreventRecursionClass.bookflag2 = true;
            }
            for(Booking__c bookObj : listOfBooking){
                if((bookObj.Welcome_Email_Checker__c && !oldMapBooking.get(bookObj.Id).Welcome_Email_Checker__c) && bookObj.Stamp_Duty_Status__c!='Dynamix'){
                    bookObj.SDR_Inititated_Date__c = System.today();
                }
            }
        }
    }
    
    public static void createSDRLetterTask(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        System.debug('In createSDRLetterTask');
        PreventRecursionClass.sdrMethodCnt++;
        if(!PreventRecursionClass.bookflag3){
            System.debug('In createSDRLetterTask 1');
            if(PreventRecursionClass.sdrMethodCnt==2){
                PreventRecursionClass.bookflag3 = true;
            }
            CustomNotificationType notifyObj = [Select Id,CustomNotifTypeName from CustomNotificationType Where DeveloperName =: 'Notification_To_RM' limit 1];
            
            Set<Id> SetOfRMIds = new Set<Id>();
            for(Booking__c bookObj : listOfBooking){
                SetOfRMIds.add(bookObj.OwnerId);
            }
            Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name,Email From User Where Id In : SetOfRMIds]);
            
            List<Task> listOftaskToInsert = new List<Task>();
            for(Booking__c bookObj : listOfBooking){
                if(bookObj.Stamp_Duty_Status__c!='Dynamix' && (bookObj.Welcome_Email_Checker__c && !oldMapBooking.get(bookObj.Id).Welcome_Email_Checker__c)){
                    Task SDRTask = new Task();
                    SDRTask.OwnerId = bookObj.OwnerId;
                    SDRTask.Status = 'Pending';
                    SDRTask.Subject = 'SDR Letter for the Booking';
                    SDRTask.ActivityDate = System.today().addDays(7);
                    SDRTask.WhatId = bookObj.Id;
                    listOftaskToInsert.add(SDRTask);
                    String Body = 'Dear '+ mapIdToUser.get(bookObj.OwnerId).Name + ',\n'+
                        'The SDR letter for ' + bookObj.Unit_Number__c + ' in ' + bookObj.Project_Name_Formulla__c +
                        ' has been created in the system.\nKindly share the same with customer.';
                    Set<String> recipientIds = new Set<String>();
                    recipientIds.add(bookObj.OwnerId);
                    SendEmailandBellNotificationUtility.SendBellNotification(
                        notifyObj.Id,
                        'SDR letter task is assigned to you.',
                        Body,
                        bookObj.Id,
                        recipientIds
                    );
                    
                }
            }
            
            if(!listOftaskToInsert.isEmpty()){
                insert listOftaskToInsert;
            }
        }
    }
    public static void changeSDRLetterTaskStatusAsSent(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        
        if(!PreventRecursionClass.bookflag4){
            PreventRecursionClass.bookflag4 = true;
            Set<Id> setOfBookingIds = new Set<Id>(); 
            for(Booking__c bookObj : listOfBooking){
                setOfBookingIds.add(bookObj.Id);
            }
            List<Task> listOfSDRLetterTask = new List<Task>([Select Id,Status,Subject,WhatId From Task Where Subject =: 'SDR Letter for the Booking' AND whatId In : setOfBookingIds]);
            System.debug('listOfSDRLetterTask'+listOfSDRLetterTask);
            Map<Id,Task> mapBookingIdToSDRLetterTask = new Map<Id,Task>();
            for(Task taskObj : listOfSDRLetterTask){
                mapBookingIdToSDRLetterTask.put(taskObj.WhatId,taskObj);
            }
            System.debug('mapBookingIdToSDRLetterTask'+mapBookingIdToSDRLetterTask);
            List<Task> listOfSDRLetterTaskToUpdate = new List<Task>();
            for(Booking__c bookObj : listOfBooking){
                System.debug('bookObj'+bookObj);
                if(bookObj.Shared_SDR_Letter__c && !oldMapBooking.get(bookObj.Id).Shared_SDR_Letter__c){
                    System.debug('bookObj.Shared_SDR_Letter__c'+bookObj.Shared_SDR_Letter__c);
                    if(mapBookingIdToSDRLetterTask.size() > 0 && mapBookingIdToSDRLetterTask.containsKey(bookObj.Id)){
                        System.debug('In Map mapBookingIdToSDRLetterTask'+mapBookingIdToSDRLetterTask);
                        Task SDRLetterTask = mapBookingIdToSDRLetterTask.get(bookObj.Id);
                        SDRLetterTask.Status = 'Sent';
                        listOfSDRLetterTaskToUpdate.add(SDRLetterTask);
                    }
                }
            }
            if(!listOfSDRLetterTaskToUpdate.isEmpty()){
                update listOfSDRLetterTaskToUpdate;
            }
        }
    }
    
    //Send Email To CRM Head And Bell Notification To RM
    public static void closeDraftTaskAndSendNotificationAndEmail(List<Booking__c> listOfBooking,Map<Id,Booking__c> oldMapBooking){
        
        if(!PreventRecursionClass.bookflag5){
            PreventRecursionClass.bookflag5 = true;
            Set<Id> setOfBookingIds = new Set<Id>(); 
            for(Booking__c bookObj : listOfBooking){
                setOfBookingIds.add(bookObj.Id);
            }
            System.debug('setOfBookingIds'+setOfBookingIds);
            List<Task> listOfDraftAgreementTask = new List<Task>([Select Id,Status,Subject,WhatId From Task Where Subject =: 'Generate Draft Agreement' AND whatId In : setOfBookingIds]);
            System.debug('listOfDraftAgreementTask'+listOfDraftAgreementTask);
            Map<Id,Task> mapBookingIdToDraftAgreementTask = new Map<Id,Task>();
            for(Task taskObj : listOfDraftAgreementTask){
                mapBookingIdToDraftAgreementTask.put(taskObj.WhatId,taskObj);
            }
            System.debug('mapBookingIdToDraftAgreementTask'+mapBookingIdToDraftAgreementTask);
            List<Task> listOfAgreementTaskToUpdate = new List<Task>();
            CustomNotificationType notifyObj = [Select Id,CustomNotifTypeName from CustomNotificationType Where DeveloperName =: 'Notification_To_RM' limit 1];
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'Primary_Secondary_info_Updated' limit 1];
            UserRole CRMHeadRoleObj = [select id,Name,DeveloperName from UserRole where DeveloperName =: 'CRM_Head'];
            String CRMHeadUserName = Label.CRM_Head_User;
            User CRMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: CRMHeadUserName AND UserRoleId =: CRMHeadRoleObj.Id AND isActive =: true Limit 1];
            List<String> addresses = new List<String>();
            addresses.add(CRMHeadRoleObjUser.Email);     
            System.debug('Before Loop'+addresses);
            
            Set<Id> setOfRMIds = new Set<Id>();
            for(Booking__c bookObj : listOfBooking){
                setOfRMIds.add(bookObj.OwnerId);
            }
            Map<Id,User> mapIdToUser = new Map<Id,User>([Select Id,Name From User where Id In : setOfRMIds]);
            for(Booking__c bookObj : listOfBooking){
                System.debug('bookObj');
                if(bookObj.Primary_Secondary_info_Updated__c && !oldMapBooking.get(bookObj.Id).Primary_Secondary_info_Updated__c){
                    System.debug('bookObj.Primary_Secondary_info_Updated__c'+bookObj.Primary_Secondary_info_Updated__c);
                    if(mapBookingIdToDraftAgreementTask.size() > 0 && mapBookingIdToDraftAgreementTask.containsKey(bookObj.Id)){
                        System.debug('In Map ');
                        Task draftTask = mapBookingIdToDraftAgreementTask.get(bookObj.Id);
                        draftTask.Status = 'Completed';
                        listOfAgreementTaskToUpdate.add(draftTask);
                        
                        Set<String> recipientIds = new Set<String>();
                        recipientIds.add(bookObj.OwnerId);
                        
                        String Body = 'Dear '+ mapIdToUser.get(bookObj.OwnerId).Name + ',\n' +
                            'The Draft Agreement Letter against Booking ' + bookObj.Name + ' for '+
                            bookObj.Unit_Number__c + ' in ' + bookObj.Project_Name_Formulla__c + ' has been closed.\n'+
                            'The Primary and Secondary Applicant/s details have been updated in the system.';
                        
                        SendEmailandBellNotificationUtility.SendBellNotification(
                            notifyObj.Id,
                            'Primary/Secondary Info Updated',
                            Body,
                            bookObj.Id,
                            recipientIds
                        );
                        String htmlBody = emailTemplate.HtmlValue;
                        htmlBody = htmlBody.replace('{!RM}', CRMHeadRoleObjUser.Name);
                        htmlBody = htmlBody.replace('{!Name}', bookObj.Name);
                        if(bookObj.Unit_Number__c != null){
                            htmlBody = htmlBody.replace('{!Unit}', bookObj.Unit_Number__c);
                        }
                        if(bookObj.Project_Name_Formulla__c != null){
                            htmlBody = htmlBody.replace('{!Project}', bookObj.Project_Name_Formulla__c);
                        }
                        /*  SendEmailandBellNotificationUtility.SendEmail(
String.valueOf(emailTemplate.Id),
htmlBody,
'',
addresses,
null
);*/
                        SendEmailandBellNotificationUtility.SendEmail3(emailTemplate.Id,
                                                                       emailTemplate.Subject, 
                                                                       htmlBody, 
                                                                       '', 
                                                                       addresses, 
                                                                       null, 
                                                                       true, 
                                                                       bookObj.Id, 
                                                                       null, 
                                                                       null, 
                                                                       null);
                    }
                }
            }
            if(!listOfAgreementTaskToUpdate.isEmpty()){
                update listOfAgreementTaskToUpdate;
            }
        }
    }
    
    
    
    public static boolean isFirstTime = true;
    
    @future(callout=true)
    public static void generateWelcomeLetter(string bookingld)
    {
        PageReference ref = Page.WelcomeMailForBooking; 
        ref.getParameters().put('id',bookingld);
        Blob body;
        
        if(Test.isRunningTest())
        {
            body = Blob.valueOf('Allotment');
        }
        else
        {
            body = ref.getContent();
        }
    }
    
    @future(callout=true)
    public Static void generateNOCLetter(string bookingl)
    {
        
        list<Booking__c> bookingList =(List<Booking__c >)JSON.deserialize(bookingl, List<Booking__c>.class);
        List<Bank_Loan_Details__c> blList = new List<Bank_Loan_Details__c> ();
        set<Id> PrLoandbookid = new set<Id>();
        for(Booking__c  b : bookingList)
        {
            PrLoandbookid.add(b.Primary_Loan_Details__c);
        }
        List<Bank__c> bank = new list<Bank__c>();
        if(PrLoandbookid != null)
        {
            blList  = [select id,Booking__c,Home_LoanInstitution__r.Name from Bank_Loan_Details__c where id IN : PrLoandbookid];
        }
        Map<ID,Bank_Loan_Details__c> MapOfBookLoan = New Map<Id,Bank_Loan_Details__c>();
        for(Bank_Loan_Details__c b : blList)
        {
            MapOfBookLoan.put(b.Booking__c,b);
        }
        for(Booking__c b : bookingList)
        {
            if(MapOfBookLoan.containskey(b.id))
            {
                PageReference ref;
                if(MapOfBookLoan.get(b.id).Home_LoanInstitution__r.Name != null)
                {
                    system.debug('===> Bank name ' + MapOfBookLoan.get(b.id).Home_LoanInstitution__r.Name);
                    if(MapOfBookLoan.get(b.id).Home_LoanInstitution__r.Name.contains('HDFC'))
                    {
                        ref = Page.HDFCNOCDocument;
                        ref.getParameters().put('id',b.id);
                    }
                    else if(MapOfBookLoan.get(b.id).Home_LoanInstitution__r.Name.contains('ICICI'))
                    {
                        ref = Page.HDFCNOCDocument;
                        ref.getParameters().put('id',b.id);
                    }
                    Blob body; 
                    if(Test.isRunningTest()){
                        body = Blob.valueOf('NOC');
                    }
                    else{
                        body = ref.getContent();
                    }
                    ContentVersion conVer = new ContentVersion();
                    conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
                    conVer.PathOnClient = MapOfBookLoan.get(b.id).Home_LoanInstitution__r.Name + '/' + 'NOC' + '.pdf'; 
                    conVer.Title = MapOfBookLoan.get(b.id).Home_LoanInstitution__r.Name + '/' + 'NOC' + '.pdf';
                    conVer.VersionData = body;
                    conVer.SObjectType__c = 'Booking__c';
                    conVer.Document_Type__c = 'Bank NOC';
                    insert conVer;    
                    system.debug('conVer' + conVer);
                    
                    ContentVersion contentverlink = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :conVer.Id LIMIT 1];
                    ContentDocumentLink contentlink = new ContentDocumentLink();
                    contentlink.LinkedEntityId = b.id;
                    contentlink.contentdocumentid = contentverlink.contentdocumentid;
                    contentlink.ShareType = 'V';
                    insert contentlink;
                    system.debug(contentlink);
                }
            }
        }
    }
    public Static void updateBrokerDetails(list<booking__c> bookinglist)
    {
        set<ID> PId = new set<ID>();
        for(booking__c b : bookingList)
        {
            PId .add(b.Project_Name__c);
        }
        //Map<ID, Project__c> m = new Map<ID, Project__c>([SELECT Id, Name FROM Project__c where id IN: PId ]);
        Map<ID, Brokerage_Ladder__c> brokerMap = new Map<ID, Brokerage_Ladder__c>([SELECT Id,Unit_Count__c,RecordType.Name,Percentage__c,RecordTypeId,Project__c,Project__r.Project_Status__c, Name FROM Brokerage_Ladder__c where Project__c IN: PId ORDER BY Unit_Count__c ASC]);
        Map<ID, booking__c> bookingMap =  new  Map<ID, booking__c>();
        
        for(booking__c b : bookingList)
        {
            for(Brokerage_Ladder__c broker : brokerMap .values())
            { 
                if(broker.Project__r.Project_Status__c=='Sustenance' && b.Project_Name__c==broker.Project__c)
                {
                    b.Brokerage_Percentage__c=broker.Percentage__c;
                }
                else
                {
                    
                    list<booking__c> bList = new list<booking__c>();
                    bList = [select id,Channel_Partner__c,Brokerage_Percentage__c  from booking__c where Channel_Partner__c=:b.Channel_Partner__c ];
                    if(bList.size()<broker.Unit_Count__c)
                    {
                        b.Brokerage_Percentage__c =broker.Percentage__c;
                        for(booking__c book : bList)
                        {
                            book.Brokerage_Percentage__c =broker.Percentage__c;
                            bookingMap.put(book.id,book);
                        }
                        break;
                        //system.debug('percentage=='+percentage); 
                    }                    
                }
            }
        } 
        update bookingMap.values(); 
    }
    public static void carPark(List<Booking__c> bookList,Map<Id,Booking__c> oldBookMap){
        Set<Id> bookingIdSet = new Set<Id>();
        Set<Id> projectIdSet = new Set<Id>();
        Set<Id> UnitIdSet = new Set<Id>();
        Set<Id> carParkId = new set<Id>();
        Set<Id> preAllotCarparkId= new Set<Id>();
        Map<String,Integer> carParkingPreAllotedMap = New Map<String,Integer> ();
        Map<String,Integer> bikeParkingPreAllotedMap = New Map<String,Integer> ();
        Map<String,Property__c> carInventoryMap = New Map<String,Property__c> ();
        Map<String,Property__c> bikeInventoryMap = New Map<String,Property__c> ();
        Map<String,String> newPreAllotedInventoryMap = New Map<String,String> ();
        List<Property__c> carParkToUpdate = new List<Property__c>();
        Map<id,Property__c> updateNewPreAllotedCarPArking = New  Map<id,Property__c>();
        List<Property__c> PreAllotCarParkToUpdate = new List<Property__c>();
        List<Project_Add_On_Charges__c> projAddOnAdd = new List<Project_Add_On_Charges__c>();
        List<Property_Add_On__c> propAddOnAdd = new List<Property_Add_On__c>();
        Id ProjAddOnRecordTypeId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        if(!bookList.isEmpty()){
            for(Booking__c booking:bookList){
                if((booking.Cancellation_Approval_Status__c == 'Approved') && (oldBookMap.get(booking.Id).Cancellation_Approval_Status__c != booking.Cancellation_Approval_Status__c)){
                    bookingIdSet.add(booking.id);
                    projectIdSet.add(booking.Project_Name__c);
                    //UnitIdSet.add(booking.Related_Suggested_Property__r.Unit__c);
                }
            }
        }
        if(!bookingIdSet.isEmpty()){
            List<Booking__c> ListBooking = [Select Id,Name,Related_Suggested_property__r.unit__c,No_of_car_Parking__c 
                                            From Booking__c WHere Id In :bookingIdSet];
            system.debug('ListBooking----'+ListBooking);    
            if(!ListBooking.isEmpty()){
                for(Booking__c booking:ListBooking){
                    UnitIdSet.add(booking.Related_Suggested_Property__r.Unit__c);
                    
                }
            }
            
            List<Property__c> inventoryList = [SELECT Id, Name, Property_Status__c, Flat_Type__c, 
                                               No_of_car_Parking__c, Project__c,No_of_Bike_Parking__c
                                               FROM Property__c 
                                               WHERE (Booking__c IN :bookingIdSet AND Flat_Type__c  IN ('CAR PARKING','BIKE PARKING')) OR Id IN:UnitIdSet
                                              ];
            if(!inventoryList.isEmpty()){
                for(Property__c property:inventoryList){
                    if((property.Flat_Type__c == 'CAR PARKING' || property.Flat_Type__c == 'BIKE PARKING')
                       && property.Property_Status__c == 'Allotted')
                    {
                        property.Property_Status__c = 'Available';
                        property.Registration_Status__c ='';
                        property.Registration_Date__c = null;
                        property.Registration_Schedule_Date__c =null;
                        property.Booking__c = null;
                        carParkToUpdate.add(property);
                    }
                    else
                    {
                        if(property.No_of_car_Parking__c != null && property.No_of_car_Parking__c > 0)
                        {
                            bikeParkingPreAllotedMap.put(property.id,Integer.Valueof(property.No_of_Bike_Parking__c));
                            carParkingPreAllotedMap.put(property.id,Integer.Valueof(property.No_of_car_Parking__c));
                        }
                        
                    }
                    system.debug('carParkToUpdate----'+carParkToUpdate);
                }
                IF(!carParkToUpdate.isEmpty())
                {
                    update carParkToUpdate;
                }
                
            }
            
            List<Property_Add_On__c>propertyAddOnList = [SELECT Id, Project_Add_On__c,Project_Add_On__r.Name,Property__c,
                                                         Car_Parking__c,Car_Parking__r.Flat_Type__c
                                                         FROM Property_Add_On__c
                                                         WHERE (Project_Add_On__r.Name Like 'Car Parking %' OR
                                                                Project_Add_On__r.Name Like '%Wheel%')
                                                         AND Property__c IN: UnitIdSet AND Property__c != null
                                                         AND Car_Parking__c != null AND
                                                         Car_Parking__r.Flat_Type__c  IN ('CAR PARKING','BIKE PARKING') ];
            
            if(!propertyAddOnList.isEmpty()){
                for(Property_Add_On__c thisPAO : propertyAddOnList)
                {
                    IF(thisPAO.Car_Parking__r.Flat_Type__c == 'CAR PARKING'){
                        if(carParkingPreAllotedMap.containsKey(thisPAO.Property__c))
                        {
                            if(carParkingPreAllotedMap.get(thisPAO.Property__c)>0)
                            {
                                carParkingPreAllotedMap.put(thisPAO.Property__c,carParkingPreAllotedMap.get(thisPAO.Property__c)-1);
                                System.debug('carParkingPreAllotedMap'+carParkingPreAllotedMap);
                            }
                        }
                    }
                    IF(thisPAO.Car_Parking__r.Flat_Type__c == 'BIKE PARKING'){
                        if(bikeParkingPreAllotedMap.containsKey(thisPAO.Property__c))
                        {
                            if(bikeParkingPreAllotedMap.get(thisPAO.Property__c)>0)
                            {
                                bikeParkingPreAllotedMap.put(thisPAO.Property__c,bikeParkingPreAllotedMap.get(thisPAO.Property__c)-1);
                                System.debug('bikeParkingPreAllotedMap'+bikeParkingPreAllotedMap);
                            }
                        }
                    }
                }
            }
            System.debug('bikeParkingPreAllotedMap'+bikeParkingPreAllotedMap);
            System.debug('carParkingPreAllotedMap'+carParkingPreAllotedMap);
            List<Property__c> AvailCarParkList = [Select Id,Name,Project__c,Property_Status__c,Flat_Type__c 
                                                  From Property__c 
                                                  Where Property_Status__c = 'Available' 
                                                  AND Flat_Type__c IN ('CAR PARKING','BIKE PARKING') 
                                                  Order By Property_Status__c Desc   LIMIT 1000];
            System.debug('AvailCarParkList'+AvailCarParkList);
            if(!AvailCarParkList.isEmpty())
            {  Integer c=1;
             Integer b=1;
             for(Property__c AvailCarPark:AvailCarParkList){
                 if(AvailCarPark.Flat_Type__c == 'CAR PARKING')
                 {
                     String key = AvailCarPark.Project__c + String.valueof(c);
                     carInventoryMap.put(key,AvailCarPark);
                     c++;
                 }
                 if(AvailCarPark.Flat_Type__c == 'BIKE PARKING')
                 {
                     String key = AvailCarPark.Project__c + String.valueof(b);
                     bikeInventoryMap.put(key,AvailCarPark);
                     b++;
                 }
                 
             }
             System.debug('carInventoryMap'+carInventoryMap);
             System.debug('bikeInventoryMap'+bikeInventoryMap);
             //insert projAddOnAdd;
             List<Project_Add_On_Charges__c> projectAddonList = [SELECT Id, Name
                                                                 FROM Project_Add_On_Charges__c
                                                                 WHERE Name Like 'Car Parking %' OR Name Like '%Wheel%'];
             Integer j=1;
             for(Property__c property:inventoryList){
                 if(property.Flat_Type__c != 'CAR PARKING' && property.Flat_Type__c != 'BIKE PARKING')
                 {
                     if(carParkingPreAllotedMap.ContainsKey(property.id))
                     {
                         system.debug('carParkingPreAllotedMap.get(property.id)'+carParkingPreAllotedMap.get(property.id));
                         for(Integer K = 0;  K <carParkingPreAllotedMap.get(property.id) ;K++ ){
                             String key = property.Project__c + String.valueof(j);
                             if(carParkingPreAllotedMap.get(property.id)>0 && carInventoryMap.ContainsKey(key)){
                                 
                                 system.debug('carParkingPreAllotedMap.get(property.id)'+carParkingPreAllotedMap.get(property.id));
                                 system.debug('carInventoryMap.get(key).Flat_Type__c'+carInventoryMap.get(key).Flat_Type__c);
                                 
                                 if(carInventoryMap.get(key).Flat_Type__c == 'CAR PARKING'){
                                     
                                     //  AvailCarPark.Property_Status__c = 'Pre - Allotted';
                                     Property_Add_On__c  propAddOn = new Property_Add_On__c();
                                     propAddOn.Car_Parking__c = carInventoryMap.get(key).id;
                                     if(!projectAddonList.isEmpty())
                                     {
                                         propAddOn.Project_Add_On__c = projectAddonList[0].Id;
                                     }
                                     Property__c updateProperty = New Property__c();
                                     updateProperty.Property_Status__c = 'Available';
                                     updateProperty.id = carInventoryMap.get(key).id;
                                     updateNewPreAllotedCarPArking.put(updateProperty.id,updateProperty);
                                     propAddOn.Property__c = property.id;
                                     carInventoryMap.remove(key);
                                     propAddOnAdd.add(propAddOn);
                                     j++;
                                 }
                             }
                         }
                     }
                     
                     
                     if(bikeParkingPreAllotedMap.ContainsKey(property.id))
                     {
                         system.debug('bikeParkingPreAllotedMap.get(property.id)'+bikeParkingPreAllotedMap.get(property.id));
                         for(Integer K = 0;  K <bikeParkingPreAllotedMap.get(property.id) ;K++ ){
                             String key = property.Project__c + String.valueof(j);
                             if(bikeParkingPreAllotedMap.get(property.id)>0 && bikeInventoryMap.ContainsKey(key)){
                                 
                                 system.debug('bikeParkingPreAllotedMap.get(property.id)'+bikeParkingPreAllotedMap.get(property.id));
                                 system.debug('bikeInventoryMap.get(key).Flat_Type__c'+bikeInventoryMap.get(key).Flat_Type__c);
                                 
                                 if(bikeInventoryMap.get(key).Flat_Type__c == 'BIKE PARKING'){
                                     Property__c updateProperty = New Property__c();
                                     updateProperty.Property_Status__c = 'Available';
                                     updateProperty.id = bikeInventoryMap.get(key).id;
                                     updateNewPreAllotedCarPArking.put(updateProperty.id,updateProperty);
                                     //  AvailCarPark.Property_Status__c = 'Pre - Allotted';
                                     Property_Add_On__c  propAddOn = new Property_Add_On__c();
                                     propAddOn.Car_Parking__c = bikeInventoryMap.get(key).id;
                                     if(!projectAddonList.isEmpty())
                                     {
                                         propAddOn.Project_Add_On__c = projectAddonList[0].Id;
                                     }
                                     propAddOn.Property__c = property.id;
                                     bikeInventoryMap.remove(key);
                                     propAddOnAdd.add(propAddOn);
                                     j++;
                                 }
                             }
                         }
                     }
                     
                     
                     
                 }
             }
             
             System.debug('propAddOnAdd'+propAddOnAdd);
             if(!propAddOnAdd.isEmpty())
             {
                 insert propAddOnAdd;
             }
             if(!updateNewPreAllotedCarPArking.isEmpty())
             {
                 update updateNewPreAllotedCarPArking.values();
             }
             
            }
        }
        
    }
    Public static void updateBookingAfterRegistraion(List<Booking__c> bookList,Map<Id,Booking__c> oldBookMap)
    {
        Set<Id> bookingIdSet = new Set<Id>();
        List<Property__c> carParkToUpdate = new List<Property__c>();
        for(Booking__c booking:bookList){
            if((booking.Registration_Status__c == 'Completed') && (oldBookMap.get(booking.Id).Registration_Status__c != booking.Registration_Status__c)){
                bookingIdSet.add(booking.id);
            }
        }
        if(!bookingIdSet.isEmpty()){
            List<Property__c> inventoryList = [SELECT Id, Name, Property_Status__c, Flat_Type__c, No_of_car_Parking__c, Project__c
                                               FROM Property__c 
                                               WHERE Booking__c IN :bookingIdSet AND Flat_Type__c  IN ('CAR PARKING','BIKE PARKING')
                                              ];
            if(!inventoryList.isEmpty()){
                for(Property__c thisProperty :inventoryList)
                {
                    thisProperty.Registration_Status__c ='Completed';
                    thisProperty.Registration_Date__c = system.today();
                    thisProperty.Registration_Schedule_Date__c = system.today();
                    carParkToUpdate.add(thisProperty);
                }
            }
            if(!carParkToUpdate.isEmpty())
            {
                update carParkToUpdate;
            }
        }
    }
    // Converted the flow "Booking Agreement 10% Amount Received" into apex Method
    public static void generateAllotmentLetter(List<Booking__c> bookList, Map<Id,Booking__c> oldBookMap){
        if(!bookList.isEmpty()){
            Set<Id> bookingIds= new Set<Id>();
            List<Booking__c> bookToUpdate = new List<Booking__c>();
            for(Booking__c book:bookList){
                Decimal tenPercentAgreementValue = book.Agreement_Value__c * 0.1;
                Decimal tenPercentGstValue = book.GST__c * 0.1;
                if(book.Payment_Received_Agreement__c >= tenPercentAgreementValue && book.Approved_Payment_Received_GST__c >= tenPercentGstValue
                   && (oldBookMap.get(book.Id).Payment_Received_Agreement__c < tenPercentAgreementValue || 
                       oldBookMap.get(book.Id).Approved_Payment_Received_GST__c < tenPercentGstValue)
                  ){
                      GenerateAllotmentLetter.execute2(book.Id);
                      bookingIds.add(book.Id);
                  }
            }
            
            if(!bookingIds.isEmpty()){
                for(Booking__c bookRec:[Select Id,Name,Allotment_Letter_Generation_Date__c from Booking__c Where Id IN:bookingIds]){
                    bookRec.Allotment_Letter_Generation_Date__c = system.now();
                    bookToUpdate.add(bookRec);
                }
                IF(!bookToUpdate.IsEmpty()){
                    update bookToUpdate;
                }
                
            }
        }
    }
}