/*
----------------------------------------------------------------------
-- - Name          : ScoreAfterUpdate
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Trigger for SObject Score__c after update
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 01-JUN-2016   BTH    1.0      Initial version
-- 01-SEP-2016   PBE    1.1      PAD
----------------------------------------------------------------------
*/

trigger ScoreAfterUpdate on Score__c (after update) {
    System.debug('Start of trigger ScoreAfterUpdate');
    if(PAD.canTrigger('AP05')){
        AP05Score.majScorePartenaire(Trigger.new);
    }
    System.debug('End of trigger ScoreAfterUpdate');
}