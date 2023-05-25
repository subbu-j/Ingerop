/*
----------------------------------------------------------------------
-- - Name          : AP04Operation
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Methods for SObject Operation__c
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 17-JUN-2016   BTH    1.0      Initial version
-- 20-JUL-2018   NDI    2.0      Ouverture de droits
----------------------------------------------------------------------
*/
public with sharing class AP04Operation {
    public static void createOperationShareOnAccount(List<Operation__c> listOperation){
        System.debug('## AP04Operation.createOperationShareOnAccount START');
/*NDI20180720
        Set<Id> accountIds = new Set<Id>();
        List<Operation__Share> listOperationShare = new List<Operation__Share>();
        for(Operation__c operation : listOperation){
            accountIds.add(operation.Compte__c);
        }
        if(accountIds.size()>0){
            List<Membre_du_compte__c> listMembreDuCompte = DAL.getMembreDuCompteByAccountIds(accountIds);
            for(Operation__c operation : listOperation){
                for(Membre_du_compte__c membreDuCompte : listMembreDuCompte){
                    if(membreDuCompte.Compte__c == operation.Compte__c && membreDuCompte.Utilisateur__c != UserInfo.getUserId()){
                        Operation__Share os = new Operation__Share();
                        os.UserOrGroupId = membreDuCompte.Utilisateur__c;
                        os.ParentId = operation.Id;
                        os.AccessLevel = membreDuCompte.Acces_a_operation__c == 'Lecteur' ? 'Read' : 'Edit';
                        listOperationShare.add(os);
                    }
                }
            }
        }
        if(listOperationShare.size()>0){
            insert listOperationShare;
        }
*/
        System.debug('## AP04Operation.createOperationShareOnAccount END');
    }
    
}