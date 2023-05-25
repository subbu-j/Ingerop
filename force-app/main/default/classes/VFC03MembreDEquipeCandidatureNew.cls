/*
----------------------------------------------------------------------
-- - Name          : VFC03MembreDEquipeCandidature
-- - Author        : Mélanie TEXEREAU - Bluetis
-- - Description   : class VFC03MembreDEquipeCandidature
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 21-JUN-2016   MTE    1.0      Initial version
-- 07-JUL-2016   MTE    1.1      Add filter Nom du compte, score + column score + contacts
----------------------------------------------------------------------
*/

public with sharing class VFC03MembreDEquipeCandidatureNew {
    public String activite                                  {   get;set;    }
    public String categorie                                 {   get;set;    }
    public String privepublic                               {   get;set;    }
    public String zoneGeo                                   {   get;set;    }
    public String codePostal                                {   get;set;    }
    public String ville                                     {   get;set;    }
    public Equipe_Candidature__c myEquipe                   {   get;set;    }
    public List<AccountWrapper> listAccountWrapper          {   get;set;    }
    public String nomCompte                                 {   get;set;    }
    public Decimal scoreCompte                              {   get;set;    }
    public Map<Id, list<SelectOption>> mapContactByAccount  {   get;set;    }
    public String idEquipe                                  {   get;set;    }

    //Pagination
    public Integer counter = 0; 
    public Integer list_size = 25; 
    public Integer total_size;

    public VFC03MembreDEquipeCandidatureNew() {
        System.debug('## VFC03MembreDEquipeCandidature.init START');
        idEquipe = ApexPages.currentPage().getParameters().get('id');
        myEquipe = DAL.getEquipeCandidatureById(idEquipe);
        System.debug('## VFC03MembreDEquipeCandidature.init END');
    }
    
    @RemoteAction
    public static String searchAccountByName(String nomCompte, String idEquipe){
        System.debug('## VFC03MembreDEquipeCandidature.searchAccount START');
        List<AccountWrapper> listAccountWrapper = new List<AccountWrapper>();
        List<Id> compteIds = new List<Id>();
        Id recordTypePartenaire = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partenaire').getRecordTypeId();
        Equipe_Candidature__c myEquipe = DAL.getEquipeCandidatureById(idEquipe);
        List<Membre_d_Equipe_Candidature__c> listMembreEquipeCandidature = DAL.getMembreEquipeCandidatureByEquipeCandidatureId(myEquipe.Id);
        for(Membre_d_Equipe_Candidature__c m : listMembreEquipeCandidature){
            compteIds.add(m.Compte__c);
        }
        
        String soql = 'SELECT Id, Name, Note_attribuee__c FROM Account WHERE Id != NULL'; 
        for(Id compteId : compteIds){
            soql += ' AND Id != \'' + compteId + '\'';
        }
        if(nomCompte != null && nomCompte != ''){
            soql += ' AND Name LIKE \'' + nomCompte.replace('\'', '\\\'') +'%\'';
        }
        soql += ' ORDER BY Name ASC';
        
        for(Account acc : Database.query(soql)){
            listAccountWrapper.add(new AccountWrapper(acc));
        }
        
        System.debug('## VFC03MembreDEquipeCandidature.searchAccount END');
        return JSON.serialize(listAccountWrapper);
    }    
    
    @RemoteAction
    public static String searchAccount(String idEquipe){
        System.debug('## VFC03MembreDEquipeCandidature.searchAccount START');
        List<AccountWrapper> listAccountWrapper = new List<AccountWrapper>();
        List<Id> compteIds = new List<Id>();
        Equipe_Candidature__c myEquipe = DAL.getEquipeCandidatureById(idEquipe);
        List<Membre_d_Equipe_Candidature__c> listMembreEquipeCandidature = DAL.getMembreEquipeCandidatureByEquipeCandidatureId(myEquipe.Id);
        for(Membre_d_Equipe_Candidature__c m : listMembreEquipeCandidature){
            compteIds.add(m.Compte__c);
        }
        
        String soql = 'SELECT Id, Name, Note_attribuee__c FROM Account WHERE Id != NULL'; 
        for(Id compteId : compteIds){
            soql += ' AND Id != \'' + compteId + '\'';
        }
        soql += ' ORDER BY Name ASC';
        
        for(Account acc : Database.query(soql)){
            listAccountWrapper.add(new AccountWrapper(acc));
        }
        
        System.debug(JSON.serialize(listAccountWrapper));
        System.debug('## VFC03MembreDEquipeCandidature.searchAccount END');
        return JSON.serialize(listAccountWrapper);
    }   
    
    @RemoteAction
    public static list<sObject> autocompleteAccounts(String sObjectType, String term, String fieldsToGet, String fieldToCompare, Integer limitSize) {        
        return DAL.dynamicQueryForAutocomplete(sObjectType, term, fieldsToGet, fieldToCompare, null, new set<Id>(), limitSize);
    }

    

    public class AccountWrapper{
        public Account acc              {   get;set;    }
        public Boolean toInsert         {   get;set;    }

        public AccountWrapper(Account account){
            acc = account;
            toInsert = false;
        }
    }
}