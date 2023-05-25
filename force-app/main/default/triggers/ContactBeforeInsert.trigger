/*
----------------------------------------------------------------------
-- - Name          : ContactBeforeInsert
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Trigger for SObject Contact before insert
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

trigger ContactBeforeInsert on Contact (before insert) {
    System.debug('Start of trigger ContactBeforeInsert');
    if(PAD.canTrigger('AP01')){
        Boolean userHasRight = AP01Contact.checkUserRights(trigger.new);
        if(!userHasRight){
            for(Contact contact : trigger.new){
                Contact.addError('Vous n\'êtes pas autorisé à créer de contacts sur ce compte.');
            }
        }
    }
    System.debug('End of trigger ContactBeforeInsert');
}