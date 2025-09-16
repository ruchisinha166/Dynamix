public class GeneratePicklist {
    @InvocableMethod(callout=true label='Get Budget')
        public static List<Results> getAccountNames(List<Requests> requestLst) {
            
            List<Results> resultsList=new List<Results>();
            Results r=new Results();
            String str = requestLst[0].Budget;
            List<String> budgetPicklist = str.split(';', 2);
            r.budgetPicklist = budgetPicklist;
            resultsList.add(r);
            System.debug('resultsList'+resultsList);
            return resultsList;
        }
        
    public class Requests {
        @InvocableVariable(label='Budget' required=true)
        public String Budget;
    }
    
    public class Results{
        
        @InvocableVariable
        public List<String> budgetPicklist;
     
    }
    
}