/*
----------------------------------------------------------------------
-- - Name          : AP06Relation
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Methods for SObject Relation__c
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 01-JUL-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
public with sharing class AP06Relation {
	public static void setUser(List<Relation__c> listRelation){
		for(Relation__c r : listRelation){
			r.Utilisateur__c = UserInfo.getUserId();
		}
	}
	public static Boolean canCreate(Relation__c relation){
		List<Relation__c> listRelation =  DAL.getRelationByUserAndContact(relation.Utilisateur__c, relation.Contact__c);
		if(listRelation.size()>0) return false;
		return true;
	}
}