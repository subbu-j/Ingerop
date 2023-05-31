({
	closeModal : function(component, event, helper) {
        let customEvent = component.getEvent("closeModalEventParent");
        customEvent.setParams({
            "close": true
        });
        customEvent.fire();
	}
})