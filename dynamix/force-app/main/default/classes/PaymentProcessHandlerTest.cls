@isTest
public class PaymentProcessHandlerTest {

    @isTest static void testSuccessfulPaymentProcessing() {
        // Prepare Test Data
        
        // Create Booking
        Booking__c booking = new Booking__c(Stage__c = 'Draft');
        insert booking;

        // Create Payment Milestone with enough Remaining Amount
        Payment_Milestones__c milestone = new Payment_Milestones__c(
            Booking__c = booking.Id,
            Name = 'Possession/Handover(Other) Charge',
            Remaining_Milestone_Amount__c = 500,
            Remaining_Unit_Cost__c = 500
        );
        insert milestone;

        // Create Payment record
        Payment__c payment = new Payment__c(Amount__c = 1000);
        insert payment;

        // Prepare PaymentRequest
        List<PaymentProcessHandler.PaymentRequest> reqList = new List<PaymentProcessHandler.PaymentRequest>();
        PaymentProcessHandler.PaymentRequest req = new PaymentProcessHandler.PaymentRequest();
        req.bookingId = booking.Id;
        req.amount = 200;
        req.PaymentId = payment.Id;
        reqList.add(req);

        Test.startTest();
        PaymentProcessHandler.processPayments(reqList);
        Test.stopTest();

        // Validate Payment Line was inserted
        List<Payment_Line__c> paymentLines = [SELECT Id, Amount__c, Payment__c, Milestone__c FROM Payment_Line__c];
        System.assertEquals(1, paymentLines.size(), 'One Payment Line should be created.');

        // Validate Milestone was updated correctly
        Payment_Milestones__c updatedMilestone = [SELECT Remaining_Milestone_Amount__c, Remaining_Unit_Cost__c FROM Payment_Milestones__c WHERE Id = :milestone.Id];
        System.assertEquals(300, updatedMilestone.Remaining_Milestone_Amount__c, 'Remaining Milestone Amount should be reduced by 200.');
        System.assertEquals(300, updatedMilestone.Remaining_Unit_Cost__c, 'Remaining Unit Cost should be reduced by 200.');
    }

    @isTest static void testInsufficientMilestoneAmount() {
        // Prepare Test Data
        
        // Create Booking
        Booking__c booking = new Booking__c(Stage__c = 'Draft');
        insert booking;

        // Create Payment Milestone with insufficient Remaining Amount
        Payment_Milestones__c milestone = new Payment_Milestones__c(
            Booking__c = booking.Id,
            Name = 'Possession/Handover(Other) Charge',
            Remaining_Milestone_Amount__c = 100,
            Remaining_Unit_Cost__c = 100
        );
        insert milestone;

        // Create Payment record
        Payment__c payment = new Payment__c(Amount__c = 1000);
        insert payment;

        // Prepare PaymentRequest where amount > remaining milestone
        List<PaymentProcessHandler.PaymentRequest> reqList = new List<PaymentProcessHandler.PaymentRequest>();
        PaymentProcessHandler.PaymentRequest req = new PaymentProcessHandler.PaymentRequest();
        req.bookingId = booking.Id;
        req.amount = 200;
        req.PaymentId = payment.Id;
        reqList.add(req);

        Test.startTest();
        PaymentProcessHandler.processPayments(reqList);
        Test.stopTest();

        // Validate that no Payment Line was inserted
        List<Payment_Line__c> paymentLines = [SELECT Id FROM Payment_Line__c];
        System.assertEquals(0, paymentLines.size(), 'No Payment Line should be created when milestone amount is insufficient.');

        // Validate that milestone amounts remain unchanged
        Payment_Milestones__c updatedMilestone = [SELECT Remaining_Milestone_Amount__c, Remaining_Unit_Cost__c FROM Payment_Milestones__c WHERE Id = :milestone.Id];
        System.assertEquals(100, updatedMilestone.Remaining_Milestone_Amount__c, 'Remaining Milestone Amount should not change.');
        System.assertEquals(100, updatedMilestone.Remaining_Unit_Cost__c, 'Remaining Unit Cost should not change.');
    }
}