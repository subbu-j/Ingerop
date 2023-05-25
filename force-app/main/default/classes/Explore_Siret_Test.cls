@IsTest
public class Explore_Siret_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"NOTICE80\": {'+
		'        \"SIRET\": \"52504601700030\",'+
		'        \"SIREN\": \"525046017\",'+
		'        \"NIC\": \"00030\",'+
		'        \"L1_NOMEN\": \"SOCIETE DU GRAND PARIS\",'+
		'        \"L2_COMP\": \"\",'+
		'        \"L3_CADR\": \"IMMEUBLE LE CEZANNE\",'+
		'        \"L4_VOIE\": \"30 AVENUE DES FRUITIERS\",'+
		'        \"L5_DISP\": \"CS 10011 ST DENIS\",'+
		'        \"L6_POST\": \"93212 LA PLAINE ST DENIS CEDEX\",'+
		'        \"L7_ETRG\": \"FRANCE\",'+
		'        \"RPET\": \"11\",'+
		'        \"DEPET\": \"93\",'+
		'        \"ARRONET\": \"3\",'+
		'        \"CTONET\": \"99\",'+
		'        \"COMET\": \"066\",'+
		'        \"LIBCOM\": \"SAINT DENIS\",'+
		'        \"DU\": \"00\",'+
		'        \"TU\": \"8\",'+
		'        \"UU\": \"51\",'+
		'        \"EPCI\": \"200054781\",'+
		'        \"TCD\": \"61\",'+
		'        \"ZEMET\": \"11\",'+
		'        \"CODEVOIE\": \"\",'+
		'        \"NUMVOIE\": \"30\",'+
		'        \"INDREP\": \"\",'+
		'        \"TYPVOIE\": \"AV\",'+
		'        \"LIBVOIE\": \"DES FRUITIERS\",'+
		'        \"CODPOS\": \"93210\",'+
		'        \"CEDEX\": \"\",'+
		'        \"ZR1\": \"\",'+
		'        \"SIEGE\": \"1\",'+
		'        \"ENSEIGNE\": \"\",'+
		'        \"NOMCOM\": \"\",'+
		'        \"NATETAB\": \"\",'+
		'        \"LIBNATETAB\": \"\",'+
		'        \"APET700\": \"8413Z\",'+
		'        \"LIBAPET\": \"Administration publique (tutelle) des activités économiques\",'+
		'        \"DAPET\": \"2011\",'+
		'        \"TEFET\": \"31\",'+
		'        \"EFETCENT\": \"200\",'+
		'        \"DEFET\": \"2016\",'+
		'        \"ORIGINE\": \"1\",'+
		'        \"DCRET\": \"201111\",'+
		'        \"AMINTRET\": \"201209\",'+
		'        \"ACTIVNAT\": \"\",'+
		'        \"LIEUACT\": \"\",'+
		'        \"ACTISURF\": \"\",'+
		'        \"SAISONAT\": \"P\",'+
		'        \"MODET\": \"S\",'+
		'        \"PRODET\": \"O\",'+
		'        \"PRODPART\": \"\",'+
		'        \"AUXILT\": \"0\",'+
		'        \"ZR2\": \"\",'+
		'        \"NOMEN_LONG\": \"SOCIETE DU GRAND PARIS\",'+
		'        \"SIGLE\": \"SGP\",'+
		'        \"CIVILITE\": \"\",'+
		'        \"NJ\": \"4110\",'+
		'        \"LIBNJ\": \"Établissement public national à caractère industriel ou commercial doté d\'un comptable public \",'+
		'        \"APEN700\": \"8413Z\",'+
		'        \"LIBAPEN\": \"Administration publique (tutelle) des activités économiques\",'+
		'        \"DAPEN\": \"2010\",'+
		'        \"APRM\": \"\",'+
		'        \"TEFEN\": \"31\",'+
		'        \"EFENCENT\": \"200\",'+
		'        \"DEFEN\": \"2016\",'+
		'        \"CATEGORIE\": \"PME\",'+
		'        \"DCREN\": \"201007\",'+
		'        \"AMINTREN\": \"201209\",'+
		'        \"MONOACT\": \"1\",'+
		'        \"MODEN\": \"S\",'+
		'        \"PRODEN\": \"O\",'+
		'        \"ESAANN\": \"\",'+
		'        \"TCA\": \"\",'+
		'        \"ESAAPEN\": \"\",'+
		'        \"ESASEC1N\": \"\",'+
		'        \"ESASEC2N\": \"\",'+
		'        \"ESASEC3N\": \"\",'+
		'        \"ESASEC4N\": \"\",'+
		'        \"REGIMP\": \"11\",'+
		'        \"MONOREG\": \"1\",'+
		'        \"ZR3\": \"\",'+
		'        \"RPEN\": \"11\",'+
		'        \"DEPCOMEN\": \"93066\",'+
		'        \"VMAJ\": \"\",'+
		'        \"VMAJ1\": \"\",'+
		'        \"VMAJ2\": \"\",'+
		'        \"VMAJ3\": \"\",'+
		'        \"INDPUBLIPO\": \"1\"'+
		'    },'+
		'    \"COMPLEMENTS\": {'+
		'        \"TELEPHONE\": \"0182462000\",'+
		'        \"SITE_WEB\": \"www.societedugrandparis.fr\",'+
		'        \"LATITUDE\": 48.919329,'+
		'        \"LONGITUDE\": 2.354677'+
		'    }'+
		'}';
		Explore_Siret r = Explore_Siret.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Explore_Siret.COMPLEMENTS objCOMPLEMENTS = new Explore_Siret.COMPLEMENTS(System.JSON.createParser(json));
		System.assert(objCOMPLEMENTS != null);
		System.assert(objCOMPLEMENTS.TELEPHONE == null);
		System.assert(objCOMPLEMENTS.SITE_WEB == null);
		System.assert(objCOMPLEMENTS.LATITUDE == null);
		System.assert(objCOMPLEMENTS.LONGITUDE == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Explore_Siret.NOTICE80 objNOTICE80 = new Explore_Siret.NOTICE80(System.JSON.createParser(json));
		System.assert(objNOTICE80 != null);
		System.assert(objNOTICE80.SIRET == null);
		System.assert(objNOTICE80.SIREN == null);
		System.assert(objNOTICE80.NIC == null);
		System.assert(objNOTICE80.L1_NOMEN == null);
		System.assert(objNOTICE80.L2_COMP == null);
		System.assert(objNOTICE80.L3_CADR == null);
		System.assert(objNOTICE80.L4_VOIE == null);
		System.assert(objNOTICE80.L5_DISP == null);
		System.assert(objNOTICE80.L6_POST == null);
		System.assert(objNOTICE80.L7_ETRG == null);
		System.assert(objNOTICE80.RPET == null);
		System.assert(objNOTICE80.DEPET == null);
		System.assert(objNOTICE80.ARRONET == null);
		System.assert(objNOTICE80.CTONET == null);
		System.assert(objNOTICE80.COMET == null);
		System.assert(objNOTICE80.LIBCOM == null);
		System.assert(objNOTICE80.DU == null);
		System.assert(objNOTICE80.TU == null);
		System.assert(objNOTICE80.UU == null);
		System.assert(objNOTICE80.EPCI == null);
		System.assert(objNOTICE80.TCD == null);
		System.assert(objNOTICE80.ZEMET == null);
		System.assert(objNOTICE80.CODEVOIE == null);
		System.assert(objNOTICE80.NUMVOIE == null);
		System.assert(objNOTICE80.INDREP == null);
		System.assert(objNOTICE80.TYPVOIE == null);
		System.assert(objNOTICE80.LIBVOIE == null);
		System.assert(objNOTICE80.CODPOS == null);
		System.assert(objNOTICE80.CEDEX == null);
		System.assert(objNOTICE80.ZR1 == null);
		System.assert(objNOTICE80.SIEGE == null);
		System.assert(objNOTICE80.ENSEIGNE == null);
		System.assert(objNOTICE80.NOMCOM == null);
		System.assert(objNOTICE80.NATETAB == null);
		System.assert(objNOTICE80.LIBNATETAB == null);
		System.assert(objNOTICE80.APET700 == null);
		System.assert(objNOTICE80.LIBAPET == null);
		System.assert(objNOTICE80.DAPET == null);
		System.assert(objNOTICE80.TEFET == null);
		System.assert(objNOTICE80.EFETCENT == null);
		System.assert(objNOTICE80.DEFET == null);
		System.assert(objNOTICE80.ORIGINE == null);
		System.assert(objNOTICE80.DCRET == null);
		System.assert(objNOTICE80.AMINTRET == null);
		System.assert(objNOTICE80.ACTIVNAT == null);
		System.assert(objNOTICE80.LIEUACT == null);
		System.assert(objNOTICE80.ACTISURF == null);
		System.assert(objNOTICE80.SAISONAT == null);
		System.assert(objNOTICE80.MODET == null);
		System.assert(objNOTICE80.PRODET == null);
		System.assert(objNOTICE80.PRODPART == null);
		System.assert(objNOTICE80.AUXILT == null);
		System.assert(objNOTICE80.ZR2 == null);
		System.assert(objNOTICE80.NOMEN_LONG == null);
		System.assert(objNOTICE80.SIGLE == null);
		System.assert(objNOTICE80.CIVILITE == null);
		System.assert(objNOTICE80.NJ == null);
		System.assert(objNOTICE80.LIBNJ == null);
		System.assert(objNOTICE80.APEN700 == null);
		System.assert(objNOTICE80.LIBAPEN == null);
		System.assert(objNOTICE80.DAPEN == null);
		System.assert(objNOTICE80.APRM == null);
		System.assert(objNOTICE80.TEFEN == null);
		System.assert(objNOTICE80.EFENCENT == null);
		System.assert(objNOTICE80.DEFEN == null);
		System.assert(objNOTICE80.CATEGORIE == null);
		System.assert(objNOTICE80.DCREN == null);
		System.assert(objNOTICE80.AMINTREN == null);
		System.assert(objNOTICE80.MONOACT == null);
		System.assert(objNOTICE80.MODEN == null);
		System.assert(objNOTICE80.PRODEN == null);
		System.assert(objNOTICE80.ESAANN == null);
		System.assert(objNOTICE80.TCA == null);
		System.assert(objNOTICE80.ESAAPEN == null);
		System.assert(objNOTICE80.ESASEC1N == null);
		System.assert(objNOTICE80.ESASEC2N == null);
		System.assert(objNOTICE80.ESASEC3N == null);
		System.assert(objNOTICE80.ESASEC4N == null);
		System.assert(objNOTICE80.REGIMP == null);
		System.assert(objNOTICE80.MONOREG == null);
		System.assert(objNOTICE80.ZR3 == null);
		System.assert(objNOTICE80.RPEN == null);
		System.assert(objNOTICE80.DEPCOMEN == null);
		System.assert(objNOTICE80.VMAJ == null);
		System.assert(objNOTICE80.VMAJ1 == null);
		System.assert(objNOTICE80.VMAJ2 == null);
		System.assert(objNOTICE80.VMAJ3 == null);
		System.assert(objNOTICE80.INDPUBLIPO == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Explore_Siret objExplore_Siret = new Explore_Siret(System.JSON.createParser(json));
		System.assert(objExplore_Siret != null);
		System.assert(objExplore_Siret.NOTICE80 == null);
		System.assert(objExplore_Siret.COMPLEMENTS == null);
	}
}