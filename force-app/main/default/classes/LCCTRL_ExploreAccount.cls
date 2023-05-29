public with sharing class LCCTRL_ExploreAccount {
    
    /* récupération des données pour la liste 'Résultats du compte trouvé' */
    @AuraEnabled
    public static List<Account> getAccountsDataSearch (String searchText) {
        
        List<Account> returnList = new List<Account>();

        //searchText = (searchText != null && searchText != '') ? '' + searchText + '*' : ''; 
        //List<List<SObject>> searchList = [FIND :searchText IN NAME FIELDS RETURNING Account(Id, Name, Alias__c, ParentId, Parent.Name, SIRET__c, ShippingCity, Type)];
        searchText = (searchText != null && searchText != '') ? '%' + searchText + '%' : ''; 
        List<Account> searchList = [SELECT Id, Name, Alias__c, ParentId, Parent.Name, SIRET__c, ShippingCity, RecordType.Name FROM Account WHERE Name LIKE :searchText OR Alias__c LIKE :searchText];
        
        for(Account acc : searchList){
            returnList.add(acc);
        }

        return returnList;
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
    public static List<String> fetchRecordTypeValues(){
        /* List<Schema.RecordTypeInfo> recordTypes = Account.SObjectType.getDescribe().getRecordTypeInfos();    
        Map<String, Id> recordTypeMap = new Map<String, Id>();
        for(RecordTypeInfo rt : recordTypes){
            if(rt.getName() != 'Master'){
                recordTypeMap.put(rt.getName(), rt.getRecordTypeId());
            }
        }        
        system.debug('recordTypeMap'+ recordTypeMap);
        return recordTypeMap; */

        List<Schema.RecordTypeInfo> recordTypes = Account.SObjectType.getDescribe().getRecordTypeInfos();    
        Map<Id, String> recordTypeMap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordTypes){
            if(rt.getName() != 'Master'){
                recordTypeMap.put(rt.getRecordTypeId(), rt.getName());
            }
        }        
        system.debug('recordTypeMap'+ recordTypeMap);
        return recordTypeMap.values();

    }
    
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){
        Id recid = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        return recid;
    }      

    @AuraEnabled
    public static ExploreAccountWrapper createAccount(String siret, String recordTypeLabel){
        if (String.isBlank(siret)){
            throw new AuraHandledException(Label.AP_CustRecCompCtrl_Ex_EmptySIRET);
        }
        Id recid = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
SYSTEM.DEBUG('recid'+ recid);
        try{
            String jsonExplore = Test.isRunningTest() ? TestDataFactory.JSON_RESULT_CRCC : WS_Explore.getSiretData(siret);
            Explore_Siret data = Explore_Siret.parse(jsonExplore);
            ExploreAccountWrapper acc = new ExploreAccountWrapper();
            System.debug('dataSize:' + data);

            if (data != null){
                acc.Name = data.NOTICE80.L1_NOMEN;
                acc.Siret = data.NOTICE80.SIRET;
                acc.Description = data.NOTICE80.LIBNJ;
                acc.ShippingStreet = data.NOTICE80.L4_VOIE;
                acc.ShippingPostalCode = data.NOTICE80.CODPOS;
                acc.ShippingCity = data.NOTICE80.LIBCOM;
                acc.ShippingCountry = data.NOTICE80.L7_ETRG;
                acc.ShippingLatitude = data.COMPLEMENTS.LATITUDE;
                acc.ShippingLongitude = data.COMPLEMENTS.LONGITUDE;
                acc.Phone = data.COMPLEMENTS.TELEPHONE;
                acc.Website = data.COMPLEMENTS.SITE_WEB;
                acc.RecordTypeId = recid;
            }
            return acc;
        } 
        catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
            
    public class ExploreAccountWrapper{
        @AuraEnabled public String Name;
        @AuraEnabled public String Siret;
        @AuraEnabled public String Description;
        @AuraEnabled public String ShippingStreet;
        @AuraEnabled public String ShippingPostalCode;
        @AuraEnabled public String ShippingCity;
        @AuraEnabled public String ShippingCountry;
        @AuraEnabled public Double ShippingLongitude;
        @AuraEnabled public Double ShippingLatitude;
        @AuraEnabled public String Phone;
        @AuraEnabled public String Website;
        @AuraEnabled public String RecordTypeId;
    }


}