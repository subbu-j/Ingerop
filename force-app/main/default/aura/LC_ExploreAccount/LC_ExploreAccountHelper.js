({
    
    // alimentation des variables URL GET Explore
    setParams : function(component) {
        
        return new Promise($A.getCallback(function(resolve, reject) {

            var titreExplore = component.get("v.pageReference").state.c__Titre;
            var siretExplore = component.get("v.pageReference").state.c__Siret;
            component.set("v.titreExplore", titreExplore);
            component.set("v.siretExplore", siretExplore);
            
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
    // RESULTATS D'OPERATIONS TROUVEES
    //
    
    getsearchAccountsColumns: function () {
        var columnsWidths = this.searchAccountsGetColumnWidths();
        var columns = [
            {label: "Name", fieldName: "Name", type: "text", initialWidth: 300, sortable: true, iconName: 'standard:account'}, 
            {label: "Alias", fieldName: "Alias__c", type: "text", initialWidth: 100, sortable: true}, 
            {label: "Parent Account", fieldName: "ParentUrl", type: "url", initialWidth: 300, sortable: true, typeAttributes: { label: {fieldName: 'ParentName'}, target: '_blank' }}, 
            {label: "SIRET", fieldName: "SIRET__c", type: "text", initialWidth: 150, sortable: true},
            {label: "Shipping City", fieldName: "ShippingCity", type: "text", initialWidth: 250, sortable: true},
            {label: "Account Type", fieldName: "Type", type: "text", initialWidth: 200, sortable: true}, 
            {label: "Action", type: "button", initialWidth: 120, typeAttributes: { label: 'Compare'}}

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
    
    
    
    
    
    
    
    
    //
    // ACTIONS
    //
    
    viewRecord : function(component, event, row) {   
        //console.log('# LC_ExploreHelper - viewRecord - START');
        
        var recordId = event.getParam('row').Id;
        //console.log('# LC_ExploreHelper - viewRecord - recordId : ' + recordId);
        
        var actionName = event.getParam('action').name;
        if (actionName == 'view_record') {
            var viewRecordEvent = $A.get("e.force:navigateToURL");
            viewRecordEvent.setParams({
                "url": "/" + recordId
            });
            viewRecordEvent.fire();
        }
        //console.log('# LC_ExploreHelper - viewRecord - END');
    },
    
    linkRecord : function(component, event, row) {       
        //console.log('# LC_ExploreHelper - linkRecord - START');
        
        var recordId = event.getParam('row').Id;
        //console.log('# LC_ExploreHelper - linkRecord - recordId : ' + recordId);
        
        var actionName = event.getParam('action').name;
        if (actionName == 'link') {
            var action = component.get("c.linkAnnonceToOperation");            
            action.setParams({
                recordId : recordId,
                idExplore : component.get("v.idExplore")
            });
            action.setCallback(this, function(response){
                var result = response.getReturnValue();
                //console.log(result);
                $A.get("e.force:refreshView").fire();
            });
            $A.enqueueAction(action);
        }
        //console.log('# LC_ExploreHelper - linkRecord - END');
    },
    
    unlinkRecord : function(component, event, row) {       
        //console.log('# LC_ExploreHelper - unlinkRecord - START');
        
        var recordId = event.getParam('row').Id;
        //console.log('# LC_ExploreHelper - unlinkRecord - recordId : ' + recordId);
        
        var actionName = event.getParam('action').name;
        if (actionName == 'unlink') {
            var action = component.get("c.unlinkOperation");            
            action.setParams({
                recordId : recordId,
                idExplore : component.get("v.idExplore")
            });
            action.setCallback(this, function(response){
                var result = response.getReturnValue();
                //console.log(result);
                $A.get("e.force:refreshView").fire();
            });
            $A.enqueueAction(action);
        }
        
        //console.log('# LC_ExploreHelper - unlinkRecord - END');
    },
    
    
    
    
    
    
    //
    // NOUVELLE OPERATION
    //
    openModalNewOperation : function(component, event, helper) {
        //console.log('# openModalNewOperation - START');
        
        // création dynamique du composant lightning modal pour création de nouvelle opération liée à l'annonce Explore
        // on transmet plusieurs paramètres pour le chargement par défaut de valeurs
        $A.createComponent(
            "c:LC_Explore_ModalNewOperation",
            {
                "idExplore": component.get("v.idExplore"),
                "typeMarcheExplore": component.get("v.typeMarcheExplore"),
                "nomExplore": component.get('v.nomExplore'),
                "siretExplore": component.get('v.siretExplore'),
                "annonceMarchePublicData": component.get('v.annonceMarchePublicData'),
                "annonceMaitreOuvrageData": component.get('v.annonceMaitreOuvrageData'),
                "idDonneurOrdre": component.get('v.idDonneurOrdre'),
            },
            function(result){                
                if (component.isValid()) {
                    var targetCmp = component.find('modalNewOperationPlaceholder');
                    var body = targetCmp.get("v.body");
                    //console.log('# openModalNewOperation / result: ' + result);
                    body.push(result);
                    targetCmp.set("v.body", body); 
                }
            }
        );
        //console.log('# openModalNewOperation - END');
    },
    
    
    
})