({
    // fermeture du composant modal
    closeModal : function(component, event, helper) {
        helper.closeModal(component, event, helper);
    },
    
    
    
    // gestion du chargement du composant modal
    handleLoad: function(component, event, helper) {
        
        //console.log('# handleLoad - START');
        
        component.set('v.showSpinner', true);
        
        var idExplore = component.get('v.idExplore');
        var typeMarcheExplore = component.get('v.typeMarcheExplore');
        var nomExplore = component.get('v.nomExplore');
        var siretExplore = component.get('v.siretExplore');
        var idDonneurOrdre = component.get('v.idDonneurOrdre');
        var concatenatedJson;
        
        if(typeMarcheExplore == 'MP') {
            concatenatedJson = component.get('v.annonceMarchePublicData');
        } else {
            concatenatedJson = component.get('v.annonceMaitreOuvrageData');
        }
        /*
        console.log('# handleLoad - idExplore : ' + idExplore);
        console.log('# handleLoad - typeMarcheExplore : ' + typeMarcheExplore);
        console.log('# handleLoad - nomExplore : ' + nomExplore);
        console.log('# handleLoad - siretExplore : ' + siretExplore);
        console.log('# handleLoad - idDonneurOrdre : ' + idDonneurOrdre);
        */
        
        if(concatenatedJson != null){
            if(concatenatedJson.indexOf('¤')>-1){
            	var arrData = concatenatedJson.split('¤');
                //console.log(concatenatedJson);
                
                // chargement des valeurs par défaut récupérées du flux WS Explore Annonce
                
                var marche = JSON.parse(arrData[0]);
                var societes = JSON.parse(arrData[1]);
                var localisations = JSON.parse(arrData[2]);
                var siret;
                
                if(societes != null && societes.length>0) {
                    siret = societes[0].SIRET;
                    if(siret != null){
                        component.set('v.siretExplore', siret); 
                    }
                    //console.log('# handleLoad - SIRET : ' + siret);
                }
                
                var nomOperationCmp = component.find('nomOperation');
                if(nomOperationCmp) {
                    //console.log('# handleLoad - nomOperationCmp OK');
                    if(nomExplore != null){
                        //console.log('# handleLoad - nomExplore NOT NULL');
                        //console.log('# handleLoad - nomExplore.length : ' + nomExplore.length);
                        var length = 0;
                        length = nomExplore.length;
                        if(length > 80){
                            nomExplore = nomExplore.substring(0,80);
                            //console.log('# handleLoad - nomExplore : ' + nomExplore);
                        }
                        nomOperationCmp.set('v.value', nomExplore); 
                    }
                }
        
                var objetCmp = component.find('objet');
                if(objetCmp) {
                    if(nomExplore != null){
                        objetCmp.set('v.value', idExplore + ' - ' + nomExplore); 
                    }
                }
                
                var adr1;
                var adr2;
                var cp;
                var loc;
                if(localisations != null) {
                    adr1 = localisations[0].ADRESSE1;
                    adr2 = localisations[0].ADRESSE2;
                    cp = localisations[0].CODE_POSTAL;
                    loc = localisations[0].COMMUNE;
                    loc = loc.toUpperCase();
                    var adrCmp = component.find('adresse');
                    if(adrCmp) {
                        if(adr1 != null){
                            if(adr2 != null) {
                                adrCmp.set('v.value', adr1 + ' ' + adr2); 
                            } else {
                                adrCmp.set('v.value', adr1); 
                            }
                        }
                    }
                    
                    var cpCmp = component.find('codePostal');
                    if(cpCmp) {
                        if(cp != null){
                            cpCmp.set('v.value', cp); 
                        }
                    }
                    
                    var locCmp = component.find('ville');
                    if(locCmp) {
                        if(loc != null){
                            locCmp.set('v.value', loc); 
                        }
                    }
                    
                    var paysCmp = component.find('pays');
                    if(paysCmp) {
                        paysCmp.set('v.value', 'FRANCE'); 
                    }
                    //component.set('v.siretExplore', siret); 
                    
                    var zoneCmp = component.find('zoneGeographique');
                    if(zoneCmp) {
                        zoneCmp.set('v.value', 'Europe de l\'Ouest (zone "Euro")'); 
                    }
                    
                    console.log('# handleLoad - SIRET : ' + siret);
                }  
            } else {
            	console.log('# handleLoad - ERROR - WS Explore : unexpected response'); 
            }
            
        } else {
            console.log('# handleLoad - ERROR - WS Explore : response NULL');
        }
        
        
        /*
        console.log('marche : ');
        console.log(marche);
        console.log('societes : ');
        console.log(societes);
        console.log('localisations : ');
        console.log(localisations);
        */
        
        //var result = helper.getAnnonceData(component, event, helper);
        //console.log('# handleLoad / result : ' + result);
        
        //console.log('# handleLoad - END');
    },
    
    
    // gestion de la soumission du formulaire de création d'opération    
    handleSubmit : function(component, event, helper) {
        //console.log('# handleSubmit - START');
        
        component.set('v.showSpinner', true);

        var nomOperationCmp = component.find('nomOperation');
        if(nomOperationCmp) {
            var value = nomOperationCmp.get("v.value");
            var nomOperation = value;

            //console.log('# handleSubmit - nomOperationCmp OK');
            //
            if(nomOperation != null){
                //console.log('# handleSubmit - nomExplore NOT NULL');
                //console.log('# handleSubmit - nomExplore.length : ' + value.length);
                var length = 0;
                length = nomOperation.length;
                if(length > 80){
                    //nomOperation = value.substring(0,80);
                    //console.log('# handleSubmit - nomOperation : ' + nomOperation);
                    
                    //nomOperationCmp.set("v.errors", [{message:"Veuillez renseigner un nom d'opération valide: " + nomOperation}]);

                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Nom de l'opération",
                        "type": "warning",
                        "message": "Veuillez saisir un nom d'opération valide (longueur max 80 caractères - actuellement : "+ value.length +")"             
                    });
                    toastEvent.fire();
                    
                    event.preventDefault();
                    
                    return;

                }

                if(length == 0){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Champs obligatoires",
                        "type": "warning",
                        "message": "Veuillez renseigner le champ obligatoire suivant : 'Nom de l'opération'."             
                    });
                    toastEvent.fire();
                    
                    event.preventDefault();
                    
                    return;
                } 
            }

        }
        
        // contrôle des champs obligatoires
        
        var invalidFields = helper.isFormValid(component);
        if(invalidFields && invalidFields.length > 0){
            
            console.log('# handleSubmit - helper.isFormValid / mandatory fields not filled');
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Champs obligatoires",
                "type": "warning",
                "message": "Veuillez renseigner les champs obligatoires suivants : 'Nom', 'Type opération', 'Activité', 'Compte', 'UFO'."             
            });
            toastEvent.fire();
            
            event.preventDefault();
            
            return;
        }
        
        event.preventDefault(); // Prevent default submit
        
        component.set('v.showSpinner', true);
        
        var fields = event.getParam("fields");
        //console.log(fields);
        var fields = event.getParam("fields");
        // exemple de surcharge d'un champ du formulaire
        //fields.Name = 'MP-1234';
        
        //var nomOperation = component.get("v.nomExplore");
        //nomOperation = nomOperation.substring(0,80);
        //prompt('',nomOperation);
        
        //fields.Name = nomOperation;
        
        var idExplore = component.get("v.idExplore");
        var typeMarche = component.get('v.typeMarcheExplore');
        
        // création de la fiche Annonce Explore par composant serveur WS_Explore.createAnnonce
        var action = component.get('c.createAnnonce');
        action.setParams({
            idExplore: idExplore
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //console.log('# handleSubmit - state : ' + state);
            
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('# handleSubmit - createAnnonce END');
                //console.log(fields);
                component.find('createOperationForm').submit(fields); // Submit form
                
            } else if (state === 'INCOMPLETE' || state === 'ERROR') {
                var error = response.getError()[0];
                console.log('# handleSubmit - error : ' + error);
            } else {
                console.log('# handleSubmit - other : ' + response);
            }
            
        });
        $A.enqueueAction(action);
        
        component.set('v.showSpinner', false);
        
        console.log('# handleSubmit - END');
    },
    
    // gestion de l'événement de création d'opération réussie
    handleSuccess : function(component, event, helper) {
        
        console.log('# handleSuccess - START');

        component.set('v.showSpinner', true);
        
        var nomExplore = component.get('v.nomExplore');
        var idExplore = component.get("v.idExplore");
        
        var record = event.getParams().response;
        console.log('# handleSuccess - record id : ' + record.id);
        
        // création de la fiche AnnonceOperation__c 
        var action = component.get('c.linkAnnonceToOperation');
        action.setParams({
            recordId: record.id,
            idExplore: idExplore
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('# handleSuccess - linkAnnonceToOperation / ok');
                
                // affichage de la notification 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Succès!",
                    "type": "success",
                    "message": "Nouvelle opération '"+ nomExplore +"' créée.",
                    "messageData": [
                        {
                            url: '/' + record.id,
                            label: record.fields.Name.value
                        }
                    ]
                });
                toastEvent.fire();
                
                component.set('v.showSpinner', false);

                $A.get("e.force:refreshView").fire();
                
            } else if (state === 'INCOMPLETE' || state === 'ERROR') {
                var error = response.getError()[0];
                console.log('# handleSuccess - linkAnnonceToOperation / error : ' + error);
            } else {
                console.log('# handleSuccess - linkAnnonceToOperation / other : ' + response);
            }
            
        });
        $A.enqueueAction(action);
        
        component.set('v.showSpinner', false);
    },
    
    // gestion de l'événement de création d'opération en erreur
    handleError : function(component, event, helper) {
        
        console.log('# handleError - START');
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Erreur!",
            "type": "error",
            "message": "Une erreur est survenue lors de la création de l'opération."             
        });
        toastEvent.fire();
        
        $A.get("e.force:refreshView").fire();
        component.set('v.showSpinner', false);
        
        console.log('# handleError - END');
    },
    
    
    createAccountRecord : function (component, event, helper) {
        var event = $A.get("e.force:createRecord");
        event.setParams({
            "entityApiName": "Account"
        });
        event.fire();
    },
    
    
    
    
})