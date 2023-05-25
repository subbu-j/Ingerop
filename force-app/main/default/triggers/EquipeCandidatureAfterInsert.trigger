/*
----------------------------------------------------------------------
-- - Name          : EquipeCandidatureAfterInsert
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Trigger for SObject Equipe_Candidature__c after insert
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 13/09/2016   BTH     1.0     Initial Version
----------------------------------------------------------------------
*/
trigger EquipeCandidatureAfterInsert on Equipe_Candidature__c (after insert) {
    System.debug('## Trigger EquipeCandidatureAfterInsert START');
    if(PAD.canTrigger('AP02')){
        AP02EquipeCandidature.createIngeropCoTraitant(Trigger.new);
    }
    System.debug('## Trigger EquipeCandidatureAfterInsert END');
}