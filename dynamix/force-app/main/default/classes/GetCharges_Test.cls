@isTest
public class GetCharges_Test {
	 @isTest public static void GetChargesMethod()
     {
         Property__c propertyObject = new Property__c();
         propertyObject.Pricing_Plan_Detail__c = '{"components":[{"type":"Charges","pricePerSQFT":null,"priceLumpSum":15000.00,"name":"Floor Rise","gst":"Standard"},{"type":"Charges","pricePerSQFT":null,"priceLumpSum":300000.00,"name":"Club Membership Charges","gst":"Standard"},{"type":"Charges","pricePerSQFT":null,"priceLumpSum":4000000.00,"name":"Basic Price","gst":"Standard"},{"type":"Charges","pricePerSQFT":null,"priceLumpSum":45000.00,"name":"Registration","gst":"Standard"},{"type":"Parking","pricePerSQFT":null,"priceLumpSum":95000.00,"name":"Basement Parking","gst":"Standard"},{"type":"Preferred Location","pricePerSQFT":null,"priceLumpSum":175000.00,"name":"Garden view","gst":"Standard"},{"type":"Preferred Location","pricePerSQFT":null,"priceLumpSum":125000.00,"name":"Podium View","gst":"Standard"}]}';
	     insert propertyObject;
         
         Project__c projectObject = new Project__c();
         projectObject.Name = 'Test Project ';
         insert projectObject;
         
         Project_Add_On_Charges__c projectAddOn = new Project_Add_On_Charges__c();
         projectAddOn.Name = 'Test Add On';
         projectAddOn.Project__c = projectObject.Id;
         insert projectAddOn;
         
         GetCharges.Requests request = new GetCharges.Requests();
         request.chargeName = 'Test';
         request.chargeType = 'Preferred Location';
         request.propertyId = propertyObject.Id;
         
         List<GetCharges.Requests> reqList = new List<GetCharges.Requests>();
         reqList.add(request);
         GetCharges.execute(reqList);
     }
}