/*
----------------------------------------------------------------------
-- - Name          : InfoDuCompteAfterInsert
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Trigger Information du compte after insert
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 05-NOV-2016   PBE    1.0      Initial version
----------------------------------------------------------------------
*/
trigger InfoDuCompteAfterInsert on Information_du_compte__c (after insert) {
    if(PAD.canTrigger('AP11')){
        AP11InfoDuCompte.createOperationShare(Trigger.New);
    }
}