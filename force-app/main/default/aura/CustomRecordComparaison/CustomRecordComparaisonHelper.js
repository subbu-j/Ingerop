({
	init : function(component, event, helper){
		let accountId = component.get("v.recordId");
        
        // Call the Apex class method 'init' and pass the Account Id as a parameter
        let action = component.get("c.init");
        action.setParams({
            primaryRecordId: accountId
        });
        
        action.setCallback(this, function(response){
            let state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                console.log('response : ',response.getReturnValue());
                component.set("v.custCompareRecordsWrapperDisplayed", response.getReturnValue());
                component.set("v.custCompareRecordsWrapperUpdated", response.getReturnValue());
            }else if (state === "ERROR") {
                let errorMessage = $A.get("$Label.c.AP_ApexUtil_Ex_CastField");//TO BE REPLACED
                this.showToast(component, event, helper, errorMessage, "error");
            }
        });
        
        $A.enqueueAction(action);
	},
    
    save : function(component, event, helper) {
        let crcwJsonWrapper = component.get("v.custCompareRecordsWrapperUpdated"); // Get the JSON string from somewhere
        console.log('crcwJsonWrapper',crcwJsonWrapper);
        let crcwJsonWrapperString = JSON.stringify(crcwJsonWrapper);
        // Call the Apex class method 'save' and pass the JSON string as a parameter
        let action = component.get("c.save");
        action.setParams({
            crcwJsonWrapper: crcwJsonWrapperString
        });
        console.log('test2');
        console.log('crcwJsonWrapperString', crcwJsonWrapperString);
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                let successMessage = $A.get("$Label.c.AP_ApexUtil_Ex_CastField");//TO BE REPLACED
                this.showToast(component, event, helper, successMessage, "success");
            }else if (state === "ERROR") {
                let errorMessage = $A.get("$Label.c.AP_ApexUtil_Ex_CastField");//TO BE REPLACED
                this.showToast(component, event, helper, errorMessage, "error");
            }
        });
        
        $A.enqueueAction(action);
	},
    
    showToast: function(component, event, helper, message, type) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: type.charAt(0).toUpperCase() + type.slice(1),
            message: message,
            type: type
        });
        toastEvent.fire();
    }
})