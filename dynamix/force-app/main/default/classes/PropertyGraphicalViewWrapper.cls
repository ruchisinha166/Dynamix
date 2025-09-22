public with sharing class PropertyGraphicalViewWrapper {
    
    @AuraEnabled
    public List<Tower> towers;

    public class Tower{

        @AuraEnabled
        public String name;

        @AuraEnabled
        public List<Floor> floors;

        public Tower(Property__c prop){

            this.name = prop.Tower__r.Name;
            this.floors = new List<Floor>();
            this.floors.add(new Floor(prop));
        }
    }

    public class Floor{

        @AuraEnabled
        public String name;

        @AuraEnabled
        public List<Property> properties;

        public Floor(Property__c prop){
            this.name = prop.Floor__c;
            this.properties = new List<Property>();
            this.properties.add(new Property(prop));
        }
    }

    public class Property{
        
        @AuraEnabled
        public String id;

        @AuraEnabled
        public String name;

        @AuraEnabled
        public String floor;

        @AuraEnabled
        public String status;

        @AuraEnabled
        public String unitType;

        @AuraEnabled
        public String propertyType;

        @AuraEnabled
        public String tower;

        @AuraEnabled
        public Decimal totalArea;

        @AuraEnabled
        public String preferredLocation;

        @AuraEnabled
        public Decimal basicPrice;

        @AuraEnabled
        public Decimal floorRise;

        @AuraEnabled
        public Decimal pLC;

        @AuraEnabled
        public String bookedBy;

        @AuraEnabled
        public String salesManager;

        @AuraEnabled
        public Date bookingDate;

        @AuraEnabled
        public Id bookingId;

        @AuraEnabled
        public Decimal RERACarpetArea;

        @AuraEnabled
        public Decimal DeckCarpetArea;

        @AuraEnabled
        public Decimal UtilityArea;

        public Property(Property__c prop){
            this.id = prop.Id;
            this.name = prop.Name;
            this.status = prop.Property_Status__c;
            this.unitType = prop.Flat_Type__c;
            this.tower = prop.Tower__r.Name;
            this.floor = prop.Floor__c;
            this.totalArea = prop.Total_Area__c;
            this.RERACarpetArea = prop.RERA_Carpet_Area__c;
            this.DeckCarpetArea = prop.Deck_Carpet_Area__c;
            this.UtilityArea = prop.Utility_Area__c;
            this.preferredLocation = '';
            
            if(prop.Properties_Add_On__r.size() > 0){
                List<String> plcs = new List<String>();
                for(Property_Add_On__c propAddOn: prop.Properties_Add_On__r){
                    plcs.add(propAddOn.Project_Add_On__r.Name);
                }

                this.preferredLocation = String.join(plcs, ', ');
            }
            else{
                this.preferredLocation = 'Not Available';
            }

            this.pLC = 0;
            this.floorRise = 0;
            this.basicPrice = 0;

            if(prop.Pricing_Plan_Detail__c != null){
                PropertyPriceJSON propertyPrice = (PropertyPriceJSON)JSON.deserialize(prop.Pricing_Plan_Detail__c, PropertyPriceJSON.class);

                for(PropertyPriceJSON.PriceComponent component: propertyPrice.components){

                    Decimal price = component.priceLumpSum == null? component.pricePerSQFT*this.totalArea:component.priceLumpSum;
                    if(component.name == 'Basic Price'){
                        this.basicPrice = price;
                    }
                    else if(component.name == 'Floor Rise'){
                        if(prop.Floor__c != null)
                        {
                            this.floorRise = price*Decimal.valueOf(prop.Floor__c);
                        }
                    }
                    else if(component.type == 'Preferred Location' && this.preferredLocation.contains(component.name)){
                        this.pLC += price;
                    }
                }
            }

            if(prop.Suggested_Property__r.size() > 0){
                for(Suggested_Property__c suggestedProp: prop.Suggested_Property__r){
                    if(suggestedProp.Status__c == prop.Property_Status__c && prop.Property_Status__c == 'In Progress'){
                        this.bookedBy = suggestedProp.Opportunity__r.Account.FirstName + ' ' + suggestedProp.Opportunity__r.Account.LastName;
                        this.salesManager = suggestedProp.Opportunity__r.Owner.Name;
                        this.bookingDate = suggestedProp.Status_Change_Date__c;
                    }
                }
            }

            if(prop.Booking_Line_Items__r.size() > 0){
                for(Booking_Line_Items__c booking: prop.Booking_Line_Items__r){
                    this.bookedBy = booking.Booking__r.Primary_Applicant__r.FirstName + ' ' + booking.Booking__r.Primary_Applicant__r.LastName;
                    this.salesManager = booking.Booking__r.Sales_Manager__r.Name;
                    this.bookingDate = booking.Booking__r.Booking_Date__c;
                    this.bookingId = booking.Booking__c;
                }
            }
        }
    }
}