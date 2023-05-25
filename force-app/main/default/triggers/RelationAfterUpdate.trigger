/*
----------------------------------------------------------------------
-- - Name          : RelationAfterUpdate
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Trigger for SObject Relation__c before update
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

trigger RelationAfterUpdate on Relation__c (before update) {
    System.debug('Start of trigger RelationAfterUpdate');
    if(PAD.canTrigger('AP06')){
        AP06Relation.setUser(Trigger.new);
        for(Relation__c oldRelation : Trigger.old){
            for(Relation__c newRelation : Trigger.new){
                if(oldRelation.Id == newRelation.Id && oldRelation.Utilisateur__c != newRelation.Utilisateur__c){
                    newRelation.addError('Vous ne pouvez pas modifier une relation qui ne vous appartient pas.');
                }
            }
        }
    }
    System.debug('End of trigger RelationAfterUpdate');
}