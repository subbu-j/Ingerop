({
	doInit : function(component, event, helper) {
        let recordInput = component.get("v.recordIdInput");
        let isQuickAction = component.get("v.recordIdInput") ? false : true;
        component.set("v.isQuickAction",isQuickAction);
        helper.init(component, event, helper, isQuickAction);
	},
    
    checkboxSelect: function(component, event, helper) {
        let fieldAPIName = event.currentTarget.dataset.fieldApiName;
        let selectedValue = event.currentTarget.dataset.value;
        let custCompareRecordsWrapperUpdated = component.get("v.custCompareRecordsWrapperUpdated");
        let mapCheckSelectedValues = component.get("v.mapCheckSelectedValues");
        let lstCustomRecordComparaisonRow = custCompareRecordsWrapperUpdated.lstCustomRecordComparaisonRow;
        let radio = event.currentTarget.querySelector("input[type='radio']");
        
        for (var i = 0; i < lstCustomRecordComparaisonRow.length; i++) {
            let row = lstCustomRecordComparaisonRow[i];
            if (row.fieldAPIName == fieldAPIName) {
                row.selectedValue = selectedValue;
                mapCheckSelectedValues.set(row.fieldAPIName, true);
                break;
            }
        }
        
    	radio.checked = true;
        
        // Update the attribute value with the modified list
        custCompareRecordsWrapperUpdated.lstCustomRecordComparaisonRow = lstCustomRecordComparaisonRow;
        component.set("v.custCompareRecordsWrapperUpdated", custCompareRecordsWrapperUpdated);
        component.set("v.mapCheckSelectedValues", mapCheckSelectedValues);
    },
    
    submit: function(component, event, helper){
        let mapCheckSelectedValues = component.get("v.mapCheckSelectedValues");
        let isValid = true;
        
        mapCheckSelectedValues.forEach (function(value, key) {
            if(value == false){
                isValid = false;
            }
        })
    
        if (isValid) {
          helper.save(component, event, helper);
        } else {
          let errorMessage = $A.get("$Label.c.AURA_CustomRecorCompModal_SelectAllFields");
          helper.showToast(component, event, helper, errorMessage, "error");
        }
        
    },
    
    closeModal: function(component, event, helper) {
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
    },
    
    onCellMouseOver: function(component, event, helper) {
        var cell = event.currentTarget;
        cell.classList.add("table-cell-hover");
	},

    onCellMouseOut: function(component, event, helper) {
        var cell = event.currentTarget;
        cell.classList.remove("table-cell-hover");
    }
})