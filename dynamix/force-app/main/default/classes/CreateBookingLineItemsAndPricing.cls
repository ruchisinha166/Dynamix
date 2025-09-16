public with sharing class CreateBookingLineItemsAndPricing {
    
    @InvocableMethod(label='Create Booking Line Items and Pricing')
    public static void execute( List<Requests> requestLst){
        
        String suggestedPropertyId = requestLst[0].suggestedPropertyId;
        String propertyId = requestLst[0].propertyId;
        String opportunityId = requestLst[0].opportunityId;
        
        system.debug('inside CreateBookingLineItemsAndPricing====');
        list<booking__c> bookingList = new list<booking__c>();
        Opportunity opp = [SELECT Id, AccountId,Project__c,Project__r.Project_Status__c,
                           OwnerId,Sourcing_Manager__c,Channel_Partner__c 
                           FROM Opportunity 
                           WHERE Id =: opportunityId];
        Property__c property = [SELECT Id, Name,Tower__c,Project__c,Project__r.GST_Applicable__c ,
                                Property_Price_Slab__c 
                                FROM Property__c 
                                WHERE Id =: propertyId];
        
        List<Property_Add_On__c> propertyAddOns = [SELECT Id, Project_Add_On__c, Is_Included__c, Project_Add_On__r.Name
                                                   FROM Property_Add_On__c 
                                                   WHERE Property__c =: propertyId];
        
        List<Add_On__c> oppAddOns = [SELECT Id, Opportunity__c, Project_Add_On_Charges__c, Project_Add_On_Charges__r.Name, Parking_Value__c, 
                                     Parking_GST_Value__c, Car_Parking__c FROM Add_On__c 
                                     WHERE Opportunity__c =: opportunityId];
        
        Suggested_Property__c suggestedProperty = [SELECT Id, Payment_Plan_Detail__c, Discount__c 
                                                   FROM Suggested_Property__c 
                                                   WHERE Id =: suggestedPropertyId];
        Decimal percentage = 0;
        list<Brokerage_Ladder__c> brokerageLadderList = new  list<Brokerage_Ladder__c>();
        if(opp.Project__r.Project_Status__c=='Sustenance' && opp.Channel_Partner__c!=null)
        {
            brokerageLadderList =[select id,Name,project__c,RecordType.Name,Percentage__c,RecordTypeId from Brokerage_Ladder__c where project__c=: opp.Project__c and RecordType.Name=:'Sustenance'];
            if(brokerageLadderList.size()>0)
            {
                percentage =brokerageLadderList[0].Percentage__c;
            }
            system.debug('brokerageLadderList=='+brokerageLadderList );
        }
        
        if(opp.Project__r.Project_Status__c=='Launch' && opp.Channel_Partner__c!=null)
        {
            
            bookingList = [select id,Channel_Partner__c,Brokerage_Percentage__c 
                           from booking__c 
                           where Channel_Partner__c=:opp.Channel_Partner__c ];
            brokerageLadderList =[select id,name,project__c,Unit_Count__c,RecordType.Name,
                                  Percentage__c,RecordTypeId 
                                  from Brokerage_Ladder__c 
                                  where  RecordType.Name='Launch' ORDER BY Unit_Count__c ASC];
            if(brokerageLadderList.size()>0)
            {
                system.debug('brokerageLadderList=='+brokerageLadderList );
                percentage =brokerageLadderList[0].Percentage__c;
                system.debug('percentage==outside'+percentage); 
                for(Brokerage_Ladder__c b : brokerageLadderList )
                {
                    
                    if(bookingList.size()<b.Unit_Count__c)
                    {
                        system.debug('b=='+b);
                        percentage =b.Percentage__c;
                        break;
                        system.debug('percentage=='+percentage); 
                    }        
                }
            }
        }
        for(booking__c b: bookingList)
        {
            b.Brokerage_Percentage__c=percentage;
        }
        update bookingList;
        Booking__c booking = new Booking__c();
        booking.Sales_Manager__c= opp.OwnerId;
        booking.Sourcing_Manager__c = opp.Sourcing_Manager__c;
        booking.Channel_Partner__c = opp.Channel_Partner__c;
        booking.Primary_Applicant__c = opp.AccountId;
        booking.Prior_Primary_Applicant__c = opp.AccountId;
        booking.Related_Opportunity__c = opportunityId;
        booking.Related_Opportunity__c = opportunityId;
        system.debug('percentage=='+percentage);
        booking.Brokerage_Percentage__c=percentage;
        /* booking.Related_Enquiry__c = opp.Linked_Enquiry__c; */
        booking.Related_Suggested_Property__c = suggestedPropertyId;
        
        if(property != null){
            booking.Tower_Name__c = property.Tower__c;
            booking.Project_Name__c = property.Project__c;
        }
        
        insert booking;
        list<Price_Details__c> priceDetails = [select id,Amount__c,Amount_after_discount__c,Charge_Group__c,GST__c, GST_Calculated__c, booking__c from Price_Details__c where booking__c=:booking.id  and Charge_Group__c='Others'];
        decimal otherChargesAmount=0;
        decimal otherChargesGST=0;
        system.debug('priceDetails=='+priceDetails );
        for(Price_Details__c p: priceDetails)  
        {
            system.debug('otherChargesAmount=='+otherChargesAmount );
            system.debug('otherChargesGST =='+otherChargesGST );  
            otherChargesAmount =otherChargesAmount+p.Amount__c;
            otherChargesGST = otherChargesGST+p.GST_Calculated__c;  
        }
        system.debug('otherChargesAmount=='+otherChargesAmount );
        system.debug('otherChargesGST=='+otherChargesGST);
        Co_Applicant__c applicant = new Co_Applicant__c();
        applicant.Booking__c = booking.Id;
        applicant.Account__c = opp.AccountId;
        applicant.Role__c = 'Primary';
        applicant.Ownership__c = 100;
        
        insert applicant;
        
        List<Booking_Line_Items__c> bLIItems = new List<Booking_Line_Items__c>();
        
        Booking_Line_Items__c bLI = new Booking_Line_Items__c();
        bLI.Name = property.Name;
        bLI.Property__c = propertyId;
        bLI.Booking__c = booking.Id;
        
        bLIItems.add(bLI);
        
        for(Property_Add_On__c propertyAddOn: propertyAddOns){
            Booking_Line_Items__c bLIPropAddOn = new Booking_Line_Items__c();
            bLIPropAddOn.Name = propertyAddOn.Project_Add_On__r.Name;
            bLIPropAddOn.Project_Add_On_Charges__c = propertyAddOn.Project_Add_On__c;
            bLIPropAddOn.Property__c = propertyId;
            bLIPropAddOn.Booking__c = booking.Id;
            
            bLIItems.add(bLIPropAddOn);
        }
        
        for(Add_On__c oppAddOn: oppAddOns){
            Booking_Line_Items__c bLIPropAddOn = new Booking_Line_Items__c();
            bLIPropAddOn.Name = oppAddOn.Project_Add_On_Charges__r.Name;
            bLIPropAddOn.Project_Add_On_Charges__c = oppAddOn.Project_Add_On_Charges__c;
            bLIPropAddOn.Booking__c = booking.Id;
            
            bLIItems.add(bLIPropAddOn);
        }
        
        insert bLIItems;
        
        suggestedProperty.Discount__c = suggestedProperty.Discount__c == null? 0:suggestedProperty.Discount__c;
        
        PricingHelper.PriceInfo priceInfo = PricingHelper.getPricing(propertyId, opportunityId, booking.Id, new Map<String, Decimal>{ 'Basic Price' => suggestedProperty.Discount__c});
        List<Pricing_Plan_Components__c> PricingPlan = PriceInfo.PricingPlan;
        insert priceInfo.priceDetails;
        Decimal TotalCharges= 0;
        Decimal otherChargeGST =0;
        Decimal GST=0;
        Decimal GstAmount=0;
        Decimal flatCost=0;
        if(priceInfo.chargeGroupMap.containsKey('Agreement')){
            flatCost = priceInfo.chargeGroupMap.get('Agreement');
        }
        if(priceInfo.chargeGroupMap.containsKey('GST')){
            GstAmount = priceInfo.chargeGroupMap.get('GST');
        }
        for(Pricing_Plan_Components__c p : PricingPlan)
        {
            
            if(p.Project_Add_On_Charges__r.RecordType.Name=='Charges'  && p.Project_Add_On_Charges__r.Charge_Group__c=='Others')
            {    
                if(p.Price_Lumpsum__c!=null)
                {
                    TotalCharges =TotalCharges +p.Price_Lumpsum__c;
                }
                else
                {
                    p.Price_Lumpsum__c=p.Price_per_SQFT__c *suggestedProperty.Unit__r.RERA_Carpet_Area__c;
                    TotalCharges =TotalCharges +p.Price_Lumpsum__c;
                }
                if(p.GST_Treatment__c  !='Standard')
                {
                    otherChargeGST = otherChargeGST+ (p.Price_Lumpsum__c * Decimal.valueOf(p.GST_Treatment__c.removeEnd('%')))/100;
                }
                else
                {
                    otherChargeGST =otherChargeGST+ (p.Price_Lumpsum__c * 5 );
                }       
            }
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
        List<Payment_Milestones__c> paymentMilestoneLst = new List<Payment_Milestones__c>();
        for(Add_On__c parkingAddOn: oppAddOns){
            if(parkingAddOn.Car_Parking__c != null && parkingAddOn.Parking_Value__c != null){
                flatCost += parkingAddOn.Parking_Value__c;
            }
            if(parkingAddOn.Car_Parking__c != null && parkingAddOn.Parking_GST_Value__c != null){
                GstAmount += parkingAddOn.Parking_GST_Value__c;
            }
        }
        Decimal greaterVal= 0;
        Decimal paymentMilestoneAmount =0 ;
        for(Payment_Plan_Milestones__c paymentPlan: (List<Payment_Plan_Milestones__c>)JSON.deserialize(suggestedProperty.Payment_Plan_Detail__c, List<Payment_Plan_Milestones__c>.class)){
            system.debug('paymentPlan----'+paymentPlan);
            Payment_Milestones__c paymentMilestone = new Payment_Milestones__c();
            paymentMilestone.Booking__c = booking.Id;
            paymentMilestone.Name = paymentPlan.Name;
            paymentMilestone.Project_Progress__c = paymentPlan.Project_Progress__c;
            paymentMilestone.Sequence_No__c = paymentPlan.Sequence_No__c;
            paymentMilestone.Sap_Code__c = paymentPlan.Milestone_Code__c;
            paymentMilestone.Milestone_age__c = paymentPlan.Milestone_age__c;
            //paymentMilestone.Milestone_Amount1__c = priceInfo.chargeGroupMap.get('Agreement') * paymentPlan.Milestone_age__c/100;
            paymentMilestone.Milestone_Amount1__c = flatCost * paymentPlan.Milestone_age__c/100;
            paymentMilestone.Remaining_Unit_Cost__c = paymentMilestone.Milestone_Amount1__c*0.99;
            paymentMilestone.Milestone_Master__c = paymentPlan.Milestone_Master__c;
            paymentMilestoneAmount = paymentMilestoneAmount+ paymentMilestone.Milestone_Amount1__c ;
            
            if(property.Project__r.GST_Applicable__c==true)
            {
                System.debug('priceInfo:'+priceInfo);
                System.debug('paymentPlan:'+paymentPlan);
                System.debug('GstAmount:'+GstAmount);
                System.debug('priceInfo.chargeGroupMap.get(GST):'+priceInfo.chargeGroupMap.get('GST'));
                System.debug('paymentPlan.Milestone_age__c:'+paymentPlan.Milestone_age__c);
                // paymentMilestone.GST_Amount1__c = priceInfo.chargeGroupMap.get('GST') * paymentPlan.Milestone_age__c/100;
                paymentMilestone.GST_Amount1__c = GstAmount * paymentPlan.Milestone_age__c/100;
                System.debug('paymentMilestone.GST_Amount1__c :'+paymentMilestone.GST_Amount1__c);
            }
            else
            {
                paymentMilestone.GST_Amount1__c = 0;
            }
            if(paymentPlan.Days_after_Booking__c != null)
            {
                paymentMilestone.Milestone_Activation_Date__c = System.today().addDays(Integer.valueOf(paymentPlan.Days_after_Booking__c));
            }
            if(greaterVal<paymentPlan.Sequence_No__c)
            {
                greaterVal =paymentPlan.Sequence_No__c;
            }
            paymentMilestoneLst.add(paymentMilestone);
            system.debug('paymentMilestoneLst----'+paymentMilestoneLst);
        }
        system.debug('TotalCharges'+TotalCharges);
        if(TotalCharges!=0)
        {
            Payment_Milestones__c paymentMilestone = new Payment_Milestones__c();
            paymentMilestone.Booking__c = booking.Id;
            paymentMilestone.Name = 'Possession/Handover(Other) Charge';
            paymentMilestone.Sequence_No__c = greaterVal+1;
            paymentMilestone.Milestone_age__c = 0;
            paymentMilestone.Milestone_Amount1__c = TotalCharges;
            paymentMilestone.Remaining_Unit_Cost__c = TotalCharges;
            paymentMilestone.GST_Amount1__c = otherChargeGST;
            paymentMilestone.Sap_Code__c = 'Z1628';
            paymentMilestone.Calculate_TDS__c = False;
            //paymentMilestoneAmount = paymentMilestoneAmount+ paymentMilestone.Milestone_Amount1__c ;
            paymentMilestoneLst.add(paymentMilestone);
            insert paymentMilestoneLst;
            system.debug('paymentMilestoneLst----'+paymentMilestoneLst);
            BooKing__c updateBooking = New BooKing__c();
            updateBooking.id =  booking.Id;
            updateBooking.Payment_Milestone_Amount__c = paymentMilestoneAmount;
            update  updateBooking;
        }
        
    }
    
    public class Requests {
        
        @InvocableVariable(label='Suggested Property Id' required=true)
        public String suggestedPropertyId;
        
        @InvocableVariable(label='Property Id' required=true)
        public String propertyId;
        
        @InvocableVariable(label='Opportunity Id' required=true)
        public String opportunityId;
    }
}