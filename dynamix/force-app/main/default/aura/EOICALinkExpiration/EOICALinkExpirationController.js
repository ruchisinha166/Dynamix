({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        console.log('recordId---'+component.get('v.recordId'));
        var action = component.get("c.EOICALinkExpirationMethod");
        console.log('recordId'+recordId);
        action.setParams({ recordId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == 'Expired')
                {
                    component.set("v.Show",  true);
                }
                else
                {
                     component.set("v.Show",  false);
                     component.set("v.message",  response.getReturnValue() );
                    
                }
                
            }
        });
        $A.enqueueAction(action);
    }
})