({
    upload: function (component, event, helper) {

        var modalBody;
        var modalFooter;

        $A.createComponents([
            ["c:uploadFile", { 'recordId': component.get('v.recordId') }],
            ["c:uploadFileFooter", {}]
        ],
            function (components, status) {
                if (status === "SUCCESS") {
                    modalBody = components[0];
                    modalFooter = components[1];
                    component.find('overlayLib').showCustomModal({
                        header: "Upload File",
                        body: modalBody,
                        footer: modalFooter,
                        showCloseButton: true
                    })
                }
            }
        );
    },
    refreshView: function (component, event, helper) {
        if (component.get("v.validRefresh") === true) {
            setTimeout(function () { component.find("refresh").publish({}); }, 5000);
            component.set("v.validRefresh", false);
        }
        else {
            component.set("v.validRefresh", true);
        }
    },
    handleRefresh: function (component, event, helper) {

        $A.get('e.force:refreshView').fire();;
    }
})