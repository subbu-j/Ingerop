({
	init : function(component, event, helper, isQuickAction){
        let recordIdPrimary = isQuickAction ? component.get("v.recordId") : component.get("v.recordIdInput");
        
        // Call the Apex class method 'init' and pass the Account Id as a parameter
        let action = component.get("c.init");
        action.setParams({
            primaryRecordId: recordIdPrimary,
            urlSiret: component.get("v.siretUrlInput"),
            isQuickAction: isQuickAction
        });
        
        action.setCallback(this, function(response){
            let state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                component.set("v.custCompareRecordsWrapperDisplayed", response.getReturnValue());
                component.set("v.custCompareRecordsWrapperUpdated", response.getReturnValue());
                this.setChecksOnSelectedValues(component, event, helper);
            }else if (state === "ERROR") {
                this.handleError(component, event, helper, response.getError()[0].message);
            }
        });
        
        $A.enqueueAction(action);
	},
    
    setChecksOnSelectedValues : function(component, event, helper){
        let custCompareRecordsWrapperUpdated = component.get("v.custCompareRecordsWrapperUpdated");
        let lstCustomRecordComparaisonRow = custCompareRecordsWrapperUpdated.lstCustomRecordComparaisonRow;
        let mapSelected = new Map();
		
        for (var i = 0; i < lstCustomRecordComparaisonRow.length; i++) {
            let row = lstCustomRecordComparaisonRow[i];
            mapSelected.set(row.fieldAPIName,false);
        }
        component.set("v.mapCheckSelectedValues", mapSelected);
    },
    
    save : function(component, event, helper) {
        let crcwJsonWrapper = component.get("v.custCompareRecordsWrapperUpdated");
        let crcwJsonWrapperString = JSON.stringify(crcwJsonWrapper);
        // Call the Apex class method 'save' and pass the JSON string as a parameter
        let action = component.get("c.save");
        action.setParams({
            crcwJsonWrapper: crcwJsonWrapperString
        });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                this.handleSuccess(component, event, helper);
            }else if (state === "ERROR") {
                let errorMessage = $A.get("$Label.c.AURA_CustomRecorCompModal_GenericErrorSave");
                this.showToast(component, event, helper, errorMessage, "error");
            }
        });
        
        $A.enqueueAction(action);
	},
    
    handleSuccess: function(component, event, helper){
        if(component.get("v.isQuickAction")){
            let successMessage = $A.get("$Label.c.AURA_CustomRecorCompModal_GenericSuccessSave");
            this.showToast(component, event, helper, successMessage, "success");
            let refreshEvent = $A.get("e.force:refreshView");
            refreshEvent.fire();
        }
        else{
            var navEvt = $A.get("e.force:navigateToSObject");
            let recordId = component.get("v.recordIdInput");
            navEvt.setParams({
                "recordId": recordId
            });
            navEvt.fire();
        }
    },

    handleError: function(component, event, helper, stringError){
        let errorMessage = '';
        let errorType = 'error';
        if(stringError.includes($A.get("$Label.c.AP_CustRecCompCtrl_Ex_EmptySIRET"))){
            errorMessage = stringError;
            errorType = 'warning';
        }
        else if(stringError.includes($A.get("$Label.c.AP_CustRecCompWrapper_Ex_DataIdentical"))){
            errorMessage = stringError;
            errorType = 'success';
        }
        else if(stringError.includes($A.get("$Label.c.AP_CustRecCompCtrl_Ex_EmptyJSON")))
            errorMessage = stringError;
        else errorMessage = $A.get("$Label.c.AURA_CustomRecorCompModal_GenericErrorInit");
        this.showToast(component, event, helper, errorMessage, errorType);
    },
    
    showToast: function(component, event, helper, message, type) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: $A.getReference("$Label.c." + type.charAt(0).toUpperCase() + type.slice(1)),
            message: message,
            type: type
        });
        toastEvent.fire();

        if(type != 'error'){
            let isQuickAction = component.get("v.isQuickAction");
            if(isQuickAction){
                let dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            else{
                let customEvent = component.getEvent("closeModalEvent");
                customEvent.setParams({
                    "close": true
                });
                customEvent.fire();
            }
        }
    }
})