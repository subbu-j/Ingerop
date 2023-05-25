/*
----------------------------------------------------------------------
-- - Name          : VeilleBeforeInsert
-- - Author        : Paul BENARD - Bluetis
-- - Description   : Trigger Information du compte before insert
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 02-NOV-2016   PBE    1.0      Initial version
----------------------------------------------------------------------
*/
trigger InforDuCompteBeforeInsert on Information_du_compte__c (before insert) {
	if(PAD.canTrigger('AP11')){
		AP11InfoDuCompte.CanAddInfo(Trigger.New);
    }
}