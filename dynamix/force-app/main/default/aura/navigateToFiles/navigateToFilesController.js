({
    invoke: function (component, event, helper) {
        var navService = component.find("navService");
        console.log(component.get("v.fileId"));
        // Sets the route to /lightning/o/Account/home
        var pageReference = {
            type: 'standard__namedPage',
            attributes: {
                pageName: 'filePreview'
            },
            state: {
                selectedRecordId: component.get("v.fileId")
            }
        };

        navService.navigate(pageReference);
    }
})