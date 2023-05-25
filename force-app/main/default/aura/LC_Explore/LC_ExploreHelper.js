({
    
    // alimentation des variables URL GET Explore
    setParams : function(component) {
        
        return new Promise($A.getCallback(function(resolve, reject) {
            var id;
            var typeMarche;
            var typeMarcheLabel;
            var idExplore = component.get("v.pageReference").state.c__idExplore;
            var nomExplore = component.get("v.pageReference").state.c__Titre;
            var siretExplore = component.get("v.pageReference").state.c__Siret;
            
            //console.log('# setParams - idExplore : ' + idExplore + ' / nomExplore : ' + nomExplore + ' / siretExplore : ' + siretExplore);
            
            if(idExplore.indexOf('-') > 1){
                var arrIdExplore = [];
                arrIdExplore = idExplore.split('-');
                if(arrIdExplore.length > 0){
                    typeMarche = arrIdExplore[0];
                    typeMarcheLabel = (typeMarche == 'MP') ? 'Marché public' : 'Maître d\'ouvrage';
                    id = arrIdExplore[1];
                    component.set("v.idExplore", idExplore);
                    component.set("v.typeMarcheExplore", typeMarche);
                    component.set("v.typeMarcheLabel", typeMarcheLabel);
                }
            } 
            //console.log('# setParams - idExplore : ' + idExplore + ' / typeMarcheExplore : ' + typeMarche + ' / nomExplore : ' + nomExplore + ' / siretExplore : ' + siretExplore);
            
            component.set("v.nomExplore", nomExplore);
            component.set("v.siretExplore", siretExplore);
            
            resolve(idExplore);
        }));
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
    // OPERATIONS LIEES 
    //
    
    // définition des colonnes du tableau "Opérations liées"  
    getRelatedOperationsColumns: function () {
        var columnsWidths = this.relatedOperationsGetColumnWidths();
        var columns = [
            {label: "Nom", fieldName: "link__c", type: "url", typeAttributes: { label: { fieldName: 'Name' } },initialWidth: 450, sortable: true, iconName: 'custom:custom37'},
            //{label: "Nom", fieldName: "Name", type: "text", typeAttributes: { label: { fieldName: 'Name' } }, initialWidth: 450, sortable: true, iconName: 'custom:custom37'}, 
            {label: "Compte", fieldName: "AccountName", type: "text", initialWidth: 450, sortable: true, iconName: 'standard:account'}, 
            {label: "Département", fieldName: "Departement__c", type: "text", initialWidth: 100, sortable: true}, 
            {label: "Dans mon département ?", fieldName: "estDansMonDepartement__c", type: "boolean", initialWidth: 150, sortable: true}, 
            {label: "Dans mon UFO ?", fieldName: "estDansMonUFO__c", type: "boolean", initialWidth: 150, sortable: true}, 
            {label: "Référent", fieldName: "OwnerName", type: "text", initialWidth: 250, sortable: true}, 
            {label: "Nb offres", fieldName: "Nombre_d_offres__c", type: "number", initialWidth: 130, sortable: true},
            //{label: 'Délier', type: 'button', initialWidth: 150, typeAttributes: { label: 'Délier', name: 'unlink', title: 'Cliquer pour délier la fiche'}}
            //{label: 'Voir', type: 'button', initialWidth: 150, typeAttributes: { label: 'Voir la fiche', name: 'view_record', title: 'Cliquer pour voir la fiche'}}
        ];
        
        if (columnsWidths.length === columns.length) {
            return columns.map(function (col, index) {
                return Object.assign(col, { initialWidth: columnsWidths[index] });
            });
        }
        return columns;
    },
    
    // chargement des données du tableau "Opérations liées"
    fetchRelatedOperationsData: function(component) {
        var self = this;
        return new Promise($A.getCallback(function(resolve, reject) {
            //console.log('# fetchRelatedOperationsData - START');
            
            var linkedOperationIds = [];
            var idExplore = component.get("v.idExplore");
            
            var action = component.get("c.getRelatedOperationsData");
            action.setParam("idExplore", idExplore);
            action.setCallback(self, function(response) {
                
                if (response && response.getState() === 'SUCCESS') {        
                    var rows = response.getReturnValue();
                    if(rows != null) {
                        for (var i = 0; i < rows.length; i++) {
                            var row = rows[i];
                            //console.log(row);
                            if(row.Id){
                                linkedOperationIds.push(row.Id);
                                //console.log('linkedOperationIds : ' + linkedOperationIds);
                            }
                            if (row.Compte__r){
                                //console.log(row.Compte__r.Name);
                                row.AccountName = row.Compte__r.Name;
                            }
                            if(row.Owner){
                                row.OwnerName = row.Owner.FirstName + ' ' + row.Owner.LastName;
                            } 
                        }
                        component.set('v.relatedOperationsData', rows);
                        component.set('v.linkedOperationIds', linkedOperationIds);
                    }
                    resolve(response.getReturnValue());
                }
                
            });
            $A.enqueueAction(action);
            //console.log('# fetchRelatedOperationsData - END');
        }));
    },
    
    relatedOperationsSortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.relatedOperationsData");
        var reverse = sortDirection !== 'asc';
        data = Object.assign([],
                             data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
                            );
        cmp.set("v.relatedOperationsData", data);
    },
    relatedOperationsStoreColumnWidths: function (widths) {
        localStorage.setItem('datatable-related-operations', JSON.stringify(widths));
    },
    relatedOperationsResetLocalStorage: function () {
        localStorage.setItem('datatable-related-operations', null);
    },
    relatedOperationsGetColumnWidths: function () {
        var widths = localStorage.getItem('datatable-related-operations');
        try {
            widths = JSON.parse(widths);
        } catch(e) {
            return [];
        }
        return Array.isArray(widths) ? widths : [];
    },
    
    
    
    //
    // AUTRES OPERATIONS LIEES AU COMPTE
    //
    
    // définition des colonnes du tableau "Autres opérations liées au(x) compte(s)"  
    getOtherOperationsColumns: function () {
        var columnsWidths = this.otherOperationsGetColumnWidths();
        var columns = [
            {label: "Nom", fieldName: "link__c", type: "url", typeAttributes: { label: { fieldName: 'Name' } },initialWidth: 450, sortable: true, iconName: 'custom:custom37'},
            //{label: "Nom", fieldName: "Name", type: "url", typeAttributes: { target: 'view_record'}, initialWidth: 400, sortable: true, iconName: 'custom:custom37'}, 
            {label: "Compte", fieldName: "AccountName", type: "text", initialWidth: 400, sortable: true, iconName: 'standard:account'}, 
            {label: "Département", fieldName: "Departement__c", type: "text", initialWidth: 100, sortable: true}, 
            {label: "Dans mon département ?", fieldName: "estDansMonDepartement__c", type: "boolean", initialWidth: 150, sortable: true}, 
            {label: "Dans mon UFO ?", fieldName: "estDansMonUFO__c", type: "boolean", initialWidth: 150, sortable: true}, 
            {label: "Référent", fieldName: "OwnerName", type: "text", initialWidth: 250, sortable: true}, 
            {label: "Nb offres", fieldName: "Nombre_d_offres__c", type: "number", initialWidth: 130, sortable: true},
            //{label: 'Voir', type: 'button', initialWidth: 135, typeAttributes: { label: 'Voir la fiche', name: 'view_record', title: 'Cliquer pour voir la fiche'}},
            {label: 'Lier', type: 'button', initialWidth: 135, typeAttributes: { label: 'Lier', name: 'link', title: 'Lier l\'annonce à l\'opération'}}
        ];
        
        if (columnsWidths.length === columns.length) {
            return columns.map(function (col, index) {
                return Object.assign(col, { initialWidth: columnsWidths[index] });
            });
        }
        return columns;
    },
    
    // chargement des données du tableau "Autres opérations liées au compte"
    fetchOtherOperationsData: function(component) {
        
        var self = this;
        return new Promise($A.getCallback(function(resolve, reject) {
            var idExplore = component.get("v.idExplore");
            var siretExplore = component.get("v.siretExplore");
            //var linkedOperationIds = component.get("v.linkedOperationIds");
            
            //console.log('# fetchOtherOperationsData - id:' + idExplore + '/ siret:' + siretExplore);
            
            var action = component.get("c.getOtherOperationsData");
            action.setParams({"idExplore" : idExplore, "siret" : siretExplore}); 
            
            action.setCallback(self, function(response) {
                
                if (response && response.getState() === 'SUCCESS') {        
                    var rows = response.getReturnValue();
                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        //console.log(row);
                        if (row.Compte__r){
                            //console.log(row.Compte__r.Name);
                            row.AccountName = row.Compte__r.Name;
                        }
                        if(row.Owner){
                            row.OwnerName = row.Owner.FirstName + ' ' + row.Owner.LastName;
                        }  
                    }
                    component.set('v.otherOperationsData', rows);
                    resolve(response.getReturnValue());
                }
                
            });
            $A.enqueueAction(action);
        }));
    },
    
    otherOperationsSortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.otherOperationsData");
        var reverse = sortDirection !== 'asc';
        data = Object.assign([],
                             data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
                            );
        cmp.set("v.otherOperationsData", data);
    },
    otherOperationsStoreColumnWidths: function (widths) {
        localStorage.setItem('datatable-other-operations', JSON.stringify(widths));
    },
    otherOperationsResetLocalStorage: function () {
        localStorage.setItem('datatable-other-operations', null);
    },
    otherOperationsGetColumnWidths: function () {
        var widths = localStorage.getItem('datatable-other-operations');
        try {
            widths = JSON.parse(widths);
        } catch(e) {
            return [];
        }
        return Array.isArray(widths) ? widths : [];
    },
    
    
    
    
    
    //
    // RESULTATS D'OPERATIONS TROUVEES
    //
    
    getSearchOperationsColumns: function () {
        var columnsWidths = this.otherOperationsGetColumnWidths();
        var columns = [
            {label: "Nom", fieldName: "link__c", type: "url", typeAttributes: { label: { fieldName: 'Name' } },initialWidth: 450, sortable: true, iconName: 'custom:custom37'},
            //{label: "Nom", fieldName: "Name", type: "text", typeAttributes: { label: { fieldName: 'Name' } },initialWidth: 450, sortable: true, iconName: 'custom:custom37'},
            //{label: "Nom", fieldName: "Name", type: "url", typeAttributes: { target: 'view_record'}, initialWidth: 400, sortable: true, iconName: 'custom:custom37'}, 
            {label: "Compte", fieldName: "AccountName", type: "text", initialWidth: 400, sortable: true, iconName: 'standard:account'}, 
            {label: "Département", fieldName: "Departement__c", type: "text", initialWidth: 100, sortable: true}, 
            {label: "Dans mon département ?", fieldName: "estDansMonDepartement__c", type: "boolean", initialWidth: 150, sortable: true}, 
            {label: "Dans mon UFO ?", fieldName: "estDansMonUFO__c", type: "boolean", initialWidth: 150, sortable: true},
            {label: "UFO porteuse", fieldName: "UFO__c", type: "text", initialWidth: 100, sortable: true},
            {label: "Référent", fieldName: "OwnerName", type: "text", initialWidth: 250, sortable: true}, 
            {label: "Nb offres", fieldName: "Nombre_d_offres__c", type: "number", initialWidth: 130, sortable: true},
            //{label: 'Voir', type: 'button', initialWidth: 135, typeAttributes: { label: 'Voir la fiche', name: 'view_record', title: 'Cliquer pour voir la fiche'}},
            {label: 'Lier', type: 'button', initialWidth: 135, typeAttributes: { label: 'Lier', name: 'link', title: 'Lier l\'annonce à l\'opération'}}
        ];
        
        if (columnsWidths.length === columns.length) {
            return columns.map(function (col, index) {
                return Object.assign(col, { initialWidth: columnsWidths[index] });
            });
        }
        return columns;
    },
    
    searchOperationsSortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.searchOperationsData");
        var reverse = sortDirection !== 'asc';
        data = Object.assign([],
                             data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
                            );
        cmp.set("v.searchOperationsData", data);
    },
    searchOperationsStoreColumnWidths: function (widths) {
        localStorage.setItem('datatable-search-operations', JSON.stringify(widths));
    },
    searchOperationsResetLocalStorage: function () {
        localStorage.setItem('datatable-search-operations', null);
    },
    searchOperationsGetColumnWidths: function () {
        var widths = localStorage.getItem('datatable-search-operations');
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
    
    
    
    
    
    
    
    
    
    // NON UTILISE
    /*
    getAnnonceData : function (component) {
        var idExplore = component.get("v.idExplore");
        var typeMarche = component.get('v.typeMarcheExplore');
        var action;
        
        if(typeMarche == 'MP') {
            action = component.get('c.getAnnonceMarchePublicData');
        } else {
            action = component.get('c.getAnnonceMaitreOuvrageData');
        }

        return new Promise(function (resolve, reject) {
            action.setParams({
                idExplore: idExplore
            });

            action.setCallback(this, function (response) {
               var state = response.getState();

                if (component.isValid() && state === "SUCCESS") {
                    resolve(response.getReturnValue());
                }
                else if (component.isValid() && state === "ERROR") {
                    var errors = response.getError();
                    reject(response.getError()[0]);
                }
            });

            $A.enqueueAction(action);
        });
        
    },
	*/
    
    // NON UTILISE    
    /*
    getAccountIdBySiret : function(component, siret, helper) {
        console.log('# getAccountIdBySiret - START');
        
        var siret = component.get('v.siretExplore');
        var action = component.get('c.getAccountIdBySiret');
        
        console.log('# getAccountIdBySiret - siret : ' + siret);
       
        return new Promise($A.getCallback(function(resolve, reject) {
            action.setParams({
                siret: siret
            });
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    console.log(response.getReturnValue());
                    resolve(response.getReturnValue());
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    console.log(response.getError());
                    reject(response.getError()[0]);
                }
            });
            
            $A.enqueueAction(action);
            console.log('# getAccountIdBySiret - END');
        }));
    },
    */
    
})