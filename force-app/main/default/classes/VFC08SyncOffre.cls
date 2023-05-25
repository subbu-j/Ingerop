/*
----------------------------------------------------------------------
-- - Name          : VFC08SyncOffre
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Extension for VFP08SyncOffre
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 01-AUG-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
public with sharing class VFC08SyncOffre {
    public Offre__c offre {get;set;}
    public Operation__c operation;

    public VFC08SyncOffre(ApexPages.StandardController controller) {
        offre = DAL.getOffreById(controller.getRecord().Id);
        if(offre.Operation__c != null){
            operation = DAL.getOperationById(offre.Operation__c);
        }
    }

    public void synchroniser(){
        if(operation != null){
            if(offre.Statut__c == 'Gagnée'){
                operation.Statut__c = 'Traitée';
            }else if(offre.Statut__c == 'Perdue'){
                operation.Statut__c = 'Perdue';
            }else if(offre.Statut__c == 'Sans suite'){
                operation.Statut__c = 'Sans suite';
            }
            update operation;
        }   
    }
}