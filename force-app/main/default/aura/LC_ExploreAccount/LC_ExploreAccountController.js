({
    doInit : function(component, event, helper) { 
        
        // chargement du composant lightning avec la définition des colonnes des 3 tableaux et des données associées

        //console.log('# doInit - START');
        helper.setParams(component)
        .then(
            $A.getCallback(function(result) {

                //redirect to standard account page corresponding to the SIRET
                //helper.redirectToAccountRecord(component, event, helper);

                //Search the account name passed in the URL on loading th page
                console.log('search1:',component.get("v.searchInputText"));
                if(component.get("v.searchInputText") != null){
                    var action = component.get("c.search");
                    $A.enqueueAction(action);
                }

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
        //helper.redirectToAccountRecord(component, event, helper);
        if(titreExplore != null){
            component.set("v.searchInputText", titreExplore);
            var action = component.get("c.search");
            $A.enqueueAction(action);
        }
    },
    
    
    
    
    
    // RECHERCHE ACCOUNTS
    
    // recherche du texte saisi sur tous les champs de l'objet Account
    search : function(component, event, helper) {

        console.log('search2:',searchElement);
        //var searchElement = document.getElementById("searchtext");
        var searchElement = component.get("v.searchInputText");
        console.log('search3:',searchElement);

        var searchValue = (searchElement) ? searchElement : '';
        
        var action = component.get("c.getAccountsDataSearch");
        action.setParams({
            "searchText": searchValue
        });
        
        action.setCallback(this, function(response){
            var rows = response.getReturnValue();
            if(rows != null){
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    
                    // Name of the Parent Account
                    if (row.Parent){
                        row.ParentName = row.Parent.Name;
                    }
                    //Link to Parent account 
                    if(row.ParentId){
                        row.ParentUrl = '/' + row.ParentId;
                    }
                    //Link to the account record
                    if(row.Id){
                        row.AccountUrl = '/' + row.Id;
                    }
                    //Set the account type value from record type
                    if(row.RecordType){
                        row.AccountType = row.RecordType.Name;
                    }
                }
                component.set('v.searchAccountsData', rows);
                console.log('# search - ', rows);
            }
        });
        $A.enqueueAction(action);
        console.log('# search - END');
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
    
    //For Custom record comparison modal
    openCustomRecordComparisonModal: function (cmp, event, helper) {
        let accountIdP = event.getParam("row").Id;
        cmp.set("v.accountId",accountIdP);
        cmp.set("v.showCustomRecordComparisonModal",true);
    },
    
    closeCustomRecordComparisonModal: function (cmp, event, helper) {
        cmp.set("v.showCustomRecordComparisonModal",false);
    },
    
	/*
	 * New Account
     */
    createAccountModal: function(component, event, helper) {
        var action = component.get("c.createAccount");
        var siret = component.get("v.siretExplore");
        console.log('recTypeId', component.get("v.selectedRecordType"));
        action.setParams({
            "siret" : siret,
            "recordTypeLabel" : component.get("v.selectedRecordType")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var accountResponse;
            var recTypeId;
            if(state === 'SUCCESS'){
                accountResponse = response.getReturnValue();
                accountResponse.SIRET__c = accountResponse.Siret; // Replacing the field name to Object's API name
                recTypeId = accountResponse.RecordTypeId; //Assigning to local variable
                delete accountResponse.Siret; // Deleting the old name
                delete accountResponse.RecordTypeId; // Deleting the separate value
                console.log('accountResponse',  accountResponse);

                var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    entityApiName: "Account",
                    recordTypeId: recTypeId,
                    defaultFieldValues: accountResponse
                });
                createRecordEvent.fire();

            }
            else if(state === 'ERROR'){

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                "title": "Error",
                "message": "Please contact your administrator"
                });
                toastEvent.fire();
            }

        });
        $A.enqueueAction(action);
    },
  
    openAccountModal: function(component, event, helper) {
        //Get all record types for account
        var action = component.get("c.fetchRecordTypeValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var recordTypes = response.getReturnValue();
                var options = [];
                recordTypes.forEach(function(recordType) {
                    options.push({label: recordType, value: recordType});
                });
                component.set("v.accountRecordTypes", options);
                component.set("v.showCreateAccountModal", true);

                console.log('accountRecordTypes0', recordTypes);
                console.log('accountRecordTypes1', options);
            }
        });
        $A.enqueueAction(action);
    },

    closeAccountModal: function(component, event, helper) {
        component.set("v.showCreateAccountModal", false);
    }
    
})