({
    doInit : function(component,event,helper){
        console.log(' component.get'+ component.get("v.flowValues"));
        var action = component.get("c.getValues");
        action.setParams({
            values : component.get("v.flowValues"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state'+state);
            if (state === "SUCCESS") {
                console.log('response.getState()'+response.getReturnValue());
                component.set("v.picklistValues",response.getReturnValue());
                
            }
        }); 
        $A.enqueueAction(action); 
    },
    // JavaScript controller or helper function to handle picklist value selection
    handlePicklistSelection: function(component, event, helper) {
        var selectedValue = component.find('picklistSelect').get('v.value');
        var selectedValuesArray = selectedValue.split(',');
        
        // Set the selected picklist value in the attribute
        component.set('v.selectedValue', selectedValuesArray[0]);
        console.log('selectedValuesArray[0]'+selectedValuesArray[0]);
        // Return the selected value to the Flow
        var returnValue = { selectedValue: selectedValuesArray[0] };
        component.set('v.flowValues', selectedValuesArray[0]);
        var flow = component.find('flowData');
        flow.resume(returnValue);
    }
    
})