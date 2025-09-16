@RestResource(urlMapping='/opportunity/*')
global class OpportuntiyService {
    @HttpPost

    global static opportunityResponse doPost()
    {   
        try{
        String oppJSON2 = RestContext.request.requestBody.toString();
        string oppJSON = oppJSON2.replaceAll(':,',':"",');
       	system.debug('Json Data'+oppJSON);
        opportunityRequest request = (opportunityRequest)(JSON.deserialize(oppJSON, opportunityRequest.Class));
     	 system.debug('Request------'+request);
            

        return createOpportunityAndAccount.createOpportunity(request);
        }
        catch(Exception ex){
             system.debug('e-------'+ex.getMessage()+' getStackTrace '+ex.getStackTraceString());
            Log.error(ex.getMessage() + '\n' + ex.getStackTraceString());
        }
        return null;
    }
    
}