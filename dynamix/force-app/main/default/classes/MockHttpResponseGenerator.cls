@isTest
public class MockHttpResponseGenerator implements HttpCalloutMock 
{
    public HTTPResponse respond(HTTPRequest req) 
    {
        
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('Sample Response');
        return res;
    }
}