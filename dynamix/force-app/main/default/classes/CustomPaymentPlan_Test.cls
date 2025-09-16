@isTest
public class CustomPaymentPlan_Test {
	 @isTest
     public static void CustomPaymentPlanMethod()
     {	
         Project__c projectObject = new Project__c();
         projectObject.Name = 'test';
         insert projectObject;
         
         Payment_Plan__c payment = new Payment_Plan__c();
         payment.Name = 'TEST';
         payment.Project__c = projectObject.Id;
         insert payment;
         
         Project_Progress__c projectProgress = new Project_Progress__c();
         projectProgress.Name = 'testProject';
         projectProgress.Project__c = projectObject.Id;
         projectProgress.Stage_Type__c = 'Plinth';
         insert projectProgress;
         
         Test.startTest();
         
         Payment_Plan_Milestones__c paymentObject  = new Payment_Plan_Milestones__c();
         paymentObject.Days_after_Booking__c =   20;
         paymentObject.Milestone_age__c = 20; 
         paymentObject.Milestone_Activation__c= 'Booking Date';
         paymentObject.Name  = 'Test';
         paymentObject.Payment_Plan__c= payment.Id;
         paymentObject.Project_Progress__c= projectProgress.Id;
         paymentObject.Sequence_No__c = 30;
         insert paymentObject;
        
         Payment_Plan_Milestones__c paymentObject1  = new Payment_Plan_Milestones__c();
         paymentObject1.Days_after_Booking__c =   20;
         paymentObject1.Milestone_age__c = 20; 
         paymentObject1.Milestone_Activation__c= 'Booking Date';
         paymentObject1.Name  = 'Test';
         paymentObject1.Payment_Plan__c= payment.Id;
         paymentObject1.Project_Progress__c= projectProgress.Id;
         paymentObject1.Sequence_No__c = 30;
         insert paymentObject1;
         try{
            CustomPaymentPlan.Requests request = new CustomPaymentPlan.Requests();
            request.planId = payment.Id;
        
            String playmentPlanDetail = CustomPaymentPlan.getPaymentPlanMilestones(new List<CustomPaymentPlan.Requests>{request})[0];
         }catch(Exception e){}
         Test.stopTest();
     }
}