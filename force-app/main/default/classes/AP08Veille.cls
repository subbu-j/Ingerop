/*
----------------------------------------------------------------------
-- - Name          : AP08Veille
-- - Author        : Mélanie TEXEREAU - Bluetis
-- - Description   : Class for trigger Veille
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 02-NOV-2016   MTE    1.0      Initial version
----------------------------------------------------------------------
*/
public class AP08Veille {
	
	public static void noDuplicateVeille(list<Veille__c> listVeille){
		
		map<Id, list<Veille__c>> mapVeilleByAnnonce = new map<Id, list<Veille__c>>();
		set<Id> setAnnonceId = new set<Id>(); 
		
		for(Veille__c v : listVeille){
			setAnnonceId.add(v.Annonce__c);
		}
		mapVeilleByAnnonce = DAL.getVeilleByAnnonceId(setAnnonceId);
		
		for(Veille__c vInsert : listVeille){
			if(mapVeilleByAnnonce.containsKey(vInsert.Annonce__c)){
				if(!mapVeilleByAnnonce.get(vInsert.Annonce__c).isEmpty()){
					for(Veille__c vExist : mapVeilleByAnnonce.get(vInsert.Annonce__c)){
						if(vExist.Destinataire__c == vInsert.Destinataire__c){
							vInsert.addError(Label.NoDuplicateVeille);
						}
					}
				}
			}
		}
	}

}