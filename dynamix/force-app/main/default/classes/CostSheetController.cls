public class CostSheetController {
    
    public Suggested_Property__c suggestedProperty {get;set;}
    public String costSheetNo {get;set;}
    public String view {get;set;}
    public String parking {get;set;}
    public decimal parkingPrice{get;set;}
    public Map<String, String> otherAddOns {get;set;}
    public decimal flatCost{get;set;}
    public decimal stampDuty{get;set;}
    public decimal registrationCharge{get;set;}
    public Builder_Organisation__c builderOrg{get;set;}
    public decimal TotalCost{get;set;}
    public Project__c projectobj{get;set;}
    public decimal GST{get;set;}
    public decimal GSTStamp{get;set;}
    public decimal GstAmount{get;set;}
    public Property__c propertyObj {get;set;} 
    public List<Add_On__c> addonList{get;set;}
    public Map<String,decimal> addonMap{get;set;}
    public decimal largeParking{get;set;}
    public decimal carParking{get;set;}
    
    public decimal totalParkingCharge{get;set;}
    public Integer paymentPlanMilestoneSize{get;set;}
    public decimal smallParking{get;set;}
    public decimal twowheelerParking{get;set;}
    public decimal shareMoney{get;set;}
    public decimal securityDeposit{get;set;}
    public decimal legalCharges{get;set;}
    public decimal utilitiesCharges{get;set;}
    public decimal societyCharges{get;set;}
    public decimal TotalCharges{get;set;}
    public decimal totalSqM{get;set;}
    public decimal totalSqF{get;set;}
    public decimal utilitySqM{get;set;}
    public decimal utility{get;set;}
    public decimal enclosedbalcony{get;set;}
    public decimal deckarea{get;set;}
    public decimal applicableGST{get;set;}
    public decimal otherChargeGST{get;set;}
    public string todaydate{get;set;}
    public boolean visiblityVer{get;set;} 
    public decimal totlaAgeement{get;set;} 
    public decimal stampPer{get;set;}
    public string  totalcount{get;set;}
    public decimal count{get;set;}
    public List<Pricing_Plan_Components__c>PricingPlan{get;set;}
    public List<Payment_Plan_Milestones__c> paymentPlans{get;set;}
    public List<ContentDocumentLink> contentDoc {get;set;}
    public List<ContentVersion> contentVerObject{get;set;}
    Public String ProjectHeader{get;set;}
    Public String ProjectFooter{get;set;}
    Public Opportunity opp{get;set;}
    public Project__c project{get;set;}
    public list<Pricing_Plan_Components__c> charges{get;set;}
    public Contact cc{get;set;} 
    public decimal totalAreainsq{get;set;}
    public decimal totalAreainft{get;set;}
    public decimal corpusfund{get;set;}
    public decimal subtotal{get;set;}
    public decimal stampdu{get;set;}
    public decimal registrationch{get;set;}
    public decimal gstAt{get;set;}
    public CostSheetController(){
        
    }
    public PageReference CostSheetController1() {
        builderOrg = new Builder_Organisation__c ();
        projectobj  = new Project__c(); 
        propertyObj  = new Property__c ();
        charges = new list<Pricing_Plan_Components__c>();
        otherChargeGST =0;
        todaydate= date.today().format();
        parkingPrice=0;
        largeParking=0;
        carParking=0;
        utility=0;
        enclosedbalcony=0;
        deckarea=0;
        smallParking=0;
        utilitySqM=0;
        totalSqM=0;
        totalAreainsq=0;
        totalAreainft=0;
        totalSqF=0;
        stampPer=0;
        totlaAgeement=0;
        totalParkingCharge=0;
        twowheelerParking=0;
        shareMoney=0;
        securityDeposit=0;
        legalCharges=0;
        utilitiesCharges=0;
        societyCharges=0;
        TotalCharges=0;
        applicableGST=0;
        GST=0;
        GSTStamp=0;
        corpusfund=0;
        subtotal=0;
        stampdu=0;
        gstAt=0;
        registrationch=0;
        
        visiblityVer =false;
        addonMap= new Map<String,decimal>();
        String sPropertyId = ApexPages.CurrentPage().getparameters().get('id');
        visiblityVer = boolean.valueof(ApexPages.CurrentPage().getparameters().get('customp'));
        suggestedProperty = [SELECT id,Opportunity__r.AccountId,Opportunity__r.Account.salutation, Name, Unit__c,
                             Cost_Sheet_Provided__c, Unit__r.Tower__r.Name,Unit__r.Tower__r.Tower_Number__c, Unit__r.Name, 
                             Unit__r.Project__c, Unit__r.Project__r.Name, Unit__r.Floor__c, Unit__r.Project__r.Location__c, Unit__r.Project__r.Corpus_Fund_Per_Sq_Ft__c,
                             Unit__r.Property_Price_Slab__c, Unit__r.Flat_Type__c, Unit__r.Project__r.RERA_Number__c,
                             unit__r.Proposed_Deck_Area_in_sq_mt__c, Unit__r.RERA_Carpet_Area__c, Unit__r.Deck_Carpet_Area__c, 
                             Unit__r.Flower_Bed_Area__c, Unit__r.Total_Area__c,unit__r.Deck_Proposed_Area__c,
                             Unit__r.Project__r.Per_Sq_ft_for_the_SMD__c,Unit__r.Project__r.No_of_the_Months__c,
                             Opportunity__r.Name,Opportunity__r.Project__r.name,Opportunity__r.Owner.Name,
                             Opportunity__r.Account.Name,Opportunity__c,Payment_Plan__c, Discount__c, Payment_Plan_Detail__c
                             FROM Suggested_Property__c WHERE Id =: sPropertyId];
        
        cc = [select id,salutation from Contact where AccountId = : suggestedProperty.Opportunity__r.AccountId];
        addonList= [select id,Opportunity__c,No_Of_Unit__c,Project_Add_On_Charges__r.Parking_Type__c,Project_Add_On_Charges__c,Project_Add_On_Charges__r.name from Add_On__c where Opportunity__c=:suggestedProperty.Opportunity__c];
        opp =[select id,Project__c,Project__r.GST_Applicable__c,Project__r.Name from Opportunity where id=:suggestedProperty.Opportunity__c];
        System.debug('addonList:'+addonList);
        if (suggestedProperty != null && suggestedProperty.Unit__c != null && suggestedProperty.Unit__r.Project__c != null && suggestedProperty.Unit__r.Project__r.Corpus_Fund_Per_Sq_Ft__c != null) {
            corpusfund = suggestedProperty.Unit__r.Project__r.Corpus_Fund_Per_Sq_Ft__c * 500;
        } else {
             System.debug('corpusfund:'+corpusfund);
        }
        if(addonList.size()>0)
        {
            
            for(Add_On__c ad : addonList)
            {
                if(ad.Project_Add_On_Charges__r.Parking_Type__c == 'Large Car Parking')
                {
                    largeParking+=ad.No_Of_Unit__c;
                }
                else if(ad.Project_Add_On_Charges__r.Parking_Type__c == 'Small Car Parking')
                {
                    smallParking+=ad.No_Of_Unit__c;
                }
                else if(ad.Project_Add_On_Charges__r.Parking_Type__c == 'Car Parking')
                {
                    carParking+=ad.No_Of_Unit__c;
                }
                else if(ad.Project_Add_On_Charges__r.Parking_Type__c == 'Two Wheeler Parking')
                {
                    twowheelerParking+=ad.No_Of_Unit__c;
                }
                addonMap.put(ad.Project_Add_On_Charges__r.name,ad.No_Of_Unit__c);
            }
            system.debug('largeParking=='+largeParking);
            system.debug('smallParking=='+smallParking);
            system.debug('twowheelerParking=='+twowheelerParking);
        }
        if(suggestedProperty.Unit__r.Project__c!=null)
        {                      
            projectobj = [select id,RERA_Number__c,Builder_Organization__c from Project__c  where id=:suggestedProperty.Unit__r.Project__c];
            if(projectobj.Builder_Organization__c !=null )  
            {
                builderOrg = [select id,Name,Account_Name__c,GST_Account_Name__c,IFSC_Code__c,Bank_Account_Number__c,Bank_Name__c,Branch_Address__c,Branch_Name__c,GST_Bank_Account_Number__c,GST_Bank_Name__c,
                              GST_Branch_Address__c,GST_IFSC_Code__c,Registration_No__c from Builder_Organisation__c where id=: projectobj.Builder_Organization__c ];
            }  
        }
        if(suggestedProperty.Unit__c!=null)
        {
            propertyObj = [select Id,Total_Area__c,Proposed_Utility_Area__c,Deck_Proposed_Area__c,Proposed_Deck_Area_in_sq_mt__c,Proposed_Utility_Area_in_sq_mt__c,Utility_Area_in_sqmtr__c,Enclosed_Balcony_in_sqmtr__c,RERA_Carpet_Area_in_sqmtr__c,Deck_Carpet_Area__c,Deck_Carpet_Area_c_in_sqmtr__c,Property_Area_in_sqft__c,Utility_Area__c,Enclosed_balcony__c,Property_Area_in_sqmtr__c,Name,Floor__c,RERA_Carpet_Area__c,Property_Area__c from Property__c where Id =: suggestedProperty.Unit__c];
        }
        totalSqM =propertyObj.RERA_Carpet_Area_in_sqmtr__c+propertyObj.Utility_Area_in_sqmtr__c+propertyObj.Enclosed_Balcony_in_sqmtr__c+propertyObj.Deck_Carpet_Area_c_in_sqmtr__c;
        
        totalAreainsq = propertyObj.Proposed_Deck_Area_in_sq_mt__c+propertyObj.Proposed_Utility_Area_in_sq_mt__c+propertyObj.RERA_Carpet_Area_in_sqmtr__c;
        
        system.debug('propertyObj.RERA_Carpet_Area__c=='+propertyObj.RERA_Carpet_Area__c);
        system.debug('propertyObj.Utility_Area__c=='+propertyObj.Utility_Area__c);
        if(propertyObj.Proposed_Utility_Area__c!=null)
        {
            utility=propertyObj.Proposed_Utility_Area__c;
            //utility=propertyObj.Utility_Area__c;
        }
        if(propertyObj.Enclosed_balcony__c!=null)
        {
            enclosedbalcony=propertyObj.Enclosed_balcony__c;
        }        
        if(propertyObj.Deck_Proposed_Area__c!=null)
        {
            deckarea=propertyObj.Deck_Proposed_Area__c;
        }
        if(propertyObj.RERA_Carpet_Area__c!=null)
        {
            totalSqf =propertyObj.RERA_Carpet_Area__c+utility+deckarea+enclosedbalcony;
        }
        else
        {
            totalSqf =utility+enclosedbalcony;
        }
        
        totalAreainft = deckarea+utility+propertyObj.RERA_Carpet_Area__c;
        
        system.debug('builderOrg =='+builderOrg );  
        view = 'No Preferred View';
        parking = 'No Parking';
        otherAddOns = new Map<String, String>();
        
        suggestedProperty.Discount__c = suggestedProperty.Discount__c == null? 0:suggestedProperty.Discount__c;
        
        PricingHelper.PriceInfo priceInfo = PricingHelper.getPricing(suggestedProperty.Unit__c, suggestedProperty.Opportunity__c, null, new Map<String, Decimal>{ 'Basic Price' => suggestedProperty.Discount__c});
        system.debug('priceInfo1641 '+ priceInfo);
        PricingPlan = PriceInfo.PricingPlan;
        for(Pricing_Plan_Components__c p :PricingPlan)
        {
            if(p.Name=='Stamp Duty')
            {
                stampPer =p.Price_age__c;
            }
            
        }
        if(priceInfo.inclusions.containsKey('Preferred Location')){
            view = String.join(priceInfo.inclusions.get('Preferred Location'), ',');
        }
        
        if(priceInfo.inclusions.containsKey('Parking')){
            parking = String.join(priceInfo.inclusions.get('Parking'), ',');
            system.debug('parking=='+parking);
        }
        
        if(priceInfo.inclusions.containsKey('Charges')){
            for(String addOn: priceInfo.inclusions.get('Charges')){
                otherAddOns.put(addOn, 'Included');
            }
        }
        
        if(!otherAddOns.containsKey('Club Membership')){
            otherAddOns.put('Club Membership', 'Excluded');
        }
        
        flatCost = 0;
        stampDuty = 0;
        registrationCharge = 0;
        system.debug('priceInfo.chargeGroupMap=='+priceInfo.chargeGroupMap);
        if(priceInfo.chargeGroupMap.containsKey('Agreement')){
            flatCost = priceInfo.chargeGroupMap.get('Agreement');
        }
        
        if(priceInfo.chargeGroupMap.containsKey('Stamp Duty')){
            stampDuty = priceInfo.chargeGroupMap.get('Stamp Duty');
            stampdu  = priceInfo.chargeGroupMap.get('Stamp Duty');
            
        }
        if(priceInfo.chargeGroupMap.containsKey('Registration Charge')){
            registrationCharge = priceInfo.chargeGroupMap.get('Registration Charge');
        }
        
        if(priceInfo.chargeGroupMap.containsKey('GST')){
            GstAmount = priceInfo.chargeGroupMap.get('GST');
        }
        if(priceInfo.chargeGroupMap.containsKey('parking')){
            system.debug('parking===='+priceInfo.chargeGroupMap.get('parking'));
        }
        list<Price_Details__c> pdList= priceInfo.priceDetails;
        system.debug('pdList=='+pdList);
        if(pdList.size()>=0)
        {
            for(Price_Details__c pd : pdList)
            {
                if((addonMap.containsKey(pd.name)) && pd.name.containsIgnoreCase('Wheeler'))
                {
                    totalParkingCharge = totalParkingCharge+(addonMap.get(pd.name)*pd.Amount__c);
                }
                else if((addonMap.containsKey(pd.name)) && pd.name.containsIgnoreCase('Large car parking'))
                {
                    totalParkingCharge = totalParkingCharge + (addonMap.get(pd.name)*pd.Amount__c);
                }   
                else if((addonMap.containsKey(pd.name)) && pd.name.containsIgnoreCase('Small Car Parking'))
                {
                    totalParkingCharge = totalParkingCharge +(addonMap.get(pd.name)*pd.Amount__c);
                }
                
            }
        }
        system.debug('flatCost220 '+ flatCost);
        totlaAgeement =flatCost;
        if(opp.Project__r.GST_Applicable__c==true)
        {
            for(Pricing_Plan_Components__c p :PricingPlan)
            {
                if(p.Name == 'Basic Price'){
                    if(p.GST_Treatment__c == 'Standard')
                    {
                        if(flatCost > 4500000){
                            GST = 5;
                        }
                        else {
                            GST = 1;
                        }
                        GstAmount = (flatCost*gst)/100;
                    }
                    else{
                        GST = Decimal.valueOf(p.GST_Treatment__c.substringBefore('%'));
                        //GST = 9;
                        GstAmount = (flatCost*GST)/100;
                    }
                }
            }
            
        }
        else
        {
            GstAmount =0;
        } 
        if(opp.Project__r.name == 'Aldeia de Goa'){
        if(opp.Project__r.GST_Applicable__c==true)
        {
            for(Pricing_Plan_Components__c p :PricingPlan)
            {
                if(p.Name == 'Stamp Duty'){
                    if(p.GST_Treatment__c == 'Standard')
                    {
                        if(stampDuty > 4500000){
                            GSTStamp = 5;
                        }
                        else {
                            GSTStamp = 1;
                        }
                        GstAmount = (stampDuty*gst)/100;
                    }
                    else{
                        GSTStamp = Decimal.valueOf(p.GST_Treatment__c.substringBefore('%'));
                        //GST = 9;
                        GstAmount = (stampDuty*GSTStamp)/100;
                    }
                }
            }
            
        }
        /*else
        {
            GstAmount =0;
        }  */ 
    }
        String unitName;
        if(suggestedProperty.Unit__r.Name.length() < 4)
        {
            unitName = 0 + suggestedProperty.Unit__r.Name;
        }
        else{
            unitName = suggestedProperty.Unit__r.Name;
        }
        if(opp.Project__r.GST_Applicable__c==true)
        {
            totalcount ='17';
            count=17;
        }
        else
        {
            totalcount ='16';
            count=16;
        }
        for(Pricing_Plan_Components__c p : PricingPlan)
        {
            
            if(p.Project_Add_On_Charges__r.RecordType.Name=='Charges'  && p.Project_Add_On_Charges__r.Charge_Group__c=='Others')
            {    
                count=count+1;
                totalcount =totalcount +' + '+ count;
                if(p.Price_Lumpsum__c!=null)
                {
                    charges.add(p);
                    TotalCharges =TotalCharges +p.Price_Lumpsum__c;
                }
                else
                {
                    p.Price_Lumpsum__c=p.Price_per_SQFT__c *suggestedProperty.Unit__r.RERA_Carpet_Area__c;
                    charges.add(p);
                    TotalCharges =TotalCharges +p.Price_Lumpsum__c;
                }
                
                //if(opp.Project__r.GST_Applicable__c==true)
                //{
                if(p.GST_Treatment__c!='Standard')
                {
                    otherChargeGST = otherChargeGST+ (p.Price_Lumpsum__c * Decimal.valueOf(p.GST_Treatment__c.removeEnd('%')))/100;
                }
                else
                {
                    otherChargeGST =otherChargeGST+ (p.Price_Lumpsum__c * GST );
                }       
                // }
            }
            
        }
        //if(opp.Project__r.GST_Applicable__c==false)
        // {
        //totalcount =totalcount.Substring(0,totalcount.length()-4);
        // }
       // stampdu = (totlaAgeement*GSTStamp)/100;
        gstAt = (totlaAgeement*GST)/100;
        registrationch = (totlaAgeement*3)/100;
        TotalCharges =TotalCharges +otherChargeGST;
        if(opp.Project__r.name != 'Aldeia de Goa')
        {        TotalCost = totlaAgeement + StampDuty + RegistrationCharge + GstAmount;
         
         
        }
        else if(opp.Project__r.name == 'Aldeia de Goa')
        {
            TotalCost = totlaAgeement + StampDuty + gstAt + registrationch;
        }
       
        List<ContentDocumentLink> cDLLst = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =: suggestedProperty.Opportunity__c];
        
        costSheetNo = suggestedProperty.Unit__r.Tower__r.Name.left(3).toUpperCase() + '/' + unitName  + '/' + suggestedProperty.Name.right(4) + cDLLst.size();
        paymentPlans = (List<Payment_Plan_Milestones__c>)JSON.deserialize(suggestedProperty.Payment_Plan_Detail__c, List<Payment_Plan_Milestones__c>.class);
        system.debug('==> paymentPlans ' + paymentPlans );
         system.debug('==> paymentPlans ' + paymentPlans.size() );
        paymentPlanMilestoneSize = paymentPlans.size() +1;
        if(suggestedProperty.Opportunity__r.Project__r.name <> null)
        {
            project = [select Id,Name,Builder_Organization__r.name,Project_Header__c,Project_Footer__c,Postal_Code__c,Location__c,Sublocation__c,City__c,State__c,Project_Email__c,Project_Phone__c from Project__c where Id =:suggestedProperty.Opportunity__r.Project__c ];
            if(project.Project_Header__c!='')
            {
                ProjectHeader=project.Project_Header__c; 
            }
            if(project.Project_Footer__c!='')
            {
                ProjectFooter =project.Project_Footer__c; 
            }
        }
        //for set Payment Plan
        if(paymentPlans!=null && paymentPlans.size()>0){
            String paymentPlanId=paymentPlans[0].Payment_Plan__c;
            System.debug('paymentPlanId:'+paymentPlanId);
            //update suggested Property
            //Suggested_Property__c updateSuggProperty=new Suggested_Property__c(Id=sPropertyId);
            Suggested_Property__c updateSuggProperty= [Select Id,Payment_Plan__c From Suggested_Property__c Where Id=:sPropertyId];
            if(updateSuggProperty.Payment_Plan__c!=paymentPlanId){
                updateSuggProperty.Payment_Plan__c=paymentPlanId;
                update updateSuggProperty;
            }
        }
        subtotal = corpusfund + 20000 + 5000;
        //for update opportunity fields
        if(suggestedProperty.Opportunity__c!=null){
            Opportunity updateOppRcd=new Opportunity(Id=suggestedProperty.Opportunity__c);
            updateOppRcd.No_of_Parking_s_Spots_Required__c=largeParking+smallParking+carParking+twowheelerParking;
            updateOppRcd.Apartment_Number__c=suggestedProperty.Unit__r.Name;
            update updateOppRcd;
        }
        
        
        return null;
    }
}