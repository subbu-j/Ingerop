/*
----------------------------------------------------------------------
-- - Name          : CompteBeforeUpdate
-- - Author        : Paul BENARD - Bluetis
-- - Description   : Trigger for SObject Compte before Update
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 10-OCT-2016   PBE    1.0      Initial version
----------------------------------------------------------------------
*/
trigger CompteBeforeUpdate on Account (before update) {
 System.Debug('Start of trigger CompteBeforeUpdate');
     if(PAD.canTrigger('AP10')){
        AP10Compte.SetActivityTech(Trigger.new,Trigger.old);
    }
    System.Debug('End of trigger CompteBeforeUpdate');
}