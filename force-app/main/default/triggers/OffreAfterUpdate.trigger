/*
----------------------------------------------------------------------
-- - Name          : ContactAfterInsert
-- - Author        : Anael CURATOLO - Bluetis
-- - Description   : Trigger for SObject Offre after Update
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 06-OCT-2016   ACU    1.0      Initial version
----------------------------------------------------------------------
*/
trigger OffreAfterUpdate on Offre__c (After Update) {
    System.Debug('Start of trigger OffreAfterUpdate');
    if(PAD.canTrigger('AP03')){
        AP03Offre.majOperation(Trigger.old, Trigger.new);
        AP09Repartition.createRepartition(Trigger.oldMap, Trigger.new);
    }
    System.debug('End of trigger OffreAfterUpdate');
}