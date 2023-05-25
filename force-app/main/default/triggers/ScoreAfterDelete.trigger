/*
----------------------------------------------------------------------
-- - Name          : ScoreAfterDelete
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Trigger for SObject Score__c after delete
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 01-JUN-2016   BTH    1.0      Initial version
-- 09-SEP-2016   PBE    1.1      PAD
----------------------------------------------------------------------
*/

trigger ScoreAfterDelete on Score__c (after delete){
    System.debug('Start of trigger ScoreAfterDelete');
    if(PAD.canTrigger('AP05')){
        AP05Score.majScorePartenaire(Trigger.old);
    }
    System.debug('Start of trigger ScoreAfterDelete');
}