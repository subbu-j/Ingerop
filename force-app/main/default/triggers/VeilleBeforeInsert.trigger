/*
----------------------------------------------------------------------
-- - Name          : VeilleBeforeInsert
-- - Author        : Mélanie TEXEREAU - Bluetis
-- - Description   : Trigger Veille before insert
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 02-NOV-2016   MTE    1.0      Initial version
----------------------------------------------------------------------
*/
trigger VeilleBeforeInsert on Veille__c (before insert) {  
    if(PAD.canTrigger('AP08')){
    	AP08Veille.noDuplicateVeille(Trigger.new);
    }
}