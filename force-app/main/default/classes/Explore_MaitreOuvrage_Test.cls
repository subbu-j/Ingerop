@IsTest
public class Explore_MaitreOuvrage_Test {
    
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"MARCHE_PUBLIC\": {'+
		'        \"IDENTIFIANT\": 7714374,'+
		'        \"IDENTIFIANT_EXPLORE\": \"MP#7714374\",'+
		'        \"CLE_MARCHE_PUBLIC_EXPLORE\": \"0299bd0b-2648-45f5-8851-96ee0f57e174\",'+
		'        \"OBJET\": \"Complexe intercommunal sportif et culturel\",'+
		'        \"DATE_LIMITE_RECEPTION\": \"2019-07-08T12:00:00\",'+
		'        \"DATE_DETECTION\": \"2019-06-19T00:00:00\",'+
		'        \"DATE_PARUTION\": \"2019-06-19T00:00:00\",'+
		'        \"SOURCE\": 2481,'+
		'        \"SOURCE_LIB\": \"Plate-forme dématérialisée\",'+
		'        \"TYPE_AVIS\": \"Informations complémentaires\",'+
		'        \"MPC_NATURE_CONTRAT\": \"\",'+
		'        \"MPC_NATURE_CONTRAT_LIB\": \"\",'+
		'        \"MPC_ALLOTISSEMENT\": true,'+
		'        \"MPC_MONTANT_REEL\": 0,'+
		'        \"MPC_MONTANT_MIN\": 0,'+
		'        \"MPC_MONTANT_MAX\": 0,'+
		'        \"MPC_RENOUVELLEMENT\": false,'+
		'        \"MPC_DUREE\": 0,'+
		'        \"MPC_DT_ECHEANCE\": \"0001-01-01T00:00:00\",'+
		'        \"MPC_DT_LIM_CANDIDAT\": \"0001-01-01T00:00:00\",'+
		'        \"MPC_DT_LIM_DEM_DOC\": \"0001-01-01T00:00:00\",'+
		'        \"MSG_CR\": \"\",'+
		'        \"MSG_CR_LIB\": \"\",'+
		'        \"URL_DETAIL\": \"https://extranet.explore.fr/dotnet/AccessBywebservice.aspx?page=AffichageMarchePublic.aspx&projet=7714374&CleClient=36AD1727-0961-44E9-A295-7A090F4D68A7\",'+
		'        \"URL_AVIS_ORIGINAL\": \"\",'+
		'        \"TEXTE_ANNONCE\": \"Commune de Reignier-Ésery\\r\\nM. Jean-François CICLET\\r\\nMaire\\r\\nMairie de Reignier\\r\\n74930 Reignier-Ésery\\r\\nTél : 0450434003\\r\\n\\r\\nDOSSIER : 19FT-0091-W\\r\\nConsultation :\\r\\nComplexe intercommunal sportif et culturel\\r\\nRemise limite :\\r\\n08/07/2019 à 12h00\\r\\n\\r\\nCOURRIER\\r\\nDestinataire :\\r\\ndce@explore.fr\\r\\nDate d\'envoi :\\r\\n19/06/2019 à 09h36\\r\\nSujet :\\r\\nLe DCE a été modifié\\r\\n19FT-0091-W : Complexe intercommunal sportif et culturel\\r\\nModification du DCE : Veuillez prendre en compte les modifications apportées au DCE et listées ci-dessous\\r\\n\\r\\nTélécharger le nouveau DCE\\r\\n\\r\\n\\r\\nAWS-Achat\\r\\nAWS - 97 rue du général Mangin - 38100 Grenoble\\r\\n\\r\\n\",'+
		'        \"MPC_MISSION\": ['+
		'            {'+
		'                \"MPC_MISSION\": \"\",'+
		'                \"MPC_MISSION_LIB\": \"\"'+
		'            }'+
		'        ],'+
		'        \"MPC_PROCEDURE\": ['+
		'            {'+
		'                \"MPC_PROCEDURE\": \"AOO\",'+
		'                \"MPC_PROCEDURE_LIB\": \"Appel d\'offre ouvert\"'+
		'            }'+
		'        ],'+
		'        \"MPC_FORME_MARCHE\": ['+
		'            {'+
		'                \"MPC_FORME_MARCHE\": \"MSIMP\",'+
		'                \"MPC_FORME_MARCHE_LIB\": \"Marché simple\"'+
		'            }'+
		'        ],'+
		'        \"MPC_TYPE_PRESTATION\": ['+
		'            {'+
		'                \"MPC_TYPE_PRESTATION\": \"PDFO\",'+
		'                \"MPC_TYPE_PRESTATION_LIB\": \"Fourniture\"'+
		'            },'+
		'            {'+
		'                \"MPC_TYPE_PRESTATION\": \"PDTR\",'+
		'                \"MPC_TYPE_PRESTATION_LIB\": \"Travaux\"'+
		'            }'+
		'        ],'+
		'        \"MPC_TYPE_CONTRAT\": ['+
		'            {'+
		'                \"MPC_TYPE_CONTRAT\": \"MAPU\",'+
		'                \"MPC_TYPE_CONTRAT_LIB\": \"Marché public\"'+
		'            }'+
		'        ],'+
		'        \"SOCIETES\": ['+
		'            {'+
		'                \"ROLE\": \"DONNEUR ORDRE\",'+
		'                \"RAISON_SOCIALE\": \"COMMUNE DE REIGNIER ESERY\",'+
		'                \"SIRET\": \"21740220500017\",'+
		'                \"SIREN\": \"217402205\",'+
		'                \"IDENTIFIANT_SOCIETE_EXPLORE\": 109388,'+
		'                \"ADRESSE_1\": \"197 GRANDE RUE\",'+
		'                \"ADRESSE_2\": \"\",'+
		'                \"CODE_POSTAL\": \"74930\",'+
		'                \"VILLE\": \"Reignier-Ésery\",'+
		'                \"CODE_NAF\": \"8411Z\",'+
		'                \"NATURE_ETS\": \"EP\",'+
		'                \"TELEPHONE\": \"0450434003\",'+
		'                \"TEFEN\": \"31\",'+
		'                \"TEFEN_LIB\": \"200 à 249 salariés\"'+
		'            }'+
		'        ],'+
		'        \"LOCALISATIONS\": ['+
		'            {'+
		'                \"DEPARTEMENT\": \"74\",'+
		'                \"DEPARTEMENT_LIB\": \"Haute-Savoie (74)\",'+
		'                \"CODE_COMMUNE\": \"74220\",'+
		'                \"ADRESSE1\": \"\",'+
		'                \"ADRESSE2\": \"\",'+
		'                \"CODE_POSTAL\": \"74930\",'+
		'                \"COMMUNE\": \"Reignier-Ésery\"'+
		'            }'+
		'        ],'+
		'        \"DCES\": []'+
		'    }'+
		'}';
		Explore_MaitreOuvrage r = Explore_MaitreOuvrage.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Explore_MaitreOuvrage.MPC_FORME_MARCHE objMPC_FORME_MARCHE = new Explore_MaitreOuvrage.MPC_FORME_MARCHE(System.JSON.createParser(json));
		System.assert(objMPC_FORME_MARCHE != null);
		System.assert(objMPC_FORME_MARCHE.MPC_FORME_MARCHE == null);
		System.assert(objMPC_FORME_MARCHE.MPC_FORME_MARCHE_LIB == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Explore_MaitreOuvrage.MPC_MISSION objMPC_MISSION = new Explore_MaitreOuvrage.MPC_MISSION(System.JSON.createParser(json));
		System.assert(objMPC_MISSION != null);
		System.assert(objMPC_MISSION.MPC_MISSION == null);
		System.assert(objMPC_MISSION.MPC_MISSION_LIB == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Explore_MaitreOuvrage.LOCALISATIONS objLOCALISATIONS = new Explore_MaitreOuvrage.LOCALISATIONS(System.JSON.createParser(json));
		System.assert(objLOCALISATIONS != null);
		System.assert(objLOCALISATIONS.DEPARTEMENT == null);
		System.assert(objLOCALISATIONS.DEPARTEMENT_LIB == null);
		System.assert(objLOCALISATIONS.CODE_COMMUNE == null);
		System.assert(objLOCALISATIONS.ADRESSE1 == null);
		System.assert(objLOCALISATIONS.ADRESSE2 == null);
		System.assert(objLOCALISATIONS.CODE_POSTAL == null);
		System.assert(objLOCALISATIONS.COMMUNE == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Explore_MaitreOuvrage.DCES objDCES = new Explore_MaitreOuvrage.DCES(System.JSON.createParser(json));
		System.assert(objDCES != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Explore_MaitreOuvrage objExplore_MaitreOuvrage = new Explore_MaitreOuvrage(System.JSON.createParser(json));
		System.assert(objExplore_MaitreOuvrage != null);
		System.assert(objExplore_MaitreOuvrage.MARCHE_PUBLIC == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Explore_MaitreOuvrage.MPC_TYPE_PRESTATION objMPC_TYPE_PRESTATION = new Explore_MaitreOuvrage.MPC_TYPE_PRESTATION(System.JSON.createParser(json));
		System.assert(objMPC_TYPE_PRESTATION != null);
		System.assert(objMPC_TYPE_PRESTATION.MPC_TYPE_PRESTATION == null);
		System.assert(objMPC_TYPE_PRESTATION.MPC_TYPE_PRESTATION_LIB == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Explore_MaitreOuvrage.SOCIETES objSOCIETES = new Explore_MaitreOuvrage.SOCIETES(System.JSON.createParser(json));
		System.assert(objSOCIETES != null);
		System.assert(objSOCIETES.ROLE == null);
		System.assert(objSOCIETES.RAISON_SOCIALE == null);
		System.assert(objSOCIETES.SIRET == null);
		System.assert(objSOCIETES.SIREN == null);
		System.assert(objSOCIETES.IDENTIFIANT_SOCIETE_EXPLORE == null);
		System.assert(objSOCIETES.ADRESSE_1 == null);
		System.assert(objSOCIETES.ADRESSE_2 == null);
		System.assert(objSOCIETES.CODE_POSTAL == null);
		System.assert(objSOCIETES.VILLE == null);
		System.assert(objSOCIETES.CODE_NAF == null);
		System.assert(objSOCIETES.NATURE_ETS == null);
		System.assert(objSOCIETES.TELEPHONE == null);
		System.assert(objSOCIETES.TEFEN == null);
		System.assert(objSOCIETES.TEFEN_LIB == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Explore_MaitreOuvrage.MARCHE_PUBLIC objMARCHE_PUBLIC = new Explore_MaitreOuvrage.MARCHE_PUBLIC(System.JSON.createParser(json));
		System.assert(objMARCHE_PUBLIC != null);
		System.assert(objMARCHE_PUBLIC.IDENTIFIANT == null);
		System.assert(objMARCHE_PUBLIC.IDENTIFIANT_EXPLORE == null);
		System.assert(objMARCHE_PUBLIC.CLE_MARCHE_PUBLIC_EXPLORE == null);
		System.assert(objMARCHE_PUBLIC.OBJET == null);
		System.assert(objMARCHE_PUBLIC.DATE_LIMITE_RECEPTION == null);
		System.assert(objMARCHE_PUBLIC.DATE_DETECTION == null);
		System.assert(objMARCHE_PUBLIC.DATE_PARUTION == null);
		System.assert(objMARCHE_PUBLIC.SOURCE == null);
		System.assert(objMARCHE_PUBLIC.SOURCE_LIB == null);
		System.assert(objMARCHE_PUBLIC.TYPE_AVIS == null);
		System.assert(objMARCHE_PUBLIC.MPC_NATURE_CONTRAT == null);
		System.assert(objMARCHE_PUBLIC.MPC_NATURE_CONTRAT_LIB == null);
		System.assert(objMARCHE_PUBLIC.MPC_ALLOTISSEMENT == null);
		System.assert(objMARCHE_PUBLIC.MPC_MONTANT_REEL == null);
		System.assert(objMARCHE_PUBLIC.MPC_MONTANT_MIN == null);
		System.assert(objMARCHE_PUBLIC.MPC_MONTANT_MAX == null);
		System.assert(objMARCHE_PUBLIC.MPC_RENOUVELLEMENT == null);
		System.assert(objMARCHE_PUBLIC.MPC_DUREE == null);
		System.assert(objMARCHE_PUBLIC.MPC_DT_ECHEANCE == null);
		System.assert(objMARCHE_PUBLIC.MPC_DT_LIM_CANDIDAT == null);
		System.assert(objMARCHE_PUBLIC.MPC_DT_LIM_DEM_DOC == null);
		System.assert(objMARCHE_PUBLIC.MSG_CR == null);
		System.assert(objMARCHE_PUBLIC.MSG_CR_LIB == null);
		System.assert(objMARCHE_PUBLIC.URL_DETAIL == null);
		System.assert(objMARCHE_PUBLIC.URL_AVIS_ORIGINAL == null);
		System.assert(objMARCHE_PUBLIC.TEXTE_ANNONCE == null);
		System.assert(objMARCHE_PUBLIC.MPC_MISSION == null);
		System.assert(objMARCHE_PUBLIC.MPC_PROCEDURE == null);
		System.assert(objMARCHE_PUBLIC.MPC_FORME_MARCHE == null);
		System.assert(objMARCHE_PUBLIC.MPC_TYPE_PRESTATION == null);
		System.assert(objMARCHE_PUBLIC.MPC_TYPE_CONTRAT == null);
		System.assert(objMARCHE_PUBLIC.SOCIETES == null);
		System.assert(objMARCHE_PUBLIC.LOCALISATIONS == null);
		System.assert(objMARCHE_PUBLIC.DCES == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Explore_MaitreOuvrage.MPC_PROCEDURE objMPC_PROCEDURE = new Explore_MaitreOuvrage.MPC_PROCEDURE(System.JSON.createParser(json));
		System.assert(objMPC_PROCEDURE != null);
		System.assert(objMPC_PROCEDURE.MPC_PROCEDURE == null);
		System.assert(objMPC_PROCEDURE.MPC_PROCEDURE_LIB == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Explore_MaitreOuvrage.MPC_TYPE_CONTRAT objMPC_TYPE_CONTRAT = new Explore_MaitreOuvrage.MPC_TYPE_CONTRAT(System.JSON.createParser(json));
		System.assert(objMPC_TYPE_CONTRAT != null);
		System.assert(objMPC_TYPE_CONTRAT.MPC_TYPE_CONTRAT == null);
		System.assert(objMPC_TYPE_CONTRAT.MPC_TYPE_CONTRAT_LIB == null);
	}
}