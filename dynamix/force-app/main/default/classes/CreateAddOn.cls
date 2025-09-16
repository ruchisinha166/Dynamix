public class CreateAddOn {
    @AuraEnabled
    public static String createOpportunityAddOns(String OppId,String SuggPropId,String CarParkId){
        system.debug('OppId----'+OppId);
        system.debug('SuggPropId----'+SuggPropId);
        system.debug('CarParkId----'+CarParkId);
        String AddOnName='';
        Set<Id> projId= new Set<Id>();
        Set<Id> pricingPlanId = new Set<Id>();
        Set<Id> projAddOnId= new Set<Id>();
        Decimal price;
        Map<String,Id> TwoWheelerProjAddMap = new Map<String,Id>();
        Map<String,Id> CarParkProjAddMap = new Map<String,Id>();
        Map<String,decimal> TwoWheelerPriceMap = new Map<String,Decimal>();
        Map<String,decimal> CarParkPriceMap = new Map<String,Decimal>();
        Map<String,decimal> TwoWheelerGSTMap = new Map<String,Decimal>();
        Map<String,decimal> CarParkGSTMap = new Map<String,Decimal>();
        
        Id ProjAddOnRecordTypeId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        
        List<Property__c> updateCarparkList = new List<Property__c>();
        List<Add_On__c> AddONList =new List<Add_On__c>();
        List<Suggested_Property__c> SuggPropList = [Select Id,Name,Unit__r.Name,Unit__r.Property_Price_Slab__c,Unit__r.Project__c From Suggested_Property__c Where Id=:SuggPropId];
        system.debug('SuggPropList----'+SuggPropList);
        if(!SuggPropList.isEmpty()){
            for(Suggested_Property__c SuggProp:SuggPropList){
                AddOnName+=SuggProp.Unit__r.Name+'-';
                projId.add(suggProp.Unit__r.Project__c);
                pricingPlanId.add(suggProp.Unit__r.Property_Price_Slab__c);
            }
        }
        
        
        List<Property__c> CarParkList = [Select Id,Name,Project__c,Parking_Type__c,Flat_Type__c From Property__c Where Id=:CarParkId];
        
        
        system.debug('CarParkList----'+CarParkList);
        if(!CarParkList.isEmpty()){
            for(Property__c CarPark:CarParkList){
                AddOnName+=CarPark.Name;
                CarPark.Property_Status__c = 'Allotted In Progress';
                updateCarparkList.add(CarPark);
            }
            update updateCarparkList;
        }
        system.debug('AddOnName'+AddOnName);
        String[] names = new String[]{'Car Parking Space','2 Wheeler Parking'};
        List<Project_Add_On_Charges__c> CarprojAddOnList = [Select Id,Name from Project_Add_On_Charges__c Where Name =:'Car Parking Space' And Project__c In:projId LIMIT 1];
        List<Project_Add_On_Charges__c> BikeprojAddOnList = [Select Id,Name from Project_Add_On_Charges__c Where Name =:'2 Wheeler Parking' And Project__c In:projId LIMIT 1];
        if(!CarprojAddOnList.isEmpty()){
            for(Project_Add_On_Charges__c CarProjAddOn:CarprojAddOnList){
                projAddOnId.add(CarProjAddOn.Id);
            }
        }
        
        if(!BikeprojAddOnList.isEmpty()){
            for(Project_Add_On_Charges__c BikeProjAddOn:BikeprojAddOnList){
                projAddOnId.add(BikeProjAddOn.Id);
            }
        }
        List<Pricing_Plan_Components__c> pricPlanCompList = [Select Id,Name,Price_Lumpsum__c,GST_Treatment__c,Project_Add_On_Charges__c From Pricing_Plan_Components__c Where Project_Add_On_Charges__c In :projAddOnId AND Pricing_Plan__c IN:pricingPlanId];
        //system.debug('projAddOnList----'+projAddOnList);
        system.debug('pricPlanCompList----'+pricPlanCompList);
        
        for(Pricing_Plan_Components__c pricPlanComp:pricPlanCompList){
            price = pricPlanComp.Price_Lumpsum__c;
            if(pricPlanComp.Name =='2 Wheeler Parking'){
                TwoWheelerProjAddMap.put('Two Wheeler',pricPlanComp.Project_Add_On_Charges__c);
                TwoWheelerPriceMap.put('Two Wheeler',pricPlanComp.Price_Lumpsum__c);
                TwoWheelerGSTMap.put('Two Wheeler',Decimal.valueOf(pricPlanComp.GST_Treatment__c.substringBefore('%')));
            }
            if(pricPlanComp.Name == 'Car Parking Space'){
                CarParkProjAddMap.put('Car Park',pricPlanComp.Project_Add_On_Charges__c);
                CarParkPriceMap.put('Car Park',pricPlanComp.Price_Lumpsum__c);
                CarParkGSTMap.put('Car Park',Decimal.valueOf(pricPlanComp.GST_Treatment__c.substringBefore('%')));
            }
        }
        if(!CarParkList.isEmpty()){
            for(Property__c carPark:CarParkList){
                Add_On__c AddOn = new Add_On__c();
       	 		AddOn.Opportunity__c = OppId;
        		AddOn.Suggested_Property__c = SuggPropId;
        		AddOn.Car_Parking__c = CarParkId;
        		AddOn.Name = AddOnName;
                if(carPark.Flat_Type__c == 'CAR PARKING'){
                    AddOn.Project_Add_On_Charges__c = CarParkProjAddMap.get('Car Park');
                    AddOn.Parking_Value__c = CarParkPriceMap.get('Car Park');
                    AddOn.Parking_GST_Percent__c = CarParkGSTMap.get('Car Park');
                }
                else if(carPark.Flat_Type__c == 'BIKE PARKING'){
                    AddOn.Project_Add_On_Charges__c = TwoWheelerProjAddMap.get('Two Wheeler');
                    AddOn.Parking_Value__c = TwoWheelerPriceMap.get('Two Wheeler');
                    AddOn.Parking_GST_Percent__c = TwoWheelerGSTMap.get('Two Wheeler');
                }
                
            	AddONList.add(AddOn);
            }
            if(!AddONList.isEmpty()){
            	insert AddONList;
            }
            
        }
         
        return 'Record Created Successfully';
        
    }
    public static void createAddOnforPreAllotted(List<Suggested_Property__c> ListsuggProp){
        System.debug('Trigger is Working');
        Set<Id> propertyId= new Set<Id>();
        Set<Id> suggPropId = new Set<Id>();
        Map<Id,Id> UnitSuggPropMap = new Map<Id,Id>();
        Map<Id,Id> UnitOppMap = new Map<Id,Id>();
        Map<Id,String> UnitSuggName = new Map<Id,String>();
        List<Add_On__c> AddOnList = new List<Add_On__c>();
        Id ProjAddOnRecordTypeId = Schema.SObjectType.Project_Add_On_Charges__c.getRecordTypeInfosByName().get('Parking').getRecordTypeId();
        if(!ListsuggProp.isEmpty()){
            for(Suggested_Property__c sp:ListsuggProp){
                suggPropId.add(sp.Id);
            }
        }
        
        List<Suggested_Property__c> suggPropList = [Select Id,Name,Unit__c,Opportunity__c,Unit__r.Name From Suggested_Property__c Where Id IN :suggPropId];
        if(!suggPropList.isEmpty()){
            System.debug('suggPropList'+suggPropList);
            for(Suggested_Property__c suggProp:suggPropList){
                propertyId.add(suggProp.Unit__c);
                UnitSuggPropMap.put(suggProp.Unit__c,suggProp.Id);
                UnitOppMap.put(suggProp.Unit__c,suggProp.Opportunity__c);
                UnitSuggName.put(suggProp.Unit__c,suggProp.Unit__r.Name);
            }
            if(!propertyId.isEmpty()){
                System.debug('propertyId'+propertyId);
                List<Property_Add_On__c> propAddOnList = [Select Id,Name,Property__c,Car_Parking__c,Project_Add_On__c,Car_Parking__r.Name From Property_Add_On__c Where Property__c IN :propertyId];
                if(!propAddOnList.isEmpty()){
                    System.debug('propAddOnList'+propAddOnList);
                    for(Property_Add_On__c propAddOn:propAddOnList){
                        Add_On__c AddON = new Add_On__c();
                    	AddOn.Suggested_Property__c = UnitSuggPropMap.get(propAddOn.Property__c);
                        system.debug('AddOn.Suggested_Property__c'+AddOn.Suggested_Property__c);
                    	AddOn.Car_Parking__c = propAddOn.Car_Parking__c;
                    	AddOn.Opportunity__c = UnitOppMap.get(propAddOn.Property__c);
                        AddOn.Name = UnitSuggName.get(propAddOn.Property__c)+'-'+propAddOn.Car_Parking__r.Name;
                        system.debug('UnitSuggName.get(propAddOn.Property__c----)'+UnitSuggName.get(propAddOn.Property__c));
                        system.debug('AddOn.Name----'+AddOn.Name);
                        system.debug('propAddOn.Car_Parking__r.Name----'+propAddOn.Car_Parking__r.Name);
                        
                        AddOn.Project_Add_On_Charges__c = propAddOn.Project_Add_On__c; 
                        AddOnList.add(AddOn);
                    }
                    if(!AddOnList.isEmpty()){
                        System.debug('AddOnList'+AddOnList);
                        insert AddOnList;
                    }
                }
            }
        }
    }
    @AuraEnabled
    public static String createAddOnBookingCarParking(String booknigId,String CarParkId){
        String BookStatus;
        String AddOnName='';
        Id OppId;
        Id suggPropId;
        Decimal CarparkValue = 0;
        Set<Id> projId= new Set<Id>();
        Set<Id> pricingPlanId = new Set<Id>();
        Map<String,Id> TwoWheelerProjAddMap = new Map<String,Id>();
        Map<String,Id> CarParkProjAddMap = new Map<String,Id>();
        Map<String,decimal> TwoWheelerPriceMap = new Map<String,Decimal>();
        Map<String,decimal> CarParkPriceMap = new Map<String,Decimal>();
        List<Property__c> carParkUpdate = new List<Property__c>();
        List<Price_Details__c> PriceDetailUpdate = new List<Price_Details__c>();
        List<Add_On__c> AddONList =new List<Add_On__c>();
        List<Booking__c> bookList = [Select Id,Name,Registration_Status__c,Stage__c,Related_Opportunity__c,Project_Name__c,Related_Suggested_Property__c,Related_Suggested_Property__r.Unit__r.Name,Related_Suggested_Property__r.Unit__r.Property_Price_Slab__c From Booking__c Where Id =:booknigId];
        List<Property__c> carParkList = [Select Id,Name,Flat_Type__c From Property__c where Id=:CarParkId];
        
        for(Booking__c book:bookList){
            BookStatus = book.Registration_Status__c;
            OppId = book.Related_Opportunity__c;
            suggPropId = book.Related_Suggested_Property__c;
            AddOnName+=book.Related_Suggested_Property__r.Unit__r.Name+'-';
            projId.add(book.Project_Name__c);
            pricingPlanId.add(book.Related_Suggested_Property__r.Unit__r.Property_Price_Slab__c);
        }
        for(Property__c carPark:carParkList){
            carPark.Property_Status__c = 'Allotted';
            carPark.Booking__c = booknigId;
            carPark.Date_of_Car_Park_Booking__c = system.today();
            AddOnName +=carPark.Name;
            carParkUpdate.add(carPark);
            }
        update carParkUpdate;
        Map<String,Pricing_Plan_Components__c> mapOfPricingPlan = New Map<String,Pricing_Plan_Components__c>();
        List<Project_Add_On_Charges__c> projAddOnList = [Select Id,Name from Project_Add_On_Charges__c 
                                                         Where (Name Like 'Car Parking %' OR
                                                                Name Like '%Wheel%') 
                                                         And Project__c In:projId];
        List<Pricing_Plan_Components__c> pricPlanCompList = [Select Id,Name,Price_Lumpsum__c,Project_Add_On_Charges__c,
                                                             Project_Add_On_Charges__r.Name,Project_Add_On_Charges__r.Charge_Group__c
                                                             From Pricing_Plan_Components__c 
                                                             Where Project_Add_On_Charges__c In :projAddOnList AND Pricing_Plan__c IN:pricingPlanId];
         List<Price_Details__c> priceDetailsList = new List<Price_Details__c>();
        for(Pricing_Plan_Components__c pricPlanComp:pricPlanCompList){
            if(pricPlanComp.Name.contains('Wheel')){
                TwoWheelerProjAddMap.put('Two Wheeler',pricPlanComp.Project_Add_On_Charges__c);
                TwoWheelerPriceMap.put('Two Wheeler',pricPlanComp.Price_Lumpsum__c);
                mapOfPricingPlan.put('Two Wheeler',pricPlanComp);
                CarparkValue+=pricPlanComp.Price_Lumpsum__c;
                
            }
            if(pricPlanComp.Name.contains('Car')){
                CarParkProjAddMap.put('Car Park',pricPlanComp.Project_Add_On_Charges__c);
                CarParkPriceMap.put('Car Park',pricPlanComp.Price_Lumpsum__c);
                mapOfPricingPlan.put('Car Park',pricPlanComp);
                CarparkValue+=pricPlanComp.Price_Lumpsum__c;
            }
        }
        
        if(/*bookList[0].Stage__c =='Draft' || bookList[0].Stage__c == 'Booked'*/ BookStatus!='Completed'){
            if(!CarParkList.isEmpty()){
                for(Property__c carPark:carParkList){
                    Add_On__c AddOn = new Add_On__c();
                    AddOn.Opportunity__c = OppId;
                    AddOn.Suggested_Property__c = SuggPropId;
                    AddOn.Car_Parking__c = CarParkId;
                    AddOn.Name = AddOnName;
                     Price_Details__c priceDetail = new Price_Details__c();
                    priceDetail.Booking__c =booknigId;
                    if(carPark.Flat_Type__c == 'CAR PARKING'){
                        AddOn.Project_Add_On_Charges__c = CarParkProjAddMap.get('Car Park');
                        AddOn.Parking_Value__c = CarParkPriceMap.get('Car Park');
                        if(mapOfPricingPlan.containsKey('Car Park'))
                        {
                            priceDetail.Name = mapOfPricingPlan.get('Car Park').Project_Add_On_Charges__r.Name;
                            priceDetail.Charge_Group__c =  mapOfPricingPlan.get('Car Park').Project_Add_On_Charges__r.Charge_Group__c;
                            //   priceDetail.Amount__c =  CarParkPriceMap.get('Car Park');
                            priceDetail.Amount__c =  mapOfPricingPlan.get('Car Park').Price_Lumpsum__c;
                            //  priceDetail.GST_Type__c = projGstTreatMentMap.get(AddOn.Project_Add_On_Charges__c);
                            priceDetail.GST__c = 1;
                            priceDetail.Additional_Car_Bike_Parking__c = true;
                            priceDetail.Parking__c = carPark.Id;
                            priceDetailsList.add(priceDetail);
                        }
                        
                    }
                    else if(carPark.Flat_Type__c == 'BIKE PARKING'){
                        AddOn.Project_Add_On_Charges__c = TwoWheelerProjAddMap.get('Two Wheeler');
                        AddOn.Parking_Value__c = TwoWheelerPriceMap.get('Two Wheeler');
                        if(mapOfPricingPlan.containsKey('Two Wheeler'))
                        {
                            priceDetail.Name = mapOfPricingPlan.get('Two Wheeler').Project_Add_On_Charges__r.Name;
                            priceDetail.Charge_Group__c =  mapOfPricingPlan.get('Two Wheeler').Project_Add_On_Charges__r.Charge_Group__c;
                            //   priceDetail.Amount__c =  CarParkPriceMap.get('Car Park');
                            priceDetail.Amount__c =  mapOfPricingPlan.get('Two Wheeler').Price_Lumpsum__c;
                            //  priceDetail.GST_Type__c = projGstTreatMentMap.get(AddOn.Project_Add_On_Charges__c);
                            priceDetail.GST__c = 1;
                            priceDetail.Additional_Car_Bike_Parking__c = true;
                            priceDetail.Parking__c = carPark.Id;
                            priceDetailsList.add(priceDetail);
                            
                        }
                    }
                    AddONList.add(AddOn);
                }
                if(!AddONList.isEmpty()){
                    insert AddONList;
                }
                 system.debug('priceDetailsList----'+ priceDetailsList);
                if(!priceDetailsList.isEmpty())
                {
                    insert priceDetailsList;
                }
            }
        }
        else if(BookStatus=='Completed'){
            if(!CarParkList.isEmpty()){
                for(Property__c carPark:carParkList){
                    Price_Details__c priceDetail = new Price_Details__c();
                    priceDetail.Booking__c =booknigId;
                    Add_On__c AddOn = new Add_On__c();
                    AddOn.Opportunity__c = OppId;
                    AddOn.Suggested_Property__c = SuggPropId;
                    AddOn.Car_Parking__c = CarParkId;
                    AddOn.Name = AddOnName;
                    if(carPark.Flat_Type__c == 'CAR PARKING'){
                        AddOn.Project_Add_On_Charges__c = CarParkProjAddMap.get('Car Park');
                        AddOn.Parking_Value__c = CarParkPriceMap.get('Car Park');
                        if(mapOfPricingPlan.containsKey('Car Park'))
                        {
                            priceDetail.Name = mapOfPricingPlan.get('Car Park').Project_Add_On_Charges__r.Name;
                            priceDetail.Charge_Group__c = 'Others';
                            //   priceDetail.Amount__c =  CarParkPriceMap.get('Car Park');
                            priceDetail.Amount__c =  mapOfPricingPlan.get('Car Park').Price_Lumpsum__c;
                            //  priceDetail.GST_Type__c = projGstTreatMentMap.get(AddOn.Project_Add_On_Charges__c);
                            priceDetail.GST__c = 1;
                            priceDetail.Additional_Car_Bike_Parking__c = true;
                            priceDetail.Parking__c = carPark.Id;
                            priceDetailsList.add(priceDetail);
                        }
                    }
                    else if(carPark.Flat_Type__c == 'BIKE PARKING'){
                        AddOn.Project_Add_On_Charges__c = TwoWheelerProjAddMap.get('Two Wheeler');
                        AddOn.Parking_Value__c = TwoWheelerPriceMap.get('Two Wheeler');
                         if(mapOfPricingPlan.containsKey('Two Wheeler'))
                        {
                            priceDetail.Name = mapOfPricingPlan.get('Two Wheeler').Project_Add_On_Charges__r.Name;
                            priceDetail.Charge_Group__c =  'Others';
                            //   priceDetail.Amount__c =  CarParkPriceMap.get('Car Park');
                            priceDetail.Amount__c =  mapOfPricingPlan.get('Two Wheeler').Price_Lumpsum__c;
                            //  priceDetail.GST_Type__c = projGstTreatMentMap.get(AddOn.Project_Add_On_Charges__c);
                            priceDetail.GST__c = 1;
                            priceDetail.Additional_Car_Bike_Parking__c = true;
                            priceDetail.Parking__c = carPark.Id;
                            priceDetailsList.add(priceDetail);
                        }
                    }
                    AddONList.add(AddOn);
                }
                if(!AddONList.isEmpty()){
                    insert AddONList;
                }
                system.debug('priceDetailsList----'+ priceDetailsList);
                if(!priceDetailsList.isEmpty())
                {
                    insert priceDetailsList;
                }
            }
            List<Payment_Milestones__c> payMilestonesList = [Select Id,Name,Milestone_Amount1__c,GST_Amount1__c,Remaining_Milestone_Amount__c,Remaining_Unit_Cost__c,
                                                            Remaining_GST1__c From Payment_Milestones__c Where Booking__c=: booknigId AND Name =:System.Label.OtherChargesMilestone limit 1];
            Payment_Milestones__c payMilestone = new Payment_Milestones__c();
            payMilestone.Id = payMilestonesList[0].Id;
            payMilestone.Milestone_Amount1__c = payMilestonesList[0].Milestone_Amount1__c + CarparkValue;
            payMilestone.GST_Amount1__c = payMilestonesList[0].GST_Amount1__c + CarparkValue*0.18;
            payMilestone.Remaining_Milestone_Amount__c = payMilestonesList[0].Remaining_Milestone_Amount__c + CarparkValue;
            payMilestone.Remaining_Unit_Cost__c = payMilestonesList[0].Remaining_Unit_Cost__c + CarparkValue;
            payMilestone.Remaining_GST1__c = payMilestonesList[0].Remaining_GST1__c + payMilestone.GST_Amount1__c;
            update payMilestone;
           
        }
        return 'Other Charges Updated Successfully';
    }
}