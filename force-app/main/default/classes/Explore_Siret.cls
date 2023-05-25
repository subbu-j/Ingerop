public class Explore_Siret {

	public class COMPLEMENTS {
		public String TELEPHONE {get;set;} 
		public String SITE_WEB {get;set;} 
		public Double LATITUDE {get;set;} 
		public Double LONGITUDE {get;set;} 

		public COMPLEMENTS(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'TELEPHONE') {
							TELEPHONE = parser.getText();
						} else if (text == 'SITE_WEB') {
							SITE_WEB = parser.getText();
						} else if (text == 'LATITUDE') {
							LATITUDE = parser.getDoubleValue();
						} else if (text == 'LONGITUDE') {
							LONGITUDE = parser.getDoubleValue();
						} else {
							System.debug(LoggingLevel.WARN, 'COMPLEMENTS consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class NOTICE80 {
		public String SIRET {get;set;} 
		public String SIREN {get;set;} 
		public String NIC {get;set;} 
		public String L1_NOMEN {get;set;} 
		public String L2_COMP {get;set;} 
		public String L3_CADR {get;set;} 
		public String L4_VOIE {get;set;} 
		public String L5_DISP {get;set;} 
		public String L6_POST {get;set;} 
		public String L7_ETRG {get;set;} 
		public String RPET {get;set;} 
		public String DEPET {get;set;} 
		public String ARRONET {get;set;} 
		public String CTONET {get;set;} 
		public String COMET {get;set;} 
		public String LIBCOM {get;set;} 
		public String DU {get;set;} 
		public String TU {get;set;} 
		public String UU {get;set;} 
		public String EPCI {get;set;} 
		public String TCD {get;set;} 
		public String ZEMET {get;set;} 
		public String CODEVOIE {get;set;} 
		public String NUMVOIE {get;set;} 
		public String INDREP {get;set;} 
		public String TYPVOIE {get;set;} 
		public String LIBVOIE {get;set;} 
		public String CODPOS {get;set;} 
		public String CEDEX {get;set;} 
		public String ZR1 {get;set;} 
		public String SIEGE {get;set;} 
		public String ENSEIGNE {get;set;} 
		public String NOMCOM {get;set;} 
		public String NATETAB {get;set;} 
		public String LIBNATETAB {get;set;} 
		public String APET700 {get;set;} 
		public String LIBAPET {get;set;} 
		public String DAPET {get;set;} 
		public String TEFET {get;set;} 
		public String EFETCENT {get;set;} 
		public String DEFET {get;set;} 
		public String ORIGINE {get;set;} 
		public String DCRET {get;set;} 
		public String AMINTRET {get;set;} 
		public String ACTIVNAT {get;set;} 
		public String LIEUACT {get;set;} 
		public String ACTISURF {get;set;} 
		public String SAISONAT {get;set;} 
		public String MODET {get;set;} 
		public String PRODET {get;set;} 
		public String PRODPART {get;set;} 
		public String AUXILT {get;set;} 
		public String ZR2 {get;set;} 
		public String NOMEN_LONG {get;set;} 
		public String SIGLE {get;set;} 
		public String CIVILITE {get;set;} 
		public String NJ {get;set;} 
		public String LIBNJ {get;set;} 
		public String APEN700 {get;set;} 
		public String LIBAPEN {get;set;} 
		public String DAPEN {get;set;} 
		public String APRM {get;set;} 
		public String TEFEN {get;set;} 
		public String EFENCENT {get;set;} 
		public String DEFEN {get;set;} 
		public String CATEGORIE {get;set;} 
		public String DCREN {get;set;} 
		public String AMINTREN {get;set;} 
		public String MONOACT {get;set;} 
		public String MODEN {get;set;} 
		public String PRODEN {get;set;} 
		public String ESAANN {get;set;} 
		public String TCA {get;set;} 
		public String ESAAPEN {get;set;} 
		public String ESASEC1N {get;set;} 
		public String ESASEC2N {get;set;} 
		public String ESASEC3N {get;set;} 
		public String ESASEC4N {get;set;} 
		public String REGIMP {get;set;} 
		public String MONOREG {get;set;} 
		public String ZR3 {get;set;} 
		public String RPEN {get;set;} 
		public String DEPCOMEN {get;set;} 
		public String VMAJ {get;set;} 
		public String VMAJ1 {get;set;} 
		public String VMAJ2 {get;set;} 
		public String VMAJ3 {get;set;} 
		public String INDPUBLIPO {get;set;} 

		public NOTICE80(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'SIRET') {
							SIRET = parser.getText();
						} else if (text == 'SIREN') {
							SIREN = parser.getText();
						} else if (text == 'NIC') {
							NIC = parser.getText();
						} else if (text == 'L1_NOMEN') {
							L1_NOMEN = parser.getText();
						} else if (text == 'L2_COMP') {
							L2_COMP = parser.getText();
						} else if (text == 'L3_CADR') {
							L3_CADR = parser.getText();
						} else if (text == 'L4_VOIE') {
							L4_VOIE = parser.getText();
						} else if (text == 'L5_DISP') {
							L5_DISP = parser.getText();
						} else if (text == 'L6_POST') {
							L6_POST = parser.getText();
						} else if (text == 'L7_ETRG') {
							L7_ETRG = parser.getText();
						} else if (text == 'RPET') {
							RPET = parser.getText();
						} else if (text == 'DEPET') {
							DEPET = parser.getText();
						} else if (text == 'ARRONET') {
							ARRONET = parser.getText();
						} else if (text == 'CTONET') {
							CTONET = parser.getText();
						} else if (text == 'COMET') {
							COMET = parser.getText();
						} else if (text == 'LIBCOM') {
							LIBCOM = parser.getText();
						} else if (text == 'DU') {
							DU = parser.getText();
						} else if (text == 'TU') {
							TU = parser.getText();
						} else if (text == 'UU') {
							UU = parser.getText();
						} else if (text == 'EPCI') {
							EPCI = parser.getText();
						} else if (text == 'TCD') {
							TCD = parser.getText();
						} else if (text == 'ZEMET') {
							ZEMET = parser.getText();
						} else if (text == 'CODEVOIE') {
							CODEVOIE = parser.getText();
						} else if (text == 'NUMVOIE') {
							NUMVOIE = parser.getText();
						} else if (text == 'INDREP') {
							INDREP = parser.getText();
						} else if (text == 'TYPVOIE') {
							TYPVOIE = parser.getText();
						} else if (text == 'LIBVOIE') {
							LIBVOIE = parser.getText();
						} else if (text == 'CODPOS') {
							CODPOS = parser.getText();
						} else if (text == 'CEDEX') {
							CEDEX = parser.getText();
						} else if (text == 'ZR1') {
							ZR1 = parser.getText();
						} else if (text == 'SIEGE') {
							SIEGE = parser.getText();
						} else if (text == 'ENSEIGNE') {
							ENSEIGNE = parser.getText();
						} else if (text == 'NOMCOM') {
							NOMCOM = parser.getText();
						} else if (text == 'NATETAB') {
							NATETAB = parser.getText();
						} else if (text == 'LIBNATETAB') {
							LIBNATETAB = parser.getText();
						} else if (text == 'APET700') {
							APET700 = parser.getText();
						} else if (text == 'LIBAPET') {
							LIBAPET = parser.getText();
						} else if (text == 'DAPET') {
							DAPET = parser.getText();
						} else if (text == 'TEFET') {
							TEFET = parser.getText();
						} else if (text == 'EFETCENT') {
							EFETCENT = parser.getText();
						} else if (text == 'DEFET') {
							DEFET = parser.getText();
						} else if (text == 'ORIGINE') {
							ORIGINE = parser.getText();
						} else if (text == 'DCRET') {
							DCRET = parser.getText();
						} else if (text == 'AMINTRET') {
							AMINTRET = parser.getText();
						} else if (text == 'ACTIVNAT') {
							ACTIVNAT = parser.getText();
						} else if (text == 'LIEUACT') {
							LIEUACT = parser.getText();
						} else if (text == 'ACTISURF') {
							ACTISURF = parser.getText();
						} else if (text == 'SAISONAT') {
							SAISONAT = parser.getText();
						} else if (text == 'MODET') {
							MODET = parser.getText();
						} else if (text == 'PRODET') {
							PRODET = parser.getText();
						} else if (text == 'PRODPART') {
							PRODPART = parser.getText();
						} else if (text == 'AUXILT') {
							AUXILT = parser.getText();
						} else if (text == 'ZR2') {
							ZR2 = parser.getText();
						} else if (text == 'NOMEN_LONG') {
							NOMEN_LONG = parser.getText();
						} else if (text == 'SIGLE') {
							SIGLE = parser.getText();
						} else if (text == 'CIVILITE') {
							CIVILITE = parser.getText();
						} else if (text == 'NJ') {
							NJ = parser.getText();
						} else if (text == 'LIBNJ') {
							LIBNJ = parser.getText();
						} else if (text == 'APEN700') {
							APEN700 = parser.getText();
						} else if (text == 'LIBAPEN') {
							LIBAPEN = parser.getText();
						} else if (text == 'DAPEN') {
							DAPEN = parser.getText();
						} else if (text == 'APRM') {
							APRM = parser.getText();
						} else if (text == 'TEFEN') {
							TEFEN = parser.getText();
						} else if (text == 'EFENCENT') {
							EFENCENT = parser.getText();
						} else if (text == 'DEFEN') {
							DEFEN = parser.getText();
						} else if (text == 'CATEGORIE') {
							CATEGORIE = parser.getText();
						} else if (text == 'DCREN') {
							DCREN = parser.getText();
						} else if (text == 'AMINTREN') {
							AMINTREN = parser.getText();
						} else if (text == 'MONOACT') {
							MONOACT = parser.getText();
						} else if (text == 'MODEN') {
							MODEN = parser.getText();
						} else if (text == 'PRODEN') {
							PRODEN = parser.getText();
						} else if (text == 'ESAANN') {
							ESAANN = parser.getText();
						} else if (text == 'TCA') {
							TCA = parser.getText();
						} else if (text == 'ESAAPEN') {
							ESAAPEN = parser.getText();
						} else if (text == 'ESASEC1N') {
							ESASEC1N = parser.getText();
						} else if (text == 'ESASEC2N') {
							ESASEC2N = parser.getText();
						} else if (text == 'ESASEC3N') {
							ESASEC3N = parser.getText();
						} else if (text == 'ESASEC4N') {
							ESASEC4N = parser.getText();
						} else if (text == 'REGIMP') {
							REGIMP = parser.getText();
						} else if (text == 'MONOREG') {
							MONOREG = parser.getText();
						} else if (text == 'ZR3') {
							ZR3 = parser.getText();
						} else if (text == 'RPEN') {
							RPEN = parser.getText();
						} else if (text == 'DEPCOMEN') {
							DEPCOMEN = parser.getText();
						} else if (text == 'VMAJ') {
							VMAJ = parser.getText();
						} else if (text == 'VMAJ1') {
							VMAJ1 = parser.getText();
						} else if (text == 'VMAJ2') {
							VMAJ2 = parser.getText();
						} else if (text == 'VMAJ3') {
							VMAJ3 = parser.getText();
						} else if (text == 'INDPUBLIPO') {
							INDPUBLIPO = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'NOTICE80 consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public NOTICE80 NOTICE80 {get;set;} 
	public COMPLEMENTS COMPLEMENTS {get;set;} 

	public Explore_Siret(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'NOTICE80') {
						NOTICE80 = new NOTICE80(parser);
					} else if (text == 'COMPLEMENTS') {
						COMPLEMENTS = new COMPLEMENTS(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'Explore_Siret consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static Explore_Siret parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new Explore_Siret(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	





}