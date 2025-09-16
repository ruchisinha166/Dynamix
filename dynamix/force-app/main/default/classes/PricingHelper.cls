public class PricingHelper {
    
    public static PriceInfo getPricing(Id propertyId, Id oppId, Id bookingId, Map<String, Decimal> discountMap){
        system.debug('propertyId=='+propertyId);
        system.debug('oppId=='+oppId);
        system.debug('bookingId=='+bookingId);
        
        system.debug('discountMap=='+discountMap);
        Map<String, ADDON> addOnsMap = new Map<String, ADDON>();
        Map<String, List<String>> inclusions = new Map<String, List<String>>();
        
        for(Property_Add_On__c property_addon : [SELECT Id, Name, Project_Add_On__r.Name, Project_Add_On__r.RecordType.Name, Is_Included__c 
                                                 FROM Property_Add_On__c WHERE Property__c =: propertyId]){
                                     system.debug('property_addon.Is_Included__c'+property_addon.Is_Included__c);                
                                                     addOnsMap.put(property_addon.Project_Add_On__r.Name, new ADDON(property_addon.Project_Add_On__c, property_addon.Is_Included__c,0));
                                                     
                                                     if(inclusions.containsKey(property_addon.Project_Add_On__r.RecordType.Name)){
                                                         inclusions.get(property_addon.Project_Add_On__r.RecordType.Name).add(property_addon.Project_Add_On__r.Name);
                                                     }
                                                     else{
                                                         inclusions.put(property_addon.Project_Add_On__r.RecordType.Name, new List<String>{property_addon.Project_Add_On__r.Name});
                                                     }
                                                 }
        
        for(Add_On__c addOn: [SELECT Id, Opportunity__c, Project_Add_On_Charges__c, No_Of_Unit__c, Project_Add_On_Charges__r.RecordType.Name,
                              Project_Add_On_Charges__r.Name FROM Add_On__c WHERE Opportunity__c =: oppId]){
                                  
                                  addOnsMap.put(addOn.Project_Add_On_Charges__r.Name, new ADDON(addOn.Project_Add_On_Charges__c, false,addOn.No_Of_Unit__c));
                                  
                                  if(inclusions.containsKey(addOn.Project_Add_On_Charges__r.RecordType.Name)){
                                      inclusions.get(addOn.Project_Add_On_Charges__r.RecordType.Name).add(addOn.Project_Add_On_Charges__r.Name);
                                  }
                                  else{
                                      inclusions.put(addOn.Project_Add_On_Charges__r.RecordType.Name, new List<String>{addOn.Project_Add_On_Charges__r.Name});
                                  }
                              }
        
        Map<String, Decimal> chargeGroupMap = new Map<String, Decimal>();
        List<Price_Details__c> priceDetailsLst = new List<Price_Details__c>();
        
        Property__c property = [SELECT Id, Index__c,Name,Total_Area__c, Property_Price_Slab__c, Floor__c FROM Property__c WHERE Id =: propertyId];
        system.debug('property=='+property);
        List<Pricing_Plan_Components__c> pPComponentLst = [SELECT Id, Name, Price_Lumpsum__c, Price_age__c, Price_per_SQFT__c, GST_Treatment__c,
                                                           Project_Add_On_Charges__r.Name, Project_Add_On_Charges__r.Age_Calculated_on__c, 
                                                           Project_Add_On_Charges__r.Charge_Group__c, Project_Add_On_Charges__r.Charge_Type__c,
                                                           Project_Add_On_Charges__r.RecordType.Name, Project_Add_On_Charges__r.Is_Optional__c,
                                                           Project_Add_On_Charges__c
                                                           FROM Pricing_Plan_Components__c 
                                                           WHERE Pricing_Plan__c =: property.Property_Price_Slab__c];
        for(Pricing_Plan_Components__c pPComponent: pPComponentLst){
            if(pPComponent.Project_Add_On_Charges__r.Charge_Type__c == 'Fixed'){
                if(pPComponent.Name != '2 Wheeler Parking' && pPComponent.Name != 'Car Parking Space'){
                system.debug('pPComponent---------'+pPComponent);
                Decimal amount = 0;
                Boolean addAmount = false;
                Boolean addDetails = false;
                Decimal discount = 0;
                
                if(!pPComponent.Project_Add_On_Charges__r.Is_Optional__c && pPComponent.Project_Add_On_Charges__r.RecordType.Name == 'Charges'){
                    addAmount = true;
                    addDetails = true;
                }
                else if(addOnsMap.containsKey(pPComponent.Project_Add_On_Charges__r.Name)){
                    if( addOnsMap.get(pPComponent.Project_Add_On_Charges__r.Name).addOnId == pPComponent.Project_Add_On_Charges__c &&
                       !addOnsMap.get(pPComponent.Project_Add_On_Charges__r.Name).included){
                           addAmount = true;
                           addDetails = true;
                       }
                    else if(addOnsMap.get(pPComponent.Project_Add_On_Charges__r.Name).addOnId == pPComponent.Project_Add_On_Charges__c){
                        addDetails = true;
                    }
                }
                
                if(addAmount){
                    amount = pPComponent.Price_Lumpsum__c != null? pPComponent.Price_Lumpsum__c: pPComponent.Price_per_SQFT__c*property.Total_Area__c;
                    
                    if(addOnsMap.containsKey(pPComponent.Project_Add_On_Charges__r.Name) && addOnsMap.get(pPComponent.Project_Add_On_Charges__r.Name).unit !=null)
                    {
                        
                        amount = amount*addOnsMap.get(pPComponent.Project_Add_On_Charges__r.Name).unit;
                        
                    }
                    
                    
                }
                
                if(pPComponent.Project_Add_On_Charges__r.Charge_Group__c.contains('Floor Rise')){
                    amount = amount*Decimal.valueOf(property.Floor__c);
                    
                }
                System.debug(pPComponent.Project_Add_On_Charges__r.Name);
                System.debug(discountMap);
                
                if(discountMap.containsKey(pPComponent.Project_Add_On_Charges__r.Name)){
                    discount = discountMap.get(pPComponent.Project_Add_On_Charges__r.Name);
                }
                if(addDetails){
                    Price_Details__c priceDetail = new Price_Details__c();
                    priceDetail.Booking__c = bookingId;
                    priceDetail.Name = pPComponent.Project_Add_On_Charges__r.Name;
                    priceDetail.GST_Type__c = pPComponent.GST_Treatment__c;
                    priceDetail.Charge_Group__c = pPComponent.Project_Add_On_Charges__r.Charge_Group__c;
                    priceDetail.Amount__c = amount;
                    priceDetail.Discount__c = discount;
                    priceDetailsLst.add(priceDetail);
                }
                
                List<String> chargeGroups = pPComponent.Project_Add_On_Charges__r.Charge_Group__c.split(';');
                
                for(String chargeGroup: chargeGroups){
                    if(chargeGroupMap.containsKey(chargeGroup)){
                        system.debug('Amount==if'+amount);
                        chargeGroupMap.put(chargeGroup, chargeGroupMap.get(chargeGroup) + amount - discount);
                    }
                    else{
                        system.debug('Amount==else'+amount );
                        chargeGroupMap.put(chargeGroup, amount - discount);
                    }
                }
            }
            }
        }
        for(Pricing_Plan_Components__c pPComponent: pPComponentLst)
        {    
            system.debug('pPComponent=='+pPComponent);
        }
        for(Pricing_Plan_Components__c pPComponent: pPComponentLst){
            if(pPComponent.Project_Add_On_Charges__r.Charge_Type__c != 'Fixed'){
                if(pPComponent.Name != '2 Wheeler Parking' && pPComponent.Name != 'Car Parking Space'){
                system.debug('pPComponent---------'+pPComponent);
                Decimal amount = 0;
                Boolean addAmount = false;
                Boolean addDetails = false;
                Decimal discount = 0;
                
                if(!pPComponent.Project_Add_On_Charges__r.Is_Optional__c && pPComponent.Project_Add_On_Charges__r.RecordType.Name == 'Charges'){
                    addAmount = true;
                    addDetails = true;
                }
                else if(addOnsMap.containsKey(pPComponent.Project_Add_On_Charges__r.Name)){
                    if( addOnsMap.get(pPComponent.Project_Add_On_Charges__r.Name).addOnId == pPComponent.Project_Add_On_Charges__c &&
                       !addOnsMap.get(pPComponent.Project_Add_On_Charges__r.Name).included){
                           addAmount = true;
                           addDetails = true;
                       }
                    else if(addOnsMap.get(pPComponent.Project_Add_On_Charges__r.Name).addOnId == pPComponent.Project_Add_On_Charges__c){
                        addDetails = true;
                    }
                }
                System.debug('Req Values-------->'+pPComponent.Price_age__c);
                System.debug('Req Values-------->'+chargeGroupMap.get(pPComponent.Project_Add_On_Charges__r.Age_Calculated_on__c));
                
                if(addAmount){
                    System.debug('%%%%%%%%%%%%%%%%%%%%%%%% pPComponent.Project_Add_On_Charges__r.Age_Calculated_on__c'+pPComponent.Project_Add_On_Charges__r.Age_Calculated_on__c);
                    System.debug('%%%%%%%%%%%%%%%%%%%%%%%% chargeGroupMap.get(pPComponent.Project_Add_On_Charges__r.Age_Calculated_on__c)'+chargeGroupMap.get(pPComponent.Project_Add_On_Charges__r.Age_Calculated_on__c));
                    System.debug('%%%%%%%%%%%%%%%%%%%%%%%% pPComponent.Price_age__c'+pPComponent.Price_age__c);
                    System.debug('%%%%%%%%%%%%%%%%%%%%%%%% amount'+amount);
                    System.debug('%%%%%%%%%%%%%%%%%%%%%%%% Index__c'+property.Index__c);
                    Decimal AgreementValue = 0;
                    System.debug('TEST 1111'+AgreementValue);
                    System.debug('TEST 1112'+chargeGroupMap);
                    if(chargeGroupMap.size() > 0 && chargeGroupMap.containsKey('Agreement')){
                        AgreementValue = chargeGroupMap.get('Agreement');
                    }
                    System.debug('TEST 1113'+AgreementValue);
                    System.debug('TEST 1114'+property);
                    System.debug('TEST 1115'+property.Index__c);
                    System.debug('TEST 1117'+pPComponent);
                    System.debug('TEST 1116'+pPComponent.Price_age__c);
                    if(pPComponent !=null && pPComponent.Price_age__c !=null ){
                    if(property !=null && property.Index__c > AgreementValue){
                        amount = (pPComponent.Price_age__c*property.Index__c)/100;
                    } 
                    else{
                        amount = (pPComponent.Price_age__c*AgreementValue)/100;
                        
                    }
                    }
                }
                
                if(discountMap.containsKey(pPComponent.Project_Add_On_Charges__r.Name)){
                    discount = discountMap.get(pPComponent.Project_Add_On_Charges__r.Name);
                }
                
                if(addDetails){
                    Price_Details__c priceDetail = new Price_Details__c();
                    priceDetail.Booking__c = bookingId;
                    priceDetail.Name = pPComponent.Project_Add_On_Charges__r.Name;
                    priceDetail.GST_Type__c = pPComponent.GST_Treatment__c;
                    priceDetail.Charge_Group__c = pPComponent.Project_Add_On_Charges__r.Charge_Group__c;
                    priceDetail.Amount__c = amount;
                    priceDetail.Discount__c = discount;
                    priceDetailsLst.add(priceDetail);
                }
                List<String> chargeGroups = pPComponent.Project_Add_On_Charges__r.Charge_Group__c.split(';');
                for(String s : chargeGroups){
                    System.debug('&&&&&&&&'+s);
                }
                for(String chargeGroup: chargeGroups){
                    if(chargeGroupMap.containsKey(chargeGroup)){
                        chargeGroupMap.put(chargeGroup, chargeGroupMap.get(chargeGroup) + amount - discount);
                    }
                    else{
                        chargeGroupMap.put(chargeGroup, amount - discount);
                    }
                }
            }
            }
        }
        chargeGroupMap.put('GST', 0);
        for(Price_Details__c p:priceDetailsLst)
        {
            system.debug('price p=='+priceDetailsLst);
        }
        Opportunity opp =[select id,Project__c,Project__r.GST_Applicable__c from Opportunity where id=:oppId];
        if(opp.Project__r.GST_Applicable__c==true)
        {
            for(Price_Details__c priceDetail: priceDetailsLst){
                system.debug('priceDetail=='+priceDetail);
                if(priceDetail.GST_Type__c == 'Standard'){
                    if(chargeGroupMap.get('Agreement') > 4500000){
                        priceDetail.GST__c = 5;
                    }
                    else {
                        priceDetail.GST__c = 1;
                    }
                }
                else {
                    priceDetail.GST__c = Decimal.valueOf(priceDetail.GST_Type__c.substringBefore('%'));
                }
                System.debug('property.Index__c'+property.Index__c);
                System.debug('chargeGroupMap.get'+chargeGroupMap.get('Agreement'));
                if(property.Index__c > chargeGroupMap.get('Agreement')){
                    System.debug('Greater property.Index__c');
                    chargeGroupMap.put('GST', chargeGroupMap.get('GST') + ((property.Index__c)*priceDetail.GST__c/100));
                }
                else{
                    System.debug('Greater Agreement');
                    chargeGroupMap.put('GST', chargeGroupMap.get('GST') + ((priceDetail.Amount__c - priceDetail.Discount__c)*priceDetail.GST__c/100));
                }
                system.debug('chargeGroupMap=='+chargeGroupMap);
            }
        }
        else
        {
            for(Price_Details__c priceDetail: priceDetailsLst){
                system.debug('priceDetail=='+priceDetail);
                if(priceDetail.GST_Type__c == 'Standard' && priceDetail.Charge_Group__c!='Agreement'){
                    if(chargeGroupMap.get('Agreement') > 4500000){
                        priceDetail.GST__c = 5;
                    }
                    else {
                        priceDetail.GST__c = 1;
                    }
                }
                else if(priceDetail.Charge_Group__c!='Agreement') {
                    priceDetail.GST__c = Decimal.valueOf(priceDetail.GST_Type__c.substringBefore('%'));
                }
                else
                {
                    priceDetail.GST__c = 0;
                } 
                System.debug('property.Index__c'+property.Index__c);
                System.debug('chargeGroupMap.get'+chargeGroupMap.get('Agreement'));
                if(property.Index__c > chargeGroupMap.get('Agreement')){
                    System.debug('Greater property.Index__c');
                    chargeGroupMap.put('GST', chargeGroupMap.get('GST') + ((property.Index__c)*priceDetail.GST__c/100));
                }
                else{
                    System.debug('Greater Agreement');
                    chargeGroupMap.put('GST', chargeGroupMap.get('GST') + ((priceDetail.Amount__c - priceDetail.Discount__c)*priceDetail.GST__c/100));
                }             
                system.debug('chargeGroupMap=='+chargeGroupMap);
            }
        }
        system.debug('chargeGroupMap=='+chargeGroupMap); 
        PriceInfo priceInfo = new PriceInfo();
        priceInfo.chargeGroupMap = chargeGroupMap;
        priceInfo.priceDetails = priceDetailsLst;
        priceInfo.inclusions = inclusions;
        priceInfo.PricingPlan=pPComponentLst;
        return priceInfo;
    }
    
    public class ADDON{
        
        public Id addOnId;
        public Boolean included;
        public decimal unit;
        
        public ADDON(Id addOnId, Boolean included,decimal unit ){
            this.addOnId = addOnId;
            this.included = included;
            this.unit= unit;
        }
    }
    
    public class PriceInfo{
        
        public Map<String, Decimal> chargeGroupMap;
        public Map<String, List<String>> inclusions;
        public List<Price_Details__c> priceDetails;
        public list<Pricing_Plan_Components__c> PricingPlan;
    }
}