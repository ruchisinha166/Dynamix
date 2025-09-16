@isTest
public class MarkCarParkAvailableTest {
    @isTest
    static void	 testCreateOpportunityAddOns() {
        
        Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account accountObject = new Account();
        accountObject.FirstName = 'test';
        accountObject.LastName = 'Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '455546565';
        accountObject.RecordTypeId = PersonRecId;
        accountObject.PersonEmail = 'dynamix.project@gmail.com';
        accountObject.Aadhar_No__pc = '458785698547';
        accountObject.PAN_No__c = 'ABCTY1234D';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        accountObject.PersonMobilePhone = '6768789684';
        insert accountObject;
       
        Project__c projectObject = new Project__c();
        projectObject.Name = 'Test Project';
        projectObject.Project_Email__c= 'nishi@manras.com';
        projectObject.GST_Applicable__c = true;
        projectObject.Project_Carpet_Area__c = '475 - 1 BHK;900 - 3 BHk';
        projectObject.Budgets__c = 'Under 75 lakhs';
        projectObject.Configuration__c ='3 BHK';
        insert projectObject;
        
        Opportunity oppoObject = new Opportunity();
        oppoObject.AccountId = accountObject.Id;
        oppoObject.Name = 'test Opportunity';
        oppoObject.StageName = 'Site Visit';
        oppoObject.CloseDate = System.Today()+3;
        oppoObject.Project__c = projectObject.Id;
        oppoObject.Walk_in_Source__c = 'Hoarding';
        insert oppoObject;
        
        Property__c propertyObject = new Property__c();
        propertyObject.Name = 'test property';
        propertyObject.Project__c = projectObject.Id;
        propertyObject.Floor__c= '5';
        propertyObject.No_of_Car_Parking__c = 2;
        insert propertyObject;
        
        Property__c CarPark = new Property__c();
        CarPark.Name = 'test Car Park';
        CarPark.Project__c = projectObject.Id;
        CarPark.Flat_Type__c = 'CAR PARKING';
        CarPark.Property_Status__c = 'Allotted In Progress';
        CarPark.Parking_Type__c = 'Puzzle';
        insert CarPark;
        
        Project_Add_On_Charges__c projAddOn = new Project_Add_On_Charges__c();
        projAddOn.Project__c= projectObject.Id;
        projAddOn.Name = 'Car Parking Space';
        insert projAddOn;

        Suggested_Property__c suggProp = new Suggested_Property__c();
        suggProp.Opportunity__c = oppoObject.Id;
        suggProp.Unit__c = propertyObject.Id;
        insert suggProp;
        
        Add_On__c AddOn = new Add_On__c();
        AddOn.Suggested_Property__c = suggProp.Id;
        AddOn.Opportunity__c = oppoObject.Id;
        AddOn.Car_Parking__c = CarPark.Id;
        AddOn.Parking_Value__c = 60000;
        insert AddOn;
        
        Booking__c bookingObject = new Booking__c();
        bookingObject.Stage__c = 'Draft';
        bookingObject.Project_Name__c = projectObject.Id;
        bookingObject.cancellation_fees__c=10000;
        bookingObject.Registration_Status__c = 'Not Started';
        bookingObject.Index_II_Document__c = true;
        bookingObject.Sales_Manager__c = oppoObject.OwnerId;
        bookingObject.Related_Opportunity__c = oppoObject.id;
        bookingObject.Related_Suggested_Property__c = SuggProp.Id;
        insert bookingObject;
    }
}