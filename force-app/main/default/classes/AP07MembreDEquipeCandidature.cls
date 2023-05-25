/*
----------------------------------------------------------------------
-- - Name          : AP07MembreDEquipeCandidature
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Methods for SObject Membre_d_equipe_candidature__c
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 27-SEP-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
public with sharing class AP07MembreDEquipeCandidature {
    public static void membreEquipeAfterUpdate(map<Id, Membre_d_Equipe_Candidature__c> mapMembreOld, list<Membre_d_Equipe_Candidature__c> listMembreNew) {
        System.debug('## AP07MembreDEquipeCandidature.membreEquipeAfterUpdate START');

        Set<Id> setIdEquipeCandidatureToUpdate = new Set<Id>();
        Set<Id> candidatureIds = new Set<Id>();
        Set<Id> membreToExclude = new Set<Id>();
        Map<Id, Id> mapMandataire = new Map<Id, Id>();
        
        // For each update member
        for(Membre_d_Equipe_Candidature__c m : listMembreNew) {
            // If it was a Mandatare, but it's not anymore,
            if(m.Mandataire__c == false && mapMembreOld.get(m.Id).Mandataire__c) {
                // Let's get the Equipe/Candidature it's been related to
                setIdEquipeCandidatureToUpdate.add(m.Equipe_Candidature__c);
            }

            if(m.Mandataire__c && mapMembreOld.get(m.Id).Mandataire__c == false){
                membreToExclude.add(m.Id);
                candidatureIds.add(m.Equipe_Candidature__c);
                mapMandataire.put(m.Equipe_Candidature__c, m.Compte__c);
            }
        }
        
        AP02EquipeCandidature.emptyMandataireOnEquipe(setIdEquipeCandidatureToUpdate);

        if(candidatureIds.size()>0){
            List<Membre_d_Equipe_Candidature__c> listAncienMandataire = DAL.getAncienMandataireByEquipeCandidatureIds(candidatureIds, membreToExclude);
            for(Membre_d_Equipe_Candidature__c ancienMandataire : listAncienMandataire){
                ancienMandataire.Mandataire__c = false;
            }
            update listAncienMandataire;

            AP02EquipeCandidature.addMandataireOnEquipe(candidatureIds, mapMandataire);
        }

        System.debug('## AP07MembreDEquipeCandidature.membreEquipeAfterUpdate END');
    }

    public static void deleteMandataire(list<Membre_d_Equipe_Candidature__c> listMembreDeleted){
        System.debug('## AP07MembreDEquipeCandidature.deleteMandataire START');

        set<Id> setIdEquipeCandidatureToUpdate = new set<Id>();

        for(Membre_d_Equipe_Candidature__c membreOld : listMembreDeleted){
            if(membreOld.Mandataire__c == true){
                setIdEquipeCandidatureToUpdate.add(membreOld.Equipe_Candidature__c);
            }
        }

        AP02EquipeCandidature.emptyMandataireOnEquipe(setIdEquipeCandidatureToUpdate);

        System.debug('## AP07MembreDEquipeCandidature.deleteMandataire END');
    }
    
    public static void UncheckOldMandataire(list<Membre_d_Equipe_Candidature__c> listMembre){
        System.debug('## AP07MembreDEquipeCandidature.UncheckOldMandataire START');
        Set<Id> setIdEquipeCandidatureToUpdate = new Set<Id>();
        Set<Id> candidatureIds = new Set<Id>();
        Set<Id> membreToExclude = new Set<Id>();
        Map<Id, Id> mapMandataire = new Map<Id, Id>();
        
        // For each update member
        for(Membre_d_Equipe_Candidature__c m : listMembre) {
            // If it was a Mandatare, but it's not anymore,
            if(m.Mandataire__c == true) {
                setIdEquipeCandidatureToUpdate.add(m.Equipe_Candidature__c);
                membreToExclude.add(m.Id);
                candidatureIds.add(m.Equipe_Candidature__c);
                mapMandataire.put(m.Equipe_Candidature__c, m.Compte__c);
            }
        }
        
        AP02EquipeCandidature.emptyMandataireOnEquipe(setIdEquipeCandidatureToUpdate);
        if(candidatureIds.size()>0){
            List<Membre_d_Equipe_Candidature__c> listAncienMandataire = DAL.getAncienMandataireByEquipeCandidatureIds(candidatureIds, membreToExclude);
            for(Membre_d_Equipe_Candidature__c ancienMandataire : listAncienMandataire){
                ancienMandataire.Mandataire__c = false;
            }
            update listAncienMandataire;

            AP02EquipeCandidature.addMandataireOnEquipe(candidatureIds, mapMandataire);
        }
       System.debug('## AP07MembreDEquipeCandidature.UncheckOldMandataire END'); 
    }
}