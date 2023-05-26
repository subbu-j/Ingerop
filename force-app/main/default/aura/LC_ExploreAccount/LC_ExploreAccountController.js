({
    doInit : function(component, event, helper) { 
        
        // chargement du composant lightning avec la définition des colonnes des 3 tableaux et des données associées

        //console.log('# doInit - START');
        helper.setParams(component)
        .then(
            $A.getCallback(function(result) {

                //redirect to standard account page corresponding to the SIRET
                helper.redirectToAccountRecord(component, event, helper);
                //component.set('v.isLoading', false);
                
                // datatable 'Résultats d'opérations trouvées
                component.set('v.searchAccountsColumns', helper.getsearchAccountsColumns());
                
            })
        ).catch(function(error) {
            console.log('# doInit - ERROR : ' + error);
        });        
        //console.log('# doInit - END');        
    },
    
    // gestion de mise à jour des paramètres URL GET Explore
    onPageReferenceChanged: function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        
        var titreExplore = pageReference.state.c__Titre;
        var siretExplore = pageReference.state.c__Siret;
        component.set("v.titreExplore", titreExplore);
        component.set("v.siretExplore", siretExplore);
        helper.redirectToAccountRecord(component, event, helper);
    },
    
    
    
    
    
    // RECHERCHE ACCOUNTS
    
    // recherche du texte saisi sur tous les champs de l'objet Account
    search : function(component, event, helper) {
        
        //console.log('# search - START');
        
        //var idExplore = component.get("v.idExplore");
        var searchElement = document.getElementById("searchtext");
        var searchValue = (searchElement) ? searchElement.value : '';
        
        var action = component.get("c.getAccountsDataSearch");
        action.setParams({
            "searchText": searchValue
        });
        
        action.setCallback(this, function(response){
            var rows = response.getReturnValue();
            if(rows != null){
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    
                    console.log('row',row);
                    console.log('ParentId',row.ParentId);
                    console.log('Parent',row.Parent);
                    // gestion du nom du compte associé
                    if (row.Parent){
                        //console.log(row.Compte__r.Name);
                        row.ParentName = row.Parent.Name;
                    }
                    // gestion du nom/prénom du référent associé
                    if(row.ParentId){
                        row.ParentUrl = '/' + row.ParentId;
                    }  
                }
                component.set('v.searchAccountsData', rows);
            }
        });
        $A.enqueueAction(action);
        //console.log('# search - END');
    },
    
    //stockage en local de la taille des colonnes du tableau
    searchAccountsStoreColumnWidths: function (cmp, event, helper) {
        helper.searchAccountsStoreColumnWidths(event.getParam('columnWidths'));
    },
    
    // vidage des paramètres locaux liés à la taille des colonnes 
    searchAccountsResetColumns: function (cmp, event, helper) {
        helper.searchAccountsResetLocalStorage();
        cmp.set('v.searchAccountsColumns', helper.getsearchAccountsColumns());
    },
    
    // gestion du tri des colonnes
    searchAccountsUpdateColumnSorting: function (cmp, event, helper) {
        cmp.set('v.isLoading', true);
        setTimeout($A.getCallback(function() {
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            cmp.set("v.searchAccountsSortedBy", fieldName);
            cmp.set("v.searchAccountsSortedDirection", sortDirection);
            helper.searchAccountsSortData(cmp, fieldName, sortDirection);
            cmp.set('v.isLoading', false);
        }), 0);
    },
    
    // gestion des actions du tableau
    searchAccountsHandleRowAction: function (cmp, event, helper) {
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
    
	/*
	 * New Account
     */
    openAccountModal: function(component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            entityApiName: "Account",
            recordTypeId: "01258000000cdwdAAA",
            defaultFieldValues: {
                Name: "Pre-filled Name"
            }
        });
        createRecordEvent.fire();
    }
    
    
    
})