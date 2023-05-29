({
    
    // alimentation des variables URL GET Explore
    setParams : function(component) {
        
        return new Promise($A.getCallback(function(resolve, reject) {

            var titreExplore = component.get("v.pageReference").state.c__Titre;
            var siretExplore = component.get("v.pageReference").state.c__Siret;
            component.set("v.titreExplore", titreExplore);
            component.set("v.siretExplore", siretExplore);
            console.log('search0:',component.get("v.searchInputText"));
            if(titreExplore!=null){
                component.set("v.searchInputText", titreExplore);
            }
            resolve(siretExplore);
        }));
    },

    
    redirectToAccountRecord : function (component, event, helper) {
        var action = component.get("c.getAccountIdBySiret");
        action.setParams({
            "siret" : component.get("v.siretExplore")
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var res = response.getReturnValue();
                if(res != null){
                    console.log("res:", res, " - ", JSON.stringify(res));
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": res
                    });
                    navEvt.fire();
                    //helper.redirectToAccountRecord(component);
                }
            }
            else if(state === "ERROR"){
                console.log("error: " + response.getError());
            }
        });
        $A.enqueueAction(action);

    },
    
    //
    // FONCTIONS COMMUNES DATATABLE
    //
    
    sortBy: function (field, reverse, primer) {
        var key = primer ? function(x) {
            return primer(x[field]);
        } : function(x) {
            return x[field];
        };
        
        return function (a, b) {
            var A = key(a);
            var B = key(b);
            return reverse * ((A > B) - (B > A));
        };
    },

    
    
    //
    // RESULTS OF ACCOUNTS FETCHED
    //
    
    getsearchAccountsColumns: function () {
        var columnsWidths = this.searchAccountsGetColumnWidths();
        var columns = [
            {label: "Name", fieldName: "AccountUrl", type: "url", initialWidth: 300, sortable: true, iconName: 'standard:account', typeAttributes: { label: {fieldName: 'Name'}, target: '_blank' }}, 
            {label: "Alias", fieldName: "Alias__c", type: "text", initialWidth: 100, sortable: true}, 
            {label: "Parent Account", fieldName: "ParentUrl", type: "url", initialWidth: 300, sortable: true, typeAttributes: { label: {fieldName: 'ParentName'}, target: '_blank' }}, 
            {label: "SIRET", fieldName: "SIRET__c", type: "text", initialWidth: 150, sortable: true},
            {label: "Shipping City", fieldName: "ShippingCity", type: "text", initialWidth: 250, sortable: true},
            {label: "Account Type", fieldName: "AccountType", type: "text", initialWidth: 150, sortable: true}, 
            {label: "Action", type: "button", initialWidth: 200, typeAttributes: { label: 'Compare with Explore'}}

        ];

        if (columnsWidths.length === columns.length) {
            return columns.map(function (col, index) {
                return Object.assign(col, { initialWidth: columnsWidths[index] });
            });
        }
        return columns;
    },
    
    searchAccountsSortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.searchAccountsData");
        var reverse = sortDirection !== 'asc';
        data = Object.assign([],
                             data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
                            );
        cmp.set("v.searchAccountsData", data);
    },
    searchAccountsStoreColumnWidths: function (widths) {
        localStorage.setItem('datatable-search-accounts', JSON.stringify(widths));
    },
    searchAccountsResetLocalStorage: function () {
        localStorage.setItem('datatable-search-accounts', null);
    },
    searchAccountsGetColumnWidths: function () {
        var widths = localStorage.getItem('datatable-search-accounts');
        try {
            widths = JSON.parse(widths);
        } catch(e) {
            return [];
        }
        return Array.isArray(widths) ? widths : [];
    },
    /*
    fetchAccountRecordTypes: function(component, event, helper){
        var action = component.get("c.fetchRecordTypeValues");
        action.setCallback(this, function(response) {
            console.log('accountRecordTypes0', response.getReturnValue());
            component.set("v.accountRecordTypes", response.getReturnValue());
        });
        $A.enqueueAction(action);
    }*/
    
})