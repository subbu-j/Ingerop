/*
----------------------------------------------------------------------
-- - Name          : VFC04PartageOperation
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Extension controller for VFP04PartageOperation
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 27-JUN-2016   BTH    1.0      Initial version
-- 20-JUL-2018   NDI    2.0      Ouverture de droits
----------------------------------------------------------------------
*/
public without sharing class VFC04PartageOperation {
    public Operation__c operation   {get;set;}
    public Boolean autorisation     {get;set;}

    public List<SelectOption> getDroits(){
        List<SelectOption> droits = new List<SelectOption>();
        droits.add(new SelectOption('Acteur/Lecteur', Label.ActeurLecteur));
        droits.add(new SelectOption('Lecteur', Label.Lecteur));
        return droits;
    }

    public VFC04PartageOperation(ApexPages.StandardController controller) {
        operation = DAL.getOperationById(controller.getRecord().Id);
        autorisation = checkUserRights(operation);
    }

    public static Boolean checkUserRights(Operation__c operation){
         list<UserRecordAccess> listOperationAccess = DAL.getReadAccessByUserIdAndObjectId(UserInfo.getUserId(),operation.Id);
         if(listOperationAccess.size()==0){return False;}
         for (UserRecordAccess access : listOperationAccess){
             if (access.HasReadAccess == False){
                 return False;
             }
         }
        return True;
    }

    
    @RemoteAction
    public static void doSave(UtilisateurPartage partage) {
        // On récupere puis delete l'opération partagée si l'utilisateur en possède une 
/*NDI20180720
        Operation__Share operationShare = DAL.getOperationShareByOperationIdAndUserId(partage.operationId, partage.userId);
        if(operationShare != null){
            delete operationShare; 
        }

        // On insert le nouveau partage sur l'opération
        Operation__Share os = new Operation__Share();
        os.UserOrGroupId = partage.userId;
        os.ParentId = partage.operationId;
        os.AccessLevel = partage.acces == 'Lecteur' ? 'Read' : 'Edit';
        insert os;

        Membre_de_l_operation__c mo = new Membre_de_l_operation__c();
        if(partage.membreOperationId != null && partage.membreOperationId != ''){
            mo.Id = partage.membreOperationId;
        }
        mo.Utilisateur__c = partage.userId;
        mo.Operation__c = partage.operationId;
        mo.Acces_a_operation__c = partage.acces;
        upsert mo;
*/
    }
    
    @RemoteAction
    public static void doDelete(String userId, String operationId) {
        if(userId != null && operationId != null){
/*NDI20180720            
			Operation__Share operationShare = DAL.getOperationShareByOperationIdAndUserId(operationId, userId);
            delete operationShare;
*/
            Membre_de_l_operation__c membreOperation = DAL.getMembreOperationByOperationIdAndUserId(operationId, userId);
            delete membreOperation;
        }
    }

    @RemoteAction
    public static List<UtilisateurPartage> initListUtilisateurPartage(String operationId, String ownerId) {
        List<UtilisateurPartage> listUtilisateurPartage = new list<UtilisateurPartage>();

        // Init list shared user for the operation
        List<Membre_de_l_operation__c> listMembreOperation = DAL.getMembreOperationByOperationId(operationId);
        for(Membre_de_l_operation__c mo : listMembreOperation){
            listUtilisateurPartage.add(new UtilisateurPartage(mo.Id, mo.Utilisateur__c, mo.Utilisateur__r.Name, mo.Operation__c, mo.Acces_a_operation__c));
        }
        
        return listUtilisateurPartage;
    }

    @RemoteAction
    public static UtilisateurPartage initNewUtilisateurPartage(String operationId) {
        return new UtilisateurPartage('', '', '', operationId, 'Acteur/Lecteur');
    }
    
    @RemoteAction
    public static UtilisateurPartage modifierUtilisateurPartage(String operationId, String userId){
        Membre_de_l_operation__c membreOperation = DAL.getMembreOperationByOperationIdAndUserId(operationId, userId);
        return new UtilisateurPartage(membreOperation.Id, membreOperation.Utilisateur__c, membreOperation.Utilisateur__r.Name, membreOperation.Operation__c, membreOperation.Acces_a_operation__c);
    }

    @RemoteAction
    public static List<SObject> autocompleteUsers(String sObjectType, String term, String fieldsToGet, String fieldToCompare, Integer limitSize, String operationId) {
        Set<Id> valuesToExclude = new Set<Id>();
/*NDI20180720
        List<Operation__Share> listOperationShare = DAL.getOperationShareByOperationId(operationId);
        for(Operation__Share os : listOperationShare){
            valuesToExclude.add(os.UserOrGroupId);
        }
*/
        return DAL.dynamicQueryForAutocomplete(sObjectType, term, fieldsToGet, fieldToCompare, 'Id', valuesToExclude, limitSize);
    }

    public class UtilisateurPartage{
        public String membreOperationId {get;set;}
        public String userId            {get;set;}
        public String userName          {get;set;}
        public String operationId       {get;set;}
        public String acces             {get;set;}


        public UtilisateurPartage(){
            this.membreOperationId = '';
            this.userId = '';
            this.userName = '';
            this.operationId = '';
            this.acces = 'Acteur/Lecteur';
        }

        public UtilisateurPartage(String membreOperationId, String userId, String userName, String operationId, String acces){
            this.membreOperationId = membreOperationId;
            this.userId = userId;
            this.userName = userName;
            this.operationId = operationId;
            this.acces = acces;
        }
    }
}