public class advancedPaymnetAdjust {
	@InvocableMethod(label='Adjust Broker Paymnet')
    public static list<decimal> adjustAdvancedbrokerPymnt(List<Request> Requests){
        List<decimal> amountList = new list<decimal>();
        id projectId = Requests[0].projectId;
        decimal totalAmount = Requests[0].totalAmount;
        id accountId = Requests[0].amountId;
        List<Project_Advanced_Payment__c> projectAdvancedPayments = new List<Project_Advanced_Payment__c>();
        
        if(projectId != null && accountId != null){
            projectAdvancedPayments = [select id, name,Account__c,Amount__c,Project__c,Status__c from Project_Advanced_Payment__c where Project__c =:projectId and Amount__c != 0 AND Account__c =: accountId and Status__c =: 'Available' order by createddate asc];
        }
        
        for(Project_Advanced_Payment__c pap : projectAdvancedPayments ){
            if(pap.Amount__c > totalAmount && totalAmount > 0){
                pap.Amount__c =   pap.Amount__c - totalAmount;
                totalAmount = 0;
            }
            else if(pap.Amount__c <= totalAmount ){
                totalAmount = totalAmount - pap.Amount__c;
                pap.Amount__c = 0;
                pap.Status__c = 'Adjusted';
            }
        }
        
        update projectAdvancedPayments;
       	amountList.add(totalAmount);
        return amountList;
    }
    
    public class Request {
        @InvocableVariable(label='Project Id' required=true)
        public id projectId;
        @InvocableVariable(label='Amount' required=true)
        public decimal totalAmount;
        @InvocableVariable(label='AccountId' required=true)
        public id amountId;
    }
}