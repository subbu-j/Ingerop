public with sharing class WS_Explore {

    /*
    Pour récupérer le flux JSON d'une annonce, renseigner les 2 paramètres :

    - Identifiant (exemple: pour identifiant Explore "MP-7714374", l'identifiant est "7714374")
    - Type de marché (exemple: pour identifiant Explore "MP-7714374", le type de marché est "MP")

    Exemple d'appel Annonce : 
    String result = WS_Explore.getAnnonceData('7714374', 'MP');
    System.debug(result);

	Exemple d'appel Siret : 
    String result = WS_Explore.getSiretData('52504601700030');
    System.debug(result);

	Exemple d'appel mise à jour fiche Compte par Explore SIRET : 
    WS_Explore.updateAccount('7714374');
    System.debug(result);
    */

	
    // Mise à jour d'une fiche Compte avec les données WS Explore SIRET
    public static void updateAccount(String recordId){
        
        Account acc = [SELECT Id, Name, SIRET__c from Account where Id =: recordId];
        
        if(acc != null) {
            
            if(acc.SIRET__c != null) {
                //System.debug('### siret : ' + acc.SIRET__c);
                String response = getSiretData(acc.SIRET__c);

                if(test.isRunningTest()){
                    response='{ "NOTICE80": { "SIRET": "52504601700030", "SIREN": "525046017", "NIC": "00030", "L1_NOMEN": "SOCIETE DU GRAND PARIS", "L2_COMP": "", "L3_CADR": "IMMEUBLE LE CEZANNE", "L4_VOIE": "30 AVENUE DES FRUITIERS", "L5_DISP": "CS 10011 ST DENIS", "L6_POST": "93212 LA PLAINE ST DENIS CEDEX", "L7_ETRG": "FRANCE", "RPET": "11", "DEPET": "93", "ARRONET": "3", "CTONET": "99", "COMET": "066", "LIBCOM": "SAINT DENIS", "DU": "00", "TU": "8", "UU": "51", "EPCI": "200054781", "TCD": "61", "ZEMET": "11", "CODEVOIE": "", "NUMVOIE": "30", "INDREP": "", "TYPVOIE": "AV", "LIBVOIE": "DES FRUITIERS", "CODPOS": "93210", "CEDEX": "", "ZR1": "", "SIEGE": "1", "ENSEIGNE": "", "NOMCOM": "", "NATETAB": "", "LIBNATETAB": "", "APET700": "8413Z", "LIBAPET": "Administration publique (tutelle) des activités économiques", "DAPET": "2011", "TEFET": "31", "EFETCENT": "200", "DEFET": "2016", "ORIGINE": "1", "DCRET": "201111", "AMINTRET": "201209", "ACTIVNAT": "", "LIEUACT": "", "ACTISURF": "", "SAISONAT": "P", "MODET": "S", "PRODET": "O", "PRODPART": "", "AUXILT": "0", "ZR2": "", "NOMEN_LONG": "SOCIETE DU GRAND PARIS", "SIGLE": "SGP", "CIVILITE": "", "NJ": "4110", "LIBNJ": "Établissement public national à caractère industriel ou commercial doté d\'un comptable public ", "APEN700": "8413Z", "LIBAPEN": "Administration publique (tutelle) des activités économiques", "DAPEN": "2010", "APRM": "", "TEFEN": "31", "EFENCENT": "200", "DEFEN": "2016", "CATEGORIE": "PME", "DCREN": "201007", "AMINTREN": "201209", "MONOACT": "1", "MODEN": "S", "PRODEN": "O", "ESAANN": "", "TCA": "", "ESAAPEN": "", "ESASEC1N": "", "ESASEC2N": "", "ESASEC3N": "", "ESASEC4N": "", "REGIMP": "11", "MONOREG": "1", "ZR3": "", "RPEN": "11", "DEPCOMEN": "93066", "VMAJ": "", "VMAJ1": "", "VMAJ2": "", "VMAJ3": "", "INDPUBLIPO": "1" }, "COMPLEMENTS": { "TELEPHONE": "0182462000", "SITE_WEB": "www.societedugrandparis.fr", "LATITUDE": 48.919329, "LONGITUDE": 2.354677 } }';
                }

                Explore_Siret data = Explore_Siret.parse(response);
                
                if(data != null) {
                    
                    acc.Name = data.NOTICE80.L1_NOMEN;
                    acc.Description = data.NOTICE80.LIBNJ;
                    acc.ShippingStreet = data.NOTICE80.L4_VOIE;
                    acc.ShippingPostalCode = data.NOTICE80.CODPOS;
                    acc.ShippingCity = data.NOTICE80.LIBCOM;
                    acc.ShippingCountry = data.NOTICE80.L7_ETRG;
                    acc.ShippingCountryCode = 'FR';
                    acc.ShippingLatitude = data.COMPLEMENTS.LATITUDE;
                    acc.ShippingLongitude = data.COMPLEMENTS.LONGITUDE;
                    acc.Phone = data.COMPLEMENTS.TELEPHONE;
                    acc.Website = data.COMPLEMENTS.SITE_WEB;
                    update acc;
                }
            }
        }
    }
    
    // construction de la clé de chiffrement Explore
    public static String getEncryptKey(String idExplore, String type, String siret) {
        String encryptKey = '';
        String strToEncrypt = ''; 
        
        if(siret != null){
            strToEncrypt = getTextToEncrypt(null, null, siret);
        }
        else {
            strToEncrypt = getTextToEncrypt(idExplore, type, null);
        }
        encryptKey = encryptExplore(strToEncrypt);

        return encryptKey;
    }

    // construction de la chaine de texte à chiffrer pour la signature Explore
    public static String getTextToEncrypt(String idExplore, String type, String siret){
        String result = '';
        
        if(test.isRunningTest()){
            if(siret != null){
                result = 'CleClient=' + 'AAAABBBB-0000-00AA-A000-AAAAAA000000' + '&Siret=' + '123456789';
            }
            else {
                result = 'CleClient=' + 'AAAABBBB-0000-00AA-A000-AAAAAA000000' + '&Identifiant=' + idExplore + '&Type=' + type;
            }
        }
        else {
            if(siret != null){
                result = 'CleClient=' + ExploreSettings__c.getInstance().ExploreClientKey__c + '&Siret=' + siret;
            }
            else {
                result = 'CleClient=' + ExploreSettings__c.getInstance().ExploreClientKey__c + '&Identifiant=' + idExplore + '&Type=' + type;
            }
        }

        return result;
    }

    // chiffrement Explore
    public static String encryptExplore(String toEncrypt){

        //toEncrypt = 'CleClient=36AD1727-0961-44E9-A295-7A090F4D68A7&Identifiant=7714374&Type=MP';
        //'20190711vWgUGm86iDgKvXHRfhUUAz1B2rG8rKG2gsuzpgb-LePZbqJ-u_zE1MVuOnDgnhWN';

        DateTime dt = DateTime.now();
        String currentDate = dt.format('yyyyMMdd');
        
        String ckey = '';
        if(test.isRunningTest()){
            ckey = currentDate + 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA-BBBBBBB-C_DDDDDDDDDDDDDD';
        }
        else {
            ckey = currentDate + ExploreSettings__c.getInstance().ExplorePrivateKey__c;
        }

        String combinedDataAsHexclekey = '';        
        String combinedDataAsHexclekeyIV = '';

        // Décomposition de la clé         
        String[] clekey = ckey.split('');
        // Boucle sur l'ensemble des caractères de la clé
        Integer i=0;        
        for(String s : clekey) {            
            if(i<=15) {                
                combinedDataAsHexclekey += EncodingUtil.convertToHex(Blob.valueOf(s));                
                i++;                
            }else{                
                if(i<=31){                    
                    combinedDataAsHexclekeyIV += EncodingUtil.convertToHex(Blob.valueOf(s));                    
                    i++;                    
                }                
            }               
        }        

        // Convertion en hexa de KEY et IV
        Blob combinedDataAsBlobkey = EncodingUtil.convertFromHex(combinedDataAsHexclekey);        
        Blob combinedDataAsBlobkeyIV = EncodingUtil.convertFromHex(combinedDataAsHexclekeyIV);    

        // Appel de la fonction de cryptage
        blob encryptedData = Crypto.encrypt('AES128', combinedDataAsBlobkey, combinedDataAsBlobkeyIV, blob.valueOf(toEncrypt));  
        String encrypt = EncodingUtil.base64Encode(encryptedData).replace('+','-').replace('/','_');

        return encrypt;        
    }

    // récupération de l'url ANNONCE et de la clé privée depuis les custom settings de l'org Salesforce
	public static String getUrlAnnonce(String idExplore, String type) {
        
        
        // https://extranet.explore.fr/ExploreAPI/api/Explore/GetDetail_SF
        //?CleClient=36AD1727-0961-44E9-A295-7A090F4D68A7
        //&Signature=NK6gmtGaY5zQMr6Ybkjac-oMEXqdvmyRZYaDovZkvpPU6-xvw7yyLhAninvImw-97cusxa0_jyHtVpuhcm4pls1YM1U1UJHI1ysJx1aCHys=
        String url;

        // https://extranet.explore.fr/ExploreAPI/api/Explore/GetDetail_SF
        String baseUrl;
        String clientKey;

        if(test.isRunningTest()){
            baseUrl = 'https://extranet.explore.fr/ExploreAPI/api/Explore/GetDetail_SF';
            clientKey = 'AAAABBBB-0000-00AA-A000-AAAAAA000000';
        }
        else {
            baseUrl = ExploreSettings__c.getInstance().ExploreAnnonceUrl__c;
            clientKey = ExploreSettings__c.getInstance().ExploreClientKey__c;
        }

        String signature = getEncryptKey(idExplore, type, null);

        url = baseUrl + '?CleClient=' + clientKey + '&Signature=' + signature;
        //System.debug('# WS_Explore / getUrlAnnonce - url : ' + url);

		return url;
	}

    // récupération de l'url SIRET et de la clé privée depuis les custom settings de l'org Salesforce
	public static String getUrlSiret(String siret) {
        
        // https://extranet.explore.fr/ExploreAPI/api/Explore/GetSocieteParSiret_SF
        //?CleClient=36AD1727-0961-44E9-A295-7A090F4D68A7
        //&Signature=NK6gmtGaY5zQMr6Ybkjac-oMEXqdvmyRZYaDovZkvpPU6-xvw7yyLhAninvImw-97cusxa0_jyHtVpuhcm4pls1YM1U1UJHI1ysJx1aCHys=
        String url;

        // https://extranet.explore.fr/ExploreAPI/api/Explore/GetDetail_SF
        String baseUrl;
        String clientKey;

        if(test.isRunningTest()){
            baseUrl = 'https://extranet.explore.fr/ExploreAPI/api/Explore/GetSocieteParSiret_SF';
            clientKey = 'AAAABBBB-0000-00AA-A000-AAAAAA000000';
        }
        else {
            baseUrl = ExploreSettings__c.getInstance().ExploreSiretUrl__c;
            clientKey = ExploreSettings__c.getInstance().ExploreClientKey__c;
        }

        String signature = getEncryptKey(null, null, siret);

        url = baseUrl + '?CleClient=' + clientKey + '&Signature=' + signature;
        //System.debug('# WS_Explore / getUrlSiret - url : ' + url);

		return url;
	}
    
	// récupération des données depuis WS Explore ANNONCE
    public static String getAnnonceData(String idExplore, String type) {

		String url = getUrlAnnonce(idExplore, type);
		System.debug('url annonce :' + url);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
 
        req.setEndpoint(url);
        req.setMethod('GET');
        HttpResponse res = h.send(req);

        //System.debug('# WS_Explore - getAnnonceData - status : ' + res.getStatusCode());
        //System.debug('# WS_Explore - getAnnonceData - body : ' + res.getBody());

        if(res.getStatusCode() == 200 && res.getBody() != null && res.getBody() != 'null') {
            if(type.equals('MP')){
                // MP : Marché Public
                //System.debug('res.getBody()' + res.getBody());
                Explore_MarchePublic data = Explore_MarchePublic.parse(res.getBody());
                //System.debug('WS_Explore - getAnnonceData - MP - MARCHE_PUBLIC.IDENTIFIANT : ' + data.MARCHE_PUBLIC.IDENTIFIANT);
                return res.getBody();
            } else {
                // MOA : Maitre d'Ouvrage
                //Explore_MaitreOuvrage data = Explore_MaitreOuvrage.parse(res.getBody());
                //System.debug('WS_Explore - getAnnonceData - MOA - IDENTIFIANT : ');
            }
        } else {
            System.debug('WS_Explore - getAnnonceData - response NULL or ERROR');
        }

        return null;
    }
    
    // récupération des données depuis WS Explore SIRET
    public static String getSiretData(String siret) {

		String url = getUrlSiret(siret);

        Http h = new Http();
        HttpRequest req = new HttpRequest();
 
        req.setEndpoint(url);
        req.setMethod('GET');
        HttpResponse res = h.send(req);

        System.debug('# WS_Explore - getSiretData - status : ' + res.getStatusCode());
        System.debug('# WS_Explore - getSiretData - body : ' + res.getBody());

        if(res.getStatusCode() == 200 && res.getBody() != null) {
            Explore_Siret data = Explore_Siret.parse(res.getBody());
            //System.debug('data' + data);
            //System.debug('WS_Explore - getSiretData : ');
            return res.getBody();
        }
        
        return null;
    }



}