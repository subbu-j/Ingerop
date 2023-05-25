/*
----------------------------------------------------------------------
-- - Name          : VFC01NoterPartenaire
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Extension for VFP01NoterPartenaire
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 13-JUN-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
public with sharing class VFC01NoterPartenaire {
	public String accountId {get;set;}
	public String userId {get;set;}
	public Score__c note {get;set;}
	public Decimal noteActuelle {get;set;}
	public Boolean autorisation {get;set;}
    
    public VFC01NoterPartenaire(ApexPages.StandardController sc) {
        String idScore = ApexPages.currentPage().getParameters().get('id');
        accountId = ApexPages.currentPage().getParameters().get('idAccount');
        
		userId = UserInfo.getUserId();
        
        if(accountId != null) {
            note = DAL.getNoteByAccountAndUser(userId, accountId);
        }
        else if(idScore != null) {
            note = DAL.getNoteById(idScore);
            accountId = note.Compte__c;
        }
        else {
            throw new NoNoteException('Une erreur est survenue. Veuillez réessayer.');
        }
        autorisation = true;
		noteActuelle = (note == null) ? 0 : note.Note_attribuee__c;
        if(note == null){
			note = new Score__c(Id = null);
		}else{
			autorisation = note.Utilisateur__c == UserInfo.getUserId();
		}
    }

	public void donnerUneNote(){
		if(note.Id == null){
			Score__c newNote = new Score__c(Compte__c = accountId, Note_attribuee__c = noteActuelle, Utilisateur__c = userId, Commentaire__c = note.Commentaire__c);
			insert newNote;
		}else{
			note.Note_attribuee__c = noteActuelle;
			update note;
		}
	}
    
    public class NoNoteException extends Exception { }
}