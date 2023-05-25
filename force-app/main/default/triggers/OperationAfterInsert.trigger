/*
----------------------------------------------------------------------
-- - Name          : OperationAfterInsert
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Trigger for SObject Operation__c after insert
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 11-OCT-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
trigger OperationAfterInsert on Operation__c (after insert) {
    if(PAD.canTrigger('AP04')){
		AP04Operation.createOperationShareOnAccount(Trigger.new);
	}
}