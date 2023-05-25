/*
----------------------------------------------------------------------
-- - Name          : AP05Score
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Methods for SObject Score__c
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 01-JUL-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
public without sharing class AP05Score {
	public static void majScorePartenaire(List<Score__c> listScore){
		Set<Id> partenaireIds = new Set<Id>();
		for(Score__c score : listScore){
			partenaireIds.add(score.Compte__c);
		}
		List<Score__c> listScorePartenaire = DAL.getNoteByAccountIds(partenaireIds);
		List<Account> listPartenaire = DAL.getAccountByIds(partenaireIds);
		for(Account partenaire : listPartenaire){
			List<Score__c> tempListScore = new List<Score__c>();
			partenaire.Moyenne_des_scores__c = 0;
			for(Score__c score : listScorePartenaire){
				if(score.Compte__c == partenaire.Id){
					tempListScore.add(score);
				}
			}
			if(tempListScore.size()>0){
				Decimal totalScore = 0;
				Integer nbScore = 0;
				for(Score__c score : tempListScore){
					totalScore += score.Note_attribuee__c;
					nbScore++;
				}
				if(nbScore>0){
					Decimal noteMoyenne = totalScore / nbScore;	
					partenaire.Moyenne_des_scores__c = noteMoyenne;				
				}
			}
		}
		update listPartenaire;
	}
}