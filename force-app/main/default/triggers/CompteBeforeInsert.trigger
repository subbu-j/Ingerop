/*
----------------------------------------------------------------------
-- - Name          : CompteBeforeInsertBeforeUpdate
-- - Author        : Paul BENARD - Bluetis
-- - Description   : Trigger for SObject Compte before Insert
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 10-OCT-2016   PBE    1.0      Initial version
----------------------------------------------------------------------
*/
trigger CompteBeforeInsert on Account (before insert) {
 System.Debug('Start of trigger CompteBeforeInsert');
     if(PAD.canTrigger('AP10')){
        AP10Compte.SetActivityTech(Trigger.new,null);
    }
    System.Debug('End of trigger CompteBeforeInsert');
}