@isTest
private class TestSnagListDocVfpController {
    
    @isTest
    static void testControllerLogic() {
        string propertyId = ApexPages.currentPage().getParameters().get('Id');
        List<Project_Snag__c> projectSnagList = [SELECT ID, NAME,Project__c,Questions__c 
                                                 FROM Project_Snag__c ];
        List<Unit_Snag_Response__c> allUnitSnagResponseList = [SELECT Id, Name, Property__c, Project_Snag__c ,Project_Snag__r.Questions__c,
                                                               Post_OC_Answers__c,Pre_OC_Answers__c,Pre_OC_End_Date__c
                                                               FROM Unit_Snag_Response__c
                                                               WHERE Property__c =: propertyId];
        Project__c testProjectRcd = new Project__c();
        testProjectRcd.Name = 'Test Project';
        testProjectRcd.Project_Email__c= 'divum@dynamixgroup.co.in';
        testProjectRcd.Project_Carpet_Area__c = '475 - 1 BHK';
        testProjectRcd.Budgets__c = 'Under 75 lakhs';
        testProjectRcd.Configuration__c ='1 BHK';
        testProjectRcd.Project_Head__c = UserInfo.getUserId() ;
        testProjectRcd.Site_Head__c = UserInfo.getUserId() ;
        testProjectRcd.Project_Footer__c = 'tsc.com';
        testProjectRcd.OTP_Disable_Till__c = System.now().addDays(1);
        testProjectRcd.Project_Header__c = 'abc.com';
        insert testProjectRcd;
        
        Project_Snag__c testProjSnag = new Project_Snag__c();
        testProjSnag.Project__c = testProjectRcd.Id;
        testProjSnag.Unit_Type__c = '2 BHK';
        testProjSnag.Area__c = 'KITCHEN';
        testProjSnag.Questions__c = 'Is Flooring Done?';
        insert testProjSnag;
        
        Pricing_Plan__c testPricingPlanRcd = new Pricing_Plan__c();
        testPricingPlanRcd.Name = 'Pricing Plan Test';
        testPricingPlanRcd.Project__c = testProjectRcd.Id;
        insert testPricingPlanRcd;
        
        List <Property__c> propertyList = new List<Property__c>();
        Property__c testPropertyRcd = new Property__c();
        testPropertyRcd.Name = 'test property';
        testPropertyRcd.Project__c = testProjectRcd.Id;
        testPropertyRcd.Property_Price_Slab__c = testPricingPlanRcd.Id;
        testPropertyRcd.Floor__c= '5';
        testPropertyRcd.Flat_Type__c = '2 BHK';
        insert testPropertyRcd;
        
        Unit_Snag_Response__c newUSR =  New Unit_Snag_Response__c();
        newUSR.Project_Snag__c = testProjSnag.id;
        newUSR.Pre_OC_Start_Date__c = system.today();
        newUSR.Property__c = testPropertyRcd.id;
        newUSR.Area__c = testProjSnag.Area__c;
        insert newUSR;
        
        testPropertyRcd.Snag_Status__c = 'Internal Snagging';
        testPropertyRcd.Sub_Snag_Status__c ='Post OC-Verified';
        update testPropertyRcd;
        propertyList.add(testPropertyRcd);
        
        Test.startTest();
        
        PageReference pageRef = Page.SnagListDoc; 
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', testPropertyRcd.Id); 
        pageRef.getParameters().put('meterReading', '10'); 
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testPropertyRcd);
        
        SnagListDocVfpController controller = new SnagListDocVfpController(stdController);
      
        
        Test.stopTest();
    }
}