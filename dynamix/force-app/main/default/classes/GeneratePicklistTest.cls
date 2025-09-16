@isTest
public class GeneratePicklistTest {
    @isTest
    static void testGetAccountNames() {
        // Create test data for Requests and Results
        GeneratePicklist.Requests request = new GeneratePicklist.Requests();
        request.Budget = 'Budget1;Budget2';
        List<GeneratePicklist.Requests> requestList = new List<GeneratePicklist.Requests>{request};
        
        // Call the @InvocableMethod
        List<GeneratePicklist.Results> resultsList = GeneratePicklist.getAccountNames(requestList);
        
        // Verify the results
        System.assertEquals(1, resultsList.size());
        GeneratePicklist.Results results = resultsList[0];
        System.assertEquals(2, results.budgetPicklist.size());
        System.assertEquals('Budget1', results.budgetPicklist[0]);
        System.assertEquals('Budget2', results.budgetPicklist[1]);
        
        // Test negative scenario - empty Budget field
        request.Budget = '';
        requestList = new List<GeneratePicklist.Requests>{request};
        resultsList = GeneratePicklist.getAccountNames(requestList);
        
    }
}