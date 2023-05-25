({
	doInit : function(component, event, helper) {
        helper.init(component, event, helper);
	},
    
    checkboxSelect: function(component, event, helper) {
        console.log('in chk');
        let fieldAPIName = event.target.dataset.fieldApiName;
        let selectedValue = event.target.dataset.value;
        let custCompareRecordsWrapperUpdated = component.get("v.custCompareRecordsWrapperUpdated");
        let lstCustomRecordComparaisonRow = custCompareRecordsWrapperUpdated.lstCustomRecordComparaisonRow;
        console.log('lstCustomRecordComparaisonRow',lstCustomRecordComparaisonRow);
        for (var i = 0; i < lstCustomRecordComparaisonRow.length; i++) {
            let row = lstCustomRecordComparaisonRow[i];
            if (row.fieldAPIName == fieldAPIName) {
                row.selectedValue = selectedValue;
                break;
            }
        }
        
        // Update the attribute value with the modified list
        custCompareRecordsWrapperUpdated.lstCustomRecordComparaisonRow = lstCustomRecordComparaisonRow;
        console.log('custCompareRecordsWrapperUpdated',custCompareRecordsWrapperUpdated);
        component.set("v.custCompareRecordsWrapperUpdated", custCompareRecordsWrapperUpdated);
    },
    
    submit: function(component, event, helper){
        helper.save(component, event, helper);
    },
    
    closeModal: function(component, event, helper) {//to adapt when encapsulated
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})