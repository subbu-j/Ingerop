/*
----------------------------------------------------------------------
-- - Name          : ScoreAfterInsert
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Trigger for SObject Score__c after insert
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

trigger ScoreAfterInsert on Score__c (after insert) {
    System.debug('Start of trigger ScoreAfterInsert');
    if(PAD.canTrigger('AP05')){
        AP05Score.majScorePartenaire(Trigger.new);
    }
    System.debug('Start of trigger ScoreAfterInsert');
}