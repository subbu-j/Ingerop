/*
----------------------------------------------------------------------
-- - Name          : RelationBeforeInsert
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Trigger for SObject Relation__c before insert
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 28-JUN-2016   BTH    1.0      Initial version
-- 09-SEP-2016   PBE    1.1      PAD
----------------------------------------------------------------------
*/

trigger RelationBeforeInsert on Relation__c (before insert) {
    System.debug('Start of trigger RelationBeforeInsert');
    if(PAD.canTrigger('AP06')){
        AP06Relation.setUser(Trigger.new);
        for(Relation__c r : Trigger.new){
            if(!AP06Relation.canCreate(r)){
                r.addError('Vous avez déjà créé une relation pour ce contact.');
            }
        }
    }
    System.debug('End of trigger RelationBeforeInsert');
}