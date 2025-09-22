@isTest
public class BookingTriggerHandlerNew_Test {
    
    @testSetup
    static void setupData() {
        // Insert Ladder Bands
        Ladder_Band__c band1 = new Ladder_Band__c(
            Minimum_Number__c = 1,
            Maximum_Number__c = 5,
            Additional_Brokerage__c = 2
        );
        Ladder_Band__c band2 = new Ladder_Band__c(
            Minimum_Number__c = 6,
            Maximum_Number__c = 10,
            Additional_Brokerage__c = 3
        );
        insert new List<Ladder_Band__c>{ band1, band2 };
    }
    
    @isTest
    static void testBookingBrokerageUpdate() {
        // Create a fake Channel Partner (replace with your real CP object if needed)
        Account channelPartner = new Account(Name = 'Test CP');
        insert channelPartner;
        
        // Insert 3 Bookings → should fall into Band 1 (2%)
        List<Booking__c> bookings = new List<Booking__c>();
        for (Integer i = 0; i < 3; i++) {
            bookings.add(new Booking__c(
               
                Channel_Partner__c = channelPartner.Id
            ));
        }
        insert bookings;
        
        // Reload bookings from DB
        bookings = [
            SELECT Id, Brokerage_Percentage__c
            FROM Booking__c
            WHERE Channel_Partner__c = :channelPartner.Id
        ];
        
        // Assert brokerage is 2% (Band 1)
        for (Booking__c b : bookings) {
            System.assertEquals(2, b.Brokerage_Percentage__c, 'Should match band 1 brokerage');
        }
       
        // Insert 4th, 5th, 6th booking → should push into Band 2 (3%)
        Booking__c booking6 = new Booking__c(
           
            Channel_Partner__c = channelPartner.Id
        );
        insert booking6;
        
        booking6 = [
            SELECT Id, Brokerage_Percentage__c
            FROM Booking__c
            WHERE Id = :booking6.Id
        ];
        
        System.assertEquals(3, booking6.Brokerage_Percentage__c, 'Should match band 2 brokerage');
    }
}