public class EOICALinkExpirationController{
    
    @AuraEnabled
    public static String EOICALinkExpirationMethod(String recordId){
        string status = '';
       
        Opportunity  thisOpportunity =  [SELECT ID,EOI_CA_Form_Sent_Date_Time__c,EOI_CA_Form_Submission_Date_and_Time__c,EOI_CA_stage__c, EOI_CA__c
                                         FROM Opportunity
                                         WHERE ID =: recordId
                                         LIMIT 1];
        
        system.debug('thisOpportunity------>'+thisOpportunity.EOI_CA_Form_Sent_Date_Time__c);
      
        if(thisOpportunity.EOI_CA_Form_Submission_Date_and_Time__c != null)
        {
            status = thisOpportunity.EOI_CA__c+' Form  is Submitted.';
        }
        else if(thisOpportunity.EOI_CA_Form_Sent_Date_Time__c != null )
        {
            if(thisOpportunity.EOI_CA_Form_Sent_Date_Time__c.addHours(24) < system.now())
            { 
                System.debug('true');
                status = 'Expired';
            }
            else
            {
                System.debug('false');
                status = thisOpportunity.EOI_CA__c+' Form Link is Activated.';
            }
        }
        return status;
    }
}