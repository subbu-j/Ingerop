/*
----------------------------------------------------------------------
-- - Name          : DAL
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Methods to access database
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 13-JUN-2016   BTH    1.0      Initial version
-- 20-JUL-2018   NDI    2.0      Ouverture de droits
----------------------------------------------------------------------
*/
public with sharing class DAL {

    public static Equipe_Candidature__c getEquipeCandidatureById(Id idEquipe){
        Equipe_Candidature__c ec = null;
        if(idEquipe != null){
            ec = [SELECT Id, 
                        Name,
                        Operation__c,
                        Operation__r.Compte__c,
                        Operation__r.Compte__r.Name,
                        Operation__r.Name,
                        Date_limite_de_remise__c,
                        Mandataire__c
                    FROM Equipe_Candidature__c
                    WHERE Id =: idEquipe];
        }
        return ec;
    }

    public static Membre_d_Equipe_Candidature__c getMembreEquipeCandidatureById(Id membreEquipeId){
        Membre_d_Equipe_Candidature__c ec = null;
        if(membreEquipeId != null){
            ec = [SELECT Id,
                         Mandataire__c
                    FROM Membre_d_Equipe_Candidature__c
                    WHERE Id =: membreEquipeId];
        }
        return ec;
    }

    public static List<Repartition__c> getRepartitionByOffreId(Id offreId){
        List<Repartition__c> value = null;
        if(offreId != null){
            value = [SELECT Id FROM Repartition__c WHERE Offre__c = :offreId];
        }
        return value;
    }

    public static List<Equipe_Candidature__c> getEquipeCandidatureBySetIds(Set<Id> candidatureIds){
        List<Equipe_Candidature__c> value = null;
        if(candidatureIds.size()>0){
            value = [SELECT Id, Mandataire__c, Operation__c, Operation__r.Compte__c,Date_limite_de_remise__c FROM Equipe_Candidature__c WHERE Id IN :candidatureIds];
        }
        return value;
    }

    public static List<Relation__c> getRelationByUserAndContact(Id userId, Id contactId){
        List<Relation__c> value = null;
        if(userId != null && contactId != null){
            value = [SELECT Id FROM Relation__c WHERE Contact__c = :contactId AND CreatedById = :userId];
        }
        return value;
    }

    public static Score__c getNoteByAccountAndUser(Id userId, Id accountId){
        Score__c value = null;
        if(userId != null && accountId != null){
            List<Score__c> tempValue = [SELECT Note_attribuee__c, Commentaire__c, Compte__c, Utilisateur__c FROM Score__c WHERE Utilisateur__c = :userId AND Compte__c = :accountId];
            if(tempValue.size()>0){
                value = tempValue[0];
            }
        }
        return value;
    }

    public static List<Score__c> getNoteByAccount(Id accountId){
        List<Score__c> value = null;
        if(accountId != null){
            value = [SELECT Id, Note_attribuee__c, Commentaire__c, Compte__c FROM Score__c WHERE Compte__c = :accountId];
        }
        return value;
    }

    public static Score__c getNoteById(Id scoreId){
        Score__c value = null;
        if(scoreId != null){
            value = [SELECT Id, Note_attribuee__c, Commentaire__c, Compte__c, Utilisateur__c FROM Score__c WHERE Id = :scoreId];
        }
        return value;
    }

    public static List<Score__c> getNoteByAccountIds(Set<Id> partenaireIds){
        List<Score__c> value = null;
        if(partenaireIds.size()>0){
            value = [SELECT Id, Note_attribuee__c, Compte__c FROM Score__c WHERE Compte__c IN :partenaireIds];
        }
        return value;
    }

    public static List<Membre_du_compte__c> getMembreDuCompteByAccountId(Id accountId){
        List<Membre_du_compte__c> value = null;
        if(accountId != null){
            value = [SELECT Id, 
                            Acces_au_contact__c,
                            Acces_a_operation__c,
                            Acces_a_info__c,
                            Utilisateur__c,
                            Utilisateur__r.Name,
                            Compte__c
                    FROM Membre_du_compte__c
                    WHERE Compte__c = :accountId];
        }
        return value;
    }

    public static Account getAccountById(Id accountId){
        Account value = null;
        if(accountId != null){
            value = [SELECT Id, Name,
                            OwnerId,
                            Prive_public__c,
                            Activite__c,
                            Moyenne_des_scores__c,
                            TECH_Activit_Batiment__c,
                            TECH_Activite_Eau_Environnement__c,
                            TECH_Activite_Energie_Industrie__c,
                            TECH_Activite_Ville_Mobilite__c
                    FROM Account
                    WHERE Id = :accountId];
        }
        return value;
    }
    
    public static Account getAccountbyName(String nameOfAccount){
        Account value = null;
        if(nameOfAccount != ''){
            value = [SELECT Id
                    FROM Account
                    WHERE Name = :nameOfAccount LIMIT 1];
        }
        return value;
    }

    public static Membre_du_compte__c getMembreDuCompteById(Id membreDuCompteId){
        Membre_du_compte__c value = null;
        if(membreDuCompteId != null){
            value = [SELECT Id,
                            Acces_au_contact__c,
                            Acces_a_operation__c,
                            Acces_a_info__c,
                            Compte__c,
                            Utilisateur__c,
                            Utilisateur__r.Name
                    FROM Membre_du_compte__c
                    WHERE Id = :membreDuCompteId];
        }
        return value;
    }

    public static List<Contact> getContactByAccountId(Id accountId){
        List<Contact> value = null;
        if(accountId != null){
            value = [SELECT Id, OwnerId FROM Contact WHERE AccountId = :accountId];
        }
        return value;
    }

    public static List<ContactShare> getContactShareByContactIdsAndUserId(Set<Id> contactIds, Id userId){
        List<ContactShare> value = null;
        if(userId != null && contactIds.size()>0){
            value = [SELECT Id, ContactAccessLevel, UserOrGroupId FROM ContactShare WHERE UserOrGroupId = :userId AND ContactId IN :contactIds AND RowCause = 'Manual'];
        }
        return value;
    }

    public static List<AccountShare> getAccountShareByAccountIdsAndUserId(Set<Id> accountIds, Id userId){
        List<AccountShare> value = null;
        if(userId != null && accountIds.size()>0){
            value = [SELECT Id, AccountAccessLevel, UserOrGroupId FROM AccountShare WHERE UserOrGroupId = :userId AND AccountId IN :accountIds AND RowCause = 'Manual'];
        }
        return value;
    }

    public static List<ContactShare> getContactShareByContactId(Id contactId){
        List<ContactShare> value = null;
        if(contactId != null){
            value = [SELECT Id, ContactAccessLevel, UserOrGroupId FROM ContactShare WHERE ContactId = :contactId AND RowCause = 'Manual'];
        }
        return value;
    }

    public static Offre__c getOffreById(Id offreId){
        Offre__c value = null;
        if(offreId != null){
            List<Offre__c> tempList = [SELECT Id, Operation__c, Statut__c FROM Offre__c WHERE Id = :offreId];
            if(tempList.size()>0){
                value = tempList[0];
            }
        }
        return value;
    }

    public static List<Offre__c> getOffreByIds(Set<Id> offreIds){
        List<Offre__c> value = null;
        if(offreIds.size()>0){
            value = [SELECT Id, 
                            Name, 
                            Operation__c, 
                            Operation__r.Compte__c, 
                            Operation__r.UFO__c,
                            Operation__r.Pole__c,
                            Operation__r.Departement_du_pole__c,
                            Operation__r.Service__c,
                            Montant_part_Ingerop__c,
                            Candidature__c 
                    FROM Offre__c 
                    WHERE Id IN :offreIds];
        }
        return value;
    }

    public static List<Operation__c> getOperationByAccountId(Id accountId){
        List<Operation__c> value = null;
        if(accountId != null){
            value = [SELECT Id, OwnerId FROM Operation__c WHERE Compte__c = :accountId];
        }
        return value;
    }
    
    public static List<Information_du_compte__c> getInfoByAccountId(Id accountId){
        List<Information_du_compte__c> value = null;
        if(accountId != null){
            value = [SELECT Id, OwnerId FROM Information_du_compte__c WHERE Compte__c = :accountId];
        }
        return value;
    }
/*NDI20180720
    public static List<Operation__Share> getOperationShareByOperationIdsAndUserId(Set<Id> operationIds, Id userId){
        List<Operation__Share> value = null;
        if(userId != null && operationIds.size()>0){
            value = [SELECT Id, AccessLevel, UserOrGroupId FROM Operation__Share WHERE UserOrGroupId = :userId AND ParentId IN :operationIds AND RowCause = 'Manual'];
        }
        return value;
    }
 */
/*NDI20180720
    public static List<Information_du_compte__Share> getInfoShareByOperationIdsAndUserId(Set<Id> infoIds, Id userId){
        List<Information_du_compte__Share> value = null;
        if(userId != null && infoIds.size()>0){
            value = [SELECT Id, AccessLevel, UserOrGroupId FROM Information_du_compte__Share WHERE UserOrGroupId = :userId AND ParentId IN :infoIds AND RowCause = 'Manual'];
        }
        return value;
    }
*/
    public static List<Membre_du_compte__c> getMembreDuCompteByAccountIds(Set<Id> accountIds){
        List<Membre_du_compte__c> value = null;
        if(accountIds.size()>0){
            value = [SELECT Id,
                            Acces_au_contact__c,
                            Acces_a_operation__c,
                            Acces_a_info__c,
                            Compte__c,
                            Utilisateur__c,
                            Utilisateur__r.Name
                    FROM Membre_du_compte__c
                    WHERE Compte__c IN :accountIds];
        }
        return value;
    }

    public static List<Account> getAccountByIds(Set<Id> accountIds){
        List<Account> value = null;
        if(accountIds.size()>0){
            value = [SELECT Id,
                            OwnerId,
                            Moyenne_des_scores__c
                    FROM Account
                    WHERE Id IN :accountIds];
        }
        return value;
    }

    public static Operation__c getOperationById(Id operationId){
        Operation__c value = null;
        if(operationId != null){
            value = [SELECT Id, Name, TECH_MAX_DateLimiteDeRemise__c, Compte__c, Compte__r.Name, Statut__c, OwnerId, UFO__c, Pole__c, Departement_du_pole__c, Service__c FROM Operation__c WHERE Id = :operationId];
        }
        return value;
    }

    public static List<Operation__c> getOperationByIds(Set<Id> operationIds){
        List<Operation__c> value = null;
        if(operationIds.size()>0){
            value = [SELECT Id, Name, OwnerId,TECH_MAX_DateLimiteDeRemise__c,Date_previsionnelle_de_candidature__c FROM Operation__c WHERE Id IN :operationIds];
        }
        return value;
    }
/*NDI20180720
    public static List<Operation__Share> getOperationShareByOperationId(Id operationId){
        List<Operation__Share> value = null;
        if(operationId != null){
            value = [SELECT Id, AccessLevel, UserOrGroupId FROM Operation__Share WHERE ParentId = :operationId AND RowCause = 'Manual'];
        }
        return value;
    }
*/
/*NDI20180720    
	public static Operation__Share getOperationShareByOperationIdAndUserId(Id operationId, Id userId){
        Operation__Share value = null;
        if(userId != null && operationId != null){
            List<Operation__Share> tempList = [SELECT Id, AccessLevel, UserOrGroupId FROM Operation__Share WHERE UserOrGroupId = :userId AND ParentId = :operationId AND RowCause = 'Manual'];
            if(tempList.size()>0){
                value = tempList[0];
            }
        }
        return value;
    }
*/
    public static List<Membre_d_Equipe_Candidature__c> getMembreEquipeCandidatureByEquipeCandidatureId(Id equipeCandidatureId){
        List<Membre_d_Equipe_Candidature__c> value = null;
        if(equipeCandidatureId != null){
            value = [SELECT Id, Compte__c FROM Membre_d_Equipe_Candidature__c WHERE Equipe_Candidature__c = :equipeCandidatureId];
        }
        return value;
    }

    public static Annonce__c getVeilleById(Id veilleId){
        Annonce__c value = null;
        if(veilleId != null){
            List<Annonce__c> tempList = [SELECT Id, Name, Owner.Name, OwnerId, Statut__c FROM Annonce__c WHERE Id = :veilleId];
            if(tempList.size()>0){
                value = tempList[0];
            }
        }
        return value;
    }
    
    public static List<sObject> dynamicQueryForAutocomplete(String sObjectType, String term, String fieldsToGet, String fieldToCompare, String fieldToExclude, set<Id> valuesToExclude, Integer limitSize) {        
        if(sObjectType == null || sObjectType == '' || term == null || term == '' || fieldsToGet == null || fieldsToGet == '') return null;
        
        limitSize = limitSize == null ? 10 : limitSize;
        
        // could add in logic to remove possible duplicate fields
        String fields = fieldsToGet.length() > 0 ? fieldsToGet : '';
        String soql = 
            ' SELECT ' + String.escapeSingleQuotes(fields) +
            ' FROM '   + String.escapeSingleQuotes(sObjectType) +
            ' WHERE ' + String.escapeSingleQuotes(fieldToCompare) + ' LIKE \'%' + String.escapeSingleQuotes(term) + '%\'' +
            (fieldToExclude != null && !valuesToExclude.isEmpty() ? ' AND ' + String.escapeSingleQuotes(fieldToExclude) + ' NOT IN :valuesToExclude ' : '') +
            ' LIMIT ' + limitSize;
        system.debug(soql);
        system.debug(valuesToExclude);
        return Database.query(soql);
    }
    
    public static List<selectOption> getPickValues(Sobject object_name, String field_name, String first_val) {
        list<selectOption> options = new list<selectOption>();
        
        // If there is a first value being provided, add it
        if (first_val != null) { 
            options.add(new selectOption(first_val, first_val));
        }
        
        // Grab the sobject that was passed
        Schema.sObjectType sobject_type = object_name.getSObjectType();
        // Describe the sobject
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        // Get a map of fields for the passed sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        // Grab the list of picklist values for the passed field on the sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues();
        // For each values in the picklist list
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getValue(), a.getLabel()));
        }
        return options;
    }

    public static List<Membre_d_Equipe_Candidature__c> getAncienMandataireByEquipeCandidatureIds(Set<Id> candidatureIds, Set<Id> membreToExclude){
        List<Membre_d_Equipe_Candidature__c> value = null;
        if(candidatureIds.size()>0 && membreToExclude.size()>0){
            value = [SELECT Id, Mandataire__c FROM Membre_d_Equipe_Candidature__c WHERE Equipe_Candidature__c IN :candidatureIds AND Id NOT IN :membreToExclude];
        }
        return value;
    }
    
    public static List<Operation__c> getOperationAndOffreByPhaseCommercialeAndId(Set<Id> OperationId, String PhaseCommerciale){
        list<Operation__c> listOperation = [SELECT id, Name,statut__c, (Select id, name, statut__c FROM Offres__r) FROM Operation__c WHERE id IN :OperationId AND Phase_commerciale__c =:PhaseCommerciale];
        return listOperation;
    }
    
    public static List<Operation__c> getOperationAndCandidatureByPhaseCommercialeAndId(Set<Id> OperationId, String PhaseCommerciale){
        list<Operation__c> listOperation = [SELECT id, Name,statut__c, (Select id, name, statut__c FROM Candidatures__r) FROM Operation__c WHERE id IN :OperationId AND Phase_commerciale__c =:PhaseCommerciale];
        return listOperation;
    }

    public static Map<Id, List<Membre_de_l_operation__c>> getMapMembreOperationByOperationIds(Set<Id> operationIds){
        Map<Id, List<Membre_de_l_operation__c>> value = null;
        if(!operationIds.isEmpty()){
            value = new Map<Id, List<Membre_de_l_operation__c>>();
            for(Membre_de_l_operation__c mo : [SELECT Id, Operation__c, Utilisateur__c 
                                                FROM Membre_de_l_operation__c
                                                WHERE Operation__c IN :operationIds]){
                if(!value.containsKey(mo.Operation__c)){
                    value.put(mo.Operation__c, new List<Membre_de_l_operation__c>());
                }
                value.get(mo.Operation__c).add(mo);
            }
        }
        return value;
    }

    public static List<Membre_de_l_operation__c> getMembreOperationByOperationId(Id operationId){
        List<Membre_de_l_operation__c> value = null;
        if(operationId != null){
            value = [SELECT Id, 
                            Acces_a_operation__c, 
                            Operation__c,
                            Utilisateur__c,
                            Utilisateur__r.Name
                    FROM Membre_de_l_operation__c 
                    WHERE Operation__c = :operationId];
        }
        return value;
    }

    public static Membre_de_l_operation__c getMembreOperationByOperationIdAndUserId(Id operationId, Id userId){
        Membre_de_l_operation__c value = null;
        if(operationId != null && userId != null){
            List<Membre_de_l_operation__c> tempList = [SELECT Id, 
                            Acces_a_operation__c, 
                            Operation__c,
                            Utilisateur__c,
                            Utilisateur__r.Name
                    FROM Membre_de_l_operation__c 
                    WHERE Operation__c = :operationId
                    AND Utilisateur__c = :userId];
            if(tempList.size()>0){
                value = tempList[0];
            }
        }
        return value;
    }
    
    public static List<Veille__c> getVeilleByUserId(Id userId, Id annonceId){
        List<Veille__c> result = new List<Veille__c>();
        if(userId != null && annonceId != null){
            result = [SELECT Id,
                             Statut__c,
                             Interet__c
                       FROM Veille__c
                       WHERE Destinataire__c =: userId
                       AND Annonce__c =: annonceId LIMIT 1];
        }
        return result;
    }
    
    
    public static list<Veille__c> getVeillePrisEnCompteByAnnonceId(Id annonceId){
        list<Veille__c> listVeille = null;
        if(annonceId != null){
            listVeille = [SELECT Id,
                                 Destinataire__c,
                                 Statut__c
                             FROM Veille__c
                             WHERE Annonce__c =: annonceId
                             AND Statut__c =: Label.VeillePrisEnCompteStatut];
        }
        return listVeille;
    }
    
    public static map<Id,list<Veille__c>> getVeilleByAnnonceId(set<Id> annonceId){
        list<Veille__c> listVeille = new list<Veille__c>();
        map<Id, list<Veille__c>> mapAnnonce = new map<Id, list<Veille__c>>();
        
        if(!annonceId.isEmpty()){
            listVeille = [SELECT Id,
                                 Destinataire__c,
                                 Statut__c,
                                 Annonce__c
                             FROM Veille__c
                             WHERE Annonce__c IN: annonceId
                         ];
            if(!listVeille.isEmpty()){
                for(Veille__c v : listVeille){
                    if(!mapAnnonce.containsKey(v.Annonce__c)){
                        mapAnnonce.put(v.Annonce__c, new List<Veille__c>());
                    }
                    mapAnnonce.get(v.Annonce__c).add(v);
                }
            }
        }
        return mapAnnonce;
    }
    
    public static list<UserRecordAccess> getEditAccessByUserIdAndObjectId(Id userId, Id objectId){
        List<UserRecordAccess> listEditAccess = null;
        if(UserId != null && ObjectId!=null) {
            listEditAccess =  [SELECT RecordId,HasEditAccess
                             FROM UserRecordAccess 
                             WHERE UserId =: userId
                             AND RecordId =: objectId
                    ];
        }
        return listEditAccess;        
    }

    public static list<UserRecordAccess> getReadAccessByUserIdAndObjectId(Id userId, Id objectId){
        List<UserRecordAccess> listEditAccess = null;
        if(UserId != null && ObjectId!=null) {
            listEditAccess =  [SELECT RecordId,HasReadAccess
                             FROM UserRecordAccess 
                             WHERE UserId =: userId
                             AND RecordId =: objectId
                    ];
        }
        return listEditAccess;        
    }

    
}