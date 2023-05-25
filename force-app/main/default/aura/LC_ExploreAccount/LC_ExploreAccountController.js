({
    doInit : function(component, event, helper) { 
        
        // chargement du composant lightning avec la définition des colonnes des 3 tableaux et des données associées
        
        //console.log('# doInit - START');
        helper.setParams(component)
        .then(
            $A.getCallback(function(result) {
                
                // datatable 'Opérations liées'
                component.set('v.relatedOperationsColumns', helper.getRelatedOperationsColumns());
                helper.fetchRelatedOperationsData(component);
                
                // datatable 'Autres opérations liées au compte'                    
                component.set('v.otherOperationsColumns', helper.getOtherOperationsColumns());
                helper.fetchOtherOperationsData(component);
                
                // datatable 'Résultats d'opérations trouvées
                component.set('v.searchOperationsColumns', helper.getSearchOperationsColumns());
                
            })
        ).catch(function(error) {
            console.log('# doInit - ERROR : ' + error);
        });        
        //console.log('# doInit - END');        
    },
    
    // gestion de mise à jour des paramètres URL GET Explore
    onPageReferenceChanged: function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        
        var id;
        var typeMarche;
        var typeMarcheLabel;
        
        var idExplore = pageReference.state.c__idExplore;
        var nomExplore = pageReference.state.c__Titre;
        var siretExplore = pageReference.state.c__Siret;
        
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
    },
    
    
    
    
    // OPERATIONS LIEES
    
    //stockage en local de la taille des colonnes du tableau
    relatedOperationsStoreColumnWidths: function (cmp, event, helper) {
        helper.relatedOperationsStoreColumnWidths(event.getParam('columnWidths'));
    },
    
    // vidage des paramètres locaux liés à la taille des colonnes 
    relatedOperationsResetColumns: function (cmp, event, helper) {
        helper.relatedOperationsResetLocalStorage();
        cmp.set('v.relatedOperationsColumns', helper.getRelatedOperationsColumns());
    },
    
    // gestion du tri des colonnes
    relatedOperationsUpdateColumnSorting: function (cmp, event, helper) {
        cmp.set('v.isLoading', true);
        setTimeout($A.getCallback(function() {
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            cmp.set("v.relatedOperationsSortedBy", fieldName);
            cmp.set("v.relatedOperationsSortedDirection", sortDirection);
            helper.relatedOperationsSortData(cmp, fieldName, sortDirection);
            cmp.set('v.isLoading', false);
        }), 0);
    },
    
    // gestion des actions du tableau
    relatedOperationsHandleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'view_record':
                helper.viewRecord(cmp,event,row);
                break;
            case 'unlink':
                helper.unlinkRecord(cmp,event,row);
                break;
            default:
                helper.viewRecord(cmp,event,row);
                break;
        }
    },
    
    
    
    // AUTRES OPERATIONS LIEES AU COMPTE
    
    //stockage en local de la taille des colonnes du tableau
    otherOperationsStoreColumnWidths: function (cmp, event, helper) {
        helper.otherOperationsStoreColumnWidths(event.getParam('columnWidths'));
    },
    
    // vidage des paramètres locaux liés à la taille des colonnes 
    otherOperationsResetColumns: function (cmp, event, helper) {
        helper.otherOperationsResetLocalStorage();
        cmp.set('v.otherOperationsColumns', helper.getOtherOperationsColumns());
        //cmp.set('v.otherOperationsColumnsTable2', helper.getOtherOperationsColumnsTable2());
    },
    
    // gestion du tri des colonnes
    otherOperationsUpdateColumnSorting: function (cmp, event, helper) {
        cmp.set('v.isLoading', true);
        setTimeout($A.getCallback(function() {
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            cmp.set("v.otherOperationsSortedBy", fieldName);
            cmp.set("v.otherOperationsSortedDirection", sortDirection);
            helper.otherOperationsSortData(cmp, fieldName, sortDirection);
            cmp.set('v.isLoading', false);
        }), 0);
    },
    
    // gestion des actions du tableau
    otherOperationsHandleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        //console.log('action',action);
        var row = event.getParam('row');
        switch (action.name) {
            case 'view_record':
                helper.viewRecord(cmp,event,row);
                break;
            case 'link':
                helper.linkRecord(cmp,event,row);
                break;
            default:
                helper.viewRecord(cmp,event,row);
                break;
        }
    },
    
    
    
    
    // RECHERCHE OPERATIONS
    
    // recherche du texte saisi sur tous les champs de l'objet Operation__c
    search : function(component, event, helper) {
        
        //console.log('# search - START');
        
        var idExplore = component.get("v.idExplore");
        var searchElement = document.getElementById("searchtext");
        var searchValue = (searchElement) ? searchElement.value : '';
        
        var action = component.get("c.getOperationsDataSearch");
        action.setParams({
            "idExplore": idExplore,
            "searchText": searchValue
        });
        
        action.setCallback(this, function(response){
            var rows = response.getReturnValue();
            if(rows != null){
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    
                    //console.log(row);
                    // gestion du nom du compte associé
                    if (row.Compte__r){
                        //console.log(row.Compte__r.Name);
                        row.AccountName = row.Compte__r.Name;
                    }
                    // gestion du nom/prénom du référent associé
                    if(row.Owner){
                        row.OwnerName = row.Owner.FirstName + ' ' + row.Owner.LastName;
                    }  
                }
                component.set('v.searchOperationsData', rows);
            }
        });
        $A.enqueueAction(action);
        //console.log('# search - END');
    },
    
    //stockage en local de la taille des colonnes du tableau
    searchOperationsStoreColumnWidths: function (cmp, event, helper) {
        helper.searchOperationsStoreColumnWidths(event.getParam('columnWidths'));
    },
    
    // vidage des paramètres locaux liés à la taille des colonnes 
    searchOperationsResetColumns: function (cmp, event, helper) {
        helper.searchOperationsResetLocalStorage();
        cmp.set('v.searchOperationsColumns', helper.getSearchOperationsColumns());
    },
    
    // gestion du tri des colonnes
    searchOperationsUpdateColumnSorting: function (cmp, event, helper) {
        cmp.set('v.isLoading', true);
        setTimeout($A.getCallback(function() {
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            cmp.set("v.searchOperationsSortedBy", fieldName);
            cmp.set("v.searchOperationsSortedDirection", sortDirection);
            helper.searchOperationsSortData(cmp, fieldName, sortDirection);
            cmp.set('v.isLoading', false);
        }), 0);
    },
    
    // gestion des actions du tableau
    searchOperationsHandleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        //console.log('action',action);
        var row = event.getParam('row');
        switch (action.name) {
            case 'view_record':
                helper.viewRecord(cmp,event,row);
                break;
            case 'link':
                helper.linkRecord(cmp,event,row);
                break;
            default:
                helper.viewRecord(cmp,event,row);
                break;
        }
    },
    
    
    
    
    
    
    // NOUVELLE OPERATION
    
    // création dynamique du composant lightning modal pour création de nouvelle opération liée à l'annonce Explore
    openModalNewOperation : function(component, event, helper) {
        
        //console.log('# openModalNewOperation - START');
        
        var idExplore = component.get("v.idExplore");
        var typeMarche = component.get('v.typeMarcheExplore');
        
        //console.log('# idExplore : ' + idExplore);
        //console.log('# typeMarche : ' + typeMarche);
        //
        // action 1 : récupération des données WS Explore pour la fiche annonce selon le type d'annonce
        // récupération de chaines json concaténées par le caractère '¤'
        var action1;
        
        if(typeMarche == 'MP') {
            action1 = component.get('c.getAnnonceMarchePublicData');
        } else {
            action1 = component.get('c.getAnnonceMaitreOuvrageData');
        }        
        action1.setParams({
            idExplore: idExplore
        });
        
        action1.setCallback(this, function(response) {
            var state = response.getState();
            //console.log('# state : ' + state);
            
            if (state === "SUCCESS") {
                //console.log('# openModalNewOperation - response : ' + response.getReturnValue())
                var concatenatedJson = response.getReturnValue();
                if(typeMarche == 'MP') {
                    component.set('v.annonceMarchePublicData', concatenatedJson); 
                } else {
                    component.set('v.annonceMaitreOuvrageData', concatenatedJson); 
                }
                
                //console.log('JSON : ' + concatenatedJson);
                
                if(concatenatedJson != null) {
                    
                    if(concatenatedJson.indexOf('¤')>-1){
                    
                        var arrData = concatenatedJson.split('¤');
                    
                        var marche = JSON.parse(arrData[0]);
                        var societes = JSON.parse(arrData[1]);
                        var localisations = JSON.parse(arrData[2]);
                        var siret;
                        if(societes != null && societes.length > 0){
                            siret = societes[0].SIRET;
                            if(siret != null){
                                component.set('v.siretExplore', siret); 
                            }
                        }
                        
                        /*
                        console.log('json marche : ');
                        console.log(marche);
                        console.log('json societes : ');
                        console.log(societes);
                        console.log('json localisations : ');
                        console.log(localisations);
                        */
                        
                        // action 2 : récupération des données WS Explore pour le SIRET donneur d'ordre
                        var action2 = component.get("c.getAccountIdBySiret");
                        action2.setParams({
                            siret: siret
                        });
                        action2.setCallback(this, function(response) {
                            var state2 = response.getState();
                            if (state2 === "SUCCESS") {
                                var accountId = response.getReturnValue();
                                //console.log('idDonneurOrdre : ' + accountId);
                                component.set('v.idDonneurOrdre', accountId); 
                                
                                // action 3 : création dynamique du composant lightning modal de création d'opération avec chargement des données récupérées d'Explore
                                helper.openModalNewOperation(component, event, helper);
                            }
                        });
                        $A.enqueueAction(action2);
                    }
                } else {
                    console.log('# openModalNewOperation - ERROR : WS Explore -> RESPONSE NULL')
                }
                
            }
        });
        $A.enqueueAction(action1);
        //console.log('# openModalNewOperation - END');
    },
    
    
    
})