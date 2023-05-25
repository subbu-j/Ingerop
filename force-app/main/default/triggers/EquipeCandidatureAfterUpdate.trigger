/*
----------------------------------------------------------------------
-- - Name          : ContactAfterInsert
-- - Author        : Paul BENARD - Bluetis
-- - Description   : Trigger for SObject Candidature after Update
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 07-OCT-2016   PBE    1.0      Initial version
----------------------------------------------------------------------
*/
trigger EquipeCandidatureAfterUpdate on Equipe_Candidature__c (after update) {
	System.Debug('Start of trigger EquipeCandidatureAfterUpdate');
    if(PAD.canTrigger('AP03')){
        AP02EquipeCandidature.majOperation(Trigger.old, Trigger.new);
    }
    System.debug('End of trigger EquipeCandidatureAfterUpdate');
}