public with sharing class LCCTRL_ExploreAccount {

    /* récupération des donneés pour la liste 'Opérations liées' */
    @AuraEnabled
    public static List<Operation__c> getRelatedOperationsData (String idExplore) {
        
        set<string> setIdExplore = new set<String>();
        setIdExplore.add(idExplore);
        setIdExplore.add(idExplore.replace('-', '#'));
    
        List<Operation__c> returnList = new List<Operation__c>();
        set<Id> opIds = new set<Id>();
        
        for(AnnonceOperations__c ao : [SELECT Operation__c FROM AnnonceOperations__c WHERE Annonce__r.IdExplore__c IN :setIdExplore]){
            opIds.add(ao.Operation__c);
        }
        
        List<Operation__c> lstOperations = [SELECT Id, Name, Compte__c, Compte__r.Name, Departement__c, estDansMonDepartement__c, estDansMonPole__c, link__c,estDansMonService__c, estDansMonUFO__c, Nom_du_r_f_rent__c, Nombre_d_offres__c, Owner.FirstName, Owner.LastName FROM Operation__c WHERE Id IN :opIds ORDER BY CreatedDate DESC];
        
        for (Operation__c ope : lstOperations) {
            returnList.add(ope);
        }

        return returnList;
    }
    
    /* récupération des donneés pour la liste 'Autres opérations liées au compte' */
    @AuraEnabled
    public static List<Operation__c> getOtherOperationsData (String idExplore, String siret) {

        List<Operation__c> linkedOperations = getRelatedOperationsData(idExplore);

        set<Id> linkedOpeIds = new set<Id>();
        for(Operation__c ope : linkedOperations){
            linkedOpeIds.add(ope.Id);
        }
        
        List<Operation__c> returnList = new List<Operation__c>();
        List<Operation__c> lstOperations = [SELECT Id, Name, Compte__c, Compte__r.Name, Departement__c,link__c, estDansMonDepartement__c, estDansMonPole__c, estDansMonService__c, estDansMonUFO__c, Nom_du_r_f_rent__c, Nombre_d_offres__c, Owner.FirstName, Owner.LastName FROM Operation__c WHERE Id NOT IN :linkedOpeIds AND Compte__r.SIRET__c =: siret AND Compte__r.SIRET__c != NULL ORDER BY CreatedDate DESC];
        
        for (Operation__c ope : lstOperations) {
            returnList.add(ope);
        }

        return returnList;
    }
    
    /* récupération des données pour la liste 'Résultats du compte trouvé' */
    @AuraEnabled
    public static List<Account> getAccountsDataSearch (String searchText) {
        
        List<Account> returnList = new List<Account>();
        /*List<Account> linkedOperations = getRelatedOperationsData(idExplore);
 
        set<Id> linkedOpeIds = new set<Id>();
        for(Operation__c ope : linkedOperations){
            linkedOpeIds.add(ope.Id);
        }*/

        //searchText = (searchText != null && searchText != '') ? '' + searchText + '*' : ''; 
        //List<List<SObject>> searchList = [FIND :searchText IN NAME FIELDS RETURNING Account(Id, Name, Alias__c, ParentId, Parent.Name, SIRET__c, ShippingCity, Type)];
        searchText = (searchText != null && searchText != '') ? '%' + searchText + '%' : ''; 
        List<Account> searchList = [SELECT Id, Name, Alias__c, ParentId, Parent.Name, SIRET__c, ShippingCity, Type FROM Account WHERE Name LIKE :searchText OR Alias__c LIKE :searchText];

        // On filtre les résultats de la recherche et 
        // on construit une liste d'opérations ne contenant pas celles qui sont affichées dans la 1ère liste 'Opérations liées'
        for(Account acc : searchList){
            returnList.add(acc);
        }

        return returnList;
    }

    /* fonction pour lier l'Annonce Explore à la fiche Opération */
    @AuraEnabled
    public static String linkAnnonceToOperation (String recordId, String idExplore){

        String result;
        
        Boolean isMarchePublic = false;        
        if(idExplore.contains('MP')){
            isMarchePublic = true;
        }
        
        String idExploreNum = (idExplore == null) ? '' : idExplore;
        
        // marché public
        idExploreNum = idExploreNum.replace('MP#','');
        idExploreNum = idExploreNum.replace('MP-','');
        
        // autres
        idExploreNum = idExploreNum.replace('FL#','');
        idExploreNum = idExploreNum.replace('FP#','');
        
        //System.debug('# linkAnnonceToOperation - idExploreNum : ' + idExploreNum);
        
        if(isMarchePublic){
            result = WS_Explore.getAnnonceData(idExploreNum, 'MP');
        } else {
            result = WS_Explore.getAnnonceData(idExploreNum, 'FL');
        }          
        //System.debug('# linkAnnonceToOperation - WS_Explore.getAnnonceData : ' + result);
        
        if(result != null){

            if(isMarchePublic){
                List <Operation__c> lstOperations = [SELECT Id, Name, Compte__c FROM Operation__c WHERE Id =: recordId];
                Explore_MarchePublic data = Explore_MarchePublic.parse(result);
                //System.debug('# linkAnnonceToOperation - Explore_MarchePublic.parse : ' + data);
                
                // création de la fiche AnnonceOperation__c
                AnnonceOperations__c annonceOpe = new AnnonceOperations__c();
                annonceOpe.Operation__c = recordId;
                if(lstOperations.size() > 0) {
                    annonceOpe.Compte__c = lstOperations[0].Compte__c;
                }
                
                // recherche d'une fiche annonce existante
                List<Annonce__c> lstAnnonce = [SELECT Id, Operation__c FROM Annonce__c WHERE IdExplore__c =:data.MARCHE_PUBLIC.IDENTIFIANT_EXPLORE];
                
                // Si une fiche existe, on la lie à la fiche AnnonceOperations__c
                if(!lstAnnonce.isEmpty()){
                    annonceOpe.Annonce__c = lstAnnonce[0].Id;
                }
                // sinon, on crée une fiche annonce puis on la lie à la fiche AnnonceOperations__c
                else{
                    String annonceId = createAnnonce(idExplore);
                    annonceOpe.Annonce__c = annonceId;
                }
                
                // insertion de la fiche AnnonceOperations__c
                insert annonceOpe;
                
                String currentOperationName;

                if(lstOperations.size() > 0){
                    currentOperationName = lstOperations[0].Name;
                }

                // création des feeds Chatter pour annoncer la liaison annonce/opération
                for(Operation__c ope : getRelatedOperationsData(idExplore)){
                    if(ope.Id != recordId){
                        postChatterFeedElement(recordId, currentOperationName, ope.OwnerId, data.MARCHE_PUBLIC.OBJET, ope.Id);
                    }
                }
                
            } else {
                // TODO MAITRE OUVRAGE
            }

        }
        return result;
    }
    
    /* fonction pour délier l'opération à l'annonce */
    @AuraEnabled
    public static String unlinkOperation (String recordId, String idExplore){
        
        List <Operation__c> lstOperations = [SELECT Id FROM Operation__c WHERE Id =: recordId];
        List<Annonce__c> lstAnnonces = [SELECT Id FROM Annonce__c WHERE IdExplore__c =: idExplore];
        
        if(lstOperations.size() > 0 && lstAnnonces.size() > 0){
            List<AnnonceOperations__c> lstAnnonceOperation = [SELECT Id, Operation__c FROM AnnonceOperations__c WHERE Annonce__c=: lstAnnonces[0].Id AND Operation__c=: lstOperations[0].Id];
            if(lstAnnonceOperation.size() > 0){
                delete lstAnnonceOperation;
            }
        }
        
        return null;
    }
    
    /* récupération des donneés Annonce Explore de type 'Marché public' (MP) à partir du WS Explore */    
    @AuraEnabled
    public static String getAnnonceMarchePublicData (String idExplore){

        String result;

        String[] arrParams = idExplore.split('-');
		String type = arrParams[0]; 
		String identifier = arrParams[1];
        //System.debug('type: ' + type);
        //System.debug('identifier: ' + identifier);
        
        if(test.isRunningTest()){
            result='{"MARCHE_PUBLIC":{"IDENTIFIANT":7714374,"IDENTIFIANT_EXPLORE":"MP#7714374","CLE_MARCHE_PUBLIC_EXPLORE":"0299bd0b-2648-45f5-8851-96ee0f57e174","OBJET":"Complexe intercommunal sportif et culturel","DATE_LIMITE_RECEPTION":"2019-07-08T12:00:00","DATE_DETECTION":"2019-06-19T00:00:00","DATE_PARUTION":"2019-06-19T00:00:00","SOURCE":2481,"SOURCE_LIB":"Plate-forme dématérialisée","TYPE_AVIS":"Informations complémentaires","MPC_NATURE_CONTRAT":"","MPC_NATURE_CONTRAT_LIB":"","MPC_ALLOTISSEMENT":true,"MPC_MONTANT_REEL":0.0,"MPC_MONTANT_MIN":0.0,"MPC_MONTANT_MAX":0.0,"MPC_RENOUVELLEMENT":false,"MPC_DUREE":0,"MPC_DT_ECHEANCE":"0001-01-01T00:00:00","MPC_DT_LIM_CANDIDAT":"0001-01-01T00:00:00","MPC_DT_LIM_DEM_DOC":"0001-01-01T00:00:00","MSG_CR":"","MSG_CR_LIB":"","URL_DETAIL":"https://extranet.explore.fr/dotnet/AccessBywebservice.aspx?page=AffichageMarchePublic.aspx&projet=7714374&CleClient=36AD1727-0961-44E9-A295-7A090F4D68A7","URL_AVIS_ORIGINAL":"","TEXTE_ANNONCE":"Commune de Reignier-ÉseryM. Jean-François CICLETMaireMairie de Reignier74930 Reignier-ÉseryTél : 0450434003DOSSIER : 19FT-0091-WConsultation :Complexe intercommunal sportif et culturelRemise limite :08/07/2019 à 12h00COURRIERDestinataire :dce@explore.frdate denvoi :19/06/2019 à 09h36Sujet :Le DCE a été modifié19FT-0091-W : Complexe intercommunal sportif et culturelModification du DCE : Veuillez prendre en compte les modifications apportées au DCE et listées ci-dessousTélécharger le nouveau DCEAWS-AchatAWS - 97 rue du général Mangin - 38100 Grenoble","MPC_MISSION":[{"MPC_MISSION":"","MPC_MISSION_LIB":""}],"MPC_PROCEDURE":[{"MPC_PROCEDURE":"AOO","MPC_PROCEDURE_LIB":"Appel doffre ouvert"}],"MPC_FORME_MARCHE":[{"MPC_FORME_MARCHE":"MSIMP","MPC_FORME_MARCHE_LIB":"Marché simple"}],"MPC_TYPE_PRESTATION":[{"MPC_TYPE_PRESTATION":"PDFO","MPC_TYPE_PRESTATION_LIB":"Fourniture"},{"MPC_TYPE_PRESTATION":"PDTR","MPC_TYPE_PRESTATION_LIB":"Travaux"}],"MPC_TYPE_CONTRAT":[{"MPC_TYPE_CONTRAT":"MAPU","MPC_TYPE_CONTRAT_LIB":"Marché public"}],"SOCIETES":[{"ROLE":"DONNEUR ORDRE","RAISON_SOCIALE":"COMMUNE DE REIGNIER ESERY","SIRET":"21740220500017","SIREN":"217402205","IDENTIFIANT_SOCIETE_EXPLORE":109388,"ADRESSE_1":"197 GRANDE RUE","ADRESSE_2":"","CODE_POSTAL":"74930","VILLE":"Reignier-Ésery","CODE_NAF":"8411Z","NATURE_ETS":"EP","TELEPHONE":"0450434003","TEFEN":"31","TEFEN_LIB":"200 à 249 salariés"}],"LOCALISATIONS":[{"DEPARTEMENT":"74","DEPARTEMENT_LIB":"Haute-Savoie (74)","CODE_COMMUNE":"74220","ADRESSE1":"","ADRESSE2":"","CODE_POSTAL":"74930","COMMUNE":"Reignier-Ésery"}],"DCES":[]}}';
        }
        else {
            
            result = WS_Explore.getAnnonceData(identifier, type);
            //System.debug('result' + result);
            if(result != null){
                Explore_MarchePublic data = Explore_MarchePublic.parse(result);
                //System.debug('data' + data);
                result = Json.serialize(data.MARCHE_PUBLIC) + '¤' + Json.serialize(data.MARCHE_PUBLIC.SOCIETES) + '¤' + Json.serialize(data.MARCHE_PUBLIC.LOCALISATIONS);
            } else {
                System.debug('getAnnonceMarchePublicData result NULL');
            }

            //System.debug('JSON' + result);
        }
        
        return result;
    }
    
    /* Retrive Account Id if SIRET corresponds to only one Account record */ 
    @AuraEnabled
    public static String getAccountIdBySiret (String siret){
        List<Account> lstAccount = [SELECT Id, Name FROM Account WHERE SIRET__c =:siret];
        if(!lstAccount.IsEmpty()){
            if(lstAccount.size() == 1){
                return lstAccount[0].Id;
            }
        }
        return null;
    }
    
    /* récupération des donneés Annonce Explore de type 'Maître d'ouvrage' (FL/FP) à partir du WS Explore */ 
    @AuraEnabled
    public static String getAnnonceMaitreOuvrageData (String idExplore){
        
        String result;
        /*
        String[] arrParams = idExplore.split('-');
		String type = arrParams[0];
		String identifier = arrParams[1];
        
        if(test.isRunningTest()){

        }
        else {
            result = WS_Explore.getAnnonceData(identifier, type);
            Explore_MaitreOuvrage data = Explore_MaitreOuvrage.parse(result);
            //System.debug('data' + data);
            
            // TODO : concaténation des données JSON
            //result = Json.serialize(data.MARCHE_PUBLIC) + '¤' + Json.serialize(data.MARCHE_PUBLIC.SOCIETES) + '¤' + Json.serialize(data.MARCHE_PUBLIC.LOCALISATIONS);
        }

        System.debug('JSON' + result);
        */
        return result;
    }
    
    /* création de la fiche Annonce partir du WS Explore */ 
    @AuraEnabled
    public static String createAnnonce (String idExplore) {
        
        Boolean isMarchePublic = false;
        // détermine le type d'annonce
        if(idExplore.contains('MP')){
            isMarchePublic = true;
        }

        // '-' tiret reçu dans l'url Explore mais l'id Explore comporte un '#' lors de la restitution des données par le WS Explore. 
        // Id Explore sauvegardé avec '#' dans fiche Annonce Salesforce
        idExplore = idExplore.replace('-','#');
        
        // suppression du type d'annonce pour garder l'identifiant Explore numérique
        String idExploreNum = (idExplore == null) ? '': idExplore;
        idExploreNum = idExploreNum.replace('-', '');
        idExploreNum = idExploreNum.replace('#', '');
        idExploreNum = idExploreNum.replace('MP', '');
        idExploreNum = idExploreNum.replace('FL', '');
        idExploreNum = idExploreNum.replace('FP', '');
        
        // recherche d'une fiche Annonce existante
        List<Annonce__c> lstAnnonce = [SELECT Id, Name FROM Annonce__c WHERE IdExplore__c =: idExplore];
        
        if(lstAnnonce.isEmpty()){    
            System.debug('# LCCTRL_Explore / createAnnonce - no annonce in org.');

            if(isMarchePublic){
                // récupération des données du WS Explore Annonce

                if (test.isRunningTest()) {
                    Test.setMock(HttpCalloutMock.class, new Explore_MockMarchePublic());
                }
                String annonceData = WS_Explore.getAnnonceData(idExploreNum, 'MP');

                Explore_MarchePublic data = Explore_MarchePublic.parse(annonceData);
                
                String dateParution = data.MARCHE_PUBLIC.DATE_PARUTION;
                dateParution=dateParution.replace('T00:00:00','');
                
                String dateEcheance = data.MARCHE_PUBLIC.DATE_LIMITE_RECEPTION;
                dateEcheance=dateEcheance.replace('0001-01-01T00:00:00',' ');
                dateEcheance=dateEcheance.replace('T',' ');
                
                // création de la fiche Annonce
                Annonce__c annonce = new Annonce__c();
                String annonceName = data.MARCHE_PUBLIC.OBJET;
                System.debug('# LCCTRL_Explore / createAnnonce - annonceName length' + annonceName.length());
                if(annonceName.length() > 80){
                    annonce.Name = annonceName.substring(0,79);
                }
                annonce.Objet__c = data.MARCHE_PUBLIC.OBJET;
                annonce.IdExplore__c = data.MARCHE_PUBLIC.IDENTIFIANT_EXPLORE;
                annonce.IdExploreSimplifie__c = data.MARCHE_PUBLIC.IDENTIFIANT;
                annonce.Date_de_parution__c = String.isBlank(dateParution) ? null : Date.valueof(dateParution);
                annonce.Date_d_echeance__c = String.isBlank(dateEcheance) ? null : DateTime.valueof(dateEcheance);
                annonce.Lien_vers_l_annonce__c = 'https://extranet.explore.fr/DotNet/AffichageMarchePublic.aspx?projet=' + data.MARCHE_PUBLIC.IDENTIFIANT;
                annonce.Contenu__c = data.MARCHE_PUBLIC.TEXTE_ANNONCE;
                annonce.Budget_travaux_HT__c = data.MARCHE_PUBLIC.MPC_MONTANT_REEL;
                
                String adr1 = '';
                String adr2 = '';
                adr1 = data.MARCHE_PUBLIC.LOCALISATIONS[0].ADRESSE1;
                adr2 = data.MARCHE_PUBLIC.LOCALISATIONS[0].ADRESSE2;
                
                if(adr1 != null && adr1 != ''){
                    if(adr2 != null && adr2 != ''){
                    	annonce.Rue__c = adr1 + ' ' + adr2;
                    } else {
                        annonce.Rue__c = adr1;
                    }
                }
 
                annonce.Code_postal__c = data.MARCHE_PUBLIC.LOCALISATIONS[0].CODE_POSTAL;
                annonce.Ville__c = data.MARCHE_PUBLIC.LOCALISATIONS[0].COMMUNE;
                annonce.Pays__c = 'FRANCE';
                
                System.debug('# LCCTRL_Explore / createAnnonce - insert annonce : ' + data.MARCHE_PUBLIC.IDENTIFIANT_EXPLORE);
                
                insert annonce;
                
                return annonce.Id;
                
            } else {
                // TODO MAITRE D'OUVRAGE
            }

        } else {
            String annonceId = lstAnnonce.get(0).Id;
            System.debug('# LCCTRL_Explore / createAnnonce - annonce existing in org : ' + annonceId);
            return annonceId;
        }
        return null;
    }

    @AuraEnabled
    public static String postChatterFeedElement(String operationId, String operationName, String ownerId, String annonceObject, String subjectId ){

        String urlOperation = URL.getSalesforceBaseUrl().toExternalForm() + '/' + operationId;

        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        ConnectApi.MarkupBeginSegmentInput markupBeginSegment;
        ConnectApi.MarkupEndSegmentInput markupEndSegment;
        ConnectApi.LinkSegmentInput linkSegment = new ConnectApi.LinkSegmentInput();

        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = 'Bonjour ';
        messageBodyInput.messageSegments.add(textSegmentInput);

        // ID Propriétaire de la fiche Opération
        mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        mentionSegmentInput.id = ownerId;
        messageBodyInput.messageSegments.add(mentionSegmentInput);

        textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = ', Une nouvelle opération ';
        messageBodyInput.messageSegments.add(textSegmentInput);

        markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
        markupBeginSegment.markupType = ConnectApi.MarkupType.Bold;
        messageBodyInput.messageSegments.add(markupBeginSegment);

        textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = operationName + ' (';
        messageBodyInput.messageSegments.add(textSegmentInput);

        linkSegment.url = urlOperation;
        messageBodyInput.messageSegments.add(linkSegment);

        markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
        markupEndSegment.markupType = ConnectApi.MarkupType.Bold;
        messageBodyInput.messageSegments.add(markupEndSegment);

        textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = ') a été liée à l’annonce ';
        messageBodyInput.messageSegments.add(textSegmentInput);

        markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
        markupBeginSegment.markupType = ConnectApi.MarkupType.Bold;
        messageBodyInput.messageSegments.add(markupBeginSegment);

        textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = annonceObject;
        messageBodyInput.messageSegments.add(textSegmentInput);

        markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
        markupEndSegment.markupType = ConnectApi.MarkupType.Bold;
        messageBodyInput.messageSegments.add(markupEndSegment);

        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
    
        feedItemInput.subjectId = subjectId;

        ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
        
        return null;
    }

}