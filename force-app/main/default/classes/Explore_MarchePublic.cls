public class Explore_MarchePublic {

	public class MPC_FORME_MARCHE {
		public String MPC_FORME_MARCHE {get;set;} 
		public String MPC_FORME_MARCHE_LIB {get;set;} 

		public MPC_FORME_MARCHE(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'MPC_FORME_MARCHE') {
							MPC_FORME_MARCHE = parser.getText();
						} else if (text == 'MPC_FORME_MARCHE_LIB') {
							MPC_FORME_MARCHE_LIB = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'MPC_FORME_MARCHE consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class MPC_MISSION {
		public String MPC_MISSION {get;set;} 
		public String MPC_MISSION_LIB {get;set;} 

		public MPC_MISSION(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'MPC_MISSION') {
							MPC_MISSION = parser.getText();
						} else if (text == 'MPC_MISSION_LIB') {
							MPC_MISSION_LIB = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'MPC_MISSION consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class LOCALISATIONS {
		public String DEPARTEMENT {get;set;} 
		public String DEPARTEMENT_LIB {get;set;} 
		public String CODE_COMMUNE {get;set;} 
		public String ADRESSE1 {get;set;} 
		public String ADRESSE2 {get;set;} 
		public String CODE_POSTAL {get;set;} 
		public String COMMUNE {get;set;} 

		public LOCALISATIONS(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'DEPARTEMENT') {
							DEPARTEMENT = parser.getText();
						} else if (text == 'DEPARTEMENT_LIB') {
							DEPARTEMENT_LIB = parser.getText();
						} else if (text == 'CODE_COMMUNE') {
							CODE_COMMUNE = parser.getText();
						} else if (text == 'ADRESSE1') {
							ADRESSE1 = parser.getText();
						} else if (text == 'ADRESSE2') {
							ADRESSE2 = parser.getText();
						} else if (text == 'CODE_POSTAL') {
							CODE_POSTAL = parser.getText();
						} else if (text == 'COMMUNE') {
							COMMUNE = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'LOCALISATIONS consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class DCES {

		public DCES(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'DCES consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class MPC_TYPE_PRESTATION {
		public String MPC_TYPE_PRESTATION {get;set;} 
		public String MPC_TYPE_PRESTATION_LIB {get;set;} 

		public MPC_TYPE_PRESTATION(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'MPC_TYPE_PRESTATION') {
							MPC_TYPE_PRESTATION = parser.getText();
						} else if (text == 'MPC_TYPE_PRESTATION_LIB') {
							MPC_TYPE_PRESTATION_LIB = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'MPC_TYPE_PRESTATION consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class SOCIETES {
		public String ROLE {get;set;} 
		public String RAISON_SOCIALE {get;set;} 
		public String SIRET {get;set;} 
		public String SIREN {get;set;} 
		public Integer IDENTIFIANT_SOCIETE_EXPLORE {get;set;} 
		public String ADRESSE_1 {get;set;} 
		public String ADRESSE_2 {get;set;} 
		public String CODE_POSTAL {get;set;} 
		public String VILLE {get;set;} 
		public String CODE_NAF {get;set;} 
		public String NATURE_ETS {get;set;} 
		public String TELEPHONE {get;set;} 
		public String TEFEN {get;set;} 
		public String TEFEN_LIB {get;set;} 

		public SOCIETES(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ROLE') {
							ROLE = parser.getText();
						} else if (text == 'RAISON_SOCIALE') {
							RAISON_SOCIALE = parser.getText();
						} else if (text == 'SIRET') {
							SIRET = parser.getText();
						} else if (text == 'SIREN') {
							SIREN = parser.getText();
						} else if (text == 'IDENTIFIANT_SOCIETE_EXPLORE') {
							IDENTIFIANT_SOCIETE_EXPLORE = parser.getIntegerValue();
						} else if (text == 'ADRESSE_1') {
							ADRESSE_1 = parser.getText();
						} else if (text == 'ADRESSE_2') {
							ADRESSE_2 = parser.getText();
						} else if (text == 'CODE_POSTAL') {
							CODE_POSTAL = parser.getText();
						} else if (text == 'VILLE') {
							VILLE = parser.getText();
						} else if (text == 'CODE_NAF') {
							CODE_NAF = parser.getText();
						} else if (text == 'NATURE_ETS') {
							NATURE_ETS = parser.getText();
						} else if (text == 'TELEPHONE') {
							TELEPHONE = parser.getText();
						} else if (text == 'TEFEN') {
							TEFEN = parser.getText();
						} else if (text == 'TEFEN_LIB') {
							TEFEN_LIB = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'SOCIETES consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class MARCHE_PUBLIC {
		public Integer IDENTIFIANT {get;set;} 
		public String IDENTIFIANT_EXPLORE {get;set;} 
		public String CLE_MARCHE_PUBLIC_EXPLORE {get;set;} 
		public String OBJET {get;set;} 
		public String DATE_LIMITE_RECEPTION {get;set;} 
		public String DATE_DETECTION {get;set;} 
		public String DATE_PARUTION {get;set;} 
		public Integer SOURCE {get;set;} 
		public String SOURCE_LIB {get;set;} 
		public String TYPE_AVIS {get;set;} 
		public String MPC_NATURE_CONTRAT {get;set;} 
		public String MPC_NATURE_CONTRAT_LIB {get;set;} 
		public Boolean MPC_ALLOTISSEMENT {get;set;} 
		public Integer MPC_MONTANT_REEL {get;set;} 
		public Integer MPC_MONTANT_MIN {get;set;} 
		public Integer MPC_MONTANT_MAX {get;set;} 
		public Boolean MPC_RENOUVELLEMENT {get;set;} 
		public Integer MPC_DUREE {get;set;} 
		public String MPC_DT_ECHEANCE {get;set;} 
		public String MPC_DT_LIM_CANDIDAT {get;set;} 
		public String MPC_DT_LIM_DEM_DOC {get;set;} 
		public String MSG_CR {get;set;} 
		public String MSG_CR_LIB {get;set;} 
		public String URL_DETAIL {get;set;} 
		public String URL_AVIS_ORIGINAL {get;set;} 
		public String TEXTE_ANNONCE {get;set;} 
		public List<MPC_MISSION> MPC_MISSION {get;set;} 
		public List<MPC_PROCEDURE> MPC_PROCEDURE {get;set;} 
		public List<MPC_FORME_MARCHE> MPC_FORME_MARCHE {get;set;} 
		public List<MPC_TYPE_PRESTATION> MPC_TYPE_PRESTATION {get;set;} 
		public List<MPC_TYPE_CONTRAT> MPC_TYPE_CONTRAT {get;set;} 
		public List<SOCIETES> SOCIETES {get;set;} 
		public List<LOCALISATIONS> LOCALISATIONS {get;set;} 
		public List<DCES> DCES {get;set;} 

		public MARCHE_PUBLIC(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'IDENTIFIANT') {
							IDENTIFIANT = parser.getIntegerValue();
						} else if (text == 'IDENTIFIANT_EXPLORE') {
							IDENTIFIANT_EXPLORE = parser.getText();
						} else if (text == 'CLE_MARCHE_PUBLIC_EXPLORE') {
							CLE_MARCHE_PUBLIC_EXPLORE = parser.getText();
						} else if (text == 'OBJET') {
							OBJET = parser.getText();
						} else if (text == 'DATE_LIMITE_RECEPTION') {
							DATE_LIMITE_RECEPTION = parser.getText();
						} else if (text == 'DATE_DETECTION') {
							DATE_DETECTION = parser.getText();
						} else if (text == 'DATE_PARUTION') {
							DATE_PARUTION = parser.getText();
						} else if (text == 'SOURCE') {
							SOURCE = parser.getIntegerValue();
						} else if (text == 'SOURCE_LIB') {
							SOURCE_LIB = parser.getText();
						} else if (text == 'TYPE_AVIS') {
							TYPE_AVIS = parser.getText();
						} else if (text == 'MPC_NATURE_CONTRAT') {
							MPC_NATURE_CONTRAT = parser.getText();
						} else if (text == 'MPC_NATURE_CONTRAT_LIB') {
							MPC_NATURE_CONTRAT_LIB = parser.getText();
						} else if (text == 'MPC_ALLOTISSEMENT') {
							MPC_ALLOTISSEMENT = parser.getBooleanValue();
						} else if (text == 'MPC_MONTANT_REEL') {
							MPC_MONTANT_REEL = parser.getIntegerValue();
						} else if (text == 'MPC_MONTANT_MIN') {
							MPC_MONTANT_MIN = parser.getIntegerValue();
						} else if (text == 'MPC_MONTANT_MAX') {
							MPC_MONTANT_MAX = parser.getIntegerValue();
						} else if (text == 'MPC_RENOUVELLEMENT') {
							MPC_RENOUVELLEMENT = parser.getBooleanValue();
						} else if (text == 'MPC_DUREE') {
							MPC_DUREE = parser.getIntegerValue();
						} else if (text == 'MPC_DT_ECHEANCE') {
							MPC_DT_ECHEANCE = parser.getText();
						} else if (text == 'MPC_DT_LIM_CANDIDAT') {
							MPC_DT_LIM_CANDIDAT = parser.getText();
						} else if (text == 'MPC_DT_LIM_DEM_DOC') {
							MPC_DT_LIM_DEM_DOC = parser.getText();
						} else if (text == 'MSG_CR') {
							MSG_CR = parser.getText();
						} else if (text == 'MSG_CR_LIB') {
							MSG_CR_LIB = parser.getText();
						} else if (text == 'URL_DETAIL') {
							URL_DETAIL = parser.getText();
						} else if (text == 'URL_AVIS_ORIGINAL') {
							URL_AVIS_ORIGINAL = parser.getText();
						} else if (text == 'TEXTE_ANNONCE') {
							TEXTE_ANNONCE = parser.getText();
						} else if (text == 'MPC_MISSION') {
							MPC_MISSION = arrayOfMPC_MISSION(parser);
						} else if (text == 'MPC_PROCEDURE') {
							MPC_PROCEDURE = arrayOfMPC_PROCEDURE(parser);
						} else if (text == 'MPC_FORME_MARCHE') {
							MPC_FORME_MARCHE = arrayOfMPC_FORME_MARCHE(parser);
						} else if (text == 'MPC_TYPE_PRESTATION') {
							MPC_TYPE_PRESTATION = arrayOfMPC_TYPE_PRESTATION(parser);
						} else if (text == 'MPC_TYPE_CONTRAT') {
							MPC_TYPE_CONTRAT = arrayOfMPC_TYPE_CONTRAT(parser);
						} else if (text == 'SOCIETES') {
							SOCIETES = arrayOfSOCIETES(parser);
						} else if (text == 'LOCALISATIONS') {
							LOCALISATIONS = arrayOfLOCALISATIONS(parser);
						} else if (text == 'DCES') {
							DCES = arrayOfDCES(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'MARCHE_PUBLIC consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public MARCHE_PUBLIC MARCHE_PUBLIC {get;set;} 

	public Explore_MarchePublic(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'MARCHE_PUBLIC') {
						MARCHE_PUBLIC = new MARCHE_PUBLIC(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'ExploreMarchePublic consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class MPC_PROCEDURE {
		public String MPC_PROCEDURE {get;set;} 
		public String MPC_PROCEDURE_LIB {get;set;} 

		public MPC_PROCEDURE(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'MPC_PROCEDURE') {
							MPC_PROCEDURE = parser.getText();
						} else if (text == 'MPC_PROCEDURE_LIB') {
							MPC_PROCEDURE_LIB = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'MPC_PROCEDURE consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class MPC_TYPE_CONTRAT {
		public String MPC_TYPE_CONTRAT {get;set;} 
		public String MPC_TYPE_CONTRAT_LIB {get;set;} 

		public MPC_TYPE_CONTRAT(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'MPC_TYPE_CONTRAT') {
							MPC_TYPE_CONTRAT = parser.getText();
						} else if (text == 'MPC_TYPE_CONTRAT_LIB') {
							MPC_TYPE_CONTRAT_LIB = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'MPC_TYPE_CONTRAT consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static Explore_MarchePublic parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new Explore_MarchePublic(parser);
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
	

    private static List<MPC_FORME_MARCHE> arrayOfMPC_FORME_MARCHE(System.JSONParser p) {
        List<MPC_FORME_MARCHE> res = new List<MPC_FORME_MARCHE>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new MPC_FORME_MARCHE(p));
        }
        return res;
    }




    private static List<MPC_PROCEDURE> arrayOfMPC_PROCEDURE(System.JSONParser p) {
        List<MPC_PROCEDURE> res = new List<MPC_PROCEDURE>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new MPC_PROCEDURE(p));
        }
        return res;
    }





    private static List<SOCIETES> arrayOfSOCIETES(System.JSONParser p) {
        List<SOCIETES> res = new List<SOCIETES>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SOCIETES(p));
        }
        return res;
    }


    private static List<DCES> arrayOfDCES(System.JSONParser p) {
        List<DCES> res = new List<DCES>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new DCES(p));
        }
        return res;
    }


    private static List<MPC_MISSION> arrayOfMPC_MISSION(System.JSONParser p) {
        List<MPC_MISSION> res = new List<MPC_MISSION>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new MPC_MISSION(p));
        }
        return res;
    }





    private static List<MPC_TYPE_PRESTATION> arrayOfMPC_TYPE_PRESTATION(System.JSONParser p) {
        List<MPC_TYPE_PRESTATION> res = new List<MPC_TYPE_PRESTATION>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new MPC_TYPE_PRESTATION(p));
        }
        return res;
    }




    private static List<MPC_TYPE_CONTRAT> arrayOfMPC_TYPE_CONTRAT(System.JSONParser p) {
        List<MPC_TYPE_CONTRAT> res = new List<MPC_TYPE_CONTRAT>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new MPC_TYPE_CONTRAT(p));
        }
        return res;
    }


    private static List<LOCALISATIONS> arrayOfLOCALISATIONS(System.JSONParser p) {
        List<LOCALISATIONS> res = new List<LOCALISATIONS>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new LOCALISATIONS(p));
        }
        return res;
    }




}