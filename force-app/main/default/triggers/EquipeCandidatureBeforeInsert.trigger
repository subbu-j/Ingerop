/*
----------------------------------------------------------------------
-- - Name          : EquipeCandidatureBeforeInsert
-- - Author        : Paul BENARD - Bluetis
-- - Description   : Trigger for SObject Equipe_Candidature__c before insert
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 13/09/2016   BTH     1.0     Initial Version
----------------------------------------------------------------------
*/
trigger EquipeCandidatureBeforeInsert on Equipe_Candidature__c (before insert) {
    System.debug('## Trigger EquipeCandidatureBeforeInsert START');
    if(PAD.canTrigger('AP02')){
        AP02EquipeCandidature.AssignDateDeRemise(Trigger.new);
    }
    System.debug('## Trigger EquipeCandidatureBeforeInsert END');
}