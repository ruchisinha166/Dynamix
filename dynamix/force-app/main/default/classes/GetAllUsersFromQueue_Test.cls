@isTest
public class GetAllUsersFromQueue_Test {
    @isTest
    public static void test01(){
        List<GetAllUsersFromQueue.Requests> requestsList = new List<GetAllUsersFromQueue.Requests>();
        GetAllUsersFromQueue.Requests requests = new GetAllUsersFromQueue.Requests();
        
        requests.queueName = 'S&M Head';
        requestsList.add(requests);
        GetAllUsersFromQueue.methodName(requestsList);
    }
    
}