/*
----------------------------------------------------------------------
-- - Name          : MembreEquipeCandidatureAfterUpdate
-- - Author        : Julien GAIOTTO - Bluetis
-- - Description   : Trigger for SObject Membre_d_Equipe_Candidature__c after update
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 19-SEP-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/

trigger MembreEquipeCandidatureAfterUpdate on Membre_d_Equipe_Candidature__c (after update) {
    System.debug('Start of trigger MembreEquipeCandidatureAfterUpdate');
    if(PAD.canTrigger('AP07')){
        AP07MembreDEquipeCandidature.membreEquipeAfterUpdate(Trigger.oldMap, Trigger.new);
    }
    System.debug('End of trigger MembreEquipeCandidatureAfterUpdate');

}