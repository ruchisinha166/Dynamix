public with sharing class CarParkingGraphicalViewWrapper {
    
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
        
        @AuraEnabled
        public String parkingType;

        public Floor(Property__c prop){
            this.name = prop.Parking_Type__c;
            this.properties = new List<Property>();
            this.properties.add(new Property(prop));
            this.ParkingType = prop.Parking_Type__c;
        }
    }

    public class Property{
        
        @AuraEnabled
        public String id;
        
        @AuraEnabled
        public String bookingNumber;

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
        
        @AuraEnabled
        public String SnagStatus;
        
        @AuraEnabled
        public String ParkingType;

        public Property(Property__c prop){
            this.id = prop.Id;
            this.name = prop.Name;
            this.status = prop.Property_Status__c;
            this.unitType = prop.Flat_Type__c;
            this.tower = prop.Tower__r.Name;
            this.floor = prop.Floor__c;
            this.ParkingType = prop.Parking_Type__c;
            this.totalArea = prop.Total_Area__c;
            this.RERACarpetArea = prop.RERA_Carpet_Area__c;
            this.DeckCarpetArea = prop.Deck_Carpet_Area__c;
            this.UtilityArea = prop.Utility_Area__c;
            this.SnagStatus = prop.Snag_Status__c;
            this.preferredLocation = '';
            if(prop.Booking__r.Stage__c != 'Cancellation Initiated' || prop.Booking__r.Stage__c != 'Booking Cancelled – Refund Pending'
              || prop.Booking__r.Stage__c != 'Booking Cancelled – Refund Ready' || prop.Booking__r.Stage__c != 'Terminated')
            {
                this.bookedBy = prop.Booking__r.Primary_Applicant_Name_Formulla__c;
                this.salesManager = prop.Booking__r.Sales_Manager__r.Name;
                this.bookingDate = prop.Booking__r.Booking_Date__c;
                this.bookingId = prop.Booking__c;
                this.bookingNumber = prop.Booking__r.Name;
            }
            
            
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
                    if(prop.Property_Status__c == 'Allotted'){
                        this.bookedBy = suggestedProp.Opportunity__r.Account.FirstName + ' ' + suggestedProp.Opportunity__r.Account.LastName;
                        this.salesManager = suggestedProp.Opportunity__r.Owner.Name;
                        this.bookingDate = suggestedProp.Status_Change_Date__c;
                    }
                }
            }

           /* if(prop.Booking__c != null){
                for(Booking_Line_Items__c booking: prop.Booking_Line_Items__r){
                    this.bookedBy = booking.Booking__r.Primary_Applicant__r.FirstName + ' ' + booking.Booking__r.Primary_Applicant__r.LastName;
                    this.salesManager = booking.Booking__r.Sales_Manager__r.Name;
                    this.bookingDate = booking.Booking__r.Booking_Date__c;
                    this.bookingId = prop.Booking__c;
                    this.bookingNumber = prop.Booking__r.Name;
                }
            if(prop.Booking_Line_Items__r.size() >0){
                for(Booking_Line_Items__c booking: prop.Booking_Line_Items__r){
                    this.bookedBy = booking.Booking__r.Primary_Applicant__r.FirstName + ' ' + booking.Booking__r.Primary_Applicant__r.LastName;
                    this.salesManager = booking.Booking__r.Sales_Manager__r.Name;
                    this.bookingDate = booking.Booking__r.Booking_Date__c;
                    this.bookingId = booking.Booking__c;
                    this.bookingNumber = booking.Booking__r.Name;
                }
            }*/
        }
    }
}