Global without Sharing class EOICAFormDocController {
    // Global ApexPages.StandardController standardController;
    Public Opportunity Opportunity {get;set;}
    Public Boolean ShowHeader {get;set;}
    Public Boolean showFooter {get;set;}
    Public string ProjectHeader{get;set;}
    Public string ProjectFooter{get;set;}
    Public string termsAndCondition{get;set;}
    public String residenceAddress { get; set; }
    Public List<Suggested_Property__c> suggProprtyRecord {get;set;}
    Public Property__c propertyRecord {get;set;}
    Global EOICAFormDocController(ApexPages.StandardController stdController) {
        ShowHeader = false;
        showFooter = false;
        String recordId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('recordid --'+recordid);
        Opportunity = [SELECT id, Name,AccountId, Project__c, Walk_in_Source__c,Budget1__c,Project__r.Name,
                       Construction_Status__c, Source_of_Funding__c, Nature_of_Use__c,Last_Site_Visit_Date_CIF__c,
                       Interested_Configuration__c,Date_of_Site_Visit__c,Channel_Partner__c,EOI_CA__c,
                       Channel_Partner__r.Name, Sales_Manager__c,Sales_Manager__r.Name,Channel_Partner__r.RERA_Number__c,
                       Sourcing_Manager__c,Sourcing_Manager__r.Name, Secondary_Sales_Manager__c,Channel_Partner__r.Phone,
                       Secondary_Sales_Manager__r.Name,Referral_By_Customer__r.Name, Project_Carpet_Area__c, EOI_CA_Number__c,
                       Referral_By_Customer__c, Referral_Type__c, Referral_Name__c, Referral_Mobile_Number__c,
                       Account.Salutation,Account.Name,Account.FirstName,Account.LastName,Account.PersonEmail,EOI_CA_stage__c,
                       Account.PersonMobilePhone,EOI_CA_Payment_Received__c,EOI_CA_Form_Sent_Date_Time__c,
                       Project__r.Configuration__c,Project__r.Budgets__c,Project__r.Project_Carpet_Area__c,
                       Opportunity.Apartment_Number__c,Account.PersonMailingStreet,Account.PersonMailingState,
                       Account.PersonMailingPostalCode,Account.PersonMailingCountry,Account.PersonMailingCity,
                       Account.Locality__c,Account.Apartment_Flat__c,Account.Age__c,Account.Nationality__c,
                       Account.Employment_Type__c,Account.Designation_or_Position__pc,Account.Company_Name__pc,
                       Account.Office_Locality__c,EOI_CA_Form_Submission_Date_and_Time__c,Account.Residence_Address__c,
                       Project__r.CA_Terms_Conditions__c,Project__r.EOI_Terms_Conditions__c,Floor_Preference__c,
                       Project__r.Launch_CA_Period_s_End_Date__c, Project__r.Launch_EOI_Period_s_End_Date__c
                       FROM Opportunity 
                       WHERE Id =: recordId 
                       Limit 1];
         if(  Opportunity.Account.Residence_Address__c != null &&  Opportunity.Account.Residence_Address__c != '')
                   {
                        residenceAddress =  Opportunity.Account.Residence_Address__c;
                   }
                   else
                   {
                       if( Opportunity.Account.Apartment_Flat__c != null &&  Opportunity.Account.Apartment_Flat__c != '')
                       {
                           residenceAddress =  Opportunity.Account.Apartment_Flat__c +' ';
                       }
                       if( Opportunity.Account.PersonMailingStreet != null &&  Opportunity.Account.PersonMailingStreet != '')
                       {
                           residenceAddress =  Opportunity.Account.PersonMailingStreet +' ';
                       }
                       if( Opportunity.Account.PersonMailingCity != null &&  Opportunity.Account.PersonMailingCity != '')
                       {
                           residenceAddress = residenceAddress + Opportunity.Account.PersonMailingCity +' ';
                       }
                       if( Opportunity.Account.PersonMailingCity != null &&  Opportunity.Account.PersonMailingCity != '')
                       {
                           residenceAddress = residenceAddress + Opportunity.Account.PersonMailingCity +' ';
                       }
                       if( Opportunity.Account.PersonMailingState != null && Opportunity.Account.PersonMailingState != '')
                       {
                           residenceAddress = residenceAddress + Opportunity.Account.PersonMailingState +' ';
                       }
                        if( Opportunity.Account.PersonMailingCountry != null &&  Opportunity.Account.PersonMailingCountry != '')
                       {
                           residenceAddress = residenceAddress + Opportunity.Account.PersonMailingCountry;
                       }
                   }
        
        List<Project__c> projectList = [SELECT id, name,OTP_Disable_Till__c, Project_Header__c,Budgets__c, 
                                        Project_Footer__c, Configuration__c,Project_Carpet_Area__c,
                                        EOI_Terms_Conditions__c,CA_Terms_Conditions__c
                                        FROM Project__c 
                                        WHERE id =: Opportunity.Project__c];
        suggProprtyRecord=[Select Id,Name,Opportunity__c,Unit__c 
                           From Suggested_Property__c 
                           Where Opportunity__c =: recordId AND Status__c = 'Confirmed Allocation'];
        if(!suggProprtyRecord.isEmpty()){
            propertyRecord=[Select Id,Name,Annexure__c,Annexures__c,Terms_Conditions__c,Flat_Type__c,RERA_Carpet_Area__c,RERA_Carpet_Area_in_sqmtr__c,Utility_Area__c,Enclosed_balcony__c,Deck_Carpet_Area__c,
                            Proposed_Area__c,Proposed_Area_c_in_sqmtr__c,Approved_Area__c,Approved_Area_in_sqmtr__c,Deck_Approved_Area__c,Deck_Proposed_Area__c,Proposed_Utility_Area__c,
                            Proposed_Enclosed_Balcony_Area__c,Deck_Carpet_Area_c_in_sqmtr__c,Property_Area__c,Utility_Area_in_sqmtr__c,Enclosed_Balcony_in_sqmtr__c,
                            Property_Area_in_sqmtr__c,Proposed_Deck_Area_in_sq_mt__c,Approved_Deck_Area_in_sq_mt__c,Proposed_Utility_Area_in_sq_mt__c,Proposed_Enclosed_Balcony_Area_sq_mt__c,
                            Total_Area__c,Total_Area_in_sq_mt__c,Proposed_Total_Area__c,Proposed_Total_Area_in_sq_mt__c
                            From Property__c Where Id=:suggProprtyRecord[0].Unit__c];
        }
        if(!projectList.isempty()){
            ShowHeader = true;
            showFooter = true;
            ProjectHeader = projectList[0].Project_Header__c;
            ProjectFooter = projectList[0].Project_Footer__c;
            if(Opportunity.EOI_CA__c == 'EOI')
            {
                termsAndCondition = projectList[0].EOI_Terms_Conditions__c;
            }
            else if(Opportunity.EOI_CA__c == 'CA')
            {
                termsAndCondition = projectList[0].CA_Terms_Conditions__c;
                
            }
            // ProjectName = projectList[0].Name;
        }
    }
    
}