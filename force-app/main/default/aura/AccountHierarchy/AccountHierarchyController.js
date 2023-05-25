({
	doInit : function(component, event, helper) {    
        var action = component.get('c.generateNode');
        console.log("doInit accountHierarchy plante");
        action.setParams({
            'accountId' : component.get('v.recordId'),
            'b' : component.get('v.isSF1')
        });
        console.log("pas");
        action.setCallback(this, function(a) {
            if(a.getState() === "SUCCESS") {
                console.log("Callback plante");
                component.set("v.node", a.getReturnValue());
                console.log("pas");
            }
            else if(a.getState() === "ERROR") {
                console.log(a.getError());
                $A.log('Errors', a.getError());
            }
        });
        $A.enqueueAction(action);
	}
})