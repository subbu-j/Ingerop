({
    getData: function(component, page) {
        this.showSpinner(component);
        var recordToDisplay = component.get("v.tableSize");
        var objectType = component.get("v.objectType");
        var parentRecordId = component.get("v.recordId");
        var parentField = component.get("v.parentFieldName");

        var action = component.get("c.fetchData");
        action.setParams({
            infoJSON : JSON.stringify({
                        "pageNumber": page,
                        "recordToDisplay": recordToDisplay,
                        "objectType" : objectType,
                        "parentRecordId": parentRecordId,
                        "parentField": parentField,
                        "recordId": null
            })
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                //console.log(result.data);
                if(result != null) {
                    if(result.data != null) {
                        var rows = result.data;
                        for (var i = 0; i < rows.length; i++) {
                            var row = rows[i];
                            //console.log(row);
                            if (row.Operation__r){
                                row.OperationName = row.Operation__r.Name;
                                row.UfoName = row.Operation__r.UFO__c;
                                row.OwnerName = row.Operation__r.Owner.Name;
                                if(row.Operation__r.Compte__r){
                                    row.AccountName = row.Operation__r.Compte__r.Name;
                                    row.AccountLink = '/lightning/r/Account/'+ row.Operation__r.Compte__r.Id +'/view';
                                }
                                else {
                                    row.AccountName = '';
                                    row.AccountLink = '';
                                }
                               
                            }
                            row.OperationLink = '/lightning/r/Operation__c/'+ row.Operation__c +'/view';                            
                            row.ExploreLinkName = 'Lien Explore'
                        }
                    }
                    
                    component.set("v.data", rows);   
                }
                
                component.set("v.page", result.page);
                component.set("v.total", result.total);
                component.set("v.pages", Math.ceil(result.total / recordToDisplay));
                this.hideSpinner(component);
            } else if (state === "ERROR") {
                this.handleResponseError(response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    unlink: function (component, page, recordId, idExplore) {

        console.log('# unlink / recordId :' + recordId);
        console.log('# unlink / idExplore :' + idExplore);
        
        var recordToDisplay = component.get("v.tableSize");
        var objectType = component.get("v.objectType");
        var parentRecordId = component.get("v.recordId");
        var parentField = component.get("v.parentFieldName");

        this.showSpinner(component);

        var action = component.get("c.unlinkOperation");
        
        action.setParams({
            "recordId": recordId,
            "idExplore": idExplore
        });
        
        action.setParams({
            infoJSON : JSON.stringify({
                "pageNumber": page,
                "recordToDisplay": recordToDisplay,
                "objectType" : objectType,
                "parentRecordId": parentRecordId,
                "parentField": parentField,
                "recordId": recordId,
                "idExplore": idExplore
            })
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.data", result.data);
                component.set("v.page", result.page);
                component.set("v.total", result.total);
                component.set("v.pages", Math.ceil(result.total / recordToDisplay));
                this.hideSpinner(component);
                this.showToast(component, 'success', 'L\'opération a été déliée de l\'annonce.');
            } else if (state === "ERROR") {
                //console.log(response.getError());
                this.handleResponseError(response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    delete: function (component, page, recordId) {
        this.showSpinner(component);
        var recordToDisplay = component.get("v.tableSize");
        var objectType = component.get("v.objectType");
        var parentRecordId = component.get("v.recordId");
        var parentField = component.get("v.parentFieldName");
        var action = component.get("c.deleteRecord");
        action.setParams({
            infoJSON : JSON.stringify({
                "pageNumber": page,
                "recordToDisplay": recordToDisplay,
                "objectType" : objectType,
                "parentRecordId": parentRecordId,
                "parentField": parentField,
                "recordId": recordId
            })
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.data", result.data);
                component.set("v.page", result.page);
                component.set("v.total", result.total);
                component.set("v.pages", Math.ceil(result.total / recordToDisplay));
                this.hideSpinner(component);
                this.showToast(component, 'success', 'Object was deleted.');
            } else if (state === "ERROR") {
                this.handleResponseError(response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    sortData: function (component, fieldName, sortDirection) {
        this.showSpinner(component);
        var data = component.get("v.data");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse));
        component.set("v.data", data);
        this.hideSpinner(component);
    },

    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },

    showSpinner: function (component) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    hideSpinner: function (component) {
        var spinner = component.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    showToast : function(component, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Opération déliée.',
            message: message,
            duration:' 3000',
            key: 'info_alt',
            type: type,
            mode: 'pester'
        });
        toastEvent.fire();
    },

    handleResponseError: function (helper, errors) {
        if (errors) {
            if (errors[0] && errors[0].message) {
                this.showToast(component, 'error', "Une erreur est survenue : " +
                    errors[0].message);
            }
        } else {
            this.showToast(component, 'error', 'Erreur inconnue.');
        }
        this.hideSpinner(component);
    }
})