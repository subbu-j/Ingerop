/*
----------------------------------------------------------------------
-- - Name          : ContactAfterInsert
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Trigger for SObject Contact after insert
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 17-JUN-2016   BTH    1.0      Initial version
-- 09-SEP-2016   PBE    1.1      PAD
----------------------------------------------------------------------
*/

trigger ContactAfterInsert on Contact (after insert) {
    System.debug('Start of trigger ContactAfterInsert');
    if(PAD.canTrigger('AP01')){
        AP01Contact.createContactShareOnAccount(Trigger.new);
    }
    System.debug('End of trigger ContactAfterInsert');
}