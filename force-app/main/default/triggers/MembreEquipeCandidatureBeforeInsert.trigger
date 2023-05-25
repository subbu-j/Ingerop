/*
----------------------------------------------------------------------
-- - Name          : MembreEquipeCandidatureBeforeInsert
-- - Author        : Paul BENARD - Bluetis
-- - Description   : Trigger for SObject Membre_d_Equipe_Candidature__c before insert
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 05-OCT-2016   PBE    1.0      Initial version
----------------------------------------------------------------------
*/
trigger MembreEquipeCandidatureBeforeInsert on Membre_d_Equipe_Candidature__c (before insert) {
System.debug('Start of trigger MembreEquipeCandidatureBeforeInsert');
    if(PAD.canTrigger('AP07')){
        AP07MembreDEquipeCandidature.UncheckOldMandataire(Trigger.new);
    }
    System.debug('End of trigger MembreEquipeCandidatureBeforeInsert');
}