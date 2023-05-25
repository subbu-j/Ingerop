/*
----------------------------------------------------------------------
-- - Name          : VFC02EquipeDuCompte
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Extension controller for VFP02EquipeDuCompte
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 16-JUN-2016   BTH    1.0      Initial version
-- 20-SEP-2016   JGA    2.0      Fonctionnement adapté au javascript
-- 02-NOV-2016   PBE    3.0      Ajout de l'accès aux infos
-- 20-JUL-2018   NDI    4.0      Ouverture de droits
----------------------------------------------------------------------
*/
public without sharing class VFC02EquipeDuCompte {    
    public Id accountId {get;set;}
    public Account account {get;set;}
    public Boolean autorisation {get;set;}
    public List<SelectOption> accesContact { get; set; }
    public List<SelectOption> accesInfo { get; set; }
    public List<SelectOption> accesOperation { get; set; }

    public VFC02EquipeDuCompte(ApexPages.StandardController controller) {
        accountId = controller.getRecord().Id;
        account = DAL.getAccountById(accountId);
        autorisation = checkUserRights(account);
        sObject picklistHelper = new Membre_du_compte__c();
        accesContact = DAL.getPickValues(picklistHelper, 'Acces_au_contact__c', null);
        accesInfo = DAL.getPickValues(picklistHelper, 'Acces_a_info__c', null);
        accesOperation = DAL.getPickValues(picklistHelper, 'Acces_a_operation__c', null);
    }
    
     public static Boolean checkUserRights(Account account){
         list<UserRecordAccess> listAccountEditAccess = DAL.getEditAccessByUserIdAndObjectId(UserInfo.getUserId(),account.Id);
         if(listAccountEditAccess.size()==0){return False;}
         for (UserRecordAccess access : listAccountEditAccess){
             if (access.HasEditAccess == False){
                 return False;
             }
         }
        return True;
    }
    
    @RemoteAction
    public static List<MembreDuCompte> initListMembreDuCompte(String accountId) {
        list<MembreDuCompte> listMembre = new list<MembreDuCompte>();
        list<Membre_du_compte__c> listExistingMembres = DAL.getMembreDuCompteByAccountId(accountId);
        
        if(listExistingMembres != null && !listExistingMembres.isEmpty()) {
            for(Membre_du_compte__c m : listExistingMembres) {
                listMembre.add(new MembreDuCompte(m));
            }
        }
        
        return listMembre;
    }
    
    @RemoteAction
    public static MembreDuCompte initNewMembreDuCompte(String accountId) {
        return new MembreDuCompte('', '', '', accountId, '', '');
    }
    
    @RemoteAction
    public static MembreDuCompte modifierMembreDuCompte(String membreId){
        Membre_du_compte__c membre = DAL.getMembreDuCompteById(membreId);
        return new MembreDuCompte(membre);
    }
    
/*NDI20180720
    public static void deleteDroits(Account currentAccount, List<Contact> listContact, List<Operation__c> listOperation, List<Information_du_compte__c> listInfo, String idUser) {
        if(currentAccount != null){
            Set<Id> accountIds = new Set<Id>();
            accountIds.add(currentAccount.Id);
            List<AccountShare> listAccountShare = DAL.getAccountShareByAccountIdsAndUserId(accountIds, idUser);
            if(listAccountShare.size()>0){
                delete listAccountShare;                    
            }       
        }
        if(listContact.size()>0){
            Set<Id> contactIds = (new Map<Id, SObject>(listContact)).keySet();
            List<ContactShare> listContactShare = DAL.getContactShareByContactIdsAndUserId(contactIds, idUser);
            if(listContactShare.size()>0){
                delete listContactShare;                    
            }
        }
        
        if(listOperation.size()>0){
            Set<Id> operationIds = (new Map<Id, SObject>(listOperation)).keySet();
            List<Operation__Share> listOperationShare = DAL.getOperationShareByOperationIdsAndUserId(operationIds, idUser);
            if(listOperationShare.size()>0){
                delete listOperationShare;
            }
        }
        if(listInfo.size()>0){
            Set<Id> infoIds = (new Map<Id, SObject>(listInfo)).keySet();
            List<Information_du_compte__Share> listInfoShare = DAL.getInfoShareByOperationIdsAndUserId(infoIds, idUser);
            if(listInfoShare.size()>0){
                delete listInfoShare;
            }
        }
    }
 */   
/*NDI20180720
    public static void insertDroits(Account currentAccount, List<Contact> listContact, List<Operation__c> listOperation, List<Information_du_compte__c> listInfo, MembreDuCompte membre) {       
        // Initialisation des différentes listes d'objets de partage
        List<ContactShare> listContactShare = new List<ContactShare>();
        List<Operation__Share> listOperationShare = new List<Operation__Share>();
        List<Information_du_compte__Share> listInfoShare =new List<Information_du_compte__Share>();
        List<AccountShare> listAccountShare = new List<AccountShare>();

        // Complétion des listes
        for(Contact c : listContact){
            if(c.OwnerId != membre.userId){
                ContactShare cs = new ContactShare();
                cs.UserOrGroupId = membre.userId;
                cs.ContactId = c.Id;
                cs.ContactAccessLevel = membre.accessContact == 'Lecteur' ? 'Read' : 'Edit';
                listContactShare.add(cs);
            }
        }
        for(Operation__c o : listOperation){
            if(o.OwnerId != membre.userId){
                Operation__Share os = new Operation__Share();
                os.UserOrGroupId = membre.userId;
                os.ParentId = o.Id;
                os.AccessLevel = membre.accessOperation == 'Lecteur' ? 'Read' : 'Edit';
                listOperationShare.add(os);
            }
        }
        for(Information_du_compte__c i : listInfo){
            if(i.OwnerId != membre.userId){
                Information_du_compte__Share is = new Information_du_compte__Share();
                is.UserOrGroupId = membre.userId;
                is.ParentId = i.Id;
                is.AccessLevel = membre.accessOperation == 'Lecteur' ? 'Read' : 'Edit';
                listInfoShare.add(is);
            }
        }
        
        if(currentAccount.OwnerId != membre.userId){
            AccountShare acs = new AccountShare();
            acs.UserOrGroupId = membre.userId;
            acs.AccountId = currentAccount.Id;
            acs.AccountAccessLevel = 'Edit';
            acs.OpportunityAccessLevel = 'Edit';
            listAccountShare.add(acs);
        }
        

        // Opération CRUD
        if(listContactShare.size()>0){
            insert listContactShare;
        }
        if(listOperationShare.size()>0){
            insert listOperationShare;
        }
        if(listInfoShare.size()>0){
            insert listInfoShare;
        }
        if(listAccountShare.size()>0){
            insert listAccountShare;
        }

    }
*/    
    @RemoteAction
    public static void doSave(MembreDuCompte membre) {
        List<Contact> listContact = DAL.getContactByAccountId(membre.accountId);
        List<Operation__c> listOperation = DAL.getOperationByAccountId(membre.accountId);
        List<Information_du_compte__c> listInfo = DAL.getInfoByAccountId(membre.accountId);
        Account currentAccount = DAL.getAccountById(membre.accountId);

        if(listOperation.size()>0){
            List<Membre_de_l_operation__c> listMembreOperationToDelete = new List<Membre_de_l_operation__c>();
            Map<Id, List<Membre_de_l_operation__c>> mapMembreOperation = DAL.getMapMembreOperationByOperationIds((new Map<Id, sObject>(listOperation).keySet()));
            for(Operation__c op : listOperation){
                if(mapMembreOperation.containsKey(op.Id)){
                    for(Membre_de_l_operation__c mo : mapMembreOperation.get(op.Id)){
                        if(mo.Utilisateur__c == membre.userId){
                            listMembreOperationToDelete.add(mo);
                        }
                    }
                }
            }
            if(listMembreOperationToDelete.size()>0){
                delete listMembreOperationToDelete;
            }
        }

        Membre_du_compte__c membreDuCompte = new Membre_du_compte__c();
        membreDuCompte.Utilisateur__c = membre.userId;
        membreDuCompte.Acces_a_operation__c = membre.accessOperation;
        membreDuCompte.Acces_au_contact__c = membre.accessContact;
        membreDuCompte.Acces_a_info__c = membre.accessInfo;
        membreDuCompte.Compte__c = membre.accountId;   
        
        if(membre.membreId == '' || membre.membreId == null){
            // Création du membre du compte
            insert membreDuCompte;
        }
        else{
/*NDI20180720
            deleteDroits(currentAccount,listContact, listOperation, listInfo, membre.userId);
*/
            // MAJ du membre du compte
            membreDuCompte.Id = membre.membreId;
            update membreDuCompte;
        }
/*NDI20180720
        insertDroits(currentAccount, listContact, listOperation, listInfo, membre);
*/    
    }
    
    @RemoteAction
    public static void doDelete(String membreId, String userId, String accountId) {
        if(membreId != null && userId != null){
            Account currentAccount = DAL.getAccountById(accountId);
            List<Contact> listContact = DAL.getContactByAccountId(accountId);
            List<Operation__c> listOperation = DAL.getOperationByAccountId(accountId);
            List<Information_du_compte__c> listInfo = DAL.getInfoByAccountId(accountId);
/*NDI20180720            
         	deleteDroits(currentAccount,listContact, listOperation, listInfo, userId);
*/
            // Suppression du membre d'équipe du compte
            Membre_du_compte__c membreDuCompte = DAL.getMembreDuCompteById(membreId);
            delete membreDuCompte;
        }
    }
    
    @RemoteAction
    public static list<sObject> autocompleteUsers(String sObjectType, String term, String fieldsToGet, String fieldToCompare, Integer limitSize, String accountId) {
        set<Id> valuesToExclude = new set<Id>();
        list<Membre_du_compte__c> listExistingMembres = DAL.getMembreDuCompteByAccountId(accountId);
        for(Membre_du_compte__c m : listExistingMembres) {
            valuesToExclude.add(m.Utilisateur__c);
        }
        
        return DAL.dynamicQueryForAutocomplete(sObjectType, term, fieldsToGet, fieldToCompare, 'Id', valuesToExclude, limitSize);
    }
    
    public class MembreDuCompte {
        public String membreId { get; set; }
        public String accessOperation { get; set; }
        public String accessContact { get; set; }
        public String accessInfo { get; set; }
        public String accountId { get; set; }
        public String userId { get; set; }
        public String userName { get; set; }
        
        public MembreDuCompte(String accessOperation, String accessContact, String accessInfo, String accountId, String userId, String membreId) {
            this.accessOperation = accessOperation;
            this.accessContact = accessContact;
            this.accessInfo = accessInfo;
            this.accountId = accountId;
            this.userId = userId;
            this.membreId = membreId;
        }
        
        public MembreDuCompte() { 
            this.accessOperation = '';
            this.accessContact = '';
            this.accessInfo = '';
            this.accountId = '';
            this.userId = '';
            this.membreId = '';
        }
        
        public MembreDuCompte(Membre_du_compte__c membre) {
            if(membre == null) {
                new MembreDuCompte();
            }
            else {
                this.accessOperation = membre.Acces_a_operation__c;
                this.accessContact = membre.Acces_au_contact__c;
                this.accessInfo = membre.Acces_a_Info__c;
                this.accountId = membre.Compte__c;
                this.userId = membre.Utilisateur__c;
                this.userName = membre.Utilisateur__r.Name;
                this.membreId = membre.Id;
            }
        }
    }
}