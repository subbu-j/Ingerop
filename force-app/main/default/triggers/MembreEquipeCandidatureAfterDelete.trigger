/*
----------------------------------------------------------------------
-- - Name          : MembreEquipeCandidatureAfterDelete
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Trigger for SObject Membre_d_Equipe_Candidature__c after delete
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 05-SEP-2016   BTH    1.0      Initial version
-- 09-SEP-2016   PBE    1.1      PAD
----------------------------------------------------------------------
*/

trigger MembreEquipeCandidatureAfterDelete on Membre_d_Equipe_Candidature__c (after delete) {
    System.debug('Start of trigger MembreEquipeCandidatureAfterDelete');
    if(PAD.canTrigger('AP07')){
        AP07MembreDEquipeCandidature.deleteMandataire(Trigger.old);
    }
    System.debug('End of trigger MembreEquipeCandidatureAfterDelete');
}